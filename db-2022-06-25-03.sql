--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: ProjectStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ProjectStatus" AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'ARCHIVED'
);


ALTER TYPE public."ProjectStatus" OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type text,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.email', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
	)::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.role', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
	)::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.sub', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
	)::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  schema_is_cron bool;
BEGIN
  schema_is_cron = (
    SELECT n.nspname = 'cron'
    FROM pg_event_trigger_ddl_commands() AS ev
    LEFT JOIN pg_catalog.pg_namespace AS n
      ON ev.objid = n.oid
  );

  IF schema_is_cron
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option; 

  END IF;

END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_collect_response(request_id bigint, async boolean) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_collect_response(request_id bigint, async boolean) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
      declare
        -- Regclass of the table e.g. public.notes
        entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

        -- I, U, D, T: insert, update ...
        action realtime.action = (
          case wal ->> 'action'
            when 'I' then 'INSERT'
            when 'U' then 'UPDATE'
            when 'D' then 'DELETE'
            else 'ERROR'
          end
        );

        -- Is row level security enabled for the table
        is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

        subscriptions realtime.subscription[] = array_agg(subs)
          from
            realtime.subscription subs
          where
            subs.entity = entity_;

        -- Subscription vars
        roles regrole[] = array_agg(distinct us.claims_role)
          from
            unnest(subscriptions) us;

        working_role regrole;
        claimed_role regrole;
        claims jsonb;

        subscription_id uuid;
        subscription_has_access bool;
        visible_to_subscription_ids uuid[] = '{}';

        -- structured info for wal's columns
        columns realtime.wal_column[];
        -- previous identity values for update/delete
        old_columns realtime.wal_column[];

        error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

        -- Primary jsonb output for record
        output jsonb;

      begin
        perform set_config('role', null, true);

        columns =
          array_agg(
            (
              x->>'name',
              x->>'type',
              realtime.cast((x->'value') #>> '{}', (x->>'type')::regtype),
              (pks ->> 'name') is not null,
              true
            )::realtime.wal_column
          )
          from
            jsonb_array_elements(wal -> 'columns') x
            left join jsonb_array_elements(wal -> 'pk') pks
              on (x ->> 'name') = (pks ->> 'name');

        old_columns =
          array_agg(
            (
              x->>'name',
              x->>'type',
              realtime.cast((x->'value') #>> '{}', (x->>'type')::regtype),
              (pks ->> 'name') is not null,
              true
            )::realtime.wal_column
          )
          from
            jsonb_array_elements(wal -> 'identity') x
            left join jsonb_array_elements(wal -> 'pk') pks
              on (x ->> 'name') = (pks ->> 'name');

        for working_role in select * from unnest(roles) loop

          -- Update `is_selectable` for columns and old_columns
          columns =
            array_agg(
              (
                c.name,
                c.type,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
              )::realtime.wal_column
            )
            from
              unnest(columns) c;

          old_columns =
            array_agg(
              (
                c.name,
                c.type,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
              )::realtime.wal_column
            )
            from
              unnest(old_columns) c;

          if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
            return next (
              null,
              is_rls_enabled,
              -- subscriptions is already filtered by entity
              (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
              array['Error 400: Bad Request, no primary key']
            )::realtime.wal_rls;

          -- The claims role does not have SELECT permission to the primary key of entity
          elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            return next (
              null,
              is_rls_enabled,
              (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
              array['Error 401: Unauthorized']
            )::realtime.wal_rls;

          else
            output = jsonb_build_object(
              'schema', wal ->> 'schema',
              'table', wal ->> 'table',
              'type', action,
              'commit_timestamp', to_char(
                (wal ->> 'timestamp')::timestamptz,
                'YYYY-MM-DD"T"HH24:MI:SS"Z"'
              ),
              'columns', (
                select
                  jsonb_agg(
                    jsonb_build_object(
                      'name', pa.attname,
                      'type', pt.typname
                    )
                    order by pa.attnum asc
                  )
                    from
                      pg_attribute pa
                      join pg_type pt
                        on pa.atttypid = pt.oid
                    where
                      attrelid = entity_
                      and attnum > 0
                      and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
              )
            )
            -- Add "record" key for insert and update
            || case
                when error_record_exceeds_max_size then jsonb_build_object('record', '{}'::jsonb)
                when action in ('INSERT', 'UPDATE') then
                  jsonb_build_object(
                    'record',
                    (select jsonb_object_agg((c).name, (c).value) from unnest(columns) c where (c).is_selectable)
                  )
                else '{}'::jsonb
            end
            -- Add "old_record" key for update and delete
            || case
                when error_record_exceeds_max_size then jsonb_build_object('old_record', '{}'::jsonb)
                when action in ('UPDATE', 'DELETE') then
                  jsonb_build_object(
                    'old_record',
                    (select jsonb_object_agg((c).name, (c).value) from unnest(old_columns) c where (c).is_selectable)
                  )
                else '{}'::jsonb
            end;

            -- Create the prepared statement
            if is_rls_enabled and action <> 'DELETE' then
              if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
              end if;
              execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            visible_to_subscription_ids = '{}';

            for subscription_id, claims in (
                select
                  subs.subscription_id,
                  subs.claims
                from
                  unnest(subscriptions) subs
                where
                  subs.entity = entity_
                  and subs.claims_role = working_role
                  and realtime.is_visible_through_filters(columns, subs.filters)
              ) loop

              if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
              else
                -- Check if RLS allows the role to see the record
                perform
                  set_config('role', working_role::text, true),
                  set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                  visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
              end if;
            end loop;

            perform set_config('role', null, true);

            return next (
              output,
              is_rls_enabled,
              visible_to_subscription_ids,
              case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
              end
            )::realtime.wal_rls;

          end if;
        end loop;

        perform set_config('role', null, true);
      end;
      $$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
    /*
    Builds a sql string that, if executed, creates a prepared statement to
    tests retrive a row from *entity* by its primary key columns.

    Example
      select realtime.build_prepared_statment_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
    */
      select
    'prepare ' || prepared_statement_name || ' as
      select
        exists(
          select
            1
          from
            ' || entity || '
          where
            ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
        )'
      from
        unnest(columns) pkc
      where
        pkc.is_pkey
      group by
        entity
    $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    /*
    Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
    */
    declare
      op_symbol text = (
        case
          when op = 'eq' then '='
          when op = 'neq' then '!='
          when op = 'lt' then '<'
          when op = 'lte' then '<='
          when op = 'gt' then '>'
          when op = 'gte' then '>='
          else 'UNKNOWN OP'
        end
      );
      res boolean;
    begin
      execute format('select %L::'|| type_::text || ' ' || op_symbol || ' %L::'|| type_::text, val_1, val_2) into res;
      return res;
    end;
    $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
    select
      -- Default to allowed when no filters present
      coalesce(
        sum(
          realtime.check_equality_op(
            op:=f.op,
            type_:=col.type::regtype,
            -- cast jsonb to text
            val_1:=col.value #>> '{}',
            val_2:=f.value
          )::int
        ) = count(1),
        true
      )
    from
      unnest(filters) f
      join unnest(columns) col
          on f.column_name = col.name;
    $$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
      col_names text[] = coalesce(
        array_agg(c.column_name order by c.ordinal_position),
        '{}'::text[]
      )
      from
        information_schema.columns c
      where
        format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
        and pg_catalog.has_column_privilege(
          (new.claims ->> 'role'),
          format('%I.%I', c.table_schema, c.table_name)::regclass,
          c.column_name,
          'SELECT'
        );
      filter realtime.user_defined_filter;
      col_type regtype;
    begin
      for filter in select * from unnest(new.filters) loop
        -- Filtered column is valid
        if not filter.column_name = any(col_names) then
          raise exception 'invalid column for filter %', filter.column_name;
        end if;

        -- Type is sanitized and safe for string interpolation
        col_type = (
          select atttypid::regtype
          from pg_catalog.pg_attribute
          where attrelid = new.entity
            and attname = filter.column_name
        );
        if col_type is null then
          raise exception 'failed to lookup type for column %', filter.column_name;
        end if;
        -- raises an exception if value is not coercable to type
        perform realtime.cast(filter.value, col_type);
      end loop;

      -- Apply consistent order to filters so the unique constraint on
      -- (subscription_id, entity, filters) can't be tricked by a different filter order
      new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value),
        '{}'
      ) from unnest(new.filters) f;

    return new;
  end;
  $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return split_part(_filename, '.', 2);
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255)
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone character varying(15) DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change character varying(15) DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: Activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Activity" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "strikeId" text
);


ALTER TABLE public."Activity" OWNER TO postgres;

--
-- Name: Habit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Habit" (
    id text NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "userId" text
);


ALTER TABLE public."Habit" OWNER TO postgres;

--
-- Name: Project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Project" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    status public."ProjectStatus" DEFAULT 'ACTIVE'::public."ProjectStatus" NOT NULL
);


ALTER TABLE public."Project" OWNER TO postgres;

--
-- Name: Strike; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Strike" (
    id text NOT NULL,
    "createdAt" timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    days text[],
    "habitId" text,
    name text NOT NULL,
    description text
);


ALTER TABLE public."Strike" OWNER TO postgres;

--
-- Name: Task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Task" (
    id text NOT NULL,
    name text NOT NULL,
    "projectId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    "Sheduled" timestamp(3) without time zone DEFAULT (now() + '1 day'::interval day),
    "userId" text
);


ALTER TABLE public."Task" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id text NOT NULL,
    uid text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    name text NOT NULL,
    username text NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at) FROM stdin;
