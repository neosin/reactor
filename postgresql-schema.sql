DROP TABLE IF EXISTS roles CASCADE;
--query--
CREATE TABLE roles
(
  id serial NOT NULL,
  "name" character varying(100) NOT NULL,
  description text NOT NULL,
  users integer NOT NULL DEFAULT 0,
  CONSTRAINT roles_pkey PRIMARY KEY (id)
);
--query--
DROP TABLE IF EXISTS site_objects CASCADE;
--query--
CREATE TABLE site_objects
(
  id serial NOT NULL,
  title character varying(160),
  description text,
  tags text,
  "type" smallint NOT NULL DEFAULT 0,
  views integer DEFAULT 0,
  status boolean NOT NULL DEFAULT false,
  creation_time timestamp without time zone NOT NULL DEFAULT now(),
  edition_time timestamp without time zone,
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
  publish_start timestamp without time zone,
  publish_end timestamp without time zone,
  owner integer NOT NULL DEFAULT 0,
  parent_id integer,
  depth integer,
  lft integer,
  rgt integer,
  comments_total integer NOT NULL DEFAULT 0,
  CONSTRAINT objects_pkey PRIMARY KEY (id),
  CONSTRAINT objects_parent_id_fkey FOREIGN KEY (parent_id)
      REFERENCES site_objects (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT tree_lft UNIQUE (lft),
  CONSTRAINT ree_rgt UNIQUE (rgt)
);
--query--
CREATE INDEX creation_date
  ON site_objects
  USING btree
  (creation_time);
--query--
CREATE INDEX object_status
  ON site_objects
  USING btree
  (status);
--query--
CREATE INDEX object_title
  ON site_objects
  USING btree
  (title);
--query--
CREATE INDEX publishing_dates
  ON site_objects
  USING btree
  (publish_start, publish_end);
--query--
DROP TABLE IF EXISTS users CASCADE;
--query--
CREATE TABLE users
(
  id serial NOT NULL,
  username character varying(50) NOT NULL,
  password character varying(32),
  status smallint NOT NULL DEFAULT 0,
  email character varying(100) NOT NULL,
  last_logged_timestamp timestamp without time zone DEFAULT now(),
  last_logged_ip character varying(50),
  registered_timestamp timestamp without time zone NOT NULL DEFAULT now(),
  registered_ip character varying(50),
  notes text,
  ident bigint DEFAULT (random() * (100000000000000::bigint)::double precision),
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
);
--query--
CREATE UNIQUE INDEX unique_email
  ON users
  USING btree
  (lower(email::text));
--query--
CREATE UNIQUE INDEX unique_username
  ON users
  USING btree
  (lower(username::text));
--query--
CREATE INDEX user_birthday
  ON users
  USING btree
  (birthday_date);
--query--
CREATE INDEX user_gender
  ON users
  USING btree
  (gender_is_male);
--query--
CREATE INDEX user_status
  ON users
  USING btree
  (status);
--query--
CREATE INDEX user_warnings
  ON users
  USING btree
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
);
--query--
DROP TABLE IF EXISTS clients CASCADE;
--query--
CREATE TABLE clients
(
  id serial NOT NULL,
  name character varying(255) NOT NULL,
  website character varying(255),
  market_symbol character varying(10),
  employees integer NOT NULL DEFAULT 0,
  owner character varying(255),
  type smallint,
  trade smallint,
  update_time timestamp without time zone,
  creation_time timestamp without time zone NOT NULL DEFAULT now(),
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
);
--query--
CREATE INDEX clients_name
  ON clients
  USING btree
  (name);
--query--
DROP TABLE IF EXISTS clients_users_bindings CASCADE;
--query--
  CREATE TABLE clients_users_bindings
