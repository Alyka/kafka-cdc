# Postgress configuration for CDC

## Edit the postgresql.conf file to add the following lines

```conf
wal_level = logical
max_replication_slots = 10
max_wal_senders = 4
```

> Run `SHOW config_file` to get the location of the pg_conf file.

## Edit the pg_hba.conf file to add the following lines

```conf
host    vas             postgres        192.168.43.139/32       scram-sha-256
host    replication     postgres        192.168.43.139/32       scram-sha-256
```

> Run `SHOW hba_file;` to get the location of the pg_conf file.

## View, Drop, Create, or Add table to the publication tables

```sql
SELECT * FROM pg_publication_tables WHERE pubname = 'dbz_publication';
DROP PUBLICATION dbz_publication;
CREATE PUBLICATION dbz_publication FOR ALL TABLES;
ALTER PUBLICATION dbz_publication ADD TABLE public.<table name>;
```

## Display the replica identities of all tables

```sql
SELECT 
    schemaname,
    tablename,
    relreplident,
    CASE 
        WHEN relreplident = 'd' THEN 'DEFAULT'
        WHEN relreplident = 'n' THEN 'NOTHING'
        WHEN relreplident = 'f' THEN 'FULL'
        WHEN relreplident = 'i' THEN 'INDEX'
        ELSE 'UNKNOWN'
    END as replica_identity
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_tables t ON t.schemaname = n.nspname AND t.tablename = c.relname
WHERE relkind = 'r'
ORDER BY schemaname, tablename;
```

### Change the replica identities of all tables to `FULL`

```sql
DO $$ 
DECLARE 
    r RECORD;
BEGIN 
    FOR r IN (
        SELECT schemaname, tablename
        FROM pg_tables
        WHERE schemaname = 'public'
    ) LOOP
        EXECUTE format('ALTER TABLE %I.%I REPLICA IDENTITY FULL;', r.schemaname, r.tablename);
    END LOOP;
END $$;
```
