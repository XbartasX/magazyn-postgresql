
-- Funkcje i trigger odpowiedzialne za aktualizację stanów magazynowych.

-- Każdy nowy produkt otrzymuje początkowy stan równy zero.
CREATE OR REPLACE FUNCTION magazyn_demo.utworz_stan_poczatkowy()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO magazyn_demo.stany_magazynowe (
        produkt_id,
        ilosc
    )
    VALUES (
        NEW.produkt_id,
        0
    );

    RETURN NEW;
END;
$function$;

CREATE TRIGGER trg_produkt_stan
AFTER INSERT ON magazyn_demo.produkty
FOR EACH ROW
EXECUTE FUNCTION magazyn_demo.utworz_stan_poczatkowy();


-- Zatwierdzenie przyjęcia zwiększa stany magazynowe
-- zgodnie z ilościami zapisanymi w dokumencie.
CREATE OR REPLACE FUNCTION magazyn_demo.zatwierdz_przyjecie(
    p_przyjecie_id BIGINT
)
RETURNS VOID
LANGUAGE plpgsql
AS $function$
DECLARE
    v_status VARCHAR(20);
BEGIN
    SELECT status
    INTO v_status
    FROM magazyn_demo.dokumenty_przyjecia
    WHERE przyjecie_id = p_przyjecie_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'Nie znaleziono przyjęcia o ID %',
            p_przyjecie_id;
    END IF;

    IF v_status = 'zatwierdzony' THEN
        RAISE EXCEPTION
            'Przyjęcie % jest już zatwierdzone',
            p_przyjecie_id;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM magazyn_demo.pozycje_przyjecia
        WHERE przyjecie_id = p_przyjecie_id
    ) THEN
        RAISE EXCEPTION
            'Nie można zatwierdzić pustego przyjęcia';
    END IF;

    UPDATE magazyn_demo.stany_magazynowe AS s
    SET
        ilosc = s.ilosc + p.ilosc,
        zaktualizowano = CURRENT_TIMESTAMP
    FROM magazyn_demo.pozycje_przyjecia AS p
    WHERE p.przyjecie_id = p_przyjecie_id
      AND p.produkt_id = s.produkt_id;

    UPDATE magazyn_demo.dokumenty_przyjecia
    SET status = 'zatwierdzony'
    WHERE przyjecie_id = p_przyjecie_id;
END;
$function$;


-- Zatwierdzenie wydania sprawdza dostępność towaru,
-- a następnie zmniejsza stany magazynowe.
CREATE OR REPLACE FUNCTION magazyn_demo.zatwierdz_wydanie(
    p_wydanie_id BIGINT
)
RETURNS VOID
LANGUAGE plpgsql
AS $function$
DECLARE
    v_status VARCHAR(20);
    v_pozycja RECORD;
    v_stan INTEGER;
BEGIN
    SELECT status
    INTO v_status
    FROM magazyn_demo.dokumenty_wydania
    WHERE wydanie_id = p_wydanie_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'Nie znaleziono wydania o ID %',
            p_wydanie_id;
    END IF;

    IF v_status = 'zatwierdzony' THEN
        RAISE EXCEPTION
            'Wydanie % jest już zatwierdzone',
            p_wydanie_id;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM magazyn_demo.pozycje_wydania
        WHERE wydanie_id = p_wydanie_id
    ) THEN
        RAISE EXCEPTION
            'Nie można zatwierdzić pustego wydania';
    END IF;

    -- Najpierw sprawdzamy dostępność wszystkich pozycji.
    FOR v_pozycja IN
        SELECT produkt_id, ilosc
        FROM magazyn_demo.pozycje_wydania
        WHERE wydanie_id = p_wydanie_id
        ORDER BY produkt_id
    LOOP
        SELECT ilosc
        INTO v_stan
        FROM magazyn_demo.stany_magazynowe
        WHERE produkt_id = v_pozycja.produkt_id
        FOR UPDATE;

        IF v_stan IS NULL OR v_stan < v_pozycja.ilosc THEN
            RAISE EXCEPTION
                'Brak towaru: produkt %, stan %, wymagane %',
                v_pozycja.produkt_id,
                COALESCE(v_stan, 0),
                v_pozycja.ilosc;
        END IF;
    END LOOP;

    -- Stan zmieniamy dopiero po sprawdzeniu wszystkich pozycji.
    UPDATE magazyn_demo.stany_magazynowe AS s
    SET
        ilosc = s.ilosc - p.ilosc,
        zaktualizowano = CURRENT_TIMESTAMP
    FROM magazyn_demo.pozycje_wydania AS p
    WHERE p.wydanie_id = p_wydanie_id
      AND p.produkt_id = s.produkt_id;

    UPDATE magazyn_demo.dokumenty_wydania
    SET status = 'zatwierdzony'
    WHERE wydanie_id = p_wydanie_id;
END;
$function$;