(
  temporary_table character varying(255)
);
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
);
--query--
CREATE INDEX object_idx2
  ON document_files
  USING btree
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
  modified timestamp without time zone DEFAULT now(),
  created timestamp without time zone NOT NULL DEFAULT now(),
  id serial NOT NULL,
  CONSTRAINT document_pages_pkey PRIMARY KEY (id),
  CONSTRAINT document_pages_object_fkey FOREIGN KEY (object)
      REFERENCES site_objects (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
--query--
CREATE INDEX page_object_sorting_index
  ON document_pages
  USING btree
  (object, sort);
--query--
DROP TABLE IF EXISTS gallery_images CASCADE;
--query--
CREATE TABLE gallery_images
(
  id serial NOT NULL,
  title character varying(255),
  description text,
  votes integer NOT NULL DEFAULT 0,
  tags character varying(255),
  picture_path text,
  owner integer NOT NULL DEFAULT 0,
  comments integer NOT NULL DEFAULT 0,
  object integer NOT NULL DEFAULT 0,
  creation_date timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT gallery_images_pkey PRIMARY KEY (id)
);
--query--
CREATE INDEX image_insert_time
  ON gallery_images
  USING btree
  (creation_date);
--query--
CREATE INDEX image_onwer
  ON gallery_images
  USING btree
  (owner);
--query--
CREATE INDEX image_title
  ON gallery_images
  USING btree
  (title);
--query--
DROP TABLE IF EXISTS garbage_collection_files CASCADE;
--query--
CREATE TABLE garbage_collection_files
(
  file_location text NOT NULL
);
--query--
DROP TABLE IF EXISTS messages CASCADE;
--query--
CREATE TABLE messages
(
  temporary_table character varying(255)
);
--query--
DROP TABLE IF EXISTS messages_flow CASCADE;
--query--
CREATE TABLE messages_flow
(
  temporary_table character varying(255)
);
--query--
DROP TABLE IF EXISTS products CASCADE;
--query--
CREATE TABLE products
(
  temporary_table character varying(255)
);
--query--
DROP TABLE IF EXISTS products_properties CASCADE;
--query--
CREATE TABLE products_properties
(
  temporary_table character varying(255)
);
--query--
DROP TABLE IF EXISTS products_propery_values CASCADE;
--query--
CREATE TABLE products_propery_values
(
  temporary_table character varying(255)
);
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
);
--query--
DROP TABLE IF EXISTS task_asignees CASCADE;
--query--
CREATE TABLE task_asignees
(
  temporary_table character varying(255)
);
--query--
DROP TABLE IF EXISTS task_steps CASCADE;
--query--
CREATE TABLE task_steps
(
  temporary_table character varying(255)
);
--query--
DROP TABLE IF EXISTS tasks CASCADE;
--query--
CREATE TABLE tasks
(
  temporary_table character varying(255)
);
--query--
DROP TABLE IF EXISTS user_phones CASCADE;
--query--
CREATE TABLE user_phones
(
  "user" integer NOT NULL DEFAULT 0,
  phone character varying(25) NOT NULL,
  description character varying(200) NOT NULL,
  CONSTRAINT user_phones_pkey PRIMARY KEY ("user", phone, description),
  CONSTRAINT user_phones_user_fkey FOREIGN KEY ("user")
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
--query--
DROP TABLE IF EXISTS users_ims CASCADE;
--query--
CREATE TABLE users_ims
(
  "user" integer NOT NULL DEFAULT 0,
  im character varying(50) NOT NULL,
  description character varying(255) NOT NULL,
  CONSTRAINT users_ims_pkey PRIMARY KEY ("user", im, description),
  CONSTRAINT users_ims_user_fkey FOREIGN KEY ("user")
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
--query--
DROP TABLE IF EXISTS users_roles CASCADE;
--query--
CREATE TABLE users_roles
(
  "user" integer NOT NULL DEFAULT 0,
  role integer NOT NULL DEFAULT 0,
  CONSTRAINT users_roles_pkey PRIMARY KEY ("user", role),
  CONSTRAINT users_roles_role_fkey FOREIGN KEY (role)
      REFERENCES roles (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT users_roles_user_fkey FOREIGN KEY ("user")
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
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