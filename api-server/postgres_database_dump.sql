--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.5

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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.authtoken_token OWNER TO postgres;

--
-- Name: core_datastoreinfo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_datastoreinfo (
    id integer NOT NULL,
    title character varying(128) NOT NULL,
    parameters character varying(2048) NOT NULL,
    type_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_datastoreinfo OWNER TO postgres;

--
-- Name: core_datastoreinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_datastoreinfo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_datastoreinfo_id_seq OWNER TO postgres;

--
-- Name: core_datastoreinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_datastoreinfo_id_seq OWNED BY public.core_datastoreinfo.id;


--
-- Name: core_datastoretype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_datastoretype (
    id integer NOT NULL,
    title character varying(128) NOT NULL,
    parameters character varying(2048) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_datastoretype OWNER TO postgres;

--
-- Name: core_datastoretype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_datastoretype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_datastoretype_id_seq OWNER TO postgres;

--
-- Name: core_datastoretype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_datastoretype_id_seq OWNED BY public.core_datastoretype.id;


--
-- Name: core_document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_document (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    institute_name character varying(255) NOT NULL,
    document_type character varying(255) NOT NULL,
    text text NOT NULL,
    highlighted text NOT NULL,
    transactions_json text NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_document OWNER TO postgres;

--
-- Name: core_document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_document_id_seq OWNER TO postgres;

--
-- Name: core_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_document_id_seq OWNED BY public.core_document.id;


--
-- Name: core_extractor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_extractor (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    institute_name character varying(255) NOT NULL,
    document_type character varying(255) NOT NULL,
    regex_parser character varying(2048) NOT NULL,
    reference character varying(512) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_extractor OWNER TO postgres;

--
-- Name: core_extractor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_extractor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_extractor_id_seq OWNER TO postgres;

--
-- Name: core_extractor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_extractor_id_seq OWNED BY public.core_extractor.id;


--
-- Name: core_file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_file (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    institute_name character varying(255) NOT NULL,
    document_type character varying(255) NOT NULL,
    file character varying(100) NOT NULL,
    password character varying(64) NOT NULL,
    remark character varying(20) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    text text NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_file OWNER TO postgres;

--
-- Name: core_file_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_file_id_seq OWNER TO postgres;

--
-- Name: core_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_file_id_seq OWNED BY public.core_file.id;


--
-- Name: core_operation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_operation (
    id integer NOT NULL,
    title character varying(128) NOT NULL,
    type character varying(32) NOT NULL,
    parameters character varying(4096) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_operation OWNER TO postgres;

--
-- Name: core_operation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_operation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_operation_id_seq OWNER TO postgres;

--
-- Name: core_operation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_operation_id_seq OWNED BY public.core_operation.id;


--
-- Name: core_pipeline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_pipeline (
    id integer NOT NULL,
    institute_name character varying(255) NOT NULL,
    document_type character varying(255) NOT NULL,
    title character varying(128) NOT NULL,
    operations_json character varying(2048) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_pipeline OWNER TO postgres;

--
-- Name: core_pipeline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_pipeline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_pipeline_id_seq OWNER TO postgres;

--
-- Name: core_pipeline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_pipeline_id_seq OWNED BY public.core_pipeline.id;


--
-- Name: core_pipeline_operations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_pipeline_operations (
    id integer NOT NULL,
    pipeline_id integer NOT NULL,
    operation_id integer NOT NULL
);


ALTER TABLE public.core_pipeline_operations OWNER TO postgres;

--
-- Name: core_pipeline_operations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_pipeline_operations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_pipeline_operations_id_seq OWNER TO postgres;

--
-- Name: core_pipeline_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_pipeline_operations_id_seq OWNED BY public.core_pipeline_operations.id;


--
-- Name: core_schema; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_schema (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    fields_json character varying(2048) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_schema OWNER TO postgres;

--
-- Name: core_schema_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_schema_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_schema_id_seq OWNER TO postgres;

--
-- Name: core_schema_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_schema_id_seq OWNED BY public.core_schema.id;


--
-- Name: core_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_tag (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_tag OWNER TO postgres;

--
-- Name: core_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_tag_id_seq OWNER TO postgres;

--
-- Name: core_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_tag_id_seq OWNED BY public.core_tag.id;


--
-- Name: core_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_transaction (
    id integer NOT NULL,
    "TradeDate" timestamp with time zone NOT NULL,
    "Scrip" character varying(64) NOT NULL,
    "Symbol" character varying(64) NOT NULL,
    "SettleDate" timestamp with time zone NOT NULL,
    "TradeQuantity" numeric(10,2) NOT NULL,
    "TradeType" character varying(16) NOT NULL,
    "PrincipalAmount" numeric(20,4) NOT NULL,
    "Commission" numeric(10,4) NOT NULL,
    "Fees" numeric(10,4) NOT NULL,
    "NetAmount" numeric(20,4) NOT NULL,
    doc_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_transaction OWNER TO postgres;

--
-- Name: core_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_transaction_id_seq OWNER TO postgres;

--
-- Name: core_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_transaction_id_seq OWNED BY public.core_transaction.id;


--
-- Name: core_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    is_active boolean NOT NULL,
    is_staff boolean NOT NULL
);


ALTER TABLE public.core_user OWNER TO postgres;

--
-- Name: core_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.core_user_groups OWNER TO postgres;

--
-- Name: core_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_user_groups_id_seq OWNER TO postgres;

--
-- Name: core_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_user_groups_id_seq OWNED BY public.core_user_groups.id;


--
-- Name: core_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_user_id_seq OWNER TO postgres;

--
-- Name: core_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_user_id_seq OWNED BY public.core_user.id;


--
-- Name: core_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.core_user_user_permissions OWNER TO postgres;

--
-- Name: core_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: core_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_user_user_permissions_id_seq OWNED BY public.core_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: core_datastoreinfo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_datastoreinfo ALTER COLUMN id SET DEFAULT nextval('public.core_datastoreinfo_id_seq'::regclass);


--
-- Name: core_datastoretype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_datastoretype ALTER COLUMN id SET DEFAULT nextval('public.core_datastoretype_id_seq'::regclass);


--
-- Name: core_document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_document ALTER COLUMN id SET DEFAULT nextval('public.core_document_id_seq'::regclass);


--
-- Name: core_extractor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_extractor ALTER COLUMN id SET DEFAULT nextval('public.core_extractor_id_seq'::regclass);


--
-- Name: core_file id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_file ALTER COLUMN id SET DEFAULT nextval('public.core_file_id_seq'::regclass);


--
-- Name: core_operation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_operation ALTER COLUMN id SET DEFAULT nextval('public.core_operation_id_seq'::regclass);


--
-- Name: core_pipeline id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_pipeline ALTER COLUMN id SET DEFAULT nextval('public.core_pipeline_id_seq'::regclass);


--
-- Name: core_pipeline_operations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_pipeline_operations ALTER COLUMN id SET DEFAULT nextval('public.core_pipeline_operations_id_seq'::regclass);


--
-- Name: core_schema id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_schema ALTER COLUMN id SET DEFAULT nextval('public.core_schema_id_seq'::regclass);


--
-- Name: core_tag id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_tag ALTER COLUMN id SET DEFAULT nextval('public.core_tag_id_seq'::regclass);


--
-- Name: core_transaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_transaction ALTER COLUMN id SET DEFAULT nextval('public.core_transaction_id_seq'::regclass);


--
-- Name: core_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user ALTER COLUMN id SET DEFAULT nextval('public.core_user_id_seq'::regclass);


--
-- Name: core_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_groups ALTER COLUMN id SET DEFAULT nextval('public.core_user_groups_id_seq'::regclass);


--
-- Name: core_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.core_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add content type	4	add_contenttype
14	Can change content type	4	change_contenttype
15	Can delete content type	4	delete_contenttype
16	Can view content type	4	view_contenttype
17	Can add session	5	add_session
18	Can change session	5	change_session
19	Can delete session	5	delete_session
20	Can view session	5	view_session
21	Can add cors model	6	add_corsmodel
22	Can change cors model	6	change_corsmodel
23	Can delete cors model	6	delete_corsmodel
24	Can view cors model	6	view_corsmodel
25	Can add Token	7	add_token
26	Can change Token	7	change_token
27	Can delete Token	7	delete_token
28	Can view Token	7	view_token
29	Can add user	8	add_user
30	Can change user	8	change_user
31	Can delete user	8	delete_user
32	Can view user	8	view_user
33	Can add datastore info	9	add_datastoreinfo
34	Can change datastore info	9	change_datastoreinfo
35	Can delete datastore info	9	delete_datastoreinfo
36	Can view datastore info	9	view_datastoreinfo
37	Can add datastore type	10	add_datastoretype
38	Can change datastore type	10	change_datastoretype
39	Can delete datastore type	10	delete_datastoretype
40	Can view datastore type	10	view_datastoretype
41	Can add document	11	add_document
42	Can change document	11	change_document
43	Can delete document	11	delete_document
44	Can view document	11	view_document
45	Can add extractor	12	add_extractor
46	Can change extractor	12	change_extractor
47	Can delete extractor	12	delete_extractor
48	Can view extractor	12	view_extractor
49	Can add file	13	add_file
50	Can change file	13	change_file
51	Can delete file	13	delete_file
52	Can view file	13	view_file
53	Can add operation	14	add_operation
54	Can change operation	14	change_operation
55	Can delete operation	14	delete_operation
56	Can view operation	14	view_operation
57	Can add pipeline	15	add_pipeline
58	Can change pipeline	15	change_pipeline
59	Can delete pipeline	15	delete_pipeline
60	Can view pipeline	15	view_pipeline
61	Can add schema	16	add_schema
62	Can change schema	16	change_schema
63	Can delete schema	16	delete_schema
64	Can view schema	16	view_schema
65	Can add tag	17	add_tag
66	Can change tag	17	change_tag
67	Can delete tag	17	delete_tag
68	Can view tag	17	view_tag
69	Can add transaction	18	add_transaction
70	Can change transaction	18	change_transaction
71	Can delete transaction	18	delete_transaction
72	Can view transaction	18	view_transaction
\.


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authtoken_token (key, created, user_id) FROM stdin;
2d3fe956e20b609f91c3afb3b6285a7b82737c29	2019-10-17 15:04:39.402809+05:30	1
\.


--
-- Data for Name: core_datastoreinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_datastoreinfo (id, title, parameters, type_id, user_id) FROM stdin;
1	Postgres_Store	{"user":"postgres","password":"Postgres123","host":"localhost","port":"5432","database":"docminer"}	2	1
\.


--
-- Data for Name: core_datastoretype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_datastoretype (id, title, parameters, user_id) FROM stdin;
2	Postgres	[\n{"name":"username", "mandatory":"True","type":"String"},\n{"name":"password", "mandatory":"True","type":"String"},\n{"name":"host", "mandatory":"True","type":"String"},\n{"name":"port", "mandatory":"True","type":"String"},\n{"name":"database", "mandatory":"True","type":"String"}\n]	1
\.


--
-- Data for Name: core_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_document (id, title, institute_name, document_type, text, highlighted, transactions_json, user_id) FROM stdin;
1	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n062120180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 2 1 BUY 1 $.74 Margin PRINCIPAL $74.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $0.15\nOPEN CONTRACT OPT REG FEE $0.02\nNET AMOUNT $74.17\n06/21/18 06/22/18 3 1 BUY 41 $.74 Margin PRINCIPAL $3,034.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $14.65\nOPEN CONTRACT OPT REG FEE $0.68\nNET AMOUNT $3,049.33\n06/21/18 06/22/18 3 4 BUY 11 $.73 Margin PRINCIPAL $803.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $10.15\nOPEN CONTRACT OPT REG FEE $0.18\nNET AMOUNT $813.33\n06/21/18 06/22/18 5 1 SELL 84 $.66 Margin PRINCIPAL $5,544.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $12.60\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.17\n1.40\n0.08\nNET AMOUNT $5,529.75\n06/21/18 06/22/18 5 1 BUY 46 $.73 Margin PRINCIPAL $3,358.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,365.67\n06/21/18 06/22/18 5 1 BUY 46 $.74 Margin PRINCIPAL $3,404.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,411.67\n\f237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 6 1 BUY 55 $.74 Margin PRINCIPAL $4,070.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $8.25\nOPEN CONTRACT OPT REG FEE $0.92\nNET AMOUNT $4,079.17\n06/21/18 06/22/18 3 1 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $9.70\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $518.16\n06/21/18 06/22/18 3 4 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $1.20\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $526.66\n\fThis Page Intentionally Left Blank\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\f		Format .pdf not supported	1
2	Sample PDF	Etrade	ContractNote	Date               ,Time        ,INR / 1 USD,INR / 1 GBP,INR / 1 EUR,INR / 100 JPY,Comments\n2018-07-10,13:30:00,68.7942,91.1051,80.78,61.93,\n2018-07-11,13:30:00,68.829,91.3453,80.7947,61.98,\n2018-07-12,13:30:00,68.6313,90.672,80.165,61.15,\n2018-07-13,13:30:00,68.4094,90.071,79.7617,60.77,\n2018-07-16,13:30:00,68.5877,90.8481,80.2526,61.02,\n2018-07-17,13:30:00,68.2978,90.516,80.1006,60.78,\n2018-07-18,13:30:00,68.5652,89.7258,79.7363,60.65,\n2018-07-19,13:30:00,68.8331,89.93,80.1153,61.01,\n2018-07-20,13:30:00,68.8458,89.6671,80.3114,61.27,\n2018-07-23,13:30:00,68.704,90.2766,80.5619,61.93,\n2018-07-24,13:30:00,69.053,90.3015,80.5434,61.98,\n2018-07-25,13:30:00,68.8028,90.5812,80.4497,61.88,\n2018-07-26,13:30:00,68.7017,90.6633,80.6045,62.09,\n2018-07-27,13:30:00,68.7041,89.9891,79.9821,61.84,\n2018-07-30,13:30:00,68.7531,90.1454,80.1597,61.89,\n2018-07-31,13:30:00,68.6068,90.0862,80.3687,61.69,\n2018-08-01,13:30:00,68.6058,89.9344,80.1151,61.21,\n2018-08-02,13:30:00,68.3566,89.5221,79.5748,61.23,\n2018-08-03,13:30:00,68.7933,89.5171,79.6746,61.58,\n2018-08-06,13:30:00,68.6833,89.2585,79.3805,61.71,\n2018-08-07,13:30:00,68.8,89.135,79.5599,61.81,\n2018-08-08,13:30:00,68.6465,88.8167,79.7169,61.74,\n2018-08-09,13:30:00,68.624,88.3475,79.6327,61.8,\n2018-08-10,13:30:00,68.9538,88.1901,78.9985,62.15,\n2018-08-13,13:30:00,69.4685,88.6274,79.1876,62.97,\n2018-08-14,13:30:00,69.7696,89.2311,79.6997,62.9,\n2018-08-16,13:30:00,70.2287,89.367,79.9718,63.35,\n2018-08-20,13:30:00,69.7617,88.8741,79.672,63.09,\n2018-08-21,13:30:00,69.6668,89.3997,80.2478,63.3,\n2018-08-23,13:30:00,70.0656,90.2576,81.0486,63.21,\n2018-08-24,13:30:00,70.1377,89.9694,81.1699,62.98,\n2018-08-27,13:30:00,70.0366,89.9541,81.3032,63.07,\n2018-08-28,13:30:00,70.1687,90.3263,81.9266,63.08,\n2018-08-29,13:30:00,70.5046,90.6257,82.3376,63.42,\n2018-08-30,13:30:00,70.7329,92.1518,82.7184,63.34,\n2018-08-31,13:30:00,70.9255,92.353,82.8391,63.91,\n2018-09-03,13:30:00,70.7695,91.3582,82.1445,63.8,\n2018-09-04,13:30:00,71.1857,91.4603,82.4919,63.92,\n2018-09-05,13:30:00,71.7533,92.2255,83.131,64.36,\n2018-09-06,13:30:00,71.9214,92.8007,83.6005,64.56,\n2018-09-07,13:30:00,71.9009,93.0364,83.6744,64.98,\n2018-09-10,13:30:00,72.5745,93.7396,83.8081,65.42,\n2018-09-11,13:30:00,72.3227,94.4182,84.0771,64.89,\n2018-09-12,13:30:00,72.7549,94.6211,84.3244,65.22,\n2018-09-14,13:30:00,71.8129,94.1553,83.9771,64.19,\n2018-09-17,13:30:00,72.5505,94.9405,84.3985,64.78,\n2018-09-18,13:30:00,72.3796,95.2897,84.7657,64.59,\n2018-09-19,13:30:00,72.6781,95.5925,84.905,64.69,\n2018-09-21,13:30:00,71.8489,95.15,84.683,63.67,\n2018-09-24,13:30:00,72.6927,94.9953,85.2535,64.61,\n2018-09-25,13:30:00,72.8134,95.5016,85.6237,64.47,\n2018-09-26,13:30:00,72.7182,95.7699,85.5365,64.42,\n2018-09-27,13:30:00,72.6505,95.4347,85.0418,64.47,\n2018-09-28,13:30:00,72.5474,94.908,84.4428,63.9,\n2018-10-01,13:30:00,72.8036,94.8825,84.3799,63.89,\n2018-10-03,13:30:00,73.0299,94.988,84.5784,64.18,\n2018-10-04,13:30:00,73.7509,95.3904,84.6257,64.49,\n2018-10-05,13:30:00,73.5809,95.8877,84.6975,64.59,\n2018-10-08,13:30:00,73.9235,96.8575,85.0613,64.96,\n2018-10-09,13:30:00,74.0989,96.9895,85.108,65.51,\n2018-10-10,13:30:00,74.1316,97.6284,85.2637,65.6,\n2018-10-11,13:30:00,74.3875,98.2961,85.9012,66.29,\n2018-10-12,13:30:00,73.7967,97.6537,85.5545,65.67,\n2018-10-15,13:30:00,73.9708,97.0832,85.4895,66.08,\n2018-10-16,13:30:00,73.9041,97.3327,85.575,65.95,\n2018-10-17,13:30:00,73.4846,96.8684,84.98,65.47,\n2018-10-19,13:30:00,73.4354,95.6525,84.1741,65.27,\n2018-10-22,13:30:00,73.3025,95.9305,84.573,65.02,\n2018-10-23,13:30:00,73.7818,95.5568,84.4743,65.62,\n2018-10-24,13:30:00,73.2645,95.0529,83.9934,65.13,\n2018-10-25,13:30:00,73.2746,94.619,83.6478,65.33,\n2018-10-26,13:30:00,73.374,94.0503,83.4077,65.41,\n2018-10-29,13:30:00,73.4181,94.2644,83.6942,65.62,\n2018-10-30,13:30:00,73.5709,94.184,83.7114,65.28,\n2018-10-31,13:30:00,73.9936,94.1016,83.925,65.36,\n2018-11-01,13:30:00,73.8295,94.8182,83.7261,65.4,\n2018-11-02,13:30:00,72.8798,94.753,83.2292,64.47,\n2018-11-05,13:30:00,73.074,94.9845,83.2566,64.5,\n2018-11-06,13:30:00,73.0097,95.302,83.2632,64.37,\n2018-11-09,13:30:00,72.7347,94.8737,82.5195,63.84,\n2018-11-12,13:30:00,72.9078,93.9947,82.4315,63.91,\n2018-11-13,13:30:00,72.5853,93.4908,81.611,63.69,\n2018-11-14,13:30:00,72.1039,93.6961,81.4361,63.31,\n2018-11-15,13:30:00,72.16,93.9518,81.8256,63.55,\n2018-11-16,13:30:00,71.8023,91.9247,81.4626,63.37,\n2018-11-19,13:30:00,71.9007,92.1983,81.9419,63.74,\n2018-11-20,13:30:00,71.3276,91.7197,81.6867,63.4,\n2018-11-22,13:30:00,71.1787,91.0423,81.1883,62.97,\n2018-11-26,13:30:00,70.7144,90.6478,80.266,62.47,\n2018-11-27,13:30:00,70.9065,90.8369,80.4207,62.49,\n2018-11-28,13:30:00,70.6881,90.1368,79.8752,62.08,\n2018-11-29,13:30:00,69.9159,89.7389,79.5801,61.71,\n2018-11-30,13:30:00,69.6574,89.0848,79.3588,61.43,\n2018-12-03,13:30:00,70.028,89.5005,79.5887,61.69,\n2018-12-04,13:30:00,70.3455,89.645,80.079,62.21,\n2018-12-05,13:30:00,70.5171,89.4458,79.8366,62.37,\n2018-12-06,13:30:00,71.0371,90.2953,80.5457,62.99,\n2018-12-07,13:30:00,70.5663,90.1212,80.2245,62.53,\n2018-12-10,13:30:00,71.3257,90.9108,81.5738,63.43,\n2018-12-11,13:30:00,71.9274,90.4266,81.7325,63.57,\n2018-12-12,13:30:00,72.0407,90.0393,81.5928,63.5,\n2018-12-13,13:30:00,71.5368,90.3095,81.3407,63.06,\n2018-12-14,13:30:00,71.7359,90.5809,81.4628,63.2,\n2018-12-17,13:30:00,71.673,90.1981,81.0717,63.17,\n2018-12-18,13:30:00,71.194,89.8829,80.7554,63.21,\n2018-12-19,13:30:00,70.1094,88.7431,79.8153,62.38,\n2018-12-20,13:30:00,70.2835,88.8454,80.0548,62.79,\n2018-12-21,13:30:00,70.0368,88.7016,80.2127,62.87,\n2018-12-24,13:30:00,70.1757,88.871,79.8824,63.16,\n2018-12-26,13:30:00,69.9906,88.9581,79.8196,63.36,\n2018-12-27,13:30:00,70.327,88.9829,80.0223,63.25,\n2018-12-28,13:30:00,69.9786,88.6564,80.1805,63.28,\n2018-12-31,13:30:00,69.7923,88.5488,79.7805,63.21,\n2019-01-01,13:30:00,69.7131,88.9748,79.933,63.57,GBP & JPY as per New York closing Mid Quote\n2019-01-02,13:30:00,69.6089,88.8261,79.9635,63.75,\n2019-01-03,13:30:00,70.3627,88.2756,79.9208,65.8,\n2019-01-04,13:30:00,69.8653,88.2599,79.5659,64.6,\n2019-01-07,13:30:00,69.4814,88.5943,79.389,64.21,\n2019-01-08,13:30:00,70.0221,89.4238,80.1576,64.37,\n2019-01-09,13:30:00,70.4418,89.7231,80.7099,64.71,\n2019-01-10,13:30:00,70.5135,90.1656,81.492,65.4,\n2019-01-11,13:30:00,70.4737,89.9155,81.2083,65.03,\n2019-01-14,13:30:00,70.8244,90.964,81.2469,65.5,\n2019-01-15,13:30:00,71.0298,91.6242,81.5048,65.37,\n2019-01-16,13:30:00,71.1847,91.4619,81.1762,65.62,\n2019-01-17,13:30:00,71.3418,91.8616,81.2583,65.51,\n2019-01-18,13:30:00,71.1418,92.2946,81.0656,65.04,\n2019-01-21,13:30:00,71.3782,91.8913,81.2308,65.15,\n2019-01-22,13:30:00,71.3761,91.8963,81.0438,65.23,\n2019-01-23,13:30:00,71.2039,92.2067,80.9394,64.94,\n2019-01-24,13:30:00,71.282,93.1456,81.1113,64.97,\n2019-01-25,13:30:00,71.1051,93.2396,80.4986,64.74,\n2019-01-28,13:30:00,71.134,93.8224,81.1482,65.05,\n2019-01-29,13:30:00,71.0942,93.5453,81.318,65.05,\n2019-01-30,13:30:00,71.2442,93.2867,81.538,65.2,\n2019-01-31,13:30:00,71.0333,93.2383,81.6836,65.3,\n2019-02-01,13:30:00,71.1102,93.1681,81.3425,65.31,\n2019-02-04,13:30:00,71.658,93.7067,81.9997,65.29,\n2019-02-05,13:30:00,71.7459,93.5624,82.0147,65.29,\n2019-02-06,13:30:00,71.5731,92.6886,81.5461,65.21,\n2019-02-07,13:30:00,71.4688,92.4478,81.2024,65.0,\n2019-02-08,13:30:00,71.2949,92.2936,80.8304,64.98,\n2019-02-11,13:30:00,71.1621,92.0216,80.5882,64.71,\n2019-02-12,13:30:00,70.9353,91.262,80.0259,64.15,\n2019-02-13,13:30:00,70.5547,91.1327,79.9596,63.78,\n2019-02-14,13:30:00,70.9408,91.2791,79.9966,63.88,\n2019-02-15,13:30:00,71.2515,91.2261,80.4168,64.55,\n2019-02-18,13:30:00,71.4705,92.2689,80.8117,64.64,\n2019-02-20,13:30:00,71.1773,92.9272,80.7075,64.21,\n2019-02-21,13:30:00,71.154,92.7213,80.6203,64.24,\n2019-02-22,13:30:00,71.2177,92.8271,80.7528,64.29,\n2019-02-25,13:30:00,71.042,92.8808,80.6028,64.22,\n2019-02-26,13:30:00,71.0952,93.3594,80.7471,64.16,\n2019-02-27,13:30:00,71.1663,94.2152,80.9668,64.38,\n2019-02-28,13:30:00,71.1953,94.7021,80.979,64.24,\n2019-03-01,13:30:00,70.9696,94.0868,80.7161,63.49,\n2019-03-05,13:30:00,70.7601,93.1179,80.1594,63.23,\n2019-03-06,13:30:00,70.5798,92.7197,79.766,63.13,\n2019-03-07,13:30:00,70.0268,92.2575,79.17,62.66,\n2019-03-08,13:30:00,70.101,91.7954,78.5463,63.13,\n2019-03-11,13:30:00,69.9308,90.7916,78.571,62.93,\n2019-03-12,13:30:00,69.595,91.8714,78.3366,62.54,\n2019-03-13,13:30:00,69.6225,91.1535,78.5709,62.55,\n2019-03-14,13:30:00,69.6657,92.288,78.8416,62.43,\n2019-03-15,13:30:00,69.2131,91.6437,78.3368,61.99,\n2019-03-18,13:30:00,68.6088,91.1184,77.7827,61.5,\n2019-03-19,13:30:00,68.5847,91.0069,77.8185,61.66,\n2019-03-20,13:30:00,68.8604,91.2846,78.1446,61.72,\n2019-03-22,13:30:00,68.6607,90.2778,78.1368,61.97,\n2019-03-25,13:30:00,68.9903,90.8731,77.9735,62.76,\n2019-03-26,13:30:00,68.8469,90.7737,77.8663,62.55,\n2019-03-27,13:30:00,68.903,90.8753,77.6041,62.33,\n2019-03-28,13:30:00,69.0038,91.028,77.6868,62.69,\n2019-03-29,13:30:00,69.1713,90.4756,77.7024,62.52,\n		[{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1531180800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.7942,"INR \\/ 1 GBP":91.1051,"INR \\/ 1 EUR":80.78,"INR \\/ 100 JPY":61.93,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1531267200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.829,"INR \\/ 1 GBP":91.3453,"INR \\/ 1 EUR":80.7947,"INR \\/ 100 JPY":61.98,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1531353600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.6313,"INR \\/ 1 GBP":90.672,"INR \\/ 1 EUR":80.165,"INR \\/ 100 JPY":61.15,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1531440000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.4094,"INR \\/ 1 GBP":90.071,"INR \\/ 1 EUR":79.7617,"INR \\/ 100 JPY":60.77,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1531699200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.5877,"INR \\/ 1 GBP":90.8481,"INR \\/ 1 EUR":80.2526,"INR \\/ 100 JPY":61.02,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1531785600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.2978,"INR \\/ 1 GBP":90.516,"INR \\/ 1 EUR":80.1006,"INR \\/ 100 JPY":60.78,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1531872000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.5652,"INR \\/ 1 GBP":89.7258,"INR \\/ 1 EUR":79.7363,"INR \\/ 100 JPY":60.65,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1531958400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.8331,"INR \\/ 1 GBP":89.93,"INR \\/ 1 EUR":80.1153,"INR \\/ 100 JPY":61.01,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1532044800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.8458,"INR \\/ 1 GBP":89.6671,"INR \\/ 1 EUR":80.3114,"INR \\/ 100 JPY":61.27,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1532304000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.704,"INR \\/ 1 GBP":90.2766,"INR \\/ 1 EUR":80.5619,"INR \\/ 100 JPY":61.93,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1532390400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.053,"INR \\/ 1 GBP":90.3015,"INR \\/ 1 EUR":80.5434,"INR \\/ 100 JPY":61.98,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1532476800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.8028,"INR \\/ 1 GBP":90.5812,"INR \\/ 1 EUR":80.4497,"INR \\/ 100 JPY":61.88,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1532563200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.7017,"INR \\/ 1 GBP":90.6633,"INR \\/ 1 EUR":80.6045,"INR \\/ 100 JPY":62.09,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1532649600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.7041,"INR \\/ 1 GBP":89.9891,"INR \\/ 1 EUR":79.9821,"INR \\/ 100 JPY":61.84,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1532908800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.7531,"INR \\/ 1 GBP":90.1454,"INR \\/ 1 EUR":80.1597,"INR \\/ 100 JPY":61.89,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1532995200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.6068,"INR \\/ 1 GBP":90.0862,"INR \\/ 1 EUR":80.3687,"INR \\/ 100 JPY":61.69,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1533081600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.6058,"INR \\/ 1 GBP":89.9344,"INR \\/ 1 EUR":80.1151,"INR \\/ 100 JPY":61.21,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1533168000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.3566,"INR \\/ 1 GBP":89.5221,"INR \\/ 1 EUR":79.5748,"INR \\/ 100 JPY":61.23,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1533254400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.7933,"INR \\/ 1 GBP":89.5171,"INR \\/ 1 EUR":79.6746,"INR \\/ 100 JPY":61.58,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1533513600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.6833,"INR \\/ 1 GBP":89.2585,"INR \\/ 1 EUR":79.3805,"INR \\/ 100 JPY":61.71,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1533600000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.8,"INR \\/ 1 GBP":89.135,"INR \\/ 1 EUR":79.5599,"INR \\/ 100 JPY":61.81,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1533686400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.6465,"INR \\/ 1 GBP":88.8167,"INR \\/ 1 EUR":79.7169,"INR \\/ 100 JPY":61.74,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1533772800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.624,"INR \\/ 1 GBP":88.3475,"INR \\/ 1 EUR":79.6327,"INR \\/ 100 JPY":61.8,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1533859200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.9538,"INR \\/ 1 GBP":88.1901,"INR \\/ 1 EUR":78.9985,"INR \\/ 100 JPY":62.15,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1534118400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.4685,"INR \\/ 1 GBP":88.6274,"INR \\/ 1 EUR":79.1876,"INR \\/ 100 JPY":62.97,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1534204800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.7696,"INR \\/ 1 GBP":89.2311,"INR \\/ 1 EUR":79.6997,"INR \\/ 100 JPY":62.9,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1534377600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.2287,"INR \\/ 1 GBP":89.367,"INR \\/ 1 EUR":79.9718,"INR \\/ 100 JPY":63.35,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1534723200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.7617,"INR \\/ 1 GBP":88.8741,"INR \\/ 1 EUR":79.672,"INR \\/ 100 JPY":63.09,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1534809600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.6668,"INR \\/ 1 GBP":89.3997,"INR \\/ 1 EUR":80.2478,"INR \\/ 100 JPY":63.3,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1534982400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.0656,"INR \\/ 1 GBP":90.2576,"INR \\/ 1 EUR":81.0486,"INR \\/ 100 JPY":63.21,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1535068800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.1377,"INR \\/ 1 GBP":89.9694,"INR \\/ 1 EUR":81.1699,"INR \\/ 100 JPY":62.98,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1535328000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.0366,"INR \\/ 1 GBP":89.9541,"INR \\/ 1 EUR":81.3032,"INR \\/ 100 JPY":63.07,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1535414400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.1687,"INR \\/ 1 GBP":90.3263,"INR \\/ 1 EUR":81.9266,"INR \\/ 100 JPY":63.08,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1535500800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.5046,"INR \\/ 1 GBP":90.6257,"INR \\/ 1 EUR":82.3376,"INR \\/ 100 JPY":63.42,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1535587200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.7329,"INR \\/ 1 GBP":92.1518,"INR \\/ 1 EUR":82.7184,"INR \\/ 100 JPY":63.34,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1535673600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.9255,"INR \\/ 1 GBP":92.353,"INR \\/ 1 EUR":82.8391,"INR \\/ 100 JPY":63.91,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1535932800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.7695,"INR \\/ 1 GBP":91.3582,"INR \\/ 1 EUR":82.1445,"INR \\/ 100 JPY":63.8,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1536019200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1857,"INR \\/ 1 GBP":91.4603,"INR \\/ 1 EUR":82.4919,"INR \\/ 100 JPY":63.92,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1536105600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.7533,"INR \\/ 1 GBP":92.2255,"INR \\/ 1 EUR":83.131,"INR \\/ 100 JPY":64.36,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1536192000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.9214,"INR \\/ 1 GBP":92.8007,"INR \\/ 1 EUR":83.6005,"INR \\/ 100 JPY":64.56,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1536278400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.9009,"INR \\/ 1 GBP":93.0364,"INR \\/ 1 EUR":83.6744,"INR \\/ 100 JPY":64.98,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1536537600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.5745,"INR \\/ 1 GBP":93.7396,"INR \\/ 1 EUR":83.8081,"INR \\/ 100 JPY":65.42,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1536624000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.3227,"INR \\/ 1 GBP":94.4182,"INR \\/ 1 EUR":84.0771,"INR \\/ 100 JPY":64.89,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1536710400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.7549,"INR \\/ 1 GBP":94.6211,"INR \\/ 1 EUR":84.3244,"INR \\/ 100 JPY":65.22,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1536883200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.8129,"INR \\/ 1 GBP":94.1553,"INR \\/ 1 EUR":83.9771,"INR \\/ 100 JPY":64.19,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1537142400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.5505,"INR \\/ 1 GBP":94.9405,"INR \\/ 1 EUR":84.3985,"INR \\/ 100 JPY":64.78,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1537228800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.3796,"INR \\/ 1 GBP":95.2897,"INR \\/ 1 EUR":84.7657,"INR \\/ 100 JPY":64.59,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1537315200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.6781,"INR \\/ 1 GBP":95.5925,"INR \\/ 1 EUR":84.905,"INR \\/ 100 JPY":64.69,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1537488000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.8489,"INR \\/ 1 GBP":95.15,"INR \\/ 1 EUR":84.683,"INR \\/ 100 JPY":63.67,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1537747200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.6927,"INR \\/ 1 GBP":94.9953,"INR \\/ 1 EUR":85.2535,"INR \\/ 100 JPY":64.61,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1537833600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.8134,"INR \\/ 1 GBP":95.5016,"INR \\/ 1 EUR":85.6237,"INR \\/ 100 JPY":64.47,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1537920000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.7182,"INR \\/ 1 GBP":95.7699,"INR \\/ 1 EUR":85.5365,"INR \\/ 100 JPY":64.42,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1538006400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.6505,"INR \\/ 1 GBP":95.4347,"INR \\/ 1 EUR":85.0418,"INR \\/ 100 JPY":64.47,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1538092800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.5474,"INR \\/ 1 GBP":94.908,"INR \\/ 1 EUR":84.4428,"INR \\/ 100 JPY":63.9,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1538352000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.8036,"INR \\/ 1 GBP":94.8825,"INR \\/ 1 EUR":84.3799,"INR \\/ 100 JPY":63.89,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1538524800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.0299,"INR \\/ 1 GBP":94.988,"INR \\/ 1 EUR":84.5784,"INR \\/ 100 JPY":64.18,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1538611200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.7509,"INR \\/ 1 GBP":95.3904,"INR \\/ 1 EUR":84.6257,"INR \\/ 100 JPY":64.49,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1538697600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.5809,"INR \\/ 1 GBP":95.8877,"INR \\/ 1 EUR":84.6975,"INR \\/ 100 JPY":64.59,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1538956800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.9235,"INR \\/ 1 GBP":96.8575,"INR \\/ 1 EUR":85.0613,"INR \\/ 100 JPY":64.96,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1539043200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":74.0989,"INR \\/ 1 GBP":96.9895,"INR \\/ 1 EUR":85.108,"INR \\/ 100 JPY":65.51,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1539129600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":74.1316,"INR \\/ 1 GBP":97.6284,"INR \\/ 1 EUR":85.2637,"INR \\/ 100 JPY":65.6,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1539216000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":74.3875,"INR \\/ 1 GBP":98.2961,"INR \\/ 1 EUR":85.9012,"INR \\/ 100 JPY":66.29,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1539302400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.7967,"INR \\/ 1 GBP":97.6537,"INR \\/ 1 EUR":85.5545,"INR \\/ 100 JPY":65.67,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1539561600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.9708,"INR \\/ 1 GBP":97.0832,"INR \\/ 1 EUR":85.4895,"INR \\/ 100 JPY":66.08,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1539648000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.9041,"INR \\/ 1 GBP":97.3327,"INR \\/ 1 EUR":85.575,"INR \\/ 100 JPY":65.95,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1539734400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.4846,"INR \\/ 1 GBP":96.8684,"INR \\/ 1 EUR":84.98,"INR \\/ 100 JPY":65.47,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1539907200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.4354,"INR \\/ 1 GBP":95.6525,"INR \\/ 1 EUR":84.1741,"INR \\/ 100 JPY":65.27,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1540166400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.3025,"INR \\/ 1 GBP":95.9305,"INR \\/ 1 EUR":84.573,"INR \\/ 100 JPY":65.02,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1540252800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.7818,"INR \\/ 1 GBP":95.5568,"INR \\/ 1 EUR":84.4743,"INR \\/ 100 JPY":65.62,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1540339200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.2645,"INR \\/ 1 GBP":95.0529,"INR \\/ 1 EUR":83.9934,"INR \\/ 100 JPY":65.13,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1540425600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.2746,"INR \\/ 1 GBP":94.619,"INR \\/ 1 EUR":83.6478,"INR \\/ 100 JPY":65.33,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1540512000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.374,"INR \\/ 1 GBP":94.0503,"INR \\/ 1 EUR":83.4077,"INR \\/ 100 JPY":65.41,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1540771200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.4181,"INR \\/ 1 GBP":94.2644,"INR \\/ 1 EUR":83.6942,"INR \\/ 100 JPY":65.62,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1540857600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.5709,"INR \\/ 1 GBP":94.184,"INR \\/ 1 EUR":83.7114,"INR \\/ 100 JPY":65.28,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1540944000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.9936,"INR \\/ 1 GBP":94.1016,"INR \\/ 1 EUR":83.925,"INR \\/ 100 JPY":65.36,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1541030400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.8295,"INR \\/ 1 GBP":94.8182,"INR \\/ 1 EUR":83.7261,"INR \\/ 100 JPY":65.4,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1541116800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.8798,"INR \\/ 1 GBP":94.753,"INR \\/ 1 EUR":83.2292,"INR \\/ 100 JPY":64.47,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1541376000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.074,"INR \\/ 1 GBP":94.9845,"INR \\/ 1 EUR":83.2566,"INR \\/ 100 JPY":64.5,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1541462400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":73.0097,"INR \\/ 1 GBP":95.302,"INR \\/ 1 EUR":83.2632,"INR \\/ 100 JPY":64.37,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1541721600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.7347,"INR \\/ 1 GBP":94.8737,"INR \\/ 1 EUR":82.5195,"INR \\/ 100 JPY":63.84,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1541980800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.9078,"INR \\/ 1 GBP":93.9947,"INR \\/ 1 EUR":82.4315,"INR \\/ 100 JPY":63.91,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1542067200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.5853,"INR \\/ 1 GBP":93.4908,"INR \\/ 1 EUR":81.611,"INR \\/ 100 JPY":63.69,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1542153600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.1039,"INR \\/ 1 GBP":93.6961,"INR \\/ 1 EUR":81.4361,"INR \\/ 100 JPY":63.31,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1542240000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.16,"INR \\/ 1 GBP":93.9518,"INR \\/ 1 EUR":81.8256,"INR \\/ 100 JPY":63.55,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1542326400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.8023,"INR \\/ 1 GBP":91.9247,"INR \\/ 1 EUR":81.4626,"INR \\/ 100 JPY":63.37,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1542585600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.9007,"INR \\/ 1 GBP":92.1983,"INR \\/ 1 EUR":81.9419,"INR \\/ 100 JPY":63.74,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1542672000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.3276,"INR \\/ 1 GBP":91.7197,"INR \\/ 1 EUR":81.6867,"INR \\/ 100 JPY":63.4,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1542844800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1787,"INR \\/ 1 GBP":91.0423,"INR \\/ 1 EUR":81.1883,"INR \\/ 100 JPY":62.97,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1543190400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.7144,"INR \\/ 1 GBP":90.6478,"INR \\/ 1 EUR":80.266,"INR \\/ 100 JPY":62.47,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1543276800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.9065,"INR \\/ 1 GBP":90.8369,"INR \\/ 1 EUR":80.4207,"INR \\/ 100 JPY":62.49,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1543363200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.6881,"INR \\/ 1 GBP":90.1368,"INR \\/ 1 EUR":79.8752,"INR \\/ 100 JPY":62.08,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1543449600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.9159,"INR \\/ 1 GBP":89.7389,"INR \\/ 1 EUR":79.5801,"INR \\/ 100 JPY":61.71,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1543536000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.6574,"INR \\/ 1 GBP":89.0848,"INR \\/ 1 EUR":79.3588,"INR \\/ 100 JPY":61.43,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1543795200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.028,"INR \\/ 1 GBP":89.5005,"INR \\/ 1 EUR":79.5887,"INR \\/ 100 JPY":61.69,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1543881600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.3455,"INR \\/ 1 GBP":89.645,"INR \\/ 1 EUR":80.079,"INR \\/ 100 JPY":62.21,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1543968000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.5171,"INR \\/ 1 GBP":89.4458,"INR \\/ 1 EUR":79.8366,"INR \\/ 100 JPY":62.37,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1544054400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.0371,"INR \\/ 1 GBP":90.2953,"INR \\/ 1 EUR":80.5457,"INR \\/ 100 JPY":62.99,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1544140800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.5663,"INR \\/ 1 GBP":90.1212,"INR \\/ 1 EUR":80.2245,"INR \\/ 100 JPY":62.53,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1544400000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.3257,"INR \\/ 1 GBP":90.9108,"INR \\/ 1 EUR":81.5738,"INR \\/ 100 JPY":63.43,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1544486400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.9274,"INR \\/ 1 GBP":90.4266,"INR \\/ 1 EUR":81.7325,"INR \\/ 100 JPY":63.57,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1544572800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":72.0407,"INR \\/ 1 GBP":90.0393,"INR \\/ 1 EUR":81.5928,"INR \\/ 100 JPY":63.5,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1544659200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.5368,"INR \\/ 1 GBP":90.3095,"INR \\/ 1 EUR":81.3407,"INR \\/ 100 JPY":63.06,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1544745600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.7359,"INR \\/ 1 GBP":90.5809,"INR \\/ 1 EUR":81.4628,"INR \\/ 100 JPY":63.2,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1545004800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.673,"INR \\/ 1 GBP":90.1981,"INR \\/ 1 EUR":81.0717,"INR \\/ 100 JPY":63.17,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1545091200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.194,"INR \\/ 1 GBP":89.8829,"INR \\/ 1 EUR":80.7554,"INR \\/ 100 JPY":63.21,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1545177600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.1094,"INR \\/ 1 GBP":88.7431,"INR \\/ 1 EUR":79.8153,"INR \\/ 100 JPY":62.38,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1545264000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.2835,"INR \\/ 1 GBP":88.8454,"INR \\/ 1 EUR":80.0548,"INR \\/ 100 JPY":62.79,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1545350400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.0368,"INR \\/ 1 GBP":88.7016,"INR \\/ 1 EUR":80.2127,"INR \\/ 100 JPY":62.87,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1545609600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.1757,"INR \\/ 1 GBP":88.871,"INR \\/ 1 EUR":79.8824,"INR \\/ 100 JPY":63.16,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1545782400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.9906,"INR \\/ 1 GBP":88.9581,"INR \\/ 1 EUR":79.8196,"INR \\/ 100 JPY":63.36,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1545868800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.327,"INR \\/ 1 GBP":88.9829,"INR \\/ 1 EUR":80.0223,"INR \\/ 100 JPY":63.25,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1545955200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.9786,"INR \\/ 1 GBP":88.6564,"INR \\/ 1 EUR":80.1805,"INR \\/ 100 JPY":63.28,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1546214400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.7923,"INR \\/ 1 GBP":88.5488,"INR \\/ 1 EUR":79.7805,"INR \\/ 100 JPY":63.21,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1546300800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.7131,"INR \\/ 1 GBP":88.9748,"INR \\/ 1 EUR":79.933,"INR \\/ 100 JPY":63.57,"Comments":"GBP & JPY as per New York closing Mid Quote"},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1546387200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.6089,"INR \\/ 1 GBP":88.8261,"INR \\/ 1 EUR":79.9635,"INR \\/ 100 JPY":63.75,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1546473600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.3627,"INR \\/ 1 GBP":88.2756,"INR \\/ 1 EUR":79.9208,"INR \\/ 100 JPY":65.8,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1546560000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.8653,"INR \\/ 1 GBP":88.2599,"INR \\/ 1 EUR":79.5659,"INR \\/ 100 JPY":64.6,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1546819200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.4814,"INR \\/ 1 GBP":88.5943,"INR \\/ 1 EUR":79.389,"INR \\/ 100 JPY":64.21,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1546905600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.0221,"INR \\/ 1 GBP":89.4238,"INR \\/ 1 EUR":80.1576,"INR \\/ 100 JPY":64.37,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1546992000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.4418,"INR \\/ 1 GBP":89.7231,"INR \\/ 1 EUR":80.7099,"INR \\/ 100 JPY":64.71,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1547078400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.5135,"INR \\/ 1 GBP":90.1656,"INR \\/ 1 EUR":81.492,"INR \\/ 100 JPY":65.4,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1547164800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.4737,"INR \\/ 1 GBP":89.9155,"INR \\/ 1 EUR":81.2083,"INR \\/ 100 JPY":65.03,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1547424000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.8244,"INR \\/ 1 GBP":90.964,"INR \\/ 1 EUR":81.2469,"INR \\/ 100 JPY":65.5,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1547510400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.0298,"INR \\/ 1 GBP":91.6242,"INR \\/ 1 EUR":81.5048,"INR \\/ 100 JPY":65.37,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1547596800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1847,"INR \\/ 1 GBP":91.4619,"INR \\/ 1 EUR":81.1762,"INR \\/ 100 JPY":65.62,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1547683200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.3418,"INR \\/ 1 GBP":91.8616,"INR \\/ 1 EUR":81.2583,"INR \\/ 100 JPY":65.51,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1547769600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1418,"INR \\/ 1 GBP":92.2946,"INR \\/ 1 EUR":81.0656,"INR \\/ 100 JPY":65.04,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548028800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.3782,"INR \\/ 1 GBP":91.8913,"INR \\/ 1 EUR":81.2308,"INR \\/ 100 JPY":65.15,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548115200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.3761,"INR \\/ 1 GBP":91.8963,"INR \\/ 1 EUR":81.0438,"INR \\/ 100 JPY":65.23,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548201600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.2039,"INR \\/ 1 GBP":92.2067,"INR \\/ 1 EUR":80.9394,"INR \\/ 100 JPY":64.94,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548288000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.282,"INR \\/ 1 GBP":93.1456,"INR \\/ 1 EUR":81.1113,"INR \\/ 100 JPY":64.97,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548374400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1051,"INR \\/ 1 GBP":93.2396,"INR \\/ 1 EUR":80.4986,"INR \\/ 100 JPY":64.74,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548633600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.134,"INR \\/ 1 GBP":93.8224,"INR \\/ 1 EUR":81.1482,"INR \\/ 100 JPY":65.05,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548720000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.0942,"INR \\/ 1 GBP":93.5453,"INR \\/ 1 EUR":81.318,"INR \\/ 100 JPY":65.05,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548806400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.2442,"INR \\/ 1 GBP":93.2867,"INR \\/ 1 EUR":81.538,"INR \\/ 100 JPY":65.2,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548892800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.0333,"INR \\/ 1 GBP":93.2383,"INR \\/ 1 EUR":81.6836,"INR \\/ 100 JPY":65.3,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1548979200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1102,"INR \\/ 1 GBP":93.1681,"INR \\/ 1 EUR":81.3425,"INR \\/ 100 JPY":65.31,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1549238400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.658,"INR \\/ 1 GBP":93.7067,"INR \\/ 1 EUR":81.9997,"INR \\/ 100 JPY":65.29,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1549324800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.7459,"INR \\/ 1 GBP":93.5624,"INR \\/ 1 EUR":82.0147,"INR \\/ 100 JPY":65.29,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1549411200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.5731,"INR \\/ 1 GBP":92.6886,"INR \\/ 1 EUR":81.5461,"INR \\/ 100 JPY":65.21,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1549497600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.4688,"INR \\/ 1 GBP":92.4478,"INR \\/ 1 EUR":81.2024,"INR \\/ 100 JPY":65.0,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1549584000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.2949,"INR \\/ 1 GBP":92.2936,"INR \\/ 1 EUR":80.8304,"INR \\/ 100 JPY":64.98,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1549843200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1621,"INR \\/ 1 GBP":92.0216,"INR \\/ 1 EUR":80.5882,"INR \\/ 100 JPY":64.71,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1549929600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.9353,"INR \\/ 1 GBP":91.262,"INR \\/ 1 EUR":80.0259,"INR \\/ 100 JPY":64.15,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1550016000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.5547,"INR \\/ 1 GBP":91.1327,"INR \\/ 1 EUR":79.9596,"INR \\/ 100 JPY":63.78,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1550102400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.9408,"INR \\/ 1 GBP":91.2791,"INR \\/ 1 EUR":79.9966,"INR \\/ 100 JPY":63.88,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1550188800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.2515,"INR \\/ 1 GBP":91.2261,"INR \\/ 1 EUR":80.4168,"INR \\/ 100 JPY":64.55,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1550448000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.4705,"INR \\/ 1 GBP":92.2689,"INR \\/ 1 EUR":80.8117,"INR \\/ 100 JPY":64.64,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1550620800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1773,"INR \\/ 1 GBP":92.9272,"INR \\/ 1 EUR":80.7075,"INR \\/ 100 JPY":64.21,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1550707200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.154,"INR \\/ 1 GBP":92.7213,"INR \\/ 1 EUR":80.6203,"INR \\/ 100 JPY":64.24,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1550793600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.2177,"INR \\/ 1 GBP":92.8271,"INR \\/ 1 EUR":80.7528,"INR \\/ 100 JPY":64.29,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1551052800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.042,"INR \\/ 1 GBP":92.8808,"INR \\/ 1 EUR":80.6028,"INR \\/ 100 JPY":64.22,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1551139200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.0952,"INR \\/ 1 GBP":93.3594,"INR \\/ 1 EUR":80.7471,"INR \\/ 100 JPY":64.16,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1551225600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1663,"INR \\/ 1 GBP":94.2152,"INR \\/ 1 EUR":80.9668,"INR \\/ 100 JPY":64.38,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1551312000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":71.1953,"INR \\/ 1 GBP":94.7021,"INR \\/ 1 EUR":80.979,"INR \\/ 100 JPY":64.24,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1551398400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.9696,"INR \\/ 1 GBP":94.0868,"INR \\/ 1 EUR":80.7161,"INR \\/ 100 JPY":63.49,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1551744000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.7601,"INR \\/ 1 GBP":93.1179,"INR \\/ 1 EUR":80.1594,"INR \\/ 100 JPY":63.23,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1551830400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.5798,"INR \\/ 1 GBP":92.7197,"INR \\/ 1 EUR":79.766,"INR \\/ 100 JPY":63.13,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1551916800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.0268,"INR \\/ 1 GBP":92.2575,"INR \\/ 1 EUR":79.17,"INR \\/ 100 JPY":62.66,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1552003200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":70.101,"INR \\/ 1 GBP":91.7954,"INR \\/ 1 EUR":78.5463,"INR \\/ 100 JPY":63.13,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1552262400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.9308,"INR \\/ 1 GBP":90.7916,"INR \\/ 1 EUR":78.571,"INR \\/ 100 JPY":62.93,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1552348800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.595,"INR \\/ 1 GBP":91.8714,"INR \\/ 1 EUR":78.3366,"INR \\/ 100 JPY":62.54,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1552435200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.6225,"INR \\/ 1 GBP":91.1535,"INR \\/ 1 EUR":78.5709,"INR \\/ 100 JPY":62.55,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1552521600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.6657,"INR \\/ 1 GBP":92.288,"INR \\/ 1 EUR":78.8416,"INR \\/ 100 JPY":62.43,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1552608000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.2131,"INR \\/ 1 GBP":91.6437,"INR \\/ 1 EUR":78.3368,"INR \\/ 100 JPY":61.99,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1552867200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.6088,"INR \\/ 1 GBP":91.1184,"INR \\/ 1 EUR":77.7827,"INR \\/ 100 JPY":61.5,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1552953600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.5847,"INR \\/ 1 GBP":91.0069,"INR \\/ 1 EUR":77.8185,"INR \\/ 100 JPY":61.66,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1553040000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.8604,"INR \\/ 1 GBP":91.2846,"INR \\/ 1 EUR":78.1446,"INR \\/ 100 JPY":61.72,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1553212800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.6607,"INR \\/ 1 GBP":90.2778,"INR \\/ 1 EUR":78.1368,"INR \\/ 100 JPY":61.97,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1553472000000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.9903,"INR \\/ 1 GBP":90.8731,"INR \\/ 1 EUR":77.9735,"INR \\/ 100 JPY":62.76,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1553558400000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.8469,"INR \\/ 1 GBP":90.7737,"INR \\/ 1 EUR":77.8663,"INR \\/ 100 JPY":62.55,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1553644800000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":68.903,"INR \\/ 1 GBP":90.8753,"INR \\/ 1 EUR":77.6041,"INR \\/ 100 JPY":62.33,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1553731200000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.0038,"INR \\/ 1 GBP":91.028,"INR \\/ 1 EUR":77.6868,"INR \\/ 100 JPY":62.69,"Comments":""},{"Date \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":1553817600000,"Time \\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0":"13:30:00","INR \\/ 1 USD":69.1713,"INR \\/ 1 GBP":90.4756,"INR \\/ 1 EUR":77.7024,"INR \\/ 100 JPY":62.52,"Comments":""}]	1
3	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f		Format .pdf not supported	1
4	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f		[{"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "BUY", "trade_qty": "10", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$330.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $1.50\\nOPEN CONTRACT OPT REG FEE $0.17", "marker_net_amount": "NET AMOUNT", "net_amount": "$331.67"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "BUY", "trade_qty": "10", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$330.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $1.50\\nOPEN CONTRACT OPT REG FEE $0.17", "marker_net_amount": "NET AMOUNT", "net_amount": "$331.67"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "BUY", "trade_qty": "129", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$4,257.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $19.35\\nOPEN CONTRACT OPT REG FEE $2.15", "marker_net_amount": "NET AMOUNT", "net_amount": "$4,278.50"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "BUY", "trade_qty": "14", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$462.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $2.10\\nOPEN CONTRACT OPT REG FEE $0.23", "marker_net_amount": "NET AMOUNT", "net_amount": "$464.33"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "4", "symbol": null, "trade_type": "BUY", "trade_qty": "18", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$594.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $11.20\\nOPEN CONTRACT OPT REG FEE $0.30", "marker_net_amount": "NET AMOUNT", "net_amount": "$605.50"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "4", "symbol": null, "trade_type": "SELL", "trade_qty": "7", "trade_rate": "$1.42", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$994.00", "option": "CALL P 01/18/19 8", "opt_type": "CALL", "opt_name": "P", "expiry_date": "01/18/19", "strike_price": "8", "scrip_commission_fee": "PANDORA MEDIA INC COMMISSION $9.55\\nCLOSING CONTRACT OPT REG FEE\\nFEE\\n$0.12\\n0.02", "marker_net_amount": "NET AMOUNT", "net_amount": "$984.31"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "SELL", "trade_qty": "93", "trade_rate": "$1.42", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$13,206.00", "option": "CALL P 01/18/19 8", "opt_type": "CALL", "opt_name": "P", "expiry_date": "01/18/19", "strike_price": "8", "scrip_commission_fee": "PANDORA MEDIA INC COMMISSION $13.95\\nCLOSING CONTRACT FINRA TAF\\nOPT REG FEE\\nFEE\\n$0.19\\n1.55\\n0.18", "marker_net_amount": "NET AMOUNT", "net_amount": "$13,190.13"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "4", "symbol": null, "trade_type": "BUY", "trade_qty": "9", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$297.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $1.35\\nOPEN CONTRACT OPT REG FEE $0.15", "marker_net_amount": "NET AMOUNT", "net_amount": "$298.50"}, {"trade_date": "06/19/18", "setl_date": "06/21/18", "mkt": "6", "cap": "1", "symbol": "HMNY", "trade_type": "SELL", "trade_qty": "20,000", "trade_rate": "$.35", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$7,000.00", "option": null, "opt_type": null, "opt_name": null, "expiry_date": null, "strike_price": null, "scrip_commission_fee": "HELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\\nFINRA TAF\\nFEE\\n$2.38\\n0.10", "marker_net_amount": "NET AMOUNT", "net_amount": "$6,993.57"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "4", "symbol": null, "trade_type": "BUY", "trade_qty": "10", "trade_rate": "$.28", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$280.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $10.00\\nOPEN CONTRACT OPT REG FEE $0.17", "marker_net_amount": "NET AMOUNT", "net_amount": "$290.17"}]	1
5	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f		[{"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "BUY", "trade_qty": "10", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$330.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $1.50\\nOPEN CONTRACT OPT REG FEE $0.17", "marker_net_amount": "NET AMOUNT", "net_amount": "$331.67"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "BUY", "trade_qty": "10", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$330.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $1.50\\nOPEN CONTRACT OPT REG FEE $0.17", "marker_net_amount": "NET AMOUNT", "net_amount": "$331.67"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "BUY", "trade_qty": "129", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$4,257.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $19.35\\nOPEN CONTRACT OPT REG FEE $2.15", "marker_net_amount": "NET AMOUNT", "net_amount": "$4,278.50"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "BUY", "trade_qty": "14", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$462.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $2.10\\nOPEN CONTRACT OPT REG FEE $0.23", "marker_net_amount": "NET AMOUNT", "net_amount": "$464.33"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "4", "symbol": null, "trade_type": "BUY", "trade_qty": "18", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$594.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $11.20\\nOPEN CONTRACT OPT REG FEE $0.30", "marker_net_amount": "NET AMOUNT", "net_amount": "$605.50"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "4", "symbol": null, "trade_type": "SELL", "trade_qty": "7", "trade_rate": "$1.42", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$994.00", "option": "CALL P 01/18/19 8", "opt_type": "CALL", "opt_name": "P", "expiry_date": "01/18/19", "strike_price": "8", "scrip_commission_fee": "PANDORA MEDIA INC COMMISSION $9.55\\nCLOSING CONTRACT OPT REG FEE\\nFEE\\n$0.12\\n0.02", "marker_net_amount": "NET AMOUNT", "net_amount": "$984.31"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "1", "symbol": null, "trade_type": "SELL", "trade_qty": "93", "trade_rate": "$1.42", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$13,206.00", "option": "CALL P 01/18/19 8", "opt_type": "CALL", "opt_name": "P", "expiry_date": "01/18/19", "strike_price": "8", "scrip_commission_fee": "PANDORA MEDIA INC COMMISSION $13.95\\nCLOSING CONTRACT FINRA TAF\\nOPT REG FEE\\nFEE\\n$0.19\\n1.55\\n0.18", "marker_net_amount": "NET AMOUNT", "net_amount": "$13,190.13"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "4", "symbol": null, "trade_type": "BUY", "trade_qty": "9", "trade_rate": "$.33", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$297.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $1.35\\nOPEN CONTRACT OPT REG FEE $0.15", "marker_net_amount": "NET AMOUNT", "net_amount": "$298.50"}, {"trade_date": "06/19/18", "setl_date": "06/21/18", "mkt": "6", "cap": "1", "symbol": "HMNY", "trade_type": "SELL", "trade_qty": "20,000", "trade_rate": "$.35", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$7,000.00", "option": null, "opt_type": null, "opt_name": null, "expiry_date": null, "strike_price": null, "scrip_commission_fee": "HELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\\nFINRA TAF\\nFEE\\n$2.38\\n0.10", "marker_net_amount": "NET AMOUNT", "net_amount": "$6,993.57"}, {"trade_date": "06/19/18", "setl_date": "06/20/18", "mkt": "3", "cap": "4", "symbol": null, "trade_type": "BUY", "trade_qty": "10", "trade_rate": "$.28", "acct_type": "Margin", "marker_principal": "PRINCIPAL", "principal": "$280.00", "option": "CALL PBR 01/18/19 15", "opt_type": "CALL", "opt_name": "PBR", "expiry_date": "01/18/19", "strike_price": "15", "scrip_commission_fee": "PETROLEO BRASILEIRO SA COMMISSION $10.00\\nOPEN CONTRACT OPT REG FEE $0.17", "marker_net_amount": "NET AMOUNT", "net_amount": "$290.17"}]	1
6	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n062120180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 2 1 BUY 1 $.74 Margin PRINCIPAL $74.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $0.15\nOPEN CONTRACT OPT REG FEE $0.02\nNET AMOUNT $74.17\n06/21/18 06/22/18 3 1 BUY 41 $.74 Margin PRINCIPAL $3,034.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $14.65\nOPEN CONTRACT OPT REG FEE $0.68\nNET AMOUNT $3,049.33\n06/21/18 06/22/18 3 4 BUY 11 $.73 Margin PRINCIPAL $803.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $10.15\nOPEN CONTRACT OPT REG FEE $0.18\nNET AMOUNT $813.33\n06/21/18 06/22/18 5 1 SELL 84 $.66 Margin PRINCIPAL $5,544.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $12.60\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.17\n1.40\n0.08\nNET AMOUNT $5,529.75\n06/21/18 06/22/18 5 1 BUY 46 $.73 Margin PRINCIPAL $3,358.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,365.67\n06/21/18 06/22/18 5 1 BUY 46 $.74 Margin PRINCIPAL $3,404.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,411.67\n\f237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 6 1 BUY 55 $.74 Margin PRINCIPAL $4,070.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $8.25\nOPEN CONTRACT OPT REG FEE $0.92\nNET AMOUNT $4,079.17\n06/21/18 06/22/18 3 1 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $9.70\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $518.16\n06/21/18 06/22/18 3 4 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $1.20\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $526.66\n\fThis Page Intentionally Left Blank\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\f		Format .pdf not supported	1
7	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f		Format .pdf not supported	1
8	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f		Format .pdf not supported	1
9	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f		Format .pdf not supported	1
10	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n062120180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 2 1 BUY 1 $.74 Margin PRINCIPAL $74.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $0.15\nOPEN CONTRACT OPT REG FEE $0.02\nNET AMOUNT $74.17\n06/21/18 06/22/18 3 1 BUY 41 $.74 Margin PRINCIPAL $3,034.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $14.65\nOPEN CONTRACT OPT REG FEE $0.68\nNET AMOUNT $3,049.33\n06/21/18 06/22/18 3 4 BUY 11 $.73 Margin PRINCIPAL $803.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $10.15\nOPEN CONTRACT OPT REG FEE $0.18\nNET AMOUNT $813.33\n06/21/18 06/22/18 5 1 SELL 84 $.66 Margin PRINCIPAL $5,544.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $12.60\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.17\n1.40\n0.08\nNET AMOUNT $5,529.75\n06/21/18 06/22/18 5 1 BUY 46 $.73 Margin PRINCIPAL $3,358.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,365.67\n06/21/18 06/22/18 5 1 BUY 46 $.74 Margin PRINCIPAL $3,404.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,411.67\n\f237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 6 1 BUY 55 $.74 Margin PRINCIPAL $4,070.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $8.25\nOPEN CONTRACT OPT REG FEE $0.92\nNET AMOUNT $4,079.17\n06/21/18 06/22/18 3 1 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $9.70\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $518.16\n06/21/18 06/22/18 3 4 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $1.20\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $526.66\n\fThis Page Intentionally Left Blank\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\f		Format .pdf not supported	1
11	Sample PDF	Etrade	ContractNote	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f		Format .pdf not supported	1
\.


--
-- Data for Name: core_extractor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_extractor (id, title, institute_name, document_type, regex_parser, reference, user_id) FROM stdin;
\.


--
-- Data for Name: core_file; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_file (id, title, institute_name, document_type, file, password, remark, "timestamp", text, user_id) FROM stdin;
2				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180621_9_1xaczam.pdf			2019-10-17 17:09:00.564905+05:30		1
1	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180621_9_0YeLzKh.pdf		No Remark	2019-10-17 17:09:00.232978+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n062120180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 2 1 BUY 1 $.74 Margin PRINCIPAL $74.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $0.15\nOPEN CONTRACT OPT REG FEE $0.02\nNET AMOUNT $74.17\n06/21/18 06/22/18 3 1 BUY 41 $.74 Margin PRINCIPAL $3,034.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $14.65\nOPEN CONTRACT OPT REG FEE $0.68\nNET AMOUNT $3,049.33\n06/21/18 06/22/18 3 4 BUY 11 $.73 Margin PRINCIPAL $803.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $10.15\nOPEN CONTRACT OPT REG FEE $0.18\nNET AMOUNT $813.33\n06/21/18 06/22/18 5 1 SELL 84 $.66 Margin PRINCIPAL $5,544.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $12.60\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.17\n1.40\n0.08\nNET AMOUNT $5,529.75\n06/21/18 06/22/18 5 1 BUY 46 $.73 Margin PRINCIPAL $3,358.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,365.67\n06/21/18 06/22/18 5 1 BUY 46 $.74 Margin PRINCIPAL $3,404.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,411.67\n\f237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 6 1 BUY 55 $.74 Margin PRINCIPAL $4,070.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $8.25\nOPEN CONTRACT OPT REG FEE $0.92\nNET AMOUNT $4,079.17\n06/21/18 06/22/18 3 1 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $9.70\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $518.16\n06/21/18 06/22/18 3 4 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $1.20\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $526.66\n\fThis Page Intentionally Left Blank\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\f	1
4				referencerate_normalized_PJxXKZX.xlsx			2019-10-24 11:34:02.755827+05:30		1
3	Sample PDF	Etrade	ContractNote	referencerate_normalized.xlsx		No Remark	2019-10-24 11:34:02.422815+05:30	Date               ,Time        ,INR / 1 USD,INR / 1 GBP,INR / 1 EUR,INR / 100 JPY,Comments\n2018-07-10,13:30:00,68.7942,91.1051,80.78,61.93,\n2018-07-11,13:30:00,68.829,91.3453,80.7947,61.98,\n2018-07-12,13:30:00,68.6313,90.672,80.165,61.15,\n2018-07-13,13:30:00,68.4094,90.071,79.7617,60.77,\n2018-07-16,13:30:00,68.5877,90.8481,80.2526,61.02,\n2018-07-17,13:30:00,68.2978,90.516,80.1006,60.78,\n2018-07-18,13:30:00,68.5652,89.7258,79.7363,60.65,\n2018-07-19,13:30:00,68.8331,89.93,80.1153,61.01,\n2018-07-20,13:30:00,68.8458,89.6671,80.3114,61.27,\n2018-07-23,13:30:00,68.704,90.2766,80.5619,61.93,\n2018-07-24,13:30:00,69.053,90.3015,80.5434,61.98,\n2018-07-25,13:30:00,68.8028,90.5812,80.4497,61.88,\n2018-07-26,13:30:00,68.7017,90.6633,80.6045,62.09,\n2018-07-27,13:30:00,68.7041,89.9891,79.9821,61.84,\n2018-07-30,13:30:00,68.7531,90.1454,80.1597,61.89,\n2018-07-31,13:30:00,68.6068,90.0862,80.3687,61.69,\n2018-08-01,13:30:00,68.6058,89.9344,80.1151,61.21,\n2018-08-02,13:30:00,68.3566,89.5221,79.5748,61.23,\n2018-08-03,13:30:00,68.7933,89.5171,79.6746,61.58,\n2018-08-06,13:30:00,68.6833,89.2585,79.3805,61.71,\n2018-08-07,13:30:00,68.8,89.135,79.5599,61.81,\n2018-08-08,13:30:00,68.6465,88.8167,79.7169,61.74,\n2018-08-09,13:30:00,68.624,88.3475,79.6327,61.8,\n2018-08-10,13:30:00,68.9538,88.1901,78.9985,62.15,\n2018-08-13,13:30:00,69.4685,88.6274,79.1876,62.97,\n2018-08-14,13:30:00,69.7696,89.2311,79.6997,62.9,\n2018-08-16,13:30:00,70.2287,89.367,79.9718,63.35,\n2018-08-20,13:30:00,69.7617,88.8741,79.672,63.09,\n2018-08-21,13:30:00,69.6668,89.3997,80.2478,63.3,\n2018-08-23,13:30:00,70.0656,90.2576,81.0486,63.21,\n2018-08-24,13:30:00,70.1377,89.9694,81.1699,62.98,\n2018-08-27,13:30:00,70.0366,89.9541,81.3032,63.07,\n2018-08-28,13:30:00,70.1687,90.3263,81.9266,63.08,\n2018-08-29,13:30:00,70.5046,90.6257,82.3376,63.42,\n2018-08-30,13:30:00,70.7329,92.1518,82.7184,63.34,\n2018-08-31,13:30:00,70.9255,92.353,82.8391,63.91,\n2018-09-03,13:30:00,70.7695,91.3582,82.1445,63.8,\n2018-09-04,13:30:00,71.1857,91.4603,82.4919,63.92,\n2018-09-05,13:30:00,71.7533,92.2255,83.131,64.36,\n2018-09-06,13:30:00,71.9214,92.8007,83.6005,64.56,\n2018-09-07,13:30:00,71.9009,93.0364,83.6744,64.98,\n2018-09-10,13:30:00,72.5745,93.7396,83.8081,65.42,\n2018-09-11,13:30:00,72.3227,94.4182,84.0771,64.89,\n2018-09-12,13:30:00,72.7549,94.6211,84.3244,65.22,\n2018-09-14,13:30:00,71.8129,94.1553,83.9771,64.19,\n2018-09-17,13:30:00,72.5505,94.9405,84.3985,64.78,\n2018-09-18,13:30:00,72.3796,95.2897,84.7657,64.59,\n2018-09-19,13:30:00,72.6781,95.5925,84.905,64.69,\n2018-09-21,13:30:00,71.8489,95.15,84.683,63.67,\n2018-09-24,13:30:00,72.6927,94.9953,85.2535,64.61,\n2018-09-25,13:30:00,72.8134,95.5016,85.6237,64.47,\n2018-09-26,13:30:00,72.7182,95.7699,85.5365,64.42,\n2018-09-27,13:30:00,72.6505,95.4347,85.0418,64.47,\n2018-09-28,13:30:00,72.5474,94.908,84.4428,63.9,\n2018-10-01,13:30:00,72.8036,94.8825,84.3799,63.89,\n2018-10-03,13:30:00,73.0299,94.988,84.5784,64.18,\n2018-10-04,13:30:00,73.7509,95.3904,84.6257,64.49,\n2018-10-05,13:30:00,73.5809,95.8877,84.6975,64.59,\n2018-10-08,13:30:00,73.9235,96.8575,85.0613,64.96,\n2018-10-09,13:30:00,74.0989,96.9895,85.108,65.51,\n2018-10-10,13:30:00,74.1316,97.6284,85.2637,65.6,\n2018-10-11,13:30:00,74.3875,98.2961,85.9012,66.29,\n2018-10-12,13:30:00,73.7967,97.6537,85.5545,65.67,\n2018-10-15,13:30:00,73.9708,97.0832,85.4895,66.08,\n2018-10-16,13:30:00,73.9041,97.3327,85.575,65.95,\n2018-10-17,13:30:00,73.4846,96.8684,84.98,65.47,\n2018-10-19,13:30:00,73.4354,95.6525,84.1741,65.27,\n2018-10-22,13:30:00,73.3025,95.9305,84.573,65.02,\n2018-10-23,13:30:00,73.7818,95.5568,84.4743,65.62,\n2018-10-24,13:30:00,73.2645,95.0529,83.9934,65.13,\n2018-10-25,13:30:00,73.2746,94.619,83.6478,65.33,\n2018-10-26,13:30:00,73.374,94.0503,83.4077,65.41,\n2018-10-29,13:30:00,73.4181,94.2644,83.6942,65.62,\n2018-10-30,13:30:00,73.5709,94.184,83.7114,65.28,\n2018-10-31,13:30:00,73.9936,94.1016,83.925,65.36,\n2018-11-01,13:30:00,73.8295,94.8182,83.7261,65.4,\n2018-11-02,13:30:00,72.8798,94.753,83.2292,64.47,\n2018-11-05,13:30:00,73.074,94.9845,83.2566,64.5,\n2018-11-06,13:30:00,73.0097,95.302,83.2632,64.37,\n2018-11-09,13:30:00,72.7347,94.8737,82.5195,63.84,\n2018-11-12,13:30:00,72.9078,93.9947,82.4315,63.91,\n2018-11-13,13:30:00,72.5853,93.4908,81.611,63.69,\n2018-11-14,13:30:00,72.1039,93.6961,81.4361,63.31,\n2018-11-15,13:30:00,72.16,93.9518,81.8256,63.55,\n2018-11-16,13:30:00,71.8023,91.9247,81.4626,63.37,\n2018-11-19,13:30:00,71.9007,92.1983,81.9419,63.74,\n2018-11-20,13:30:00,71.3276,91.7197,81.6867,63.4,\n2018-11-22,13:30:00,71.1787,91.0423,81.1883,62.97,\n2018-11-26,13:30:00,70.7144,90.6478,80.266,62.47,\n2018-11-27,13:30:00,70.9065,90.8369,80.4207,62.49,\n2018-11-28,13:30:00,70.6881,90.1368,79.8752,62.08,\n2018-11-29,13:30:00,69.9159,89.7389,79.5801,61.71,\n2018-11-30,13:30:00,69.6574,89.0848,79.3588,61.43,\n2018-12-03,13:30:00,70.028,89.5005,79.5887,61.69,\n2018-12-04,13:30:00,70.3455,89.645,80.079,62.21,\n2018-12-05,13:30:00,70.5171,89.4458,79.8366,62.37,\n2018-12-06,13:30:00,71.0371,90.2953,80.5457,62.99,\n2018-12-07,13:30:00,70.5663,90.1212,80.2245,62.53,\n2018-12-10,13:30:00,71.3257,90.9108,81.5738,63.43,\n2018-12-11,13:30:00,71.9274,90.4266,81.7325,63.57,\n2018-12-12,13:30:00,72.0407,90.0393,81.5928,63.5,\n2018-12-13,13:30:00,71.5368,90.3095,81.3407,63.06,\n2018-12-14,13:30:00,71.7359,90.5809,81.4628,63.2,\n2018-12-17,13:30:00,71.673,90.1981,81.0717,63.17,\n2018-12-18,13:30:00,71.194,89.8829,80.7554,63.21,\n2018-12-19,13:30:00,70.1094,88.7431,79.8153,62.38,\n2018-12-20,13:30:00,70.2835,88.8454,80.0548,62.79,\n2018-12-21,13:30:00,70.0368,88.7016,80.2127,62.87,\n2018-12-24,13:30:00,70.1757,88.871,79.8824,63.16,\n2018-12-26,13:30:00,69.9906,88.9581,79.8196,63.36,\n2018-12-27,13:30:00,70.327,88.9829,80.0223,63.25,\n2018-12-28,13:30:00,69.9786,88.6564,80.1805,63.28,\n2018-12-31,13:30:00,69.7923,88.5488,79.7805,63.21,\n2019-01-01,13:30:00,69.7131,88.9748,79.933,63.57,GBP & JPY as per New York closing Mid Quote\n2019-01-02,13:30:00,69.6089,88.8261,79.9635,63.75,\n2019-01-03,13:30:00,70.3627,88.2756,79.9208,65.8,\n2019-01-04,13:30:00,69.8653,88.2599,79.5659,64.6,\n2019-01-07,13:30:00,69.4814,88.5943,79.389,64.21,\n2019-01-08,13:30:00,70.0221,89.4238,80.1576,64.37,\n2019-01-09,13:30:00,70.4418,89.7231,80.7099,64.71,\n2019-01-10,13:30:00,70.5135,90.1656,81.492,65.4,\n2019-01-11,13:30:00,70.4737,89.9155,81.2083,65.03,\n2019-01-14,13:30:00,70.8244,90.964,81.2469,65.5,\n2019-01-15,13:30:00,71.0298,91.6242,81.5048,65.37,\n2019-01-16,13:30:00,71.1847,91.4619,81.1762,65.62,\n2019-01-17,13:30:00,71.3418,91.8616,81.2583,65.51,\n2019-01-18,13:30:00,71.1418,92.2946,81.0656,65.04,\n2019-01-21,13:30:00,71.3782,91.8913,81.2308,65.15,\n2019-01-22,13:30:00,71.3761,91.8963,81.0438,65.23,\n2019-01-23,13:30:00,71.2039,92.2067,80.9394,64.94,\n2019-01-24,13:30:00,71.282,93.1456,81.1113,64.97,\n2019-01-25,13:30:00,71.1051,93.2396,80.4986,64.74,\n2019-01-28,13:30:00,71.134,93.8224,81.1482,65.05,\n2019-01-29,13:30:00,71.0942,93.5453,81.318,65.05,\n2019-01-30,13:30:00,71.2442,93.2867,81.538,65.2,\n2019-01-31,13:30:00,71.0333,93.2383,81.6836,65.3,\n2019-02-01,13:30:00,71.1102,93.1681,81.3425,65.31,\n2019-02-04,13:30:00,71.658,93.7067,81.9997,65.29,\n2019-02-05,13:30:00,71.7459,93.5624,82.0147,65.29,\n2019-02-06,13:30:00,71.5731,92.6886,81.5461,65.21,\n2019-02-07,13:30:00,71.4688,92.4478,81.2024,65.0,\n2019-02-08,13:30:00,71.2949,92.2936,80.8304,64.98,\n2019-02-11,13:30:00,71.1621,92.0216,80.5882,64.71,\n2019-02-12,13:30:00,70.9353,91.262,80.0259,64.15,\n2019-02-13,13:30:00,70.5547,91.1327,79.9596,63.78,\n2019-02-14,13:30:00,70.9408,91.2791,79.9966,63.88,\n2019-02-15,13:30:00,71.2515,91.2261,80.4168,64.55,\n2019-02-18,13:30:00,71.4705,92.2689,80.8117,64.64,\n2019-02-20,13:30:00,71.1773,92.9272,80.7075,64.21,\n2019-02-21,13:30:00,71.154,92.7213,80.6203,64.24,\n2019-02-22,13:30:00,71.2177,92.8271,80.7528,64.29,\n2019-02-25,13:30:00,71.042,92.8808,80.6028,64.22,\n2019-02-26,13:30:00,71.0952,93.3594,80.7471,64.16,\n2019-02-27,13:30:00,71.1663,94.2152,80.9668,64.38,\n2019-02-28,13:30:00,71.1953,94.7021,80.979,64.24,\n2019-03-01,13:30:00,70.9696,94.0868,80.7161,63.49,\n2019-03-05,13:30:00,70.7601,93.1179,80.1594,63.23,\n2019-03-06,13:30:00,70.5798,92.7197,79.766,63.13,\n2019-03-07,13:30:00,70.0268,92.2575,79.17,62.66,\n2019-03-08,13:30:00,70.101,91.7954,78.5463,63.13,\n2019-03-11,13:30:00,69.9308,90.7916,78.571,62.93,\n2019-03-12,13:30:00,69.595,91.8714,78.3366,62.54,\n2019-03-13,13:30:00,69.6225,91.1535,78.5709,62.55,\n2019-03-14,13:30:00,69.6657,92.288,78.8416,62.43,\n2019-03-15,13:30:00,69.2131,91.6437,78.3368,61.99,\n2019-03-18,13:30:00,68.6088,91.1184,77.7827,61.5,\n2019-03-19,13:30:00,68.5847,91.0069,77.8185,61.66,\n2019-03-20,13:30:00,68.8604,91.2846,78.1446,61.72,\n2019-03-22,13:30:00,68.6607,90.2778,78.1368,61.97,\n2019-03-25,13:30:00,68.9903,90.8731,77.9735,62.76,\n2019-03-26,13:30:00,68.8469,90.7737,77.8663,62.55,\n2019-03-27,13:30:00,68.903,90.8753,77.6041,62.33,\n2019-03-28,13:30:00,69.0038,91.028,77.6868,62.69,\n2019-03-29,13:30:00,69.1713,90.4756,77.7024,62.52,\n	1
6				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_a7XM8JV.pdf			2020-08-18 12:14:02.450994+05:30		1
8				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_YG1Eei0.pdf			2020-08-18 12:14:02.883707+05:30		1
7	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_unAKDgy.pdf		No Remark	2020-08-18 12:14:02.876496+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f	1
5	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_vX4ZpXD.pdf		No Remark	2020-08-18 12:14:01.883044+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f	1
10				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_eZ6tcAd.pdf			2020-08-18 13:23:30.951184+05:30		1
9	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_HwNh7Jm.pdf		No Remark	2020-08-18 13:23:30.946331+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f	1
12				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180621_9_vVWa5UJ.pdf			2020-08-18 13:33:21.157852+05:30		1
11	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180621_9_s0tUhRo.pdf		No Remark	2020-08-18 13:33:21.153686+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n062120180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 2 1 BUY 1 $.74 Margin PRINCIPAL $74.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $0.15\nOPEN CONTRACT OPT REG FEE $0.02\nNET AMOUNT $74.17\n06/21/18 06/22/18 3 1 BUY 41 $.74 Margin PRINCIPAL $3,034.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $14.65\nOPEN CONTRACT OPT REG FEE $0.68\nNET AMOUNT $3,049.33\n06/21/18 06/22/18 3 4 BUY 11 $.73 Margin PRINCIPAL $803.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $10.15\nOPEN CONTRACT OPT REG FEE $0.18\nNET AMOUNT $813.33\n06/21/18 06/22/18 5 1 SELL 84 $.66 Margin PRINCIPAL $5,544.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $12.60\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.17\n1.40\n0.08\nNET AMOUNT $5,529.75\n06/21/18 06/22/18 5 1 BUY 46 $.73 Margin PRINCIPAL $3,358.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,365.67\n06/21/18 06/22/18 5 1 BUY 46 $.74 Margin PRINCIPAL $3,404.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,411.67\n\f237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 6 1 BUY 55 $.74 Margin PRINCIPAL $4,070.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $8.25\nOPEN CONTRACT OPT REG FEE $0.92\nNET AMOUNT $4,079.17\n06/21/18 06/22/18 3 1 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $9.70\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $518.16\n06/21/18 06/22/18 3 4 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $1.20\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $526.66\n\fThis Page Intentionally Left Blank\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\f	1
14				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_eljfabE.pdf			2020-08-18 13:34:50.557086+05:30		1
13	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_csEKzkI.pdf		No Remark	2020-08-18 13:34:50.552891+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f	1
16				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_4LhQWLo.pdf			2020-08-18 13:35:39.485686+05:30		1
15	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_5C6npZN.pdf		No Remark	2020-08-18 13:35:39.480029+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f	1
18				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_M5k5Xpj.pdf			2020-08-18 13:39:02.902538+05:30		1
17	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_cUarTnZ.pdf		No Remark	2020-08-18 13:39:02.898976+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f	1
20				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180621_9_cVaedvD.pdf			2020-08-18 13:40:34.418053+05:30		1
19	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180621_9_KPNvXL4.pdf		No Remark	2020-08-18 13:40:34.412731+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n062120180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 2 1 BUY 1 $.74 Margin PRINCIPAL $74.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $0.15\nOPEN CONTRACT OPT REG FEE $0.02\nNET AMOUNT $74.17\n06/21/18 06/22/18 3 1 BUY 41 $.74 Margin PRINCIPAL $3,034.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $14.65\nOPEN CONTRACT OPT REG FEE $0.68\nNET AMOUNT $3,049.33\n06/21/18 06/22/18 3 4 BUY 11 $.73 Margin PRINCIPAL $803.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $10.15\nOPEN CONTRACT OPT REG FEE $0.18\nNET AMOUNT $813.33\n06/21/18 06/22/18 5 1 SELL 84 $.66 Margin PRINCIPAL $5,544.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $12.60\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.17\n1.40\n0.08\nNET AMOUNT $5,529.75\n06/21/18 06/22/18 5 1 BUY 46 $.73 Margin PRINCIPAL $3,358.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,365.67\n06/21/18 06/22/18 5 1 BUY 46 $.74 Margin PRINCIPAL $3,404.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $6.90\nOPEN CONTRACT OPT REG FEE $0.77\nNET AMOUNT $3,411.67\n\f237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/21/18 06/22/18 6 1 BUY 55 $.74 Margin PRINCIPAL $4,070.00\nCALL PBR 01/18/19 12 PETROLEO BRASILEIRO SA COMMISSION $8.25\nOPEN CONTRACT OPT REG FEE $0.92\nNET AMOUNT $4,079.17\n06/21/18 06/22/18 3 1 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $9.70\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $518.16\n06/21/18 06/22/18 3 4 SELL 8 $.66 Margin PRINCIPAL $528.00\nCALL SNAP 01/18/19 19 SNAP INC COMMISSION $1.20\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.13\n0.01\nNET AMOUNT $526.66\n\fThis Page Intentionally Left Blank\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 39677 PBA 2 78813 1 of 1 C EDLV AFPEDLV 21/06/18 23:26 001\n\f	1
22				ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_CTxujiT.pdf			2020-08-18 14:06:30.449417+05:30		1
21	Sample PDF	Etrade	ContractNote	ETRADE_Brokerage_Trade_Confirmation_-_XXXX7417_-_20180619_10_ZEhttdO.pdf		No Remark	2020-08-18 14:06:30.445935+05:30	E*TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\nDETACH HERE DETACH HERE\nMake checks payable to E*TRADE Securities LLC.\nMail depositsto:\nE TRADE\nPlease do not send cash Dollars Cents\nTOTAL DEPOSIT\nAccount Name:\nNEERAJ GUPTA\nE TRADE Securities LLC\nPO Box 484\nJersey City, NJ 07303-0484\n1-800-ETRADE-1 (1-800-387-2331)\netrade.com\n061920180001 900542174173\nAccount Number: XXXX-7417\nUse This Deposit Slip Acct: XXXX-7417\nInvestment Account\nNEERAJ GUPTA\nFF5 WILDGRASSAPTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\nTRADE CONFIRMATION\nPage 1 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 10 $.33 Margin PRINCIPAL $330.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.50\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $331.67\n06/19/18 06/20/18 3 1 BUY 129 $.33 Margin PRINCIPAL $4,257.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $19.35\nOPEN CONTRACT OPT REG FEE $2.15\nNET AMOUNT $4,278.50\n06/19/18 06/20/18 3 1 BUY 14 $.33 Margin PRINCIPAL $462.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $2.10\nOPEN CONTRACT OPT REG FEE $0.23\nNET AMOUNT $464.33\n06/19/18 06/20/18 3 4 BUY 18 $.33 Margin PRINCIPAL $594.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $11.20\nOPEN CONTRACT OPT REG FEE $0.30\nNET AMOUNT $605.50\n06/19/18 06/20/18 3 4 SELL 7 $1.42 Margin PRINCIPAL $994.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $9.55\nCLOSING CONTRACT OPT REG FEE\nFEE\n$0.12\n0.02\nNET AMOUNT $984.31\n\f237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\nAccount Number: XXXX-7417\nE TRADE\nInvestment Account\nTRADE CONFIRMATION\nPage 2 of 4\nTRADE\nDATE\nSETL\nDATE\nMKT /\nCPT\nSYMBOL /\nCUSIP\nBUY /\nSELL QUANTITY PRICE\nACCT\nTYPE\n06/19/18 06/20/18 3 1 SELL 93 $1.42 Margin PRINCIPAL $13,206.00\nCALL P 01/18/19 8 PANDORA MEDIA INC COMMISSION $13.95\nCLOSING CONTRACT FINRA TAF\nOPT REG FEE\nFEE\n$0.19\n1.55\n0.18\nNET AMOUNT $13,190.13\n06/19/18 06/20/18 3 4 BUY 9 $.33 Margin PRINCIPAL $297.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $1.35\nOPEN CONTRACT OPT REG FEE $0.15\nNET AMOUNT $298.50\n06/19/18 06/21/18 6 1 HMNY SELL 20,000 $.35 Margin PRINCIPAL $7,000.00\nHELIOS AND MATHESON ANALYTICS INC COMMISSION $3.95\nFINRA TAF\nFEE\n$2.38\n0.10\nNET AMOUNT $6,993.57\n06/19/18 06/20/18 3 4 BUY 10 $.28 Margin PRINCIPAL $280.00\nCALL PBR 01/18/19 15 PETROLEO BRASILEIRO SA COMMISSION $10.00\nOPEN CONTRACT OPT REG FEE $0.17\nNET AMOUNT $290.17\n\fThis Page Intentionally Left Blank\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\fNEERAJ GUPTA\nFF5 WILDGRASS APTS BLK 2\n8-1 S.T. BED, KORAMANGALA\nBANGALORE\n560047 INDIA\n237 41468 PBA 2 83619 1 of 1 C EDLV AFPEDLV 19/06/18 23:18 001\n\f	1
\.


--
-- Data for Name: core_operation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_operation (id, title, type, parameters, user_id) FROM stdin;
8	Etrade_Extractor	Extract	{"type":"regex","parameters":{"regex":"(?#\\n)(?P<trade_date>\\\\d{2}\\\\/\\\\d{2}\\\\/\\\\d{2})(?:\\\\s){1,2}(?#\\n)(?P<setl_date>\\\\d{2}\\\\/\\\\d{2}\\\\/\\\\d{2})(?:\\\\s){1,2}(?#\\n)(?P<mkt>[\\\\w]+)(?:\\\\s){1,2}(?#\\n)(?P<cap>[\\\\w]+)(?:\\\\s){1,2}(?#\\n)(?:(?P<symbol>[\\\\w]+)(?:\\\\s){1,2}(?#\\n))?(?# symbol/cusip is only for EQ\\n)(?P<trade_type>[\\\\w]+)(?:\\\\s){1,2}(?#\\n)(?P<trade_qty>[,.\\\\-\\\\d]+)(?:\\\\s){1,2}(?#\\n)(?P<trade_rate>[\\\\$,.\\\\-\\\\d]+)(?:\\\\s){1,2}(?#\\n)(?P<acct_type>[\\\\w]+)(?:\\\\s){1,2}(?#\\n)(?P<marker_principal>PRINCIPAL)(?:\\\\s){1,2}(?#\\n)(?P<principal>[\\\\$,.\\\\-\\\\d]+)(?:\\\\s){1,2}(?#\\n)(?:(?P<option>(?#\\n    )(?P<opt_type>CALL|PUT) (?#\\n    )(?P<opt_name>[\\\\w]+) (?#\\n    )(?P<expiry_date>\\\\d{2}\\\\/\\\\d{2}\\\\/\\\\d{2}) (?#\\n    )(?P<strike_price>[\\\\$,.\\\\-\\\\d]+))(?#\\n)(?:\\\\s){1,2})?(?#\\n)(?P<scrip_commission_fee>(?:.|\\\\s)*?)(?:\\\\s){1,2}(?#\\n)(?P<marker_net_amount>NET AMOUNT)(?:\\\\s){1,2}(?#\\n)(?P<net_amount>[\\\\$,.\\\\-\\\\d]+)(?:\\\\s){1,2}(?#\\n)(?#\\n)"}}	1
9	Etrade_Transformer1	Transform	{"destination_table":"1","existing_fields":"[{\\"src\\":\\"trade_date\\",\\"srctype\\":\\"datetime64[ns]\\",\\"select\\":true,\\"dst\\":\\"TransactionDate\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"setl_date\\",\\"srctype\\":\\"datetime64[ns]\\",\\"select\\":true,\\"dst\\":\\"SettlementDate\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"mkt\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"mkt\\",\\"mapping\\":\\"IGNORE\\"},{\\"src\\":\\"cap\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"cap\\",\\"mapping\\":\\"IGNORE\\"},{\\"src\\":\\"symbol\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"symbol\\",\\"mapping\\":\\"IGNORE\\"},{\\"src\\":\\"trade_type\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"TradeType\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"trade_qty\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"Quantity\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"trade_rate\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"Rate\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"acct_type\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"acct_type\\",\\"mapping\\":\\"IGNORE\\"},{\\"src\\":\\"marker_principal\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"marker_principal\\",\\"mapping\\":\\"IGNORE\\"},{\\"src\\":\\"principal\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"PrincipalAmount\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"option\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"option\\",\\"mapping\\":\\"IGNORE\\"},{\\"src\\":\\"opt_type\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"Scrip\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"opt_name\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"Scrip\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"expiry_date\\",\\"srctype\\":\\"datetime64[ns]\\",\\"select\\":true,\\"dst\\":\\"Scrip\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"strike_price\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"Scrip\\",\\"mapping\\":\\"RENAME\\"},{\\"src\\":\\"scrip_commission_fee\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"Summary\\",\\"mapping\\":\\"SPLIT_REGEX_DYNAMIC\\"},{\\"src\\":\\"marker_net_amount\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"marker_net_amount\\",\\"mapping\\":\\"IGNORE\\"},{\\"src\\":\\"net_amount\\",\\"srctype\\":\\"object\\",\\"select\\":true,\\"dst\\":\\"NetAmount\\",\\"mapping\\":\\"RENAME\\"}]","new_fields":"[{\\"active\\":true,\\"type\\":\\"Generate-Regex\\",\\"src\\":\\"scrip_commission_fee\\",\\"value\\":\\"{\\\\\\"regex\\\\\\": \\\\\\"(?P<Scrip>.*)[\\\\\\\\\\\\\\\\s](?:COMMISSION)[\\\\\\\\\\\\\\\\s](?:[$]?)(?P<Commission>[.\\\\\\\\\\\\\\\\d]+)[\\\\\\\\\\\\\\\\s](?P<FeeStr_str>[\\\\\\\\\\\\\\\\s\\\\\\\\\\\\\\\\S]*)\\\\\\"}\\"},{\\"active\\":true,\\"type\\":\\"Generate-Regex\\",\\"temp_name\\":\\"FeeStr\\",\\"value\\":\\"{\\\\\\"regex\\\\\\": \\\\\\"(?:.*)[$](?P<Fee1_float_0>[.\\\\\\\\\\\\\\\\d]+)(?:[\\\\\\\\\\\\\\\\s](?P<Fee2_float_0>[.\\\\\\\\\\\\\\\\d]+))?(?:[\\\\\\\\\\\\\\\\s](?P<Fee3_float_0>[.\\\\\\\\\\\\\\\\d]+))?\\\\\\"}\\"},{\\"active\\":true,\\"type\\":\\"Generate-Final\\",\\"dst\\":\\"Fees\\",\\"value\\":\\"df.apply (lambda row: float(row['Fee1']) + float(row['Fee2']) + float(row['Fee3']), axis=1)\\"}]"}	1
10	Etrade_Postgres_Loader1	Load	{"table":"Trades","datastore_id":"1"}	1
\.


--
-- Data for Name: core_pipeline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_pipeline (id, institute_name, document_type, title, operations_json, user_id) FROM stdin;
3	Etrade	ContractNote	Etrade_P2	[8,9,10]	1
\.


--
-- Data for Name: core_pipeline_operations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_pipeline_operations (id, pipeline_id, operation_id) FROM stdin;
5	3	8
6	3	9
7	3	10
\.


--
-- Data for Name: core_schema; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_schema (id, title, fields_json, user_id) FROM stdin;
1	StockTransaction	[{"name":"TransactionDate","type":"date","aggregation":"none"},{"name":"SettlementDate","type":"date","aggregation":"none"},{"name":"Scrip","type":"object","aggregation":"sum"},{"name":"TradeType","type":"object","aggregation":"none"},{"name":"Quantity","type":"int64","aggregation":"none"},{"name":"Rate","type":"float64","aggregation":"none"},{"name":"PrincipalAmount","type":"float64","aggregation":"none"},{"name":"NetAmount","type":"float64","aggregation":"sum"},{"name":"Summary","type":"object","aggregation":"sum"}]	1
\.


--
-- Data for Name: core_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_tag (id, name, user_id) FROM stdin;
\.


--
-- Data for Name: core_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_transaction (id, "TradeDate", "Scrip", "Symbol", "SettleDate", "TradeQuantity", "TradeType", "PrincipalAmount", "Commission", "Fees", "NetAmount", doc_id, user_id) FROM stdin;
\.


--
-- Data for Name: core_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_user (id, password, last_login, is_superuser, email, name, is_active, is_staff) FROM stdin;
1	pbkdf2_sha256$120000$OaL5paXgQBw0$9++uEF4H/bjl3MnGBV+ZCq3weV2om18rrR7RTnnxyRA=	\N	f	alice@abc.com	Alice	t	f
\.


--
-- Data for Name: core_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: core_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	contenttypes	contenttype
5	sessions	session
6	corsheaders	corsmodel
7	authtoken	token
8	core	user
9	core	datastoreinfo
10	core	datastoretype
11	core	document
12	core	extractor
13	core	file
14	core	operation
15	core	pipeline
16	core	schema
17	core	tag
18	core	transaction
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2019-10-17 14:41:49.505574+05:30
2	contenttypes	0002_remove_content_type_name	2019-10-17 14:41:49.516597+05:30
3	auth	0001_initial	2019-10-17 14:41:49.550388+05:30
4	auth	0002_alter_permission_name_max_length	2019-10-17 14:41:49.557164+05:30
5	auth	0003_alter_user_email_max_length	2019-10-17 14:41:49.56409+05:30
6	auth	0004_alter_user_username_opts	2019-10-17 14:41:49.572695+05:30
7	auth	0005_alter_user_last_login_null	2019-10-17 14:41:49.580652+05:30
8	auth	0006_require_contenttypes_0002	2019-10-17 14:41:49.582553+05:30
9	auth	0007_alter_validators_add_error_messages	2019-10-17 14:41:49.589549+05:30
10	auth	0008_alter_user_username_max_length	2019-10-17 14:41:49.596471+05:30
11	auth	0009_alter_user_last_name_max_length	2019-10-17 14:41:49.603495+05:30
12	core	0001_initial	2019-10-17 14:45:09.960786+05:30
13	admin	0001_initial	2019-10-17 14:45:09.99068+05:30
14	admin	0002_logentry_remove_auto_add	2019-10-17 14:45:10.012506+05:30
15	admin	0003_logentry_add_action_flag_choices	2019-10-17 14:45:10.030074+05:30
16	authtoken	0001_initial	2019-10-17 14:45:10.054065+05:30
17	authtoken	0002_auto_20160226_1747	2019-10-17 14:45:10.140642+05:30
18	sessions	0001_initial	2019-10-17 14:45:10.149504+05:30
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 72, true);


--
-- Name: core_datastoreinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_datastoreinfo_id_seq', 2, true);


--
-- Name: core_datastoretype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_datastoretype_id_seq', 2, true);


--
-- Name: core_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_document_id_seq', 11, true);


--
-- Name: core_extractor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_extractor_id_seq', 1, false);


--
-- Name: core_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_file_id_seq', 22, true);


--
-- Name: core_operation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_operation_id_seq', 10, true);


--
-- Name: core_pipeline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_pipeline_id_seq', 3, true);


--
-- Name: core_pipeline_operations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_pipeline_operations_id_seq', 7, true);


--
-- Name: core_schema_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_schema_id_seq', 1, true);


--
-- Name: core_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_tag_id_seq', 1, false);


--
-- Name: core_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_transaction_id_seq', 1, false);


--
-- Name: core_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_user_groups_id_seq', 1, false);


--
-- Name: core_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_user_id_seq', 1, true);


--
-- Name: core_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 18, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 18, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: core_datastoreinfo core_datastoreinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_datastoreinfo
    ADD CONSTRAINT core_datastoreinfo_pkey PRIMARY KEY (id);


--
-- Name: core_datastoretype core_datastoretype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_datastoretype
    ADD CONSTRAINT core_datastoretype_pkey PRIMARY KEY (id);


--
-- Name: core_document core_document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_document
    ADD CONSTRAINT core_document_pkey PRIMARY KEY (id);


--
-- Name: core_extractor core_extractor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_extractor
    ADD CONSTRAINT core_extractor_pkey PRIMARY KEY (id);


--
-- Name: core_file core_file_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_file
    ADD CONSTRAINT core_file_pkey PRIMARY KEY (id);


--
-- Name: core_operation core_operation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_operation
    ADD CONSTRAINT core_operation_pkey PRIMARY KEY (id);


--
-- Name: core_pipeline_operations core_pipeline_operations_pipeline_id_operation_id_20910f42_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_pipeline_operations
    ADD CONSTRAINT core_pipeline_operations_pipeline_id_operation_id_20910f42_uniq UNIQUE (pipeline_id, operation_id);


--
-- Name: core_pipeline_operations core_pipeline_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_pipeline_operations
    ADD CONSTRAINT core_pipeline_operations_pkey PRIMARY KEY (id);


--
-- Name: core_pipeline core_pipeline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_pipeline
    ADD CONSTRAINT core_pipeline_pkey PRIMARY KEY (id);


--
-- Name: core_schema core_schema_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_schema
    ADD CONSTRAINT core_schema_pkey PRIMARY KEY (id);


--
-- Name: core_tag core_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_tag
    ADD CONSTRAINT core_tag_pkey PRIMARY KEY (id);


--
-- Name: core_transaction core_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_transaction
    ADD CONSTRAINT core_transaction_pkey PRIMARY KEY (id);


--
-- Name: core_user core_user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_email_key UNIQUE (email);


--
-- Name: core_user_groups core_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_groups
    ADD CONSTRAINT core_user_groups_pkey PRIMARY KEY (id);


--
-- Name: core_user_groups core_user_groups_user_id_group_id_c82fcad1_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_groups
    ADD CONSTRAINT core_user_groups_user_id_group_id_c82fcad1_uniq UNIQUE (user_id, group_id);


--
-- Name: core_user core_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_pkey PRIMARY KEY (id);


--
-- Name: core_user_user_permissions core_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_user_permissions
    ADD CONSTRAINT core_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: core_user_user_permissions core_user_user_permissions_user_id_permission_id_73ea0daa_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_user_permissions
    ADD CONSTRAINT core_user_user_permissions_user_id_permission_id_73ea0daa_uniq UNIQUE (user_id, permission_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: core_datastoreinfo_type_id_c3eca0e3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_datastoreinfo_type_id_c3eca0e3 ON public.core_datastoreinfo USING btree (type_id);


--
-- Name: core_datastoreinfo_user_id_b8d9d4cb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_datastoreinfo_user_id_b8d9d4cb ON public.core_datastoreinfo USING btree (user_id);


--
-- Name: core_datastoretype_user_id_7eb1faaa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_datastoretype_user_id_7eb1faaa ON public.core_datastoretype USING btree (user_id);


--
-- Name: core_document_user_id_843edabc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_document_user_id_843edabc ON public.core_document USING btree (user_id);


--
-- Name: core_extractor_user_id_ef6dc20b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_extractor_user_id_ef6dc20b ON public.core_extractor USING btree (user_id);


--
-- Name: core_file_user_id_2faf979a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_file_user_id_2faf979a ON public.core_file USING btree (user_id);


--
-- Name: core_operation_user_id_8776af6c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_operation_user_id_8776af6c ON public.core_operation USING btree (user_id);


--
-- Name: core_pipeline_operations_operation_id_1bdd6198; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_pipeline_operations_operation_id_1bdd6198 ON public.core_pipeline_operations USING btree (operation_id);


--
-- Name: core_pipeline_operations_pipeline_id_524be0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_pipeline_operations_pipeline_id_524be0c0 ON public.core_pipeline_operations USING btree (pipeline_id);


--
-- Name: core_pipeline_user_id_7d2a1239; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_pipeline_user_id_7d2a1239 ON public.core_pipeline USING btree (user_id);


--
-- Name: core_schema_user_id_c3c57ee8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_schema_user_id_c3c57ee8 ON public.core_schema USING btree (user_id);


--
-- Name: core_tag_user_id_1b670500; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_tag_user_id_1b670500 ON public.core_tag USING btree (user_id);


--
-- Name: core_transaction_doc_id_cc7f44f4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_transaction_doc_id_cc7f44f4 ON public.core_transaction USING btree (doc_id);


--
-- Name: core_transaction_user_id_9d7207a3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_transaction_user_id_9d7207a3 ON public.core_transaction USING btree (user_id);


--
-- Name: core_user_email_92a71487_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_user_email_92a71487_like ON public.core_user USING btree (email varchar_pattern_ops);


--
-- Name: core_user_groups_group_id_fe8c697f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_user_groups_group_id_fe8c697f ON public.core_user_groups USING btree (group_id);


--
-- Name: core_user_groups_user_id_70b4d9b8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_user_groups_user_id_70b4d9b8 ON public.core_user_groups USING btree (user_id);


--
-- Name: core_user_user_permissions_permission_id_35ccf601; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_user_user_permissions_permission_id_35ccf601 ON public.core_user_user_permissions USING btree (permission_id);


--
-- Name: core_user_user_permissions_user_id_085123d3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX core_user_user_permissions_user_id_085123d3 ON public.core_user_user_permissions USING btree (user_id);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken_token_user_id_35299eff_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_datastoreinfo core_datastoreinfo_type_id_c3eca0e3_fk_core_datastoretype_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_datastoreinfo
    ADD CONSTRAINT core_datastoreinfo_type_id_c3eca0e3_fk_core_datastoretype_id FOREIGN KEY (type_id) REFERENCES public.core_datastoretype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_datastoreinfo core_datastoreinfo_user_id_b8d9d4cb_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_datastoreinfo
    ADD CONSTRAINT core_datastoreinfo_user_id_b8d9d4cb_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_datastoretype core_datastoretype_user_id_7eb1faaa_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_datastoretype
    ADD CONSTRAINT core_datastoretype_user_id_7eb1faaa_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_document core_document_user_id_843edabc_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_document
    ADD CONSTRAINT core_document_user_id_843edabc_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_extractor core_extractor_user_id_ef6dc20b_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_extractor
    ADD CONSTRAINT core_extractor_user_id_ef6dc20b_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_file core_file_user_id_2faf979a_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_file
    ADD CONSTRAINT core_file_user_id_2faf979a_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_operation core_operation_user_id_8776af6c_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_operation
    ADD CONSTRAINT core_operation_user_id_8776af6c_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_pipeline_operations core_pipeline_operat_operation_id_1bdd6198_fk_core_oper; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_pipeline_operations
    ADD CONSTRAINT core_pipeline_operat_operation_id_1bdd6198_fk_core_oper FOREIGN KEY (operation_id) REFERENCES public.core_operation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_pipeline_operations core_pipeline_operat_pipeline_id_524be0c0_fk_core_pipe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_pipeline_operations
    ADD CONSTRAINT core_pipeline_operat_pipeline_id_524be0c0_fk_core_pipe FOREIGN KEY (pipeline_id) REFERENCES public.core_pipeline(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_pipeline core_pipeline_user_id_7d2a1239_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_pipeline
    ADD CONSTRAINT core_pipeline_user_id_7d2a1239_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_schema core_schema_user_id_c3c57ee8_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_schema
    ADD CONSTRAINT core_schema_user_id_c3c57ee8_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_tag core_tag_user_id_1b670500_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_tag
    ADD CONSTRAINT core_tag_user_id_1b670500_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_transaction core_transaction_doc_id_cc7f44f4_fk_core_document_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_transaction
    ADD CONSTRAINT core_transaction_doc_id_cc7f44f4_fk_core_document_id FOREIGN KEY (doc_id) REFERENCES public.core_document(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_transaction core_transaction_user_id_9d7207a3_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_transaction
    ADD CONSTRAINT core_transaction_user_id_9d7207a3_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_user_groups core_user_groups_group_id_fe8c697f_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_groups
    ADD CONSTRAINT core_user_groups_group_id_fe8c697f_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_user_groups core_user_groups_user_id_70b4d9b8_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_groups
    ADD CONSTRAINT core_user_groups_user_id_70b4d9b8_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_user_user_permissions core_user_user_permi_permission_id_35ccf601_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_user_permissions
    ADD CONSTRAINT core_user_user_permi_permission_id_35ccf601_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_user_user_permissions core_user_user_permissions_user_id_085123d3_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user_user_permissions
    ADD CONSTRAINT core_user_user_permissions_user_id_085123d3_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_core_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_core_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

