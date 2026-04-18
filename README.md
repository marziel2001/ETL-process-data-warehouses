# ETL Process – Driving School Data Warehouse

A SQL-based ETL (Extract, Transform, Load) project that migrates data from an OLTP database of a driving school (*Szkoła Jazdy*) into a data warehouse optimised for analytics.

---

## Technology

| Area | Tool / Technology |
|------|------------------|
| Database engine | Microsoft SQL Server |
| Query language | T-SQL |
| IDE | SQL Server Management Studio (SSMS) |
| Data ingestion | `BULK INSERT` from CSV files |

---

## Architecture

The project follows a **two-database** design:

### 1. `szkolaJazdyBD` – OLTP Source Database
Normalised relational database that stores day-to-day operational data of the driving school.

**Tables:**
- `Student` – student personal data (PESEL as business key)
- `Employee` – instructor / staff data
- `Bill` – invoice records (issue & payment timestamps)
- `Course` – course editions with pricing
- `Car` – vehicles used for lessons (VIN as business key)
- `StudentCourse` – enrolment bridge linking students, courses, bills and cars
- `Lecture` – scheduled theory lectures
- `LectureAttendanceList` – attendance records per student per lecture
- `DrivingLesson` – practical driving sessions with instructor, duration and billing

### 2. `szkolaJazdyHD` – Data Warehouse (Star/Snowflake Schema)
Denormalised warehouse optimised for reporting and analytics.

**Dimension tables:**
- `Date` – full date dimension (1980-01-01 → 2025-12-31) with day, month, year and holiday flag
- `Student` – SCD-aware student dimension (`Actual` flag)
- `Employee` – instructor dimension
- `Course` – course edition dimension linked to `Date`
- `Car` – vehicle dimension with `Actual` flag

**Fact tables:**
- `StudentCourse` – measures per enrolment: course price, extra driving hours, theory score, practice attempts, lecture presence percentage
- `DrivingLesson` – measures per lesson: duration, unit price, total cost, bill dates
- `LectureAttendance` – per-lecture attendance fact
- `TheoryAttempt` – theory exam attempts with result and score
- `PracticeAttempt` – practical exam attempts with pass/fail result

---

## ETL Pipeline

Data flows from the OLTP source to the warehouse through a sequence of numbered SQL scripts.

```
CSV files
   │
   ▼
szkolaJazdyBD  ──[ETL scripts]──►  szkolaJazdyHD
 (OLTP)                              (Data Warehouse)
```

Each ETL script uses a **staging view** to transform and map business keys, then performs a `MERGE` statement to perform an upsert (insert-if-not-matched) into the target warehouse table.

---

## Script Execution Order

Scripts are divided into two runs (two time points / data batches – `t1` and `t2`):

### Time Point 1 (`t1`)
| Step | Script | Description |
|------|--------|-------------|
| 1 | `s01_Create_SzkolaJazdy.sql` | Create OLTP source database and all tables |
| 2 | `s02_Create_Hurtowni_SzkolaJazdy.sql` | Create data warehouse and all tables |
| 3 | `s03_Bulk_Insert.sql` | Load raw CSV data into the OLTP DB and exam staging table |
| 4 | `s04_ETL_load_date.sql` | Populate the `Date` dimension |
| 5 | `s05_ETL_load_course.sql` | Load `Course` dimension |
| 6 | `s06_ETL_load_car.sql` | Load `Car` dimension |
| 7 | `s07_ETL_load_student.sql` | Load `Student` dimension |
| 8 | `s08_ETL_load_employee.sql` | Load `Employee` dimension |
| 9 | `s09_ETL_load_studentCourse.sql` | Load `StudentCourse` fact table |
| 10 | `s10_ETL_load_drivingLesson.sql` | Load `DrivingLesson` fact table |
| 11 | `s11_ETL_load_lectureAttendance.sql` | Load `LectureAttendance` fact table |
| 12 | `s12_ETL_load_exams.sql` | Load `TheoryAttempt` and `PracticeAttempt` fact tables |

### Time Point 2 (`t2` – incremental load)
| Step | Script | Description |
|------|--------|-------------|
| 1 | `s01_Create_SzkolaJazdy.sql` | Re-create OLTP DB with fresh schema |
| 2 | `s13_BulkInsertT2.sql` | Load second batch of CSV data |
| 3 | `s05` – `s12` | Re-run all ETL dimension and fact loads (incremental via `MERGE`) |

---

## How to Use

### Prerequisites
- Microsoft SQL Server (any recent edition)
- SQL Server Management Studio (SSMS)
- CSV data files placed at the paths referenced in `s03_Bulk_Insert.sql` and `s13_BulkInsertT2.sql`

### Steps

1. **Update CSV paths** – open `s03_Bulk_Insert.sql` and `s13_BulkInsertT2.sql` and replace the hardcoded `C:\Users\Marcel\...` paths with the location of your own CSV files.

2. **Run Time Point 1 scripts** in SSMS in order (s01 → s12):
   ```
   s01 → s02 → s03 → s04 → s05 → s06 → s07 → s08 → s09 → s10 → s11 → s12
   ```

3. **Run Time Point 2 scripts** to simulate an incremental data load:
   ```
   s01 → s13 → s05 → s06 → s07 → s08 → s09 → s10 → s11 → s12
   ```

4. **Query the warehouse** – use `select.sql` or write your own analytical queries against `szkolaJazdyHD`.

> **Note:** Each script switches database context internally (`USE szkolaJazdyBD` / `USE szkolaJazdyHD`), so scripts can be run individually as long as both databases exist.

---

## Project Structure

```
├── order_of_execution.txt          # Short execution order reference
├── s01_Create_SzkolaJazdy.sql      # OLTP DB schema
├── s02_Create_Hurtowni_SzkolaJazdy.sql  # Data warehouse schema
├── s03_Bulk_Insert.sql             # T1 CSV data ingestion
├── s04_ETL_load_date.sql           # Date dimension ETL
├── s05_ETL_load_course.sql         # Course dimension ETL
├── s06_ETL_load_car.sql            # Car dimension ETL
├── s07_ETL_load_student.sql        # Student dimension ETL
├── s08_ETL_load_employee.sql       # Employee dimension ETL
├── s09_ETL_load_studentCourse.sql  # StudentCourse fact ETL
├── s10_ETL_load_drivingLesson.sql  # DrivingLesson fact ETL
├── s11_ETL_load_lectureAttendance.sql  # LectureAttendance fact ETL
├── s12_ETL_load_exams.sql          # Theory & Practice exam facts ETL
├── s13_BulkInsertT2.sql            # T2 CSV data ingestion (incremental)
└── select.sql                      # Sample verification queries
```
