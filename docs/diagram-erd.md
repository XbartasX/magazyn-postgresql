# Diagram ERD

```mermaid
erDiagram
    KATEGORIE ||--o{ PRODUKTY : grupuje
    DOSTAWCY ||--o{ DOKUMENTY_PRZYJECIA : dostarcza
    PRODUKTY ||--o| STANY_MAGAZYNOWE : posiada
    DOKUMENTY_PRZYJECIA ||--o{ POZYCJE_PRZYJECIA : zawiera
    PRODUKTY ||--o{ POZYCJE_PRZYJECIA : wystepuje
    DOKUMENTY_WYDANIA ||--o{ POZYCJE_WYDANIA : zawiera
    PRODUKTY ||--o{ POZYCJE_WYDANIA : wystepuje

    KATEGORIE {
        bigint kategoria_id PK
        varchar nazwa UK
    }

    DOSTAWCY {
        bigint dostawca_id PK
        varchar nazwa
        varchar email UK
        varchar telefon
    }

    PRODUKTY {
        bigint produkt_id PK
        bigint kategoria_id FK
        varchar sku UK
        varchar nazwa
        numeric cena_netto
        integer stan_minimalny
        boolean aktywny
    }

    STANY_MAGAZYNOWE {
        bigint produkt_id PK, FK
        integer ilosc
        timestamptz zaktualizowano
    }

    DOKUMENTY_PRZYJECIA {
        bigint przyjecie_id PK
        bigint dostawca_id FK
        timestamptz data_przyjecia
        varchar status
    }

    POZYCJE_PRZYJECIA {
        bigint przyjecie_id PK, FK
        bigint produkt_id PK, FK
        integer ilosc
        numeric cena_zakupu
    }

    DOKUMENTY_WYDANIA {
        bigint wydanie_id PK
        varchar odbiorca
        timestamptz data_wydania
        varchar status
    }

    POZYCJE_WYDANIA {
        bigint wydanie_id PK, FK
        bigint produkt_id PK, FK
        integer ilosc
    }
```

**PK** – klucz główny, **FK** – klucz obcy, **UK** – wartość unikalna.
