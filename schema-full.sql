-- RESUME---------------------------
--
-- 1 CONFIGS SET
-- 2 DROP SEQUENCES
-- 3 CREATE TABLES, SET OWNER
-- 4 CREATE CONSTRAINTS
-- 5 CREATE INDEXES
-- 6 SCHEMA ACCESS
--
------------------------------------
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';



-- DROP SEQUENCES
DROP SEQUENCE IF EXISTS accesstoken_id_seq CASCADE;
DROP SEQUENCE IF EXISTS acl_id_seq CASCADE;
DROP SEQUENCE IF EXISTS application_id_seq CASCADE;
DROP SEQUENCE IF EXISTS user_id_seq CASCADE;
DROP SEQUENCE IF EXISTS oauthaccesstoken_id_seq CASCADE;
DROP SEQUENCE IF EXISTS oauthauthorizationcode_id_seq CASCADE;
DROP SEQUENCE IF EXISTS oauthclientapplication_id_seq CASCADE;
DROP SEQUENCE IF EXISTS oauthpermission_id_seq CASCADE;
DROP SEQUENCE IF EXISTS oauthscope_id_seq CASCADE;
DROP SEQUENCE IF EXISTS oauthscopemapping_id_seq CASCADE;
DROP SEQUENCE IF EXISTS role_id_seq CASCADE;
DROP SEQUENCE IF EXISTS rolemapping_id_seq CASCADE;


-- CREATE TABLES
DROP TABLE IF EXISTS accesstoken CASCADE;
CREATE TABLE accesstoken (
    id character varying(1024) PRIMARY KEY,
    ttl integer,
    created timestamp with time zone,
    userid integer
);
ALTER TABLE public.accesstoken OWNER TO postgres;


DROP TABLE IF EXISTS acl CASCADE;
CREATE TABLE acl (
    model character varying(1024),
    property character varying(1024),
    accesstype character varying(1024),
    permission character varying(1024),
    principaltype character varying(1024),
    principalid character varying(1024),
    id serial PRIMARY KEY
);
ALTER TABLE public.acl OWNER TO postgres;


DROP TABLE IF EXISTS application CASCADE;
CREATE TABLE application (
    id character varying(1024) PRIMARY KEY,
    realm character varying(1024),
    name character varying(1024) NOT NULL,
    description character varying(1024),
    icon character varying(1024),
    owner jsonb,
    collaborators jsonb,
    email character varying(1024),
    emailverified boolean,
    url character varying(1024),
    callbackurls character varying(1024),
    permissions jsonb,
    clientkey character varying(1024),
    javascriptkey character varying(1024),
    restapikey character varying(1024),
    windowskey character varying(1024),
    masterkey character varying(1024),
    pushsettings jsonb,
    authenticationenabled boolean,
    anonymousallowed boolean,
    authenticationschemes character varying(1024),
    status character varying(1024),
    created timestamp with time zone,
    modified timestamp with time zone
);
ALTER TABLE public.application OWNER TO postgres;


DROP TABLE IF EXISTS "user" CASCADE;
CREATE TABLE "user" (
    realm character varying(1024),
    username character varying(1024),
    password character varying(1024) NOT NULL,
    credentials character varying(1024),
    challenges character varying(1024),
    email character varying(1024) NOT NULL,
    emailverified boolean,
    verificationtoken character varying(1024),
    status character varying(1024),
    created timestamp with time zone,
    lastupdated timestamp with time zone,
    id serial PRIMARY KEY
);
ALTER TABLE public."user" OWNER TO postgres;


DROP TABLE IF EXISTS oauthaccesstoken CASCADE;
CREATE TABLE oauthaccesstoken (
    id character varying(300) PRIMARY KEY,
    appid character varying(128),
    userid integer,
    issuedat timestamp with time zone,
    expiresin integer,
    expiredat timestamp with time zone,
    scopes jsonb,
    parameters jsonb,
    authorizationcode character varying(300),
    refreshtoken character varying(300),
    tokentype character varying(1024),
    hash character varying(1024)
);
ALTER TABLE public.oauthaccesstoken OWNER TO postgres;


DROP TABLE IF EXISTS oauthauthorizationcode CASCADE;
CREATE TABLE oauthauthorizationcode (
    id character varying(300) PRIMARY KEY,
    appid character varying(128),
    userid integer,
    issuedat timestamp with time zone,
    expiresin integer,
    expiredat timestamp with time zone,
    scopes jsonb,
    parameters jsonb,
    used boolean,
    redirecturi character varying(1024),
    hash character varying(1024)
);
ALTER TABLE public.oauthauthorizationcode OWNER TO postgres;


