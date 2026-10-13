
-- Raporty SQL wspierające kontrolę stanów i obrotu magazynowego.

-- 1. Aktualny stan magazynu wraz z wartością zapasów.
SELECT
    sku,
    produkt,
    kategoria,
    ilosc,
    stan_minimalny,
    wartosc_netto
FROM magazyn_demo.v_stan_magazynowy
ORDER BY kategoria, produkt;


-- 2. Produkty, które wymagają uzupełnienia.
SELECT
    sku,
    produkt,
    ilosc,
    stan_minimalny
FROM magazyn_demo.v_produkty_do_uzupelnienia
ORDER BY ilosc ASC;


-- 3. Łączna wartość zapasów według kategorii.
SELECT
    kategoria,
    COUNT(*) AS liczba_produktow,
    SUM(ilosc) AS liczba_sztuk,
    SUM(wartosc_netto) AS wartosc_zapasow_netto
FROM magazyn_demo.v_stan_magazynowy
GROUP BY kategoria
ORDER BY wartosc_zapasow_netto DESC;


-- 4. Historia przyjęć wraz z nazwą dostawcy.
SELECT
    dp.przyjecie_id,
    dp.data_przyjecia,
    d.nazwa AS dostawca,
    dp.status,
    COUNT(pp.produkt_id) AS liczba_pozycji,
    COALESCE(SUM(pp.ilosc * pp.cena_zakupu), 0) AS wartosc_zakupu
FROM magazyn_demo.dokumenty_przyjecia AS dp
JOIN magazyn_demo.dostawcy AS d
    ON d.dostawca_id = dp.dostawca_id
LEFT JOIN magazyn_demo.pozycje_przyjecia AS pp
    ON pp.przyjecie_id = dp.przyjecie_id
GROUP BY
    dp.przyjecie_id,
    dp.data_przyjecia,
    d.nazwa,
    dp.status
ORDER BY dp.data_przyjecia DESC;


-- 5. Historia wydań wraz z liczbą wydanych sztuk.
SELECT
    dw.wydanie_id,
    dw.data_wydania,
    dw.odbiorca,
    dw.status,
    COUNT(pw.produkt_id) AS liczba_pozycji,
    COALESCE(SUM(pw.ilosc), 0) AS liczba_wydanych_sztuk
FROM magazyn_demo.dokumenty_wydania AS dw
LEFT JOIN magazyn_demo.pozycje_wydania AS pw
    ON pw.wydanie_id = dw.wydanie_id
GROUP BY
    dw.wydanie_id,
    dw.data_wydania,
    dw.odbiorca,
    dw.status
ORDER BY dw.data_wydania DESC;


-- 6. Produkty z największą liczbą sztuk w magazynie.
SELECT
    sku,
    produkt,
    ilosc
FROM magazyn_demo.v_stan_magazynowy
ORDER BY ilosc DESC, produkt
LIMIT 10;
