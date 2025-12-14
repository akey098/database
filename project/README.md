# Fitness Club Membership Management

I’m aware of the deadlines and I will meet them.

## Project Structure

```text
project/
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

## What the database stores

- Members
- Pricing plans and memberships
- Trainers
- Classes and schedules
- Attendance records
- Payments
- Locker assignments
- Analytical reports

## Main tables

- `member`
- `membership_plan`
- `subscription`
- `trainer`
- `class`
- `class_schedule`
- `attendance`
- `payment`
- `locker_assignment`

## Installation and Startup
In psql:

Create a database
```sql
CREATE DATABASE fitness_club_db;
```

Load the schema
```sql
\i sql/schema_creation.sql;
```

Add data
```sql
\i sql/sample_data.sql;
```

Execute queries
```sql
\i sql/basic_queries.sql;
\i sql/advanced_queries.sql;
```

Execute transactions and functions
```sql
\i sql/transactions_and_indexes.sql;
\i sql/views_and_functions.sql;
```


