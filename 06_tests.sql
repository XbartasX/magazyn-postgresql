-- Testy kontrolne systemu magazynowego.
-- Skrypt zawiera zapytania sprawdzające poprawność działania bazy.
-- Uruchamiaj zapytania pojedynczo, aby łatwiej analizować wyniki.

-- TEST 1: Sprawdzenie aktualnych stanów magazynowych.
SELECT
    sku,
    produkt,
    ilosc,
    stan_minimalny,
    wymaga_uzupelnienia
FROM magazyn_demo.v_stan_magazynowy
ORDER BY sku;


-- TEST 2: Sprawdzenie, czy każdy produkt ma utworzony stan magazynowy.
-- Oczekiwany wynik: 0.
SELECT COUNT(*) AS produkty_bez_stanu
FROM magazyn_demo.produkty AS p
LEFT JOIN magazyn_demo.stany_magazynowe AS s
    ON s.produkt_id = p.produkt_id
WHERE s.produkt_id IS NULL;


-- TEST 3: Sprawdzenie, czy nie istnieją ujemne stany magazynowe.
-- Oczekiwany wynik: 0.
SELECT COUNT(*) AS ujemne_stany
FROM magazyn_demo.stany_magazynowe
WHERE ilosc < 0;


-- TEST 4: Sprawdzenie dokumentów przyjęcia i ich statusów.
SELECT
    dp.przyjecie_id,
    d.nazwa AS dostawca,
    dp.data_przyjecia,
    dp.status
FROM magazyn_demo.dokumenty_przyjecia AS dp
JOIN magazyn_demo.dostawcy AS d
    ON d.dostawca_id = dp.dostawca_id
ORDER BY dp.przyjecie_id;


-- TEST 5: Sprawdzenie dokumentów wydania i ich statusów.
SELECT
    wydanie_id,
    odbiorca,
    data_wydania,
    status
FROM magazyn_demo.dokumenty_wydania
ORDER BY wydanie_id;


-- TEST 6: Sprawdzenie, czy klucze obce pozycji przyjęcia są poprawne.
-- Oczekiwany wynik: 0.
SELECT COUNT(*) AS niepoprawne_pozycje_przyjecia
FROM magazyn_demo.pozycje_przyjecia AS pp
LEFT JOIN magazyn_demo.dokumenty_przyjecia AS dp
    ON dp.przyjecie_id = pp.przyjecie_id
LEFT JOIN magazyn_demo.produkty AS p
    ON p.produkt_id = pp.produkt_id
WHERE dp.przyjecie_id IS NULL
   OR p.produkt_id IS NULL;


-- TEST 7: Sprawdzenie, czy klucze obce pozycji wydania są poprawne.
-- Oczekiwany wynik: 0.
SELECT COUNT(*) AS niepoprawne_pozycje_wydania
FROM magazyn_demo.pozycje_wydania AS pw
LEFT JOIN magazyn_demo.dokumenty_wydania AS dw
    ON dw.wydanie_id = pw.wydanie_id
LEFT JOIN magazyn_demo.produkty AS p
    ON p.produkt_id = pw.produkt_id
WHERE dw.wydanie_id IS NULL
   OR p.produkt_id IS NULL;
