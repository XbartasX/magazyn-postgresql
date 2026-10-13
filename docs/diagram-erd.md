# Diagram ERD — system magazynowy

Diagram przedstawia strukturę relacyjnej bazy danych systemu magazynowego w PostgreSQL. Pokazuje tabele, klucze główne (PK), klucze obce (FK) oraz najważniejsze relacje.

```mermaid
erDiagram
    KATEGORIE ||--o{ PRODUKTY : "grupuje"
    DOSTAWCY ||--o{ DOKUMENTY_PRZYJECIA : "dostarcza"
    PRODUKTY ||--o| STANY_MAGAZYNOWE : "ma stan"
    DOKUMENTY_PRZYJECIA ||--|{ POZYCJE_PRZYJECIA : "zawiera"
    PRODUKTY ||--o{ POZYCJE_PRZYJECIA : "wystepuje"
    DOKUMENTY_WYDANIA ||--|{ POZYCJE_WYDANIA : "zawiera"
    PRODUKTY ||--o{ POZYCJE_WYDANIA : "wystepuje"

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

**Oznaczenia:**
- `PK` — klucz główny, identyfikuje rekord.
- `FK` — klucz obcy, łączy rekord z inną tabelą.
- `UK` — wartość unikalna, która nie może się powtarzać.
