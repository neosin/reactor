--query--
SET FOREIGN_KEY_CHECKS=0
--query--
CREATE OR REPLACE FUNCTION document_file_ad()
  RETURNS trigger AS
$BODY$DECLARE
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
END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION document_file_au()
  RETURNS trigger AS
$BODY$BEGIN

IF NEW.filename != OLD.filename THEN
	IF OLD.private = true THEN
	INSERT INTO garbage_collection_files VALUES ('Private/Files/' || OLD.filename);
	ELSE
	INSERT INTO garbage_collection_files VALUES ('Public/Files/' || OLD.filename);
	END IF;
END IF;
RETURN NEW;
END;$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION document_file_bi()
  RETURNS trigger AS
$BODY$DECLARE
max_sort integer;
BEGIN

SELECT MAX(sort) INTO max_sort FROM document_files WHERE object = NEW.object;
IF (max_sort IS NULL) THEN max_sort = 0; END IF;
NEW.sort = max_sort + 1;
UPDATE site_objects SET files = files + 1 WHERE id = NEW.object;
RETURN NEW;
END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION document_page_ad()
  RETURNS trigger AS
$BODY$DECLARE
max_sort integer;
BEGIN

UPDATE document_pages SET sort = sort - 1 WHERE object = OLD.object AND sort > OLD.sort;
UPDATE site_objects SET pages = pages - 1 WHERE id = OLD.object;
RETURN OLD;

END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION document_page_bi()
  RETURNS trigger AS
$BODY$DECLARE
max_sort integer;
BEGIN

SELECT MAX(sort) INTO max_sort FROM document_pages WHERE object = NEW.object;
IF (max_sort IS NULL) THEN max_sort = 0; END IF;
NEW.sort = max_sort + 1;
UPDATE site_objects SET pages = pages + 1 WHERE id = NEW.object;
RETURN NEW;
END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION tree_objects_ai()
  RETURNS trigger AS
$BODY$DECLARE
BEGIN
-- http://www.depesz.com --

-- it inserts row, where both parent_id and child_id are set to the same value (id of newly inserted object), and depth is set to 0 (as both child and parent are on the same level) - easy serches later
INSERT INTO site_objects_tree (parent_id, child_id, depth) VALUES (NEW.id, NEW.id, 0);
-- we copy all rows that our parent had as its parents, but we modify child_id in these rows to be id of currently inserted row, and increase depth
INSERT INTO site_objects_tree (parent_id, child_id, depth) SELECT x.parent_id, NEW.id, x.depth + 1 FROM site_objects_tree x WHERE x.child_id = NEW.parent_id;

-- <insert>--
RETURN NEW;
END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION tree_objects_au()
  RETURNS trigger AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION tree_objects_bu()
  RETURNS trigger AS
$BODY$DECLARE
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
END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION tree_ordering_path_objects_bi()
  RETURNS trigger AS
$BODY$BEGIN
IF NEW.ordering IS NULL THEN
SELECT MAX(ordering) + 1000 FROM site_objects INTO NEW.ordering;
END IF;

IF NEW.parent_id IS NULL THEN
NEW.ordering_path := to_char(NEW.ordering, '000000000000');
ELSE
SELECT ordering_path || '/' || to_char(NEW.ordering, '000000000000') INTO NEW.ordering_path FROM site_objects WHERE id = NEW.parent_id;
END IF;
RETURN NEW;
END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION tree_ordering_path_objects_bu()
  RETURNS trigger AS
$BODY$BEGIN
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
END;$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION tree_path_objects_bi()
  RETURNS trigger AS
$BODY$
DECLARE
BEGIN
IF NEW.parent_id IS NULL THEN
NEW.tree_path := NEW.id;
ELSE
SELECT tree_path || '/' || NEW.id INTO NEW.tree_path FROM site_objects WHERE id = NEW.parent_id;
END IF;
RETURN NEW;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION tree_path_objects_bu()
  RETURNS trigger AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION update_group_member_counts()
  RETURNS trigger AS
$BODY$BEGIN
IF( TG_OP = 'INSERT' ) THEN
UPDATE groups SET member_count = member_count + 1 WHERE id = NEW.group_id;
RETURN NEW;
END IF;
IF( TG_OP = 'DELETE' ) THEN
UPDATE groups SET member_count = member_count - 1 WHERE id = OLD.group_id;
RETURN OLD;
END IF;

END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION update_user_fields()
  RETURNS trigger AS
$BODY$DECLARE
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
END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
CREATE OR REPLACE FUNCTION user_ai()
  RETURNS trigger AS
