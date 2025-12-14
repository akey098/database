# Backup and Restore Strategy

## Backup

Database dump to a custom format:

```bash
pg_dump -Fc -f fitness_club_backup.dump fitness_club_db
```

or dump into SQL format:

```bash
pg_dump -Fp -f fitness_club_backup.sql fitness_club_db
```

## Recovery

Restoring from a custom format:
```bash
createdb fitness_club_db_restored
pg_restore -d fitness_club_db_restored fitness_club_backup.dump
```

or restore from the SQL format:
```bash
createdb fitness_club_db_restored
psql -d fitness_club_db_restored -f fitness_club_backup.sql
```