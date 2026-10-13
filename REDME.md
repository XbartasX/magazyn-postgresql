
# System magazynowy — PostgreSQL

Projekt relacyjnej bazy danych do obsługi podstawowych procesów magazynowych. Obejmuje ewidencję produktów, dostawców, przyjęć i wydań towaru oraz kontrolę stanów magazynowych.

## Funkcjonalności

- Zarządzanie produktami i kategoriami.
- Ewidencja dostawców.
- Rejestrowanie dokumentów przyjęcia i wydania.
- Automatyczne tworzenie początkowego stanu magazynowego dla nowego produktu.
- Aktualizacja stanów po zatwierdzeniu dokumentów.
- Kontrola dostępnej ilości towaru przed zatwierdzeniem wydania.
- Wykrywanie produktów wymagających uzupełnienia.
- Raportowanie wartości zapasów i historii dokumentów.

## Technologie

- PostgreSQL
- SQL
- PL/pgSQL
- DBeaver
- Git i GitHub

## Struktura projektu

```text
magazyn-postgresql/
├── README.md
├── sql/
│   ├── 01_schema.sql
│   ├── 02_functions_triggers.sql
│   ├── 03_sample_data.sql
│   ├── 04_views.sql
│   ├── 05_reports.sql
│   └── 06_tests.sql
└── docs/
    └── diagram-erd.md
```

## Struktura bazy danych

Baza składa się z ośmiu tabel:

- `kategorie` — kategorie produktów.
- `dostawcy` — dane dostawców.
- `produkty` — dane produktów i ich ceny.
- `stany_magazynowe` — aktualna ilość towaru.
- `dokumenty_przyjecia` — dokumenty dostaw.
- `pozycje_przyjecia` — produkty ujęte w dostawach.
- `dokumenty_wydania` — dokumenty wydań.
- `pozycje_wydania` — produkty ujęte w wydaniach.

Dodatkowo projekt wykorzystuje dwa widoki, funkcje PL/pgSQL, trigger oraz indeksy i ograniczenia integralności danych.

## Uruchomienie projektu

Utwórz pustą bazę danych PostgreSQL i otwórz połączenie z nią w DBeaverze.

Wykonuj skrypty w następującej kolejności:

1. `01_schema.sql` — utworzenie schematu, tabel i relacji.
2. `02_functions_triggers.sql` — utworzenie funkcji i triggera.
3. `03_sample_data.sql` — dodanie i zatwierdzenie przykładowych dokumentów.
4. `04_views.sql` — utworzenie widoków.
5. `05_reports.sql` — przykładowe zapytania raportowe.

Każdy skrypt uruchamiaj w edytorze SQL połączonym z nową bazą danych. Skrypt raportowy zawiera kilka zapytań, które można wykonywać pojedynczo.

**Uwaga:** skrypty inicjalizacyjne są przeznaczone do uruchomienia na pustej bazie. Nie uruchamiaj ich ponownie na bazie zawierającej już te same tabele i przykładowe dane.

## Przykładowe zapytania

Aktualny stan magazynu:

```sql
SELECT *
FROM magazyn_demo.v_stan_magazynowy;
```

Produkty wymagające uzupełnienia:

```sql
SELECT *
FROM magazyn_demo.v_produkty_do_uzupelnienia;
```

## Cel projektu

Celem projektu jest praktyczne wykorzystanie relacyjnego modelowania danych, kluczy głównych i obcych, ograniczeń integralności, indeksów, widoków, funkcji oraz triggerów w PostgreSQL.
