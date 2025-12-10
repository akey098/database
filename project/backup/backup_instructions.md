# Backup and Recovery Instructions

## 1. Overview
This document describes the process of backing up and restoring the PostgreSQL database used in the *Fitness Club Membership Management* project.

## 2. Backup

### 2.1 Full Database Backup
Recommended format: `custom` (`-Fc`).

```bash
pg_dump -Fc -f fitness_club_backup.dump fitness_club_db
```

### 2.2 SQL Dump (Text)
```bash
pg_dump -f fitness_club_backup.sql fitness_club_db
```

### 2.3 Recommendations
- Perform daily backups;
- Keep at least 7-14 recent copies;
- Test recovery once a month;
- Store copies separately from the database server.

## 3. Recovery

### 3.1 Restoring from a custom dump (`.dump`)
```bash
createdb fitness_club_db_restored
pg_restore -d fitness_club_db_restored fitness_club_backup.dump
```

### 3.2 Restoring from an SQL file
```bash
createdb fitness_club_db_restored
psql -d fitness_club_db_restored -f fitness_club_backup.sql
```
## 4. Verifying the restoration
After restoration, we recommend running:

```sql
SELECT COUNT(*) FROM member;
SELECT COUNT(*) FROM subscription;
SELECT COUNT(*) FROM class_schedule;
```

## 5. Additional recommendations
- Store backups in the cloud or on a dedicated drive.
- Use file versions with dates (`backup_2025_12_10.dump`).
- For large databases, WAL archiving and point-in-time recovery can be configured.