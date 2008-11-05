--
-- PostgreSQL database dump
--

-- Started on 2008-11-05 20:09:22 CET

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 1963 (class 1262 OID 16385)
-- Name: cms; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE cms WITH TEMPLATE = template0 ENCODING = 'UTF8';


\connect cms

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 367 (class 2612 OID 16388)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1539 (class 1259 OID 16389)
-- Dependencies: 1834 1835 1836 6
-- Name: acl; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE acl (
    object integer DEFAULT 0 NOT NULL,
    permission integer DEFAULT 0 NOT NULL,
    role integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 1540 (class 1259 OID 16395)
-- Dependencies: 1837 1838 6
-- Name: clients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clients (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    website character varying(255),
    market_symbol character varying(10),
    employees integer DEFAULT 0 NOT NULL,
    owner character varying(255),
    type smallint,
    trade smallint,
    update_time timestamp without time zone,
    creation_time timestamp without time zone DEFAULT now() NOT NULL,
    phone1 character varying(20),
    fax1 character varying(20),
    phone2 character varying(20),
    fax2 character varying(20),
    email1 character varying(50),
    email2 character varying(50),
    evaluation character varying(30),
    yearly_income integer,
    permission_to_send_mail boolean,
    notifications_to_client boolean,
    description text,
    invoice_address character varying(255),
    invoice_pobox character varying(255),
    invoice_city character varying(255),
    invoice_district character varying(100),
    invoice_postal_number character varying(30),
    invoice_country character varying(50),
    sending_address character varying(255),
    sending_pobox character varying(255),
    sending_city character varying(255),
    sending_district character varying(100),
    sending_postal_number character varying(30),
    sending_country character varying(50)
);


--
-- TOC entry 1541 (class 1259 OID 16403)
-- Dependencies: 6
-- Name: clients_users_bindings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clients_users_bindings (
);


--
-- TOC entry 1542 (class 1259 OID 16406)
-- Dependencies: 1840 1841 1842 1843 6
-- Name: document_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE document_files (
    object integer DEFAULT 0 NOT NULL,
    filename character varying(100) NOT NULL,
    title character varying(150) NOT NULL,
    description text,
    downloads integer DEFAULT 0 NOT NULL,
    private boolean DEFAULT true NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    id integer NOT NULL
);


--
-- TOC entry 1543 (class 1259 OID 16416)
-- Dependencies: 1845 1846 1847 1848 1849 6
-- Name: document_pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE document_pages (
    object integer DEFAULT 0 NOT NULL,
    title text,
    description text,
    body text,
    sort integer DEFAULT 0 NOT NULL,
    views integer DEFAULT 0 NOT NULL,
    modified timestamp without time zone DEFAULT now(),
    created timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL
);


--
-- TOC entry 1544 (class 1259 OID 16427)
-- Dependencies: 1851 1852 1853 1854 1855 6
-- Name: gallery_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gallery_images (
    id integer NOT NULL,
    title character varying(255),
    description text,
    votes integer DEFAULT 0 NOT NULL,
    tags character varying(255),
    picture_path text,
    owner integer DEFAULT 0 NOT NULL,
    comments integer DEFAULT 0 NOT NULL,
    object integer DEFAULT 0 NOT NULL,
    creation_date timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1545 (class 1259 OID 16438)
-- Dependencies: 6
-- Name: garbage_collection_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE garbage_collection_files (
    "fileLocation" text NOT NULL
);


--
-- TOC entry 1546 (class 1259 OID 16444)
-- Dependencies: 6
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages (
);


--
-- TOC entry 1547 (class 1259 OID 16447)
-- Dependencies: 6
-- Name: messages_flow; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages_flow (
);


--
-- TOC entry 1548 (class 1259 OID 16450)
-- Dependencies: 6
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
);


--
-- TOC entry 1549 (class 1259 OID 16453)
-- Dependencies: 6
-- Name: products_properties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products_properties (
);


--
-- TOC entry 1550 (class 1259 OID 16456)
-- Dependencies: 6
-- Name: products_propery_values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products_propery_values (
);


--
-- TOC entry 1551 (class 1259 OID 16459)
-- Dependencies: 1857 6
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    users integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 1552 (class 1259 OID 16466)
-- Dependencies: 6
-- Name: session; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE session (
    id character(32) NOT NULL,
    modified integer,
    lifetime integer,
    data text
);


--
-- TOC entry 1553 (class 1259 OID 16472)
-- Dependencies: 1859 1860 1861 1862 1863 1864 1865 1866 1867 1868 1869 1870 1871 1872 1873 1874 6
-- Name: site_objects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE site_objects (
    id integer NOT NULL,
    title character varying(160),
    description text,
    tags text,
    type smallint DEFAULT 0 NOT NULL,
    views integer DEFAULT 0,
    status boolean DEFAULT false NOT NULL,
    creation_time timestamp without time zone DEFAULT now() NOT NULL,
    edition_time timestamp without time zone,
    pages smallint DEFAULT 0 NOT NULL,
    topics integer DEFAULT 0 NOT NULL,
    posts integer DEFAULT 0 NOT NULL,
    images integer DEFAULT 0 NOT NULL,
    products integer DEFAULT 0 NOT NULL,
    files integer DEFAULT 0 NOT NULL,
    main_menu boolean DEFAULT true NOT NULL,
    support_menu boolean DEFAULT false NOT NULL,
    list_child_objects boolean DEFAULT false NOT NULL,
    allow_delete boolean DEFAULT true NOT NULL,
    publish_start timestamp without time zone,
    publish_end timestamp without time zone,
    owner integer DEFAULT 0 NOT NULL,
    parent_id integer,
    ordering integer,
    ordering_path text,
    tree_path text,
    comments integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 1554 (class 1259 OID 16494)
-- Dependencies: 6
-- Name: site_objects_tree; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE site_objects_tree (
    id integer NOT NULL,
    parent_id integer NOT NULL,
    child_id integer NOT NULL,
    depth integer NOT NULL
);


--
-- TOC entry 1555 (class 1259 OID 16497)
-- Dependencies: 6
-- Name: task_asignees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task_asignees (
);


--
-- TOC entry 1556 (class 1259 OID 16500)
-- Dependencies: 6
-- Name: task_steps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task_steps (
);


--
-- TOC entry 1557 (class 1259 OID 16503)
-- Dependencies: 6
-- Name: tasks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tasks (
);


--
-- TOC entry 1558 (class 1259 OID 16506)
-- Dependencies: 1877 1878 1879 1880 1881 1882 1883 1884 1885 1886 1887 1888 1889 1890 1891 1892 1893 1894 1895 6
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(32),
    status smallint DEFAULT 0 NOT NULL,
    email character varying(100) NOT NULL,
    last_logged_timestamp timestamp without time zone DEFAULT now(),
    last_logged_ip character varying(50),
    registered_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    registered_ip character varying(50),
    notes text,
    ident bigint DEFAULT (random() * (100000000000000::bigint)::double precision),
    avatar boolean DEFAULT false NOT NULL,
    gender_is_male boolean DEFAULT true NOT NULL,
    show_gender boolean DEFAULT true NOT NULL,
    birthday_date date,
    show_age integer DEFAULT 3 NOT NULL,
    warnings integer DEFAULT 0,
    im_gg character varying(50),
    im_icq character varying(50),
    im_aim character varying(50),
    im_skype character varying(50),
    im_tlen character varying(50),
    im_msn character varying(50),
    im_yahoo character varying(50),
    im_googletalk character varying(50),
    pm_read integer DEFAULT 0 NOT NULL,
    pm_new integer DEFAULT 0 NOT NULL,
    pm_sent integer DEFAULT 0 NOT NULL,
    pm_sketches integer DEFAULT 0 NOT NULL,
    friends integer DEFAULT 0 NOT NULL,
    signature text,
    config_topics_per_page integer DEFAULT 20 NOT NULL,
    config_posts_per_page integer DEFAULT 10 NOT NULL,
    config_add_signature boolean DEFAULT true NOT NULL,
    config_bookmark_topics boolean DEFAULT true NOT NULL,
    address character varying(255),
    tax_number character varying(30),
    city character varying(100),
    country character varying(10),
    company_phone character varying(30),
    mobile_phone character varying(30),
    private_phone character varying(30),
    district character varying(10),
    salutation character varying(10),
    company_title character varying(50),
    company_department character varying(50),
    assistant_name character varying(50),
    assistant_phone character varying(30),
    email_notifications boolean,
    do_not_call boolean DEFAULT false NOT NULL,
    supervisor_id integer,
    fax character varying(30),
    postal_number character varying(20)
);


--
-- TOC entry 1559 (class 1259 OID 16531)
-- Dependencies: 1897 1898 6
-- Name: users_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_roles (
    "user" integer DEFAULT 0 NOT NULL,
    role integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 20 (class 1255 OID 16536)
-- Dependencies: 367 6
-- Name: document_file_ad(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION document_file_ad() RETURNS trigger
    AS $$DECLARE
max_sort integer;
BEGIN

UPDATE document_files SET sort = sort-1 WHERE object = OLD.object AND sort > OLD.sort;
UPDATE site_objects SET files = files-1 WHERE id = OLD.object;

IF OLD.private = true THEN
INSERT INTO garbage_collection_files VALUES ('data/uploads/' || OLD.filename);
ELSE
INSERT INTO garbage_collection_files VALUES ('public/uploads/' || OLD.filename);
END IF;


RETURN OLD;
END$$
    LANGUAGE plpgsql;


--
-- TOC entry 21 (class 1255 OID 16537)
-- Dependencies: 367 6
-- Name: document_file_au(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION document_file_au() RETURNS trigger
    AS $$BEGIN

IF NEW.filename != OLD.filename THEN
	IF OLD.private = true THEN
	INSERT INTO garbage_collection_files VALUES ('Private/Files/' || OLD.filename);
	ELSE
	INSERT INTO garbage_collection_files VALUES ('Public/Files/' || OLD.filename);
	END IF;
END IF;
RETURN NEW;
END;$$
    LANGUAGE plpgsql;


--
-- TOC entry 22 (class 1255 OID 16538)
-- Dependencies: 367 6
-- Name: document_file_bi(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION document_file_bi() RETURNS trigger
    AS $$DECLARE
max_sort integer;
BEGIN

SELECT MAX(sort) INTO max_sort FROM document_files WHERE object = NEW.object;
IF (max_sort IS NULL) THEN max_sort = 0; END IF;
NEW.sort = max_sort + 1;
UPDATE site_objects SET files = files + 1 WHERE id = NEW.object;
RETURN NEW;
END$$
    LANGUAGE plpgsql;


--
-- TOC entry 23 (class 1255 OID 16539)
-- Dependencies: 367 6
-- Name: document_page_ad(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION document_page_ad() RETURNS trigger
    AS $$DECLARE
max_sort integer;
BEGIN

UPDATE document_pages SET sort = sort - 1 WHERE object = OLD.object AND sort > OLD.sort;
UPDATE site_objects SET pages = pages - 1 WHERE id = OLD.object;
RETURN OLD;

END$$
    LANGUAGE plpgsql;


--
-- TOC entry 24 (class 1255 OID 16540)
-- Dependencies: 6 367
-- Name: document_page_bi(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION document_page_bi() RETURNS trigger
    AS $$DECLARE
max_sort integer;
BEGIN

SELECT MAX(sort) INTO max_sort FROM document_pages WHERE object = NEW.object;
IF (max_sort IS NULL) THEN max_sort = 0; END IF;
NEW.sort = max_sort + 1;
UPDATE site_objects SET pages = pages + 1 WHERE id = NEW.object;
RETURN NEW;
END$$
    LANGUAGE plpgsql;


--
-- TOC entry 1966 (class 0 OID 0)
-- Dependencies: 24
-- Name: FUNCTION document_page_bi(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION document_page_bi() IS 'counts and updates document pages';


--
-- TOC entry 25 (class 1255 OID 16541)
-- Dependencies: 6 367
-- Name: move_object_down(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION move_object_down(integer) RETURNS boolean
    AS $_$DECLARE
so INTEGER;
par INTEGER;
maxsort INTEGER;
BEGIN
SELECT sort, parent INTO so, par FROM objects WHERE id = $1;
SELECT MAX(sort) INTO maxsort FROM objects WHERE parent = par;
IF (so < maxsort) THEN
UPDATE objects SET sort = sort - 1 WHERE parent = par AND sort = so + 1;
UPDATE objects SET sort = sort + 1 WHERE id = $1;
RETURN true; 
ELSE
RETURN false; 
END IF;
END$_$
    LANGUAGE plpgsql;


--
-- TOC entry 26 (class 1255 OID 16542)
-- Dependencies: 6 367
-- Name: move_object_up(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION move_object_up(integer) RETURNS boolean
    AS $_$DECLARE
so INTEGER;
par INTEGER;
BEGIN
SELECT sort, parent  INTO so, par FROM objects  WHERE id = $1;
IF (so > 1) THEN
UPDATE objects SET sort = sort + 1 WHERE parent = par AND sort = so - 1;
UPDATE objects SET sort = sort - 1 WHERE id = $1;
RETURN true; 
ELSE
RETURN false; 
END IF;
END$_$
    LANGUAGE plpgsql;


--
-- TOC entry 27 (class 1255 OID 16543)
-- Dependencies: 6 367
-- Name: move_page_down(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION move_page_down(integer) RETURNS boolean
    AS $_$DECLARE
so INTEGER;
par INTEGER;
maxsort INTEGER;
BEGIN
SELECT sort, object_id INTO so, par FROM document_pages WHERE id = $1;
SELECT MAX(sort) INTO maxsort FROM document_pages  WHERE object_id = par;
IF (so < maxsort) THEN
UPDATE document_pages SET sort = sort - 1 WHERE object_id = par AND sort = so + 1;
UPDATE document_pages SET sort = sort + 1 WHERE id = $1;
RETURN true; 
ELSE
RETURN false; 
END IF;
END$_$
    LANGUAGE plpgsql;


--
-- TOC entry 28 (class 1255 OID 16544)
-- Dependencies: 367 6
-- Name: move_page_up(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION move_page_up(integer) RETURNS boolean
    AS $_$DECLARE
so INTEGER;
par INTEGER;
BEGIN
SELECT sort, object_id  INTO so, par FROM document_pages  WHERE id = $1;
IF (so>1) THEN
UPDATE document_pages SET sort = sort + 1 WHERE object_id = par AND sort = so - 1;
UPDATE document_pages SET sort = sort - 1 WHERE id = $1;
RETURN true; 
ELSE
RETURN false; 
END IF;
END$_$
    LANGUAGE plpgsql;


--
-- TOC entry 29 (class 1255 OID 16545)
-- Dependencies: 6 367
-- Name: tree_objects_ai(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tree_objects_ai() RETURNS trigger
    AS $$DECLARE
BEGIN
-- http://www.depesz.com --

-- it inserts row, where both parent_id and child_id are set to the same value (id of newly inserted object), and depth is set to 0 (as both child and parent are on the same level) - easy serches later
INSERT INTO site_objects_tree (parent_id, child_id, depth) VALUES (NEW.id, NEW.id, 0);
-- we copy all rows that our parent had as its parents, but we modify child_id in these rows to be id of currently inserted row, and increase depth
INSERT INTO site_objects_tree (parent_id, child_id, depth) SELECT x.parent_id, NEW.id, x.depth + 1 FROM site_objects_tree x WHERE x.child_id = NEW.parent_id;

-- <insert>--
RETURN NEW;
END$$
    LANGUAGE plpgsql;


--
-- TOC entry 30 (class 1255 OID 16546)
-- Dependencies: 367 6
-- Name: tree_objects_au(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tree_objects_au() RETURNS trigger
    AS $$
DECLARE
BEGIN
IF NOT OLD.parent_id IS DISTINCT FROM NEW.parent_id THEN
RETURN NEW;
END IF;
IF OLD.parent_id IS NOT NULL THEN
DELETE FROM site_objects_tree WHERE id in (
SELECT r2.id FROM site_objects_tree r1 join site_objects_tree r2 on r1.child_id = r2.child_id
WHERE r1.parent_id = NEW.id AND r2.depth > r1.depth
);
END IF;
IF NEW.parent_id IS NOT NULL THEN
INSERT INTO site_objects_tree (parent_id, child_id, depth)
SELECT r1.parent_id, r2.child_id, r1.depth + r2.depth + 1
FROM
site_objects_tree r1,
site_objects_tree r2
WHERE
r1.child_id = NEW.parent_id AND
r2.parent_id = NEW.id;
END IF;
RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 31 (class 1255 OID 16547)
-- Dependencies: 6 367
-- Name: tree_objects_bu(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tree_objects_bu() RETURNS trigger
    AS $$DECLARE
BEGIN
IF NEW.id <> OLD.id THEN
RAISE EXCEPTION 'Changing ids is forbidden.';
END IF;

IF NOT OLD.parent_id IS DISTINCT FROM NEW.parent_id THEN
RETURN NEW;
END IF;
IF NEW.parent_id IS NULL THEN
RETURN NEW;
END IF;

PERFORM 1 FROM site_objects_tree WHERE ( parent_id, child_id ) = ( NEW.id, NEW.parent_id );
IF FOUND THEN
RAISE EXCEPTION 'Update blocked, because it would create loop in tree.';
END IF;
RETURN NEW;
END$$
    LANGUAGE plpgsql;


--
-- TOC entry 1967 (class 0 OID 0)
-- Dependencies: 31
-- Name: FUNCTION tree_objects_bu(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION tree_objects_bu() IS 'update the path and depth of new objects';


--
-- TOC entry 32 (class 1255 OID 16548)
-- Dependencies: 367 6
-- Name: tree_ordering_path_objects_bi(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tree_ordering_path_objects_bi() RETURNS trigger
    AS $$BEGIN
IF NEW.ordering IS NULL THEN
SELECT MAX(ordering) + 1000 FROM site_objects INTO NEW.ordering;
END IF;

IF NEW.parent_id IS NULL THEN
NEW.ordering_path := to_char(NEW.ordering, '000000000000');
ELSE
SELECT ordering_path || '/' || to_char(NEW.ordering, '000000000000') INTO NEW.ordering_path FROM site_objects WHERE id = NEW.parent_id;
END IF;
RETURN NEW;
END$$
    LANGUAGE plpgsql;


--
-- TOC entry 33 (class 1255 OID 16549)
-- Dependencies: 6 367
-- Name: tree_ordering_path_objects_bu(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tree_ordering_path_objects_bu() RETURNS trigger
    AS $$BEGIN
IF OLD.ordering = NEW.ordering AND OLD.parent_id = NEW.parent_id THEN
RETURN NEW;
END IF;
IF NEW.parent_id IS NULL THEN
NEW.ordering_path := to_char(NEW.ordering, '000000000000');
ELSE
SELECT ordering_path || '/' || to_char(NEW.ordering, '000000000000') INTO NEW.ordering_path FROM site_objects WHERE id = NEW.parent_id;
END IF;
UPDATE site_objects SET ordering_path = regexp_replace(ordering_path, '^' || OLD.ordering_path, NEW.ordering_path )
WHERE id in (SELECT child_id FROM site_objects_tree WHERE parent_id = NEW.id AND depth > 0);
RETURN NEW;
END;$$
    LANGUAGE plpgsql;


--
-- TOC entry 34 (class 1255 OID 16550)
-- Dependencies: 367 6
-- Name: tree_path_objects_bi(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tree_path_objects_bi() RETURNS trigger
    AS $$
DECLARE
BEGIN
IF NEW.parent_id IS NULL THEN
NEW.tree_path := NEW.id;
ELSE
SELECT tree_path || '/' || NEW.id INTO NEW.tree_path FROM site_objects WHERE id = NEW.parent_id;
END IF;
RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 35 (class 1255 OID 16551)
-- Dependencies: 367 6
-- Name: tree_path_objects_bu(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tree_path_objects_bu() RETURNS trigger
    AS $$
DECLARE
replace_from TEXT := '^';
replace_to TEXT := '';
BEGIN
IF NOT OLD.parent_id IS distinct FROM NEW.parent_id THEN
RETURN NEW;
END IF;
IF OLD.parent_id IS NOT NULL THEN
SELECT '^' || tree_path || '/' INTO replace_from FROM site_objects WHERE id = OLD.parent_id;
END IF;
IF NEW.parent_id IS NOT NULL THEN
SELECT tree_path || '/' INTO replace_to FROM site_objects WHERE id = NEW.parent_id;
END IF;
NEW.tree_path := regexp_replace( NEW.tree_path, replace_from, replace_to );
UPDATE site_objects SET tree_path = regexp_replace(tree_path, replace_from, replace_to ) WHERE id in (SELECT child_id FROM site_objects_tree WHERE parent_id = NEW.id AND depth > 0);
RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 36 (class 1255 OID 16552)
-- Dependencies: 367 6
-- Name: update_group_member_counts(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_group_member_counts() RETURNS trigger
    AS $$BEGIN
IF( TG_OP = 'INSERT' ) THEN
UPDATE groups SET member_count = member_count + 1 WHERE id = NEW.group_id;
RETURN NEW;
END IF;
IF( TG_OP = 'DELETE' ) THEN
UPDATE groups SET member_count = member_count - 1 WHERE id = OLD.group_id;
RETURN OLD;
END IF;

END$$
    LANGUAGE plpgsql;


--
-- TOC entry 1968 (class 0 OID 0)
-- Dependencies: 36
-- Name: FUNCTION update_group_member_counts(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION update_group_member_counts() IS 'updates the grops member counts';


--
-- TOC entry 37 (class 1255 OID 16553)
-- Dependencies: 6 367
-- Name: update_user_fields(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_user_fields() RETURNS trigger
    AS $$DECLARE
max_sort integer;
column_name text;
BEGIN

IF (TG_OP = 'DELETE') THEN
UPDATE user_fields SET sort = sort-1 WHERE sort > OLD.sort;
column_name = 'custom_field_' || OLD.id;
--ALTER TABLE users DROP COLUMN column_name;
END IF;

IF (TG_OP = 'INSERT') THEN
SELECT MAX(sort) INTO max_sort FROM user_fields;
IF (max_sort IS NULL) THEN max_sort = 0; END IF;
NEW.sort = max_sort + 1;
column_name = 'custom_field' || NEW.id; 
--ALTER TABLE users ADD COLUMN column_name character varying(255);
END IF;

IF (TG_OP = 'INSERT') THEN
RETURN NEW;
END IF;
IF (TG_OP = 'DELETE') THEN
RETURN OLD;
END IF;
END$$
    LANGUAGE plpgsql;


--
-- TOC entry 1969 (class 0 OID 0)
-- Dependencies: 37
-- Name: FUNCTION update_user_fields(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION update_user_fields() IS 'updates the field sorting on delete and insert';


--
-- TOC entry 38 (class 1255 OID 16554)
-- Dependencies: 367 6
-- Name: user_ai(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION user_ai() RETURNS trigger
    AS $$BEGIN
INSERT INTO users_roles ("user",role) VALUES (NEW.id,3);
RETURN NEW;
END$$
    LANGUAGE plpgsql;


--
-- TOC entry 1970 (class 0 OID 0)
-- Dependencies: 38
-- Name: FUNCTION user_ai(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION user_ai() IS 'post action on user creation';


--
-- TOC entry 1560 (class 1259 OID 16555)
-- Dependencies: 6 1540
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1971 (class 0 OID 0)
-- Dependencies: 1560
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clients_id_seq OWNED BY clients.id;


--
-- TOC entry 1561 (class 1259 OID 16557)
-- Dependencies: 6 1542
-- Name: document_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE document_files_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1972 (class 0 OID 0)
-- Dependencies: 1561
-- Name: document_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE document_files_id_seq OWNED BY document_files.id;


--
-- TOC entry 1562 (class 1259 OID 16559)
-- Dependencies: 1543 6
-- Name: document_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE document_pages_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1973 (class 0 OID 0)
-- Dependencies: 1562
-- Name: document_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE document_pages_id_seq OWNED BY document_pages.id;


--
-- TOC entry 1563 (class 1259 OID 16561)
-- Dependencies: 1544 6
-- Name: gallery_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gallery_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1974 (class 0 OID 0)
-- Dependencies: 1563
-- Name: gallery_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gallery_images_id_seq OWNED BY gallery_images.id;


--
-- TOC entry 1564 (class 1259 OID 16563)
-- Dependencies: 6 1551
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1975 (class 0 OID 0)
-- Dependencies: 1564
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- TOC entry 1565 (class 1259 OID 16565)
-- Dependencies: 6 1553
-- Name: site_objects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE site_objects_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1976 (class 0 OID 0)
-- Dependencies: 1565
-- Name: site_objects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE site_objects_id_seq OWNED BY site_objects.id;


--
-- TOC entry 1566 (class 1259 OID 16567)
-- Dependencies: 6 1554
-- Name: site_objects_tree_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE site_objects_tree_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1977 (class 0 OID 0)
-- Dependencies: 1566
-- Name: site_objects_tree_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE site_objects_tree_id_seq OWNED BY site_objects_tree.id;


--
-- TOC entry 1567 (class 1259 OID 16569)
-- Dependencies: 6 1558
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 1978 (class 0 OID 0)
-- Dependencies: 1567
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- TOC entry 1839 (class 2604 OID 16571)
-- Dependencies: 1560 1540
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE clients ALTER COLUMN id SET DEFAULT nextval('clients_id_seq'::regclass);


--
-- TOC entry 1844 (class 2604 OID 16572)
-- Dependencies: 1561 1542
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE document_files ALTER COLUMN id SET DEFAULT nextval('document_files_id_seq'::regclass);


--
-- TOC entry 1850 (class 2604 OID 16573)
-- Dependencies: 1562 1543
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE document_pages ALTER COLUMN id SET DEFAULT nextval('document_pages_id_seq'::regclass);


--
-- TOC entry 1856 (class 2604 OID 16574)
-- Dependencies: 1563 1544
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE gallery_images ALTER COLUMN id SET DEFAULT nextval('gallery_images_id_seq'::regclass);


--
-- TOC entry 1858 (class 2604 OID 16575)
-- Dependencies: 1564 1551
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- TOC entry 1875 (class 2604 OID 16576)
-- Dependencies: 1565 1553
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE site_objects ALTER COLUMN id SET DEFAULT nextval('site_objects_id_seq'::regclass);


--
-- TOC entry 1876 (class 2604 OID 16577)
-- Dependencies: 1566 1554
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE site_objects_tree ALTER COLUMN id SET DEFAULT nextval('site_objects_tree_id_seq'::regclass);


--
-- TOC entry 1896 (class 2604 OID 16578)
-- Dependencies: 1567 1558
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- TOC entry 1900 (class 2606 OID 16580)
-- Dependencies: 1539 1539 1539 1539
-- Name: acl_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY acl
    ADD CONSTRAINT acl_pkey PRIMARY KEY (object, permission, role);


--
-- TOC entry 1902 (class 2606 OID 16582)
-- Dependencies: 1540 1540
-- Name: clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- TOC entry 1904 (class 2606 OID 16584)
-- Dependencies: 1542 1542
-- Name: document_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document_files
    ADD CONSTRAINT document_files_pkey PRIMARY KEY (id);


--
-- TOC entry 1907 (class 2606 OID 16586)
-- Dependencies: 1543 1543
-- Name: document_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document_pages
    ADD CONSTRAINT document_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 1910 (class 2606 OID 16588)
-- Dependencies: 1544 1544
-- Name: gallery_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gallery_images
    ADD CONSTRAINT gallery_images_pkey PRIMARY KEY (id);


--
-- TOC entry 1912 (class 2606 OID 16590)
-- Dependencies: 1545 1545
-- Name: garbage_collection_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY garbage_collection_files
    ADD CONSTRAINT garbage_collection_files_pkey PRIMARY KEY ("fileLocation");


--
-- TOC entry 1921 (class 2606 OID 16592)
-- Dependencies: 1553 1553
-- Name: objects_ordering_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_objects
    ADD CONSTRAINT objects_ordering_key UNIQUE (ordering);


--
-- TOC entry 1923 (class 2606 OID 16594)
-- Dependencies: 1553 1553
-- Name: objects_ordering_path_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_objects
    ADD CONSTRAINT objects_ordering_path_key UNIQUE (ordering_path);


--
-- TOC entry 1925 (class 2606 OID 16596)
-- Dependencies: 1553 1553
-- Name: objects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 1928 (class 2606 OID 16598)
-- Dependencies: 1554 1554 1554
-- Name: objects_tree_parent_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_objects_tree
    ADD CONSTRAINT objects_tree_parent_id_key UNIQUE (parent_id, child_id);


--
-- TOC entry 1930 (class 2606 OID 16600)
-- Dependencies: 1554 1554
-- Name: objects_tree_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_objects_tree
    ADD CONSTRAINT objects_tree_pkey PRIMARY KEY (id);


--
-- TOC entry 1914 (class 2606 OID 16602)
-- Dependencies: 1551 1551
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 1916 (class 2606 OID 16604)
-- Dependencies: 1552 1552
-- Name: session_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- TOC entry 1937 (class 2606 OID 16606)
-- Dependencies: 1558 1558
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 1939 (class 2606 OID 16608)
-- Dependencies: 1559 1559 1559
-- Name: users_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_roles
    ADD CONSTRAINT users_roles_pkey PRIMARY KEY ("user", role);


--
-- TOC entry 1917 (class 1259 OID 16609)
-- Dependencies: 1553
-- Name: creation_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX creation_date ON site_objects USING btree (creation_time);


--
-- TOC entry 1905 (class 1259 OID 16610)
-- Dependencies: 1542
-- Name: object_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX object_idx2 ON document_files USING btree (object);


--
-- TOC entry 1918 (class 1259 OID 16611)
-- Dependencies: 1553
-- Name: object_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX object_status ON site_objects USING btree (status);


--
-- TOC entry 1919 (class 1259 OID 16612)
-- Dependencies: 1553
-- Name: object_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX object_title ON site_objects USING btree (title);


--
-- TOC entry 1908 (class 1259 OID 16613)
-- Dependencies: 1543 1543
-- Name: page_object_sorting_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX page_object_sorting_index ON document_pages USING btree (object, sort);


--
-- TOC entry 1926 (class 1259 OID 16614)
-- Dependencies: 1553 1553
-- Name: publishing_dates; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX publishing_dates ON site_objects USING btree (publish_start, publish_end);


--
-- TOC entry 1931 (class 1259 OID 16615)
-- Dependencies: 1558
-- Name: unique_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_email ON users USING btree (lower((email)::text));


--
-- TOC entry 1932 (class 1259 OID 16616)
-- Dependencies: 1558
-- Name: user_birthday; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_birthday ON users USING btree (birthday_date);


--
-- TOC entry 1933 (class 1259 OID 16617)
-- Dependencies: 1558
-- Name: user_gender; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_gender ON users USING btree (gender_is_male);


--
-- TOC entry 1934 (class 1259 OID 16618)
-- Dependencies: 1558
-- Name: user_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_status ON users USING btree (status);


--
-- TOC entry 1935 (class 1259 OID 16619)
-- Dependencies: 1558
-- Name: user_warnings; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_warnings ON users USING btree (warnings);


--
-- TOC entry 1948 (class 2620 OID 16620)
-- Dependencies: 1542 20
-- Name: document_file_ad; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER document_file_ad
    AFTER DELETE ON document_files
    FOR EACH ROW
    EXECUTE PROCEDURE document_file_ad();


--
-- TOC entry 1949 (class 2620 OID 16621)
-- Dependencies: 21 1542
-- Name: document_file_au; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER document_file_au
    AFTER UPDATE ON document_files
    FOR EACH ROW
    EXECUTE PROCEDURE document_file_au();


--
-- TOC entry 1950 (class 2620 OID 16622)
-- Dependencies: 1542 22
-- Name: document_file_bi; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER document_file_bi
    BEFORE INSERT ON document_files
    FOR EACH ROW
    EXECUTE PROCEDURE document_file_bi();


--
-- TOC entry 1951 (class 2620 OID 16623)
-- Dependencies: 23 1543
-- Name: document_page_ad; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER document_page_ad
    AFTER DELETE ON document_pages
    FOR EACH ROW
    EXECUTE PROCEDURE document_page_ad();


--
-- TOC entry 1952 (class 2620 OID 16624)
-- Dependencies: 1543 24
-- Name: document_page_bi; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER document_page_bi
    BEFORE INSERT ON document_pages
    FOR EACH ROW
    EXECUTE PROCEDURE document_page_bi();


--
-- TOC entry 1953 (class 2620 OID 16625)
-- Dependencies: 1553 29
-- Name: tree_objects_ai; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tree_objects_ai
    AFTER INSERT ON site_objects
    FOR EACH ROW
    EXECUTE PROCEDURE tree_objects_ai();


--
-- TOC entry 1954 (class 2620 OID 16626)
-- Dependencies: 1553 30
-- Name: tree_objects_au; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tree_objects_au
    AFTER UPDATE ON site_objects
    FOR EACH ROW
    EXECUTE PROCEDURE tree_objects_au();


--
-- TOC entry 1955 (class 2620 OID 16627)
-- Dependencies: 31 1553
-- Name: tree_objects_bu; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tree_objects_bu
    BEFORE UPDATE ON site_objects
    FOR EACH ROW
    EXECUTE PROCEDURE tree_objects_bu();


--
-- TOC entry 1956 (class 2620 OID 16628)
-- Dependencies: 1553 32
-- Name: tree_ordering_path_objects_bi; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tree_ordering_path_objects_bi
    BEFORE INSERT ON site_objects
    FOR EACH ROW
    EXECUTE PROCEDURE tree_ordering_path_objects_bi();


--
-- TOC entry 1957 (class 2620 OID 16629)
-- Dependencies: 1553 33
-- Name: tree_ordering_path_objects_bu; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tree_ordering_path_objects_bu
    BEFORE UPDATE ON site_objects
    FOR EACH ROW
    EXECUTE PROCEDURE tree_ordering_path_objects_bu();


--
-- TOC entry 1958 (class 2620 OID 16630)
-- Dependencies: 34 1553
-- Name: tree_path_objects_bi; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tree_path_objects_bi
    BEFORE INSERT ON site_objects
    FOR EACH ROW
    EXECUTE PROCEDURE tree_path_objects_bi();


--
-- TOC entry 1959 (class 2620 OID 16631)
-- Dependencies: 35 1553
-- Name: tree_path_objects_bu; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tree_path_objects_bu
    BEFORE UPDATE ON site_objects
    FOR EACH ROW
    EXECUTE PROCEDURE tree_path_objects_bu();


--
-- TOC entry 1960 (class 2620 OID 16632)
-- Dependencies: 38 1558
-- Name: users_ai; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER users_ai
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE PROCEDURE user_ai();


--
-- TOC entry 1940 (class 2606 OID 16633)
-- Dependencies: 1551 1913 1539
-- Name: acl_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY acl
    ADD CONSTRAINT acl_role_fkey FOREIGN KEY (role) REFERENCES roles(id) ON DELETE CASCADE;


--
-- TOC entry 1941 (class 2606 OID 16638)
-- Dependencies: 1924 1553 1542
-- Name: document_files_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_files
    ADD CONSTRAINT document_files_object_fkey FOREIGN KEY (object) REFERENCES site_objects(id) ON DELETE CASCADE;


--
-- TOC entry 1942 (class 2606 OID 16643)
-- Dependencies: 1543 1924 1553
-- Name: document_pages_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_pages
    ADD CONSTRAINT document_pages_object_fkey FOREIGN KEY (object) REFERENCES site_objects(id) ON DELETE CASCADE;


--
-- TOC entry 1943 (class 2606 OID 16648)
-- Dependencies: 1924 1553 1553
-- Name: objects_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY site_objects
    ADD CONSTRAINT objects_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES site_objects(id) ON DELETE CASCADE;


--
-- TOC entry 1944 (class 2606 OID 16653)
-- Dependencies: 1554 1924 1553
-- Name: objects_tree_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY site_objects_tree
    ADD CONSTRAINT objects_tree_child_id_fkey FOREIGN KEY (child_id) REFERENCES site_objects(id) ON DELETE CASCADE;


--
-- TOC entry 1945 (class 2606 OID 16658)
-- Dependencies: 1553 1924 1554
-- Name: objects_tree_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY site_objects_tree
    ADD CONSTRAINT objects_tree_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES site_objects(id) ON DELETE CASCADE;


--
-- TOC entry 1946 (class 2606 OID 16663)
-- Dependencies: 1559 1551 1913
-- Name: users_roles_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_roles
    ADD CONSTRAINT users_roles_role_fkey FOREIGN KEY (role) REFERENCES roles(id) ON DELETE CASCADE;


--
-- TOC entry 1947 (class 2606 OID 16668)
-- Dependencies: 1559 1936 1558
-- Name: users_roles_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_roles
    ADD CONSTRAINT users_roles_user_fkey FOREIGN KEY ("user") REFERENCES users(id) ON DELETE CASCADE;


--
-- TOC entry 1965 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2008-11-05 20:09:22 CET

--
-- PostgreSQL database dump complete
--

