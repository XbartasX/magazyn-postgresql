
-- Widoki ułatwiają analizę stanów magazynowych i wartości towarów.

-- Zestawienie produktów wraz z kategorią, stanem i wartością zapasu.
CREATE OR REPLACE VIEW magazyn_demo.v_stan_magazynowy AS
SELECT
    p.produkt_id,
    p.sku,
    p.nazwa AS produkt,
    k.nazwa AS kategoria,
    p.cena_netto,
    s.ilosc,
    p.stan_minimalny,
    s.ilosc <= p.stan_minimalny AS wymaga_uzupelnienia,
    ROUND(p.cena_netto * s.ilosc, 2) AS wartosc_netto
FROM magazyn_demo.produkty AS p
JOIN magazyn_demo.kategorie AS k
    ON k.kategoria_id = p.kategoria_id
JOIN magazyn_demo.stany_magazynowe AS s
    ON s.produkt_id = p.produkt_id
WHERE p.aktywny = TRUE;


-- Lista aktywnych produktów, których stan osiągnął
-- lub spadł poniżej ustalonego minimum.
CREATE OR REPLACE VIEW magazyn_demo.v_produkty_do_uzupelnienia AS
SELECT
    produkt_id,
    sku,
    produkt,
    kategoria,
    cena_netto,
    ilosc,
    stan_minimalny,
    wartosc_netto
FROM magazyn_demo.v_stan_magazynowy
WHERE wymaga_uzupelnienia = TRUE;
