I promise to meet the deadline and will take disciplinary action if this requirement is not met.
# Fitness Club Membership Management

A training database project for managing a fitness club.
Implemented using PostgreSQL.

## Project Structure

```text
fitness-club-db-project/
├── README.md
├── sql/
│   ├── schema_creation.sql
│   ├── sample_data.sql
│   ├── basic_queries.sql
│   ├── advanced_queries.sql
│   ├── transactions_and_indexes.sql
│   └── views_and_functions.sql
├── docs/
│   ├── er_diagram.png
│   └── project_report.pdf
└── backup/
    ├── backup_instructions.md
    └── example_backup_command.txt
```

## Subject area

The system is designed to store and process fitness club data:

- Club members
- Rates and memberships
- Trainers
- Classes and schedules
- Attendances
- Payments
- Locker assignments
- Analytical queries, views, and functions

## Core entities

- `member`
- `membership_plan`
- `subscription`
- `trainer`
- `class`
- `class_schedule`
- `attendance`
- `payment`
- `locker_assignment`

The ER diagram is located at `docs/er_diagram.png`.

## Description of SQL files

### `schema_creation.sql`
Creates all tables, primary and foreign keys, and constraints.

### `sample_data.sql`
Fills the database with sample values ​​(club members, rates, coaches, schedule, visits, payments).

### `basic_queries.sql`
Basic SQL queries: selections, filtering, sorting, simple JOINs.

### `advanced_queries.sql`
Advanced queries:

- aggregates
- GROUP BY and HAVING
- window functions
- CTE
- analytical reports

### `transactions_and_indexes.sql`
Examples:

- transactions with COMMIT and ROLLBACK
- "create customer + subscription + payment" scenario
- indexes for query acceleration

### `views_and_functions.sql`
Contains:

- analytical views
- SQL and PL/pgSQL functions for working with data
## Installation and Startup

### 1. Create a Database
```bash
createdb fitness_club_db
```

### 2. Load the Schema
```bash
psql -d fitness_club_db -f sql/01_schema_creation.sql
```

### 3. Add Data
```bash
psql -d fitness_club_db -f sql/02_sample_data.sql
```

### 4. Execute Queries
```bash
psql -d fitness_club_db -f sql/03_basic_queries.sql
psql -d fitness_club_db -f sql/04_advanced_queries.sql
```

### 5. Use Transactions, Indexes, Views, and Functions
```bash
psql -d fitness_club_db -f sql/05_transactions_and_indexes.sql
psql -d fitness_club_db -f sql/06_views_and_functions.sql
```

## Backup and Restore

Instructions: `backup/backup_instructions.md`.

### Backup
```bash
pg_dump -Fc -f fitness_club_backup.dump fitness_club_db
```

### Restore
```bash
pg_restore -d fitness_club_db_restored fitness_club_backup.dump
```

## Compliance

The project contains:

- ER diagram and database schema
- PostgreSQL implementation
- Basic and complex SQL queries
- Examples of transactions and indexes
- Backup strategy
- Views and functions