$BODY$BEGIN
INSERT INTO users_roles ("user",role) VALUES (NEW.id,3);
RETURN NEW;
END$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
--query--
DROP TABLE IF EXISTS roles CASCADE;
--query--
CREATE TABLE roles
(
  id integer NOT NULL auto_increment,
  name character varying(100) NOT NULL,
  description text NOT NULL,
  users integer NOT NULL DEFAULT 0,
  CONSTRAINT roles_pkey PRIMARY KEY (id)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS site_objects CASCADE;
--query--
CREATE TABLE site_objects
(
  id integer NOT NULL auto_increment,
  title character varying(160),
  description text,
  tags text,
  type smallint NOT NULL DEFAULT 0,
  views integer DEFAULT 0,
  status boolean NOT NULL DEFAULT false,
  creation_time timestamp NOT NULL DEFAULT now(),
  edition_time timestamp,
  pages_total smallint NOT NULL DEFAULT 0,
  topics_total integer NOT NULL DEFAULT 0,
  posts_total integer NOT NULL DEFAULT 0,
  images_total integer NOT NULL DEFAULT 0,
  products_total integer NOT NULL DEFAULT 0,
  files_total integer NOT NULL DEFAULT 0,
  main_menu boolean NOT NULL DEFAULT false,
  support_menu boolean NOT NULL DEFAULT false,
  list_child_objects boolean NOT NULL DEFAULT false,
  allow_delete boolean NOT NULL DEFAULT true,
  publish_start timestamp,
  publish_end timestamp,
  owner integer NOT NULL DEFAULT 0,
  parent_id integer,
  ordering integer,
  ordering_path character varying(255),
  tree_path text,
  comments_total integer NOT NULL DEFAULT 0,
  CONSTRAINT objects_pkey PRIMARY KEY (id),
  CONSTRAINT objects_parent_id_fkey FOREIGN KEY (parent_id)
      REFERENCES site_objects (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT objects_ordering_key UNIQUE (ordering),
  CONSTRAINT objects_ordering_path_key UNIQUE (ordering_path)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
CREATE INDEX creation_date
  ON site_objects
  (creation_time);
--query--
CREATE INDEX object_status
  ON site_objects
  (status);
--query--
CREATE INDEX object_title 
  ON site_objects
  (title);
--query--
CREATE INDEX publishing_dates
  ON site_objects
  (publish_start, publish_end);
--query--
DROP TABLE IF EXISTS site_objects_tree CASCADE;
--query--
CREATE TABLE site_objects_tree
(
  id integer NOT NULL auto_increment,
  parent_id integer NOT NULL,
  child_id integer NOT NULL,
  depth integer NOT NULL,
  CONSTRAINT objects_tree_pkey PRIMARY KEY (id),
  CONSTRAINT objects_tree_child_id_fkey FOREIGN KEY (child_id)
      REFERENCES site_objects (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT objects_tree_parent_id_fkey FOREIGN KEY (parent_id)
      REFERENCES site_objects (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT objects_tree_parent_id_key UNIQUE (parent_id, child_id)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS users;
--query--
CREATE TABLE users
(
  id integer NOT NULL auto_increment,
  username character varying(50) NOT NULL,
  password character varying(32),
  status smallint NOT NULL DEFAULT 0,
  email character varying(100) NOT NULL,
  registered_timestamp timestamp NOT NULL DEFAULT now(),
  last_logged_timestamp timestamp,
  last_logged_ip character varying(50),
  registered_ip character varying(50),
  notes text,
  ident bigint,
  avatar boolean NOT NULL DEFAULT false,
  gender_is_male boolean NOT NULL DEFAULT true,
  show_gender boolean NOT NULL DEFAULT true,
  birthday_date date,
  show_age integer NOT NULL DEFAULT 3,
  warnings integer DEFAULT 0,
  pm_read_total integer NOT NULL DEFAULT 0,
  pm_new_total integer NOT NULL DEFAULT 0,
  pm_sent_total integer NOT NULL DEFAULT 0,
  pm_sketches_total integer NOT NULL DEFAULT 0,
  friends_total integer NOT NULL DEFAULT 0,
  signature text,
  config_topics_per_page integer NOT NULL DEFAULT 20,
  config_posts_per_page integer NOT NULL DEFAULT 10,
  config_add_signature boolean NOT NULL DEFAULT true,
  config_bookmark_topics boolean NOT NULL DEFAULT true,
  address character varying(255),
  tax_number character varying(30),
  city character varying(100),
  country character varying(10),
  district character varying(10),
  salutation character varying(10),
  company_title character varying(50),
  company_department character varying(50),
  assistant_name character varying(50),
  assistant_phone character varying(30),
  email_notifications boolean,
  do_not_call boolean NOT NULL DEFAULT false,
  supervisor_id integer,
  postal_number character varying(20),
  CONSTRAINT users_pkey PRIMARY KEY (id)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
CREATE UNIQUE INDEX unique_email
  ON users
  (email);
--query--
CREATE UNIQUE INDEX unique_username
  ON users
  (username);
--query--
CREATE INDEX user_birthday
  ON users
  (birthday_date);
--query--
CREATE INDEX user_gender
  ON users
  (gender_is_male);
--query--
CREATE INDEX user_status
  ON users
  (status);
--query--
CREATE INDEX user_warnings
  ON users
  (warnings);
--query--
DROP TABLE IF EXISTS acl CASCADE;
--query--
CREATE TABLE acl
(
  object integer NOT NULL DEFAULT 0,
  permission integer NOT NULL DEFAULT 0,
  role integer NOT NULL DEFAULT 0,
  CONSTRAINT acl_pkey PRIMARY KEY (object, permission, role),
  CONSTRAINT acl_role_fkey FOREIGN KEY (role)
      REFERENCES roles (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS clients CASCADE;
--query--
CREATE TABLE clients
(
  id integer NOT NULL auto_increment,
  name character varying(255) NOT NULL,
  website character varying(255),
  market_symbol character varying(10),
  employees integer NOT NULL DEFAULT 0,
  owner character varying(255),
  type smallint,
  trade smallint,
  creation_time timestamp NOT NULL DEFAULT now(),
  update_time timestamp,
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
  sending_country character varying(50),
  CONSTRAINT clients_pkey PRIMARY KEY (id)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
CREATE INDEX clients_name
  ON clients
  (name);
--query--
DROP TABLE IF EXISTS clients_users_bindings CASCADE;
--query--
  CREATE TABLE clients_users_bindings
(
  temporary_table character varying(255)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS document_files CASCADE;
--query--
CREATE TABLE document_files
(
  object integer NOT NULL DEFAULT 0,
  filename character varying(100) NOT NULL,
  title character varying(150) NOT NULL,
  description text,
  downloads integer NOT NULL DEFAULT 0,
  private boolean NOT NULL DEFAULT true,
  sort integer NOT NULL DEFAULT 0,
  id serial NOT NULL,
  CONSTRAINT document_files_pkey PRIMARY KEY (id),
  CONSTRAINT document_files_object_fkey FOREIGN KEY (object)
      REFERENCES site_objects (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
CREATE INDEX object_idx2
  ON document_files
  (object);
--query--
DROP TABLE IF EXISTS document_pages CASCADE;
--query--
CREATE TABLE document_pages
(
  object integer NOT NULL DEFAULT 0,
  title text,
  description text,
  body text,
  sort integer NOT NULL DEFAULT 0,
  views integer NOT NULL DEFAULT 0,
  created timestamp NOT NULL DEFAULT now(),
  modified timestamp,
  id serial NOT NULL,
  CONSTRAINT document_pages_pkey PRIMARY KEY (id),
  CONSTRAINT document_pages_object_fkey FOREIGN KEY (object)
      REFERENCES site_objects (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
CREATE INDEX page_object_sorting_index
  ON document_pages
  (object, sort);
--query--
DROP TABLE IF EXISTS gallery_images CASCADE;
--query--
CREATE TABLE gallery_images
(
  id integer NOT NULL auto_increment,
  title character varying(255),
  description text,
  votes integer NOT NULL DEFAULT 0,
  tags character varying(255),
  picture_path text,
  owner integer NOT NULL DEFAULT 0,
  comments integer NOT NULL DEFAULT 0,
  object integer NOT NULL DEFAULT 0,
  creation_date timestamp NOT NULL DEFAULT now(),
  CONSTRAINT gallery_images_pkey PRIMARY KEY (id)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
CREATE INDEX image_insert_time
  ON gallery_images
  (creation_date);
--query--
CREATE INDEX image_onwer
  ON gallery_images
  (owner);
--query--
CREATE INDEX image_title
  ON gallery_images
  (title);
--query--
DROP TABLE IF EXISTS garbage_collection_files CASCADE;
--query--
CREATE TABLE garbage_collection_files
(
  file_location text NOT NULL
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS messages CASCADE;
--query--
CREATE TABLE messages
(
  temporary_table character varying(255)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS messages_flow CASCADE;
--query--
CREATE TABLE messages_flow
(
  temporary_table character varying(255)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS products CASCADE;
--query--
CREATE TABLE products
(
  temporary_table character varying(255)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS products_properties CASCADE;
--query--
CREATE TABLE products_properties
(
  temporary_table character varying(255)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS products_propery_values CASCADE;
--query--
CREATE TABLE products_propery_values
(
  temporary_table character varying(255)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS session CASCADE;
--query--
CREATE TABLE session
(
  id character(32) NOT NULL,
  modified integer,
  lifetime integer,
  data text,
  CONSTRAINT session_pkey PRIMARY KEY (id)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS task_asignees CASCADE;
--query--
CREATE TABLE task_asignees
(
  temporary_table character varying(255)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS task_steps CASCADE;
--query--
CREATE TABLE task_steps
(
  temporary_table character varying(255)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS tasks CASCADE;
--query--
CREATE TABLE tasks
(
  temporary_table character varying(255)
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS user_phones CASCADE;
--query--
CREATE TABLE user_phones
(
  `user` integer NOT NULL DEFAULT 0,
  phone character varying(25) NOT NULL,
  description character varying(200) NOT NULL,
  CONSTRAINT user_phones_pkey PRIMARY KEY (`user`, phone, description),
  CONSTRAINT user_phones_user_fkey FOREIGN KEY (`user`)
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS users_ims CASCADE;
--query--
CREATE TABLE users_ims
(
  `user` integer NOT NULL DEFAULT 0,
  im character varying(50) NOT NULL,
  description character varying(255) NOT NULL,
  CONSTRAINT users_ims_pkey PRIMARY KEY (`user`, im, description),
  CONSTRAINT users_ims_user_fkey FOREIGN KEY (`user`)
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
DROP TABLE IF EXISTS users_roles CASCADE;
--query--
CREATE TABLE users_roles
(
  `user` integer NOT NULL DEFAULT 0,
  role integer NOT NULL DEFAULT 0,
  CONSTRAINT users_roles_pkey PRIMARY KEY (`user`, role),
  CONSTRAINT users_roles_role_fkey FOREIGN KEY (role)
      REFERENCES roles (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT users_roles_user_fkey FOREIGN KEY (`user`)
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
) ENGINE InnoDB CHARACTER SET=utf8;
--query--
CREATE TRIGGER document_file_ad
  AFTER DELETE
  ON document_files
  FOR EACH ROW
  EXECUTE PROCEDURE document_file_ad();
--query--
CREATE TRIGGER document_file_au
  AFTER UPDATE
  ON document_files
  FOR EACH ROW
  EXECUTE PROCEDURE document_file_au();
--query--
CREATE TRIGGER document_file_bi
  BEFORE INSERT
  ON document_files
  FOR EACH ROW
  EXECUTE PROCEDURE document_file_bi();
--query--
CREATE TRIGGER document_page_ad
  AFTER DELETE
  ON document_pages
  FOR EACH ROW
  EXECUTE PROCEDURE document_page_ad();
--query--
CREATE TRIGGER document_page_bi
  BEFORE INSERT
  ON document_pages
  FOR EACH ROW
  EXECUTE PROCEDURE document_page_bi();
--query--
CREATE TRIGGER tree_objects_ai
  AFTER INSERT
  ON site_objects
  FOR EACH ROW
  EXECUTE PROCEDURE tree_objects_ai();
--query--
CREATE TRIGGER tree_objects_au
  AFTER UPDATE
  ON site_objects
  FOR EACH ROW
  EXECUTE PROCEDURE tree_objects_au();
--query--
CREATE TRIGGER tree_objects_bu
  BEFORE UPDATE
  ON site_objects
  FOR EACH ROW
  EXECUTE PROCEDURE tree_objects_bu();
--query--
CREATE TRIGGER tree_ordering_path_objects_bi
  BEFORE INSERT
  ON site_objects
  FOR EACH ROW
  EXECUTE PROCEDURE tree_ordering_path_objects_bi();
--query--
CREATE TRIGGER tree_ordering_path_objects_bu
  BEFORE UPDATE
  ON site_objects
  FOR EACH ROW
  EXECUTE PROCEDURE tree_ordering_path_objects_bu();
--query--
CREATE TRIGGER tree_path_objects_bi
  BEFORE INSERT
  ON site_objects
  FOR EACH ROW
  EXECUTE PROCEDURE tree_path_objects_bi();
--query--
CREATE TRIGGER tree_path_objects_bu
  BEFORE UPDATE
  ON site_objects
  FOR EACH ROW
  EXECUTE PROCEDURE tree_path_objects_bu();  
--query--
CREATE TRIGGER users_ai
  AFTER INSERT
  ON users
  FOR EACH ROW
  EXECUTE PROCEDURE user_ai();
--query--
SET FOREIGN_KEY_CHECKS=1
--query--
INSERT INTO site_objects (id, title, parent_id, ordering) VALUES
(1, 'a', NULL, 100),
(2, 'b', NULL, 200),
(3, 'c', 1, 300),
(4, 'd', 2, 400),
(5, 'e', 3, 500),
(6, 'f', 3, 600),
(7, 'g', 3, 700),
(8, 'h', 6, 800),
(9, 'i', 7, 900),
(10, 'j', 8, 1000);