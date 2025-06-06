SELECT
 'DROP TABLE IF EXISTS public.' || table_name || ' CASCADE;' AS drop_query
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
;