DROP TABLE IF EXISTS oauthclientapplication CASCADE;
CREATE TABLE oauthclientapplication (
    id character varying(128) PRIMARY KEY,
    clienttype character varying(1024),
    redirecturis character varying(1024),
    tokenendpointauthmethod character varying(1024),
    granttypes jsonb,
    responsetypes character varying(1024),
    tokentype character varying(1024),
    clientsecret character varying(1024),
    clientname character varying(1024),
    clienturi character varying(1024),
    logouri character varying(1024),
    scopes jsonb,
    contacts jsonb,
    tosuri character varying(1024),
    policyuri character varying(1024),
    jwksuri character varying(1024),
    jwks character varying(1024),
    softwareid character varying(1024),
    softwareversion character varying(1024),
    realm character varying(1024),
    name character varying(1024) NOT NULL,
    description character varying(1024),
    owner jsonb,
    collaborators jsonb,
    email character varying(1024),
    emailverified boolean,
    clientkey character varying(1024),
    javascriptkey character varying(1024),
    restapikey character varying(1024),
    windowskey character varying(1024),
    masterkey character varying(1024),
    pushsettings character varying(1024),
    status character varying(1024),
    created timestamp with time zone,
    modified timestamp with time zone
);
ALTER TABLE public.oauthclientapplication OWNER TO postgres;


DROP TABLE IF EXISTS oauthpermission CASCADE;
CREATE TABLE oauthpermission (
    appid character varying(128),
    userid integer,
    issuedat timestamp with time zone,
    expiresin integer,
    expiredat timestamp with time zone,
    scopes jsonb,
    id serial PRIMARY KEY
);
ALTER TABLE public.oauthpermission OWNER TO postgres;


DROP TABLE IF EXISTS oauthscope CASCADE;
CREATE TABLE oauthscope (
    scope character varying(1024) PRIMARY KEY,
    description character varying(1024),
    iconurl character varying(1024),
    ttl integer
);
ALTER TABLE public.oauthscope OWNER TO postgres;


DROP TABLE IF EXISTS oauthscopemapping CASCADE;
CREATE TABLE oauthscopemapping (
    scope character varying(255),
    route character varying(1024),
    id integer NOT NULL
);
ALTER TABLE public.oauthscopemapping OWNER TO postgres;


DROP TABLE IF EXISTS role CASCADE;
CREATE TABLE role (
    id serial PRIMARY KEY,
    name character varying(1024) NOT NULL,
    description character varying(1024),
    created timestamp with time zone,
    modified timestamp with time zone
);
ALTER TABLE public.role OWNER TO postgres;


DROP TABLE IF EXISTS rolemapping CASCADE;
CREATE TABLE rolemapping (
    id serial PRIMARY KEY,
    principaltype character varying(1024),
    principalid character varying(1024),
    roleid integer
);
ALTER TABLE public.rolemapping OWNER TO postgres;


-- CREATE FOREIGN KEYS
ALTER TABLE accesstoken
  ADD FOREIGN KEY(userid)
  REFERENCES "user" (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE oauthaccesstoken
  ADD FOREIGN KEY(userid)
  REFERENCES "user" (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,

  ADD FOREIGN KEY(appid)
  REFERENCES oauthclientapplication (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE oauthauthorizationcode
  ADD FOREIGN KEY(userid)
  REFERENCES "user" (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,

  ADD FOREIGN KEY(appid)
  REFERENCES oauthclientapplication (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE oauthpermission
  ADD FOREIGN KEY(userid)
  REFERENCES "user" (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,

  ADD FOREIGN KEY(appid)
  REFERENCES oauthclientapplication (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE rolemapping
  ADD FOREIGN KEY(roleid)
  REFERENCES role (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION;


-- CREATE INDEX
CREATE INDEX oauthaccesstoken_appid_idx ON oauthaccesstoken USING btree (appid);
CREATE INDEX oauthaccesstoken_authorizationcode_idx ON oauthaccesstoken USING btree (authorizationcode);
CREATE INDEX oauthaccesstoken_expiredat_idx ON oauthaccesstoken USING btree (expiredat);
CREATE INDEX oauthaccesstoken_issuedat_idx ON oauthaccesstoken USING btree (issuedat);
CREATE INDEX oauthaccesstoken_refreshtoken_idx ON oauthaccesstoken USING btree (refreshtoken);
CREATE INDEX oauthaccesstoken_userid_idx ON oauthaccesstoken USING btree (userid);
CREATE INDEX oauthauthorizationcode_appid_idx ON oauthauthorizationcode USING btree (appid);
CREATE INDEX oauthauthorizationcode_expiredat_idx ON oauthauthorizationcode USING btree (expiredat);
CREATE INDEX oauthauthorizationcode_issuedat_idx ON oauthauthorizationcode USING btree (issuedat);
CREATE INDEX oauthauthorizationcode_userid_idx ON oauthauthorizationcode USING btree (userid);
CREATE INDEX oauthpermission_appid_idx ON oauthpermission USING btree (appid);
CREATE INDEX oauthpermission_expiredat_idx ON oauthpermission USING btree (expiredat);
CREATE INDEX oauthpermission_issuedat_idx ON oauthpermission USING btree (issuedat);
CREATE INDEX oauthpermission_userid_idx ON oauthpermission USING btree (userid);
CREATE INDEX oauthscopemapping_scope_idx ON oauthscopemapping USING btree (scope);

-- SCHEMA ACCESS
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT  ALL ON SCHEMA public TO   postgres;
GRANT  ALL ON SCHEMA public TO   PUBLIC;
