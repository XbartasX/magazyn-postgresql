# System magazynowy w PostgreSQL

Projekt relacyjnej bazy danych do obsługi magazynu. Baza umożliwia przechowywanie informacji o produktach, kategoriach, dostawcach oraz dokumentach przyjęcia i wydania towaru.

## Zastosowane rozwiązania

- Relacje między tabelami z wykorzystaniem kluczy głównych i obcych.
- Ograniczenia integralności danych, w tym `CHECK` i `UNIQUE`.
- Funkcje napisane w PL/pgSQL do zatwierdzania przyjęć i wydań.
- Trigger tworzący początkowy stan magazynowy po dodaniu produktu.
- Kontrola dostępnej ilości towaru podczas zatwierdzania wydania.
- Widoki przedstawiające stany magazynowe i produkty wymagające uzupełnienia.
- Zapytania SQL do generowania raportów.

## Technologie

- PostgreSQL
- SQL i PL/pgSQL
- DBeaver

## Struktura projektu

```text
magazyn-postgresql/
├── README.md
├── docs/
│   └── diagram-erd.md
└── sql/
    ├── 01_schema.sql
    ├── 02_functions_triggers.sql
    ├── 03_sample_data.sql
    ├── 04_views.sql
    ├── 05_reports.sql
    └── 06_tests.sql
```

## Struktura bazy danych

Baza zawiera osiem tabel:

| Tabela | Przeznaczenie |
|---|---|
| `kategorie` | Kategorie produktów |
| `dostawcy` | Dane dostawców |
| `produkty` | Informacje o produktach |
| `stany_magazynowe` | Aktualne ilości produktów |
| `dokumenty_przyjecia` | Dokumenty przyjęcia towaru |
| `pozycje_przyjecia` | Produkty ujęte w przyjęciach |
| `dokumenty_wydania` | Dokumenty wydania towaru |
| `pozycje_wydania` | Produkty ujęte w wydaniach |

Dodatkowo wykorzystano dwa widoki, trzy funkcje, trigger oraz indeksy.

## Uruchomienie

Do uruchomienia projektu potrzebny jest PostgreSQL i program umożliwiający wykonywanie zapytań SQL, np. DBeaver.

Skrypty należy wykonać w następującej kolejności:

1. `01_schema.sql` tworzy schemat, tabele i relacje.
2. `02_functions_triggers.sql` tworzy funkcje i trigger.
3. `03_sample_data.sql` dodaje przykładowe dane i zatwierdza dokumenty.
4. `04_views.sql` tworzy widoki.
5. `05_reports.sql` zawiera zapytania raportowe.
6. `06_tests.sql` zawiera zapytania sprawdzające poprawność danych.

Skrypty inicjalizacyjne należy uruchomić na pustej bazie danych. Nie należy wykonywać ich ponownie na bazie zawierającej już te same tabele i dane.

## Przykładowe zapytania

Aktualne stany magazynowe:

```sql
SELECT *
FROM magazyn_demo.v_stan_magazynowy;
```

Produkty wymagające uzupełnienia:

```sql
SELECT *
FROM magazyn_demo.v_produkty_do_uzupelnienia;
```

## Diagram ERD

Diagram relacji między tabelami znajduje się w pliku [`docs/diagram-erd.md`](docs/diagram-erd.md).

## Cel projektu

Celem projektu było zaprojektowanie relacyjnej bazy danych oraz wykorzystanie w praktyce kluczy głównych i obcych, ograniczeń integralności, funkcji, triggerów, widoków i zapytań raportowych.
