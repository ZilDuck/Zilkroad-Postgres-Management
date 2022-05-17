-- drop the existing user
REVOKE ALL PRIVILEGES ON DATABASE postgres FROM user_function_readonly;
REVOKE CONNECT ON DATABASE postgres FROM user_function_readonly;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM user_function_readonly;
DROP OWNED BY user_function_readonly;
DROP USER IF EXISTS user_function_readonly;

-- https://stackoverflow.com/questions/760210/how-do-you-create-a-read-only-user-in-postgresql
-- user_function_readonly is used by the public API
-- It is allowed connection to public DB and all function calls
CREATE ROLE user_function_readonly WITH LOGIN PASSWORD 'a}T.K;XA>M45d\D/#Ws#T$As+4a=MM8S'
NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION VALID UNTIL 'infinity';

--assign permissions
GRANT CONNECT ON DATABASE postgres TO user_function_readonly;
GRANT USAGE ON SCHEMA public TO user_function_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO user_function_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO user_function_readonly;

-- allow access to newer tables in the future
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO user_function_readonly