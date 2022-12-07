1. Utwórz nowy schemat dml_exercises

CREATE SCHEMA IF NOT EXISTS dml_exercises;

2. Utwórz nową tabelę sales w schemacie dml_exercises według opisu:

CREATE TABLE IF NOT EXISTS dml_exercises.sales(
id SERIAL PRIMARY KEY,
sales_date TIMESTAMP NOT NULL,
sales_amount NUMERIC (38,2) CONSTRAINT sales_less_1k CHECK (sales_amount<=1000),
sales_qty NUMERIC (10,2),
added_by TEXT DEFAULT 'admin');

SELECT * FROM dml_exercises.sales;

3. Dodaj do tabeli kilka wierszy korzystając ze składni INSERT INTO

INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty, added_by) 
VALUES ('2022-01-05 12:11:55', 215, 100, NULL),
		('2022-02-02 08:11:22', 300, 200, null),
		('2022-03-04 09:12:33', 600, 500, null),
		('2022-05-05 11:12:44', 1000,700, NULL);
		
	ODP3.3 Po wprowadzeniu wartości większej niż 1000, wyrzuca BŁĄD: nowy rekord dla relacji "sales" narusza ograniczenie sprawdzające "sales_less_1k"
  Detail: Niepoprawne ograniczenia wiersza (4, 2022-05-05 11:12:44, 1100.00, 700.00, null).
  
  INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
VALUES ('2019/11/20', 101, 50, NULL);

ODP4. Po wstawieniu powyższego rekordu w atrybucie sales_date wstawiona zostaje 2019-11-20 00:00:00.000

INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
VALUES ('2020/04/04', 101, 50, NULL);

ODP5. Po wstawieniu powyższego rekordu w atrybucie sales_date wstawiona zostaje 2020-04-04 00:00:00.000

6. Dodaj do tabeli sales wstaw wiersze korzystając z poniższego polecenia

INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty,added_by)
SELECT NOW() + (random() * (interval '90 days')) + '30 days',
random() * 500 + 1,
random() * 100 + 1,
NULL
FROM generate_series(1, 20000) s(i);

7.Korzystając ze składni UPDATE, zaktualizuj atrybut added_by, wpisując mu wartość 'sales_over_200', gdy wartość sprzedaży (sales_amount jest większa lub równa 200)

UPDATE dml_exercises.sales
   SET added_by = 'sales_over_200'
 WHERE sales_amount >= 200;

SELECT * FROM dml_exercises.sales;


8.
DELETE FROM dml_exercises.sales 
      WHERE added_by = NULL; 

DELETE FROM dml_exercises.sales 
      WHERE added_by IS NULL;
     
Różnica między zapisem: added_by = NULL u mnie nie usunął żądanych rekordów, a added_by IS NULL usunął żądane rekordy. Innych różnic nie spostrzegłem.

9. Wyczyść wszystkie dane z tabeli sales i zrestartuj sekwencje


TRUNCATE dml_exercises.sales RESTART IDENTITY;

10. DODATKOWE ponownie wstaw do tabeli sales wiersze jak w zadaniu 6.

INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty,added_by)
SELECT NOW() + (random() * (interval '90 days')) + '30 days',
random() * 500 + 1,
random() * 100 + 1,
NULL
FROM generate_series(1, 20000) s(i);

Używając wiersza poleceń tworzę kopię zapasową tabeli w katalogu Sales_kopia_zapasowa

pg_dump --host localhost ^
        --port 5432 ^
        --username postgres ^
        --format d ^
        --file "C:\Users\user\OneDrive\Pulpit\Sales_kopia_zapasowa" ^
        --table dml_exercises.sales ^
        postgres

Usuwam tabelę ze schematu.        
        
DROP TABLE IF EXISTS dml_exercises.sales;

Odtwarzam tabelę z kopii zapasowej.

pg_restore --host localhost ^
           --port 5432 ^
           --username postgres ^
           --dbname postgres ^
           --clean ^
           "C:\Users\user\OneDrive\Pulpit\Sales_kopia_zapasowa"    
