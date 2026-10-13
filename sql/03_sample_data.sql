
-- Przykładowe dane do demonstracji systemu magazynowego.
-- Skrypt przeznaczony do uruchomienia po utworzeniu tabel.

-- Kategorie produktów.
INSERT INTO magazyn_demo.kategorie (nazwa)
VALUES
    ('Komputery'),
    ('Akcesoria'),
    ('Sieci');

-- Dostawcy sprzętu komputerowego.
INSERT INTO magazyn_demo.dostawcy (nazwa, email, telefon)
VALUES
    ('TechSupply', 'kontakt@techsupply.example', '500100200'),
    ('Komputery Plus', 'biuro@komputeryplus.example', '500200300');

-- Produkty dostępne w magazynie.
INSERT INTO magazyn_demo.produkty
    (kategoria_id, sku, nazwa, cena_netto, stan_minimalny)
VALUES
    (
        (SELECT kategoria_id
         FROM magazyn_demo.kategorie
         WHERE nazwa = 'Komputery'),
        'PC-001',
        'Mini komputer biurowy',
        1800.00,
        3
    ),
    (
        (SELECT kategoria_id
         FROM magazyn_demo.kategorie
         WHERE nazwa = 'Akcesoria'),
        'ACC-001',
        'Klawiatura USB',
        70.00,
        10
    ),
    (
        (SELECT kategoria_id
         FROM magazyn_demo.kategorie
         WHERE nazwa = 'Sieci'),
        'NET-001',
        'Switch 8-portowy',
        220.00,
        4
    );

-- Przykładowe przyjęcie towaru od dostawcy.
-- Dokument pozostaje roboczy, aby można było przetestować
-- funkcję zatwierdzającą przyjęcie.
INSERT INTO magazyn_demo.dokumenty_przyjecia
    (dostawca_id, status)
VALUES
    (
        (SELECT dostawca_id
         FROM magazyn_demo.dostawcy
         WHERE email = 'kontakt@techsupply.example'),
        'roboczy'
    );

INSERT INTO magazyn_demo.pozycje_przyjecia
    (przyjecie_id, produkt_id, ilosc, cena_zakupu)
VALUES
    (
        (SELECT przyjecie_id
         FROM magazyn_demo.dokumenty_przyjecia
         ORDER BY przyjecie_id DESC
         LIMIT 1),
        (SELECT produkt_id FROM magazyn_demo.produkty WHERE sku = 'PC-001'),
        8,
        1500.00
    ),
    (
        (SELECT przyjecie_id
         FROM magazyn_demo.dokumenty_przyjecia
         ORDER BY przyjecie_id DESC
         LIMIT 1),
        (SELECT produkt_id FROM magazyn_demo.produkty WHERE sku = 'ACC-001'),
        20,
        45.00
    ),
    (
        (SELECT przyjecie_id
         FROM magazyn_demo.dokumenty_przyjecia
         ORDER BY przyjecie_id DESC
         LIMIT 1),
        (SELECT produkt_id FROM magazyn_demo.produkty WHERE sku = 'NET-001'),
        6,
        160.00
    );

-- Przykładowe wydanie towaru.
-- Dokument pozostaje roboczy do testowania zatwierdzania wydań.
INSERT INTO magazyn_demo.dokumenty_wydania
    (odbiorca, status)
VALUES
    ('Dział IT', 'roboczy');

INSERT INTO magazyn_demo.pozycje_wydania
    (wydanie_id, produkt_id, ilosc)
VALUES
    (
        (SELECT wydanie_id
         FROM magazyn_demo.dokumenty_wydania
         ORDER BY wydanie_id DESC
         LIMIT 1),
        (SELECT produkt_id FROM magazyn_demo.produkty WHERE sku = 'PC-001'),
        2
    ),
    (
        (SELECT wydanie_id
         FROM magazyn_demo.dokumenty_wydania
         ORDER BY wydanie_id DESC
         LIMIT 1),
        (SELECT produkt_id FROM magazyn_demo.produkty WHERE sku = 'ACC-001'),
        5
    );


-- Zatwierdzenie przykładowych dokumentów aktualizuje stany magazynowe.
SELECT magazyn_demo.zatwierdz_przyjecie(
    (
        SELECT przyjecie_id
        FROM magazyn_demo.dokumenty_przyjecia
        WHERE status = 'roboczy'
        ORDER BY przyjecie_id DESC
        LIMIT 1
    )
);

SELECT magazyn_demo.zatwierdz_wydanie(
    (
        SELECT wydanie_id
        FROM magazyn_demo.dokumenty_wydania
        WHERE status = 'roboczy'
        ORDER BY wydanie_id DESC
        LIMIT 1
    )
);