00000000-0000-0000-0000-000000000000	8c7e661f-7a53-4a0d-9aa4-eb3fffc7b500	{"action":"user_signedup","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"team","timestamp":"2021-09-13T19:49:11Z"}	2021-09-13 19:49:11.248281+00
00000000-0000-0000-0000-000000000000	2cfa49e4-9b39-4fca-b22b-0eca671a61d0	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T19:48:39Z"}	2021-09-14 19:48:39.92653+00
00000000-0000-0000-0000-000000000000	cae313cc-2426-4abd-87fe-6c82eeb7c7d6	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T19:48:46Z"}	2021-09-14 19:48:46.609424+00
00000000-0000-0000-0000-000000000000	17c7475b-fa28-4337-977b-1ac451fbc61e	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T19:49:37Z"}	2021-09-14 19:49:37.377622+00
00000000-0000-0000-0000-000000000000	f70f9eb7-9b0f-40c3-8f6a-5e8a820f754f	{"action":"logout","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T19:50:36Z"}	2021-09-14 19:50:36.54143+00
00000000-0000-0000-0000-000000000000	1bf567c8-44b2-40f1-81f7-a4b39c284b93	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T19:51:05Z"}	2021-09-14 19:51:05.634151+00
00000000-0000-0000-0000-000000000000	24bea4bf-05c5-45ae-bdc1-400c83def2d6	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T19:51:08Z"}	2021-09-14 19:51:08.770065+00
00000000-0000-0000-0000-000000000000	624bba71-1235-4d8d-bc4e-e81a2d6663d9	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T19:51:18Z"}	2021-09-14 19:51:18.936888+00
00000000-0000-0000-0000-000000000000	768c873a-0973-4949-a59f-0958e5c87c39	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T19:55:11Z"}	2021-09-14 19:55:11.007969+00
00000000-0000-0000-0000-000000000000	506b2dbc-32d5-4120-ba36-cbed5187f046	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T19:57:49Z"}	2021-09-14 19:57:49.665012+00
00000000-0000-0000-0000-000000000000	12dfb194-88df-400a-852c-333b742b8d9d	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T20:02:13Z"}	2021-09-14 20:02:13.847333+00
00000000-0000-0000-0000-000000000000	99314653-b898-4eb7-b08c-e23b3c777498	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T20:02:18Z"}	2021-09-14 20:02:18.60501+00
00000000-0000-0000-0000-000000000000	c718e9d5-e132-4a0d-bdeb-e3e22dca5efc	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T20:03:04Z"}	2021-09-14 20:03:04.09079+00
00000000-0000-0000-0000-000000000000	d40b42b3-ec5c-491f-aad1-5f9af1fd926f	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-14T20:03:08Z"}	2021-09-14 20:03:08.931854+00
00000000-0000-0000-0000-000000000000	30462fea-cd2b-4fd2-8242-de119362cc41	{"action":"token_refreshed","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"token","timestamp":"2021-09-15T10:25:45Z"}	2021-09-15 10:25:45.237142+00
00000000-0000-0000-0000-000000000000	354a91bb-6b8f-46ee-b40d-517b10260583	{"action":"token_revoked","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"token","timestamp":"2021-09-15T10:25:45Z"}	2021-09-15 10:25:45.239601+00
00000000-0000-0000-0000-000000000000	5c954dea-e4ad-443c-a269-e5b44b55bbca	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-15T10:26:44Z"}	2021-09-15 10:26:44.371727+00
00000000-0000-0000-0000-000000000000	1f2afad1-46e5-4d8d-883c-a57459d111bc	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-15T10:27:57Z"}	2021-09-15 10:27:57.252133+00
00000000-0000-0000-0000-000000000000	947186b1-8d8f-4619-a4f6-03e24f3085ec	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-15T10:28:59Z"}	2021-09-15 10:28:59.562184+00
00000000-0000-0000-0000-000000000000	18b49503-ef9e-4a65-99c9-2e2920f36dae	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-15T10:29:03Z"}	2021-09-15 10:29:03.413461+00
00000000-0000-0000-0000-000000000000	0fcfeb15-d2c3-4f5d-abf6-b054430774b5	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-15T10:34:50Z"}	2021-09-15 10:34:50.781119+00
00000000-0000-0000-0000-000000000000	8eb8ae87-01fb-4603-ad56-37141b5eedc6	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-09-15T10:34:56Z"}	2021-09-15 10:34:56.285138+00
00000000-0000-0000-0000-000000000000	695c3e76-4230-46fe-937a-29a3d35dc905	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-03T08:29:54Z"}	2021-10-03 08:29:54.17835+00
00000000-0000-0000-0000-000000000000	8cfa9dee-df1b-4f08-8585-65b0ab350451	{"action":"token_refreshed","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"token","timestamp":"2021-10-03T11:38:22Z"}	2021-10-03 11:38:22.118043+00
00000000-0000-0000-0000-000000000000	d44dfa7e-8389-45c5-a829-534c1cc584e1	{"action":"token_revoked","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"token","timestamp":"2021-10-03T11:38:22Z"}	2021-10-03 11:38:22.118699+00
00000000-0000-0000-0000-000000000000	0c4f1ea5-14d0-4d11-a9d6-3fd0cc0854c1	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-03T11:57:54Z"}	2021-10-03 11:57:54.183735+00
00000000-0000-0000-0000-000000000000	9f9393f0-754e-4ece-8681-073e00b59088	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-03T11:59:35Z"}	2021-10-03 11:59:35.146224+00
00000000-0000-0000-0000-000000000000	e4cf30b8-6998-4677-88fd-56edbbd73979	{"action":"user_recovery_requested","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"user","timestamp":"2021-10-03T12:01:43Z"}	2021-10-03 12:01:43.847017+00
00000000-0000-0000-0000-000000000000	9a8dfc46-e7b1-433f-8179-7a2b3c164962	{"action":"token_refreshed","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"token","timestamp":"2021-10-03T13:24:47Z"}	2021-10-03 13:24:47.041105+00
00000000-0000-0000-0000-000000000000	9df65cf7-d7c8-40f9-b94f-600e06785b33	{"action":"token_revoked","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"token","timestamp":"2021-10-03T13:24:47Z"}	2021-10-03 13:24:47.041842+00
00000000-0000-0000-0000-000000000000	dbdf73ba-2054-4f58-a245-15b290adf477	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-08T06:19:36Z"}	2021-10-08 06:19:36.07914+00
00000000-0000-0000-0000-000000000000	f2d09237-55dd-4f77-a089-4781dd2a1049	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-08T06:20:28Z"}	2021-10-08 06:20:28.753245+00
00000000-0000-0000-0000-000000000000	8dab314f-52ad-49cb-b05e-01ae596418b3	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-08T06:26:03Z"}	2021-10-08 06:26:03.59079+00
00000000-0000-0000-0000-000000000000	036f1ad4-61e3-478a-850b-98095a1d2ad9	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-08T06:26:22Z"}	2021-10-08 06:26:22.574657+00
00000000-0000-0000-0000-000000000000	a2197faf-c8bb-404f-8259-240661514b28	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-08T06:33:38Z"}	2021-10-08 06:33:38.771332+00
00000000-0000-0000-0000-000000000000	6efcd20f-768b-47cf-9252-2640ee6263c2	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-08T06:34:55Z"}	2021-10-08 06:34:55.44557+00
00000000-0000-0000-0000-000000000000	c08e7714-1bc3-4082-bc52-7819a7bcbc8a	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:16:32Z"}	2021-10-09 21:16:32.296553+00
00000000-0000-0000-0000-000000000000	9c1dbd78-3fd7-41da-a2f1-9b0e3e1ee748	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:17:08Z"}	2021-10-09 21:17:08.100912+00
00000000-0000-0000-0000-000000000000	26838420-0b88-42e9-a405-46966c93e15f	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:17:23Z"}	2021-10-09 21:17:23.991406+00
00000000-0000-0000-0000-000000000000	4e1ea615-b570-4092-8609-88871fe5b48b	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:18:03Z"}	2021-10-09 21:18:03.453065+00
00000000-0000-0000-0000-000000000000	e721b5c2-6758-4244-89d8-18dcf6dd0b7a	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:18:19Z"}	2021-10-09 21:18:19.896643+00
00000000-0000-0000-0000-000000000000	ce313fce-722e-46b5-b555-7c3952f43bbc	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:18:24Z"}	2021-10-09 21:18:24.268272+00
00000000-0000-0000-0000-000000000000	d7ef9230-6685-4af7-afa6-f23b075372f0	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:18:26Z"}	2021-10-09 21:18:26.177121+00
00000000-0000-0000-0000-000000000000	254f2a5c-6bb9-4a52-af68-f7d2937b6104	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:18:29Z"}	2021-10-09 21:18:29.148431+00
00000000-0000-0000-0000-000000000000	38b8348b-4b93-4e31-bcae-dceffa156ca4	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:19:03Z"}	2021-10-09 21:19:03.940073+00
00000000-0000-0000-0000-000000000000	48103727-6688-4a0c-bd69-4af6cda6e26c	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-09T21:36:07Z"}	2021-10-09 21:36:07.553405+00
00000000-0000-0000-0000-000000000000	8e19a66b-2140-485d-9f36-aeab86563081	{"action":"login","actor_id":"1c171d35-dd2a-42d0-87ec-02f91179fc7d","actor_name":"Makuza Mugabo verite","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T22:06:55Z"}	2021-10-30 22:06:55.757254+00
00000000-0000-0000-0000-000000000000	82b6a773-01d9-47b5-a80f-f6db81e0f674	{"action":"user_confirmation_requested","actor_id":"37dbba90-9b5d-4615-b617-0743ee532916","actor_username":"verite@kobra.dev","log_type":"user","timestamp":"2021-10-30T23:13:10Z"}	2021-10-30 23:13:10.537121+00
00000000-0000-0000-0000-000000000000	60239846-55d6-4e86-8e46-9f6233f2e2e5	{"action":"user_confirmation_requested","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"user","timestamp":"2021-10-30T23:14:34Z"}	2021-10-30 23:14:34.533761+00
00000000-0000-0000-0000-000000000000	1dd2171e-c931-4aa7-b69a-d8ecd4664347	{"action":"user_signedup","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"team","timestamp":"2021-10-30T23:15:06Z"}	2021-10-30 23:15:06.191408+00
00000000-0000-0000-0000-000000000000	22fb682e-828a-4c62-af36-c589bc1a9a8e	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:15:28Z"}	2021-10-30 23:15:28.279681+00
00000000-0000-0000-0000-000000000000	6694318a-3c99-414d-ad47-df97f3fe95c0	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:19:06Z"}	2021-10-30 23:19:06.066416+00
00000000-0000-0000-0000-000000000000	767e0237-1d9f-498e-97ba-3cbb1fa02cee	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:25:18Z"}	2021-10-30 23:25:18.779113+00
00000000-0000-0000-0000-000000000000	c836afa5-5c3a-455e-9c21-e5a91c5986a1	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:27:03Z"}	2021-10-30 23:27:03.579759+00
00000000-0000-0000-0000-000000000000	ca2aecfe-c746-40d5-9dc3-5785f373af7c	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:27:36Z"}	2021-10-30 23:27:36.362213+00
00000000-0000-0000-0000-000000000000	b9523e90-44d9-4156-b6fc-782cec81481b	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:27:40Z"}	2021-10-30 23:27:40.199253+00
00000000-0000-0000-0000-000000000000	a4b3c5cb-6ef4-46ed-baf9-e0b9f9dfe7b0	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:27:49Z"}	2021-10-30 23:27:49.739897+00
00000000-0000-0000-0000-000000000000	ee38903a-922c-46fd-927f-7f1c89516b40	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:28:20Z"}	2021-10-30 23:28:20.699241+00
00000000-0000-0000-0000-000000000000	168adeec-11db-4a8f-a5ac-c2fc3c817a26	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:28:25Z"}	2021-10-30 23:28:25.350384+00
00000000-0000-0000-0000-000000000000	75846ea7-5c73-4321-bf68-d1f5ff43a641	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-30T23:28:33Z"}	2021-10-30 23:28:33.460376+00
00000000-0000-0000-0000-000000000000	e3319a1c-b19b-4a8a-b297-c73b1e5be060	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-31T10:55:13Z"}	2021-10-31 10:55:13.729225+00
00000000-0000-0000-0000-000000000000	8c42e175-c36f-4a5a-9881-1ac8784f1619	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-31T13:03:10Z"}	2021-10-31 13:03:10.445461+00
00000000-0000-0000-0000-000000000000	46aa49bd-47fe-4da5-b650-71a279a3dc9c	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-31T13:03:57Z"}	2021-10-31 13:03:57.19022+00
00000000-0000-0000-0000-000000000000	3f419488-7541-447b-bff4-1b9eb3f53028	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-31T13:04:22Z"}	2021-10-31 13:04:22.812682+00
00000000-0000-0000-0000-000000000000	40001bca-7f6e-44e6-b7df-e6296db89aef	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-10-31T13:04:32Z"}	2021-10-31 13:04:32.256124+00
00000000-0000-0000-0000-000000000000	bdc4b2c2-04c0-492d-9afa-1bd25b9e2c5b	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-01T21:04:02Z"}	2021-11-01 21:04:02.859193+00
00000000-0000-0000-0000-000000000000	67b595e5-0671-47a1-b079-710e46b29c35	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-01T21:04:20Z"}	2021-11-01 21:04:20.575521+00
00000000-0000-0000-0000-000000000000	78f20189-4b6e-410e-bc2e-6582450906e2	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-01T21:04:54Z"}	2021-11-01 21:04:54.47118+00
00000000-0000-0000-0000-000000000000	0a6286a4-809b-47d5-8560-1b48cd7d28d7	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-01T21:05:00Z"}	2021-11-01 21:05:00.519583+00
00000000-0000-0000-0000-000000000000	ceccb598-5d4a-4b65-86e4-6311aa3c4c78	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-01T21:14:14Z"}	2021-11-01 21:14:14.801884+00
00000000-0000-0000-0000-000000000000	3aa4ac0a-fa68-4217-ba28-09612bfb8ab1	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-01T21:14:21Z"}	2021-11-01 21:14:21.610516+00
00000000-0000-0000-0000-000000000000	98227806-c5d5-45ec-9df7-0a0cd3ce07be	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-01T21:14:55Z"}	2021-11-01 21:14:55.836887+00
00000000-0000-0000-0000-000000000000	bbd0a419-9cbd-4e1e-9601-6d6a4d6e3c15	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-02T09:18:49Z"}	2021-11-02 09:18:49.656672+00
00000000-0000-0000-0000-000000000000	a0cbb9c4-cb57-4ca5-95b6-0339599717fc	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-02T10:25:56Z"}	2021-11-02 10:25:56.416616+00
00000000-0000-0000-0000-000000000000	711f727d-71a5-4001-a710-1c8a9e14d094	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-02T11:28:53Z"}	2021-11-02 11:28:53.717301+00
00000000-0000-0000-0000-000000000000	c6b08b36-1894-4dc9-91cc-f89c41124c8f	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-02T12:33:07Z"}	2021-11-02 12:33:07.466863+00
00000000-0000-0000-0000-000000000000	affd42b9-ac84-4f08-8b58-6b88694d6ce9	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-02T12:51:25Z"}	2021-11-02 12:51:25.86883+00
00000000-0000-0000-0000-000000000000	5b484bb0-85fc-4afd-b87a-51af7f9f8fb4	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-02T12:51:27Z"}	2021-11-02 12:51:27.406546+00
00000000-0000-0000-0000-000000000000	01e2ac4d-6c2b-46dc-85ac-593ba9a73917	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-02T13:04:08Z"}	2021-11-02 13:04:08.929155+00
00000000-0000-0000-0000-000000000000	62495481-fba1-4ff6-946e-d52662ada67e	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-07T10:17:00Z"}	2021-11-07 10:17:00.55968+00
00000000-0000-0000-0000-000000000000	4ca9bf5e-4673-4706-9f41-7c33952a8b36	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-14T19:46:31Z"}	2021-11-14 19:46:31.400067+00
00000000-0000-0000-0000-000000000000	54000526-6741-4628-9775-5dd1485c6b55	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-14T19:46:31Z"}	2021-11-14 19:46:31.409027+00
00000000-0000-0000-0000-000000000000	2f091a34-e83a-472e-be90-8f796684c5f0	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-15T12:58:09Z"}	2021-11-15 12:58:09.096888+00
00000000-0000-0000-0000-000000000000	b6d24f2b-f378-4b96-9353-edaa22d33056	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-16T21:27:34Z"}	2021-11-16 21:27:34.083992+00
00000000-0000-0000-0000-000000000000	4a499088-2808-4ab0-b6b6-be92b2b553db	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-17T06:38:22Z"}	2021-11-17 06:38:22.108868+00
00000000-0000-0000-0000-000000000000	db4ab56e-9b49-4953-985b-5a75935036d8	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-17T06:38:22Z"}	2021-11-17 06:38:22.12763+00
00000000-0000-0000-0000-000000000000	28d0333c-641c-4ba3-a181-941ca87155ca	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-17T19:39:23Z"}	2021-11-17 19:39:23.648438+00
00000000-0000-0000-0000-000000000000	aac6bfc7-889d-4c1e-860e-7d920d32c99b	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-18T05:00:37Z"}	2021-11-18 05:00:37.091847+00
00000000-0000-0000-0000-000000000000	a8074dfd-3dac-4494-8e2d-8c7c074526ea	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-18T22:54:51Z"}	2021-11-18 22:54:51.488381+00
00000000-0000-0000-0000-000000000000	cd0286a8-3e7a-4fe1-b7fa-2557f4280239	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-21T19:26:31Z"}	2021-11-21 19:26:31.376885+00
00000000-0000-0000-0000-000000000000	9f0db87e-a631-4b17-8ac7-8d7d97fe82eb	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-24T06:02:04Z"}	2021-11-24 06:02:04.575343+00
00000000-0000-0000-0000-000000000000	fdf89fa9-5a6a-4056-ae1f-957a4fdea869	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-24T06:02:08Z"}	2021-11-24 06:02:08.534588+00
00000000-0000-0000-0000-000000000000	dd86e478-b5da-4cff-824c-e1032d0d12a1	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-26T04:25:19Z"}	2021-11-26 04:25:19.424566+00
00000000-0000-0000-0000-000000000000	e921b50c-30a7-4974-9726-82bdde243be8	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-26T07:47:35Z"}	2021-11-26 07:47:35.68588+00
00000000-0000-0000-0000-000000000000	d9ced83e-4a4b-43f2-8dd8-7c1c73d8dbdc	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-26T08:17:54Z"}	2021-11-26 08:17:54.845555+00
00000000-0000-0000-0000-000000000000	afaaf16d-0cb5-4877-8b53-5768487db6b9	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T16:49:23Z"}	2021-11-30 16:49:23.174596+00
00000000-0000-0000-0000-000000000000	7cb02b2d-7f0c-4baf-9ca7-48974f804f89	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:02:01Z"}	2021-11-30 17:02:01.440594+00
00000000-0000-0000-0000-000000000000	af7e1488-68b9-41a4-b4df-af58a5a0fdfc	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:02:49Z"}	2021-11-30 17:02:49.108142+00
00000000-0000-0000-0000-000000000000	c2cfff13-4b25-495d-9ae4-adea09b8120f	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:02:49Z"}	2021-11-30 17:02:49.122692+00
00000000-0000-0000-0000-000000000000	b25684b1-b8f0-40ba-b0da-815cd9572b76	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:05:26Z"}	2021-11-30 17:05:26.608175+00
00000000-0000-0000-0000-000000000000	30a69c89-754d-4f1d-a704-32c1ef092c63	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:05:31Z"}	2021-11-30 17:05:31.301886+00
00000000-0000-0000-0000-000000000000	c77b40ce-6533-4037-ad6f-4c32730274e7	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:05:41Z"}	2021-11-30 17:05:41.749886+00
00000000-0000-0000-0000-000000000000	13af57a0-6a10-4864-a548-5476a12c44f8	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:06:30Z"}	2021-11-30 17:06:30.731982+00
00000000-0000-0000-0000-000000000000	c185affb-b2f5-427b-81ad-fb1cf6d01ad2	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:07:20Z"}	2021-11-30 17:07:20.347157+00
00000000-0000-0000-0000-000000000000	033ab175-970f-4240-bd58-7083d5686d95	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:08:42Z"}	2021-11-30 17:08:42.401209+00
00000000-0000-0000-0000-000000000000	e1084a34-82ba-412b-a3e0-1e2af4df6e6f	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:09:08Z"}	2021-11-30 17:09:08.115125+00
00000000-0000-0000-0000-000000000000	013bd1b8-7296-4d5b-b3d0-1d6d4cd048af	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:09:46Z"}	2021-11-30 17:09:46.274702+00
00000000-0000-0000-0000-000000000000	a22d81e8-41ea-40e0-bcb2-dfb902ad6f62	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:10:12Z"}	2021-11-30 17:10:12.974044+00
00000000-0000-0000-0000-000000000000	5c50e288-6e40-4144-8d60-5c0392eca02f	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:10:33Z"}	2021-11-30 17:10:33.707062+00
00000000-0000-0000-0000-000000000000	cf3014e4-1157-4beb-a38e-29decd190ecd	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:10:42Z"}	2021-11-30 17:10:42.022567+00
00000000-0000-0000-0000-000000000000	83053dad-4b38-45b0-94e6-80a49a1672e7	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:11:50Z"}	2021-11-30 17:11:50.559827+00
00000000-0000-0000-0000-000000000000	4a7263c8-60d1-4234-8827-cf6f1a46a879	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:12:58Z"}	2021-11-30 17:12:58.399613+00
00000000-0000-0000-0000-000000000000	6e1a8094-da9e-484e-ac9b-7dffe120f0c4	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T17:13:51Z"}	2021-11-30 17:13:51.946649+00
00000000-0000-0000-0000-000000000000	ed4ea4f7-4f20-4b35-887e-ec3d4e39b459	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T19:11:29Z"}	2021-11-30 19:11:29.14664+00
00000000-0000-0000-0000-000000000000	74a0a790-a5a3-46c0-8228-0a57bb4a4825	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T19:12:36Z"}	2021-11-30 19:12:36.002865+00
00000000-0000-0000-0000-000000000000	a925b0bc-f6b7-4422-b411-0a7e8778afb8	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T19:12:41Z"}	2021-11-30 19:12:41.890964+00
00000000-0000-0000-0000-000000000000	04d96f76-626f-4b27-b953-ea839cdb3317	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T19:14:16Z"}	2021-11-30 19:14:16.729702+00
00000000-0000-0000-0000-000000000000	005189f0-370a-4d55-bb70-5b3bec973418	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T19:14:23Z"}	2021-11-30 19:14:23.406781+00
00000000-0000-0000-0000-000000000000	8ba68b65-2162-43c1-b810-96b1bdb49576	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T21:06:20Z"}	2021-11-30 21:06:20.680524+00
00000000-0000-0000-0000-000000000000	f79e0664-f0d6-42af-b732-4d7cddacddc8	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T21:16:40Z"}	2021-11-30 21:16:40.22751+00
00000000-0000-0000-0000-000000000000	2848affe-8e94-4841-9150-0f59f41a1636	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T21:17:17Z"}	2021-11-30 21:17:17.368844+00
00000000-0000-0000-0000-000000000000	05fd841e-9a9e-4141-adab-a47fbbcfb944	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T21:17:44Z"}	2021-11-30 21:17:44.689396+00
00000000-0000-0000-0000-000000000000	c0fa8d17-b606-49ed-bd26-8818c5906325	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T21:20:34Z"}	2021-11-30 21:20:34.466996+00
00000000-0000-0000-0000-000000000000	2bbc6909-15f3-4df5-92c0-5589f93a619b	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T21:29:13Z"}	2021-11-30 21:29:13.132092+00
00000000-0000-0000-0000-000000000000	decf308d-15e5-4a7b-b87d-cf029e1e4e3e	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-11-30T21:37:42Z"}	2021-11-30 21:37:42.977567+00
00000000-0000-0000-0000-000000000000	aa60354e-30e3-413a-adc9-482bd0d1c5b7	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-01T16:57:36Z"}	2021-12-01 16:57:36.999442+00
00000000-0000-0000-0000-000000000000	74452a27-eb6f-407d-b8c6-187757347a80	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-01T17:01:34Z"}	2021-12-01 17:01:34.496529+00
00000000-0000-0000-0000-000000000000	6e7bd2c1-141f-46dc-9cc4-d49e6f08db6a	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-01T17:08:38Z"}	2021-12-01 17:08:38.51064+00
00000000-0000-0000-0000-000000000000	abb3d356-649b-433b-bfb1-6d0f27d9ba29	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-01T17:11:29Z"}	2021-12-01 17:11:29.172006+00
00000000-0000-0000-0000-000000000000	6059567d-e338-4023-bd40-8cb9147c1548	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-02T19:57:41Z"}	2021-12-02 19:57:41.569679+00
00000000-0000-0000-0000-000000000000	832972d7-c53f-4746-951f-8963874a0473	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-02T20:00:07Z"}	2021-12-02 20:00:07.325808+00
00000000-0000-0000-0000-000000000000	b2b53233-b508-4ff8-8fab-bd73abaa5289	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-02T20:00:07Z"}	2021-12-02 20:00:07.856119+00
00000000-0000-0000-0000-000000000000	2eccf05f-317a-458b-83ea-24511b342589	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-02T21:09:13Z"}	2021-12-02 21:09:13.037841+00
00000000-0000-0000-0000-000000000000	09d61fec-2827-4c3c-94bb-ae8876cca1c2	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-02T21:12:14Z"}	2021-12-02 21:12:14.465872+00
00000000-0000-0000-0000-000000000000	73297c52-65ab-41bb-b213-93cf87cf0bf1	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-02T21:55:45Z"}	2021-12-02 21:55:45.256201+00
00000000-0000-0000-0000-000000000000	19717d2a-d47b-44b2-9339-7c5b03026729	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-04T22:22:53Z"}	2021-12-04 22:22:53.877976+00
00000000-0000-0000-0000-000000000000	003283fa-51c0-4a9e-bd05-ff91cfd24827	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-04T23:19:59Z"}	2021-12-04 23:19:59.579716+00
00000000-0000-0000-0000-000000000000	b3809a9d-2dcd-4699-b67b-aba0240b07ac	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-04T23:28:58Z"}	2021-12-04 23:28:58.541444+00
00000000-0000-0000-0000-000000000000	58f891a9-8974-49be-bb41-a9d168637e23	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-05T09:01:19Z"}	2021-12-05 09:01:19.820608+00
00000000-0000-0000-0000-000000000000	6ef4d497-3c57-4628-a8cb-690e176735d7	{"action":"user_signedup","actor_id":"4407c74b-d460-443a-ba13-824612fbd3f6","actor_username":"hacker@hackerclub.com","log_type":"team","timestamp":"2021-12-05T17:00:50Z"}	2021-12-05 17:00:50.30185+00
00000000-0000-0000-0000-000000000000	8fdaadf7-8135-4fc2-9e64-0a3f61e252e6	{"action":"login","actor_id":"4407c74b-d460-443a-ba13-824612fbd3f6","actor_username":"hacker@hackerclub.com","log_type":"account","timestamp":"2021-12-05T17:00:50Z"}	2021-12-05 17:00:50.304453+00
00000000-0000-0000-0000-000000000000	3250c4d0-6198-41b5-ac23-19749dcd9317	{"action":"login","actor_id":"4407c74b-d460-443a-ba13-824612fbd3f6","actor_username":"hacker@hackerclub.com","log_type":"account","timestamp":"2021-12-05T17:01:03Z"}	2021-12-05 17:01:03.479719+00
00000000-0000-0000-0000-000000000000	d49b33c6-c116-4458-bb27-5c05a53a953e	{"action":"logout","actor_id":"4407c74b-d460-443a-ba13-824612fbd3f6","actor_username":"hacker@hackerclub.com","log_type":"account","timestamp":"2021-12-05T17:05:15Z"}	2021-12-05 17:05:15.686683+00
00000000-0000-0000-0000-000000000000	68fda079-90fc-48d1-9f75-3aa99658555e	{"action":"user_signedup","actor_id":"f3a301b8-fe48-4102-b0be-dc545c1b7f2d","actor_username":"didiermunezer38@gmail.com","log_type":"team","timestamp":"2021-12-05T19:30:57Z"}	2021-12-05 19:30:57.332392+00
00000000-0000-0000-0000-000000000000	5e2b2997-9a9d-45b8-9f5b-3aff46a9ff25	{"action":"login","actor_id":"f3a301b8-fe48-4102-b0be-dc545c1b7f2d","actor_username":"didiermunezer38@gmail.com","log_type":"account","timestamp":"2021-12-05T19:30:57Z"}	2021-12-05 19:30:57.33498+00
00000000-0000-0000-0000-000000000000	b99cce3b-f27e-4192-8ca0-2c4c0501a17e	{"action":"login","actor_id":"f3a301b8-fe48-4102-b0be-dc545c1b7f2d","actor_username":"didiermunezer38@gmail.com","log_type":"account","timestamp":"2021-12-05T19:31:32Z"}	2021-12-05 19:31:32.55051+00
00000000-0000-0000-0000-000000000000	aae0dd9a-0573-4994-a80f-cc24c1ae2316	{"action":"logout","actor_id":"f3a301b8-fe48-4102-b0be-dc545c1b7f2d","actor_username":"didiermunezer38@gmail.com","log_type":"account","timestamp":"2021-12-05T19:33:38Z"}	2021-12-05 19:33:38.491283+00
00000000-0000-0000-0000-000000000000	93a4bb88-2424-4acd-b159-6ff75da47a83	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-06T09:54:48Z"}	2021-12-06 09:54:48.61406+00
00000000-0000-0000-0000-000000000000	7f9c0f59-75e6-4bcf-b381-6efb0ec21772	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-06T09:54:48Z"}	2021-12-06 09:54:48.883761+00
00000000-0000-0000-0000-000000000000	881b7a5a-cf1a-4b13-8b42-dde27d9dc82c	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-06T11:35:12Z"}	2021-12-06 11:35:12.353886+00
00000000-0000-0000-0000-000000000000	f72fa6ed-19fd-4cab-9a3d-629cfd96ec5c	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-06T12:48:59Z"}	2021-12-06 12:48:59.91697+00
00000000-0000-0000-0000-000000000000	a83f241e-c9f3-4587-8081-e041be55b065	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-06T13:19:38Z"}	2021-12-06 13:19:38.978313+00
00000000-0000-0000-0000-000000000000	a32de625-1dcc-4483-8524-ac5b132ed829	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-06T13:46:46Z"}	2021-12-06 13:46:46.114417+00
00000000-0000-0000-0000-000000000000	7edb10d6-39b4-4cb6-8142-3e7eb5f7bd21	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-06T19:24:10Z"}	2021-12-06 19:24:10.940685+00
00000000-0000-0000-0000-000000000000	14cd69f6-f973-4874-ae45-9d6dee697a23	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-07T08:45:25Z"}	2021-12-07 08:45:25.406182+00
00000000-0000-0000-0000-000000000000	d0ecc553-06d2-469f-abca-6a1fd15d09b0	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-07T11:47:30Z"}	2021-12-07 11:47:30.391936+00
00000000-0000-0000-0000-000000000000	dca76560-f931-44be-848b-5a551104797c	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-08T13:39:42Z"}	2021-12-08 13:39:42.56473+00
00000000-0000-0000-0000-000000000000	51836334-f49c-432c-b896-166abb89950a	{"action":"logout","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-08T13:42:41Z"}	2021-12-08 13:42:41.726701+00
00000000-0000-0000-0000-000000000000	6fe58400-d41b-4f39-ab60-5f901e9b145d	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-08T13:42:59Z"}	2021-12-08 13:42:59.623722+00
00000000-0000-0000-0000-000000000000	30897e59-ca9d-4753-8578-16ebd9cb8752	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-08T16:42:04Z"}	2021-12-08 16:42:04.340601+00
00000000-0000-0000-0000-000000000000	efce774e-f090-456c-b7bd-6700cc763c78	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2021-12-08T16:42:06Z"}	2021-12-08 16:42:06.244652+00
00000000-0000-0000-0000-000000000000	b888791c-ff22-4810-bedd-56114ff088b1	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-01-09T15:45:56Z"}	2022-01-09 15:45:56.109266+00
00000000-0000-0000-0000-000000000000	2a0bb3ea-80e6-4a1f-b5c5-5089449e30f2	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-01-09T15:45:56Z"}	2022-01-09 15:45:56.123159+00
00000000-0000-0000-0000-000000000000	565ab3b0-eb32-489e-9fc7-0d8a6151a0ca	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-01-09T15:52:39Z"}	2022-01-09 15:52:39.880628+00
00000000-0000-0000-0000-000000000000	4afbb70b-9e30-4102-9db1-ed40ecf57cc4	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-01-09T15:52:40Z"}	2022-01-09 15:52:40.342166+00
00000000-0000-0000-0000-000000000000	d8f07ada-d3ef-4f68-acbc-c53af1867d9f	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-02-03T12:04:05Z"}	2022-02-03 12:04:05.087102+00
00000000-0000-0000-0000-000000000000	26169a64-1bc5-4727-a307-f9b31864c5a5	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-02-03T12:07:05Z"}	2022-02-03 12:07:05.866774+00
00000000-0000-0000-0000-000000000000	e49539ac-b434-415c-b13d-09e41441f9d9	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-02-03T12:16:47Z"}	2022-02-03 12:16:47.775431+00
00000000-0000-0000-0000-000000000000	dcb59de7-ed3a-4d81-9813-d20dad7ba09c	{"action":"token_refreshed","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"token","timestamp":"2022-02-03T13:15:49Z"}	2022-02-03 13:15:49.041701+00
00000000-0000-0000-0000-000000000000	8f4f6bd7-7eff-4d8b-95bd-178b479da17c	{"action":"token_revoked","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"token","timestamp":"2022-02-03T13:15:49Z"}	2022-02-03 13:15:49.042639+00
00000000-0000-0000-0000-000000000000	e3e66775-0644-4c8c-90aa-edf9e039e852	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-02-03T13:23:53Z"}	2022-02-03 13:23:53.750971+00
00000000-0000-0000-0000-000000000000	f15dffdb-1cfe-4df7-b626-652acf95e34d	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-02-03T13:24:56Z"}	2022-02-03 13:24:56.659155+00
00000000-0000-0000-0000-000000000000	37eab873-2aa3-44bd-94ab-36429970f19f	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-02-03T13:26:27Z"}	2022-02-03 13:26:27.564182+00
00000000-0000-0000-0000-000000000000	a11fed46-083d-4440-8142-3b32462d986f	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-02-03T13:27:32Z"}	2022-02-03 13:27:32.245069+00
00000000-0000-0000-0000-000000000000	e59dc8ab-e586-488d-80a1-d7d3ef8de3a3	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-02-05T19:44:32Z"}	2022-02-05 19:44:32.345842+00
00000000-0000-0000-0000-000000000000	25984e82-6dc5-4681-8fd1-70a5da49525a	{"action":"login","actor_id":"2f5d3c63-37f9-4a59-86d2-476a0d530c27","actor_username":"mugaboverite@gmail.com","log_type":"account","timestamp":"2022-03-02T09:16:38Z","traits":{"provider":"email"}}	2022-03-02 09:16:38.729487+00
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent) FROM stdin;
00000000-0000-0000-0000-000000000000	5	ny_JW66fMyeDkYho87QqeQ	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-14 19:51:05.634891+00	2021-09-14 19:51:05.634891+00	\N
00000000-0000-0000-0000-000000000000	6	PKvThO4BJEYDN2LFuB7FiA	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-14 19:51:08.77081+00	2021-09-14 19:51:08.77081+00	\N
00000000-0000-0000-0000-000000000000	7	s0_TA4fMnWXI2wDQHi8wEA	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-14 19:51:18.937853+00	2021-09-14 19:51:18.937853+00	\N
00000000-0000-0000-0000-000000000000	8	g24n6jvQhGP68ZkYrsS8WA	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-14 19:55:11.010684+00	2021-09-14 19:55:11.010684+00	\N
00000000-0000-0000-0000-000000000000	9	z7mf0cNTu_sWNgJi7MGY0w	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-14 19:57:49.665751+00	2021-09-14 19:57:49.665751+00	\N
00000000-0000-0000-0000-000000000000	10	650dkBc_NPKJPzHpOzMLgA	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-14 20:02:13.848117+00	2021-09-14 20:02:13.848117+00	\N
00000000-0000-0000-0000-000000000000	11	086f_X571Gl_BYhYd8PR8w	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-14 20:02:18.605756+00	2021-09-14 20:02:18.605756+00	\N
00000000-0000-0000-0000-000000000000	12	lCHRQD19NhUT_uvR3UT3HA	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-14 20:03:04.091516+00	2021-09-14 20:03:04.091516+00	\N
00000000-0000-0000-0000-000000000000	13	YNr1IgB-5ALqd6AMsDpSOw	1c171d35-dd2a-42d0-87ec-02f91179fc7d	t	2021-09-14 20:03:08.933933+00	2021-09-14 20:03:08.933933+00	\N
00000000-0000-0000-0000-000000000000	14	azN4tsN_L067vxr2QdhM1g	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-15 10:25:45.242069+00	2021-09-15 10:25:45.242069+00	\N
00000000-0000-0000-0000-000000000000	15	J_N-C5BOpgpZxqL8nRgzWg	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-15 10:26:44.372523+00	2021-09-15 10:26:44.372523+00	\N
00000000-0000-0000-0000-000000000000	16	OVKT-8zbuVAUn9ceT2kQjQ	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-15 10:27:57.252877+00	2021-09-15 10:27:57.252877+00	\N
00000000-0000-0000-0000-000000000000	17	yxbvDP6H1rBh5w5nKVoi0Q	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-15 10:28:59.562935+00	2021-09-15 10:28:59.562935+00	\N
00000000-0000-0000-0000-000000000000	18	SohkQ5rx3wj9GBr_bw35SA	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-15 10:29:03.41418+00	2021-09-15 10:29:03.41418+00	\N
00000000-0000-0000-0000-000000000000	19	vePzi_L0-Uu8wbUE-_0HSg	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-15 10:34:50.781949+00	2021-09-15 10:34:50.781949+00	\N
00000000-0000-0000-0000-000000000000	20	aiShKWD34Fp7znRtMs7ZnQ	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-09-15 10:34:56.285895+00	2021-09-15 10:34:56.285895+00	\N
00000000-0000-0000-0000-000000000000	21	bJsb37jhywlnV10sEXHIGQ	1c171d35-dd2a-42d0-87ec-02f91179fc7d	t	2021-10-03 08:29:54.182101+00	2021-10-03 08:29:54.182101+00	\N
00000000-0000-0000-0000-000000000000	22	TmAPOQE7YiW9Rnk5zOdQIQ	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-03 11:38:22.119872+00	2021-10-03 11:38:22.119872+00	\N
00000000-0000-0000-0000-000000000000	23	zPIU0sDwe-2DaV39HP_2wg	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-03 11:57:54.184471+00	2021-10-03 11:57:54.184471+00	\N
00000000-0000-0000-0000-000000000000	24	0ulKWibADySN1maR5lijyg	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-03 11:59:35.146951+00	2021-10-03 11:59:35.146951+00	\N
00000000-0000-0000-0000-000000000000	25	WlYfkMbT4svKD769fGcZVA	1c171d35-dd2a-42d0-87ec-02f91179fc7d	t	2021-10-03 12:25:44.136107+00	2021-10-03 12:25:44.136107+00	\N
00000000-0000-0000-0000-000000000000	26	5ffs3auuLvw2lZ6sHcaA-Q	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-03 13:24:47.043093+00	2021-10-03 13:24:47.043093+00	\N
00000000-0000-0000-0000-000000000000	27	C1PdovxryeYQ5wJhngK_-w	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-08 06:19:36.081768+00	2021-10-08 06:19:36.081768+00	\N
00000000-0000-0000-0000-000000000000	28	-lW0W7qFt_kJALzy2FTu1Q	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-08 06:20:28.754008+00	2021-10-08 06:20:28.754008+00	\N
00000000-0000-0000-0000-000000000000	29	w6UiKDdwbaiHWTtzpaQw5g	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-08 06:26:03.591516+00	2021-10-08 06:26:03.591516+00	\N
00000000-0000-0000-0000-000000000000	30	0eL1cEmIAdFq7m4nzAf7SQ	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-08 06:26:22.579151+00	2021-10-08 06:26:22.579151+00	\N
00000000-0000-0000-0000-000000000000	31	8R6KoFGp-OAxg1cxHfa6Uw	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-08 06:33:38.772019+00	2021-10-08 06:33:38.772019+00	\N
00000000-0000-0000-0000-000000000000	32	PjW5Jur_KirPACGKIGWoEQ	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-08 06:34:55.446307+00	2021-10-08 06:34:55.446307+00	\N
00000000-0000-0000-0000-000000000000	33	NOKVAJaCJENtlIfZExRwcg	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:16:32.300196+00	2021-10-09 21:16:32.300196+00	\N
00000000-0000-0000-0000-000000000000	34	Xqi8mRN8LHbSfrFeHGIetA	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:17:08.101644+00	2021-10-09 21:17:08.101644+00	\N
00000000-0000-0000-0000-000000000000	35	Eglp0QZuzwkah1jLK6cvKA	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:17:23.992133+00	2021-10-09 21:17:23.992133+00	\N
00000000-0000-0000-0000-000000000000	36	FPoqkwUtvULP8ax8BlyTFg	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:18:03.453765+00	2021-10-09 21:18:03.453765+00	\N
00000000-0000-0000-0000-000000000000	37	tuOIFo0I0kn1d8fdtSQRYw	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:18:19.897353+00	2021-10-09 21:18:19.897353+00	\N
00000000-0000-0000-0000-000000000000	38	imjleRKw7VaRSO8yJ1JbOw	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:18:24.268968+00	2021-10-09 21:18:24.268968+00	\N
00000000-0000-0000-0000-000000000000	39	dPlntPVv6ynwIwDhz2G-rw	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:18:26.177814+00	2021-10-09 21:18:26.177814+00	\N
00000000-0000-0000-0000-000000000000	40	Zb1Rn-tYB2PpHfxJHI0Kxg	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:18:29.149115+00	2021-10-09 21:18:29.149115+00	\N
00000000-0000-0000-0000-000000000000	41	LW_FaUThCtqcUFIL8PRlng	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:19:03.944944+00	2021-10-09 21:19:03.944944+00	\N
00000000-0000-0000-0000-000000000000	42	SMjxUVpx8cgUaSP4ebnFyQ	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-09 21:36:07.554153+00	2021-10-09 21:36:07.554153+00	\N
00000000-0000-0000-0000-000000000000	43	5jFaeH56jMDjnp7P9lRB-Q	1c171d35-dd2a-42d0-87ec-02f91179fc7d	f	2021-10-30 22:06:55.75833+00	2021-10-30 22:06:55.75833+00	\N
00000000-0000-0000-0000-000000000000	137	MY-MTnOJKOyIjoM2Xpc8dQ	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2021-12-08 16:42:04.341425+00	2021-12-08 16:42:04.341425+00	\N
00000000-0000-0000-0000-000000000000	138	sp_IhvMz4zIz4uh6T26S8Q	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2021-12-08 16:42:06.245475+00	2021-12-08 16:42:06.245475+00	\N
00000000-0000-0000-0000-000000000000	140	DNsZrv8JQl2GTLECOXfS9w	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-01-09 15:45:56.124327+00	2022-01-09 15:45:56.124327+00	\N
00000000-0000-0000-0000-000000000000	142	J7eqt6svtRVxfzAdMBvOFg	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-01-09 15:52:40.343152+00	2022-01-09 15:52:40.343152+00	\N
00000000-0000-0000-0000-000000000000	152	0_aspVY9j3lE3WFl7illxw	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-03-02 09:16:38.731592+00	2022-03-02 09:16:38.731595+00	\N
00000000-0000-0000-0000-000000000000	136	wrd5a-o9Kp8-DMSBfFS0Jg	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2021-12-08 13:42:59.624544+00	2021-12-08 13:42:59.624544+00	\N
00000000-0000-0000-0000-000000000000	139	EfINI2_-DfA8AYm-hoBJSA	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-01-09 15:45:56.110615+00	2022-01-09 15:45:56.110615+00	\N
00000000-0000-0000-0000-000000000000	141	xpmGAt7LiT_4znUwvo8uxA	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-01-09 15:52:39.881634+00	2022-01-09 15:52:39.881634+00	\N
00000000-0000-0000-0000-000000000000	143	gdeftNa8xaIRlTEJST_6oA	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-02-03 12:04:05.092525+00	2022-02-03 12:04:05.09253+00	\N
00000000-0000-0000-0000-000000000000	144	Qveyk8weBrKovqxtYCcQnw	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-02-03 12:07:05.867872+00	2022-02-03 12:07:05.867877+00	\N
00000000-0000-0000-0000-000000000000	145	pdE-MgMlOnoCPgSJI21FPg	2f5d3c63-37f9-4a59-86d2-476a0d530c27	t	2022-02-03 12:16:47.776499+00	2022-02-03 12:16:47.776502+00	\N
00000000-0000-0000-0000-000000000000	146	e932IHPBkNnE-ho9NzE-3Q	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-02-03 13:15:49.0444+00	2022-02-03 13:15:49.044403+00	pdE-MgMlOnoCPgSJI21FPg
00000000-0000-0000-0000-000000000000	147	lz-x8QQywF0_fMa6W95gAQ	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-02-03 13:23:53.752157+00	2022-02-03 13:23:53.752161+00	\N
00000000-0000-0000-0000-000000000000	148	l8xKPK5B1HTL85IrbrF66Q	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-02-03 13:24:56.66027+00	2022-02-03 13:24:56.660274+00	\N
00000000-0000-0000-0000-000000000000	149	WYtgWZKH5AiqztpBFxN3ew	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-02-03 13:26:27.565176+00	2022-02-03 13:26:27.565179+00	\N
00000000-0000-0000-0000-000000000000	150	RDOKuOAgYL6IDFnooP5Qmg	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-02-03 13:27:32.2461+00	2022-02-03 13:27:32.246103+00	\N
00000000-0000-0000-0000-000000000000	151	pUqPyESK2wHkiDj0Ezc7pg	2f5d3c63-37f9-4a59-86d2-476a0d530c27	f	2022-02-05 19:44:32.349955+00	2022-02-05 19:44:32.34996+00	\N
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
00
20220224000811
20220323170000
20220412150300
20220429010200
20220429102000
20220531120530
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at) FROM stdin;
00000000-0000-0000-0000-000000000000	2f5d3c63-37f9-4a59-86d2-476a0d530c27	authenticated	authenticated	mugaboverite@gmail.com	$2a$10$jpX8Cu6P.67njExldwjDN.o40DHVUCjxq9.IlDIPxGoFkw81TXPrm	2021-10-30 23:15:06.192053+00	\N		2021-10-30 23:14:34.534324+00		\N			\N	2022-03-02 09:16:38.731555+00	{"provider": "email"}	null	f	2021-10-30 23:14:34.531608+00	2021-10-30 23:14:34.531608+00	\N	\N			\N		0	\N		\N
\.


--
-- Data for Name: Activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Activity" (id, "createdAt", "updatedAt", "strikeId") FROM stdin;
\.


--
-- Data for Name: Habit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Habit" (id, name, "createdAt", "updatedAt", "userId") FROM stdin;
3af0c365-c0ea-4de3-8141-f07751c95804	Reading books	2021-12-24 17:33:26.493	2021-12-24 17:33:26.494	d52b8400-5e92-11ec-bf63-0242ac130002
8dc1f6f4-147a-4dee-8438-ab4e69d5a46e	Learning Math	2021-12-24 17:39:20.386	2021-12-24 17:39:20.387	d52b8400-5e92-11ec-bf63-0242ac130002
aa3c494f-368c-407a-b425-c32fb1961b34	Learning Physics	2021-12-24 17:43:56.347	2021-12-24 17:43:56.347	d52b8400-5e92-11ec-bf63-0242ac130002
f0229b17-ebc9-43b9-89ea-b40e73d58c41	Write open source code	2021-12-24 18:36:12.66	2021-12-24 18:36:12.661	d52b8400-5e92-11ec-bf63-0242ac130002
20e5e773-730d-4120-92be-101c85dd00d4	Working out	2021-12-24 18:38:21.458	2021-12-24 18:38:21.458	d52b8400-5e92-11ec-bf63-0242ac130002
82eec42e-bd39-465e-8ca3-c4e898fe2026	Time management	2021-12-24 18:38:57.297	2021-12-24 18:38:57.298	d52b8400-5e92-11ec-bf63-0242ac130002
\.


--
-- Data for Name: Project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Project" (id, name, description, "userId", "createdAt", "updatedAt", status) FROM stdin;
940c5e3e-f4af-4af5-acc6-117680d7c19b	tepl 	A wasm powered nodejs repl in the browser	d52b8400-5e92-11ec-bf63-0242ac130002	2022-01-02 15:44:44.78	2022-01-31 05:19:36.887	ACTIVE
33fb6e11-9115-45bd-b640-845a0d9f0918	sveltess	Re-usable svelte-components	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 19:43:43.892	2021-12-25 19:43:43.893	ACTIVE
0817d4ea-4593-49c7-a98b-88198eeb01f3	ndi	cross platform nerd fonts installer	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 19:44:23.243	2021-12-25 19:44:23.243	ACTIVE
4787f30d-799f-4058-886e-a6214f8f63d8	dutil	developer utilies	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-19 12:46:09.363	2021-12-19 12:46:09.363	ACTIVE
7e40bac2-db02-41fc-bdee-189880c23765	impauth	Authentication implementitoon 	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 19:42:39.724	2021-12-25 19:44:54.824	ACTIVE
6b543b51-40ca-4dd5-ae53-dd3332b7135a	rust api template	Rust api temp	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-27 12:49:41.702	2021-12-27 12:49:41.703	ACTIVE
af2de417-492f-491e-9701-759dc7c456b8	svere 	Modern builder and Runner for cpp projects	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 19:45:32.741	2021-12-25 19:45:32.742	ACTIVE
2c05de1b-c121-4e94-808b-9a79a09afc78	fork sync 	https://github.com/veritem/fork_sync	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 19:46:15.54	2021-12-25 19:46:15.541	ACTIVE
7659622d-a14e-4d1f-8843-cfcab75fffdc	ts compiler	https://github.com/veritem/rtsc	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 19:44:51.955	2021-12-25 19:53:25.715	ACTIVE
df6a6ac2-401d-43a7-9886-5f6e0392b834	lau	<div>Free and cross platform screen recorder<br></div>https://github.com/veritem/lau	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-24 17:50:56.592	2021-12-28 18:30:05.009	ACTIVE
0fcaa95e-101f-4390-be56-0709f642de8e	fakerjs 	<h3 style="margin-top: 24px; margin-bottom: 16px; font-size: 1.25em; font-weight: 600; line-height: 1.25; color: rgb(36, 41, 46); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Helvetica, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;; background-color: rgb(255, 255, 255);">API Methods</h3><ul style="padding-left: 2em; margin-bottom: 16px; color: rgb(36, 41, 46); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Helvetica, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;; background-color: rgb(255, 255, 255);"><li>address<ul style="padding-left: 2em;"><li>zipCode</li><li style="margin-top: 0.25em;">zipCodeByState</li><li style="margin-top: 0.25em;">city</li><li style="margin-top: 0.25em;">cityPrefix</li><li style="margin-top: 0.25em;">citySuffix</li><li style="margin-top: 0.25em;">streetName</li><li style="margin-top: 0.25em;">streetAddress</li><li style="margin-top: 0.25em;">streetSuffix</li><li style="margin-top: 0.25em;">streetPrefix</li><li style="margin-top: 0.25em;">secondaryAddress</li><li style="margin-top: 0.25em;">county</li><li style="margin-top: 0.25em;">country</li><li style="margin-top: 0.25em;">countryCode</li><li style="margin-top: 0.25em;">state</li><li style="margin-top: 0.25em;">stateAbbr</li><li style="margin-top: 0.25em;">latitude</li><li style="margin-top: 0.25em;">longitude</li><li style="margin-top: 0.25em;">direction</li><li style="margin-top: 0.25em;">cardinalDirection</li><li style="margin-top: 0.25em;">ordinalDirection</li><li style="margin-top: 0.25em;">nearbyGPSCoordinate</li><li style="margin-top: 0.25em;">timeZone</li></ul></li><li style="margin-top: 0.25em;">commerce<ul style="padding-left: 2em;"><li>color</li><li style="margin-top: 0.25em;">department</li><li style="margin-top: 0.25em;">productName</li><li style="margin-top: 0.25em;">price</li><li style="margin-top: 0.25em;">productAdjective</li><li style="margin-top: 0.25em;">productMaterial</li><li style="margin-top: 0.25em;">product</li><li style="margin-top: 0.25em;">productDescription</li></ul></li><li style="margin-top: 0.25em;">company<ul style="padding-left: 2em;"><li>suffixes</li><li style="margin-top: 0.25em;">companyName</li><li style="margin-top: 0.25em;">companySuffix</li><li style="margin-top: 0.25em;">catchPhrase</li><li style="margin-top: 0.25em;">bs</li><li style="margin-top: 0.25em;">catchPhraseAdjective</li><li style="margin-top: 0.25em;">catchPhraseDescriptor</li><li style="margin-top: 0.25em;">catchPhraseNoun</li><li style="margin-top: 0.25em;">bsAdjective</li><li style="margin-top: 0.25em;">bsBuzz</li><li style="margin-top: 0.25em;">bsNoun</li></ul></li><li style="margin-top: 0.25em;">database<ul style="padding-left: 2em;"><li>column</li><li style="margin-top: 0.25em;">type</li><li style="margin-top: 0.25em;">collation</li><li style="margin-top: 0.25em;">engine</li></ul></li><li style="margin-top: 0.25em;">date<ul style="padding-left: 2em;"><li>past</li><li style="margin-top: 0.25em;">future</li><li style="margin-top: 0.25em;">between</li><li style="margin-top: 0.25em;">recent</li><li style="margin-top: 0.25em;">soon</li><li style="margin-top: 0.25em;">month</li><li style="margin-top: 0.25em;">weekday</li></ul></li><li style="margin-top: 0.25em;">fake</li><li style="margin-top: 0.25em;">finance<ul style="padding-left: 2em;"><li>account</li><li style="margin-top: 0.25em;">accountName</li><li style="margin-top: 0.25em;">routingNumber</li><li style="margin-top: 0.25em;">mask</li><li style="margin-top: 0.25em;">amount</li><li style="margin-top: 0.25em;">transactionType</li><li style="margin-top: 0.25em;">currencyCode</li><li style="margin-top: 0.25em;">currencyName</li><li style="margin-top: 0.25em;">currencySymbol</li><li style="margin-top: 0.25em;">bitcoinAddress</li><li style="margin-top: 0.25em;">litecoinAddress</li><li style="margin-top: 0.25em;">creditCardNumber</li><li style="margin-top: 0.25em;">creditCardCVV</li><li style="margin-top: 0.25em;">ethereumAddress</li><li style="margin-top: 0.25em;">iban</li><li style="margin-top: 0.25em;">bic</li><li style="margin-top: 0.25em;">transactionDescription</li></ul></li><li style="margin-top: 0.25em;">git<ul style="padding-left: 2em;"><li>branch</li><li style="margin-top: 0.25em;">commitEntry</li><li style="margin-top: 0.25em;">commitMessage</li><li style="margin-top: 0.25em;">commitSha</li><li style="margin-top: 0.25em;">shortSha</li></ul></li><li style="margin-top: 0.25em;">hacker<ul style="padding-left: 2em;"><li>abbreviation</li><li style="margin-top: 0.25em;">adjective</li><li style="margin-top: 0.25em;">noun</li><li style="margin-top: 0.25em;">verb</li><li style="margin-top: 0.25em;">ingverb</li><li style="margin-top: 0.25em;">phrase</li></ul></li><li style="margin-top: 0.25em;">helpers<ul style="padding-left: 2em;"><li>randomize</li><li style="margin-top: 0.25em;">slugify</li><li style="margin-top: 0.25em;">replaceSymbolWithNumber</li><li style="margin-top: 0.25em;">replaceSymbols</li><li style="margin-top: 0.25em;">replaceCreditCardSymbols</li><li style="margin-top: 0.25em;">repeatString</li><li style="margin-top: 0.25em;">regexpStyleStringParse</li><li style="margin-top: 0.25em;">shuffle</li><li style="margin-top: 0.25em;">mustache</li><li style="margin-top: 0.25em;">createCard</li><li style="margin-top: 0.25em;">contextualCard</li><li style="margin-top: 0.25em;">userCard</li><li style="margin-top: 0.25em;">createTransaction</li></ul></li><li style="margin-top: 0.25em;">image<ul style="padding-left: 2em;"><li>image</li><li style="margin-top: 0.25em;">avatar</li><li style="margin-top: 0.25em;">imageUrl</li><li style="margin-top: 0.25em;">abstract</li><li style="margin-top: 0.25em;">animals</li><li style="margin-top: 0.25em;">business</li><li style="margin-top: 0.25em;">cats</li><li style="margin-top: 0.25em;">city</li><li style="margin-top: 0.25em;">food</li><li style="margin-top: 0.25em;">nightlife</li><li style="margin-top: 0.25em;">fashion</li><li style="margin-top: 0.25em;">people</li><li style="margin-top: 0.25em;">nature</li><li style="margin-top: 0.25em;">sports</li><li style="margin-top: 0.25em;">technics</li><li style="margin-top: 0.25em;">transport</li><li style="margin-top: 0.25em;">dataUri</li><li style="margin-top: 0.25em;">lorempixel</li><li style="margin-top: 0.25em;">unsplash</li><li style="margin-top: 0.25em;">lorempicsum</li></ul></li><li style="margin-top: 0.25em;">internet<ul style="padding-left: 2em;"><li>avatar</li><li style="margin-top: 0.25em;">email</li><li style="margin-top: 0.25em;">exampleEmail</li><li style="margin-top: 0.25em;">userName</li><li style="margin-top: 0.25em;">protocol</li><li style="margin-top: 0.25em;">url</li><li style="margin-top: 0.25em;">domainName</li><li style="margin-top: 0.25em;">domainSuffix</li><li style="margin-top: 0.25em;">domainWord</li><li style="margin-top: 0.25em;">ip</li><li style="margin-top: 0.25em;">ipv6</li><li style="margin-top: 0.25em;">userAgent</li><li style="margin-top: 0.25em;">color</li><li style="margin-top: 0.25em;">mac</li><li style="margin-top: 0.25em;">password</li></ul></li><li style="margin-top: 0.25em;">lorem<ul style="padding-left: 2em;"><li>word</li><li style="margin-top: 0.25em;">words</li><li style="margin-top: 0.25em;">sentence</li><li style="margin-top: 0.25em;">slug</li><li style="margin-top: 0.25em;">sentences</li><li style="margin-top: 0.25em;">paragraph</li><li style="margin-top: 0.25em;">paragraphs</li><li style="margin-top: 0.25em;">text</li><li style="margin-top: 0.25em;">lines</li></ul></li><li style="margin-top: 0.25em;">music<ul style="padding-left: 2em;"><li>genre</li></ul></li><li style="margin-top: 0.25em;">name<ul style="padding-left: 2em;"><li>firstName</li><li style="margin-top: 0.25em;">lastName</li><li style="margin-top: 0.25em;">findName</li><li style="margin-top: 0.25em;">jobTitle</li><li style="margin-top: 0.25em;">gender</li><li style="margin-top: 0.25em;">prefix</li><li style="margin-top: 0.25em;">suffix</li><li style="margin-top: 0.25em;">title</li><li style="margin-top: 0.25em;">jobDescriptor</li><li style="margin-top: 0.25em;">jobArea</li><li style="margin-top: 0.25em;">jobType</li></ul></li><li style="margin-top: 0.25em;">phone<ul style="padding-left: 2em;"><li>phoneNumber</li><li style="margin-top: 0.25em;">phoneNumberFormat</li><li style="margin-top: 0.25em;">phoneFormats</li></ul></li><li style="margin-top: 0.25em;">random<ul style="padding-left: 2em;"><li>number</li><li style="margin-top: 0.25em;">float</li><li style="margin-top: 0.25em;">arrayElement</li><li style="margin-top: 0.25em;">arrayElements</li><li style="margin-top: 0.25em;">objectElement</li><li style="margin-top: 0.25em;">uuid</li><li style="margin-top: 0.25em;">boolean</li><li style="margin-top: 0.25em;">word</li><li style="margin-top: 0.25em;">words</li><li style="margin-top: 0.25em;">image</li><li style="margin-top: 0.25em;">locale</li><li style="margin-top: 0.25em;">alpha</li><li style="margin-top: 0.25em;">alphaNumeric</li><li style="margin-top: 0.25em;">hexaDecimal</li></ul></li><li style="margin-top: 0.25em;">system<ul style="padding-left: 2em;"><li>fileName</li><li style="margin-top: 0.25em;">commonFileName</li><li style="margin-top: 0.25em;">mimeType</li><li style="margin-top: 0.25em;">commonFileType</li><li style="margin-top: 0.25em;">commonFileExt</li><li style="margin-top: 0.25em;">fileType</li><li style="margin-top: 0.25em;">fileExt</li><li style="margin-top: 0.25em;">directoryPath</li><li style="margin-top: 0.25em;">filePath</li><li style="margin-top: 0.25em;">semver</li></ul></li><li style="margin-top: 0.25em;">time<ul style="padding-left: 2em;"><li>recent</li></ul></li><li style="margin-top: 0.25em;">unique</li><li style="margin-top: 0.25em;">vehicle<ul style="padding-left: 2em;"><li>vehicle</li><li style="margin-top: 0.25em;">manufacturer</li><li style="margin-top: 0.25em;">model</li><li style="margin-top: 0.25em;">type</li><li style="margin-top: 0.25em;">fuel</li><li style="margin-top: 0.25em;">vin</li><li style="margin-top: 0.25em;">color</li></ul></li></ul>Fake data javascript lib	d52b8400-5e92-11ec-bf63-0242ac130002	2022-01-05 16:29:51.342	2022-01-09 15:48:55.717	ACTIVE
0f17b440-d0bd-46f5-b55c-466f6bfa6872	Ideas 	Ideas I'm thinking  of	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-26 12:17:57.439	2021-12-31 06:23:17.617	ACTIVE
1e03da52-beb3-4865-9a5d-12058f032b0a	releaser	https://github.com/veritem/releaser	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 19:28:54.202	2021-12-25 19:41:22.689	ACTIVE
b7e70836-de22-4bc5-8429-e7694fcff079	pac 	https://github.com/veritem/pac	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-28 18:29:59.696	2022-02-05 19:33:28.996	ACTIVE
d39cae43-ae81-4233-8110-8b3fbfc90eaa	ansu website		d52b8400-5e92-11ec-bf63-0242ac130002	2022-01-09 15:55:13.017	2022-01-09 15:56:48.287	ACTIVE
a8641a68-f98b-41de-9893-8819f13ab389	Weekly		d52b8400-5e92-11ec-bf63-0242ac130002	2022-02-05 19:19:25.162	2022-02-05 19:33:32.82	ACTIVE
4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	piste	This app im building	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-16 17:09:13.546	2022-02-05 19:34:49.895	ACTIVE
3958653c-e9c7-4129-84f1-65854a69428d	rudi 	<div>Typescript package development<br></div>https://github.com/veritem/releaser	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 19:41:17.734	2021-12-25 19:42:09.697	ACTIVE
3ac3f771-9562-4193-99a0-a2c67359748a	resume	personal online resume	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 20:07:53.681	2021-12-25 20:07:53.681	ACTIVE
74075aa7-769b-453d-8bd6-bb3489856210	GTS 	Github profile analyzer	d52b8400-5e92-11ec-bf63-0242ac130002	2021-12-25 12:47:57.879	2021-12-25 20:08:04.993	ACTIVE
ba1b0ee5-84b5-40d6-946f-9a7c7ec64949	alc		d52b8400-5e92-11ec-bf63-0242ac130002	2022-01-15 13:22:50.847	2022-01-15 15:17:39.124	ACTIVE
\.


--
-- Data for Name: Strike; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Strike" (id, "createdAt", "updatedAt", days, "habitId", name, description) FROM stdin;
3e02b89f-e708-4d0c-8980-6f66e3608ea2	2022-02-03 13:41:32.311+00	2022-02-03 13:41:32.311	{Monday,Wednesday,Thursday,Tuesday,Friday,Saturday}	aa3c494f-368c-407a-b425-c32fb1961b34	Study everytime in the evening 	\N
7164a90a-720e-42e2-8019-d82beeb7acc4	2022-02-03 13:41:54.711+00	2022-02-03 13:41:54.711	{Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday}	aa3c494f-368c-407a-b425-c32fb1961b34	Read class materials 	\N
f742531d-f634-46e7-a3e8-bd0be51b7737	2022-02-03 13:49:55.096+00	2022-02-03 13:49:55.097	{Monday,Wednesday}	aa3c494f-368c-407a-b425-c32fb1961b34	mmmm	\N
e62c8f25-a47b-42e0-8fc7-ff60619979d0	2022-02-03 13:51:34.036+00	2022-02-03 13:51:34.037	{Monday}	aa3c494f-368c-407a-b425-c32fb1961b34	Distinctio Ut tempo	\N
d9c340ae-a10f-4f03-beb9-b404d70e0835	2022-02-03 13:52:25.908+00	2022-02-03 13:52:25.909	{Monday,Thursday}	aa3c494f-368c-407a-b425-c32fb1961b34	Culpa non aspernatur	\N
\.


--
-- Data for Name: Task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Task" (id, name, "projectId", "createdAt", "updatedAt", completed, "Sheduled", "userId") FROM stdin;
062b7fef-2316-4baf-aee9-557b5ef50067	Fix modal component issue	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2021-12-16 17:13:10.403	2021-12-16 17:13:10.404	f	2021-12-17 19:27:29	d52b8400-5e92-11ec-bf63-0242ac130002
23c3823f-c53c-4fc0-8101-f33b1d1745e4	add delete and edit buttons	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2021-12-16 17:12:11.209	2021-12-16 17:12:11.21	f	2021-12-16 19:27:49	d52b8400-5e92-11ec-bf63-0242ac130002
608a6b59-724f-41fe-95fa-212861120e00	Fix the dataloss issue	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2021-12-16 17:09:47.545	2021-12-16 17:09:47.546	f	2021-12-18 19:27:53	d52b8400-5e92-11ec-bf63-0242ac130002
53ab7dfb-cf95-445b-a790-d82c8a843ca7	Follow this template https://jamesclear.s3.amazonaws.com/Habits+Course/Habit+Tracker.pdf	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2021-12-19 14:54:56.974	2021-12-19 14:54:56.974	f	2021-12-20 14:54:57.014	d52b8400-5e92-11ec-bf63-0242ac130002
8f12f434-fc5a-4bf1-8f57-de3e96f7ebfd	Github wrapped for a partcular profile	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2021-12-25 12:48:20.325	2021-12-25 12:48:20.325	f	2021-12-26 12:48:20.364	d52b8400-5e92-11ec-bf63-0242ac130002
724a9585-9b14-4c8a-a1ed-bd2d42e41bfb	study about how go releaser work	1e03da52-beb3-4865-9a5d-12058f032b0a	2021-12-25 19:30:42.761	2021-12-25 19:30:42.762	f	2021-12-26 19:30:42.8	d52b8400-5e92-11ec-bf63-0242ac130002
8a438cb8-cb02-40a8-abd8-a04cd7d0b1f3	https://github.com/vitest-dev/vitest/tree/main/test/svelte/test	0f17b440-d0bd-46f5-b55c-466f6bfa6872	2021-12-26 12:18:10.121	2021-12-26 12:18:10.122	f	2021-12-27 12:18:10.16	d52b8400-5e92-11ec-bf63-0242ac130002
6ee09f39-0c50-4a41-a011-47f71a201c0a	https://github.com/vitest-dev/vitest/tree/main/test/svelte/test	0f17b440-d0bd-46f5-b55c-466f6bfa6872	2021-12-26 12:18:11.367	2021-12-26 12:18:11.368	f	2021-12-27 12:18:11.406	d52b8400-5e92-11ec-bf63-0242ac130002
100cbaa3-3cd2-4a30-892c-9328ed6f18d0	Nodejs live repl	0f17b440-d0bd-46f5-b55c-466f6bfa6872	2021-12-27 11:34:50.603	2021-12-27 11:34:50.603	f	2021-12-28 11:34:50.642	d52b8400-5e92-11ec-bf63-0242ac130002
c7691aa3-8979-41b6-a074-671bd4ba543f	current adress browser extension 	0f17b440-d0bd-46f5-b55c-466f6bfa6872	2021-12-31 06:23:14.16	2021-12-31 06:23:14.16	f	2022-01-01 06:23:14.199	d52b8400-5e92-11ec-bf63-0242ac130002
cae17b27-04a3-4385-b1f6-0fabdf86d880	rust prisma client	0f17b440-d0bd-46f5-b55c-466f6bfa6872	2022-01-02 08:23:26.202	2022-01-02 08:23:26.202	f	2022-01-03 08:23:26.241	d52b8400-5e92-11ec-bf63-0242ac130002
80df15c1-f4bf-48c3-a4fb-45aba411bfd3	> https://github.com/railwayapp/starters/tree/master/examples/rust-wasm	940c5e3e-f4af-4af5-acc6-117680d7c19b	2022-01-02 16:26:30.961	2022-01-02 16:26:30.962	f	2022-01-03 16:26:31	d52b8400-5e92-11ec-bf63-0242ac130002
13d96374-9a41-4838-8920-a7a31df9e874	Make projects page in the center and projects should open when clicked in form of a modal	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2022-01-02 16:29:00.848	2022-01-02 16:29:00.848	f	2022-01-03 16:29:00.887	d52b8400-5e92-11ec-bf63-0242ac130002
ca84c60a-9ae5-47d4-9ba0-93aa1be81df4	adding notes on the current strike	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2022-01-09 15:54:43.153	2022-01-09 15:54:43.154	f	2022-01-10 15:54:43.192	d52b8400-5e92-11ec-bf63-0242ac130002
6dcc76e4-367d-4ecb-ae2c-fc143a24ae48	Add option to change the status of the project	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2022-01-09 15:54:55.52	2022-01-09 15:54:55.521	f	2022-01-10 15:54:55.559	d52b8400-5e92-11ec-bf63-0242ac130002
16245237-fa47-4193-9058-3eba1146fcfd	use invalidate feature of svelte-kit	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2022-01-09 15:55:48.42	2022-01-09 15:55:48.42	f	2022-01-10 15:55:48.459	d52b8400-5e92-11ec-bf63-0242ac130002
cd0ba77a-c385-498f-83cd-7bdd7ed677c1	ansumana's website	d39cae43-ae81-4233-8110-8b3fbfc90eaa	2022-01-09 15:56:05.81	2022-01-09 15:56:05.811	f	2022-01-10 15:56:05.849	d52b8400-5e92-11ec-bf63-0242ac130002
1e4dae04-38ab-4379-b09d-5abbdb0a5f0e	use this website as reference https://www.ahmedkonneh.net/	d39cae43-ae81-4233-8110-8b3fbfc90eaa	2022-01-09 15:56:28.681	2022-01-09 15:56:28.682	f	2022-01-10 15:56:28.72	d52b8400-5e92-11ec-bf63-0242ac130002
e3a53e61-e804-4e1b-a1d6-3e84d83183da	Updating user	ba1b0ee5-84b5-40d6-946f-9a7c7ec64949	2022-01-15 13:23:08.895	2022-01-15 13:23:08.896	f	2022-01-16 13:23:08.934	d52b8400-5e92-11ec-bf63-0242ac130002
fe4a52b2-0aa8-4d88-b834-31932d621b15	Creating user	ba1b0ee5-84b5-40d6-946f-9a7c7ec64949	2022-01-15 13:23:18.254	2022-01-15 13:23:18.255	f	2022-01-16 13:23:18.293	d52b8400-5e92-11ec-bf63-0242ac130002
f4b1c739-fac0-4b11-aa75-6623bab798c6	Deleting user	ba1b0ee5-84b5-40d6-946f-9a7c7ec64949	2022-01-15 13:23:29.194	2022-01-15 13:23:29.195	f	2022-01-16 13:23:29.233	d52b8400-5e92-11ec-bf63-0242ac130002
90a6994d-1d1e-4625-b041-a813b46f029c	creating announcement 	ba1b0ee5-84b5-40d6-946f-9a7c7ec64949	2022-01-15 13:24:19.692	2022-01-15 13:24:19.692	f	2022-01-16 13:24:19.731	d52b8400-5e92-11ec-bf63-0242ac130002
ff232c12-71b7-4d63-86e3-daea1d5b6654	updating announcement	ba1b0ee5-84b5-40d6-946f-9a7c7ec64949	2022-01-15 13:24:27.474	2022-01-15 13:24:27.475	f	2022-01-16 13:24:27.513	d52b8400-5e92-11ec-bf63-0242ac130002
13dc08ec-8eb3-4acb-b12e-6d5b007bdc93	creating high school	ba1b0ee5-84b5-40d6-946f-9a7c7ec64949	2022-01-15 13:24:45.462	2022-01-15 13:24:45.463	f	2022-01-16 13:24:45.502	d52b8400-5e92-11ec-bf63-0242ac130002
5af5065f-5640-4eb1-83c4-50b8bf59af12	updating high school 	ba1b0ee5-84b5-40d6-946f-9a7c7ec64949	2022-01-15 13:24:52.231	2022-01-15 13:24:52.231	f	2022-01-16 13:24:52.27	d52b8400-5e92-11ec-bf63-0242ac130002
7c601cdd-f647-4e12-9990-393f60296da0	Exporting users, summer programs, announcements	ba1b0ee5-84b5-40d6-946f-9a7c7ec64949	2022-01-15 13:25:22.983	2022-01-15 13:25:22.983	f	2022-01-16 13:25:23.022	d52b8400-5e92-11ec-bf63-0242ac130002
04baf822-520a-4c01-b4d7-1781739b06c6	https://github.com/fouita/tailwind-editor	4b8f9f2e-f6b9-45d6-8e2a-f3e5989f717b	2022-02-05 19:34:20.206	2022-02-05 19:34:20.207	f	2022-02-06 19:34:20.245	d52b8400-5e92-11ec-bf63-0242ac130002
eb9a1e07-40c3-475a-813f-5216d64b8f4d	https://github.com/railwayapp/starters/tree/master/examples/rust-wasm	940c5e3e-f4af-4af5-acc6-117680d7c19b	2022-01-02 16:26:29.977	2022-01-02 16:26:29.978	f	2022-01-03 16:26:30.016	d52b8400-5e92-11ec-bf63-0242ac130002
fd01d985-612b-4471-b14f-a57b91410dc8	Finish scam project	a8641a68-f98b-41de-9893-8819f13ab389	2022-02-05 19:19:56.046	2022-02-06 08:52:45.352	f	2022-02-06 19:19:56.085	d52b8400-5e92-11ec-bf63-0242ac130002
a1730c96-fdc6-4334-bfb4-7cc367a9bbd6	Consistently prepare for next weeks cats by reading math and Phsyics daily	a8641a68-f98b-41de-9893-8819f13ab389	2022-02-05 19:20:47.054	2022-03-02 09:56:04.433	f	2022-02-06 19:20:47.093	d52b8400-5e92-11ec-bf63-0242ac130002
5bdec102-e690-4467-afe9-ba13db2bc8a3	Finish telp tabs and execution 	a8641a68-f98b-41de-9893-8819f13ab389	2022-02-05 19:21:31.156	2022-02-06 08:52:44.331	f	2022-02-06 19:21:31.195	d52b8400-5e92-11ec-bf63-0242ac130002
f67732da-dca0-46cd-8a21-4396c572d82d	finish uploading practice tests for alc	a8641a68-f98b-41de-9893-8819f13ab389	2022-02-05 19:25:25.49	2022-02-06 08:52:43.271	f	2022-02-06 19:25:25.529	d52b8400-5e92-11ec-bf63-0242ac130002
636e4ca1-7508-470e-b33f-536cae8f74c2	improve editor expressience on piste	a8641a68-f98b-41de-9893-8819f13ab389	2022-02-05 19:33:53.356	2022-02-06 15:09:15.504	f	2022-02-06 19:33:53.395	d52b8400-5e92-11ec-bf63-0242ac130002
d9d704b3-7634-413d-b116-0dd77e22c11b	base 64 encoder	4787f30d-799f-4058-886e-a6214f8f63d8	2022-02-08 11:47:19.467	2022-02-08 11:47:19.467	f	2022-02-09 11:47:19.505	d52b8400-5e92-11ec-bf63-0242ac130002
c23f71a4-154f-44aa-a560-ec61a5d093c4	Faker data generator	4787f30d-799f-4058-886e-a6214f8f63d8	2022-02-08 11:47:32.021	2022-02-08 11:47:32.021	f	2022-02-09 11:47:32.059	d52b8400-5e92-11ec-bf63-0242ac130002
8e96d65d-275c-455e-82da-a0ce5a3bfa4f	date timestamp convertor	4787f30d-799f-4058-886e-a6214f8f63d8	2022-02-08 11:47:45.372	2022-02-08 11:47:45.372	f	2022-02-09 11:47:45.41	d52b8400-5e92-11ec-bf63-0242ac130002
9dda9959-09c4-48b4-87e2-689b160d6ed7	URl encoder	4787f30d-799f-4058-886e-a6214f8f63d8	2022-02-08 11:47:57.156	2022-02-08 11:47:57.156	f	2022-02-09 11:47:57.195	d52b8400-5e92-11ec-bf63-0242ac130002
702b3061-6eaf-4f1c-9811-29d5e2957679	RGB to hsl	4787f30d-799f-4058-886e-a6214f8f63d8	2022-02-08 11:48:09.2	2022-02-08 11:48:09.2	f	2022-02-09 11:48:09.238	d52b8400-5e92-11ec-bf63-0242ac130002
b6e89e35-dafe-4d89-b073-8679ab93e979	JSON to csv convertor	4787f30d-799f-4058-886e-a6214f8f63d8	2022-02-08 11:48:23.433	2022-02-08 11:48:23.434	f	2022-02-09 11:48:23.471	d52b8400-5e92-11ec-bf63-0242ac130002
12d7cf13-3396-4362-8ef2-0802a69c44cf	UUID generator	4787f30d-799f-4058-886e-a6214f8f63d8	2022-02-08 11:48:36.268	2022-02-08 11:48:36.269	f	2022-02-09 11:48:36.307	d52b8400-5e92-11ec-bf63-0242ac130002
9c6580ab-a23e-4c00-ab0f-6cc579674039	Write tests for alc web backend to do crud for users 	a8641a68-f98b-41de-9893-8819f13ab389	2022-02-05 19:27:14.908	2022-03-02 09:55:25.612	f	2022-02-06 19:27:14.947	d52b8400-5e92-11ec-bf63-0242ac130002
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, uid, "createdAt", "updatedAt", name, username) FROM stdin;
d52b8400-5e92-11ec-bf63-0242ac130002	2f5d3c63-37f9-4a59-86d2-476a0d530c27	2021-12-16 17:08:55.78	2021-12-08 19:08:20	Makuza Mugabo Verite	veritem
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
950c24fd-1e1d-48e9-aa36-0d01f04af789	80ed427dcab71b67df42221ca86242e37249f1e07fcd3c07e22a7d9521a4472e	2021-12-29 18:30:43.929648+00	20211229183037_remove_description	\N	\N	2021-12-29 18:30:42.497896+00	1
c4485b0f-d478-451e-b5fc-ce8d61f4d758	5c736f8c843314f5043cf020d3e1a261acfd1a7ce8a7d24ecccb6d0a75570448	2021-12-16 16:58:29.855327+00	20211120232646_init	\N	\N	2021-12-16 16:58:28.796304+00	1
3db071ba-daae-476a-90dd-a9240fbd4046	47b23a33cc56dd43788d9c597523d32eb76b4058ca4a3c9d36f1695b55d07019	2021-12-16 16:58:31.696923+00	20211124073411_setup	\N	\N	2021-12-16 16:58:30.668802+00	1
f18f691a-59ae-40a7-98d3-b36c411ce6b1	9a8298e82bfb469d9d56d0433c40465bbf177c8f2a2b68a6f7bfc748e6074663	2021-12-16 16:58:33.128613+00	20211126065151_update_task_model	\N	\N	2021-12-16 16:58:32.107292+00	1
e42c002b-be2c-4b11-9d6a-45e0c432c5b5	82c7e1cc696ab3b13bec99f8d5adfcf725b3aa9b7af824b847eaef8d6e53681c	2022-03-02 12:30:49.964566+00	20220302123039_add_status_to_projects	\N	\N	2022-03-02 12:30:48.346333+00	1
1f2130f7-2fe5-4aef-b3b5-69288bbf0cfe	690ca144acbc05f8d089013e59f3b85f6826afafdaa7ec670f9d80e890cf8233	2021-12-16 16:58:34.938949+00	20211129101600_fix_delete_projects_tasks	\N	\N	2021-12-16 16:58:33.536441+00	1
99137fcf-063b-4d21-b43e-a8afc19b677b	268c2323b570b3a43c4d3c169bafdfc17ec670369e85b725a131c364c88e5f02	2021-12-16 16:58:36.41112+00	20211130175931_user_id	\N	\N	2021-12-16 16:58:35.402377+00	1
fc0ec21b-f09d-4551-aee9-3c126c95eff9	fbcb0046894f265f72964641e56a96eb67ee83e4ad96ada18ec71d554eef0056	2021-12-16 16:58:37.833886+00	20211202210216_fix_tasks	\N	\N	2021-12-16 16:58:36.814751+00	1
91122e89-b291-41a7-8400-ea4ac13c4610	337b14b69e7d7bccc04dd00ecdfd136626af64af65d157bac63760a7cc19a09c	2021-12-16 16:58:39.271345+00	20211204232832_schedule_for_tasks	\N	\N	2021-12-16 16:58:38.24878+00	1
0fa03b40-c67b-4aa6-b001-0a3d1a707552	e6d61c7577ad7bfcc8448712939316a28e8b75b42deacade1eb662ccba08b44f	2021-12-16 16:58:40.704096+00	20211215130512_fix_strikes	\N	\N	2021-12-16 16:58:39.679317+00	1
92b0d9b1-385a-4a5e-a363-563ead42cce9	6dc395ba4adaa405411be56ae1f78ce62b232c913dcfb616821bbfe508b70717	2021-12-16 16:58:42.211103+00	20211216165218_added_user_on_task_table	\N	\N	2021-12-16 16:58:41.218482+00	1
aed11171-6ca5-46c5-b5b1-abd923f227e2	6e0f353f7764c322e5b70dbc22b147b7b1d9c0c538f249321cb90bde3607dd00	2021-12-16 16:59:12.964862+00	20211216165907_added_user_on_task	\N	\N	2021-12-16 16:59:11.789802+00	1
064b1a0d-496c-4ef6-a586-079492ab9854	91beeb3e655a8dccf9e618a713ba9d5dbed82ecab5e66b2bbb9ef685551dfb6e	2021-12-16 17:27:11.372188+00	20211216172706_add_suppot_for_task_scheduling	\N	\N	2021-12-16 17:27:10.52266+00	1
c379cf36-1c7b-469e-b1e6-139c68a8da65	8c1417a44bc60b9380275693b38f1bcbcb93e9dd3663a2d7b662ddd37a04a057	2021-12-16 17:29:18.697299+00	20211216172912_fix_date	\N	\N	2021-12-16 17:29:17.25828+00	1
8df48ec9-1ace-44e9-8481-0dd27352133e	59520e82ed21b6f1b811c37211db12ef656147f8eb0ae35a04fc6bf8fc321e8a	2021-12-16 17:31:39.602521+00	20211216173134_fix_date_thing	\N	\N	2021-12-16 17:31:38.578707+00	1
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2021-12-01 01:34:16
20211116045059	2021-12-01 01:34:16
20211116050929	2021-12-01 01:34:16
20211116051442	2021-12-01 01:34:16
20211116212300	2021-12-01 01:34:16
20211116213355	2021-12-01 01:34:16
20211116213934	2021-12-01 01:34:16
20211116214523	2021-12-01 01:34:16
20211122062447	2021-12-01 01:34:16
20211124070109	2021-12-01 01:34:16
20211202204204	2021-12-04 01:36:56
20211202204605	2021-12-04 01:36:56
20211210212804	2022-01-25 03:42:27
20220107221237	2022-01-25 03:42:27
20211228014915	2022-03-04 04:52:36
20220228202821	2022-03-04 04:52:36
20220312004840	2022-03-27 15:33:28
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2021-09-13 12:16:48.557861
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2021-09-13 12:16:48.560485
2	pathtoken-column	49756be03be4c17bb85fe70d4a861f27de7e49ad	2021-09-13 12:16:48.562531
3	add-migrations-rls	bb5d124c53d68635a883e399426c6a5a25fc893d	2021-09-13 12:16:48.651723
4	add-size-functions	6d79007d04f5acd288c9c250c42d2d5fd286c54d	2021-09-13 12:16:48.653804
5	change-column-name-in-get-size	fd65688505d2ffa9fbdc58a944348dd8604d688c	2021-09-13 12:16:48.656201
6	add-rls-to-buckets	63e2bab75a2040fee8e3fb3f15a0d26f3380e9b6	2021-09-13 12:16:48.658563
7	add-public-to-buckets	82568934f8a4d9e0a85f126f6fb483ad8214c418	2021-09-13 12:16:48.6606
8	fix-search-function	1a43a40eddb525f2e2f26efd709e6c06e58e059c	2021-11-30 09:26:58.263536
9	search-files-search-function	34c096597eb8b9d077fdfdde9878c88501b2fafc	2022-04-06 03:33:49.621454
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 152, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (provider, id);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: Activity Activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Activity"
    ADD CONSTRAINT "Activity_pkey" PRIMARY KEY (id);


--
-- Name: Habit Habit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Habit"
    ADD CONSTRAINT "Habit_pkey" PRIMARY KEY (id);


--
-- Name: Project Project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_pkey" PRIMARY KEY (id);


--
-- Name: Strike Strike_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Strike"
    ADD CONSTRAINT "Strike_pkey" PRIMARY KEY (id);


--
-- Name: Task Task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Task"
    ADD CONSTRAINT "Task_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_token_idx ON auth.refresh_tokens USING btree (token);


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: User_uid_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_uid_key" ON public."User" USING btree (uid);


--
-- Name: User_username_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_username_key" ON public."User" USING btree (username);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING hash (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_parent_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_parent_fkey FOREIGN KEY (parent) REFERENCES auth.refresh_tokens(token);


--
-- Name: Activity Activity_strikeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Activity"
    ADD CONSTRAINT "Activity_strikeId_fkey" FOREIGN KEY ("strikeId") REFERENCES public."Strike"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Habit Habit_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Habit"
    ADD CONSTRAINT "Habit_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Project Project_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Strike Strike_habitId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Strike"
    ADD CONSTRAINT "Strike_habitId_fkey" FOREIGN KEY ("habitId") REFERENCES public."Habit"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Task Task_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Task"
    ADD CONSTRAINT "Task_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Task Task_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Task"
    ADD CONSTRAINT "Task_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: buckets buckets_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: objects objects_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT ALL ON TABLE auth.audit_log_entries TO postgres;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.identities TO postgres;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT ALL ON TABLE auth.instances TO postgres;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT ALL ON TABLE auth.refresh_tokens TO postgres;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT ALL ON TABLE auth.schema_migrations TO postgres;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT ALL ON TABLE auth.users TO postgres;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE SCHEMA')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

