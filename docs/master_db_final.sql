--
-- PostgreSQL database dump
--

-- Dumped from database version 11.8
-- Dumped by pg_dump version 11.8

-- Started on 2021-01-12 21:59:15

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
-- TOC entry 334 (class 1255 OID 122424)
-- Name: process_disbursement_assignment_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.process_disbursement_assignment_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE' AND OLD.owner!=NEW.owner AND OLD.owner!=0) THEN
            INSERT INTO disbursement_assignment_history (
id, owner, state_id,disbursement_id,assigned_on,updated_by,updated_on) select OLD.id, OLD.owner, OLD.state_id,OLD.disbursement_id,OLD.assigned_on,OLD.updated_by,now();

            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;


ALTER FUNCTION public.process_disbursement_assignment_change() OWNER TO postgres;

--
-- TOC entry 335 (class 1255 OID 122425)
-- Name: process_disbursement_state_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.process_disbursement_state_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE' AND OLD.status_id!=NEW.status_id) THEN
            INSERT INTO disbursement_history (
id, requested_amount, reason, requested_on, requested_by, status_id,grant_id,note,note_added,note_added_by,created_at,created_by,updated_at,updated_by,moved_on,grantee_entry,other_sources,report_id) select OLD.id, OLD.requested_amount, OLD.reason, OLD.requested_on, OLD.requested_by, OLD.status_id,OLD.grant_id,NEW.note,NEW.note_added,NEW.note_added_by,OLD.created_at,OLD.created_by,OLD.updated_at,OLD.updated_by,OLD.moved_on,OLD.grantee_entry,OLD.other_sources,OLD.report_id;

            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;


ALTER FUNCTION public.process_disbursement_state_change() OWNER TO postgres;

--
-- TOC entry 336 (class 1255 OID 122426)
-- Name: process_grant_assignment_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.process_grant_assignment_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE' AND OLD.assignments!=NEW.assignments AND OLD.assignments!=0) THEN
            INSERT INTO grant_assignment_history (
id, assignments, state_id,grant_id,assigned_on,updated_by,updated_on) select OLD.id, OLD.assignments, OLD.state_id,OLD.grant_id,OLD.assigned_on,NEW.updated_by,now();

            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;


ALTER FUNCTION public.process_grant_assignment_change() OWNER TO postgres;

--
-- TOC entry 337 (class 1255 OID 122427)
-- Name: process_grant_state_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.process_grant_state_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE' AND OLD.grant_status_id!=NEW.grant_status_id) THEN
            INSERT INTO grant_history (
id, amount, created_at, created_by, description, end_date, name, representative, start_date, status_name, template_id, updated_at, updated_by, grant_status_id, grantor_org_id, organization_id, substatus_id, note, note_added,note_added_by,moved_on,reference_no,deleted) select OLD.id, OLD.amount, OLD.created_at, OLD.created_by, OLD.description, OLD.end_date, OLD.name, OLD.representative, OLD.start_date, OLD.status_name, OLD.template_id, OLD.updated_at, OLD.updated_by, OLD.grant_status_id, OLD.grantor_org_id, OLD.organization_id, OLD.substatus_id, NEW.note, NEW.note_added,NEW.note_added_by,OLD.moved_on,OLD.reference_no,OLD.deleted;

            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;


ALTER FUNCTION public.process_grant_state_change() OWNER TO postgres;

--
-- TOC entry 338 (class 1255 OID 122428)
-- Name: process_report_assignment_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.process_report_assignment_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE' AND OLD.assignment!=NEW.assignment AND OLD.assignment!=0) THEN
            INSERT INTO report_assignment_history (
id, assignment, state_id,report_id,assigned_on,updated_by,updated_on) select OLD.id, OLD.assignment, OLD.state_id,OLD.report_id,OLD.assigned_on,OLD.updated_by,now();

            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;


ALTER FUNCTION public.process_report_assignment_change() OWNER TO postgres;

--
-- TOC entry 351 (class 1255 OID 122429)
-- Name: process_report_state_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.process_report_state_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN

        IF (TG_OP = 'UPDATE' AND OLD.status_id!=NEW.status_id) THEN
INSERT INTO report_history(
id, name, start_date, end_date, due_date, status_id, created_at, created_by, updated_at, updated_by, grant_id,type, note, note_added,note_added_by,template_id,moved_on,linked_approved_reports,report_detail)
select OLD.id, OLD.name, OLD.start_date, OLD.end_date, OLD.due_date, OLD.status_id, OLD.created_at, OLD.created_by, OLD.updated_at, OLD.updated_by, OLD.grant_id,OLD.type, NEW.note, NEW.note_added,NEW.note_added_by,OLD.template_id,OLD.moved_on,OLD.linked_approved_reports,OLD.report_detail;
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;

$$;


ALTER FUNCTION public.process_report_state_change() OWNER TO postgres;

--
-- TOC entry 352 (class 1255 OID 122430)
-- Name: refresh_mat_views(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.refresh_mat_views() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
    refresh materialized view granter_count_and_amount_totals;
 refresh materialized view granter_grantees;
end
$$;


ALTER FUNCTION public.refresh_mat_views() OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 122431)
-- Name: actual_disbursements_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actual_disbursements_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.actual_disbursements_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 197 (class 1259 OID 122433)
-- Name: actual_disbursements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actual_disbursements (
    id bigint DEFAULT nextval('public.actual_disbursements_seq'::regclass) NOT NULL,
    disbursement_date timestamp without time zone,
    actual_amount double precision,
    note text,
    disbursement_id bigint,
    created_at timestamp without time zone,
    created_by bigint,
    updated_at timestamp without time zone,
    updated_by bigint,
    other_sources double precision,
    order_position integer,
    status boolean DEFAULT false,
    saved boolean DEFAULT false
);


ALTER TABLE public.actual_disbursements OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 122442)
-- Name: app_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_config (
    id bigint NOT NULL,
    config_name character varying(255),
    config_value text,
    description text,
    configurable boolean DEFAULT false,
    key bigint,
    type character varying(10)
);


ALTER TABLE public.app_config OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 122449)
-- Name: app_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_config_id_seq OWNER TO postgres;

--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 199
-- Name: app_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_config_id_seq OWNED BY public.app_config.id;


--
-- TOC entry 200 (class 1259 OID 122451)
-- Name: disb_assign_hist; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.disb_assign_hist
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.disb_assign_hist OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 122453)
-- Name: disbursement_assignment_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disbursement_assignment_history (
    seqid bigint DEFAULT nextval('public.disb_assign_hist'::regclass) NOT NULL,
    id bigint,
    owner bigint,
    anchor boolean,
    state_id bigint,
    disbursement_id bigint,
    updated_on timestamp without time zone,
    assigned_on timestamp without time zone,
    updated_by bigint
);


ALTER TABLE public.disbursement_assignment_history OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 122457)
-- Name: disbursement_assignment_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.disbursement_assignment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.disbursement_assignment_seq OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 122459)
-- Name: disbursement_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disbursement_assignments (
    id bigint DEFAULT nextval('public.disbursement_assignment_seq'::regclass) NOT NULL,
    disbursement_id bigint,
    owner bigint,
    anchor boolean,
    state_id bigint,
    assigned_on timestamp without time zone,
    updated_by bigint
);


ALTER TABLE public.disbursement_assignments OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 122463)
-- Name: disbursement_hist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.disbursement_hist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.disbursement_hist_id_seq OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 122465)
-- Name: disbursement_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disbursement_history (
    seqid bigint DEFAULT nextval('public.disbursement_hist_id_seq'::regclass) NOT NULL,
    id bigint,
    requested_amount double precision,
    reason text,
    requested_on timestamp without time zone,
    requested_by bigint,
    status_id bigint,
    grant_id bigint,
    note text,
    note_added timestamp without time zone,
    note_added_by bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    moved_on timestamp without time zone,
    grantee_entry boolean DEFAULT false,
    other_sources real,
    report_id bigint
);


ALTER TABLE public.disbursement_history OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 122473)
-- Name: disbursement_snapshot_seq_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.disbursement_snapshot_seq_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.disbursement_snapshot_seq_id OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 122475)
-- Name: disbursement_snapshot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disbursement_snapshot (
    id bigint DEFAULT nextval('public.disbursement_snapshot_seq_id'::regclass) NOT NULL,
    assigned_to_id bigint,
    disbursement_id bigint,
    status_id bigint,
    requested_amount double precision,
    reason text,
    from_state_id bigint,
    from_note text,
    moved_by bigint,
    from_string_attributes text,
    to_state_id bigint,
    moved_on timestamp without time zone
);


ALTER TABLE public.disbursement_snapshot OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 122482)
-- Name: disbursements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.disbursements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.disbursements_id_seq OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 122484)
-- Name: disbursements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disbursements (
    id bigint DEFAULT nextval('public.disbursements_id_seq'::regclass) NOT NULL,
    requested_amount double precision,
    reason text,
    requested_on timestamp without time zone,
    requested_by bigint,
    status_id bigint,
    grant_id bigint,
    note text,
    note_added timestamp without time zone,
    note_added_by bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    moved_on timestamp without time zone,
    grantee_entry boolean DEFAULT false,
    other_sources real,
    report_id bigint,
    disabled_by_amendment boolean DEFAULT false
);


ALTER TABLE public.disbursements OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 122493)
-- Name: doc_kpi_data_document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doc_kpi_data_document (
    id bigint NOT NULL,
    file_name character varying(255),
    file_type character varying(255),
    version integer,
    doc_kpi_data_id bigint
);


ALTER TABLE public.doc_kpi_data_document OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 122499)
-- Name: doc_kpi_data_document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doc_kpi_data_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doc_kpi_data_document_id_seq OWNER TO postgres;

--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 211
-- Name: doc_kpi_data_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_kpi_data_document_id_seq OWNED BY public.doc_kpi_data_document.id;


--
-- TOC entry 212 (class 1259 OID 122501)
-- Name: document_kpi_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document_kpi_notes (
    id bigint NOT NULL,
    message character varying(255),
    posted_on timestamp without time zone,
    kpi_data_id bigint,
    posted_by_id bigint
);


ALTER TABLE public.document_kpi_notes OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 122504)
-- Name: document_kpi_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.document_kpi_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.document_kpi_notes_id_seq OWNER TO postgres;

--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 213
-- Name: document_kpi_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.document_kpi_notes_id_seq OWNED BY public.document_kpi_notes.id;


--
-- TOC entry 214 (class 1259 OID 122506)
-- Name: grant_assign_hist; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_assign_hist
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_assign_hist OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 122508)
-- Name: grant_assignment_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_assignment_history (
    seqid bigint DEFAULT nextval('public.grant_assign_hist'::regclass) NOT NULL,
    id bigint,
    assignments bigint,
    state_id bigint,
    grant_id bigint,
    updated_on timestamp without time zone,
    assigned_on timestamp without time zone,
    updated_by bigint
);


ALTER TABLE public.grant_assignment_history OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 122512)
-- Name: grant_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_assignments (
    id bigint NOT NULL,
    anchor boolean,
    assignments bigint,
    grant_id bigint,
    state_id bigint,
    assigned_on timestamp without time zone,
    updated_by bigint
);


ALTER TABLE public.grant_assignments OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 122515)
-- Name: grant_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_assignments_id_seq OWNER TO postgres;

--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 217
-- Name: grant_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_assignments_id_seq OWNED BY public.grant_assignments.id;


--
-- TOC entry 218 (class 1259 OID 122517)
-- Name: grant_attrib_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_attrib_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_attrib_attachments_id_seq OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 122519)
-- Name: grant_document_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_document_attributes (
    id bigint NOT NULL,
    file_type character varying(255),
    location character varying(255),
    name character varying(255),
    version integer,
    grant_id bigint,
    section_id bigint,
    section_attribute_id bigint
);


ALTER TABLE public.grant_document_attributes OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 122525)
-- Name: grant_document_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_document_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_document_attributes_id_seq OWNER TO postgres;

--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 220
-- Name: grant_document_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_document_attributes_id_seq OWNED BY public.grant_document_attributes.id;


--
-- TOC entry 221 (class 1259 OID 122527)
-- Name: grant_document_kpi_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_document_kpi_data (
    id bigint NOT NULL,
    actuals character varying(255),
    goal character varying(255),
    note character varying(255),
    to_report boolean,
    type character varying(255),
    grant_kpi_id bigint,
    submission_id bigint
);


ALTER TABLE public.grant_document_kpi_data OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 122533)
-- Name: grant_document_kpi_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_document_kpi_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_document_kpi_data_id_seq OWNER TO postgres;

--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 222
-- Name: grant_document_kpi_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_document_kpi_data_id_seq OWNED BY public.grant_document_kpi_data.id;


--
-- TOC entry 223 (class 1259 OID 122535)
-- Name: grant_documents_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_documents_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_documents_seq OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 122537)
-- Name: grant_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_documents (
    id bigint DEFAULT nextval('public.grant_documents_seq'::regclass) NOT NULL,
    location text,
    uploaded_on timestamp without time zone,
    uploaded_by bigint,
    name text,
    extension text,
    grant_id bigint
);


ALTER TABLE public.grant_documents OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 122544)
-- Name: grant_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_history_id_seq OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 122546)
-- Name: grant_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_history (
    seqid bigint DEFAULT nextval('public.grant_history_id_seq'::regclass) NOT NULL,
    id bigint,
    amount double precision,
    created_at timestamp without time zone,
    created_by character varying(255),
    description text,
    end_date timestamp without time zone,
    name text,
    representative character varying(255),
    start_date timestamp without time zone,
    status_name character varying(255),
    template_id bigint,
    updated_at timestamp without time zone,
    updated_by character varying(255),
    grant_status_id bigint,
    grantor_org_id bigint,
    organization_id bigint,
    substatus_id bigint,
    note text,
    note_added timestamp without time zone,
    note_added_by text,
    moved_on timestamp without time zone,
    reference_no text,
    deleted boolean DEFAULT false,
    amended boolean DEFAULT false,
    orig_grant_id bigint,
    amend_grant_id bigint,
    amendment_no integer DEFAULT 0
);


ALTER TABLE public.grant_history OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 122556)
-- Name: grant_kpis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_kpis (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    created_by character varying(255),
    description character varying(255),
    periodicity_unit character varying(255),
    kpi_reporting_type character varying(255),
    kpi_type character varying(255),
    periodicity integer,
    is_scheduled boolean,
    title character varying(255),
    updated_at timestamp without time zone,
    updated_by character varying(255),
    grant_id bigint
);


ALTER TABLE public.grant_kpis OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 122562)
-- Name: grant_kpis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_kpis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_kpis_id_seq OWNER TO postgres;

--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 228
-- Name: grant_kpis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_kpis_id_seq OWNED BY public.grant_kpis.id;


--
-- TOC entry 229 (class 1259 OID 122564)
-- Name: grant_qualitative_kpi_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_qualitative_kpi_data (
    id bigint NOT NULL,
    actuals character varying(255),
    goal character varying(255),
    note character varying(255),
    to_report boolean,
    grant_kpi_id bigint,
    submission_id bigint
);


ALTER TABLE public.grant_qualitative_kpi_data OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 122570)
-- Name: grant_qualitative_kpi_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_qualitative_kpi_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_qualitative_kpi_data_id_seq OWNER TO postgres;

--
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 230
-- Name: grant_qualitative_kpi_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_qualitative_kpi_data_id_seq OWNED BY public.grant_qualitative_kpi_data.id;


--
-- TOC entry 231 (class 1259 OID 122572)
-- Name: grant_quantitative_kpi_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_quantitative_kpi_data (
    id bigint NOT NULL,
    actuals integer,
    goal integer,
    note character varying(255),
    to_report boolean,
    grant_kpi_id bigint,
    submission_id bigint
);


ALTER TABLE public.grant_quantitative_kpi_data OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 122575)
-- Name: grant_quantitative_kpi_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_quantitative_kpi_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_quantitative_kpi_data_id_seq OWNER TO postgres;

--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 232
-- Name: grant_quantitative_kpi_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_quantitative_kpi_data_id_seq OWNED BY public.grant_quantitative_kpi_data.id;


--
-- TOC entry 233 (class 1259 OID 122577)
-- Name: grant_section_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_section_attributes (
    id bigint NOT NULL,
    deletable boolean,
    field_name character varying(255),
    field_type character varying(255),
    required boolean,
    type character varying(255),
    section_id bigint
);


ALTER TABLE public.grant_section_attributes OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 122583)
-- Name: grant_section_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_section_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_section_attributes_id_seq OWNER TO postgres;

--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 234
-- Name: grant_section_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_section_attributes_id_seq OWNED BY public.grant_section_attributes.id;


--
-- TOC entry 235 (class 1259 OID 122585)
-- Name: grant_sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_sections (
    id bigint NOT NULL,
    deletable boolean,
    section_name character varying(255)
);


ALTER TABLE public.grant_sections OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 122588)
-- Name: grant_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_sections_id_seq OWNER TO postgres;

--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 236
-- Name: grant_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_sections_id_seq OWNED BY public.grant_sections.id;


--
-- TOC entry 237 (class 1259 OID 122590)
-- Name: grant_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_snapshot_id_seq OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 122592)
-- Name: grant_snapshot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_snapshot (
    id bigint DEFAULT nextval('public.grant_snapshot_id_seq'::regclass) NOT NULL,
    assigned_to_id bigint,
    grant_id bigint,
    grantee text,
    string_attributes text,
    name text,
    description text,
    amount double precision,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    representative character varying(255),
    grant_status_id bigint,
    moved_on timestamp without time zone,
    assigned_by bigint,
    amended boolean DEFAULT false,
    orig_grant_id bigint,
    amend_grant_id bigint,
    amendment_no integer DEFAULT 0,
    from_state_id bigint,
    from_note text,
    moved_by bigint,
    from_string_attributes text,
    to_state_id bigint
);


ALTER TABLE public.grant_snapshot OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 122601)
-- Name: grant_specific_section_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_specific_section_attributes (
    id bigint NOT NULL,
    attribute_order integer,
    deletable boolean,
    extras text,
    field_name text,
    field_type text,
    required boolean,
    granter_id bigint,
    section_id bigint
);


ALTER TABLE public.grant_specific_section_attributes OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 122607)
-- Name: grant_specific_section_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_specific_section_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_specific_section_attributes_id_seq OWNER TO postgres;

--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 240
-- Name: grant_specific_section_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_specific_section_attributes_id_seq OWNED BY public.grant_specific_section_attributes.id;


--
-- TOC entry 241 (class 1259 OID 122609)
-- Name: grant_specific_sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_specific_sections (
    id bigint NOT NULL,
    deletable boolean,
    grant_id bigint,
    grant_template_id bigint,
    section_name character varying(255),
    section_order integer,
    granter_id bigint
);


ALTER TABLE public.grant_specific_sections OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 122612)
-- Name: grant_specific_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_specific_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_specific_sections_id_seq OWNER TO postgres;

--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 242
-- Name: grant_specific_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_specific_sections_id_seq OWNED BY public.grant_specific_sections.id;


--
-- TOC entry 243 (class 1259 OID 122614)
-- Name: grant_string_attribute_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_string_attribute_attachments (
    id bigint DEFAULT nextval('public.grant_attrib_attachments_id_seq'::regclass) NOT NULL,
    name text,
    description text,
    location text,
    version integer DEFAULT 1,
    title text,
    type text,
    created_on date,
    created_by text,
    updated_on date,
    updated_by text,
    grant_string_attribute_id bigint
);


ALTER TABLE public.grant_string_attribute_attachments OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 122622)
-- Name: grant_string_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_string_attributes (
    id bigint NOT NULL,
    frequency character varying(255),
    target character varying(255),
    value text,
    grant_id bigint,
    section_id bigint,
    section_attribute_id bigint
);


ALTER TABLE public.grant_string_attributes OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 122628)
-- Name: grant_string_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_string_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grant_string_attributes_id_seq OWNER TO postgres;

--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 245
-- Name: grant_string_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_string_attributes_id_seq OWNED BY public.grant_string_attributes.id;


--
-- TOC entry 246 (class 1259 OID 122630)
-- Name: grantees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grantees (
    id bigint NOT NULL
);


ALTER TABLE public.grantees OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 122633)
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    organization_type character varying(31) NOT NULL,
    id bigint NOT NULL,
    code character varying(255),
    created_at timestamp without time zone,
    created_by character varying(255),
    name character varying(255),
    updated_at timestamp without time zone,
    updated_by character varying(255)
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 122639)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    created_by character varying(255),
    email_id character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    password character varying(255),
    updated_at timestamp without time zone,
    updated_by character varying(255),
    organization_id bigint,
    active boolean DEFAULT true,
    user_profile text,
    plain boolean DEFAULT false,
    deleted boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 122648)
-- Name: granter_active_users; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.granter_active_users AS
 SELECT b.id AS granter_id,
    count(*) AS active_users
   FROM (public.users a
     JOIN public.organizations b ON ((b.id = a.organization_id)))
  WHERE ((a.active = true) AND ((b.organization_type)::text = 'GRANTER'::text))
  GROUP BY b.id
  WITH NO DATA;


ALTER TABLE public.granter_active_users OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 122653)
-- Name: grants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grants (
    id bigint NOT NULL,
    amount double precision,
    created_at timestamp without time zone,
    created_by character varying(255),
    description text,
    end_date timestamp without time zone,
    name text,
    representative character varying(255),
    start_date timestamp without time zone,
    status_name character varying(255),
    template_id bigint,
    updated_at timestamp without time zone,
    updated_by character varying(255),
    grant_status_id bigint,
    grantor_org_id bigint,
    organization_id bigint,
    substatus_id bigint,
    note text,
    note_added timestamp without time zone,
    note_added_by text,
    moved_on timestamp without time zone,
    reference_no text,
    deleted boolean DEFAULT false,
    amended boolean DEFAULT false,
    orig_grant_id bigint,
    amend_grant_id bigint,
    amendment_no integer DEFAULT 0
);


ALTER TABLE public.grants OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 122662)
-- Name: workflow_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_statuses (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    created_by character varying(255),
    display_name character varying(255),
    initial boolean,
    internal_status character varying(255),
    name character varying(255),
    terminal boolean,
    updated_at timestamp without time zone,
    updated_by character varying(255),
    verb character varying(255),
    workflow_id bigint
);


ALTER TABLE public.workflow_statuses OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 122668)
-- Name: granter_count_and_amount_totals; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.granter_count_and_amount_totals AS
 SELECT a.grantor_org_id AS granter_id,
    sum(a.amount) AS total_grant_amount,
    count(*) AS total_grants
   FROM (public.grants a
     JOIN public.workflow_statuses b ON ((a.grant_status_id = b.id)))
  WHERE (((b.internal_status)::text = 'ACTIVE'::text) OR ((b.internal_status)::text = 'CLOSED'::text))
  GROUP BY a.grantor_org_id
  WITH NO DATA;


ALTER TABLE public.granter_count_and_amount_totals OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 122673)
-- Name: granter_grant_section_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.granter_grant_section_attributes (
    id bigint NOT NULL,
    attribute_order integer,
    deletable boolean,
    extras text,
    field_name character varying(255),
    field_type character varying(255),
    required boolean,
    granter_id bigint,
    section_id bigint
);


ALTER TABLE public.granter_grant_section_attributes OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 122679)
-- Name: granter_grant_section_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.granter_grant_section_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.granter_grant_section_attributes_id_seq OWNER TO postgres;

--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 254
-- Name: granter_grant_section_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.granter_grant_section_attributes_id_seq OWNED BY public.granter_grant_section_attributes.id;


--
-- TOC entry 255 (class 1259 OID 122681)
-- Name: granter_grant_sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.granter_grant_sections (
    id bigint NOT NULL,
    deletable boolean,
    section_name character varying(255),
    section_order integer,
    grant_template_id bigint,
    granter_id bigint
);


ALTER TABLE public.granter_grant_sections OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 122684)
-- Name: granter_grant_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.granter_grant_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.granter_grant_sections_id_seq OWNER TO postgres;

--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 256
-- Name: granter_grant_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.granter_grant_sections_id_seq OWNED BY public.granter_grant_sections.id;


--
-- TOC entry 257 (class 1259 OID 122686)
-- Name: granter_grant_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.granter_grant_templates (
    id bigint NOT NULL,
    description text,
    granter_id bigint,
    name text,
    published boolean,
    private_to_grant boolean DEFAULT true,
    default_template boolean DEFAULT false
);


ALTER TABLE public.granter_grant_templates OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 122694)
-- Name: granter_grant_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.granter_grant_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.granter_grant_templates_id_seq OWNER TO postgres;

--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 258
-- Name: granter_grant_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.granter_grant_templates_id_seq OWNED BY public.granter_grant_templates.id;


--
-- TOC entry 259 (class 1259 OID 122696)
-- Name: granter_grantees; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.granter_grantees AS
 SELECT DISTINCT a.grantor_org_id AS granter_id,
    count(DISTINCT a.organization_id) AS grantee_totals
   FROM (public.grants a
     JOIN public.workflow_statuses b ON ((a.grant_status_id = b.id)))
  WHERE (((b.internal_status)::text = 'ACTIVE'::text) OR ((b.internal_status)::text = 'CLOSED'::text))
  GROUP BY a.grantor_org_id
  WITH NO DATA;


ALTER TABLE public.granter_grantees OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 122701)
-- Name: granter_report_section_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.granter_report_section_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.granter_report_section_attributes_id_seq OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 122703)
-- Name: granter_report_section_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.granter_report_section_attributes (
    id bigint DEFAULT nextval('public.granter_report_section_attributes_id_seq'::regclass) NOT NULL,
    attribute_order integer,
    deletable boolean,
    extras text,
    field_name character varying(255),
    field_type character varying(255),
    required boolean,
    granter_id bigint,
    section_id bigint
);


ALTER TABLE public.granter_report_section_attributes OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 122710)
-- Name: granter_report_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.granter_report_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.granter_report_sections_id_seq OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 122712)
-- Name: granter_report_sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.granter_report_sections (
    id bigint DEFAULT nextval('public.granter_report_sections_id_seq'::regclass) NOT NULL,
    deletable boolean,
    section_name character varying(255),
    section_order integer,
    report_template_id bigint,
    granter_id bigint
);


ALTER TABLE public.granter_report_sections OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 122716)
-- Name: granter_report_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.granter_report_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.granter_report_templates_id_seq OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 122718)
-- Name: granter_report_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.granter_report_templates (
    id bigint DEFAULT nextval('public.granter_report_templates_id_seq'::regclass) NOT NULL,
    description text,
    granter_id bigint,
    name text,
    published boolean,
    private_to_report boolean DEFAULT true,
    default_template boolean DEFAULT false
);


ALTER TABLE public.granter_report_templates OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 122727)
-- Name: granters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.granters (
    host_url character varying(255),
    image_name character varying(255),
    navbar_color character varying(255),
    navbar_text_color character varying(255),
    id bigint NOT NULL
);


ALTER TABLE public.granters OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 122733)
-- Name: grants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grants_id_seq OWNER TO postgres;

--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 267
-- Name: grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grants_id_seq OWNED BY public.grants.id;


--
-- TOC entry 268 (class 1259 OID 122735)
-- Name: grants_to_verify; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grants_to_verify (
    status character varying(255),
    moved_on timestamp without time zone,
    reference_no text,
    concat text
);


ALTER TABLE public.grants_to_verify OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 122741)
-- Name: mail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mail_id_seq OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 122743)
-- Name: mail_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mail_logs (
    id bigint DEFAULT nextval('public.mail_id_seq'::regclass) NOT NULL,
    sent_on timestamp without time zone,
    cc text,
    sent_to text,
    msg text,
    subject text,
    status boolean
);


ALTER TABLE public.mail_logs OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 122750)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    message text,
    posted_on timestamp without time zone,
    read boolean,
    user_id bigint,
    grant_id bigint,
    title text,
    report_id bigint,
    notification_for character varying(25),
    disbursement_id bigint
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 122756)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO postgres;

--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 272
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 273 (class 1259 OID 122758)
-- Name: org_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_config (
    id bigint NOT NULL,
    config_name character varying(255),
    config_value text,
    granter_id bigint,
    description text,
    configurable boolean DEFAULT false,
    key bigint,
    type character varying(10)
);


ALTER TABLE public.org_config OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 122765)
-- Name: org_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.org_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.org_config_id_seq OWNER TO postgres;

--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 274
-- Name: org_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.org_config_id_seq OWNED BY public.org_config.id;


--
-- TOC entry 275 (class 1259 OID 122768)
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organizations_id_seq OWNER TO postgres;

--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 275
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- TOC entry 276 (class 1259 OID 122770)
-- Name: password_reset_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.password_reset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.password_reset_id_seq OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 122772)
-- Name: password_reset_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_request (
    id bigint DEFAULT nextval('public.password_reset_id_seq'::regclass) NOT NULL,
    key character varying(255),
    user_id bigint,
    validated boolean DEFAULT false,
    requested_on timestamp without time zone DEFAULT now(),
    validated_on timestamp without time zone,
    org_id bigint,
    code text
);


ALTER TABLE public.password_reset_request OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 122781)
-- Name: platform; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platform (
    host_url character varying(255),
    image_name character varying(255),
    navbar_color character varying(255),
    id bigint NOT NULL
);


ALTER TABLE public.platform OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 122787)
-- Name: qual_kpi_data_document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qual_kpi_data_document (
    id bigint NOT NULL,
    file_name character varying(255),
    file_type character varying(255),
    version integer,
    qual_kpi_data_id bigint
);


ALTER TABLE public.qual_kpi_data_document OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 122793)
-- Name: qual_kpi_data_document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qual_kpi_data_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qual_kpi_data_document_id_seq OWNER TO postgres;

--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 280
-- Name: qual_kpi_data_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qual_kpi_data_document_id_seq OWNED BY public.qual_kpi_data_document.id;


--
-- TOC entry 281 (class 1259 OID 122795)
-- Name: qualitative_kpi_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qualitative_kpi_notes (
    id bigint NOT NULL,
    message character varying(255),
    posted_on timestamp without time zone,
    kpi_data_id bigint,
    posted_by_id bigint
);


ALTER TABLE public.qualitative_kpi_notes OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 122798)
-- Name: qualitative_kpi_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qualitative_kpi_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qualitative_kpi_notes_id_seq OWNER TO postgres;

--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 282
-- Name: qualitative_kpi_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qualitative_kpi_notes_id_seq OWNED BY public.qualitative_kpi_notes.id;


--
-- TOC entry 283 (class 1259 OID 122800)
-- Name: quant_kpi_data_document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quant_kpi_data_document (
    id bigint NOT NULL,
    file_name character varying(255),
    file_type character varying(255),
    version integer,
    quant_kpi_data_id bigint
);


ALTER TABLE public.quant_kpi_data_document OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 122806)
-- Name: quant_kpi_data_document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quant_kpi_data_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quant_kpi_data_document_id_seq OWNER TO postgres;

--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 284
-- Name: quant_kpi_data_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quant_kpi_data_document_id_seq OWNED BY public.quant_kpi_data_document.id;


--
-- TOC entry 285 (class 1259 OID 122808)
-- Name: quantitative_kpi_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quantitative_kpi_notes (
    id bigint NOT NULL,
    message character varying(255),
    posted_on timestamp without time zone,
    kpi_data_id bigint,
    posted_by_id bigint
);


ALTER TABLE public.quantitative_kpi_notes OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 122811)
-- Name: quantitative_kpi_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quantitative_kpi_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quantitative_kpi_notes_id_seq OWNER TO postgres;

--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 286
-- Name: quantitative_kpi_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quantitative_kpi_notes_id_seq OWNED BY public.quantitative_kpi_notes.id;


--
-- TOC entry 287 (class 1259 OID 122813)
-- Name: release_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.release_id_seq OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 122815)
-- Name: release; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.release (
    id bigint DEFAULT nextval('public.release_id_seq'::regclass) NOT NULL,
    version character varying(255)
);


ALTER TABLE public.release OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 122819)
-- Name: report_assign_hist; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_assign_hist
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_assign_hist OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 122821)
-- Name: report_assignment_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_assignment_history (
    seqid bigint DEFAULT nextval('public.report_assign_hist'::regclass) NOT NULL,
    id bigint,
    assignment bigint,
    state_id bigint,
    report_id bigint,
    updated_on timestamp without time zone,
    assigned_on timestamp without time zone,
    updated_by bigint
);


ALTER TABLE public.report_assignment_history OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 122825)
-- Name: report_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_assignments_id_seq
    START WITH 768
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_assignments_id_seq OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 122827)
-- Name: report_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_assignments (
    id bigint DEFAULT nextval('public.report_assignments_id_seq'::regclass) NOT NULL,
    report_id bigint,
    state_id bigint,
    assignment bigint,
    anchor boolean,
    assigned_on timestamp without time zone,
    updated_by bigint
);


ALTER TABLE public.report_assignments OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 122831)
-- Name: report_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_history_id_seq OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 122833)
-- Name: report_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_history (
    seqid bigint DEFAULT nextval('public.report_history_id_seq'::regclass) NOT NULL,
    id bigint,
    name text,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    due_date timestamp without time zone,
    status_id bigint,
    created_at timestamp without time zone,
    created_by bigint,
    updated_at timestamp without time zone,
    updated_by bigint,
    grant_id bigint,
    note text,
    note_added timestamp without time zone,
    note_added_by bigint,
    template_id bigint,
    type text,
    moved_on timestamp without time zone,
    linked_approved_reports text,
    report_detail text,
    deleted boolean DEFAULT false
);


ALTER TABLE public.report_history OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 122841)
-- Name: report_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_snapshot_id_seq OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 122843)
-- Name: report_snapshot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_snapshot (
    id bigint DEFAULT nextval('public.report_snapshot_id_seq'::regclass) NOT NULL,
    assigned_to_id bigint,
    report_id bigint,
    string_attributes text,
    name text,
    description text,
    status_id bigint,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    due_date timestamp without time zone,
    from_state_id bigint,
    from_note text,
    moved_by bigint,
    from_string_attributes text,
    to_state_id bigint,
    moved_on timestamp without time zone
);


ALTER TABLE public.report_snapshot OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 122850)
-- Name: report_specific_section_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_specific_section_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_specific_section_attributes_id_seq OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 122852)
-- Name: report_specific_section_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_specific_section_attributes (
    id bigint DEFAULT nextval('public.report_specific_section_attributes_id_seq'::regclass) NOT NULL,
    attribute_order integer,
    deletable boolean,
    extras text,
    field_name text,
    field_type text,
    required boolean,
    granter_id bigint,
    section_id bigint,
    can_edit boolean DEFAULT true
);


ALTER TABLE public.report_specific_section_attributes OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 122860)
-- Name: report_specific_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_specific_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_specific_sections_id_seq OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 122862)
-- Name: report_specific_sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_specific_sections (
    id bigint DEFAULT nextval('public.report_specific_sections_id_seq'::regclass) NOT NULL,
    deletable boolean,
    report_id bigint,
    report_template_id bigint,
    section_name character varying(255),
    section_order integer,
    granter_id bigint
);


ALTER TABLE public.report_specific_sections OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 122866)
-- Name: report_string_attribute_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_string_attribute_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_string_attribute_attachments_id_seq OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 122868)
-- Name: report_string_attribute_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_string_attribute_attachments (
    id bigint DEFAULT nextval('public.report_string_attribute_attachments_id_seq'::regclass) NOT NULL,
    created_by character varying(255),
    created_on timestamp without time zone,
    description text,
    location character varying(255),
    name text,
    title character varying(255),
    type character varying(255),
    updated_by character varying(255),
    updated_on timestamp without time zone,
    version integer,
    report_string_attribute_id bigint
);


ALTER TABLE public.report_string_attribute_attachments OWNER TO postgres;

--
-- TOC entry 303 (class 1259 OID 122875)
-- Name: report_string_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_string_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_string_attributes_id_seq OWNER TO postgres;

--
-- TOC entry 304 (class 1259 OID 122877)
-- Name: report_string_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_string_attributes (
    id bigint DEFAULT nextval('public.report_string_attributes_id_seq'::regclass) NOT NULL,
    frequency character varying(255),
    target character varying(255),
    value text,
    report_id bigint,
    section_id bigint,
    section_attribute_id bigint,
    grant_level_target text DEFAULT ''::text,
    actual_target text
);


ALTER TABLE public.report_string_attributes OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 122885)
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reports_id_seq OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 122887)
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports (
    id bigint DEFAULT nextval('public.reports_id_seq'::regclass) NOT NULL,
    name text,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    due_date timestamp without time zone,
    status_id bigint,
    created_at timestamp without time zone,
    created_by bigint,
    updated_at timestamp without time zone,
    updated_by bigint,
    grant_id bigint,
    type text,
    note text,
    note_added timestamp without time zone,
    note_added_by bigint,
    template_id bigint,
    moved_on timestamp without time zone,
    linked_approved_reports text,
    report_detail text,
    disabled_by_amendment boolean DEFAULT false,
    deleted boolean DEFAULT false
);


ALTER TABLE public.reports OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 122896)
-- Name: rfps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rfps (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    created_by character varying(255),
    description character varying(255),
    title character varying(255),
    updated_at timestamp without time zone,
    updated_by character varying(255),
    granter_id bigint
);


ALTER TABLE public.rfps OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 122902)
-- Name: rfps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rfps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rfps_id_seq OWNER TO postgres;

--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 308
-- Name: rfps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rfps_id_seq OWNED BY public.rfps.id;


--
-- TOC entry 309 (class 1259 OID 122904)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    created_by character varying(255),
    name character varying(255),
    updated_at timestamp without time zone,
    updated_by character varying(255),
    organization_id bigint,
    description text,
    internal boolean DEFAULT false
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 122911)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 310
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 311 (class 1259 OID 122913)
-- Name: roles_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles_permission (
    id bigint NOT NULL,
    permission character varying(255),
    role_id bigint
);


ALTER TABLE public.roles_permission OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 122916)
-- Name: roles_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_permission_id_seq OWNER TO postgres;

--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 312
-- Name: roles_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_permission_id_seq OWNED BY public.roles_permission.id;


--
-- TOC entry 313 (class 1259 OID 122918)
-- Name: submission_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submission_note (
    id bigint NOT NULL,
    message character varying(255),
    posted_on timestamp without time zone,
    posted_by_id bigint,
    submission_id bigint
);


ALTER TABLE public.submission_note OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 122921)
-- Name: submission_note_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submission_note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submission_note_id_seq OWNER TO postgres;

--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 314
-- Name: submission_note_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.submission_note_id_seq OWNED BY public.submission_note.id;


--
-- TOC entry 315 (class 1259 OID 122923)
-- Name: submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submissions (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    created_by character varying(255),
    submit_by timestamp without time zone,
    submitted_on timestamp without time zone,
    title character varying(255),
    updated_at timestamp without time zone,
    updated_by character varying(255),
    grant_id bigint,
    submission_status_id bigint
);


ALTER TABLE public.submissions OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 122929)
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submissions_id_seq OWNER TO postgres;

--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 316
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.submissions_id_seq OWNED BY public.submissions.id;


--
-- TOC entry 317 (class 1259 OID 122931)
-- Name: template_library; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.template_library (
    id bigint NOT NULL,
    description text,
    file_type character varying(255),
    granter_id bigint,
    location character varying(255),
    name text,
    type character varying(255),
    version integer
);


ALTER TABLE public.template_library OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 122937)
-- Name: template_library_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.template_library_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.template_library_id_seq OWNER TO postgres;

--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 318
-- Name: template_library_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.template_library_id_seq OWNED BY public.template_library.id;


--
-- TOC entry 319 (class 1259 OID 122939)
-- Name: templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.templates (
    id bigint NOT NULL,
    description character varying(255),
    file_type character varying(255),
    location character varying(255),
    name character varying(255),
    type character varying(255),
    version integer,
    kpi_id bigint
);


ALTER TABLE public.templates OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 122945)
-- Name: templates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.templates_id_seq OWNER TO postgres;

--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 320
-- Name: templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.templates_id_seq OWNED BY public.templates.id;


--
-- TOC entry 321 (class 1259 OID 122947)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id bigint NOT NULL,
    role_id bigint,
    user_id bigint
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 122950)
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_roles_id_seq OWNER TO postgres;

--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 322
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- TOC entry 323 (class 1259 OID 122952)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 323
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 324 (class 1259 OID 122954)
-- Name: work_flow_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_flow_permission (
    id bigint NOT NULL,
    action character varying(255),
    from_name character varying(255),
    from_state_id bigint,
    note_required boolean,
    to_name character varying(255),
    to_state_id bigint
);


ALTER TABLE public.work_flow_permission OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 122960)
-- Name: workflow_action_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_action_permission (
    id bigint NOT NULL,
    permissions_string character varying(255)
);


ALTER TABLE public.workflow_action_permission OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 122963)
-- Name: workflow_state_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_state_permissions (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    created_by character varying(255),
    permission character varying(255),
    updated_at timestamp without time zone,
    updated_by character varying(255),
    role_id bigint,
    workflow_status_id bigint
);


ALTER TABLE public.workflow_state_permissions OWNER TO postgres;

--
-- TOC entry 327 (class 1259 OID 122969)
-- Name: workflow_state_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_state_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_state_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 327
-- Name: workflow_state_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_state_permissions_id_seq OWNED BY public.workflow_state_permissions.id;


--
-- TOC entry 328 (class 1259 OID 122971)
-- Name: workflow_status_transitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_status_transitions (
    id bigint NOT NULL,
    action character varying(255),
    created_at timestamp without time zone,
    created_by character varying(255),
    note_required boolean,
    updated_at timestamp without time zone,
    updated_by character varying(255),
    from_state_id bigint,
    role_id bigint,
    to_state_id bigint,
    workflow_id bigint,
    seq_order integer
);


ALTER TABLE public.workflow_status_transitions OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 122977)
-- Name: workflow_status_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_status_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_status_transitions_id_seq OWNER TO postgres;

--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 329
-- Name: workflow_status_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_status_transitions_id_seq OWNED BY public.workflow_status_transitions.id;


--
-- TOC entry 330 (class 1259 OID 122979)
-- Name: workflow_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_statuses_id_seq OWNER TO postgres;

--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 330
-- Name: workflow_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_statuses_id_seq OWNED BY public.workflow_statuses.id;


--
-- TOC entry 331 (class 1259 OID 122981)
-- Name: workflow_transition_model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_transition_model (
    id bigint NOT NULL,
    _from character varying(255),
    _performedby character varying(255),
    _to character varying(255),
    action character varying(255),
    from_state_id bigint,
    role_id bigint,
    to_state_id bigint,
    seq_order integer
);


ALTER TABLE public.workflow_transition_model OWNER TO postgres;

--
-- TOC entry 332 (class 1259 OID 122987)
-- Name: workflows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflows (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    created_by character varying(255),
    description character varying(255),
    name character varying(255),
    object character varying(255),
    updated_at timestamp without time zone,
    updated_by character varying(255),
    granter_id bigint
);


ALTER TABLE public.workflows OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 122993)
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflows_id_seq OWNER TO postgres;

--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 333
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflows_id_seq OWNED BY public.workflows.id;


--
-- TOC entry 3164 (class 2604 OID 122995)
-- Name: app_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_config ALTER COLUMN id SET DEFAULT nextval('public.app_config_id_seq'::regclass);


--
-- TOC entry 3173 (class 2604 OID 122996)
-- Name: doc_kpi_data_document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_kpi_data_document ALTER COLUMN id SET DEFAULT nextval('public.doc_kpi_data_document_id_seq'::regclass);


--
-- TOC entry 3174 (class 2604 OID 122997)
-- Name: document_kpi_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_kpi_notes ALTER COLUMN id SET DEFAULT nextval('public.document_kpi_notes_id_seq'::regclass);


--
-- TOC entry 3176 (class 2604 OID 122998)
-- Name: grant_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_assignments ALTER COLUMN id SET DEFAULT nextval('public.grant_assignments_id_seq'::regclass);


--
-- TOC entry 3177 (class 2604 OID 122999)
-- Name: grant_document_attributes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_document_attributes ALTER COLUMN id SET DEFAULT nextval('public.grant_document_attributes_id_seq'::regclass);


--
-- TOC entry 3178 (class 2604 OID 123000)
-- Name: grant_document_kpi_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_document_kpi_data ALTER COLUMN id SET DEFAULT nextval('public.grant_document_kpi_data_id_seq'::regclass);


--
-- TOC entry 3184 (class 2604 OID 123001)
-- Name: grant_kpis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_kpis ALTER COLUMN id SET DEFAULT nextval('public.grant_kpis_id_seq'::regclass);


--
-- TOC entry 3185 (class 2604 OID 123002)
-- Name: grant_qualitative_kpi_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_qualitative_kpi_data ALTER COLUMN id SET DEFAULT nextval('public.grant_qualitative_kpi_data_id_seq'::regclass);


--
-- TOC entry 3186 (class 2604 OID 123003)
-- Name: grant_quantitative_kpi_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_quantitative_kpi_data ALTER COLUMN id SET DEFAULT nextval('public.grant_quantitative_kpi_data_id_seq'::regclass);


--
-- TOC entry 3187 (class 2604 OID 123004)
-- Name: grant_section_attributes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_section_attributes ALTER COLUMN id SET DEFAULT nextval('public.grant_section_attributes_id_seq'::regclass);


--
-- TOC entry 3188 (class 2604 OID 123005)
-- Name: grant_sections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_sections ALTER COLUMN id SET DEFAULT nextval('public.grant_sections_id_seq'::regclass);


--
-- TOC entry 3192 (class 2604 OID 123006)
-- Name: grant_specific_section_attributes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_specific_section_attributes ALTER COLUMN id SET DEFAULT nextval('public.grant_specific_section_attributes_id_seq'::regclass);


--
-- TOC entry 3193 (class 2604 OID 123007)
-- Name: grant_specific_sections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_specific_sections ALTER COLUMN id SET DEFAULT nextval('public.grant_specific_sections_id_seq'::regclass);


--
-- TOC entry 3196 (class 2604 OID 123008)
-- Name: grant_string_attributes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_string_attributes ALTER COLUMN id SET DEFAULT nextval('public.grant_string_attributes_id_seq'::regclass);


--
-- TOC entry 3207 (class 2604 OID 123009)
-- Name: granter_grant_section_attributes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_section_attributes ALTER COLUMN id SET DEFAULT nextval('public.granter_grant_section_attributes_id_seq'::regclass);


--
-- TOC entry 3208 (class 2604 OID 123010)
-- Name: granter_grant_sections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_sections ALTER COLUMN id SET DEFAULT nextval('public.granter_grant_sections_id_seq'::regclass);


--
-- TOC entry 3211 (class 2604 OID 123011)
-- Name: granter_grant_templates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_templates ALTER COLUMN id SET DEFAULT nextval('public.granter_grant_templates_id_seq'::regclass);


--
-- TOC entry 3205 (class 2604 OID 123012)
-- Name: grants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grants ALTER COLUMN id SET DEFAULT nextval('public.grants_id_seq'::regclass);


--
-- TOC entry 3218 (class 2604 OID 123013)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 3220 (class 2604 OID 123014)
-- Name: org_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_config ALTER COLUMN id SET DEFAULT nextval('public.org_config_id_seq'::regclass);


--
-- TOC entry 3197 (class 2604 OID 123015)
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- TOC entry 3224 (class 2604 OID 123016)
-- Name: qual_kpi_data_document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qual_kpi_data_document ALTER COLUMN id SET DEFAULT nextval('public.qual_kpi_data_document_id_seq'::regclass);


--
-- TOC entry 3225 (class 2604 OID 123017)
-- Name: qualitative_kpi_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualitative_kpi_notes ALTER COLUMN id SET DEFAULT nextval('public.qualitative_kpi_notes_id_seq'::regclass);


--
-- TOC entry 3226 (class 2604 OID 123018)
-- Name: quant_kpi_data_document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quant_kpi_data_document ALTER COLUMN id SET DEFAULT nextval('public.quant_kpi_data_document_id_seq'::regclass);


--
-- TOC entry 3227 (class 2604 OID 123019)
-- Name: quantitative_kpi_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantitative_kpi_notes ALTER COLUMN id SET DEFAULT nextval('public.quantitative_kpi_notes_id_seq'::regclass);


--
-- TOC entry 3243 (class 2604 OID 123020)
-- Name: rfps id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rfps ALTER COLUMN id SET DEFAULT nextval('public.rfps_id_seq'::regclass);


--
-- TOC entry 3245 (class 2604 OID 123021)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3246 (class 2604 OID 123022)
-- Name: roles_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_permission ALTER COLUMN id SET DEFAULT nextval('public.roles_permission_id_seq'::regclass);


--
-- TOC entry 3247 (class 2604 OID 123023)
-- Name: submission_note id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission_note ALTER COLUMN id SET DEFAULT nextval('public.submission_note_id_seq'::regclass);


--
-- TOC entry 3248 (class 2604 OID 123024)
-- Name: submissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submissions ALTER COLUMN id SET DEFAULT nextval('public.submissions_id_seq'::regclass);


--
-- TOC entry 3249 (class 2604 OID 123025)
-- Name: template_library id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template_library ALTER COLUMN id SET DEFAULT nextval('public.template_library_id_seq'::regclass);


--
-- TOC entry 3250 (class 2604 OID 123026)
-- Name: templates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates ALTER COLUMN id SET DEFAULT nextval('public.templates_id_seq'::regclass);


--
-- TOC entry 3251 (class 2604 OID 123027)
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- TOC entry 3201 (class 2604 OID 123028)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3252 (class 2604 OID 123029)
-- Name: workflow_state_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_state_permissions ALTER COLUMN id SET DEFAULT nextval('public.workflow_state_permissions_id_seq'::regclass);


--
-- TOC entry 3253 (class 2604 OID 123030)
-- Name: workflow_status_transitions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_status_transitions ALTER COLUMN id SET DEFAULT nextval('public.workflow_status_transitions_id_seq'::regclass);


--
-- TOC entry 3206 (class 2604 OID 123031)
-- Name: workflow_statuses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_statuses ALTER COLUMN id SET DEFAULT nextval('public.workflow_statuses_id_seq'::regclass);


--
-- TOC entry 3254 (class 2604 OID 123032)
-- Name: workflows id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows ALTER COLUMN id SET DEFAULT nextval('public.workflows_id_seq'::regclass);


--
-- TOC entry 3587 (class 0 OID 122433)
-- Dependencies: 197
-- Data for Name: actual_disbursements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actual_disbursements (id, disbursement_date, actual_amount, note, disbursement_id, created_at, created_by, updated_at, updated_by, other_sources, order_position, status, saved) FROM stdin;
\.


--
-- TOC entry 3588 (class 0 OID 122442)
-- Dependencies: 198
-- Data for Name: app_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_config (id, config_name, config_value, description, configurable, key, type) FROM stdin;
1	KPI_REMINDER_NOTIFICATION_DAYS	30	\N	f	\N	\N
2	KPI_SUBMISSION_WINDOW_DAYS	20	\N	f	\N	\N
3	SUBMISSION_ALTER_MAIL_SUBJECT	Submission Alert	\N	f	\N	\N
4	SUBMISSION_ALTER_MAIL_CONTENT	Submission for %SUBMISSION_TITLE% has been recently updated to %SUBMISSION_STATUS%. Your action is required.	\N	f	\N	\N
5	GRANT_ALERT_NOTIFICATION_MESSAGE	Grant %GRANT_NAME% is %GRANT_STATUS%	\N	f	\N	\N
6	GRANT_STATE_CHANGED_MAIL_MESSAGE	<p style="color: #000;">You have received an automated workflow alert for %TENANT%. Click on <a class="go-to-grant-class" href="%GRANT_LINK%">%GRANT_NAME%</a> to review.</p> <p>Gant workflow status changed for <strong>%GRANTEE%</strong></p> <hr /> <p style="color: #000;"><strong>Change Summary: </strong></p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Name of the Grant:</p> </td> <td><span style="font-size: 14px; color: #000; font-weight: bold;">%GRANT_NAME%</span></td> </tr> <tr> <td> <p style="font-size: 11px; color: #000; margin: 0;">Current State:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_STATE%</span></td> </tr> <tr> <td> <p style="font-size: 11px; color: #000; margin: 0;">State Owner:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_OWNER%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Previous State:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_STATE%</span></td> </tr> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Previous State Owner:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_OWNER%</span></td> </tr> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Previous Action:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_ACTION%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Changes from the previous state to the current state:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_CHANGES%. %HAS_CHANGES_COMMENT%</span></td> </tr> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Notes attached to state change:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_NOTES%. %HAS_NOTES_COMMENT%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <p>This is an automatically generated email. Please do not reply to this message.</p>	\N	f	\N	\N
20	GRANT_STATE_CHANGED_NOTIFICATION_SUBJECT	Workflow Alert | Status of %GRANT_NAME% has changed.	\N	f	\N	\N
9	REPORT_DUE_DATE_INTERVAL	15	Days after end date	f	\N	\N
10	REPORT_SETUP_INTERVAL	30	Days before end date when report needs to be setup	f	\N	\N
11	REPORT_PERIOD_INTERVAL	30	Calculated start date of report	f	\N	\N
14	GRANT_INVITE_SUBJECT	Invitation to Grant: %GRANT_NAME% 	\N	f	\N	\N
21	GRANT_STATE_CHANGED_NOTIFICATION_MESSAGE	<p style="color: #000;">Gant workflow status changed for&nbsp;<strong>%GRANTEE%</strong></p> <p style="color: #000;"><strong>Change Summary: </strong></p> <hr /> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Name of the Grant:</p> </td> <td><span style="font-size: 14px; color: #000; font-weight: bold;">%GRANT_NAME%</span></td> </tr> <tr> <td> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Current State:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_STATE%</span></td> </tr> <tr> <td> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">State Owner:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_OWNER%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Previous State:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_STATE%</span></td> </tr> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Previous State Owner:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_OWNER%</span></td> </tr> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Previous Action:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_ACTION%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Changes from the previous state to the current state:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_CHANGES%. %HAS_CHANGES_COMMENT%</span></td> </tr> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Notes attached to state change:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_NOTES%. %HAS_NOTES_COMMENT%</span></td> </tr> </tbody> </table>	\N	f	\N	\N
15	GRANT_INVITE_MESSAGE	<p>You have been invited to view access Grant: %GRANT_NAME% from %TENANT_NAME%.</p> <p>Please sign up to register to Anudan and/or sign in to view the grant by clicking on the link below. </p> <p>%LINK%</p>	\N	f	\N	\N
22	REPORT_STATE_CHANGED_NOTIFICATION_SUBJECT	Workflow Alert | Status of %REPORT_NAME% has changed.	\N	f	\N	\N
7	GRANT_STATE_CHANGED_MAIL_SUBJECT	Alert | Workflow Status of %GRANT_NAME% has changed.	\N	f	\N	\N
23	REPORT_STATE_CHANGED_NOTIFICATION_MESSAGE	<p style="color: #000;">Report workflow status changed for&nbsp;<strong>%GRANTEE%</strong></p> <p style="color: #000;"><strong>Change Summary: </strong></p> <hr /> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Name of the Report:</p> </td> <td><span style="font-size: 14px; color: #000; font-weight: bold;">%REPORT_NAME% <span style="font-size: 14px; color: #000; font-weight: normal;">for Grant "%GRANT_NAME%"</span> </span></td> </tr> <tr> <td> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Current State:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_STATE%</span></td> </tr> <tr> <td> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">State Owner:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_OWNER%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Previous State:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_STATE%</span></td> </tr> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Previous State Owner:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_OWNER%</span></td> </tr> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Previous Action:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_ACTION%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Changes from the previous state to the current state:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_CHANGES%. %HAS_CHANGES_COMMENT%</span></td> </tr> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Notes attached to state change:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_NOTES%. %HAS_NOTES_COMMENT%</span></td> </tr> </tbody> </table>	\N	f	\N	\N
16	REPORT_INVITE_SUBJECT	Invitation to Report: %REPORT_NAME% for Grant: %GRANT_NAME% 	\N	f	\N	\N
17	REPORT_INVITE_MESSAGE	<p>You have been invited to access Report: %REPORT_NAME% for Grant: %GRANT_NAME% from %TENANT_NAME%.</p> <p>Please sign up to register to Anudan and/or sign in to view the report by clicking on the link below.</p> <p>%LINK%</p>	\N	f	\N	\N
13	REPORT_STATE_CHANGED_MAIL_SUBJECT	Alert | Workflow Status of %REPORT_NAME% has changed.	\N	f	\N	\N
18	INVITE_SUBJECT	Invitation to join %ORG_NAME%	\N	f	\N	\N
19	INVITE_MESSAGE	<p>You have been invited to join %ORG_NAME% as %ROLE_NAME%. This invite has been sent on behalf of %INVITE_FROM%</p> <p>Please complete your registration by clicking on the link below</p> <p>%LINK%</p>	\N	f	\N	\N
12	REPORT_STATE_CHANGED_MAIL_MESSAGE	<p style="color: #000;">You have received an automated workflow alert for %TENANT%. Click the appropriate link below to&nbsp;review.</p> <p style="color: #000;">%GRANTEE% user: <a class="go-to-report-class" href="%GRANTEE_REPORT_LINK%">Click here</a></p> <p style="color: #000;">%GRANTER% user:&nbsp;<a class="go-to-report-class" href="%GRANTER_REPORT_LINK%">Click here</a></p> <p style="color: #000;">&nbsp;</p> <p>Report workflow status changed for <strong>%GRANTEE%</strong></p> <hr /> <p style="color: #000;"><strong>Change Summary:</strong></p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Name of the Report:</p> </td> <td><span style="font-size: 14px; color: #000; font-weight: bold;">%REPORT_NAME% <span style="font-size: 14px; color: #000; font-weight: normal;">for Grant "%GRANT_NAME%"</span> </span></td> </tr> <tr> <td> <p style="font-size: 11px; color: #000; margin: 0;">Current State:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_STATE%</span></td> </tr> <tr> <td> <p style="font-size: 11px; color: #000; margin: 0;">State Owner:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_OWNER%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Previous State:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_STATE%</span></td> </tr> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Previous State Owner:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_OWNER%</span></td> </tr> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Previous Action:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_ACTION%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Changes from the previous state to the current state:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_CHANGES%. %HAS_CHANGES_COMMENT%</span></td> </tr> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Notes attached to state change:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_NOTES%. %HAS_NOTES_COMMENT%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <p>This is an automatically generated email. Please do not reply to this message.</p>	\N	f	\N	\N
32	DISBURSEMENT_STATE_CHANGED_NOTIFICATION_SUBJECT	Workflow Alert | Status of Approval Request for %GRANT_NAME% has changed.	\N	f	\N	\N
31	DISBURSEMENT_STATE_CHANGED_NOTIFICATION_MESSAGE	<p style="color: #000;">Disbursement Approval Request workflow status changed for&nbsp;<strong>%GRANTEE%</strong></p> <p style="color: #000;"><strong>Change Summary: </strong></p> <hr /> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Approval Request for:</p> </td> <td><span style="font-size: 14px; color: #000; font-weight: bold;"><span style="font-size: 14px; color: #000; font-weight: normal;">"%GRANT_NAME%"</span> </span></td> </tr> <tr> <td> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Current State:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_STATE%</span></td> </tr> <tr> <td> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">State Owner:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_OWNER%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Previous State:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_STATE%</span></td> </tr> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Previous State Owner:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_OWNER%</span></td> </tr> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Previous Action:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_ACTION%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Changes from the previous state to the current state:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_CHANGES%. %HAS_CHANGES_COMMENT%</span></td> </tr> <tr> <td width="25%"> <p class="m-0" style="font-size: 11px; color: #000; margin: 0;">Notes attached to state change:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_NOTES%. %HAS_NOTES_COMMENT%</span></td> </tr> </tbody> </table>	\N	f	\N	\N
26	GENERATE_GRANT_REFERENCE	true	\N	f	\N	\N
28	FORGOT_PASSWORD_MAIL_SUBJECT	Password Reset Request | Anudan	\N	f	\N	\N
27	FORGOT_PASSWORD_MAIL_MESSAGE	<p>Hi %USER_NAME%</p> <p>We have received a request to reset your password for %ORGANIZATION% on Anudan.</p> <p>Please click the link below to reset your password.</p> <p>%RESET_LINK%</p> <p><span style="text-decoration: underline;">Note</span>: <em>This link will work only once and cannot be reused.</em></p>	\N	f	\N	\N
8	PLATFORM_EMAIL_FOOTER	<hr /> <p style="text-align: center; color: #000;"><strong>Anudan &ndash; A simple Grant Management tool.</strong> </p> <p style="text-align: center; color: #000;font-size:12px;"><em>%RELEASE_VERSION%</em></p> <p style="text-align: center; color: #000;">&copy; 2020 Foundation for Innovation and Social Entrepreneurship. All rights reserved.</p> <p style="text-align: center; color: #000;">Social Alpha | India | <a href="https://www.socialalpha.org">www.socialalpha.org</a></p> <hr /> <span style="color: #808080;"><em>The content of this message is confidential. If you have received it by mistake, please inform us by writing to admin@anudan.org and then delete the message. It is forbidden to copy, forward, or in any way reveal the contents of this message to anyone. The integrity and security of this email cannot be guaranteed over the Internet. Therefore, the sender will not be held liable for any damage caused by the message.</em></span></p> <hr />	\N	f	\N	\N
29	DISBURSEMENT_STATE_CHANGED_MAIL_SUBJECT	Alert | Workflow Status of Approval Request for %GRANT_NAME% has changed.	\N	f	\N	\N
34	OWNERSHIP_CHANGED_EMAIL_SUBJECT	Alert | Workflow Assignment changes to review state owner(s)	\N	f	\N	\N
33	OWNERSHIP_CHANGED_EMAIL_MESSAGE	<p  style="color: #000;"> The workflow assignments for %ENTITY_TYPE% <b>%ENTITY_NAME%</b> has changed.</p> <p  style="color: #000;">%PREVIOUS_ASSIGNMENTS%</p><p>This is an automatically generated email. Please do not reply to this message.</p>	\N	f	\N	\N
36	OWNERSHIP_CHANGED_NOTIFICATION_SUBJECT	Workflow Assignment Alert: Change of review state owner(s)	\N	f	\N	\N
35	OWNERSHIP_CHANGED_NOTIFICATION_MESSAGE	<p  style="color: #000;"> The workflow assignments for %ENTITY_TYPE% <b>%ENTITY_NAME%</b> has changed.</p> <p  style="color: #000;">%PREVIOUS_ASSIGNMENTS%</p>	\N	f	\N	\N
30	DISBURSEMENT_STATE_CHANGED_MAIL_MESSAGE	<p style="color: #000;">You have received an automated workflow alert for %TENANT%. Click on <a class="go-to-disbursement-class" href="%DISBURSEMENT_LINK%">Approval Request Note for %GRANT_NAME%</a> to review.</p> <p>Disbursement Approval Request workflow status changed for <strong>%GRANTEE%</strong></p> <p style="color: #000;"><strong>Change Summary: </strong></p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Approval Request for:</p> </td> <td><span style="font-size: 14px; color: #000; font-weight: bold;"><span style="font-size: 14px; color: #000; font-weight: normal;">"%GRANT_NAME%"</span> </span></td> </tr> <tr> <td> <p style="font-size: 11px; color: #000; margin: 0;">Current State:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_STATE%</span></td> </tr> <tr> <td> <p style="font-size: 11px; color: #000; margin: 0;">State Owner:</p> </td> <td><span style="font-size: 14px; color: #00b050; font-weight: bold;">%CURRENT_OWNER%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Previous State:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_STATE%</span></td> </tr> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Previous State Owner:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_OWNER%</span></td> </tr> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Previous Action:</p> </td> <td><span style="font-size: 14px; color: #7f7f7f; font-weight: bold;">%PREVIOUS_ACTION%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <table style="border-color: #fafafa;" border="1" width="100%" cellspacing="0" cellpadding="2"> <tbody> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Changes from the previous state to the current state:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_CHANGES%. %HAS_CHANGES_COMMENT%</span></td> </tr> <tr> <td width="25%"> <p style="font-size: 11px; color: #000; margin: 0;">Notes attached to state change:</p> </td> <td width="70%"><span style="font-size: 14px; color: #00b050; font-weight: bold;">%HAS_NOTES%. %HAS_NOTES_COMMENT%</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <p>This is an automatically generated email. Please do not reply to this message.</p>	\N	f	\N	\N
37	DISABLED_USERS_IN_WORKFLOW_EMAIL_TEMPLATE	<p>%ENTITY_TYPE% %ENTITY_NAME% cannot be moved in the workflow because there are disabled users in the workflow assignments.</p> <br> <p>Please carry our reassignment for this&nbsp;%ENTITY_TYPE%</p>	\N	f	\N	\N
24	DUE_REPORTS_REMINDER_SETTINGS	{ "messageDescription": "Description for message", "time": "23:00", "timeDescription": "Description for time", "configuration": { "daysBefore": [ 5, 4, 3, 2 ], "afterNoOfHours": [ 0 ] }, "configurationDescription": "Description for configuration", "sql": "", "subjectDescription": "Description for reminder notification subject", "messageReport": "<p>The report <strong>%REPORT_NAME%</strong>&nbsp;for <strong>%GRANT_NAME%</strong> from <strong>%TENANT%&nbsp;</strong>is due on %DUE_DATE%.</p> <p>Please log on to Anudan to submit the report.</p> <p>In case you have any questions or need clarifications while submitting the report please reach out to <strong>%OWNER_NAME%</strong> at <strong>%OWNER_EMAIL%</strong>.</p> <p><i>Please ignore this reminder if you have already submitted the report.</i></p>", "subjectReport": "Alert | Report Submission Reminder | Action Required" }	<p>Report due reminders<p><br><small>Applicable to unsubmitted reports</small>	t	\N	\N
25	ACTION_DUE_REPORTS_REMINDER_SETTINGS	{"messageReport":"<p>The Report approval workflow for <b>%REPORT_NAME%</b> for <b>%GRANT_NAME%</b> requires your action.</p><p>This has been in your queue for %NO_DAYS% day(s)</p> <p> Please log on to Anudan to progress the workflow. </p><p><i>This is a system generated reminder for %TENANT%. Please ignore this reminder if you have already actioned the workflow.</i></p>","messageGrant":"<p>The Grant workflow for <b>%GRANT_NAME%</b> requires your action.</p><p>This has been in your queue for %NO_DAYS% day(s)</p><p> Please log on to Anudan to progress the workflow. </p><p><i>This is a system generated reminder for %TENANT%. Please ignore this reminder if you have already actioned the workflow.</i></p>","messageDisbursement":"<p>The Disbursement approval workflow for Approval Request for <b>%GRANT_NAME%</b> requires your action.</p><p>This has been in your queue for %NO_DAYS% day(s)</p><p> Please log on to Anudan to progress the workflow. </p><p><i>This is a system generated reminder for %TENANT%. Please ignore this reminder if you have already actioned the workflow.</i></p>","messageDescription":"Description for message","subjectReport":"Alert | Workflow delays | Action required","subjectGrant":"Alert | Workflow delays | Action required","subjectDisbursement":"Alert | Workflow delays | Action required","subjectDescription":"Description for reminder notification subject","time":"05:00","timeDescription":"Description for time","configuration":{"daysBefore":[0],"afterNoOfHours":[5760]},"configurationDescription":"Description for configuration","sql":""}	Workflow delays	t	\N	\N
\.


--
-- TOC entry 3591 (class 0 OID 122453)
-- Dependencies: 201
-- Data for Name: disbursement_assignment_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disbursement_assignment_history (seqid, id, owner, anchor, state_id, disbursement_id, updated_on, assigned_on, updated_by) FROM stdin;
\.


--
-- TOC entry 3593 (class 0 OID 122459)
-- Dependencies: 203
-- Data for Name: disbursement_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disbursement_assignments (id, disbursement_id, owner, anchor, state_id, assigned_on, updated_by) FROM stdin;
\.


--
-- TOC entry 3595 (class 0 OID 122465)
-- Dependencies: 205
-- Data for Name: disbursement_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disbursement_history (seqid, id, requested_amount, reason, requested_on, requested_by, status_id, grant_id, note, note_added, note_added_by, created_at, created_by, updated_at, updated_by, moved_on, grantee_entry, other_sources, report_id) FROM stdin;
\.


--
-- TOC entry 3597 (class 0 OID 122475)
-- Dependencies: 207
-- Data for Name: disbursement_snapshot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disbursement_snapshot (id, assigned_to_id, disbursement_id, status_id, requested_amount, reason, from_state_id, from_note, moved_by, from_string_attributes, to_state_id, moved_on) FROM stdin;
\.


--
-- TOC entry 3599 (class 0 OID 122484)
-- Dependencies: 209
-- Data for Name: disbursements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disbursements (id, requested_amount, reason, requested_on, requested_by, status_id, grant_id, note, note_added, note_added_by, created_at, created_by, updated_at, updated_by, moved_on, grantee_entry, other_sources, report_id, disabled_by_amendment) FROM stdin;
\.


--
-- TOC entry 3600 (class 0 OID 122493)
-- Dependencies: 210
-- Data for Name: doc_kpi_data_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doc_kpi_data_document (id, file_name, file_type, version, doc_kpi_data_id) FROM stdin;
\.


--
-- TOC entry 3602 (class 0 OID 122501)
-- Dependencies: 212
-- Data for Name: document_kpi_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_kpi_notes (id, message, posted_on, kpi_data_id, posted_by_id) FROM stdin;
\.


--
-- TOC entry 3605 (class 0 OID 122508)
-- Dependencies: 215
-- Data for Name: grant_assignment_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_assignment_history (seqid, id, assignments, state_id, grant_id, updated_on, assigned_on, updated_by) FROM stdin;
1	971	55	12	199	2020-07-03 13:56:04.818802	2020-07-03 13:55:00	28
2	971	29	12	199	2020-07-03 13:57:37.222026	2020-07-03 13:56:00	28
3	630	26	22	130	2020-07-03 14:22:34.980462	\N	\N
4	630	28	22	130	2020-07-03 14:23:13.724326	2020-07-03 14:22:00	28
5	994	40	15	203	2020-07-09 00:19:15.196987	2020-07-06 18:02:00	40
6	994	55	15	203	2020-07-09 00:19:38.724516	2020-07-09 00:19:00	40
7	1011	51	12	207	2020-07-12 21:10:15.517381	2020-07-10 14:28:00	28
8	1012	38	22	207	2020-07-12 21:10:15.522308	2020-07-10 14:28:00	28
9	1013	30	14	207	2020-07-12 21:10:15.526374	2020-07-10 14:28:00	28
10	1027	38	22	210	2020-07-15 12:22:51.927242	2020-07-15 12:22:00	40
11	1028	30	14	210	2020-07-15 12:24:15.876646	2020-07-15 12:22:00	40
12	1050	53	11	215	2020-07-17 10:05:17.900717	\N	\N
13	1031	85	12	211	2020-07-17 14:15:25.319086	2020-07-15 12:41:00	40
14	1032	83	22	211	2020-07-17 14:15:25.322613	2020-07-15 12:41:00	40
15	1033	84	14	211	2020-07-17 14:15:25.3255	2020-07-15 12:41:00	40
16	1034	82	15	211	2020-07-17 14:15:25.331078	2020-07-15 12:41:00	40
17	793	55	11	163	2020-07-31 11:32:16.620368	\N	\N
18	794	55	12	163	2020-07-31 11:32:16.636384	\N	\N
19	795	55	22	163	2020-07-31 11:32:16.646082	\N	\N
20	796	55	14	163	2020-07-31 11:32:16.654792	\N	\N
21	797	55	15	163	2020-07-31 11:32:16.669936	\N	\N
22	630	26	22	130	2020-08-05 07:39:39.829586	2020-07-03 14:23:00	28
23	1251	104	12	255	2020-08-21 10:04:34.846095	2020-08-17 21:08:00	103
24	1256	104	12	256	2020-08-21 10:18:23.284375	2020-08-17 21:09:00	103
25	1257	105	22	256	2020-08-21 10:18:23.288619	2020-08-17 21:09:00	103
26	1258	106	14	256	2020-08-21 10:18:23.292989	2020-08-17 21:09:00	103
27	1251	28	12	255	2020-08-21 11:08:36.819702	2020-08-21 10:04:00	103
28	1256	28	12	256	2020-08-21 11:10:10.510581	2020-08-21 10:18:00	103
29	1257	103	22	256	2020-08-21 11:10:10.513898	2020-08-21 10:18:00	103
30	1258	28	14	256	2020-08-21 11:10:10.517055	2020-08-21 10:18:00	103
31	1339	102	15	272	2020-08-25 14:56:36.960727	2020-08-25 00:09:00	107
32	1324	102	15	269	2020-08-25 14:58:33.488702	2020-08-24 23:57:00	107
33	1329	102	15	270	2020-08-25 14:59:29.111315	2020-08-25 00:01:00	107
34	1334	102	15	271	2020-08-25 15:00:26.433408	2020-08-25 00:04:00	107
35	1319	102	15	268	2020-08-25 15:01:24.060931	2020-08-24 23:50:00	107
36	1373	106	14	279	2020-08-31 16:30:47.136148	2020-08-31 16:29:00	103
37	1436	117	12	292	2020-09-14 15:05:24.65357	2020-09-14 13:30:00	116
38	1481	117	12	301	2020-09-14 15:49:43.062821	2020-09-08 11:55:00	116
39	1551	101	12	315	2020-09-22 20:42:43.405067	2020-09-15 15:20:00	122
40	1554	101	15	315	2020-09-22 20:45:30.869935	2020-09-22 20:42:00	122
41	1496	101	12	304	2020-09-22 20:46:27.65584	2020-09-15 15:13:00	122
42	1499	122	15	304	2020-12-04 10:25:08.448792	2020-09-22 20:46:00	102
43	1697	109	22	344	2020-12-16 10:19:25.172911	2020-11-09 14:57:00	123
44	1850	117	11	375	2021-01-05 16:24:55.827392	\N	117
45	1850	120	11	375	2021-01-05 16:33:51.88368	2021-01-05 16:24:00	120
\.


--
-- TOC entry 3606 (class 0 OID 122512)
-- Dependencies: 216
-- Data for Name: grant_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_assignments (id, anchor, assignments, grant_id, state_id, assigned_on, updated_by) FROM stdin;
1	f	14	1	2	\N	\N
2	f	2	1	3	\N	\N
3	t	5	1	1	\N	\N
4	f	\N	1	4	\N	\N
5	f	\N	1	2	\N	\N
6	f	\N	1	3	\N	\N
7	t	4	2	1	\N	\N
8	f	\N	2	4	\N	\N
9	f	\N	2	2	\N	\N
10	f	\N	2	3	\N	\N
11	t	5	3	1	\N	\N
12	f	\N	3	4	\N	\N
13	f	\N	3	2	\N	\N
14	f	\N	3	3	\N	\N
15	t	5	4	1	\N	\N
16	f	\N	4	4	\N	\N
17	f	\N	4	2	\N	\N
18	f	\N	4	3	\N	\N
19	t	5	5	1	\N	\N
20	f	\N	5	4	\N	\N
21	f	\N	5	2	\N	\N
22	f	\N	5	3	\N	\N
23	t	5	6	1	\N	\N
24	f	\N	6	4	\N	\N
25	f	\N	6	2	\N	\N
26	f	\N	6	3	\N	\N
27	t	5	7	1	\N	\N
28	f	\N	7	4	\N	\N
29	f	\N	7	2	\N	\N
30	f	\N	7	3	\N	\N
31	t	5	8	1	\N	\N
32	f	\N	8	4	\N	\N
33	f	\N	8	2	\N	\N
34	f	\N	8	3	\N	\N
35	t	4	9	1	\N	\N
36	f	\N	9	4	\N	\N
37	f	\N	9	2	\N	\N
38	f	\N	9	3	\N	\N
39	t	5	10	1	\N	\N
40	f	\N	10	4	\N	\N
41	f	\N	10	2	\N	\N
42	f	\N	10	3	\N	\N
43	t	17	11	1	\N	\N
44	f	\N	11	4	\N	\N
45	f	\N	11	2	\N	\N
46	f	\N	11	3	\N	\N
47	t	15	12	1	\N	\N
51	t	16	13	1	\N	\N
52	f	\N	13	4	\N	\N
53	f	\N	13	2	\N	\N
54	f	\N	13	3	\N	\N
55	t	17	14	1	\N	\N
56	f	\N	14	4	\N	\N
57	f	\N	14	2	\N	\N
58	f	\N	14	3	\N	\N
59	t	5	15	1	\N	\N
60	f	\N	15	4	\N	\N
61	f	\N	15	2	\N	\N
62	f	\N	15	3	\N	\N
63	t	15	16	1	\N	\N
64	f	\N	16	4	\N	\N
65	f	\N	16	2	\N	\N
66	f	\N	16	3	\N	\N
67	t	5	17	1	\N	\N
68	f	\N	17	4	\N	\N
69	f	\N	17	2	\N	\N
70	f	\N	17	3	\N	\N
71	t	5	18	1	\N	\N
72	f	\N	18	4	\N	\N
73	f	\N	18	2	\N	\N
74	f	\N	18	3	\N	\N
75	t	17	19	1	\N	\N
76	f	\N	19	4	\N	\N
77	f	\N	19	2	\N	\N
78	f	\N	19	3	\N	\N
79	t	5	20	1	\N	\N
80	f	\N	20	4	\N	\N
81	f	\N	20	2	\N	\N
82	f	\N	20	3	\N	\N
83	t	16	21	1	\N	\N
84	f	\N	21	4	\N	\N
85	f	\N	21	2	\N	\N
86	f	\N	21	3	\N	\N
87	t	16	22	1	\N	\N
88	f	\N	22	4	\N	\N
89	f	\N	22	2	\N	\N
90	f	\N	22	3	\N	\N
91	t	15	23	1	\N	\N
92	f	\N	23	4	\N	\N
93	f	\N	23	2	\N	\N
94	f	\N	23	3	\N	\N
95	t	5	24	1	\N	\N
96	f	\N	24	4	\N	\N
97	f	\N	24	2	\N	\N
98	f	\N	24	3	\N	\N
99	t	5	25	1	\N	\N
49	f	12	12	2	\N	\N
50	f	9	12	3	\N	\N
48	f	15	12	4	\N	\N
101	f	14	25	2	\N	\N
102	f	2	25	3	\N	\N
100	f	5	25	4	\N	\N
103	t	5	26	1	\N	\N
104	f	\N	26	4	\N	\N
105	f	\N	26	2	\N	\N
106	f	\N	26	3	\N	\N
107	t	17	27	1	\N	\N
111	t	16	28	1	\N	\N
112	f	\N	28	4	\N	\N
113	f	\N	28	2	\N	\N
114	f	\N	28	3	\N	\N
115	t	16	29	1	\N	\N
109	f	12	27	2	\N	\N
110	f	9	27	3	\N	\N
108	f	17	27	4	\N	\N
117	f	12	29	2	\N	\N
118	f	9	29	3	\N	\N
116	f	16	29	4	\N	\N
120	t	5	30	1	\N	\N
121	f	14	30	2	\N	\N
122	f	2	30	3	\N	\N
119	f	5	30	4	\N	\N
123	f	\N	31	4	\N	\N
124	t	5	31	1	\N	\N
125	f	\N	31	2	\N	\N
126	f	\N	31	3	\N	\N
127	f	\N	32	4	\N	\N
128	t	5	32	1	\N	\N
129	f	\N	32	2	\N	\N
130	f	\N	32	3	\N	\N
131	f	\N	33	4	\N	\N
132	t	5	33	1	\N	\N
133	f	\N	33	2	\N	\N
134	f	\N	33	3	\N	\N
136	t	5	34	1	\N	\N
137	f	5	34	2	\N	\N
138	f	5	34	3	\N	\N
135	f	5	34	4	\N	\N
139	t	29	35	11	\N	\N
140	f	\N	35	12	\N	\N
141	f	\N	35	13	\N	\N
142	f	\N	35	14	\N	\N
143	f	\N	35	15	\N	\N
144	t	29	36	11	\N	\N
145	f	\N	36	12	\N	\N
146	f	\N	36	13	\N	\N
147	f	\N	36	14	\N	\N
148	f	\N	36	15	\N	\N
149	t	29	37	11	\N	\N
150	f	27	37	12	\N	\N
151	f	26	37	13	\N	\N
152	f	28	37	14	\N	\N
153	f	29	37	15	\N	\N
154	t	29	38	11	\N	\N
159	t	28	39	11	\N	\N
160	f	27	39	12	\N	\N
161	f	26	39	13	\N	\N
162	f	28	39	14	\N	\N
163	f	29	39	15	\N	\N
165	t	5	40	1	\N	\N
166	f	2	40	2	\N	\N
167	f	14	40	3	\N	\N
164	f	15	40	4	\N	\N
168	t	29	41	11	\N	\N
169	f	27	41	12	\N	\N
170	f	26	41	13	\N	\N
171	f	28	41	14	\N	\N
172	f	31	41	15	\N	\N
173	t	29	42	11	\N	\N
178	t	39	43	11	\N	\N
179	f	\N	43	12	\N	\N
180	f	\N	43	13	\N	\N
181	f	\N	43	14	\N	\N
182	f	\N	43	15	\N	\N
183	t	32	44	11	\N	\N
184	f	\N	44	12	\N	\N
185	f	\N	44	13	\N	\N
186	f	\N	44	14	\N	\N
187	f	\N	44	15	\N	\N
188	t	39	45	11	\N	\N
193	t	39	46	11	\N	\N
194	f	32	46	12	\N	\N
195	f	36	46	13	\N	\N
196	f	32	46	14	\N	\N
197	f	39	46	15	\N	\N
198	t	32	47	11	\N	\N
189	f	32	45	12	\N	\N
190	f	36	45	13	\N	\N
191	f	32	45	14	\N	\N
192	f	39	45	15	\N	\N
199	f	39	47	12	\N	\N
200	f	36	47	13	\N	\N
201	f	32	47	14	\N	\N
202	f	32	47	15	\N	\N
203	t	39	48	11	\N	\N
204	f	\N	48	12	\N	\N
205	f	\N	48	13	\N	\N
206	f	\N	48	14	\N	\N
207	f	\N	48	15	\N	\N
208	t	32	49	11	\N	\N
209	f	\N	49	12	\N	\N
210	f	\N	49	13	\N	\N
211	f	\N	49	14	\N	\N
212	f	\N	49	15	\N	\N
213	t	39	50	11	\N	\N
214	f	32	50	12	\N	\N
228	t	31	53	11	\N	\N
229	f	\N	53	12	\N	\N
217	f	39	50	15	\N	\N
230	f	\N	53	13	\N	\N
231	f	\N	53	14	\N	\N
232	f	\N	53	15	\N	\N
216	f	28	50	14	\N	\N
215	f	37	50	13	\N	\N
218	t	31	51	11	\N	\N
221	f	40	51	14	\N	\N
220	f	32	51	13	\N	\N
222	f	31	51	15	\N	\N
223	t	32	52	11	\N	\N
224	f	\N	52	12	\N	\N
225	f	\N	52	13	\N	\N
226	f	\N	52	14	\N	\N
227	f	\N	52	15	\N	\N
233	t	32	54	11	\N	\N
234	f	\N	54	12	\N	\N
235	f	\N	54	13	\N	\N
236	f	\N	54	14	\N	\N
237	f	\N	54	15	\N	\N
238	t	28	55	11	\N	\N
239	f	\N	55	12	\N	\N
240	f	\N	55	13	\N	\N
241	f	\N	55	14	\N	\N
242	f	\N	55	15	\N	\N
243	t	40	56	11	\N	\N
247	f	40	56	15	\N	\N
245	f	32	56	13	\N	\N
219	f	33	51	12	\N	\N
248	t	31	57	11	\N	\N
244	f	40	56	12	\N	\N
175	f	29	42	13	\N	\N
177	f	29	42	15	\N	\N
249	f	40	57	12	\N	\N
250	f	26	57	13	\N	\N
251	f	33	57	14	\N	\N
252	f	31	57	15	\N	\N
156	f	26	38	13	\N	\N
157	f	28	38	14	\N	\N
158	f	29	38	15	\N	\N
246	f	28	56	14	\N	\N
174	f	29	42	12	\N	\N
176	f	29	42	14	\N	\N
253	t	31	58	11	\N	\N
254	f	\N	58	12	\N	\N
255	f	\N	58	13	\N	\N
256	f	\N	58	14	\N	\N
257	f	\N	58	15	\N	\N
155	f	27	38	12	\N	\N
258	t	29	59	11	\N	\N
259	f	27	59	12	\N	\N
260	f	26	59	13	\N	\N
261	f	28	59	14	\N	\N
262	f	29	59	15	\N	\N
263	t	29	60	11	\N	\N
268	t	28	61	11	\N	\N
273	t	32	62	11	\N	\N
274	f	\N	62	12	\N	\N
275	f	\N	62	13	\N	\N
276	f	\N	62	14	\N	\N
277	f	\N	62	15	\N	\N
278	t	28	63	11	\N	\N
279	f	\N	63	12	\N	\N
280	f	\N	63	13	\N	\N
281	f	\N	63	14	\N	\N
282	f	\N	63	15	\N	\N
283	t	31	64	11	\N	\N
288	t	31	65	11	\N	\N
289	f	\N	65	12	\N	\N
290	f	\N	65	13	\N	\N
291	f	\N	65	14	\N	\N
292	f	\N	65	15	\N	\N
294	t	5	66	1	\N	\N
297	t	31	67	11	\N	\N
298	f	\N	67	12	\N	\N
299	f	\N	67	13	\N	\N
300	f	\N	67	14	\N	\N
301	f	\N	67	15	\N	\N
302	t	39	68	11	\N	\N
303	f	\N	68	12	\N	\N
304	f	\N	68	13	\N	\N
305	f	\N	68	14	\N	\N
306	f	\N	68	15	\N	\N
295	f	5	66	2	\N	\N
296	f	5	66	3	\N	\N
293	f	5	66	4	\N	\N
308	t	5	69	1	\N	\N
309	f	5	69	2	\N	\N
310	f	5	69	3	\N	\N
307	f	5	69	4	\N	\N
312	t	5	70	1	\N	\N
313	f	5	70	2	\N	\N
314	f	5	70	3	\N	\N
311	f	5	70	4	\N	\N
264	f	29	60	12	\N	\N
265	f	29	60	13	\N	\N
266	f	29	60	14	\N	\N
334	f	29	74	12	\N	\N
267	f	29	60	15	\N	\N
315	t	29	71	11	\N	\N
316	f	29	71	12	\N	\N
317	f	29	71	13	\N	\N
320	f	29	71	21	\N	\N
318	f	29	71	14	\N	\N
321	f	29	71	22	\N	\N
319	f	29	71	15	\N	\N
322	t	28	72	11	\N	\N
323	f	\N	72	12	\N	\N
324	f	\N	72	13	\N	\N
325	f	\N	72	14	\N	\N
326	f	\N	72	15	\N	\N
327	f	\N	72	21	\N	\N
328	f	\N	72	22	\N	\N
330	t	5	73	1	\N	\N
331	f	5	73	2	\N	\N
332	f	5	73	3	\N	\N
329	f	5	73	4	\N	\N
333	t	29	74	11	\N	\N
335	f	29	74	13	\N	\N
338	f	29	74	21	\N	\N
336	f	29	74	14	\N	\N
339	f	29	74	22	\N	\N
337	f	29	74	15	\N	\N
269	f	28	61	12	\N	\N
270	f	28	61	13	\N	\N
340	f	28	61	21	\N	\N
271	f	28	61	14	\N	\N
341	f	28	61	22	\N	\N
272	f	28	61	15	\N	\N
342	t	29	75	11	\N	\N
347	f	29	75	12	\N	\N
345	f	29	75	13	\N	\N
343	f	29	75	21	\N	\N
346	f	29	75	14	\N	\N
344	f	29	75	22	\N	\N
348	f	29	75	15	\N	\N
349	t	28	76	11	\N	\N
356	t	28	77	11	\N	\N
357	f	\N	77	21	\N	\N
358	f	\N	77	22	\N	\N
359	f	\N	77	13	\N	\N
360	f	\N	77	14	\N	\N
361	f	\N	77	12	\N	\N
362	f	\N	77	15	\N	\N
363	t	39	78	11	\N	\N
364	f	\N	78	21	\N	\N
365	f	\N	78	22	\N	\N
366	f	\N	78	13	\N	\N
367	f	\N	78	14	\N	\N
368	f	\N	78	12	\N	\N
369	f	\N	78	15	\N	\N
370	t	5	79	1	\N	\N
371	f	\N	79	2	\N	\N
372	f	\N	79	3	\N	\N
373	f	\N	79	4	\N	\N
350	f	28	76	21	\N	\N
353	f	28	76	14	\N	\N
351	f	28	76	22	\N	\N
355	f	28	76	15	\N	\N
287	f	31	64	15	\N	\N
284	f	33	64	12	\N	\N
286	f	40	64	14	\N	\N
354	f	28	76	12	\N	\N
352	f	28	76	13	\N	\N
285	f	40	64	13	\N	\N
374	f	32	64	21	\N	\N
375	f	32	64	22	\N	\N
376	t	28	80	11	\N	\N
377	f	\N	80	21	\N	\N
379	f	\N	80	13	\N	\N
381	f	28	80	12	\N	\N
378	f	28	80	22	\N	\N
382	f	28	80	14	\N	\N
380	f	28	80	15	\N	\N
383	t	28	81	11	\N	\N
384	f	28	81	12	\N	\N
385	f	28	81	22	\N	\N
386	f	28	81	14	\N	\N
387	f	28	81	15	\N	\N
388	t	28	82	11	\N	\N
389	f	\N	82	12	\N	\N
390	f	\N	82	22	\N	\N
391	f	\N	82	14	\N	\N
392	f	\N	82	15	\N	\N
393	t	46	83	1	\N	\N
394	f	46	83	2	\N	\N
395	f	46	83	3	\N	\N
396	f	46	83	4	\N	\N
397	f	28	39	22	\N	\N
398	t	48	84	11	\N	\N
399	f	\N	84	12	\N	\N
400	f	\N	84	22	\N	\N
401	f	\N	84	14	\N	\N
402	f	\N	84	15	\N	\N
403	t	28	85	11	\N	\N
404	f	\N	85	12	\N	\N
405	f	\N	85	22	\N	\N
406	f	\N	85	14	\N	\N
407	f	\N	85	15	\N	\N
408	t	28	86	11	\N	\N
413	t	55	87	11	\N	\N
454	f	33	95	12	\N	\N
455	f	38	95	22	\N	\N
493	t	57	103	11	2020-07-07 19:55:00	57
457	f	31	95	15	\N	\N
414	f	55	87	12	\N	\N
415	f	55	87	22	\N	\N
416	f	55	87	14	\N	\N
417	f	55	87	15	\N	\N
409	f	28	86	12	\N	\N
410	f	28	86	22	\N	\N
411	f	28	86	14	\N	\N
412	f	28	86	15	\N	\N
418	t	28	88	11	\N	\N
423	t	40	89	11	\N	\N
424	f	\N	89	12	\N	\N
425	f	\N	89	22	\N	\N
426	f	\N	89	14	\N	\N
427	f	\N	89	15	\N	\N
428	t	48	90	11	\N	\N
429	f	\N	90	12	\N	\N
430	f	\N	90	22	\N	\N
431	f	\N	90	14	\N	\N
432	f	\N	90	15	\N	\N
433	t	32	91	11	\N	\N
434	f	39	91	12	\N	\N
435	f	32	91	22	\N	\N
436	f	39	91	14	\N	\N
437	f	32	91	15	\N	\N
438	t	32	92	11	\N	\N
439	f	\N	92	12	\N	\N
440	f	\N	92	22	\N	\N
441	f	\N	92	14	\N	\N
442	f	\N	92	15	\N	\N
443	t	48	93	11	\N	\N
448	t	29	94	11	\N	\N
449	f	\N	94	12	\N	\N
450	f	\N	94	22	\N	\N
451	f	\N	94	14	\N	\N
452	f	\N	94	15	\N	\N
453	t	31	95	11	\N	\N
458	t	28	96	11	\N	\N
459	f	28	96	12	\N	\N
460	f	28	96	22	\N	\N
461	f	28	96	14	\N	\N
462	f	28	96	15	\N	\N
444	f	51	93	12	\N	\N
465	f	48	97	22	\N	\N
466	f	51	97	14	\N	\N
467	f	57	97	15	\N	\N
445	f	57	93	22	\N	\N
446	f	51	93	14	\N	\N
447	f	48	93	15	\N	\N
463	t	57	97	11	\N	\N
464	f	51	97	12	\N	\N
468	t	54	98	11	\N	\N
469	f	\N	98	12	\N	\N
470	f	\N	98	22	\N	\N
471	f	\N	98	14	\N	\N
472	f	\N	98	15	\N	\N
473	t	57	99	11	\N	\N
474	f	\N	99	12	\N	\N
475	f	\N	99	22	\N	\N
476	f	\N	99	14	\N	\N
477	f	\N	99	15	\N	\N
478	t	57	100	11	\N	\N
479	f	\N	100	12	\N	\N
480	f	\N	100	22	\N	\N
481	f	\N	100	14	\N	\N
482	f	\N	100	15	\N	\N
483	t	57	101	11	\N	\N
484	f	\N	101	12	\N	\N
485	f	\N	101	22	\N	\N
486	f	\N	101	14	\N	\N
487	f	\N	101	15	\N	\N
488	t	57	102	11	\N	\N
489	f	\N	102	12	\N	\N
490	f	\N	102	22	\N	\N
491	f	\N	102	14	\N	\N
492	f	\N	102	15	\N	\N
419	f	28	88	12	\N	\N
421	f	28	88	14	\N	\N
422	f	28	88	15	\N	\N
456	f	40	95	14	\N	\N
498	t	50	104	11	\N	\N
499	f	\N	104	12	\N	\N
500	f	\N	104	22	\N	\N
501	f	\N	104	14	\N	\N
502	f	\N	104	15	\N	\N
503	t	50	105	11	\N	\N
504	f	\N	105	12	\N	\N
505	f	\N	105	22	\N	\N
506	f	\N	105	14	\N	\N
507	f	\N	105	15	\N	\N
508	t	55	106	11	\N	\N
509	f	\N	106	12	\N	\N
510	f	\N	106	22	\N	\N
511	f	\N	106	14	\N	\N
512	f	\N	106	15	\N	\N
513	t	50	107	11	\N	\N
514	f	\N	107	12	\N	\N
515	f	\N	107	22	\N	\N
516	f	\N	107	14	\N	\N
517	f	\N	107	15	\N	\N
518	t	28	108	11	\N	\N
519	f	28	108	12	\N	\N
520	f	28	108	22	\N	\N
521	f	28	108	14	\N	\N
522	f	28	108	15	\N	\N
555	f	38	115	22	\N	\N
497	f	57	103	15	2020-07-07 19:55:00	57
523	t	57	109	11	\N	\N
524	f	\N	109	12	\N	\N
525	f	\N	109	22	\N	\N
526	f	\N	109	14	\N	\N
527	f	\N	109	15	\N	\N
528	t	28	110	11	\N	\N
529	f	28	110	12	\N	\N
530	f	28	110	22	\N	\N
531	f	28	110	14	\N	\N
532	f	28	110	15	\N	\N
533	t	53	111	11	\N	\N
534	f	\N	111	12	\N	\N
535	f	\N	111	22	\N	\N
536	f	\N	111	14	\N	\N
537	f	\N	111	15	\N	\N
420	f	28	88	22	\N	\N
538	t	53	112	11	\N	\N
543	t	52	113	11	\N	\N
548	t	57	114	11	\N	\N
549	f	\N	114	12	\N	\N
550	f	\N	114	22	\N	\N
551	f	\N	114	14	\N	\N
552	f	\N	114	15	\N	\N
589	f	50	122	12	\N	\N
545	f	0	113	22	\N	\N
590	f	0	122	22	\N	\N
547	f	0	113	15	\N	\N
544	f	54	113	12	\N	\N
546	f	30	113	14	\N	\N
553	t	57	115	11	\N	\N
556	f	30	115	14	\N	\N
557	f	57	115	15	\N	\N
494	f	60	103	12	2020-07-07 19:55:00	57
541	f	54	112	14	\N	\N
558	t	28	116	11	\N	\N
559	f	\N	116	12	\N	\N
560	f	\N	116	22	\N	\N
561	f	\N	116	14	\N	\N
562	f	\N	116	15	\N	\N
563	t	40	117	11	\N	\N
564	f	\N	117	12	\N	\N
565	f	\N	117	22	\N	\N
566	f	\N	117	14	\N	\N
567	f	\N	117	15	\N	\N
568	t	40	118	11	\N	\N
569	f	\N	118	12	\N	\N
570	f	\N	118	22	\N	\N
571	f	\N	118	14	\N	\N
572	f	\N	118	15	\N	\N
573	t	40	119	11	\N	\N
574	f	\N	119	12	\N	\N
575	f	\N	119	22	\N	\N
576	f	\N	119	14	\N	\N
577	f	\N	119	15	\N	\N
578	t	40	120	11	\N	\N
579	f	\N	120	12	\N	\N
580	f	\N	120	22	\N	\N
581	f	\N	120	14	\N	\N
582	f	\N	120	15	\N	\N
583	t	40	121	11	\N	\N
588	t	49	122	11	\N	\N
591	f	0	122	14	\N	\N
592	f	0	122	15	\N	\N
539	f	54	112	12	\N	\N
542	f	53	112	15	\N	\N
600	f	49	124	22	\N	\N
540	f	52	112	22	\N	\N
593	t	52	123	11	\N	\N
594	f	\N	123	12	\N	\N
595	f	\N	123	22	\N	\N
596	f	\N	123	14	\N	\N
597	f	\N	123	15	\N	\N
598	t	49	124	11	\N	\N
599	f	50	124	12	\N	\N
603	t	49	125	11	\N	\N
604	f	\N	125	12	\N	\N
605	f	\N	125	22	\N	\N
584	f	33	121	12	\N	\N
608	t	49	126	11	\N	\N
554	f	51	115	12	\N	\N
606	f	\N	125	14	\N	\N
607	f	\N	125	15	\N	\N
601	f	50	124	14	\N	\N
609	f	\N	126	12	\N	\N
610	f	\N	126	22	\N	\N
611	f	\N	126	14	\N	\N
612	f	\N	126	15	\N	\N
613	t	49	127	11	\N	\N
614	f	\N	127	12	\N	\N
615	f	\N	127	22	\N	\N
616	f	\N	127	14	\N	\N
617	f	\N	127	15	\N	\N
618	t	49	128	11	\N	\N
585	f	38	121	22	\N	\N
587	f	40	121	15	\N	\N
495	f	60	103	22	2020-07-07 19:55:00	57
619	f	\N	128	12	\N	\N
620	f	\N	128	22	\N	\N
621	f	\N	128	14	\N	\N
622	f	\N	128	15	\N	\N
623	t	28	129	11	\N	\N
624	f	\N	129	12	\N	\N
625	f	\N	129	22	\N	\N
626	f	\N	129	14	\N	\N
627	f	\N	129	15	\N	\N
632	f	28	130	15	2020-08-05 07:39:00	28
630	f	28	130	22	2020-08-05 07:39:00	28
631	f	27	130	14	2020-08-05 07:39:00	28
633	t	39	131	11	\N	\N
634	f	\N	131	12	\N	\N
635	f	\N	131	22	\N	\N
636	f	\N	131	14	\N	\N
637	f	\N	131	15	\N	\N
638	t	39	132	11	\N	\N
639	f	\N	132	12	\N	\N
640	f	\N	132	22	\N	\N
641	f	\N	132	14	\N	\N
642	f	\N	132	15	\N	\N
643	t	49	133	11	\N	\N
644	f	\N	133	12	\N	\N
645	f	\N	133	22	\N	\N
646	f	\N	133	14	\N	\N
647	f	\N	133	15	\N	\N
648	t	49	134	11	\N	\N
649	f	\N	134	12	\N	\N
650	f	\N	134	22	\N	\N
651	f	\N	134	14	\N	\N
652	f	\N	134	15	\N	\N
653	t	49	135	11	\N	\N
654	f	\N	135	12	\N	\N
655	f	\N	135	22	\N	\N
656	f	\N	135	14	\N	\N
657	f	\N	135	15	\N	\N
658	t	28	136	11	\N	\N
659	f	\N	136	12	\N	\N
660	f	\N	136	22	\N	\N
661	f	\N	136	14	\N	\N
662	f	\N	136	15	\N	\N
663	t	49	137	11	\N	\N
664	f	\N	137	12	\N	\N
665	f	\N	137	22	\N	\N
666	f	\N	137	14	\N	\N
667	f	\N	137	15	\N	\N
668	t	49	138	11	\N	\N
669	f	50	138	12	\N	\N
670	f	50	138	22	\N	\N
671	f	50	138	14	\N	\N
672	f	49	138	15	\N	\N
602	f	49	124	15	\N	\N
673	t	52	139	11	\N	\N
674	f	\N	139	12	\N	\N
675	f	\N	139	22	\N	\N
676	f	\N	139	14	\N	\N
677	f	\N	139	15	\N	\N
678	t	52	140	11	\N	\N
679	f	\N	140	12	\N	\N
680	f	\N	140	22	\N	\N
681	f	\N	140	14	\N	\N
682	f	\N	140	15	\N	\N
683	t	52	141	11	\N	\N
684	f	\N	141	12	\N	\N
685	f	\N	141	22	\N	\N
686	f	\N	141	14	\N	\N
687	f	\N	141	15	\N	\N
688	t	52	142	11	\N	\N
689	f	\N	142	12	\N	\N
690	f	\N	142	22	\N	\N
691	f	\N	142	14	\N	\N
692	f	\N	142	15	\N	\N
693	t	52	143	11	\N	\N
694	f	\N	143	12	\N	\N
695	f	\N	143	22	\N	\N
696	f	\N	143	14	\N	\N
697	f	\N	143	15	\N	\N
698	t	52	144	11	\N	\N
699	f	\N	144	12	\N	\N
700	f	\N	144	22	\N	\N
701	f	\N	144	14	\N	\N
702	f	\N	144	15	\N	\N
703	t	32	145	11	\N	\N
704	f	\N	145	12	\N	\N
705	f	\N	145	22	\N	\N
706	f	\N	145	14	\N	\N
707	f	\N	145	15	\N	\N
708	t	32	146	11	\N	\N
709	f	\N	146	12	\N	\N
710	f	\N	146	22	\N	\N
711	f	\N	146	14	\N	\N
712	f	\N	146	15	\N	\N
713	t	52	147	11	\N	\N
714	f	54	147	12	\N	\N
715	f	32	147	22	\N	\N
716	f	54	147	14	\N	\N
717	f	52	147	15	\N	\N
718	t	15	148	1	\N	\N
719	f	\N	148	2	\N	\N
720	f	\N	148	3	\N	\N
721	f	\N	148	4	\N	\N
722	t	2	149	1	\N	\N
723	f	\N	149	2	\N	\N
724	f	\N	149	3	\N	\N
725	f	\N	149	4	\N	\N
726	t	28	150	11	\N	\N
727	f	\N	150	12	\N	\N
728	f	\N	150	22	\N	\N
729	f	\N	150	14	\N	\N
730	f	\N	150	15	\N	\N
731	t	60	151	11	\N	\N
732	f	\N	151	12	\N	\N
733	f	\N	151	22	\N	\N
734	f	\N	151	14	\N	\N
735	f	\N	151	15	\N	\N
736	t	28	152	11	\N	\N
741	t	60	153	11	\N	\N
742	f	\N	153	12	\N	\N
743	f	\N	153	22	\N	\N
744	f	\N	153	14	\N	\N
745	f	\N	153	15	\N	\N
737	f	28	152	12	\N	\N
738	f	28	152	22	\N	\N
739	f	28	152	14	\N	\N
740	f	28	152	15	\N	\N
746	t	40	154	11	\N	\N
747	f	\N	154	12	\N	\N
748	f	\N	154	22	\N	\N
749	f	\N	154	14	\N	\N
750	f	\N	154	15	\N	\N
751	f	38	57	22	\N	\N
752	f	38	51	22	\N	\N
753	t	31	155	11	\N	\N
754	f	\N	155	12	\N	\N
755	f	\N	155	22	\N	\N
756	f	\N	155	14	\N	\N
757	f	\N	155	15	\N	\N
758	f	38	56	22	\N	\N
586	f	32	121	14	\N	\N
759	t	60	156	11	\N	\N
764	t	40	157	11	\N	\N
765	f	\N	157	12	\N	\N
766	f	\N	157	22	\N	\N
767	f	\N	157	14	\N	\N
768	f	\N	157	15	\N	\N
826	t	49	170	11	\N	\N
761	f	60	156	22	\N	\N
762	f	57	156	14	\N	\N
763	f	60	156	15	\N	\N
760	f	57	156	12	\N	\N
769	t	49	158	11	\N	\N
770	f	\N	158	12	\N	\N
771	f	\N	158	22	\N	\N
772	f	\N	158	14	\N	\N
773	f	\N	158	15	\N	\N
774	t	49	159	11	\N	\N
775	f	50	159	12	\N	\N
776	f	50	159	22	\N	\N
777	f	50	159	14	\N	\N
778	f	49	159	15	\N	\N
779	t	15	160	1	\N	\N
780	f	\N	160	2	\N	\N
781	f	\N	160	3	\N	\N
782	f	\N	160	4	\N	\N
783	t	55	161	11	\N	\N
793	t	28	163	11	2020-07-31 11:32:00	28
785	f	55	161	22	\N	\N
786	f	55	161	14	\N	\N
787	f	55	161	15	\N	\N
788	t	55	162	11	\N	\N
790	f	55	162	22	\N	\N
791	f	55	162	14	\N	\N
792	f	55	162	15	\N	\N
789	f	55	162	12	\N	\N
796	f	29	163	14	2020-07-31 11:32:00	28
797	f	28	163	15	2020-07-31 11:32:00	28
798	t	55	164	11	\N	\N
799	f	55	164	12	\N	\N
800	f	55	164	22	\N	\N
801	f	55	164	14	\N	\N
802	f	55	164	15	\N	\N
803	t	60	165	11	\N	\N
804	f	57	165	12	\N	\N
805	f	60	165	22	\N	\N
806	f	51	165	14	\N	\N
807	f	60	165	15	\N	\N
808	t	4	166	1	\N	\N
809	f	4	166	2	\N	\N
810	f	4	166	3	\N	\N
811	f	4	166	4	\N	\N
812	t	4	167	1	\N	\N
813	f	\N	167	2	\N	\N
814	f	\N	167	3	\N	\N
815	f	\N	167	4	\N	\N
816	t	40	168	11	\N	\N
817	f	\N	168	12	\N	\N
818	f	\N	168	22	\N	\N
819	f	\N	168	14	\N	\N
820	f	\N	168	15	\N	\N
821	t	28	169	11	\N	\N
822	f	\N	169	12	\N	\N
823	f	\N	169	22	\N	\N
824	f	\N	169	14	\N	\N
825	f	\N	169	15	\N	\N
831	t	31	171	11	\N	\N
832	f	33	171	12	\N	\N
833	f	38	171	22	\N	\N
834	f	30	171	14	\N	\N
835	f	31	171	15	\N	\N
836	t	49	172	11	\N	\N
837	f	\N	172	12	\N	\N
838	f	\N	172	22	\N	\N
839	f	\N	172	14	\N	\N
840	f	\N	172	15	\N	\N
841	t	40	173	11	\N	\N
842	f	33	173	12	\N	\N
843	f	38	173	22	\N	\N
844	f	30	173	14	\N	\N
845	f	31	173	15	\N	\N
846	t	49	174	11	\N	\N
847	f	\N	174	12	\N	\N
848	f	\N	174	22	\N	\N
849	f	\N	174	14	\N	\N
850	f	\N	174	15	\N	\N
851	t	63	175	11	\N	\N
852	f	\N	175	12	\N	\N
853	f	\N	175	22	\N	\N
854	f	\N	175	14	\N	\N
855	f	\N	175	15	\N	\N
827	f	50	170	12	\N	\N
828	f	38	170	22	\N	\N
829	f	30	170	14	\N	\N
830	f	49	170	15	\N	\N
856	t	57	176	11	\N	\N
861	t	49	177	11	\N	\N
862	f	\N	177	12	\N	\N
863	f	\N	177	22	\N	\N
864	f	\N	177	14	\N	\N
865	f	\N	177	15	\N	\N
866	t	63	178	11	\N	\N
857	f	51	176	12	\N	\N
858	f	38	176	22	\N	\N
860	f	57	176	15	\N	\N
784	f	55	161	12	\N	\N
794	f	29	163	12	2020-07-31 11:32:00	28
868	f	49	178	22	\N	\N
869	f	50	178	14	\N	\N
870	f	63	178	15	\N	\N
867	f	50	178	12	\N	\N
859	f	30	176	14	\N	\N
871	t	63	179	11	\N	\N
872	f	50	179	12	\N	\N
873	f	38	179	22	\N	\N
874	f	30	179	14	\N	\N
875	f	63	179	15	\N	\N
876	t	52	180	11	\N	\N
881	t	53	181	11	\N	\N
877	f	54	180	12	\N	\N
878	f	38	180	22	\N	\N
879	f	30	180	14	\N	\N
880	f	52	180	15	\N	\N
882	f	54	181	12	\N	\N
883	f	38	181	22	\N	\N
884	f	30	181	14	\N	\N
885	f	53	181	15	\N	\N
886	t	31	182	11	\N	\N
887	f	\N	182	12	\N	\N
888	f	\N	182	22	\N	\N
889	f	\N	182	14	\N	\N
890	f	\N	182	15	\N	\N
891	t	31	183	11	\N	\N
892	f	\N	183	12	\N	\N
893	f	\N	183	22	\N	\N
894	f	\N	183	14	\N	\N
895	f	\N	183	15	\N	\N
896	t	30	184	11	\N	\N
897	f	\N	184	12	\N	\N
898	f	\N	184	22	\N	\N
899	f	\N	184	14	\N	\N
900	f	\N	184	15	\N	\N
901	t	51	185	11	\N	\N
902	f	\N	185	12	\N	\N
903	f	\N	185	22	\N	\N
904	f	\N	185	14	\N	\N
905	f	\N	185	15	\N	\N
906	t	29	186	11	\N	\N
907	f	28	186	12	\N	\N
908	f	28	186	22	\N	\N
909	f	28	186	14	\N	\N
910	f	28	186	15	\N	\N
911	t	28	187	11	\N	\N
912	f	28	187	12	\N	\N
913	f	28	187	22	\N	\N
914	f	28	187	14	\N	\N
915	f	28	187	15	\N	\N
916	t	28	188	11	\N	\N
917	f	28	188	12	\N	\N
918	f	28	188	22	\N	\N
919	f	28	188	14	\N	\N
920	f	28	188	15	\N	\N
921	t	28	189	11	\N	\N
922	f	28	189	12	\N	\N
923	f	28	189	22	\N	\N
924	f	28	189	14	\N	\N
925	f	28	189	15	\N	\N
926	t	53	190	11	\N	\N
927	f	\N	190	12	\N	\N
928	f	\N	190	22	\N	\N
929	f	\N	190	14	\N	\N
930	f	\N	190	15	\N	\N
931	t	38	191	11	\N	\N
932	f	\N	191	12	\N	\N
933	f	\N	191	22	\N	\N
934	f	\N	191	14	\N	\N
935	f	\N	191	15	\N	\N
936	t	28	192	11	\N	\N
941	t	37	193	11	\N	\N
942	f	\N	193	12	\N	\N
943	f	\N	193	22	\N	\N
944	f	\N	193	14	\N	\N
945	f	\N	193	15	\N	\N
946	t	55	194	11	\N	\N
947	f	\N	194	12	\N	\N
948	f	\N	194	22	\N	\N
949	f	\N	194	14	\N	\N
950	f	\N	194	15	\N	\N
951	t	55	195	11	\N	\N
952	f	55	195	12	\N	\N
953	f	55	195	22	\N	\N
954	f	55	195	14	\N	\N
955	f	55	195	15	\N	\N
956	t	31	196	11	\N	\N
957	f	\N	196	12	\N	\N
958	f	\N	196	22	\N	\N
959	f	\N	196	14	\N	\N
960	f	\N	196	15	\N	\N
937	f	28	192	12	\N	\N
938	f	28	192	22	\N	\N
939	f	28	192	14	\N	\N
940	f	28	192	15	\N	\N
961	t	2	197	1	\N	\N
962	f	15	197	2	\N	\N
963	f	12	197	3	\N	\N
964	f	2	197	4	\N	\N
972	f	28	199	22	2020-07-03 13:57:00	28
973	f	55	199	14	2020-07-03 13:57:00	28
974	f	28	199	15	2020-07-03 13:57:00	28
965	t	28	198	11	2020-07-03 14:04:00	28
970	t	28	199	11	2020-07-03 13:57:00	28
971	f	55	199	12	2020-07-03 13:57:00	28
966	f	55	198	12	2020-07-03 14:04:00	28
967	f	28	198	22	2020-07-03 14:04:00	28
968	f	55	198	14	2020-07-03 14:04:00	28
969	f	29	198	15	2020-07-03 14:04:00	28
629	f	29	130	12	2020-08-05 07:39:00	28
975	t	28	200	11	2020-07-03 14:31:00	28
976	f	55	200	12	2020-07-03 14:31:00	28
977	f	28	200	22	2020-07-03 14:31:00	28
978	f	55	200	14	2020-07-03 14:31:00	28
979	f	28	200	15	2020-07-03 14:31:00	28
980	t	49	201	11	\N	\N
981	f	\N	201	12	\N	\N
982	f	\N	201	22	\N	\N
983	f	\N	201	14	\N	\N
984	f	\N	201	15	\N	\N
985	t	49	202	11	2020-07-06 15:34:00	49
986	f	50	202	12	2020-07-06 15:34:00	49
987	f	63	202	22	2020-07-06 15:34:00	49
988	f	50	202	14	2020-07-06 15:34:00	49
989	f	49	202	15	2020-07-06 15:34:00	49
1050	t	52	215	11	2020-07-17 10:05:00	53
1051	f	54	215	12	2020-07-17 10:05:00	53
1052	f	38	215	22	2020-07-17 10:05:00	53
1053	f	30	215	14	2020-07-17 10:05:00	53
1054	f	52	215	15	2020-07-17 10:05:00	53
1055	t	52	216	11	\N	\N
1025	t	40	210	11	2020-07-15 12:24:00	40
1026	f	33	210	12	2020-07-15 12:24:00	40
1027	f	85	210	22	2020-07-15 12:24:00	40
1028	f	33	210	14	2020-07-15 12:24:00	40
496	f	51	103	14	2020-07-07 19:55:00	57
995	t	60	204	11	\N	\N
996	f	\N	204	12	\N	\N
997	f	\N	204	22	\N	\N
998	f	\N	204	14	\N	\N
999	f	\N	204	15	\N	\N
1000	t	60	205	11	2020-07-08 15:19:00	60
1001	f	57	205	12	2020-07-08 15:19:00	60
1002	f	38	205	22	2020-07-08 15:19:00	60
1003	f	30	205	14	2020-07-08 15:19:00	60
1004	f	60	205	15	2020-07-08 15:19:00	60
990	t	40	203	11	2020-07-09 00:19:00	40
991	f	38	203	12	2020-07-09 00:19:00	40
992	f	31	203	22	2020-07-09 00:19:00	40
993	f	33	203	14	2020-07-09 00:19:00	40
1029	f	40	210	15	2020-07-15 12:24:00	40
994	f	40	203	15	2020-07-09 00:19:00	40
1005	t	57	206	11	2020-07-09 11:42:00	57
1006	f	60	206	12	2020-07-09 11:42:00	57
1007	f	38	206	22	2020-07-09 11:42:00	57
1008	f	30	206	14	2020-07-09 11:42:00	57
1009	f	57	206	15	2020-07-09 11:42:00	57
1015	t	40	208	11	2020-07-12 20:26:00	40
1016	f	33	208	12	2020-07-12 20:26:00	40
1017	f	38	208	22	2020-07-12 20:26:00	40
1018	f	30	208	14	2020-07-12 20:26:00	40
1019	f	40	208	15	2020-07-12 20:26:00	40
1010	t	28	207	11	2020-07-12 21:10:00	28
1011	f	29	207	12	2020-07-12 21:10:00	28
1012	f	28	207	22	2020-07-12 21:10:00	28
1013	f	29	207	14	2020-07-12 21:10:00	28
1014	f	28	207	15	2020-07-12 21:10:00	28
1020	t	28	209	11	2020-07-13 07:00:00	28
1021	f	29	209	12	2020-07-13 07:00:00	28
1022	f	28	209	22	2020-07-13 07:00:00	28
1023	f	29	209	14	2020-07-13 07:00:00	28
1024	f	28	209	15	2020-07-13 07:00:00	28
1031	f	33	211	12	2020-07-17 14:15:00	40
1032	f	38	211	22	2020-07-17 14:15:00	40
1033	f	30	211	14	2020-07-17 14:15:00	40
1034	f	32	211	15	2020-07-17 14:15:00	40
1075	t	28	220	11	\N	\N
1035	t	57	212	11	2020-07-15 20:15:00	57
1036	f	60	212	12	2020-07-15 20:15:00	57
1037	f	76	212	22	2020-07-15 20:15:00	57
1038	f	60	212	14	2020-07-15 20:15:00	57
1039	f	76	212	15	2020-07-15 20:15:00	57
1040	t	60	213	11	\N	\N
1041	f	\N	213	12	\N	\N
1042	f	\N	213	22	\N	\N
1043	f	\N	213	14	\N	\N
1044	f	\N	213	15	\N	\N
1045	t	52	214	11	\N	\N
1046	f	\N	214	12	\N	\N
1047	f	\N	214	22	\N	\N
1048	f	\N	214	14	\N	\N
1049	f	\N	214	15	\N	\N
1056	f	\N	216	12	\N	\N
1057	f	\N	216	22	\N	\N
1058	f	\N	216	14	\N	\N
1059	f	\N	216	15	\N	\N
1060	t	49	217	11	2020-07-17 10:36:00	49
1061	f	50	217	12	2020-07-17 10:36:00	49
1062	f	63	217	22	2020-07-17 10:36:00	49
1063	f	30	217	14	2020-07-17 10:36:00	49
1064	f	49	217	15	2020-07-17 10:36:00	49
1065	t	63	218	11	\N	\N
1066	f	\N	218	12	\N	\N
1067	f	\N	218	22	\N	\N
1068	f	\N	218	14	\N	\N
1069	f	\N	218	15	\N	\N
1070	t	49	219	11	2020-07-17 12:11:00	49
1071	f	50	219	12	2020-07-17 12:11:00	49
1072	f	63	219	22	2020-07-17 12:11:00	49
1073	f	50	219	14	2020-07-17 12:11:00	49
1074	f	49	219	15	2020-07-17 12:11:00	49
1030	t	40	211	11	2020-07-17 14:15:00	40
1076	f	\N	220	12	\N	\N
1077	f	\N	220	22	\N	\N
1078	f	\N	220	14	\N	\N
1079	f	\N	220	15	\N	\N
1081	f	40	221	12	2020-07-17 14:41:00	60
1085	t	28	222	11	\N	\N
1086	f	\N	222	12	\N	\N
1087	f	\N	222	22	\N	\N
1088	f	\N	222	14	\N	\N
1089	f	\N	222	15	\N	\N
1090	t	28	223	11	\N	\N
1091	f	\N	223	12	\N	\N
1092	f	\N	223	22	\N	\N
1093	f	\N	223	14	\N	\N
1094	f	\N	223	15	\N	\N
1095	t	28	224	11	\N	\N
1096	f	\N	224	12	\N	\N
1097	f	\N	224	22	\N	\N
1098	f	\N	224	14	\N	\N
1099	f	\N	224	15	\N	\N
1100	t	28	225	11	2020-07-17 14:40:00	28
1101	f	29	225	12	2020-07-17 14:40:00	28
1102	f	28	225	22	2020-07-17 14:40:00	28
1103	f	29	225	14	2020-07-17 14:40:00	28
1104	f	28	225	15	2020-07-17 14:40:00	28
1080	t	60	221	11	2020-07-17 14:41:00	60
1082	f	57	221	22	2020-07-17 14:41:00	60
1083	f	76	221	14	2020-07-17 14:41:00	60
1084	f	60	221	15	2020-07-17 14:41:00	60
1105	t	57	226	11	\N	\N
1106	f	\N	226	12	\N	\N
1107	f	\N	226	22	\N	\N
1108	f	\N	226	14	\N	\N
1109	f	\N	226	15	\N	\N
1120	t	63	229	11	\N	\N
1121	f	\N	229	12	\N	\N
1122	f	\N	229	22	\N	\N
1123	f	\N	229	14	\N	\N
1124	f	\N	229	15	\N	\N
1125	t	63	230	11	2020-07-20 16:45:00	63
1126	f	50	230	12	2020-07-20 16:45:00	63
1127	f	49	230	22	2020-07-20 16:45:00	63
1128	f	50	230	14	2020-07-20 16:45:00	63
1129	f	63	230	15	2020-07-20 16:45:00	63
1130	t	57	231	11	2020-07-22 12:07:00	57
1131	f	60	231	12	2020-07-22 12:07:00	57
1132	f	76	231	22	2020-07-22 12:07:00	57
1133	f	60	231	14	2020-07-22 12:07:00	57
1134	f	76	231	15	2020-07-22 12:07:00	57
1135	t	57	232	11	2020-07-22 12:21:00	57
1136	f	60	232	12	2020-07-22 12:21:00	57
1137	f	76	232	22	2020-07-22 12:21:00	57
1138	f	79	232	14	2020-07-22 12:21:00	57
1139	f	57	232	15	2020-07-22 12:21:00	57
1140	t	60	233	11	2020-07-24 12:56:00	60
1141	f	57	233	12	2020-07-24 12:56:00	60
1142	f	38	233	22	2020-07-24 12:56:00	60
1143	f	30	233	14	2020-07-24 12:56:00	60
1144	f	60	233	15	2020-07-24 12:56:00	60
1110	t	28	227	11	2020-07-27 08:50:00	28
1111	f	29	227	12	2020-07-27 08:50:00	28
1112	f	28	227	22	2020-07-27 08:50:00	28
1113	f	29	227	14	2020-07-27 08:50:00	28
1114	f	28	227	15	2020-07-27 08:50:00	28
1115	t	84	228	11	2020-07-29 12:33:00	84
1116	f	31	228	12	2020-07-29 12:33:00	84
1117	f	40	228	22	2020-07-29 12:33:00	84
1118	f	33	228	14	2020-07-29 12:33:00	84
1119	f	84	228	15	2020-07-29 12:33:00	84
1145	t	83	234	11	2020-07-30 18:05:00	83
1146	f	40	234	12	2020-07-30 18:05:00	83
1147	f	85	234	22	2020-07-30 18:05:00	83
1148	f	31	234	14	2020-07-30 18:05:00	83
1149	f	82	234	15	2020-07-30 18:05:00	83
795	f	28	163	22	2020-07-31 11:32:00	28
1150	t	60	235	11	2020-07-31 11:43:00	60
1151	f	93	235	12	2020-07-31 11:43:00	60
1152	f	57	235	22	2020-07-31 11:43:00	60
1153	f	78	235	14	2020-07-31 11:43:00	60
1154	f	60	235	15	2020-07-31 11:43:00	60
1155	t	60	236	11	\N	\N
1156	f	\N	236	12	\N	\N
1157	f	\N	236	22	\N	\N
1158	f	\N	236	14	\N	\N
1159	f	\N	236	15	\N	\N
1165	t	40	238	11	\N	\N
1166	f	\N	238	12	\N	\N
1167	f	\N	238	22	\N	\N
1168	f	\N	238	14	\N	\N
1169	f	\N	238	15	\N	\N
1160	t	83	237	11	2020-08-03 17:19:00	83
1161	f	40	237	12	2020-08-03 17:19:00	83
1162	f	31	237	22	2020-08-03 17:19:00	83
1163	f	84	237	14	2020-08-03 17:19:00	83
1164	f	85	237	15	2020-08-03 17:19:00	83
1170	t	84	239	11	\N	\N
1171	f	\N	239	12	\N	\N
1172	f	\N	239	22	\N	\N
1173	f	\N	239	14	\N	\N
1174	f	\N	239	15	\N	\N
628	t	28	130	11	2020-08-05 07:39:00	28
1175	t	28	240	11	2020-08-05 08:11:00	28
1176	f	29	240	12	2020-08-05 08:11:00	28
1177	f	27	240	22	2020-08-05 08:11:00	28
1178	f	29	240	14	2020-08-05 08:11:00	28
1179	f	28	240	15	2020-08-05 08:11:00	28
1181	f	54	241	12	2020-08-06 09:47:00	52
1183	f	30	241	14	2020-08-06 09:47:00	52
1184	f	52	241	15	2020-08-06 09:47:00	52
1180	t	52	241	11	2020-08-06 09:47:00	52
1182	f	38	241	22	2020-08-06 09:47:00	52
1185	t	40	242	11	\N	\N
1186	f	\N	242	12	\N	\N
1187	f	\N	242	22	\N	\N
1188	f	\N	242	14	\N	\N
1189	f	\N	242	15	\N	\N
1190	t	84	243	11	\N	\N
1191	f	\N	243	12	\N	\N
1192	f	\N	243	22	\N	\N
1193	f	\N	243	14	\N	\N
1194	f	\N	243	15	\N	\N
1195	t	84	244	11	2020-08-06 18:33:00	84
1196	f	40	244	12	2020-08-06 18:33:00	84
1197	f	85	244	22	2020-08-06 18:33:00	84
1198	f	40	244	14	2020-08-06 18:33:00	84
1199	f	84	244	15	2020-08-06 18:33:00	84
1200	t	84	245	11	2020-08-06 19:24:00	84
1201	f	40	245	12	2020-08-06 19:24:00	84
1202	f	85	245	22	2020-08-06 19:24:00	84
1203	f	40	245	14	2020-08-06 19:24:00	84
1204	f	84	245	15	2020-08-06 19:24:00	84
1205	t	52	246	11	\N	\N
1206	f	\N	246	12	\N	\N
1207	f	\N	246	22	\N	\N
1208	f	\N	246	14	\N	\N
1209	f	\N	246	15	\N	\N
1210	t	53	247	11	\N	\N
1211	f	\N	247	12	\N	\N
1212	f	\N	247	22	\N	\N
1213	f	\N	247	14	\N	\N
1214	f	\N	247	15	\N	\N
1215	t	74	248	11	\N	\N
1216	f	\N	248	12	\N	\N
1217	f	\N	248	22	\N	\N
1218	f	\N	248	14	\N	\N
1219	f	\N	248	15	\N	\N
1220	t	54	249	11	\N	\N
1221	f	\N	249	12	\N	\N
1222	f	\N	249	22	\N	\N
1223	f	\N	249	14	\N	\N
1224	f	\N	249	15	\N	\N
1225	t	54	250	11	\N	\N
1226	f	\N	250	12	\N	\N
1227	f	\N	250	22	\N	\N
1228	f	\N	250	14	\N	\N
1229	f	\N	250	15	\N	\N
1230	t	74	251	11	2020-08-07 12:16:00	74
1231	f	54	251	12	2020-08-07 12:16:00	74
1232	f	38	251	22	2020-08-07 12:16:00	74
1233	f	30	251	14	2020-08-07 12:16:00	74
1234	f	52	251	15	2020-08-07 12:16:00	74
1235	t	73	252	11	\N	\N
1236	f	\N	252	12	\N	\N
1237	f	\N	252	22	\N	\N
1238	f	\N	252	14	\N	\N
1239	f	\N	252	15	\N	\N
1240	t	98	253	55	2020-08-14 00:52:00	98
1241	f	99	253	61	2020-08-14 00:52:00	98
1242	f	98	253	58	2020-08-14 00:52:00	98
1243	f	99	253	62	2020-08-14 00:52:00	98
1244	f	98	253	60	2020-08-14 00:52:00	98
1245	t	103	254	11	\N	\N
1246	f	\N	254	12	\N	\N
1247	f	\N	254	22	\N	\N
1248	f	\N	254	14	\N	\N
1249	f	\N	254	15	\N	\N
1261	f	99	257	61	2020-08-20 12:19:00	98
1262	f	98	257	58	2020-08-20 12:19:00	98
1263	f	99	257	62	2020-08-20 12:19:00	98
1264	f	98	257	60	2020-08-20 12:19:00	98
1300	t	103	265	11	\N	\N
1301	f	\N	265	12	\N	\N
1302	f	\N	265	22	\N	\N
1303	f	\N	265	14	\N	\N
1304	f	\N	265	15	\N	\N
1305	t	103	266	11	\N	\N
1306	f	\N	266	12	\N	\N
1307	f	\N	266	22	\N	\N
1308	f	\N	266	14	\N	\N
1309	f	\N	266	15	\N	\N
1250	t	103	255	11	2020-08-21 11:08:00	103
1251	f	104	255	12	2020-08-21 11:08:00	103
1252	f	105	255	22	2020-08-21 11:08:00	103
1253	f	106	255	14	2020-08-21 11:08:00	103
1254	f	103	255	15	2020-08-21 11:08:00	103
1255	t	103	256	11	2020-08-21 11:10:00	103
1310	t	107	267	11	\N	\N
1311	f	\N	267	12	\N	\N
1312	f	\N	267	22	\N	\N
1313	f	\N	267	14	\N	\N
1314	f	\N	267	15	\N	\N
1265	t	97	258	35	\N	\N
1266	f	\N	258	41	\N	\N
1267	f	\N	258	38	\N	\N
1268	f	\N	258	42	\N	\N
1269	f	\N	258	40	\N	\N
1270	t	28	259	11	\N	\N
1271	f	\N	259	12	\N	\N
1272	f	\N	259	22	\N	\N
1273	f	\N	259	14	\N	\N
1274	f	\N	259	15	\N	\N
1275	t	28	260	11	\N	\N
1276	f	\N	260	12	\N	\N
1277	f	\N	260	22	\N	\N
1278	f	\N	260	14	\N	\N
1279	f	\N	260	15	\N	\N
1280	t	28	261	11	\N	\N
1281	f	\N	261	12	\N	\N
1282	f	\N	261	22	\N	\N
1283	f	\N	261	14	\N	\N
1284	f	\N	261	15	\N	\N
1285	t	28	262	11	\N	\N
1286	f	\N	262	12	\N	\N
1287	f	\N	262	22	\N	\N
1288	f	\N	262	14	\N	\N
1289	f	\N	262	15	\N	\N
1260	t	98	257	55	2020-08-20 12:19:00	98
1256	f	104	256	12	2020-08-21 11:10:00	103
1257	f	105	256	22	2020-08-21 11:10:00	103
1258	f	106	256	14	2020-08-21 11:10:00	103
1259	f	103	256	15	2020-08-21 11:10:00	103
1290	t	103	263	11	\N	\N
1291	f	\N	263	12	\N	\N
1292	f	\N	263	22	\N	\N
1293	f	\N	263	14	\N	\N
1294	f	\N	263	15	\N	\N
1295	t	103	264	11	\N	\N
1296	f	\N	264	12	\N	\N
1297	f	\N	264	22	\N	\N
1298	f	\N	264	14	\N	\N
1299	f	\N	264	15	\N	\N
1325	t	107	270	11	2020-08-25 14:59:00	107
1326	f	104	270	12	2020-08-25 14:59:00	107
1327	f	105	270	22	2020-08-25 14:59:00	107
1330	t	107	271	11	2020-08-25 15:00:00	107
1331	f	104	271	12	2020-08-25 15:00:00	107
1332	f	105	271	22	2020-08-25 15:00:00	107
1340	t	107	273	11	2020-08-26 16:20:00	107
1341	f	104	273	12	2020-08-26 16:20:00	107
1320	t	107	269	11	2020-08-25 14:58:00	107
1321	f	104	269	12	2020-08-25 14:58:00	107
1322	f	105	269	22	2020-08-25 14:58:00	107
1335	t	107	272	11	2020-08-25 14:56:00	107
1336	f	104	272	12	2020-08-25 14:56:00	107
1337	f	105	272	22	2020-08-25 14:56:00	107
1329	f	107	270	15	2020-08-25 14:59:00	107
1345	t	103	274	11	\N	\N
1346	f	\N	274	12	\N	\N
1347	f	\N	274	22	\N	\N
1348	f	\N	274	14	\N	\N
1349	f	\N	274	15	\N	\N
1338	f	106	272	14	2020-08-25 14:56:00	107
1339	f	107	272	15	2020-08-25 14:56:00	107
1323	f	106	269	14	2020-08-25 14:58:00	107
1324	f	107	269	15	2020-08-25 14:58:00	107
1328	f	106	270	14	2020-08-25 14:59:00	107
1333	f	106	271	14	2020-08-25 15:00:00	107
1334	f	107	271	15	2020-08-25 15:00:00	107
1315	t	107	268	11	2020-08-25 15:01:00	107
1316	f	104	268	12	2020-08-25 15:01:00	107
1317	f	105	268	22	2020-08-25 15:01:00	107
1318	f	106	268	14	2020-08-25 15:01:00	107
1319	f	107	268	15	2020-08-25 15:01:00	107
1350	t	103	275	11	2020-08-25 18:07:00	103
1351	f	104	275	12	2020-08-25 18:07:00	103
1352	f	105	275	22	2020-08-25 18:07:00	103
1353	f	106	275	14	2020-08-25 18:07:00	103
1354	f	103	275	15	2020-08-25 18:07:00	103
1355	t	103	276	11	2020-08-25 18:48:00	103
1356	f	104	276	12	2020-08-25 18:48:00	103
1357	f	105	276	22	2020-08-25 18:48:00	103
1358	f	106	276	14	2020-08-25 18:48:00	103
1359	f	103	276	15	2020-08-25 18:48:00	103
1342	f	105	273	22	2020-08-26 16:20:00	107
1343	f	106	273	14	2020-08-26 16:20:00	107
1344	f	107	273	15	2020-08-26 16:20:00	107
1360	t	99	277	55	2020-08-31 14:17:00	99
1361	f	98	277	61	2020-08-31 14:17:00	99
1362	f	99	277	58	2020-08-31 14:17:00	99
1363	f	98	277	62	2020-08-31 14:17:00	99
1364	f	99	277	60	2020-08-31 14:17:00	99
1365	t	103	278	11	\N	\N
1366	f	\N	278	12	\N	\N
1367	f	\N	278	22	\N	\N
1368	f	\N	278	14	\N	\N
1369	f	\N	278	15	\N	\N
1386	f	99	282	61	2020-08-31 21:19:00	98
1387	f	98	282	58	2020-08-31 21:19:00	98
1388	f	99	282	62	2020-08-31 21:19:00	98
1389	f	98	282	60	2020-08-31 21:19:00	98
1370	t	103	279	11	2020-08-31 16:30:00	103
1371	f	104	279	12	2020-08-31 16:30:00	103
1372	f	105	279	22	2020-08-31 16:30:00	103
1373	f	102	279	14	2020-08-31 16:30:00	103
1374	f	103	279	15	2020-08-31 16:30:00	103
1375	t	103	280	11	\N	\N
1376	f	\N	280	12	\N	\N
1377	f	\N	280	22	\N	\N
1378	f	\N	280	14	\N	\N
1379	f	\N	280	15	\N	\N
1380	t	103	281	11	\N	\N
1381	f	\N	281	12	\N	\N
1382	f	\N	281	22	\N	\N
1383	f	\N	281	14	\N	\N
1384	f	\N	281	15	\N	\N
1385	t	98	282	55	2020-08-31 21:19:00	98
1390	t	98	283	55	2020-09-01 07:00:00	98
1391	f	99	283	61	2020-09-01 07:00:00	98
1392	f	98	283	58	2020-09-01 07:00:00	98
1393	f	99	283	62	2020-09-01 07:00:00	98
1394	f	98	283	60	2020-09-01 07:00:00	98
1395	t	98	284	55	2020-09-01 07:47:00	98
1396	f	99	284	61	2020-09-01 07:47:00	98
1397	f	98	284	58	2020-09-01 07:47:00	98
1398	f	99	284	62	2020-09-01 07:47:00	98
1399	f	98	284	60	2020-09-01 07:47:00	98
1400	t	98	285	55	2020-09-01 08:35:00	98
1401	f	99	285	61	2020-09-01 08:35:00	98
1402	f	98	285	58	2020-09-01 08:35:00	98
1403	f	99	285	62	2020-09-01 08:35:00	98
1404	f	98	285	60	2020-09-01 08:35:00	98
1410	t	98	287	55	2020-09-01 16:05:00	98
1411	f	99	287	61	2020-09-01 16:05:00	98
1412	f	98	287	58	2020-09-01 16:05:00	98
1413	f	99	287	62	2020-09-01 16:05:00	98
1414	f	98	287	60	2020-09-01 16:05:00	98
1405	t	113	286	11	2020-09-01 17:06:00	113
1406	f	111	286	12	2020-09-01 17:06:00	113
1407	f	105	286	22	2020-09-01 17:06:00	113
1408	f	106	286	14	2020-09-01 17:06:00	113
1409	f	113	286	15	2020-09-01 17:06:00	113
1415	t	109	288	11	2020-09-01 18:16:00	109
1416	f	104	288	12	2020-09-01 18:16:00	109
1417	f	105	288	22	2020-09-01 18:16:00	109
1418	f	106	288	14	2020-09-01 18:16:00	109
1419	f	109	288	15	2020-09-01 18:16:00	109
1420	t	107	289	11	2020-09-01 19:51:00	107
1421	f	104	289	12	2020-09-01 19:51:00	107
1422	f	105	289	22	2020-09-01 19:51:00	107
1423	f	106	289	14	2020-09-01 19:51:00	107
1424	f	107	289	15	2020-09-01 19:51:00	107
1425	t	116	290	11	\N	\N
1426	f	\N	290	12	\N	\N
1427	f	\N	290	22	\N	\N
1428	f	\N	290	14	\N	\N
1429	f	\N	290	15	\N	\N
1430	t	116	291	11	\N	\N
1431	f	\N	291	12	\N	\N
1432	f	\N	291	22	\N	\N
1433	f	\N	291	14	\N	\N
1434	f	\N	291	15	\N	\N
1440	t	118	293	11	\N	\N
1441	f	\N	293	12	\N	\N
1442	f	\N	293	22	\N	\N
1443	f	\N	293	14	\N	\N
1444	f	\N	293	15	\N	\N
1445	t	118	294	11	\N	\N
1446	f	\N	294	12	\N	\N
1447	f	\N	294	22	\N	\N
1448	f	\N	294	14	\N	\N
1449	f	\N	294	15	\N	\N
1450	t	99	295	55	2020-09-02 16:36:00	99
1451	f	98	295	61	2020-09-02 16:36:00	99
1452	f	99	295	58	2020-09-02 16:36:00	99
1453	f	98	295	62	2020-09-02 16:36:00	99
1454	f	99	295	60	2020-09-02 16:36:00	99
1455	t	28	296	11	\N	\N
1456	f	\N	296	12	\N	\N
1457	f	\N	296	22	\N	\N
1458	f	\N	296	14	\N	\N
1459	f	\N	296	15	\N	\N
1460	t	98	297	55	2020-09-04 11:10:00	98
1461	f	99	297	61	2020-09-04 11:10:00	98
1462	f	98	297	58	2020-09-04 11:10:00	98
1463	f	99	297	62	2020-09-04 11:10:00	98
1464	f	98	297	60	2020-09-04 11:10:00	98
1465	t	98	298	55	2020-09-06 09:04:00	98
1466	f	99	298	61	2020-09-06 09:04:00	98
1467	f	98	298	58	2020-09-06 09:04:00	98
1468	f	99	298	62	2020-09-06 09:04:00	98
1469	f	98	298	60	2020-09-06 09:04:00	98
1475	t	99	300	55	2020-09-07 17:24:00	99
1476	f	98	300	61	2020-09-07 17:24:00	99
1477	f	99	300	58	2020-09-07 17:24:00	99
1478	f	98	300	62	2020-09-07 17:24:00	99
1479	f	99	300	60	2020-09-07 17:24:00	99
1535	t	113	312	11	\N	\N
1536	f	\N	312	12	\N	\N
1537	f	\N	312	22	\N	\N
1538	f	\N	312	14	\N	\N
1539	f	\N	312	15	\N	\N
1485	t	116	302	11	\N	\N
1486	f	\N	302	12	\N	\N
1487	f	\N	302	22	\N	\N
1488	f	\N	302	14	\N	\N
1489	f	\N	302	15	\N	\N
1470	t	107	299	11	2020-09-08 12:08:00	107
1471	f	104	299	12	2020-09-08 12:08:00	107
1472	f	105	299	22	2020-09-08 12:08:00	107
1473	f	106	299	14	2020-09-08 12:08:00	107
1474	f	107	299	15	2020-09-08 12:08:00	107
1490	t	122	303	11	\N	\N
1491	f	\N	303	12	\N	\N
1492	f	\N	303	22	\N	\N
1493	f	\N	303	14	\N	\N
1494	f	\N	303	15	\N	\N
1530	t	120	311	11	\N	\N
1531	f	\N	311	12	\N	\N
1532	f	\N	311	22	\N	\N
1533	f	\N	311	14	\N	\N
1534	f	\N	311	15	\N	\N
1500	t	119	305	11	\N	\N
1501	f	\N	305	12	\N	\N
1502	f	\N	305	22	\N	\N
1503	f	\N	305	14	\N	\N
1504	f	\N	305	15	\N	\N
1505	t	121	306	11	\N	\N
1506	f	\N	306	12	\N	\N
1507	f	\N	306	22	\N	\N
1508	f	\N	306	14	\N	\N
1509	f	\N	306	15	\N	\N
1510	t	121	307	11	\N	\N
1511	f	\N	307	12	\N	\N
1512	f	\N	307	22	\N	\N
1513	f	\N	307	14	\N	\N
1514	f	\N	307	15	\N	\N
1435	t	116	292	11	2020-09-14 15:05:00	116
1436	f	120	292	12	2020-09-14 15:05:00	116
1437	f	105	292	22	2020-09-14 15:05:00	116
1438	f	106	292	14	2020-09-14 15:05:00	116
1439	f	116	292	15	2020-09-14 15:05:00	116
1515	t	119	308	11	2020-09-14 15:32:00	119
1516	f	120	308	12	2020-09-14 15:32:00	119
1517	f	105	308	22	2020-09-14 15:32:00	119
1518	f	106	308	14	2020-09-14 15:32:00	119
1519	f	119	308	15	2020-09-14 15:32:00	119
1480	t	116	301	11	2020-09-14 15:49:00	116
1481	f	120	301	12	2020-09-14 15:49:00	116
1482	f	105	301	22	2020-09-14 15:49:00	116
1483	f	106	301	14	2020-09-14 15:49:00	116
1484	f	116	301	15	2020-09-14 15:49:00	116
1495	t	122	304	11	2020-12-04 10:26:00	102
1525	t	112	310	11	2020-09-16 10:02:00	112
1526	f	111	310	12	2020-09-16 10:02:00	112
1527	f	102	310	22	2020-09-16 10:02:00	112
1528	f	106	310	14	2020-09-16 10:02:00	112
1520	t	112	309	11	2020-09-16 10:03:00	112
1521	f	111	309	12	2020-09-16 10:03:00	112
1522	f	105	309	22	2020-09-16 10:03:00	112
1496	f	123	304	12	2020-12-04 10:26:00	102
1497	f	105	304	22	2020-12-04 10:26:00	102
1540	t	116	313	11	2020-09-14 16:40:00	116
1541	f	120	313	12	2020-09-14 16:40:00	116
1542	f	105	313	22	2020-09-14 16:40:00	116
1543	f	106	313	14	2020-09-14 16:40:00	116
1544	f	116	313	15	2020-09-14 16:40:00	116
1560	t	117	317	11	\N	\N
1561	f	\N	317	12	\N	\N
1562	f	\N	317	22	\N	\N
1563	f	\N	317	14	\N	\N
1564	f	\N	317	15	\N	\N
1551	f	123	315	12	2020-09-22 20:45:00	122
1552	f	105	315	22	2020-09-22 20:45:00	122
1553	f	106	315	14	2020-09-22 20:45:00	122
1554	f	121	315	15	2020-09-22 20:45:00	122
1498	f	106	304	14	2020-12-04 10:26:00	102
1545	t	113	314	11	2020-09-15 17:59:00	113
1546	f	111	314	12	2020-09-15 17:59:00	113
1766	f	\N	358	12	\N	\N
1547	f	105	314	22	2020-09-15 17:59:00	113
1548	f	106	314	14	2020-09-15 17:59:00	113
1549	f	113	314	15	2020-09-15 17:59:00	113
1570	t	113	319	11	2020-09-15 20:32:00	113
1571	f	111	319	12	2020-09-15 20:32:00	113
1572	f	105	319	22	2020-09-15 20:32:00	113
1573	f	106	319	14	2020-09-15 20:32:00	113
1574	f	113	319	15	2020-09-15 20:32:00	113
1529	f	112	310	15	2020-09-16 10:02:00	112
1523	f	106	309	14	2020-09-16 10:03:00	112
1524	f	112	309	15	2020-09-16 10:03:00	112
1580	t	114	321	11	2020-09-16 12:10:00	114
1581	f	111	321	12	2020-09-16 12:10:00	114
1582	f	105	321	22	2020-09-16 12:10:00	114
1583	f	106	321	14	2020-09-16 12:10:00	114
1584	f	114	321	15	2020-09-16 12:10:00	114
1575	t	113	320	11	2020-09-16 12:11:00	113
1576	f	111	320	12	2020-09-16 12:11:00	113
1577	f	105	320	22	2020-09-16 12:11:00	113
1578	f	106	320	14	2020-09-16 12:11:00	113
1579	f	113	320	15	2020-09-16 12:11:00	113
1585	t	114	322	11	2020-09-16 13:59:00	114
1586	f	111	322	12	2020-09-16 13:59:00	114
1587	f	105	322	22	2020-09-16 13:59:00	114
1588	f	106	322	14	2020-09-16 13:59:00	114
1589	f	114	322	15	2020-09-16 13:59:00	114
1590	t	112	323	11	2020-09-21 15:29:00	112
1591	f	111	323	12	2020-09-21 15:29:00	112
1592	f	105	323	22	2020-09-21 15:29:00	112
1593	f	106	323	14	2020-09-21 15:29:00	112
1594	f	112	323	15	2020-09-21 15:29:00	112
1595	t	107	324	11	\N	\N
1596	f	\N	324	12	\N	\N
1597	f	\N	324	22	\N	\N
1598	f	\N	324	14	\N	\N
1599	f	\N	324	15	\N	\N
1600	t	107	325	11	\N	\N
1601	f	\N	325	12	\N	\N
1602	f	\N	325	22	\N	\N
1603	f	\N	325	14	\N	\N
1604	f	\N	325	15	\N	\N
1610	t	107	327	11	\N	\N
1611	f	\N	327	12	\N	\N
1612	f	\N	327	22	\N	\N
1613	f	\N	327	14	\N	\N
1614	f	\N	327	15	\N	\N
1605	t	107	326	11	2020-09-22 17:24:00	107
1606	f	104	326	12	2020-09-22 17:24:00	107
1607	f	105	326	22	2020-09-22 17:24:00	107
1608	f	106	326	14	2020-09-22 17:24:00	107
1609	f	107	326	15	2020-09-22 17:24:00	107
1555	t	122	316	11	2020-09-22 20:45:00	122
1556	f	123	316	12	2020-09-22 20:45:00	122
1557	f	105	316	22	2020-09-22 20:45:00	122
1558	f	106	316	14	2020-09-22 20:45:00	122
1559	f	121	316	15	2020-09-22 20:45:00	122
1550	t	122	315	11	2020-09-22 20:45:00	122
1499	f	121	304	15	2020-12-04 10:26:00	102
1615	t	123	328	11	\N	\N
1616	f	\N	328	12	\N	\N
1617	f	\N	328	22	\N	\N
1618	f	\N	328	14	\N	\N
1619	f	\N	328	15	\N	\N
1620	t	113	329	11	\N	\N
1621	f	\N	329	12	\N	\N
1622	f	\N	329	22	\N	\N
1623	f	\N	329	14	\N	\N
1624	f	\N	329	15	\N	\N
1640	t	114	333	11	2020-09-29 14:27:00	114
1641	f	115	333	12	2020-09-29 14:27:00	114
1642	f	105	333	22	2020-09-29 14:27:00	114
1635	t	114	332	11	2020-09-29 16:14:00	114
1636	f	115	332	12	2020-09-29 16:14:00	114
1637	f	105	332	22	2020-09-29 16:14:00	114
1625	t	114	330	11	2020-09-30 16:37:00	114
1626	f	115	330	12	2020-09-30 16:37:00	114
1627	f	105	330	22	2020-09-30 16:37:00	114
1628	f	106	330	14	2020-09-30 16:37:00	114
1565	t	117	318	11	2020-12-17 14:06:00	117
1566	f	120	318	12	2020-12-17 14:06:00	117
1567	f	105	318	22	2020-12-17 14:06:00	117
1630	t	107	331	11	2020-09-29 13:46:00	107
1631	f	104	331	12	2020-09-29 13:46:00	107
1632	f	105	331	22	2020-09-29 13:46:00	107
1633	f	106	331	14	2020-09-29 13:46:00	107
1634	f	107	331	15	2020-09-29 13:46:00	107
1643	f	106	333	14	2020-09-29 14:27:00	114
1644	f	114	333	15	2020-09-29 14:27:00	114
1638	f	106	332	14	2020-09-29 16:14:00	114
1639	f	114	332	15	2020-09-29 16:14:00	114
1629	f	114	330	15	2020-09-30 16:37:00	114
1645	t	121	334	11	\N	\N
1646	f	\N	334	12	\N	\N
1647	f	\N	334	22	\N	\N
1648	f	\N	334	14	\N	\N
1649	f	\N	334	15	\N	\N
1650	t	121	335	11	2020-10-15 16:15:00	121
1651	f	123	335	12	2020-10-15 16:15:00	121
1652	f	105	335	22	2020-10-15 16:15:00	121
1653	f	106	335	14	2020-10-15 16:15:00	121
1654	f	121	335	15	2020-10-15 16:15:00	121
1655	t	121	336	11	\N	\N
1656	f	\N	336	12	\N	\N
1657	f	\N	336	22	\N	\N
1658	f	\N	336	14	\N	\N
1659	f	\N	336	15	\N	\N
1660	t	121	337	11	2020-10-16 18:28:00	121
1661	f	123	337	12	2020-10-16 18:28:00	121
1662	f	105	337	22	2020-10-16 18:28:00	121
1663	f	106	337	14	2020-10-16 18:28:00	121
1664	f	121	337	15	2020-10-16 18:28:00	121
1665	t	117	338	11	2020-10-21 15:58:00	117
1666	f	120	338	12	2020-10-21 15:58:00	117
1667	f	105	338	22	2020-10-21 15:58:00	117
1668	f	106	338	14	2020-10-21 15:58:00	117
1669	f	117	338	15	2020-10-21 15:58:00	117
1670	t	114	339	11	2020-11-03 15:12:00	114
1671	f	103	339	12	2020-11-03 15:12:00	114
1672	f	105	339	22	2020-11-03 15:12:00	114
1673	f	106	339	14	2020-11-03 15:12:00	114
1674	f	114	339	15	2020-11-03 15:12:00	114
1675	t	114	340	11	\N	\N
1676	f	\N	340	12	\N	\N
1677	f	\N	340	22	\N	\N
1678	f	\N	340	14	\N	\N
1679	f	\N	340	15	\N	\N
1680	t	114	341	11	2020-11-03 17:30:00	114
1681	f	103	341	12	2020-11-03 17:30:00	114
1682	f	105	341	22	2020-11-03 17:30:00	114
1683	f	106	341	14	2020-11-03 17:30:00	114
1684	f	114	341	15	2020-11-03 17:30:00	114
1685	t	114	342	11	2020-11-03 18:34:00	114
1686	f	103	342	12	2020-11-03 18:34:00	114
1687	f	105	342	22	2020-11-03 18:34:00	114
1688	f	106	342	14	2020-11-03 18:34:00	114
1689	f	114	342	15	2020-11-03 18:34:00	114
1690	t	121	343	11	2020-11-09 13:19:00	121
1691	f	123	343	12	2020-11-09 13:19:00	121
1692	f	105	343	22	2020-11-09 13:19:00	121
1693	f	106	343	14	2020-11-09 13:19:00	121
1694	f	121	343	15	2020-11-09 13:19:00	121
1695	t	121	344	11	2020-11-09 14:57:00	121
1696	f	123	344	12	2020-11-09 14:57:00	121
1698	f	106	344	14	2020-11-09 14:57:00	121
1699	f	121	344	15	2020-11-09 14:57:00	121
1700	t	116	345	11	\N	\N
1701	f	\N	345	12	\N	\N
1702	f	\N	345	22	\N	\N
1703	f	\N	345	14	\N	\N
1704	f	\N	345	15	\N	\N
1705	t	128	346	11	2020-11-11 12:34:00	128
1706	f	120	346	12	2020-11-11 12:34:00	128
1707	f	105	346	22	2020-11-11 12:34:00	128
1708	f	106	346	14	2020-11-11 12:34:00	128
1709	f	128	346	15	2020-11-11 12:34:00	128
1710	t	121	347	11	2020-12-08 17:10:00	121
1711	f	123	347	12	2020-12-08 17:10:00	121
1712	f	105	347	22	2020-12-08 17:10:00	121
1713	f	106	347	14	2020-12-08 17:10:00	121
1714	f	121	347	15	2020-12-08 17:10:00	121
1730	t	113	351	11	2020-12-11 15:12:00	113
1731	f	111	351	12	2020-12-11 15:12:00	113
1732	f	105	351	22	2020-12-11 15:12:00	113
1733	f	106	351	14	2020-12-11 15:12:00	113
1734	f	113	351	15	2020-12-11 15:12:00	113
1725	t	121	350	11	2020-12-11 16:10:00	121
1726	f	123	350	12	2020-12-11 16:10:00	121
1727	f	105	350	22	2020-12-11 16:10:00	121
1720	t	121	349	11	2020-12-11 16:14:00	121
1721	f	123	349	12	2020-12-11 16:14:00	121
1722	f	105	349	22	2020-12-11 16:14:00	121
1723	f	106	349	14	2020-12-11 16:14:00	121
1715	t	121	348	11	2020-12-11 16:15:00	121
1716	f	123	348	12	2020-12-11 16:15:00	121
1717	f	105	348	22	2020-12-11 16:15:00	121
1697	f	105	344	22	2020-12-16 10:19:00	123
1728	f	106	350	14	2020-12-11 16:10:00	121
1729	f	121	350	15	2020-12-11 16:10:00	121
1724	f	121	349	15	2020-12-11 16:14:00	121
1718	f	106	348	14	2020-12-11 16:15:00	121
1719	f	121	348	15	2020-12-11 16:15:00	121
1735	t	121	352	11	2020-12-12 11:22:00	121
1736	f	123	352	12	2020-12-12 11:22:00	121
1737	f	105	352	22	2020-12-12 11:22:00	121
1738	f	106	352	14	2020-12-12 11:22:00	121
1739	f	121	352	15	2020-12-12 11:22:00	121
1740	t	119	353	11	2020-12-15 13:53:00	119
1741	f	120	353	12	2020-12-15 13:53:00	119
1742	f	105	353	22	2020-12-15 13:53:00	119
1743	f	106	353	14	2020-12-15 13:53:00	119
1744	f	128	353	15	2020-12-15 13:53:00	119
1750	t	109	355	11	2020-12-16 09:46:00	109
1751	f	104	355	12	2020-12-16 09:46:00	109
1752	f	105	355	22	2020-12-16 09:46:00	109
1753	f	106	355	14	2020-12-16 09:46:00	109
1754	f	109	355	15	2020-12-16 09:46:00	109
1755	t	109	356	11	2020-12-16 10:00:00	109
1756	f	104	356	12	2020-12-16 10:00:00	109
1757	f	105	356	22	2020-12-16 10:00:00	109
1758	f	106	356	14	2020-12-16 10:00:00	109
1759	f	109	356	15	2020-12-16 10:00:00	109
1760	t	117	357	11	\N	\N
1761	f	\N	357	12	\N	\N
1762	f	\N	357	22	\N	\N
1763	f	\N	357	14	\N	\N
1764	f	\N	357	15	\N	\N
1765	t	117	358	11	\N	\N
1767	f	\N	358	22	\N	\N
1768	f	\N	358	14	\N	\N
1769	f	\N	358	15	\N	\N
1775	t	134	360	11	\N	\N
1776	f	\N	360	12	\N	\N
1777	f	\N	360	22	\N	\N
1778	f	\N	360	14	\N	\N
1779	f	\N	360	15	\N	\N
1770	t	117	359	11	2020-12-17 13:57:00	117
1771	f	120	359	12	2020-12-17 13:57:00	117
1772	f	105	359	22	2020-12-17 13:57:00	117
1773	f	106	359	14	2020-12-17 13:57:00	117
1774	f	117	359	15	2020-12-17 13:57:00	117
1568	f	106	318	14	2020-12-17 14:06:00	117
1569	f	117	318	15	2020-12-17 14:06:00	117
1790	t	107	363	11	2020-12-18 15:40:00	107
1791	f	104	363	12	2020-12-18 15:40:00	107
1792	f	105	363	22	2020-12-18 15:40:00	107
1793	f	106	363	14	2020-12-18 15:40:00	107
1794	f	107	363	15	2020-12-18 15:40:00	107
1795	t	107	364	11	2020-12-18 16:20:00	107
1796	f	104	364	12	2020-12-18 16:20:00	107
1797	f	105	364	22	2020-12-18 16:20:00	107
1798	f	106	364	14	2020-12-18 16:20:00	107
1799	f	107	364	15	2020-12-18 16:20:00	107
1800	t	98	365	55	2020-12-19 10:44:00	98
1801	f	99	365	61	2020-12-19 10:44:00	98
1802	f	98	365	58	2020-12-19 10:44:00	98
1803	f	99	365	62	2020-12-19 10:44:00	98
1804	f	98	365	60	2020-12-19 10:44:00	98
1785	t	109	362	11	2020-12-19 11:48:00	109
1786	f	104	362	12	2020-12-19 11:48:00	109
1787	f	105	362	22	2020-12-19 11:48:00	109
1788	f	106	362	14	2020-12-19 11:48:00	109
1789	f	109	362	15	2020-12-19 11:48:00	109
1810	t	117	367	11	2020-12-21 15:10:00	117
1811	f	120	367	12	2020-12-21 15:10:00	117
1812	f	105	367	22	2020-12-21 15:10:00	117
1813	f	106	367	14	2020-12-21 15:10:00	117
1814	f	117	367	15	2020-12-21 15:10:00	117
1780	t	134	361	11	2020-12-21 15:58:00	134
1781	f	123	361	12	2020-12-21 15:58:00	134
1782	f	105	361	22	2020-12-21 15:58:00	134
1783	f	106	361	14	2020-12-21 15:58:00	134
1784	f	134	361	15	2020-12-21 15:58:00	134
1815	t	121	368	11	\N	\N
1816	f	\N	368	12	\N	\N
1817	f	\N	368	22	\N	\N
1818	f	\N	368	14	\N	\N
1819	f	\N	368	15	\N	\N
1805	t	134	366	11	2020-12-21 17:25:00	134
1806	f	123	366	12	2020-12-21 17:25:00	134
1807	f	105	366	22	2020-12-21 17:25:00	134
1808	f	106	366	14	2020-12-21 17:25:00	134
1809	f	134	366	15	2020-12-21 17:25:00	134
1820	t	134	369	11	2020-12-22 12:54:00	134
1825	t	121	370	11	2020-12-23 12:22:00	121
1826	f	123	370	12	2020-12-23 12:22:00	121
1827	f	105	370	22	2020-12-23 12:22:00	121
1828	f	106	370	14	2020-12-23 12:22:00	121
1745	t	116	354	11	2020-12-23 13:59:00	116
1746	f	120	354	12	2020-12-23 13:59:00	116
1747	f	105	354	22	2020-12-23 13:59:00	116
1821	f	123	369	12	2020-12-22 12:54:00	134
1822	f	105	369	22	2020-12-22 12:54:00	134
1823	f	106	369	14	2020-12-22 12:54:00	134
1824	f	134	369	15	2020-12-22 12:54:00	134
1830	t	121	371	11	\N	\N
1831	f	\N	371	12	\N	\N
1832	f	\N	371	22	\N	\N
1833	f	\N	371	14	\N	\N
1834	f	\N	371	15	\N	\N
1835	t	98	372	55	2020-12-23 09:28:00	98
1836	f	99	372	61	2020-12-23 09:28:00	98
1837	f	98	372	58	2020-12-23 09:28:00	98
1838	f	99	372	62	2020-12-23 09:28:00	98
1839	f	98	372	60	2020-12-23 09:28:00	98
1829	f	121	370	15	2020-12-23 12:22:00	121
1748	f	106	354	14	2020-12-23 13:59:00	116
1749	f	116	354	15	2020-12-23 13:59:00	116
1840	t	99	373	55	\N	\N
1841	f	\N	373	61	\N	\N
1842	f	\N	373	58	\N	\N
1843	f	\N	373	62	\N	\N
1844	f	\N	373	60	\N	\N
1845	t	98	374	55	\N	\N
1846	f	\N	374	61	\N	\N
1847	f	\N	374	58	\N	\N
1848	f	\N	374	62	\N	\N
1849	f	\N	374	60	\N	\N
1850	t	117	375	11	2021-01-05 16:33:00	120
1851	f	120	375	12	2021-01-05 16:33:00	120
1852	f	105	375	22	2021-01-05 16:33:00	120
1853	f	106	375	14	2021-01-05 16:33:00	120
1854	f	117	375	15	2021-01-05 16:33:00	120
1855	t	116	376	11	\N	\N
1856	f	\N	376	12	\N	\N
1857	f	\N	376	22	\N	\N
1858	f	\N	376	14	\N	\N
1859	f	\N	376	15	\N	\N
1860	t	113	377	11	\N	\N
1861	f	\N	377	12	\N	\N
1862	f	\N	377	22	\N	\N
1863	f	\N	377	14	\N	\N
1864	f	\N	377	15	\N	\N
1865	t	146	378	75	\N	\N
1866	f	\N	378	81	\N	\N
1867	f	\N	378	78	\N	\N
1868	f	\N	378	82	\N	\N
1869	f	\N	378	80	\N	\N
1870	t	147	379	95	\N	\N
1871	f	\N	379	97	\N	\N
1872	f	\N	379	98	\N	\N
1873	f	\N	379	99	\N	\N
1874	f	\N	379	100	\N	\N
\.


--
-- TOC entry 3609 (class 0 OID 122519)
-- Dependencies: 219
-- Data for Name: grant_document_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_document_attributes (id, file_type, location, name, version, grant_id, section_id, section_attribute_id) FROM stdin;
\.


--
-- TOC entry 3611 (class 0 OID 122527)
-- Dependencies: 221
-- Data for Name: grant_document_kpi_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_document_kpi_data (id, actuals, goal, note, to_report, type, grant_kpi_id, submission_id) FROM stdin;
\.


--
-- TOC entry 3614 (class 0 OID 122537)
-- Dependencies: 224
-- Data for Name: grant_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_documents (id, location, uploaded_on, uploaded_by, name, extension, grant_id) FROM stdin;
\.


--
-- TOC entry 3616 (class 0 OID 122546)
-- Dependencies: 226
-- Data for Name: grant_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_history (seqid, id, amount, created_at, created_by, description, end_date, name, representative, start_date, status_name, template_id, updated_at, updated_by, grant_status_id, grantor_org_id, organization_id, substatus_id, note, note_added, note_added_by, moved_on, reference_no, deleted, amended, orig_grant_id, amend_grant_id, amendment_no) FROM stdin;
\.


--
-- TOC entry 3617 (class 0 OID 122556)
-- Dependencies: 227
-- Data for Name: grant_kpis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_kpis (id, created_at, created_by, description, periodicity_unit, kpi_reporting_type, kpi_type, periodicity, is_scheduled, title, updated_at, updated_by, grant_id) FROM stdin;
\.


--
-- TOC entry 3619 (class 0 OID 122564)
-- Dependencies: 229
-- Data for Name: grant_qualitative_kpi_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_qualitative_kpi_data (id, actuals, goal, note, to_report, grant_kpi_id, submission_id) FROM stdin;
\.


--
-- TOC entry 3621 (class 0 OID 122572)
-- Dependencies: 231
-- Data for Name: grant_quantitative_kpi_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_quantitative_kpi_data (id, actuals, goal, note, to_report, grant_kpi_id, submission_id) FROM stdin;
\.


--
-- TOC entry 3623 (class 0 OID 122577)
-- Dependencies: 233
-- Data for Name: grant_section_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_section_attributes (id, deletable, field_name, field_type, required, type, section_id) FROM stdin;
1	f	What is need being addressed?	multiline	t	\N	1
2	f	Why do this?	multiline	t	\N	1
3	f	What is the proposed intervention?	multiline	t	\N	2
4	f	Describe the intervention	multiline	t	\N	2
5	f	Describe the main activities of the project	multiline	t	\N	2
6	f	Describe the key assumptions	multiline	t	\N	2
7	f	Describe the success factors	multiline	t	\N	2
8	f	Describe the risks to the project & mitigation plans	multiline	t	\N	3
9	f	Describe the impact outcomes	multiline	t	\N	4
10	f	Annual budget	multiline	t	\N	5
11	f	Disbursement schedule	multiline	t	\N	5
12	f	Bank Name	multiline	t	\N	5
13	f	Bank A/C No.	multiline	t	\N	5
14	f	Bank IFSC Code	multiline	t	\N	5
15	f	Severability	multiline	t	\N	6
16	f	Governing Law and Jursidiction	multiline	t	\N	6
17	f	Binding terms	multiline	t	\N	6
18	f	Insurance	multiline	t	\N	6
19	f	Notices	multiline	t	\N	6
20	f	Indemnification	multiline	t	\N	6
21	f	Assignment	multiline	t	\N	6
22	f	Amendment	multiline	t	\N	6
\.


--
-- TOC entry 3625 (class 0 OID 122585)
-- Dependencies: 235
-- Data for Name: grant_sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_sections (id, deletable, section_name) FROM stdin;
1	f	Purpose
2	f	Project Approach
3	t	Project Risks/challenges
4	t	Project Outcome Measurement & Evaluation
5	t	Budget & Finance Details
6	t	Grant Terms & Conditions
\.


--
-- TOC entry 3628 (class 0 OID 122592)
-- Dependencies: 238
-- Data for Name: grant_snapshot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_snapshot (id, assigned_to_id, grant_id, grantee, string_attributes, name, description, amount, start_date, end_date, representative, grant_status_id, moved_on, assigned_by, amended, orig_grant_id, amend_grant_id, amendment_no, from_state_id, from_note, moved_by, from_string_attributes, to_state_id) FROM stdin;
\.


--
-- TOC entry 3629 (class 0 OID 122601)
-- Dependencies: 239
-- Data for Name: grant_specific_section_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_specific_section_attributes (id, attribute_order, deletable, extras, field_name, field_type, required, granter_id, section_id) FROM stdin;
\.


--
-- TOC entry 3631 (class 0 OID 122609)
-- Dependencies: 241
-- Data for Name: grant_specific_sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_specific_sections (id, deletable, grant_id, grant_template_id, section_name, section_order, granter_id) FROM stdin;
\.


--
-- TOC entry 3633 (class 0 OID 122614)
-- Dependencies: 243
-- Data for Name: grant_string_attribute_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_string_attribute_attachments (id, name, description, location, version, title, type, created_on, created_by, updated_on, updated_by, grant_string_attribute_id) FROM stdin;
\.


--
-- TOC entry 3634 (class 0 OID 122622)
-- Dependencies: 244
-- Data for Name: grant_string_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_string_attributes (id, frequency, target, value, grant_id, section_id, section_attribute_id) FROM stdin;
\.


--
-- TOC entry 3636 (class 0 OID 122630)
-- Dependencies: 246
-- Data for Name: grantees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grantees (id) FROM stdin;
\.


--
-- TOC entry 3643 (class 0 OID 122673)
-- Dependencies: 253
-- Data for Name: granter_grant_section_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.granter_grant_section_attributes (id, attribute_order, deletable, extras, field_name, field_type, required, granter_id, section_id) FROM stdin;
2068	1	t	\N	What is need being addressed?	multiline	f	11	591
2069	2	t	\N	Why do this?	multiline	f	11	591
2070	1	t	\N	What is the proposed intervention?	multiline	f	11	592
2071	2	t	\N	Describe the intervention	multiline	f	11	592
2072	3	t	\N	Describe the main activities of the project	multiline	f	11	592
2073	4	t	\N	Describe the key assumptions	multiline	f	11	592
2074	5	t	\N	Describe the success factors	multiline	f	11	592
2075	1	t	\N	Describe the risks to the project & mitigation plans	multiline	f	11	593
2076	1	t	\N	Describe the impact outcomes	multiline	f	11	594
2077	1	t	\N	Annual budget	multiline	f	11	595
2078	2	t	\N	Disbursement schedule	multiline	f	11	595
2079	3	t	\N	Bank Name	multiline	f	11	595
2080	4	t	\N	Bank A/C No.	multiline	f	11	595
2081	5	t	\N	Bank IFSC Code	multiline	f	11	595
2082	1	t	\N	Severability	multiline	f	11	596
2083	2	t	\N	Governing Law and Jursidiction	multiline	f	11	596
2084	3	t	\N	Binding terms	multiline	f	11	596
2085	4	t	\N	Insurance	multiline	f	11	596
2086	5	t	\N	Notices	multiline	f	11	596
2087	6	t	\N	Indemnification	multiline	f	11	596
2088	7	t	\N	Assignment	multiline	f	11	596
2089	8	t	\N	Amendment	multiline	f	11	596
\.


--
-- TOC entry 3645 (class 0 OID 122681)
-- Dependencies: 255
-- Data for Name: granter_grant_sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.granter_grant_sections (id, deletable, section_name, section_order, grant_template_id, granter_id) FROM stdin;
591	t	Purpose	1	99	11
592	t	Project Approach	2	99	11
593	t	Project Risks/challenges	3	99	11
594	t	Project Outcome Measurement & Evaluation	4	99	11
595	t	Budget & Finance Details	5	99	11
596	t	Grant Terms & Conditions	6	99	11
\.


--
-- TOC entry 3647 (class 0 OID 122686)
-- Dependencies: 257
-- Data for Name: granter_grant_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.granter_grant_templates (id, description, granter_id, name, published, private_to_grant, default_template) FROM stdin;
99	Default Anudan template	11	Default Anudan template	t	f	t
\.


--
-- TOC entry 3651 (class 0 OID 122703)
-- Dependencies: 261
-- Data for Name: granter_report_section_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.granter_report_section_attributes (id, attribute_order, deletable, extras, field_name, field_type, required, granter_id, section_id) FROM stdin;
73	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	67
74	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	68
7	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	f	11	8
8	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	f	11	12
9	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}]}]	Planned v/s Actuals Spends	table	f	11	12
10	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	f	11	11
11	1	t	\N	Who is this project for? (List beneficiaries)	multiline	f	11	7
12	1	t	\N		document	f	11	10
75	1	f	\N	New KPI	kpi	t	11	69
76	1	t	\N		document	t	11	70
77	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	71
78	2	t	[{"name":"Amounts (in INR)","header":null,"columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}]}]	Planned v/s Actuals Spends	table	t	11	72
79	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	document	t	11	72
128	1	t	\N		document	t	11	112
129	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	113
130	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	114
131	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	115
132	2	t	[{"name":"1","header":"Actual Installment #","columns":[{"name":"Disbursement Date","value":"","dataType":"date"},{"name":"Actual Disbursement","value":"","dataType":"currency"},{"name":"Funds from other Sources","value":"","dataType":"currency"},{"name":"Notes","value":"","dataType":null}]}]	Instalment	disbursement	t	11	115
133	1	t	\N	New KPI	kpi	t	11	116
134	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	117
135	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	118
136	1	f	\N	Increase in additional training hours	kpi	t	11	119
137	1	t	\N		document	t	11	120
138	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	121
139	1	t	[{"name":"2","header":"Planned Installment #","columns":[{"name":"Disbursement Date","value":"","dataType":"date"},{"name":"Actual Disbursement","value":"","dataType":"currency"},{"name":"Funds from other Sources","value":"","dataType":"currency"},{"name":"Notes","value":"","dataType":null}]}]	Disbursement Details	disbursement	t	11	122
140	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	123
141	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	124
142	1	f	\N	Increase in additional training hours	kpi	t	11	125
143	1	t	\N		document	t	11	126
144	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	127
66	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	61
67	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	62
68	1	t	\N	Otuput	multiline	t	11	63
69	1	t	\N	Learning 	multiline	t	11	64
70	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	65
71	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	66
72	2	t	\N	Planned v/s Actuals Spends	multiline	t	11	66
325	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	276
326	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	277
327	1	t	\N		document	t	11	279
328	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	280
329	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	281
330	2	t	\N	Planned v/s Actuals Spends	disbursement	t	11	281
461	2	t	\N	Disbursement	disbursement	t	11	402
462	2	t	\N	Copy of Approved Report	document	t	11	404
463	1	t	\N	Note on the migrated report (why is this report different) | This report is previously approved outside of Anudan and has been migrated along with the Grant and all related details to ensure centralisation of all Sustain Plus Grants. 	multiline	t	11	404
464	3	t	\N	Copies of documents attached with the report	document	t	11	404
550	1	t	\N	Copy of Approved Report	document	t	11	447
551	3	t	\N	Copies of documents attached with the report	document	t	11	447
552	2	t	\N	Note on the migrated report (why is this report different) 	multiline	t	11	447
553	1	t	\N	Disbursement	disbursement	t	11	448
554	1	t	\N	Apricot drying	kpi	t	11	449
555	2	t	\N	Improved greenhouse	kpi	t	11	449
556	3	t	\N	Sheep Shearing	kpi	t	11	449
557	4	t	\N	Lift Irrigation	kpi	t	11	449
558	5	t	\N	Lambing Shed	kpi	t	11	449
145	1	t	[{"name":"1","header":"Planned Installment #","columns":[{"name":"Disbursement Date","value":"","dataType":"date"},{"name":"Actual Disbursement","value":"","dataType":"currency"},{"name":"Funds from other Sources","value":"","dataType":"currency"},{"name":"Notes","value":""}]}]	Disbursement Details	disbursement	t	11	128
206	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	184
207	1	t	\N	Learning 	multiline	t	11	185
208	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	186
209	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	187
210	2	t	\N	Planned v/s Actuals Spends	multiline	t	11	187
211	1	t	\N	Otuput	multiline	t	11	188
212	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	189
213	1	t	\N		document	t	11	190
352	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	300
366	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	318
367	2	t	\N		document	t	11	318
368	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	319
369	1	f	\N	Describe the impact outcomes	kpi	t	11	320
370	1	t	\N		document	t	11	321
371	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	322
372	1	t	\N	Disbursement Details	disbursement	t	11	323
390	1	t	\N	Please submit FCRA certificate	multiline	t	11	338
398	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	345
399	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	346
400	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null}]	Planned v/s Actuals Spends	table	t	11	346
401	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	347
402	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	348
403	1	t	\N		table	t	11	349
404	1	t	\N		document	t	11	350
410	1	t	\N		document	t	11	357
411	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	358
412	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	359
413	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null}]	Planned v/s Actuals Spends	table	t	11	359
319	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	270
320	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	271
321	1	t	\N		document	t	11	273
322	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	274
323	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	275
324	2	t	\N	Planned v/s Actuals Spends	disbursement	t	11	275
283	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	233
284	1	t	\N	Otuput	multiline	t	11	234
285	1	t	\N	Learning 	multiline	t	11	235
286	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	236
161	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	143
162	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	144
163	1	f	\N	Describe the risks to the project & mitigation plans	kpi	t	11	145
164	2	f	\N	Aut sit consequatur qui provident sit hic voluptatem minus voluptatum.	kpi	t	11	145
165	1	t	\N		document	t	11	146
166	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	147
167	1	t	[{"name":"1","header":"Planned Installment #","columns":[{"name":"Disbursement Date","value":"","dataType":"date"},{"name":"Actual Disbursement","value":"","dataType":"currency"},{"name":"Funds from other Sources","value":"","dataType":"currency"},{"name":"Notes","value":""}],"enteredByGrantee":false}]	Disbursement Details	disbursement	t	11	148
287	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	237
288	2	t	\N	Planned v/s Actuals Spends	multiline	t	11	237
289	6	t	\N		multiline	f	11	237
290	7	t	\N		multiline	f	11	237
291	8	t	\N		multiline	f	11	237
292	3	t	[{"name":"","columns":[{"name":"","value":""},{"name":"","value":""},{"name":"","value":""},{"name":"","value":""},{"name":"","value":""}],"enteredByGrantee":false}]		table	t	11	237
293	4	t	\N		multiline	t	11	237
294	5	t	\N		multiline	t	11	237
295	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	238
296	1	t	\N	UC till 31/3/2020	document	t	11	239
345	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	294
183	1	f	\N	Increase in additional training hours	kpi	t	11	163
184	2	t	\N		document	t	11	163
185	1	t	\N		document	t	11	164
186	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	165
187	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	166
188	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	167
189	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	168
190	1	t	[{"name":"1","header":"Planned Installment #","columns":[{"name":"Disbursement Date","value":"","dataType":"date"},{"name":"Actual Disbursement","value":"","dataType":"currency"},{"name":"Funds from other Sources","value":"","dataType":"currency"},{"name":"Notes","value":""}],"enteredByGrantee":false}]	Disbursement Details	disbursement	t	11	169
346	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	295
347	2	t	\N	Planned v/s Actuals Spends	disbursement	t	11	295
348	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	296
349	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	297
350	1	t	\N	How many installations were completed	kpi	t	11	298
351	1	t	\N		document	t	11	299
849	1	t	\N	1.\tIntroduction to the project (Give a small synopsis of the project) 	multiline	t	11	656
850	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	657
851	2	f	\N	Installation of Solar Powering System 	kpi	t	11	657
852	3	f	\N	Farmers benefitted directly 	kpi	t	11	657
853	4	t	\N		multiline	f	11	657
854	1	t	\N		document	t	11	658
855	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	659
856	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	660
857	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	660
858	1	t	\N	Disbursement Details	disbursement	t	11	661
885	1	t	\N		document	t	11	677
886	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	678
935	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	703
765	1	t	\N	Please describe AWP briefly (100-200 words)	multiline	t	11	607
766	2	t	\N		document	t	11	607
802	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	624
803	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	625
804	1	f	\N	Number of apricot dryers implemented	kpi	t	11	626
805	2	f	\N	Direct beneficiaries of apricot dryers	kpi	t	11	626
806	3	f	\N	Number of lambing shed implemented	kpi	t	11	626
807	4	f	\N	Direct beneficiaries of lambing shed	kpi	t	11	626
808	5	f	\N	Number of improvised greenhouse implemented	kpi	t	11	626
809	6	f	\N	Direct beneficiaries of improvised greenhouse	kpi	t	11	626
810	7	f	\N	Number of solar lift irrigation implemented	kpi	t	11	626
811	8	f	\N	Direct beneficiaries of solar lift irrigation	kpi	t	11	626
860	1	t	\N	1.\tIntroduction to the project (Give a small synopsis of the project) 	multiline	t	11	663
861	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	664
862	2	f	\N	Installation of Solar Powering System 	kpi	t	11	664
863	3	f	\N	Farmers benefitted directly 	kpi	t	11	664
864	4	t	\N		multiline	f	11	664
865	5	t	\N		multiline	f	11	664
866	1	t	\N		document	t	11	665
867	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	666
868	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	667
869	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	667
870	1	t	\N	Disbursement Details	disbursement	t	11	668
887	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	679
888	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	679
889	1	t	\N	Disbursement Details	disbursement	t	11	680
890	1	t	\N		multiline	t	11	681
891	1	t	\N	1.\tIntroduction to the project (Give a small synopsis of the project) 	multiline	t	11	682
892	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	683
893	2	f	\N	Installation of Solar Powering System 	kpi	t	11	683
894	3	f	\N	Farmers benefitted directly 	kpi	t	11	683
895	4	t	\N		multiline	t	11	683
908	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	690
909	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	690
910	1	t	\N	Disbursement Details	disbursement	t	11	691
911	1	t	\N	1.\tIntroduction to the project (Give a small synopsis of the project) 	multiline	t	11	692
912	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	693
913	2	f	\N	Installation of Solar Powering System 	kpi	t	11	693
914	3	f	\N	Farmers benefitted directly 	kpi	t	11	693
924	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	698
925	1	t	\N	Disbursement Details	disbursement	t	11	699
812	9	f	\N	Number of sheep shearers implemented	kpi	t	11	626
813	10	f	\N	Direct beneficiaries of sheep shearers 	kpi	t	11	626
814	1	t	\N		document	t	11	627
815	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	628
816	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	629
817	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	629
818	1	t	\N	Disbursement Details	disbursement	t	11	630
819	1	t	\N		document	t	11	631
926	1	t	\N	1.\tIntroduction to the project (Give a small synopsis of the project) 	multiline	t	11	700
927	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	701
839	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	648
840	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	649
841	1	f	\N	Number of Agro-processing units that can be run by Pine-needle fuelled 10 kW power plant (Nos.)	kpi	t	11	650
842	2	f	\N	Minimum number of hours of operation of Agro-processing units run by power plant (Hours)	kpi	t	11	650
843	1	t	\N		document	t	11	651
844	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	652
845	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	653
846	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	653
847	1	t	\N	Disbursement Details	disbursement	t	11	654
848	1	t	\N		document	t	11	655
872	1	t	\N	1.\tIntroduction to the project (Give a small synopsis of the project) 	multiline	t	11	670
873	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	671
874	2	f	\N	Installation of Solar Powering System 	kpi	t	11	671
875	3	f	\N	Farmers benefitted directly 	kpi	t	11	671
876	4	t	\N		multiline	t	11	671
877	5	t	\N		multiline	t	11	671
878	6	t	\N		multiline	f	11	671
879	1	t	\N		document	t	11	672
880	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	673
881	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	674
882	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	674
883	1	t	\N	Disbursement Details	disbursement	t	11	675
897	1	t	\N		document	t	11	684
1187	1	t	\N	Kindly attach utilisation certificate 	document	t	11	855
898	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	685
899	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	686
900	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	686
901	1	t	\N	Disbursement Details	disbursement	t	11	687
902	1	t	\N	1.\tIntroduction to the project (Give a small synopsis of the project) 	multiline	t	11	688
903	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	689
904	2	f	\N	Installation of Solar Powering System 	kpi	t	11	689
905	3	f	\N	Farmers benefitted directly 	kpi	t	11	689
906	4	t	\N		multiline	t	11	689
916	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	694
917	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	694
918	1	t	\N	Disbursement Details	disbursement	t	11	695
919	1	t	\N	1.\tIntroduction to the project (Give a small synopsis of the project) 	multiline	t	11	696
920	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	697
921	2	f	\N	Installation of Solar Powering System 	kpi	t	11	697
922	3	f	\N	Farmers benefitted directly 	kpi	t	11	697
928	2	f	\N	Installation of Solar Powering System 	kpi	t	11	701
929	3	f	\N	Farmers benefitted directly 	kpi	t	11	701
931	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	702
932	2	f	\N	Installation of Solar Powering System 	kpi	t	11	702
933	3	f	\N	Farmers benefitted directly 	kpi	t	11	702
936	2	f	\N	Installation of Solar Powering System 	kpi	t	11	703
937	3	f	\N	Farmers benefitted directly 	kpi	t	11	703
938	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	704
939	2	f	\N	Installation of Solar Powering System 	kpi	t	11	704
940	3	f	\N	Farmers benefitted directly 	kpi	t	11	704
942	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	705
943	2	f	\N	Installation of Solar Powering System 	kpi	t	11	705
944	3	f	\N	Farmers benefitted directly 	kpi	t	11	705
946	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	706
947	2	f	\N	Installation of Solar Powering System 	kpi	t	11	706
948	3	f	\N	Farmers benefitted directly 	kpi	t	11	706
950	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	707
951	2	f	\N	Installation of Solar Powering System 	kpi	t	11	707
952	3	f	\N	Farmers benefitted directly 	kpi	t	11	707
954	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	708
955	2	f	\N	Installation of Solar Powering System 	kpi	t	11	708
956	3	f	\N	Farmers benefitted directly 	kpi	t	11	708
958	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	709
959	2	f	\N	Installation of Solar Powering System 	kpi	t	11	709
960	3	f	\N	Farmers benefitted directly 	kpi	t	11	709
962	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	710
963	2	f	\N	Installation of Solar Powering System 	kpi	t	11	710
964	3	f	\N	Farmers benefitted directly 	kpi	t	11	710
965	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	711
966	2	f	\N	Installation of Solar Powering System 	kpi	t	11	711
967	3	f	\N	Farmers benefitted directly 	kpi	t	11	711
968	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	712
969	2	f	\N	Installation of Solar Powering System 	kpi	t	11	712
970	3	f	\N	Farmers benefitted directly 	kpi	t	11	712
971	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null}]	Planned v/s Actuals Spends	table	t	11	713
972	1	t	\N	Disbursement Details	disbursement	t	11	714
973	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	715
974	2	f	\N	Installation of Solar Powering System 	kpi	t	11	715
975	3	f	\N	Farmers benefitted directly 	kpi	t	11	715
1099	1	t	\N	Progress report (kindly fill the report attach)	document	t	11	801
1100	1	t	\N	Kindly attach the Utilisation Certificate here 	document	t	11	802
1183	1	f	\N	Installation of Godaam Sense unit 	kpi	t	11	854
1184	2	f	\N	Installation of Solar Powering System 	kpi	t	11	854
1185	3	f	\N	Farmers benefitted directly 	kpi	t	11	854
1186	5	t	\N	Give a brief description on the planning and implementation as given above, This should consist of a narrative of activities implemented per Intermediate Result Area, and include what was planned versus what was actually achieved.	multiline	t	11	854
1188	1	t	\N	Disbursement Details	disbursement	t	11	856
1189	2	t	\N	Kindly attach photographs 	document	t	11	857
1190	1	t	\N	Kindly fill QPR attach 	document	t	11	858
1204	1	t	\N	Describe the major activities of the project achieved during this reporting period ( List as many as possible.)	multiline	t	11	873
1205	1	t	\N		document	t	11	875
1206	1	t	\N	Describe the project challenges encountered and mitigations for this reporting period (List as many as possible).	multiline	t	11	876
1207	1	t	\N	Describe reasons for deviations  of planned vs actuals spends on the project (if any)	multiline	t	11	877
1208	2	t	[{"name":"Amounts (in INR)","columns":[{"name":"Approved (Grant Level)","value":""},{"name":"Spent (Grant Level)","value":""},{"name":"Planned (Report period)","value":""},{"name":"Spent (Report period)","value":""},{"name":"","value":""}],"enteredByGrantee":false,"status":false,"saved":false,"actualDisbursementId":null,"disbursementId":null,"reportId":null,"showForGrantee":true}]	Planned v/s Actuals Spends	table	t	11	877
1209	1	t	\N		document	t	11	878
1210	1	t	\N	Who is this project for? (List beneficiaries)	multiline	t	11	879
1062	1	f	\N	Installation of Biogas Systems with BAIF filters (IRESA unit)	kpi	t	11	769
1063	2	f	\N	PROM Enterprise Establishment & Development	kpi	t	11	769
1064	3	f	\N	Farmers benefitted directly 	kpi	t	11	769
1065	1	t	\N	Disbursement Details	disbursement	t	11	770
1066	1	t	\N	Kindly attach utilisation certificate 	document	t	11	771
1067	1	t	\N	Kindky fill the report attach 	document	t	11	772
\.


--
-- TOC entry 3653 (class 0 OID 122712)
-- Dependencies: 263
-- Data for Name: granter_report_sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.granter_report_sections (id, deletable, section_name, section_order, report_template_id, granter_id) FROM stdin;
7	t	Project Summary	1	2	11
8	t	Project Activities & Highlights	2	2	11
9	t	Project Indicators	3	2	11
10	t	Learnings and best practices	4	2	11
11	t	Project Challenges	5	2	11
12	t	Financials	6	2	11
112	t	Learnings and best practices	4	20	11
113	t	Project Challenges	5	20	11
114	t	Project Summary	1	20	11
115	t	Project Activities & Highlights	2	20	11
116	t	Project Indicators	3	20	11
117	t	Project Summary	1	21	11
118	t	Project Activities & Highlights	2	21	11
119	t	Project Indicators	3	21	11
120	t	Learnings and best practices	4	21	11
121	t	Project Challenges	5	21	11
122	t	Disbursement Details	7	21	11
123	t	Project Summary	1	22	11
124	t	Project Activities & Highlights	2	22	11
125	t	Project Indicators	3	22	11
126	t	Learnings and best practices	4	22	11
127	t	Project Challenges	5	22	11
128	t	Disbursement Details	7	22	11
61	t	Project Summary	1	11	11
62	t	Project Activities & Highlights	2	11	11
63	t	Project Indicators	3	11	11
64	t	Learnings and best practices	4	11	11
65	t	Project Challenges	5	11	11
66	t	Financials	6	11	11
67	t	Project Summary	1	12	11
68	t	Project Activities & Highlights	2	12	11
69	t	Project Indicators	3	12	11
70	t	Learnings and best practices	4	12	11
71	t	Project Challenges	5	12	11
72	t	Financials	6	12	11
143	t	Project Summary	1	25	11
144	t	Project Activities & Highlights	2	25	11
145	t	Project Indicators	3	25	11
146	t	Learnings and best practices	4	25	11
147	t	Project Challenges	5	25	11
148	t	Disbursement Details	7	25	11
233	t	Project Summary	1	38	11
234	t	Project Indicators	3	38	11
235	t	Learnings and best practices	4	38	11
236	t	Project Challenges	5	38	11
237	t	Financials	6	38	11
238	t	Project Activities & Highlights	2	38	11
239	t	Documents	7	38	11
163	t	Project Indicators	3	28	11
164	t	Learnings and best practices	4	28	11
165	t	Project Challenges	5	28	11
166	t	Financials	6	28	11
167	t	Project Activities & Highlights	2	28	11
168	t	Project Summary	1	28	11
169	t	Disbursement Details	7	28	11
184	t	Project Summary	1	31	11
185	t	Learnings and best practices	4	31	11
186	t	Project Challenges	5	31	11
187	t	Financials	6	31	11
188	t	Project Indicators	3	31	11
189	t	Project Activities & Highlights	2	31	11
190	t	Documents	7	31	11
270	t	Project Summary	1	44	11
271	t	Project Activities & Highlights	2	44	11
272	t	Project Indicators	3	44	11
273	t	Learnings and best practices	4	44	11
274	t	Project Challenges	5	44	11
275	t	Financials	6	44	11
276	t	Project Summary	1	45	11
277	t	Project Activities & Highlights	2	45	11
278	t	Project Indicators	3	45	11
279	t	Learnings and best practices	4	45	11
280	t	Project Challenges	5	45	11
281	t	Financials	6	45	11
294	t	Project Challenges	5	48	11
295	t	Financials	6	48	11
296	t	Project Summary	1	48	11
297	t	Project Activities & Highlights	2	48	11
298	t	Project Indicators	3	48	11
299	t	Learnings and best practices	4	48	11
300	t	Project Summary	1	49	11
301	t	Project Activities & Highlights	2	49	11
302	t	Project Indicators	3	50	11
303	t	Project Activities & Highlights	2	50	11
304	t	Project Indicators	3	51	11
305	t	Project Activities & Highlights	2	51	11
338	t	FCRA Submission	1	59	11
345	t	Project Challenges	5	61	11
346	t	Financials	6	61	11
347	t	Project Summary	1	61	11
318	t	Project Summary	1	54	11
319	t	Project Activities & Highlights	2	54	11
320	t	Project Indicators	3	54	11
321	t	Learnings and best practices	4	54	11
322	t	Project Challenges	5	54	11
323	t	Project Funds	7	54	11
348	t	Project Activities & Highlights	2	61	11
349	t	Project Indicators	3	61	11
350	t	Learnings and best practices	4	61	11
356	t	Project Indicators	3	63	11
357	t	Learnings and best practices	4	63	11
358	t	Project Challenges	5	63	11
359	t	Financials	6	63	11
447	t	Report Migration Note	1	89	11
448	t	Project Funding	6	89	11
449	t	Project Indicators	3	89	11
402	t	Project Funding	6	74	11
403	t	Project Indicators	3	74	11
404	t	Report Migration Note	1	74	11
656	t	Project Summary	1	124	11
657	t	Project Indicators	3	124	11
658	t	Learnings and best practices	4	124	11
659	t	Project Challenges	5	124	11
660	t	Financials	6	124	11
661	t	Project Funds	7	124	11
662	t	Planning and Implementation	2	124	11
663	t	Project Summary	1	125	11
664	t	Project Indicators	3	125	11
665	t	Learnings and best practices	4	125	11
666	t	Project Challenges	5	125	11
667	t	Financials	6	125	11
668	t	Project Funds	7	125	11
669	t	Planning and Implementation	2	125	11
670	t	Project Summary	1	126	11
671	t	Project Indicators	3	126	11
672	t	Learnings and best practices	4	126	11
673	t	Project Challenges	5	126	11
674	t	Financials	6	126	11
675	t	Project Funds	7	126	11
676	t	Planning and Implementation	2	126	11
677	t	Learnings and best practices	4	127	11
678	t	Project Challenges	5	127	11
679	t	Financials	6	127	11
680	t	Project Funds	7	127	11
681	t	Planning and Implementation	2	127	11
682	t	Project Summary	1	127	11
683	t	Project Indicators	3	127	11
684	t	Learnings and best practices	4	128	11
685	t	Project Challenges	5	128	11
686	t	Financials	6	128	11
687	t	Project Funds	7	128	11
688	t	Project Summary	1	128	11
689	t	Project Indicators	3	128	11
690	t	Financials	6	129	11
691	t	Project Funds	7	129	11
692	t	Project Summary	1	129	11
693	t	Project Indicators	3	129	11
694	t	Financials	6	130	11
695	t	Project Funds	7	130	11
696	t	Project Summary	1	130	11
697	t	Project Indicators	3	130	11
698	t	Financials	6	131	11
699	t	Project Funds	7	131	11
700	t	Project Summary	1	131	11
701	t	Project Indicators	3	131	11
702	t	Project Indicators	3	132	11
703	t	Project Indicators	3	133	11
704	t	Project Indicators	3	134	11
705	t	Project Indicators	3	135	11
706	t	Project Indicators	3	136	11
607	t	Project Summary	1	117	11
707	t	Project Indicators	3	137	11
708	t	Project Indicators	3	138	11
709	t	Project Indicators	3	139	11
710	t	Project Indicators	3	140	11
711	t	Project Indicators	3	141	11
712	t	Project Indicators	3	142	11
713	t	Financials	6	143	11
714	t	Project Funds	7	143	11
715	t	Project Indicators	3	143	11
854	t	Project Indicators	2	175	11
855	t	Financials	3	175	11
856	t	Project Funds	4	175	11
624	t	Project Summary	1	120	11
625	t	Project Activities & Highlights	2	120	11
626	t	Project Indicators	3	120	11
627	t	Learnings and best practices	4	120	11
628	t	Project Challenges	5	120	11
629	t	Financials	6	120	11
630	t	Project Funds	7	120	11
631	t	QPR	8	120	11
857	t	Photograph	5	175	11
858	t	Project report	1	175	11
873	t	Project Activities & Highlights	2	178	11
874	t	Project Indicators	3	178	11
648	t	Project Summary	1	123	11
649	t	Project Activities & Highlights	2	123	11
650	t	Project Indicators	3	123	11
651	t	Learnings and best practices	4	123	11
652	t	Project Challenges	5	123	11
653	t	Financials	6	123	11
654	t	Project Funds	7	123	11
655	t	QPR	8	123	11
875	t	Learnings and best practices	4	178	11
876	t	Project Challenges	5	178	11
877	t	Financials	6	178	11
878	t	Document	8	178	11
879	t	Project Summary	1	178	11
769	t	Project Indicators	3	156	11
770	t	Project Funds	7	156	11
771	t	Utilisation Certificate	8	156	11
772	t	Progress Report	9	156	11
801	t	Project Summary	1	164	11
802	t	Financials	6	164	11
\.


--
-- TOC entry 3655 (class 0 OID 122718)
-- Dependencies: 265
-- Data for Name: granter_report_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.granter_report_templates (id, description, granter_id, name, published, private_to_report, default_template) FROM stdin;
2	Default Anudan template	11	Default Anudan template	t	f	t
12	\N	11	undefined	t	t	\N
11	\N	11	undefined	t	t	\N
20	\N	11	undefined	t	t	\N
21	\N	11	undefined	t	t	\N
22	\N	11	undefined	t	t	\N
89	\N	11	undefined	t	t	\N
25	\N	11	undefined	t	t	\N
28	\N	11	undefined	t	t	\N
31	\N	11	undefined	t	t	\N
38	\N	11	undefined	t	t	\N
44	\N	11	Custom Template	f	f	\N
45	\N	11	undefined	t	t	\N
48	\N	11	undefined	t	t	\N
49	\N	11	Custom Template	f	f	\N
50	\N	11	Custom Template	f	f	\N
51	\N	11	Custom Template	f	f	\N
54	\N	11	undefined	t	t	\N
59	\N	11	Custom Template	f	f	\N
61	\N	11	Custom Template	f	f	\N
63	\N	11	Custom Template	f	f	\N
74	Simplified template for migrating previously approved reports	11	Migration of previously approved reports	t	f	\N
117	\N	11	undefined	t	t	\N
120	\N	11	Custom Template	f	f	\N
123	\N	11	Custom Template	f	f	\N
124	\N	11	Custom Template	f	f	\N
125	\N	11	Custom Template	f	f	\N
126	\N	11	Custom Template	f	f	\N
127	\N	11	Custom Template	f	f	\N
128	\N	11	Custom Template	f	f	\N
129	\N	11	Custom Template	f	f	\N
130	\N	11	Custom Template	f	f	\N
131	\N	11	Custom Template	f	f	\N
132	\N	11	Custom Template	f	f	\N
133	\N	11	Custom Template	f	f	\N
134	\N	11	Custom Template	f	f	\N
135	\N	11	Custom Template	f	f	\N
136	\N	11	Custom Template	f	f	\N
137	\N	11	Custom Template	f	f	\N
138	\N	11	Custom Template	f	f	\N
139	\N	11	Custom Template	f	f	\N
140	\N	11	Custom Template	f	f	\N
141	\N	11	Custom Template	f	f	\N
142	\N	11	Custom Template	f	f	\N
143	\N	11	Custom Template	f	f	\N
156	\N	11	undefined	t	t	\N
164		11	Siddharth	t	f	\N
175	\N	11	undefined	t	t	\N
178	\N	11	Custom Template	f	f	\N
\.


--
-- TOC entry 3656 (class 0 OID 122727)
-- Dependencies: 266
-- Data for Name: granters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.granters (host_url, image_name, navbar_color, navbar_text_color, id) FROM stdin;
sustainplus	temporg.png	#232323	#fff	11
\.


--
-- TOC entry 3640 (class 0 OID 122653)
-- Dependencies: 250
-- Data for Name: grants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grants (id, amount, created_at, created_by, description, end_date, name, representative, start_date, status_name, template_id, updated_at, updated_by, grant_status_id, grantor_org_id, organization_id, substatus_id, note, note_added, note_added_by, moved_on, reference_no, deleted, amended, orig_grant_id, amend_grant_id, amendment_no) FROM stdin;
\.


--
-- TOC entry 3658 (class 0 OID 122735)
-- Dependencies: 268
-- Data for Name: grants_to_verify; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grants_to_verify (status, moved_on, reference_no, concat) FROM stdin;
Active	2020-08-22 18:25:00	ADVA-2009-2206-1	: 1\nAmount: 1593000\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nNotes: 
Active	2020-08-22 18:25:00	ADVA-2009-2206-1	: 2\nAmount: 1571700\nDate/Period: March 2021\nFunds from other Sources: 274000\nNotes: 
Active	2020-08-22 18:25:00	ADVA-2009-2206-1	: 3\nAmount: 2685300\nDate/Period: September 2021\nFunds from other Sources: 274000\nNotes: 
Active	2020-09-14 10:37:00	AVAN-2009-2108-3	: 1\nAmount: 1200000\nDate/Period: September 2020\nFunds from other Sources: \nNotes: 
Active	2020-09-14 10:37:00	AVAN-2009-2108-3	: 2\nAmount: 1006000\nDate/Period: February 2021\nFunds from other Sources: 1157000\nNotes: 
Active	2020-09-23 13:43:00	PRAV-2007-2206-5	Planned Installment #: 1\nAmount: 32843000\nDate/Period: September 2020\nFunds from other Sources: \nNotes: 
Active	2020-09-23 13:43:00	PRAV-2007-2206-5	Planned Installment #: 2\nAmount: 16672000\nDate/Period: June 2021\nFunds from other Sources: 62895750\nNotes: 
Active	2020-09-23 13:43:00	PRAV-2007-2206-5	Planned Installment #: 3\nAmount: 16672000\nDate/Period: November 2021\nFunds from other Sources: 62895750\nNotes: 
Active	2020-09-23 15:01:00	TAGO-2007-2206-6	Planned Installment #: 1\nAmount: 31511200\nDate/Period: September 2020\nFunds from other Sources: \nNotes: 
Active	2020-09-23 15:01:00	TAGO-2007-2206-6	Planned Installment #: 2\nAmount: 17612900\nDate/Period: June 2021\nFunds from other Sources: 63020020\nNotes: 
Active	2020-09-23 15:01:00	TAGO-2007-2206-6	Planned Installment #: 3\nAmount: 17612900\nDate/Period: November 2021\nFunds from other Sources: 63020020\nNotes: 
Active	2020-09-23 15:03:00	RURA-2007-2206-7	Planned Installment #: 1\nAmount: 32003000\nDate/Period: September 2020\nFunds from other Sources: \nNotes: 
Active	2020-09-23 15:03:00	RURA-2007-2206-7	Planned Installment #: 2\nAmount: 17432000\nDate/Period: June 2021\nFunds from other Sources: 64994830\nNotes: 
Active	2020-09-23 15:03:00	RURA-2007-2206-7	Planned Installment #: 3\nAmount: 17432000\nDate/Period: November 2021\nFunds from other Sources: 64994830\nNotes: 
Active	2020-09-23 15:04:00	NAVB-2007-2206-8	Planned Installment #: 1\nAmount: 32391550\nDate/Period: September 2020\nFunds from other Sources: \nNotes: 
Active	2020-09-23 15:04:00	NAVB-2007-2206-8	Planned Installment #: 2\nAmount: 17083750\nDate/Period: June 2021\nFunds from other Sources: 63005240\nNotes: 
Active	2020-09-23 15:04:00	NAVB-2007-2206-8	Planned Installment #: 3\nAmount: 17083700\nDate/Period: November 2021\nFunds from other Sources: 63005240\nNotes: 
Active	2020-09-23 15:08:00	PROF-2008-2206-10	Planned Installment #: 1\nAmount: 31977700\nDate/Period: September 2020\nFunds from other Sources: \nNotes: 
Active	2020-09-23 15:08:00	PROF-2008-2206-10	Planned Installment #: 2\nAmount: 17527300\nDate/Period: June 2021\nFunds from other Sources: 114516280\nNotes: 
Active	2020-09-23 15:08:00	PROF-2008-2206-10	Planned Installment #: 3\nAmount: 17527000\nDate/Period: November 2021\nFunds from other Sources: 114516280\nNotes: 
CEO/ED Approval	2020-08-21 19:59:00	\N	: 1\nAmount: 1593000\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nNotes: 
CEO/ED Approval	2020-08-21 19:59:00	\N	: 2\nAmount: 1571700\nDate/Period: March 2021\nFunds from other Sources: 274000\nNotes: 
CEO/ED Approval	2020-08-21 19:59:00	\N	: 3\nAmount: 2685300\nDate/Period: September 2021\nFunds from other Sources: 274000\nNotes: 
CEO/ED Approval	2020-09-14 09:56:00	\N	: 1\nAmount: 1200000\nDate/Period: September 2020\nFunds from other Sources: \nNotes: 
CEO/ED Approval	2020-09-14 09:56:00	\N	: 2\nAmount: 1006000\nDate/Period: February 2021\nFunds from other Sources: 1157000\nNotes: 
CEO/ED Approval	2020-09-21 17:28:00	\N	Planned Installment #: 1\nAmount: 32391550\nAmount: 32391550\nAmount: 32391550\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-21 17:28:00	\N	Planned Installment #: 2\nAmount: 17083750\nAmount: 17083750\nAmount: 17083750\nDate/Period: June 2021\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-21 17:28:00	\N	Planned Installment #: 3\nAmount: 17083700\nAmount: 17083700\nAmount: 17083700\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-21 19:54:00	\N	Planned Installment #: 1\nAmount: 32003000\nAmount: 32003000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-21 19:54:00	\N	Planned Installment #: 2\nAmount: 17432000\nAmount: 17432000\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
CEO/ED Approval	2020-09-21 19:54:00	\N	Planned Installment #: 3\nAmount: 17432000\nAmount: 17432000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
CEO/ED Approval	2020-09-22 12:51:00	\N	Planned Installment #: 1\nAmount: 31511200\nAmount: 31511200\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-22 12:51:00	\N	Planned Installment #: 2\nAmount: 17612900\nAmount: 17612900\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63020020\nFunds from other Sources: 63020020\nNotes: \nNotes: 
CEO/ED Approval	2020-09-22 12:51:00	\N	Planned Installment #: 3\nAmount: 17612900\nAmount: 17612900\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63020020\nFunds from other Sources: 63020020\nNotes: \nNotes: 
CEO/ED Approval	2020-09-22 15:57:00	\N	Planned Installment #: 1\nAmount: 32843000\nAmount: 32843000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-22 15:57:00	\N	Planned Installment #: 2\nAmount: 16672000\nAmount: 16672000\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 62895750\nFunds from other Sources: 62895750\nNotes: \nNotes: 
CEO/ED Approval	2020-09-22 15:57:00	\N	Planned Installment #: 3\nAmount: 16672000\nAmount: 16672000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 62895750\nFunds from other Sources: 62895750\nNotes: \nNotes: 
CEO/ED Approval	2020-09-22 17:24:00	\N	Planned Installment #: 1\nAmount: 31977700\nAmount: 31977700\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-22 17:24:00	\N	Planned Installment #: 2\nAmount: 17527300\nAmount: 17527300\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nNotes: \nNotes: 
CEO/ED Approval	2020-09-22 17:24:00	\N	Planned Installment #: 3\nAmount: 17527000\nAmount: 17527000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:44:00	\N	Planned Installment #: 1\nAmount: 32391550\nAmount: 32391550\nAmount: 32391550\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:44:00	\N	Planned Installment #: 2\nAmount: 17083750\nAmount: 17083750\nAmount: 17083750\nDate/Period: June 2021\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:44:00	\N	Planned Installment #: 3\nAmount: 17083700\nAmount: 17083700\nAmount: 17083700\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:45:00	\N	Planned Installment #: 1\nAmount: 31977700\nAmount: 31977700\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:45:00	\N	Planned Installment #: 2\nAmount: 17527300\nAmount: 17527300\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:45:00	\N	Planned Installment #: 3\nAmount: 17527000\nAmount: 17527000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:49:00	\N	Planned Installment #: 1\nAmount: 32391550\nAmount: 32391550\nAmount: 32391550\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:49:00	\N	Planned Installment #: 2\nAmount: 17083750\nAmount: 17083750\nAmount: 17083750\nDate/Period: June 2021\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:49:00	\N	Planned Installment #: 3\nAmount: 17083700\nAmount: 17083700\nAmount: 17083700\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:50:00	\N	Planned Installment #: 1\nAmount: 32003000\nAmount: 32003000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:50:00	\N	Planned Installment #: 2\nAmount: 17432000\nAmount: 17432000\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:50:00	\N	Planned Installment #: 3\nAmount: 17432000\nAmount: 17432000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:52:00	\N	Planned Installment #: 1\nAmount: 31511200\nAmount: 31511200\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:52:00	\N	Planned Installment #: 2\nAmount: 17612900\nAmount: 17612900\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63020020\nFunds from other Sources: 63020020\nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:52:00	\N	Planned Installment #: 3\nAmount: 17612900\nAmount: 17612900\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63020020\nFunds from other Sources: 63020020\nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:53:00	\N	Planned Installment #: 1\nAmount: 32843000\nAmount: 32843000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:53:00	\N	Planned Installment #: 2\nAmount: 16672000\nAmount: 16672000\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 62895750\nFunds from other Sources: 62895750\nNotes: \nNotes: 
CEO/ED Approval	2020-09-23 12:53:00	\N	Planned Installment #: 3\nAmount: 16672000\nAmount: 16672000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 62895750\nFunds from other Sources: 62895750\nNotes: \nNotes: 
Draft	2020-08-20 13:15:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-20 13:15:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-20 13:15:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-20 13:23:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-20 13:23:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-09-02 16:16:00	\N	Planned Installment #: 1\nAmount: 5803500\nAmount: 5803500\nAmount: 5872920\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-20 13:23:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-20 17:44:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-20 17:44:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-20 17:44:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-21 10:05:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-21 10:05:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-21 10:05:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-21 10:16:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-21 10:16:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-21 10:16:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-21 10:58:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-21 10:58:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-08-21 10:58:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-09-02 10:09:00	\N	: 1\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: Initial Disbursement\nNotes: Initial Disbursement
Draft	2020-09-02 10:09:00	\N	: 2\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nNotes: \nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC
GMT Review	2020-08-21 11:21:00	\N	: 2\nAmount: 1571700\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: 
Draft	2020-09-02 16:16:00	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 13928400\nAmount: 14095008\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 23019216\nNotes: \nNotes: \nNotes: 
Draft	2020-09-02 16:16:00	\N	Planned Installment #: 3\nAmount: 23200300\nAmount: 23200300\nAmount: 23241971\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 57548040\nNotes: \nNotes: \nNotes: 
Draft	2020-09-02 16:16:00	\N	Planned Installment #: 4\nAmount: 24100045\nAmount: 24100104\nAmount: 24100104\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 92076864\nNotes: \nNotes: \nNotes: 
Draft	2020-09-02 16:16:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 57548040\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nNotes: \nNotes: \nNotes: 
Draft	2020-09-07 09:22:00	\N	: 1\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: Initial Disbursement\nNotes: Initial Disbursement
Draft	2020-09-07 09:22:00	\N	: 2\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nNotes: \nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC
Draft	2020-09-14 16:03:00	\N	Planned Installment #: 1\nAmount: 7877800\nAmount: 9092600\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
Draft	2020-09-14 16:03:00	\N	Planned Installment #: 2\nAmount: 18906700\nAmount: 21822300\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12604000\nFunds from other Sources: 13697040\nNotes: \nNotes: 
Draft	2020-09-14 16:03:00	\N	Planned Installment #: 3\nAmount: 20578300\nAmount: 22661300\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 31510000\nFunds from other Sources: 34242600\nNotes: \nNotes: 
Draft	2020-09-14 16:03:00	\N	Planned Installment #: 4\nAmount: 19374200\nAmount: 21029300\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 50416000\nFunds from other Sources: 54788160\nNotes: \nNotes: 
Draft	2020-09-14 16:03:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 31510040\nFunds from other Sources: 34242600\nNotes: \nNotes: 
Draft	2020-09-14 16:05:00	\N	Planned Installment #: 1\nAmount: 7163100\nAmount: 8000700\nAmount: 8162000\nAmount: 8210800\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-09-14 16:05:00	\N	Planned Installment #: 2\nAmount: 17191300\nAmount: 19201800\nAmount: 19588800\nAmount: 19705800\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12579200\nFunds from other Sources: 12999000\nFunds from other Sources: 14687440\nFunds from other Sources: 9129510\nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-09-14 16:05:00	\N	Planned Installment #: 3\nAmount: 18503800\nAmount: 19931000\nAmount: 20489200\nAmount: 21119100\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 22823775\nFunds from other Sources: 31447900\nFunds from other Sources: 32497400\nFunds from other Sources: 36718600\nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-09-14 16:05:00	\N	Planned Installment #: 4\nAmount: 17362800\nAmount: 18338900\nAmount: 19175250\nAmount: 19826800\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 36518040\nFunds from other Sources: 50316600\nFunds from other Sources: 51995900\nFunds from other Sources: 58749760\nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-09-14 16:05:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 22823775\nFunds from other Sources: 31447800\nFunds from other Sources: 32497360\nFunds from other Sources: 36718600\nNotes: \nNotes: \nNotes: \nNotes: 
Draft	2020-09-14 16:07:00	\N	Planned Installment #: 1\nAmount: 8097900\nAmount: 8140900\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
Draft	2020-09-14 16:07:00	\N	Planned Installment #: 2\nAmount: 19434900\nAmount: 19538100\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12601000\nFunds from other Sources: 14070000\nNotes: \nNotes: 
Draft	2020-09-14 16:07:00	\N	Planned Installment #: 3\nAmount: 20059600\nAmount: 20234100\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 31502600\nFunds from other Sources: 35175000\nNotes: \nNotes: 
Draft	2020-09-14 16:07:00	\N	Planned Installment #: 4\nAmount: 18547400\nAmount: 18792150\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 50404200\nFunds from other Sources: 56280000\nNotes: \nNotes: 
Draft	2020-09-14 16:07:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 31502680\nFunds from other Sources: 35175000\nNotes: \nNotes: 
Draft	2020-09-15 17:17:00	\N	Planned Installment #: 1\nAmount: 5803500\nAmount: 5803500\nAmount: 5872920\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
Draft	2020-09-15 17:17:00	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 13928400\nAmount: 14095008\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 23019216\nNotes: \nNotes: \nNotes: 
Draft	2020-09-15 17:17:00	\N	Planned Installment #: 3\nAmount: 23200300\nAmount: 23200300\nAmount: 23241971\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 57548040\nNotes: \nNotes: \nNotes: 
Draft	2020-09-15 17:17:00	\N	Planned Installment #: 4\nAmount: 24100045\nAmount: 24100104\nAmount: 24100104\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 92076864\nNotes: \nNotes: \nNotes: 
Draft	2020-09-15 17:17:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 57548040\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nNotes: \nNotes: \nNotes: 
Draft	\N	\N	: 1\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: Initial Disbursement\nNotes: Initial Disbursement
Draft	\N	\N	: 2\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC
Draft	\N	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	\N	\N	Planned Installment #: 1\nAmount: 5803500\nAmount: 5803500\nAmount: 5872920\nAmount: 7163100\nAmount: 7877800\nAmount: 8000700\nAmount: 8097900\nAmount: 8140900\nAmount: 8162000\nAmount: 8210800\nAmount: 9092600\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	\N	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 13928400\nAmount: 14095008\nAmount: 17191300\nAmount: 18906700\nAmount: 19201800\nAmount: 19434900\nAmount: 19538100\nAmount: 19588800\nAmount: 19705800\nAmount: 21822300\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 12579200\nFunds from other Sources: 12601000\nFunds from other Sources: 12604000\nFunds from other Sources: 12999000\nFunds from other Sources: 13697040\nFunds from other Sources: 14070000\nFunds from other Sources: 14687440\nFunds from other Sources: 23019216\nFunds from other Sources: 9129510\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	\N	\N	Planned Installment #: 3\nAmount: 18503800\nAmount: 19931000\nAmount: 20059600\nAmount: 20234100\nAmount: 20489200\nAmount: 20578300\nAmount: 21119100\nAmount: 22661300\nAmount: 23200300\nAmount: 23200300\nAmount: 23241971\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 22823775\nFunds from other Sources: 31447900\nFunds from other Sources: 31502600\nFunds from other Sources: 31510000\nFunds from other Sources: 32497400\nFunds from other Sources: 34242600\nFunds from other Sources: 35175000\nFunds from other Sources: 36718600\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 57548040\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	\N	\N	Planned Installment #: 4\nAmount: 17362800\nAmount: 18338900\nAmount: 18547400\nAmount: 18792150\nAmount: 19175250\nAmount: 19374200\nAmount: 19826800\nAmount: 21029300\nAmount: 24100045\nAmount: 24100104\nAmount: 24100104\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 36518040\nFunds from other Sources: 50316600\nFunds from other Sources: 50404200\nFunds from other Sources: 50416000\nFunds from other Sources: 51995900\nFunds from other Sources: 54788160\nFunds from other Sources: 56280000\nFunds from other Sources: 58749760\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 92076864\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Draft	\N	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 22823775\nFunds from other Sources: 31447800\nFunds from other Sources: 31502680\nFunds from other Sources: 31510040\nFunds from other Sources: 32497360\nFunds from other Sources: 34242600\nFunds from other Sources: 35175000\nFunds from other Sources: 36718600\nFunds from other Sources: 57548040\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
GMT Review	2020-08-20 10:39:00	\N	: 1\nAmount: 1593000\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-08-20 10:39:00	\N	: 2\nAmount: 1571700\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: 
GMT Review	2020-08-20 10:39:00	\N	: 3\nAmount: 2685300\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: 
GMT Review	2020-08-21 11:21:00	\N	: 1\nAmount: 1593000\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-08-21 11:21:00	\N	: 3\nAmount: 2685300\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: 
GMT Review	2020-09-02 10:48:00	\N	: 1\nAmount: 1200000\nAmount: 1200000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: Initial Disbursement
GMT Review	2020-09-02 10:48:00	\N	: 2\nAmount: 1006000\nAmount: 1006000\nDate/Period: February 2021\nDate/Period: February 2021\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nNotes: \nNotes: Disbursement based on submission of previous quarter's QPR and UC
GMT Review	2020-09-07 12:37:00	\N	: 1\nAmount: 1200000\nAmount: 1200000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: Initial Disbursement
GMT Review	2020-09-07 12:37:00	\N	: 2\nAmount: 1006000\nAmount: 1006000\nDate/Period: February 2021\nDate/Period: February 2021\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nNotes: \nNotes: Disbursement based on submission of previous quarter's QPR and UC
GMT Review	2020-09-08 17:28:00	\N	Planned Installment #: 1\nAmount: 31977700\nAmount: 31977700\nAmount: 5803500\nDate/Period: August 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-08 17:28:00	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 17527300\nAmount: 17527300\nDate/Period: June 2021\nDate/Period: June 2021\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-08 17:28:00	\N	Planned Installment #: 3\nAmount: 17527000\nAmount: 17527000\nAmount: 23200300\nDate/Period: May 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nFunds from other Sources: 45806500\nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-08 17:28:00	\N	Planned Installment #: 4\nAmount: 24100104\nDate/Period: November 2021\nFunds from other Sources: 91613000\nNotes: 
GMT Review	2020-09-08 17:28:00	\N	Planned Installment #: 5\nAmount: \nDate/Period: June 2022\nFunds from other Sources: 80161460\nNotes: 
GMT Review	2020-09-17 12:48:00	\N	Planned Installment #: 1\nAmount: 31977700\nAmount: 31977700\nAmount: 5803500\nDate/Period: August 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-17 12:48:00	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 17527300\nAmount: 17527300\nDate/Period: June 2021\nDate/Period: June 2021\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-17 12:48:00	\N	Planned Installment #: 3\nAmount: 17527000\nAmount: 17527000\nAmount: 23200300\nDate/Period: May 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nFunds from other Sources: 45806500\nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-17 12:48:00	\N	Planned Installment #: 4\nAmount: 24100104\nDate/Period: November 2021\nFunds from other Sources: 91613000\nNotes: 
GMT Review	2020-09-17 12:48:00	\N	Planned Installment #: 5\nAmount: \nDate/Period: June 2022\nFunds from other Sources: 80161460\nNotes: 
GMT Review	2020-09-20 20:43:00	\N	Planned Installment #: 1\nAmount: 32843000\nAmount: 32843000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-20 20:43:00	\N	Planned Installment #: 2\nAmount: 16672000\nAmount: 16672000\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 62895750\nFunds from other Sources: 62895750\nNotes: \nNotes: 
GMT Review	2020-09-20 20:43:00	\N	Planned Installment #: 3\nAmount: 16672000\nAmount: 16672000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 62895750\nFunds from other Sources: 62895750\nNotes: \nNotes: 
GMT Review	2020-09-20 20:53:00	\N	Planned Installment #: 1\nAmount: 32003000\nAmount: 32003000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-20 20:53:00	\N	Planned Installment #: 2\nAmount: 17432000\nAmount: 17432000\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
GMT Review	2020-09-20 20:53:00	\N	Planned Installment #: 3\nAmount: 17432000\nAmount: 17432000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
GMT Review	2020-09-20 20:56:00	\N	Planned Installment #: 1\nAmount: 31511200\nAmount: 31511200\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-20 20:56:00	\N	Planned Installment #: 2\nAmount: 17612900\nAmount: 17612900\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63020020\nFunds from other Sources: 63020020\nNotes: \nNotes: 
GMT Review	2020-09-20 20:56:00	\N	Planned Installment #: 3\nAmount: 17612900\nAmount: 17612900\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63020020\nFunds from other Sources: 63020020\nNotes: \nNotes: 
GMT Review	2020-09-20 21:00:00	\N	Planned Installment #: 1\nAmount: 32003000\nAmount: 32003000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-20 21:00:00	\N	Planned Installment #: 2\nAmount: 17432000\nAmount: 17432000\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
GMT Review	2020-09-20 21:00:00	\N	Planned Installment #: 3\nAmount: 17432000\nAmount: 17432000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
GMT Review	2020-09-20 21:06:00	\N	Planned Installment #: 1\nAmount: 32391550\nAmount: 32391550\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-20 21:06:00	\N	Planned Installment #: 2\nAmount: 17083750\nAmount: 17083750\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-20 21:06:00	\N	Planned Installment #: 3\nAmount: 17083700\nAmount: 17083700\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-20 21:10:00	\N	Planned Installment #: 1\nAmount: 32391550\nAmount: 32391550\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-20 21:10:00	\N	Planned Installment #: 2\nAmount: 17083750\nAmount: 17083750\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-20 21:10:00	\N	Planned Installment #: 3\nAmount: 17083700\nAmount: 17083700\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-20 21:19:00	\N	Planned Installment #: 1\nAmount: 32391550\nAmount: 32391550\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-20 21:19:00	\N	Planned Installment #: 2\nAmount: 17083750\nAmount: 17083750\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-20 21:19:00	\N	Planned Installment #: 3\nAmount: 17083700\nAmount: 17083700\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-20 21:44:00	\N	Planned Installment #: 1\nAmount: 32391550\nAmount: 32391550\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-20 21:44:00	\N	Planned Installment #: 2\nAmount: 17083750\nAmount: 17083750\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-20 21:44:00	\N	Planned Installment #: 3\nAmount: 17083700\nAmount: 17083700\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-23 12:40:00	\N	Planned Installment #: 1\nAmount: 31977700\nAmount: 31977700\nAmount: 5803500\nDate/Period: August 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-23 12:40:00	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 17527300\nAmount: 17527300\nDate/Period: June 2021\nDate/Period: June 2021\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-23 12:40:00	\N	Planned Installment #: 3\nAmount: 17527000\nAmount: 17527000\nAmount: 23200300\nDate/Period: May 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 114516280\nFunds from other Sources: 114516280\nFunds from other Sources: 45806500\nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-23 12:40:00	\N	Planned Installment #: 4\nAmount: 24100104\nDate/Period: November 2021\nFunds from other Sources: 91613000\nNotes: 
GMT Review	2020-09-23 12:40:00	\N	Planned Installment #: 5\nAmount: \nDate/Period: June 2022\nFunds from other Sources: 80161460\nNotes: 
GMT Review	2020-09-23 12:41:00	\N	Planned Installment #: 1\nAmount: 31511200\nAmount: 31511200\nAmount: 32843000\nAmount: 32843000\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-23 12:41:00	\N	Planned Installment #: 2\nAmount: 16672000\nAmount: 16672000\nAmount: 17612900\nAmount: 17612900\nDate/Period: June 2021\nDate/Period: June 2021\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 62895750\nFunds from other Sources: 62895750\nFunds from other Sources: 63020020\nFunds from other Sources: 63020020\nNotes: \nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-23 12:41:00	\N	Planned Installment #: 3\nAmount: 16672000\nAmount: 16672000\nAmount: 17612900\nAmount: 17612900\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 62895750\nFunds from other Sources: 62895750\nFunds from other Sources: 63020020\nFunds from other Sources: 63020020\nNotes: \nNotes: \nNotes: \nNotes: 
GMT Review	2020-09-23 12:43:00	\N	Planned Installment #: 1\nAmount: 32003000\nAmount: 32003000\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-23 12:43:00	\N	Planned Installment #: 2\nAmount: 17432000\nAmount: 17432000\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
GMT Review	2020-09-23 12:43:00	\N	Planned Installment #: 3\nAmount: 17432000\nAmount: 17432000\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 64994830\nFunds from other Sources: 64994830\nNotes: \nNotes: 
GMT Review	2020-09-23 12:44:00	\N	Planned Installment #: 1\nAmount: 32391550\nAmount: 32391550\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-23 12:44:00	\N	Planned Installment #: 2\nAmount: 17083750\nAmount: 17083750\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-23 12:44:00	\N	Planned Installment #: 3\nAmount: 17083700\nAmount: 17083700\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-23 12:45:00	\N	Planned Installment #: 1\nAmount: 32391550\nAmount: 32391550\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
GMT Review	2020-09-23 12:45:00	\N	Planned Installment #: 2\nAmount: 17083750\nAmount: 17083750\nDate/Period: June 2021\nDate/Period: June 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
GMT Review	2020-09-23 12:45:00	\N	Planned Installment #: 3\nAmount: 17083700\nAmount: 17083700\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 63005240\nFunds from other Sources: 63005240\nNotes: \nNotes: 
Program Review (Hub)	2020-08-19 13:07:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-19 13:07:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:04:00	\N	Planned Installment #: 2\nAmount: 17191300\nAmount: 19705800\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12579200\nFunds from other Sources: 9129510\nNotes: \nNotes: 
Program Review (Hub)	2020-08-19 13:07:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 10:39:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 10:39:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 10:39:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 13:15:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 13:15:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 13:15:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 13:23:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 13:23:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 13:23:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 17:44:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 17:44:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-20 17:44:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-21 10:13:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-21 10:13:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-21 10:13:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-21 10:55:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-21 10:55:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-21 10:55:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-21 11:09:00	\N	: 1\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nAmount: 1593263\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nDate/Period: Sepetmber 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-21 11:09:00	\N	: 2\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nAmount: 1571762\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nDate/Period: March 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-21 11:09:00	\N	: 3\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nAmount: 2685700\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nDate/Period: September 2021\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nFunds from other Sources: 274000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:51:00	\N	Planned Installment #: 1\nAmount: 7877800\nAmount: 9092600\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:51:00	\N	Planned Installment #: 2\nAmount: 18906700\nAmount: 21822300\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12604000\nFunds from other Sources: 13697040\nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:51:00	\N	Planned Installment #: 3\nAmount: 20578300\nAmount: 22661300\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 31510000\nFunds from other Sources: 34242600\nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:51:00	\N	Planned Installment #: 4\nAmount: 19374200\nAmount: 21029300\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 50416000\nFunds from other Sources: 54788160\nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:51:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 31510040\nFunds from other Sources: 34242600\nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:58:00	\N	Planned Installment #: 1\nAmount: 8000700\nAmount: 8000700\nAmount: 8162000\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:58:00	\N	Planned Installment #: 2\nAmount: 19201800\nAmount: 19201800\nAmount: 19588800\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12999000\nFunds from other Sources: 12999000\nFunds from other Sources: 14687440\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:58:00	\N	Planned Installment #: 3\nAmount: 20489200\nAmount: 20489200\nAmount: 21119100\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 32497400\nFunds from other Sources: 32497400\nFunds from other Sources: 36718600\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:58:00	\N	Planned Installment #: 4\nAmount: 19175250\nAmount: 19175250\nAmount: 19826800\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 51995900\nFunds from other Sources: 51995900\nFunds from other Sources: 58749760\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-24 23:58:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 32497360\nFunds from other Sources: 32497360\nFunds from other Sources: 36718600\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:02:00	\N	Planned Installment #: 1\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8140900\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:02:00	\N	Planned Installment #: 2\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19538100\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 14070000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:02:00	\N	Planned Installment #: 3\nAmount: 20059600\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:02:00	\N	Planned Installment #: 4\nAmount: 18547400\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 56280000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:02:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:04:00	\N	Planned Installment #: 1\nAmount: 7163100\nAmount: 8210800\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:04:00	\N	Planned Installment #: 3\nAmount: 18503800\nAmount: 19931000\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 22823775\nFunds from other Sources: 31447900\nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:04:00	\N	Planned Installment #: 4\nAmount: 17362800\nAmount: 18338900\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 36518040\nFunds from other Sources: 50316600\nNotes: \nNotes: 
Program Review (Hub)	2020-08-25 00:04:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 22823775\nFunds from other Sources: 31447800\nNotes: \nNotes: 
Program Review (Hub)	2020-08-26 16:21:00	\N	Planned Installment #: 1\nAmount: 5803500\nAmount: 5803500\nAmount: 5803500\nAmount: 5872920\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-26 16:21:00	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 13928400\nAmount: 13928400\nAmount: 14095008\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 23019216\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-26 16:21:00	\N	Planned Installment #: 3\nAmount: 23200300\nAmount: 23200300\nAmount: 23200300\nAmount: 23241971\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 57548040\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-26 16:21:00	\N	Planned Installment #: 4\nAmount: 24100045\nAmount: 24100104\nAmount: 24100104\nAmount: 24100104\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 92076864\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-08-26 16:21:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 57548040\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-01 17:40:00	\N	: 1\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: Initial Disbursement\nNotes: Initial Disbursement\nNotes: Initial Disbursement
Program Review (Hub)	2020-09-01 17:40:00	\N	: 2\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nNotes: \nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC
Program Review (Hub)	2020-09-02 10:14:00	\N	: 1\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: Initial Disbursement\nNotes: Initial Disbursement\nNotes: Initial Disbursement
Program Review (Hub)	2020-09-02 10:14:00	\N	: 2\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nNotes: \nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC
Program Review (Hub)	2020-09-05 10:58:00	\N	: 1\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: Initial Disbursement\nNotes: Initial Disbursement\nNotes: Initial Disbursement
Program Review (Hub)	2020-09-05 10:58:00	\N	: 2\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nNotes: \nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC
Program Review (Hub)	2020-09-07 12:15:00	\N	: 1\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nAmount: 1200000\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nDate/Period: September 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: Initial Disbursement\nNotes: Initial Disbursement\nNotes: Initial Disbursement
Program Review (Hub)	2020-09-07 12:15:00	\N	: 2\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nAmount: 1006000\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nDate/Period: February 2021\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nFunds from other Sources: 1157000\nNotes: \nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC\nNotes: Disbursement based on submission of previous quarter's QPR and UC
Program Review (Hub)	2020-09-07 20:15:00	\N	Planned Installment #: 1\nAmount: 5803500\nAmount: 5803500\nAmount: 5803500\nAmount: 5872920\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-07 20:15:00	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 13928400\nAmount: 13928400\nAmount: 14095008\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 23019216\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 15:23:00	\N	Planned Installment #: 2\nAmount: 18906700\nAmount: 21822300\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12604000\nFunds from other Sources: 13697040\nNotes: \nNotes: 
Program Review (Hub)	2020-09-07 20:15:00	\N	Planned Installment #: 3\nAmount: 23200300\nAmount: 23200300\nAmount: 23200300\nAmount: 23241971\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 57548040\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-07 20:15:00	\N	Planned Installment #: 4\nAmount: 24100045\nAmount: 24100104\nAmount: 24100104\nAmount: 24100104\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 92076864\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-07 20:15:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 57548040\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-15 10:42:00	\N	Planned Installment #: 1\nAmount: 5803500\nAmount: 5803500\nAmount: 5803500\nAmount: 5872920\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-15 10:42:00	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 13928400\nAmount: 13928400\nAmount: 14095008\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 23019216\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-15 10:42:00	\N	Planned Installment #: 3\nAmount: 23200300\nAmount: 23200300\nAmount: 23200300\nAmount: 23241971\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 57548040\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-15 10:42:00	\N	Planned Installment #: 4\nAmount: 24100045\nAmount: 24100104\nAmount: 24100104\nAmount: 24100104\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 92076864\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-15 10:42:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 57548040\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-17 10:20:00	\N	Planned Installment #: 1\nAmount: 5803500\nAmount: 5803500\nAmount: 5803500\nAmount: 5872920\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-17 10:20:00	\N	Planned Installment #: 2\nAmount: 13928400\nAmount: 13928400\nAmount: 13928400\nAmount: 14095008\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 11451600\nFunds from other Sources: 23019216\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-17 10:20:00	\N	Planned Installment #: 3\nAmount: 23200300\nAmount: 23200300\nAmount: 23200300\nAmount: 23241971\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 45806500\nFunds from other Sources: 57548040\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-17 10:20:00	\N	Planned Installment #: 4\nAmount: 24100045\nAmount: 24100104\nAmount: 24100104\nAmount: 24100104\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 91613000\nFunds from other Sources: 92076864\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-17 10:20:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 57548040\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nFunds from other Sources: 80161460\nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 12:41:00	\N	Planned Installment #: 1\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8140900\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 12:41:00	\N	Planned Installment #: 2\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19538100\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 14070000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 12:41:00	\N	Planned Installment #: 3\nAmount: 20059600\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 12:41:00	\N	Planned Installment #: 4\nAmount: 18547400\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 56280000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 12:41:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 15:23:00	\N	Planned Installment #: 1\nAmount: 7877800\nAmount: 9092600\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 15:23:00	\N	Planned Installment #: 3\nAmount: 20578300\nAmount: 22661300\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 31510000\nFunds from other Sources: 34242600\nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 15:23:00	\N	Planned Installment #: 4\nAmount: 19374200\nAmount: 21029300\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 50416000\nFunds from other Sources: 54788160\nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 15:23:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 31510040\nFunds from other Sources: 34242600\nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 18:32:00	\N	Planned Installment #: 1\nAmount: 8000700\nAmount: 8000700\nAmount: 8162000\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 18:32:00	\N	Planned Installment #: 2\nAmount: 19201800\nAmount: 19201800\nAmount: 19588800\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12999000\nFunds from other Sources: 12999000\nFunds from other Sources: 14687440\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 18:32:00	\N	Planned Installment #: 3\nAmount: 20489200\nAmount: 20489200\nAmount: 21119100\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 32497400\nFunds from other Sources: 32497400\nFunds from other Sources: 36718600\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 18:32:00	\N	Planned Installment #: 4\nAmount: 19175250\nAmount: 19175250\nAmount: 19826800\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 51995900\nFunds from other Sources: 51995900\nFunds from other Sources: 58749760\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 18:32:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 32497360\nFunds from other Sources: 32497360\nFunds from other Sources: 36718600\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 21:06:00	\N	Planned Installment #: 1\nAmount: 7163100\nAmount: 8210800\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 21:06:00	\N	Planned Installment #: 2\nAmount: 17191300\nAmount: 19705800\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12579200\nFunds from other Sources: 9129510\nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 21:06:00	\N	Planned Installment #: 3\nAmount: 18503800\nAmount: 19931000\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 22823775\nFunds from other Sources: 31447900\nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 21:06:00	\N	Planned Installment #: 4\nAmount: 17362800\nAmount: 18338900\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 36518040\nFunds from other Sources: 50316600\nNotes: \nNotes: 
Program Review (Hub)	2020-09-18 21:06:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 22823775\nFunds from other Sources: 31447800\nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 20:53:00	\N	Planned Installment #: 1\nAmount: 8000700\nAmount: 8000700\nAmount: 8162000\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 20:53:00	\N	Planned Installment #: 2\nAmount: 19201800\nAmount: 19201800\nAmount: 19588800\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12999000\nFunds from other Sources: 12999000\nFunds from other Sources: 14687440\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 20:53:00	\N	Planned Installment #: 3\nAmount: 20489200\nAmount: 20489200\nAmount: 21119100\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 32497400\nFunds from other Sources: 32497400\nFunds from other Sources: 36718600\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 20:53:00	\N	Planned Installment #: 4\nAmount: 19175250\nAmount: 19175250\nAmount: 19826800\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 51995900\nFunds from other Sources: 51995900\nFunds from other Sources: 58749760\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 20:53:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 32497360\nFunds from other Sources: 32497360\nFunds from other Sources: 36718600\nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:06:00	\N	Planned Installment #: 1\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8140900\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:06:00	\N	Planned Installment #: 2\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19538100\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 14070000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:06:00	\N	Planned Installment #: 3\nAmount: 20059600\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:06:00	\N	Planned Installment #: 4\nAmount: 18547400\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 56280000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:06:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:10:00	\N	Planned Installment #: 1\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8140900\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:10:00	\N	Planned Installment #: 2\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19538100\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 14070000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:10:00	\N	Planned Installment #: 3\nAmount: 20059600\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:10:00	\N	Planned Installment #: 4\nAmount: 18547400\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 56280000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:10:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:19:00	\N	Planned Installment #: 1\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8097900\nAmount: 8140900\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nDate/Period: August 2020\nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nFunds from other Sources: \nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:19:00	\N	Planned Installment #: 2\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19434900\nAmount: 19538100\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nDate/Period: November 2020\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 12601000\nFunds from other Sources: 14070000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:19:00	\N	Planned Installment #: 3\nAmount: 20059600\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nAmount: 20234100\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nDate/Period: May 2021\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 31502600\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:19:00	\N	Planned Installment #: 4\nAmount: 18547400\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nAmount: 18792150\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nDate/Period: November 2021\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 50404200\nFunds from other Sources: 56280000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
Program Review (Hub)	2020-09-20 21:19:00	\N	Planned Installment #: 5\nAmount: \nAmount: \nAmount: \nAmount: \nAmount: \nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nDate/Period: June 2022\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 31502680\nFunds from other Sources: 35175000\nNotes: \nNotes: \nNotes: \nNotes: \nNotes: 
\.


--
-- TOC entry 3660 (class 0 OID 122743)
-- Dependencies: 270
-- Data for Name: mail_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mail_logs (id, sent_on, cc, sent_to, msg, subject, status) FROM stdin;
\.


--
-- TOC entry 3661 (class 0 OID 122750)
-- Dependencies: 271
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, message, posted_on, read, user_id, grant_id, title, report_id, notification_for, disbursement_id) FROM stdin;
\.


--
-- TOC entry 3663 (class 0 OID 122758)
-- Dependencies: 273
-- Data for Name: org_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_config (id, config_name, config_value, granter_id, description, configurable, key, type) FROM stdin;
\.


--
-- TOC entry 3637 (class 0 OID 122633)
-- Dependencies: 247
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (organization_type, id, code, created_at, created_by, name, updated_at, updated_by) FROM stdin;
PLATFORM	3	ANUDAN	2019-04-08 03:02:02.431	System	Anudan	\N	\N
GRANTER	11	TEMPORG	2020-02-17 08:12:16.057644	System	Sustain Plus Energy Foundation	\N	\N
\.


--
-- TOC entry 3667 (class 0 OID 122772)
-- Dependencies: 277
-- Data for Name: password_reset_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_request (id, key, user_id, validated, requested_on, validated_on, org_id, code) FROM stdin;
\.


--
-- TOC entry 3668 (class 0 OID 122781)
-- Dependencies: 278
-- Data for Name: platform; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.platform (host_url, image_name, navbar_color, id) FROM stdin;
anudan	anudan.png	#a41029	3
\.


--
-- TOC entry 3669 (class 0 OID 122787)
-- Dependencies: 279
-- Data for Name: qual_kpi_data_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qual_kpi_data_document (id, file_name, file_type, version, qual_kpi_data_id) FROM stdin;
\.


--
-- TOC entry 3671 (class 0 OID 122795)
-- Dependencies: 281
-- Data for Name: qualitative_kpi_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qualitative_kpi_notes (id, message, posted_on, kpi_data_id, posted_by_id) FROM stdin;
\.


--
-- TOC entry 3673 (class 0 OID 122800)
-- Dependencies: 283
-- Data for Name: quant_kpi_data_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quant_kpi_data_document (id, file_name, file_type, version, quant_kpi_data_id) FROM stdin;
\.


--
-- TOC entry 3675 (class 0 OID 122808)
-- Dependencies: 285
-- Data for Name: quantitative_kpi_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quantitative_kpi_notes (id, message, posted_on, kpi_data_id, posted_by_id) FROM stdin;
\.


--
-- TOC entry 3678 (class 0 OID 122815)
-- Dependencies: 288
-- Data for Name: release; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.release (id, version) FROM stdin;
372786	1.0.2
\.


--
-- TOC entry 3680 (class 0 OID 122821)
-- Dependencies: 290
-- Data for Name: report_assignment_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_assignment_history (seqid, id, assignment, state_id, report_id, updated_on, assigned_on, updated_by) FROM stdin;
\.


--
-- TOC entry 3682 (class 0 OID 122827)
-- Dependencies: 292
-- Data for Name: report_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_assignments (id, report_id, state_id, assignment, anchor, assigned_on, updated_by) FROM stdin;
\.


--
-- TOC entry 3684 (class 0 OID 122833)
-- Dependencies: 294
-- Data for Name: report_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_history (seqid, id, name, start_date, end_date, due_date, status_id, created_at, created_by, updated_at, updated_by, grant_id, note, note_added, note_added_by, template_id, type, moved_on, linked_approved_reports, report_detail, deleted) FROM stdin;
\.


--
-- TOC entry 3686 (class 0 OID 122843)
-- Dependencies: 296
-- Data for Name: report_snapshot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_snapshot (id, assigned_to_id, report_id, string_attributes, name, description, status_id, start_date, end_date, due_date, from_state_id, from_note, moved_by, from_string_attributes, to_state_id, moved_on) FROM stdin;
\.


--
-- TOC entry 3688 (class 0 OID 122852)
-- Dependencies: 298
-- Data for Name: report_specific_section_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_specific_section_attributes (id, attribute_order, deletable, extras, field_name, field_type, required, granter_id, section_id, can_edit) FROM stdin;
\.


--
-- TOC entry 3690 (class 0 OID 122862)
-- Dependencies: 300
-- Data for Name: report_specific_sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_specific_sections (id, deletable, report_id, report_template_id, section_name, section_order, granter_id) FROM stdin;
\.


--
-- TOC entry 3692 (class 0 OID 122868)
-- Dependencies: 302
-- Data for Name: report_string_attribute_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_string_attribute_attachments (id, created_by, created_on, description, location, name, title, type, updated_by, updated_on, version, report_string_attribute_id) FROM stdin;
\.


--
-- TOC entry 3694 (class 0 OID 122877)
-- Dependencies: 304
-- Data for Name: report_string_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_string_attributes (id, frequency, target, value, report_id, section_id, section_attribute_id, grant_level_target, actual_target) FROM stdin;
\.


--
-- TOC entry 3696 (class 0 OID 122887)
-- Dependencies: 306
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reports (id, name, start_date, end_date, due_date, status_id, created_at, created_by, updated_at, updated_by, grant_id, type, note, note_added, note_added_by, template_id, moved_on, linked_approved_reports, report_detail, disabled_by_amendment, deleted) FROM stdin;
\.


--
-- TOC entry 3697 (class 0 OID 122896)
-- Dependencies: 307
-- Data for Name: rfps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rfps (id, created_at, created_by, description, title, updated_at, updated_by, granter_id) FROM stdin;
\.


--
-- TOC entry 3699 (class 0 OID 122904)
-- Dependencies: 309
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, created_at, created_by, name, updated_at, updated_by, organization_id, description, internal) FROM stdin;
5	2019-09-17 08:39:04.645742	System	Admin	\N	\N	3	\N	t
10	2020-02-17 08:15:00.862358	System	Admin	\N	\N	11	Admin	t
82	2020-08-14 16:15:12.603	vineet@socialalpha.org	HR & Admin (South)	\N	\N	11	Human Resources for South Region	f
83	2020-08-14 16:17:02.418	vineet@socialalpha.org	Finance (Central)	\N	\N	11	Finance & Accounts - Central team	f
84	2020-08-14 16:18:46.535	vineet@socialalpha.org	CEO/ED	\N	\N	11	Managing Committee for approvals	f
85	2020-08-14 16:20:29.451	vineet@socialalpha.org	Program Officer (Central & West)	\N	\N	11	Program Officer (Central & West)	f
86	2020-08-14 16:20:57.783	vineet@socialalpha.org	Hub Manager (Central & West)	\N	\N	11	Hub Manager (Central & West)	f
87	2020-08-14 16:21:18.734	vineet@socialalpha.org	Grant Management Team (Central)	\N	\N	11	Grant Management Team (Central)	f
88	2020-08-14 19:34:07.746	vineet@socialalpha.org	Program Officer (South)	\N	\N	11	Program Officer (South)	f
90	2020-08-14 19:34:58.364	vineet@socialalpha.org	HR & Admin (North East)	\N	\N	11	HR & Admin (North East)	f
91	2020-08-14 19:35:14.844	vineet@socialalpha.org	HR & Admin (North)	\N	\N	11	HR & Admin (North)	f
92	2020-08-14 19:36:04.135	vineet@socialalpha.org	Hub Manager (North East)	\N	\N	11	Hub Manager (North East)	f
93	2020-08-14 19:36:22.215	vineet@socialalpha.org	Hub Manager (North)	\N	\N	11	Hub Manager (North)	f
94	2020-08-14 19:36:38.971	vineet@socialalpha.org	Hub Manager (South)	\N	\N	11	Hub Manager (South)	f
95	2020-08-14 19:36:53.579	vineet@socialalpha.org	Monitoring Learning Evaluation (Central)	\N	\N	11	Monitoring Learning Evaluation (Central)	f
96	2020-08-14 19:37:13.347	vineet@socialalpha.org	Operation (North East)	\N	\N	11	Operation (North East)	f
97	2020-08-14 19:37:28.039	vineet@socialalpha.org	Partnership Lead 	\N	\N	11	Partnership Lead 	f
98	2020-08-14 19:38:04.377	vineet@socialalpha.org	Program Officer (North East)	\N	\N	11	Program Officer (North East)	f
99	2020-08-14 19:38:19.076	vineet@socialalpha.org	Program Officer (North)	\N	\N	11	Program Officer (North)	f
100	2020-08-14 19:38:51.192	vineet@socialalpha.org	Sr. Program Officer (North East)	\N	\N	11	Sr. Program Officer (North East)	f
101	2020-08-14 19:39:05.374	vineet@socialalpha.org	Technical Coordinator (North East)	\N	\N	11	Technical Coordinator (North East)	f
89	2020-08-14 19:34:34.531	vineet@socialalpha.org	Core Team	2020-10-06 14:09:00.537	sgahoi@tatatrusts.org	11	Core Team	f
\.


--
-- TOC entry 3701 (class 0 OID 122913)
-- Dependencies: 311
-- Data for Name: roles_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles_permission (id, permission, role_id) FROM stdin;
\.


--
-- TOC entry 3703 (class 0 OID 122918)
-- Dependencies: 313
-- Data for Name: submission_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.submission_note (id, message, posted_on, posted_by_id, submission_id) FROM stdin;
\.


--
-- TOC entry 3705 (class 0 OID 122923)
-- Dependencies: 315
-- Data for Name: submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.submissions (id, created_at, created_by, submit_by, submitted_on, title, updated_at, updated_by, grant_id, submission_status_id) FROM stdin;
\.


--
-- TOC entry 3707 (class 0 OID 122931)
-- Dependencies: 317
-- Data for Name: template_library; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.template_library (id, description, file_type, granter_id, location, name, type, version) FROM stdin;
\.


--
-- TOC entry 3709 (class 0 OID 122939)
-- Dependencies: 319
-- Data for Name: templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.templates (id, description, file_type, location, name, type, version, kpi_id) FROM stdin;
\.


--
-- TOC entry 3711 (class 0 OID 122947)
-- Dependencies: 321
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (id, role_id, user_id) FROM stdin;
\.


--
-- TOC entry 3638 (class 0 OID 122639)
-- Dependencies: 248
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, created_at, created_by, email_id, first_name, last_name, password, updated_at, updated_by, organization_id, active, user_profile, plain, deleted) FROM stdin;
7	2019-04-08 03:00:16.545	System	administrator@anudan.com	Anudan	Admin	password	\N	\N	3	t	\N	t	f
\.


--
-- TOC entry 3714 (class 0 OID 122954)
-- Dependencies: 324
-- Data for Name: work_flow_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.work_flow_permission (id, action, from_name, from_state_id, note_required, to_name, to_state_id) FROM stdin;
\.


--
-- TOC entry 3715 (class 0 OID 122960)
-- Dependencies: 325
-- Data for Name: workflow_action_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_action_permission (id, permissions_string) FROM stdin;
\.


--
-- TOC entry 3716 (class 0 OID 122963)
-- Dependencies: 326
-- Data for Name: workflow_state_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_state_permissions (id, created_at, created_by, permission, updated_at, updated_by, role_id, workflow_status_id) FROM stdin;
\.


--
-- TOC entry 3718 (class 0 OID 122971)
-- Dependencies: 328
-- Data for Name: workflow_status_transitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_status_transitions (id, action, created_at, created_by, note_required, updated_at, updated_by, from_state_id, role_id, to_state_id, workflow_id, seq_order) FROM stdin;
49	Submit for Review	2020-04-29 10:28:12.898617	System	t	\N	\N	11	\N	12	6	1
51	Submit for Final Approval	2020-04-29 10:28:12.918545	System	t	\N	\N	22	\N	14	6	3
52	Approve for Release	2020-04-29 10:28:12.926843	System	t	\N	\N	14	\N	15	6	4
53	Close	2020-04-29 10:28:12.980134	System	t	\N	\N	15	\N	16	6	5
50	Submit for Review	2020-04-29 10:28:12.908447	System	t	\N	\N	12	\N	22	6	2
55	Request Modifications	2020-04-29 10:28:12.994181	System	t	\N	\N	22	\N	12	6	52
56	Request Modifications	2020-04-29 10:28:13.647737	System	t	\N	\N	14	\N	22	6	53
54	Request Modifications	2020-04-29 10:28:12.987694	System	t	\N	\N	12	\N	11	6	51
57	Publish	2020-04-29 11:22:51.61334	System	t	\N	\N	17	\N	18	7	1
58	Submit for Approval	2020-04-29 11:22:51.632294	System	t	\N	\N	18	\N	19	7	2
59	Submit for Finance Approval	2020-04-29 11:22:51.654104	System	t	\N	\N	19	\N	23	7	3
60	Approve for Final Approval	2020-04-29 11:22:51.665589	System	t	\N	\N	23	\N	24	7	4
61	Approve	2020-04-29 11:22:51.704601	System	t	\N	\N	24	\N	20	7	5
62	Request Modifications	2020-04-29 11:22:51.71428	System	t	\N	\N	19	\N	18	7	51
63	Request Modifications	2020-04-29 11:22:51.731509	System	t	\N	\N	23	\N	19	7	52
64	Request Modifications	2020-04-29 11:22:52.518888	System	t	\N	\N	24	\N	23	7	53
70	Submit for Finance Review	2020-06-11 16:05:37.94509	System	t	\N	\N	30	\N	31	9	2
71	Submit for Final Approval	2020-06-11 16:05:37.950855	System	t	\N	\N	31	\N	32	9	3
75	Approve	2020-06-11 16:05:37.978715	System	t	\N	\N	32	\N	33	9	4
76	Close	2020-06-11 16:05:37.985302	System	t	\N	\N	33	\N	34	9	5
69	Submit for Review	2020-06-11 16:05:37.937457	System	t	\N	\N	29	\N	30	9	1
72	Request Modifications	2020-06-11 16:05:37.959497	System	t	\N	\N	32	\N	31	9	53
73	Request Modifications	2020-06-11 16:05:37.964899	System	t	\N	\N	30	\N	29	9	51
74	Request Modifications	2020-06-11 16:05:37.973623	System	t	\N	\N	31	\N	30	9	52
\.


--
-- TOC entry 3641 (class 0 OID 122662)
-- Dependencies: 251
-- Data for Name: workflow_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_statuses (id, created_at, created_by, display_name, initial, internal_status, name, terminal, updated_at, updated_by, verb, workflow_id) FROM stdin;
11	2020-02-17 08:21:19.43246	System	Draft	t	DRAFT	Draft	f	\N	\N	Draft	6
16	2020-02-17 08:21:21.2552	System	Closed	f	CLOSED	Closed	t	\N	\N	Closed	6
17	2020-02-17 08:22:17.901802	System	Draft	t	DRAFT	Draft	f	\N	\N	Draft	7
20	2020-02-17 08:22:19.255933	System	Approved	f	CLOSED	Approved	t	\N	\N	Approved	7
23	2020-04-29 11:16:20.105153	System	Finance Review	f	REVIEW	Finance Review	f	\N	\N	\N	7
29	2020-06-11 16:05:37.902931	System	Draft	t	DRAFT	Draft	f	\N	\N	\N	9
31	2020-06-11 16:05:37.915292	System	Finance Review	f	REVIEW	Finance Review	f	\N	\N	\N	9
34	2020-06-11 16:05:37.930699	System	Disbursed	f	CLOSED	Disbursed	t	\N	\N	\N	9
12	2020-02-17 08:21:19.454955	System	Peer Review	f	REVIEW	Peer Review	f	\N	\N	\N	6
22	2020-04-22 17:02:24.848523	System	Pre-Approval Review	f	REVIEW	Pre-Approval Review	f	\N	\N	\N	6
14	2020-02-17 08:21:19.492619	System	Final Approval	f	REVIEW	Final Approval	f	\N	\N	\N	6
15	2020-02-17 08:21:19.539954	System	Active	f	ACTIVE	Active	f	\N	\N	\N	6
18	2020-02-17 08:22:17.9183	System	External Project Team	f	ACTIVE	External Project Team	f	\N	\N	\N	7
19	2020-02-17 08:22:17.937497	System	Program Review	f	REVIEW	Program Review	f	\N	\N	\N	7
24	2020-04-29 11:18:55.242587	System	Final Approval	f	REVIEW	Final Approval	f	\N	\N	\N	7
30	2020-06-11 16:05:37.907026	System	Peer Review	f	REVIEW	Peer Review	f	\N	\N	\N	9
32	2020-06-11 16:05:37.919687	System	Final Approval	f	REVIEW	Final Approval	f	\N	\N	\N	9
33	2020-06-11 16:05:37.923781	System	Record Disbursement	f	ACTIVE	Record Disbursement	f	\N	\N	\N	9
\.


--
-- TOC entry 3721 (class 0 OID 122981)
-- Dependencies: 331
-- Data for Name: workflow_transition_model; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_transition_model (id, _from, _performedby, _to, action, from_state_id, role_id, to_state_id, seq_order) FROM stdin;
\.


--
-- TOC entry 3722 (class 0 OID 122987)
-- Dependencies: 332
-- Data for Name: workflows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflows (id, created_at, created_by, description, name, object, updated_at, updated_by, granter_id) FROM stdin;
6	2020-02-17 08:20:53.752926	System	Default Sustain Plus Grant workflow	Default Sustain Plus Grant workflow	GRANT	\N	\N	11
7	2020-02-17 08:20:55.368175	System	Default Sustain Plus Report workflow	Default Sustain Plus Report workflow	REPORT	\N	\N	11
9	2020-06-11 16:05:37.833902	System	\N	SUSPLUS Disbursement Workflow	DISBURSEMENT	\N	\N	11
\.


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 196
-- Name: actual_disbursements_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actual_disbursements_seq', 40, true);


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 199
-- Name: app_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_config_id_seq', 37, true);


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 200
-- Name: disb_assign_hist; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disb_assign_hist', 3, true);


--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 202
-- Name: disbursement_assignment_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disbursement_assignment_seq', 283, true);


--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 204
-- Name: disbursement_hist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disbursement_hist_id_seq', 165, true);


--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 206
-- Name: disbursement_snapshot_seq_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disbursement_snapshot_seq_id', 158, true);


--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 208
-- Name: disbursements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disbursements_id_seq', 92, true);


--
-- TOC entry 3774 (class 0 OID 0)
-- Dependencies: 211
-- Name: doc_kpi_data_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_kpi_data_document_id_seq', 1, false);


--
-- TOC entry 3775 (class 0 OID 0)
-- Dependencies: 213
-- Name: document_kpi_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_kpi_notes_id_seq', 1, false);


--
-- TOC entry 3776 (class 0 OID 0)
-- Dependencies: 214
-- Name: grant_assign_hist; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_assign_hist', 45, true);


--
-- TOC entry 3777 (class 0 OID 0)
-- Dependencies: 217
-- Name: grant_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_assignments_id_seq', 1874, true);


--
-- TOC entry 3778 (class 0 OID 0)
-- Dependencies: 218
-- Name: grant_attrib_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_attrib_attachments_id_seq', 1317, true);


--
-- TOC entry 3779 (class 0 OID 0)
-- Dependencies: 220
-- Name: grant_document_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_document_attributes_id_seq', 1, false);


--
-- TOC entry 3780 (class 0 OID 0)
-- Dependencies: 222
-- Name: grant_document_kpi_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_document_kpi_data_id_seq', 1, false);


--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 223
-- Name: grant_documents_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_documents_seq', 131, true);


--
-- TOC entry 3782 (class 0 OID 0)
-- Dependencies: 225
-- Name: grant_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_history_id_seq', 907, true);


--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 228
-- Name: grant_kpis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_kpis_id_seq', 1, false);


--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 230
-- Name: grant_qualitative_kpi_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_qualitative_kpi_data_id_seq', 1, false);


--
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 232
-- Name: grant_quantitative_kpi_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_quantitative_kpi_data_id_seq', 1, false);


--
-- TOC entry 3786 (class 0 OID 0)
-- Dependencies: 234
-- Name: grant_section_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_section_attributes_id_seq', 22, true);


--
-- TOC entry 3787 (class 0 OID 0)
-- Dependencies: 236
-- Name: grant_sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_sections_id_seq', 6, true);


--
-- TOC entry 3788 (class 0 OID 0)
-- Dependencies: 237
-- Name: grant_snapshot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_snapshot_id_seq', 935, true);


--
-- TOC entry 3789 (class 0 OID 0)
-- Dependencies: 240
-- Name: grant_specific_section_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_specific_section_attributes_id_seq', 11831, true);


--
-- TOC entry 3790 (class 0 OID 0)
-- Dependencies: 242
-- Name: grant_specific_sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_specific_sections_id_seq', 2703, true);


--
-- TOC entry 3791 (class 0 OID 0)
-- Dependencies: 245
-- Name: grant_string_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_string_attributes_id_seq', 11864, true);


--
-- TOC entry 3792 (class 0 OID 0)
-- Dependencies: 254
-- Name: granter_grant_section_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.granter_grant_section_attributes_id_seq', 51971, true);


--
-- TOC entry 3793 (class 0 OID 0)
-- Dependencies: 256
-- Name: granter_grant_sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.granter_grant_sections_id_seq', 11222, true);


--
-- TOC entry 3794 (class 0 OID 0)
-- Dependencies: 258
-- Name: granter_grant_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.granter_grant_templates_id_seq', 1645, true);


--
-- TOC entry 3795 (class 0 OID 0)
-- Dependencies: 260
-- Name: granter_report_section_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.granter_report_section_attributes_id_seq', 1222, true);


--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 262
-- Name: granter_report_sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.granter_report_sections_id_seq', 891, true);


--
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 264
-- Name: granter_report_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.granter_report_templates_id_seq', 180, true);


--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 267
-- Name: grants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grants_id_seq', 379, true);


--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 269
-- Name: mail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mail_id_seq', 4096, true);


--
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 272
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 3544, true);


--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 274
-- Name: org_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.org_config_id_seq', 9, true);


--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 275
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organizations_id_seq', 119, true);


--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 276
-- Name: password_reset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.password_reset_id_seq', 87, true);


--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 280
-- Name: qual_kpi_data_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.qual_kpi_data_document_id_seq', 1, false);


--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 282
-- Name: qualitative_kpi_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.qualitative_kpi_notes_id_seq', 1, false);


--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 284
-- Name: quant_kpi_data_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quant_kpi_data_document_id_seq', 1, false);


--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 286
-- Name: quantitative_kpi_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quantitative_kpi_notes_id_seq', 1, false);


--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 287
-- Name: release_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.release_id_seq', 372786, true);


--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 289
-- Name: report_assign_hist; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_assign_hist', 7, true);


--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 291
-- Name: report_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_assignments_id_seq', 3815, true);


--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 293
-- Name: report_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_history_id_seq', 116, true);


--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 295
-- Name: report_snapshot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_snapshot_id_seq', 438, true);


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 297
-- Name: report_specific_section_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_specific_section_attributes_id_seq', 6086, true);


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 299
-- Name: report_specific_sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_specific_sections_id_seq', 4611, true);


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 301
-- Name: report_string_attribute_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_string_attribute_attachments_id_seq', 26, true);


--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 303
-- Name: report_string_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_string_attributes_id_seq', 6086, true);


--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 305
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reports_id_seq', 675, true);


--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 308
-- Name: rfps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rfps_id_seq', 1, false);


--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 310
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 164, true);


--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 312
-- Name: roles_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_permission_id_seq', 15, true);


--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 314
-- Name: submission_note_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.submission_note_id_seq', 1, false);


--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 316
-- Name: submissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.submissions_id_seq', 1, false);


--
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 318
-- Name: template_library_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.template_library_id_seq', 71, true);


--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 320
-- Name: templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.templates_id_seq', 1, false);


--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 322
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 150, true);


--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 323
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 147, true);


--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 327
-- Name: workflow_state_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_state_permissions_id_seq', 14, true);


--
-- TOC entry 3828 (class 0 OID 0)
-- Dependencies: 329
-- Name: workflow_status_transitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_status_transitions_id_seq', 172, true);


--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 330
-- Name: workflow_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_statuses_id_seq', 112, true);


--
-- TOC entry 3830 (class 0 OID 0)
-- Dependencies: 333
-- Name: workflows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflows_id_seq', 21, true);


--
-- TOC entry 3256 (class 2606 OID 123034)
-- Name: actual_disbursements act_disb_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actual_disbursements
    ADD CONSTRAINT act_disb_pk PRIMARY KEY (id);


--
-- TOC entry 3258 (class 2606 OID 123036)
-- Name: app_config app_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_config
    ADD CONSTRAINT app_config_pkey PRIMARY KEY (id);


--
-- TOC entry 3264 (class 2606 OID 123038)
-- Name: disbursement_snapshot disb_snapshot_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disbursement_snapshot
    ADD CONSTRAINT disb_snapshot_pk PRIMARY KEY (id);


--
-- TOC entry 3260 (class 2606 OID 123040)
-- Name: disbursement_assignments disbursement_assig_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disbursement_assignments
    ADD CONSTRAINT disbursement_assig_pk PRIMARY KEY (id);


--
-- TOC entry 3262 (class 2606 OID 123042)
-- Name: disbursement_history disbursement_hist_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disbursement_history
    ADD CONSTRAINT disbursement_hist_id_pk PRIMARY KEY (seqid);


--
-- TOC entry 3266 (class 2606 OID 123044)
-- Name: disbursements disbursements_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disbursements
    ADD CONSTRAINT disbursements_id_pk PRIMARY KEY (id);


--
-- TOC entry 3268 (class 2606 OID 123046)
-- Name: doc_kpi_data_document doc_kpi_data_document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_kpi_data_document
    ADD CONSTRAINT doc_kpi_data_document_pkey PRIMARY KEY (id);


--
-- TOC entry 3270 (class 2606 OID 123048)
-- Name: document_kpi_notes document_kpi_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_kpi_notes
    ADD CONSTRAINT document_kpi_notes_pkey PRIMARY KEY (id);


--
-- TOC entry 3272 (class 2606 OID 123050)
-- Name: grant_assignments grant_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_assignments
    ADD CONSTRAINT grant_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 3274 (class 2606 OID 123052)
-- Name: grant_document_attributes grant_document_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_document_attributes
    ADD CONSTRAINT grant_document_attributes_pkey PRIMARY KEY (id);


--
-- TOC entry 3276 (class 2606 OID 123054)
-- Name: grant_document_kpi_data grant_document_kpi_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_document_kpi_data
    ADD CONSTRAINT grant_document_kpi_data_pkey PRIMARY KEY (id);


--
-- TOC entry 3278 (class 2606 OID 123056)
-- Name: grant_documents grant_document_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_documents
    ADD CONSTRAINT grant_document_pk PRIMARY KEY (id);


--
-- TOC entry 3280 (class 2606 OID 123058)
-- Name: grant_history grant_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_history
    ADD CONSTRAINT grant_history_pkey PRIMARY KEY (seqid);


--
-- TOC entry 3282 (class 2606 OID 123060)
-- Name: grant_kpis grant_kpis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_kpis
    ADD CONSTRAINT grant_kpis_pkey PRIMARY KEY (id);


--
-- TOC entry 3284 (class 2606 OID 123062)
-- Name: grant_qualitative_kpi_data grant_qualitative_kpi_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_qualitative_kpi_data
    ADD CONSTRAINT grant_qualitative_kpi_data_pkey PRIMARY KEY (id);


--
-- TOC entry 3286 (class 2606 OID 123064)
-- Name: grant_quantitative_kpi_data grant_quantitative_kpi_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_quantitative_kpi_data
    ADD CONSTRAINT grant_quantitative_kpi_data_pkey PRIMARY KEY (id);


--
-- TOC entry 3288 (class 2606 OID 123066)
-- Name: grant_section_attributes grant_section_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_section_attributes
    ADD CONSTRAINT grant_section_attributes_pkey PRIMARY KEY (id);


--
-- TOC entry 3290 (class 2606 OID 123068)
-- Name: grant_sections grant_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_sections
    ADD CONSTRAINT grant_sections_pkey PRIMARY KEY (id);


--
-- TOC entry 3292 (class 2606 OID 123070)
-- Name: grant_snapshot grant_snapshot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_snapshot
    ADD CONSTRAINT grant_snapshot_pkey PRIMARY KEY (id);


--
-- TOC entry 3294 (class 2606 OID 123072)
-- Name: grant_specific_section_attributes grant_specific_section_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_specific_section_attributes
    ADD CONSTRAINT grant_specific_section_attributes_pkey PRIMARY KEY (id);


--
-- TOC entry 3296 (class 2606 OID 123074)
-- Name: grant_specific_sections grant_specific_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_specific_sections
    ADD CONSTRAINT grant_specific_sections_pkey PRIMARY KEY (id);


--
-- TOC entry 3298 (class 2606 OID 123076)
-- Name: grant_string_attribute_attachments grant_string_attribute_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_string_attribute_attachments
    ADD CONSTRAINT grant_string_attribute_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 3300 (class 2606 OID 123078)
-- Name: grant_string_attributes grant_string_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_string_attributes
    ADD CONSTRAINT grant_string_attributes_pkey PRIMARY KEY (id);


--
-- TOC entry 3302 (class 2606 OID 123080)
-- Name: grantees grantees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grantees
    ADD CONSTRAINT grantees_pkey PRIMARY KEY (id);


--
-- TOC entry 3312 (class 2606 OID 123082)
-- Name: granter_grant_section_attributes granter_grant_section_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_section_attributes
    ADD CONSTRAINT granter_grant_section_attributes_pkey PRIMARY KEY (id);


--
-- TOC entry 3314 (class 2606 OID 123084)
-- Name: granter_grant_sections granter_grant_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_sections
    ADD CONSTRAINT granter_grant_sections_pkey PRIMARY KEY (id);


--
-- TOC entry 3316 (class 2606 OID 123086)
-- Name: granter_grant_templates granter_grant_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_templates
    ADD CONSTRAINT granter_grant_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 3318 (class 2606 OID 123088)
-- Name: granter_report_section_attributes granter_report_section_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_report_section_attributes
    ADD CONSTRAINT granter_report_section_attributes_pkey PRIMARY KEY (id);


--
-- TOC entry 3320 (class 2606 OID 123090)
-- Name: granter_report_sections granter_report_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_report_sections
    ADD CONSTRAINT granter_report_sections_pkey PRIMARY KEY (id);


--
-- TOC entry 3322 (class 2606 OID 123092)
-- Name: granter_report_templates granter_report_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_report_templates
    ADD CONSTRAINT granter_report_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 3324 (class 2606 OID 123094)
-- Name: granters granters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granters
    ADD CONSTRAINT granters_pkey PRIMARY KEY (id);


--
-- TOC entry 3308 (class 2606 OID 123096)
-- Name: grants grants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grants
    ADD CONSTRAINT grants_pkey PRIMARY KEY (id);


--
-- TOC entry 3326 (class 2606 OID 123098)
-- Name: mail_logs mail_log_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mail_logs
    ADD CONSTRAINT mail_log_pk PRIMARY KEY (id);


--
-- TOC entry 3328 (class 2606 OID 123100)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 3330 (class 2606 OID 123102)
-- Name: org_config org_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_config
    ADD CONSTRAINT org_config_pkey PRIMARY KEY (id);


--
-- TOC entry 3304 (class 2606 OID 123104)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 3332 (class 2606 OID 123106)
-- Name: password_reset_request password_reset_req_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_request
    ADD CONSTRAINT password_reset_req_id_pk PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 123108)
-- Name: platform platform_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform
    ADD CONSTRAINT platform_pkey PRIMARY KEY (id);


--
-- TOC entry 3336 (class 2606 OID 123110)
-- Name: qual_kpi_data_document qual_kpi_data_document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qual_kpi_data_document
    ADD CONSTRAINT qual_kpi_data_document_pkey PRIMARY KEY (id);


--
-- TOC entry 3338 (class 2606 OID 123112)
-- Name: qualitative_kpi_notes qualitative_kpi_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualitative_kpi_notes
    ADD CONSTRAINT qualitative_kpi_notes_pkey PRIMARY KEY (id);


--
-- TOC entry 3340 (class 2606 OID 123114)
-- Name: quant_kpi_data_document quant_kpi_data_document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quant_kpi_data_document
    ADD CONSTRAINT quant_kpi_data_document_pkey PRIMARY KEY (id);


--
-- TOC entry 3342 (class 2606 OID 123116)
-- Name: quantitative_kpi_notes quantitative_kpi_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantitative_kpi_notes
    ADD CONSTRAINT quantitative_kpi_notes_pkey PRIMARY KEY (id);


--
-- TOC entry 3344 (class 2606 OID 123118)
-- Name: release release_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.release
    ADD CONSTRAINT release_id_pk PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 123120)
-- Name: report_history report_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_history
    ADD CONSTRAINT report_history_pkey PRIMARY KEY (seqid);


--
-- TOC entry 3348 (class 2606 OID 123122)
-- Name: report_specific_section_attributes report_specific_section_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_specific_section_attributes
    ADD CONSTRAINT report_specific_section_attributes_pkey PRIMARY KEY (id);


--
-- TOC entry 3350 (class 2606 OID 123124)
-- Name: report_specific_sections report_specific_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_specific_sections
    ADD CONSTRAINT report_specific_sections_pkey PRIMARY KEY (id);


--
-- TOC entry 3352 (class 2606 OID 123126)
-- Name: report_string_attribute_attachments report_string_attribute_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_string_attribute_attachments
    ADD CONSTRAINT report_string_attribute_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 3354 (class 2606 OID 123128)
-- Name: report_string_attributes report_string_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_string_attributes
    ADD CONSTRAINT report_string_attributes_pkey PRIMARY KEY (id);


--
-- TOC entry 3356 (class 2606 OID 123130)
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 123132)
-- Name: rfps rfps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rfps
    ADD CONSTRAINT rfps_pkey PRIMARY KEY (id);


--
-- TOC entry 3362 (class 2606 OID 123134)
-- Name: roles_permission roles_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_permission
    ADD CONSTRAINT roles_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3360 (class 2606 OID 123136)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3364 (class 2606 OID 123138)
-- Name: submission_note submission_note_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission_note
    ADD CONSTRAINT submission_note_pkey PRIMARY KEY (id);


--
-- TOC entry 3366 (class 2606 OID 123140)
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3368 (class 2606 OID 123142)
-- Name: template_library template_library_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template_library
    ADD CONSTRAINT template_library_pkey PRIMARY KEY (id);


--
-- TOC entry 3370 (class 2606 OID 123144)
-- Name: templates templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (id);


--
-- TOC entry 3372 (class 2606 OID 123146)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3306 (class 2606 OID 123148)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3374 (class 2606 OID 123150)
-- Name: work_flow_permission work_flow_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_flow_permission
    ADD CONSTRAINT work_flow_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3376 (class 2606 OID 123152)
-- Name: workflow_action_permission workflow_action_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_action_permission
    ADD CONSTRAINT workflow_action_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3378 (class 2606 OID 123154)
-- Name: workflow_state_permissions workflow_state_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_state_permissions
    ADD CONSTRAINT workflow_state_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3380 (class 2606 OID 123156)
-- Name: workflow_status_transitions workflow_status_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_status_transitions
    ADD CONSTRAINT workflow_status_transitions_pkey PRIMARY KEY (id);


--
-- TOC entry 3310 (class 2606 OID 123158)
-- Name: workflow_statuses workflow_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_statuses
    ADD CONSTRAINT workflow_statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 3382 (class 2606 OID 123160)
-- Name: workflow_transition_model workflow_transition_model_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_transition_model
    ADD CONSTRAINT workflow_transition_model_pkey PRIMARY KEY (id);


--
-- TOC entry 3384 (class 2606 OID 123162)
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);


--
-- TOC entry 3456 (class 2620 OID 123163)
-- Name: disbursement_assignments disbursement_assignment_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER disbursement_assignment_audit AFTER UPDATE ON public.disbursement_assignments FOR EACH ROW EXECUTE PROCEDURE public.process_disbursement_assignment_change();


--
-- TOC entry 3457 (class 2620 OID 123164)
-- Name: disbursements disbursement_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER disbursement_audit AFTER UPDATE ON public.disbursements FOR EACH ROW EXECUTE PROCEDURE public.process_disbursement_state_change();


--
-- TOC entry 3458 (class 2620 OID 123165)
-- Name: grant_assignments grant_assignment_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER grant_assignment_audit AFTER UPDATE ON public.grant_assignments FOR EACH ROW EXECUTE PROCEDURE public.process_grant_assignment_change();


--
-- TOC entry 3459 (class 2620 OID 123166)
-- Name: grants grant_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER grant_audit AFTER UPDATE ON public.grants FOR EACH ROW EXECUTE PROCEDURE public.process_grant_state_change();


--
-- TOC entry 3460 (class 2620 OID 123167)
-- Name: report_assignments report_assignment_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER report_assignment_audit AFTER UPDATE ON public.report_assignments FOR EACH ROW EXECUTE PROCEDURE public.process_report_assignment_change();


--
-- TOC entry 3461 (class 2620 OID 123168)
-- Name: reports report_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER report_audit AFTER UPDATE ON public.reports FOR EACH ROW EXECUTE PROCEDURE public.process_report_state_change();


--
-- TOC entry 3451 (class 2606 OID 123169)
-- Name: workflow_status_transitions fk27a376l9dly50yhv4dyqprgqv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_status_transitions
    ADD CONSTRAINT fk27a376l9dly50yhv4dyqprgqv FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- TOC entry 3398 (class 2606 OID 123174)
-- Name: grant_qualitative_kpi_data fk2s6ithk1xy0ig8jowyiqmo8rx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_qualitative_kpi_data
    ADD CONSTRAINT fk2s6ithk1xy0ig8jowyiqmo8rx FOREIGN KEY (grant_kpi_id) REFERENCES public.grant_kpis(id);


--
-- TOC entry 3418 (class 2606 OID 123179)
-- Name: granter_grant_sections fk3lr5sgkm2s6bx4filctn6gagm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_sections
    ADD CONSTRAINT fk3lr5sgkm2s6bx4filctn6gagm FOREIGN KEY (grant_template_id) REFERENCES public.granter_grant_templates(id);


--
-- TOC entry 3425 (class 2606 OID 123184)
-- Name: platform fk3xre58624noycrrgchsgyef5e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform
    ADD CONSTRAINT fk3xre58624noycrrgchsgyef5e FOREIGN KEY (id) REFERENCES public.organizations(id);


--
-- TOC entry 3446 (class 2606 OID 123189)
-- Name: templates fk4op755x1d71aebjj4e8018cc7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT fk4op755x1d71aebjj4e8018cc7 FOREIGN KEY (kpi_id) REFERENCES public.grant_kpis(id);


--
-- TOC entry 3427 (class 2606 OID 123194)
-- Name: qualitative_kpi_notes fk52xwacoieu7isbdcgqy07ekmx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualitative_kpi_notes
    ADD CONSTRAINT fk52xwacoieu7isbdcgqy07ekmx FOREIGN KEY (posted_by_id) REFERENCES public.users(id);


--
-- TOC entry 3397 (class 2606 OID 123199)
-- Name: grant_kpis fk6qxmldadt1rprdf8v1oesx106; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_kpis
    ADD CONSTRAINT fk6qxmldadt1rprdf8v1oesx106 FOREIGN KEY (grant_id) REFERENCES public.grants(id);


--
-- TOC entry 3449 (class 2606 OID 123204)
-- Name: workflow_state_permissions fk7cek33ktgssedr520yohxkse5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_state_permissions
    ADD CONSTRAINT fk7cek33ktgssedr520yohxkse5 FOREIGN KEY (workflow_status_id) REFERENCES public.workflow_statuses(id);


--
-- TOC entry 3409 (class 2606 OID 123209)
-- Name: grantees fk82ngyn089fjkpmbjg79v75ctx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grantees
    ADD CONSTRAINT fk82ngyn089fjkpmbjg79v75ctx FOREIGN KEY (id) REFERENCES public.organizations(id);


--
-- TOC entry 3411 (class 2606 OID 123214)
-- Name: grants fk881g56ucqjflq4o7hyyrlx2a2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grants
    ADD CONSTRAINT fk881g56ucqjflq4o7hyyrlx2a2 FOREIGN KEY (substatus_id) REFERENCES public.workflow_statuses(id);


--
-- TOC entry 3393 (class 2606 OID 123219)
-- Name: grant_history fk881g56ucqjflq4o7hyyrlx2a2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_history
    ADD CONSTRAINT fk881g56ucqjflq4o7hyyrlx2a2 FOREIGN KEY (substatus_id) REFERENCES public.workflow_statuses(id);


--
-- TOC entry 3455 (class 2606 OID 123224)
-- Name: workflows fk8kjwa8ecy2djhc3mmbhvbj7hb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT fk8kjwa8ecy2djhc3mmbhvbj7hb FOREIGN KEY (granter_id) REFERENCES public.organizations(id);


--
-- TOC entry 3386 (class 2606 OID 123229)
-- Name: document_kpi_notes fk94ty5yy9jgvquojr9albjxe7r; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_kpi_notes
    ADD CONSTRAINT fk94ty5yy9jgvquojr9albjxe7r FOREIGN KEY (kpi_data_id) REFERENCES public.grant_document_kpi_data(id);


--
-- TOC entry 3442 (class 2606 OID 123234)
-- Name: submission_note fk9ev4x0qwvnowkyu0ev1539sse; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission_note
    ADD CONSTRAINT fk9ev4x0qwvnowkyu0ev1539sse FOREIGN KEY (posted_by_id) REFERENCES public.users(id);


--
-- TOC entry 3443 (class 2606 OID 123239)
-- Name: submission_note fkaqjedpauphanpxfbn87v3tfld; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission_note
    ADD CONSTRAINT fkaqjedpauphanpxfbn87v3tfld FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- TOC entry 3430 (class 2606 OID 123244)
-- Name: quantitative_kpi_notes fkb84h34g0dy0hpf0i8rhkcpma1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantitative_kpi_notes
    ADD CONSTRAINT fkb84h34g0dy0hpf0i8rhkcpma1 FOREIGN KEY (kpi_data_id) REFERENCES public.grant_quantitative_kpi_data(id);


--
-- TOC entry 3424 (class 2606 OID 123249)
-- Name: granters fkbfopvr9uc3vt0tqg1kom5yy6h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granters
    ADD CONSTRAINT fkbfopvr9uc3vt0tqg1kom5yy6h FOREIGN KEY (id) REFERENCES public.organizations(id);


--
-- TOC entry 3412 (class 2606 OID 123254)
-- Name: grants fkcmlj43405rmsfqlm0x4gs1cli; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grants
    ADD CONSTRAINT fkcmlj43405rmsfqlm0x4gs1cli FOREIGN KEY (grantor_org_id) REFERENCES public.granters(id);


--
-- TOC entry 3394 (class 2606 OID 123259)
-- Name: grant_history fkcmlj43405rmsfqlm0x4gs1cli; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_history
    ADD CONSTRAINT fkcmlj43405rmsfqlm0x4gs1cli FOREIGN KEY (grantor_org_id) REFERENCES public.granters(id);


--
-- TOC entry 3391 (class 2606 OID 123264)
-- Name: grant_document_kpi_data fkd1swedg4q3c9wfo8llld3lacn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_document_kpi_data
    ADD CONSTRAINT fkd1swedg4q3c9wfo8llld3lacn FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- TOC entry 3403 (class 2606 OID 123269)
-- Name: grant_specific_section_attributes fkdbh8rbyec5r524690vo6csgle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_specific_section_attributes
    ADD CONSTRAINT fkdbh8rbyec5r524690vo6csgle FOREIGN KEY (granter_id) REFERENCES public.granters(id);


--
-- TOC entry 3419 (class 2606 OID 123274)
-- Name: granter_grant_sections fkdv7se7knwl9xooqukbghcl261; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_sections
    ADD CONSTRAINT fkdv7se7knwl9xooqukbghcl261 FOREIGN KEY (granter_id) REFERENCES public.granters(id);


--
-- TOC entry 3406 (class 2606 OID 123279)
-- Name: grant_string_attributes fke0oju6e6wfkn6a8edf6v5sag9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_string_attributes
    ADD CONSTRAINT fke0oju6e6wfkn6a8edf6v5sag9 FOREIGN KEY (section_attribute_id) REFERENCES public.grant_specific_section_attributes(id);


--
-- TOC entry 3407 (class 2606 OID 123284)
-- Name: grant_string_attributes fke7k71toqd2cibb1p6ct63wc1w; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_string_attributes
    ADD CONSTRAINT fke7k71toqd2cibb1p6ct63wc1w FOREIGN KEY (grant_id) REFERENCES public.grants(id);


--
-- TOC entry 3420 (class 2606 OID 123289)
-- Name: granter_report_section_attributes fkey_report_section_attr_report_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_report_section_attributes
    ADD CONSTRAINT fkey_report_section_attr_report_section FOREIGN KEY (section_id) REFERENCES public.granter_report_sections(id);


--
-- TOC entry 3421 (class 2606 OID 123294)
-- Name: granter_report_section_attributes fkey_report_section_attrib_granter; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_report_section_attributes
    ADD CONSTRAINT fkey_report_section_attrib_granter FOREIGN KEY (granter_id) REFERENCES public.granters(id);


--
-- TOC entry 3422 (class 2606 OID 123299)
-- Name: granter_report_sections fkey_report_section_granter; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_report_sections
    ADD CONSTRAINT fkey_report_section_granter FOREIGN KEY (granter_id) REFERENCES public.granters(id);


--
-- TOC entry 3423 (class 2606 OID 123304)
-- Name: granter_report_sections fkey_report_section_report_template; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_report_sections
    ADD CONSTRAINT fkey_report_section_report_template FOREIGN KEY (report_template_id) REFERENCES public.granter_report_templates(id);


--
-- TOC entry 3432 (class 2606 OID 123309)
-- Name: report_specific_section_attributes fkey_report_sp_sec_attr_granter; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_specific_section_attributes
    ADD CONSTRAINT fkey_report_sp_sec_attr_granter FOREIGN KEY (granter_id) REFERENCES public.granters(id);


--
-- TOC entry 3433 (class 2606 OID 123314)
-- Name: report_specific_section_attributes fkey_report_sp_sec_attr_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_specific_section_attributes
    ADD CONSTRAINT fkey_report_sp_sec_attr_section FOREIGN KEY (section_id) REFERENCES public.report_specific_sections(id);


--
-- TOC entry 3434 (class 2606 OID 123319)
-- Name: report_specific_sections fkey_report_specific_section_granter; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_specific_sections
    ADD CONSTRAINT fkey_report_specific_section_granter FOREIGN KEY (granter_id) REFERENCES public.granters(id);


--
-- TOC entry 3436 (class 2606 OID 123324)
-- Name: report_string_attributes fkey_report_string_report; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_string_attributes
    ADD CONSTRAINT fkey_report_string_report FOREIGN KEY (report_id) REFERENCES public.reports(id);


--
-- TOC entry 3435 (class 2606 OID 123329)
-- Name: report_string_attribute_attachments fkey_string_attach_attrib; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_string_attribute_attachments
    ADD CONSTRAINT fkey_string_attach_attrib FOREIGN KEY (report_string_attribute_id) REFERENCES public.report_string_attributes(id);


--
-- TOC entry 3437 (class 2606 OID 123334)
-- Name: report_string_attributes fkey_string_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_string_attributes
    ADD CONSTRAINT fkey_string_section FOREIGN KEY (section_id) REFERENCES public.report_specific_sections(id);


--
-- TOC entry 3438 (class 2606 OID 123339)
-- Name: report_string_attributes fkey_string_section_attribs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_string_attributes
    ADD CONSTRAINT fkey_string_section_attribs FOREIGN KEY (section_attribute_id) REFERENCES public.report_specific_section_attributes(id);


--
-- TOC entry 3392 (class 2606 OID 123344)
-- Name: grant_document_kpi_data fkfeth01qga8x88vu374surppqo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_document_kpi_data
    ADD CONSTRAINT fkfeth01qga8x88vu374surppqo FOREIGN KEY (grant_kpi_id) REFERENCES public.grant_kpis(id);


--
-- TOC entry 3413 (class 2606 OID 123349)
-- Name: grants fkfxhc0yhlrne4obtxvc11skonn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grants
    ADD CONSTRAINT fkfxhc0yhlrne4obtxvc11skonn FOREIGN KEY (organization_id) REFERENCES public.grantees(id);


--
-- TOC entry 3395 (class 2606 OID 123354)
-- Name: grant_history fkfxhc0yhlrne4obtxvc11skonn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_history
    ADD CONSTRAINT fkfxhc0yhlrne4obtxvc11skonn FOREIGN KEY (organization_id) REFERENCES public.grantees(id);


--
-- TOC entry 3429 (class 2606 OID 123359)
-- Name: quant_kpi_data_document fkg1oub7mx2plcgg2rcmoo1x5lf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quant_kpi_data_document
    ADD CONSTRAINT fkg1oub7mx2plcgg2rcmoo1x5lf FOREIGN KEY (quant_kpi_data_id) REFERENCES public.grant_quantitative_kpi_data(id);


--
-- TOC entry 3400 (class 2606 OID 123364)
-- Name: grant_quantitative_kpi_data fkg6kxfcc72cocm6wqomsc8vu8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_quantitative_kpi_data
    ADD CONSTRAINT fkg6kxfcc72cocm6wqomsc8vu8 FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- TOC entry 3447 (class 2606 OID 123369)
-- Name: user_roles fkh8ciramu9cc9q3qcqiv4ue8a6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fkh8ciramu9cc9q3qcqiv4ue8a6 FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 3431 (class 2606 OID 123374)
-- Name: quantitative_kpi_notes fkhbitfsvff7a9lvilmsqg6j589; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantitative_kpi_notes
    ADD CONSTRAINT fkhbitfsvff7a9lvilmsqg6j589 FOREIGN KEY (posted_by_id) REFERENCES public.users(id);


--
-- TOC entry 3448 (class 2606 OID 123379)
-- Name: user_roles fkhfh9dx7w3ubf1co1vdev94g3f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fkhfh9dx7w3ubf1co1vdev94g3f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3416 (class 2606 OID 123384)
-- Name: granter_grant_section_attributes fkhj6nvncasmgr56s0t840loa8g; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_section_attributes
    ADD CONSTRAINT fkhj6nvncasmgr56s0t840loa8g FOREIGN KEY (section_id) REFERENCES public.granter_grant_sections(id);


--
-- TOC entry 3452 (class 2606 OID 123389)
-- Name: workflow_status_transitions fkhq3p8mrvunploh7713igtaowk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_status_transitions
    ADD CONSTRAINT fkhq3p8mrvunploh7713igtaowk FOREIGN KEY (from_state_id) REFERENCES public.workflow_statuses(id);


--
-- TOC entry 3441 (class 2606 OID 123394)
-- Name: roles_permission fkigkyo0gp095cm55sjfgy0i4lg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_permission
    ADD CONSTRAINT fkigkyo0gp095cm55sjfgy0i4lg FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 3402 (class 2606 OID 123399)
-- Name: grant_section_attributes fkj9i8la8732x3w55fujra47bv3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_section_attributes
    ADD CONSTRAINT fkj9i8la8732x3w55fujra47bv3 FOREIGN KEY (section_id) REFERENCES public.grant_sections(id);


--
-- TOC entry 3453 (class 2606 OID 123404)
-- Name: workflow_status_transitions fkjg8davo6hmqd2ailb3ysnwt8j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_status_transitions
    ADD CONSTRAINT fkjg8davo6hmqd2ailb3ysnwt8j FOREIGN KEY (to_state_id) REFERENCES public.workflow_statuses(id);


--
-- TOC entry 3444 (class 2606 OID 123409)
-- Name: submissions fkjkfxsyttwtbnpuitanuceacvh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fkjkfxsyttwtbnpuitanuceacvh FOREIGN KEY (submission_status_id) REFERENCES public.workflow_statuses(id);


--
-- TOC entry 3415 (class 2606 OID 123414)
-- Name: workflow_statuses fkjo7ovfj3t6h7u3nqbflbk2s2n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_statuses
    ADD CONSTRAINT fkjo7ovfj3t6h7u3nqbflbk2s2n FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- TOC entry 3387 (class 2606 OID 123419)
-- Name: document_kpi_notes fkjymhkyqqmvrsj6rjgmxl8rid7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_kpi_notes
    ADD CONSTRAINT fkjymhkyqqmvrsj6rjgmxl8rid7 FOREIGN KEY (posted_by_id) REFERENCES public.users(id);


--
-- TOC entry 3414 (class 2606 OID 123424)
-- Name: grants fkldpdqi1vkhahlhaxn5o25vdfa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grants
    ADD CONSTRAINT fkldpdqi1vkhahlhaxn5o25vdfa FOREIGN KEY (grant_status_id) REFERENCES public.workflow_statuses(id);


--
-- TOC entry 3396 (class 2606 OID 123429)
-- Name: grant_history fkldpdqi1vkhahlhaxn5o25vdfa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_history
    ADD CONSTRAINT fkldpdqi1vkhahlhaxn5o25vdfa FOREIGN KEY (grant_status_id) REFERENCES public.workflow_statuses(id);


--
-- TOC entry 3405 (class 2606 OID 123434)
-- Name: grant_specific_sections fklvg23wp6dijbxa3v3kjdu9nfx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_specific_sections
    ADD CONSTRAINT fklvg23wp6dijbxa3v3kjdu9nfx FOREIGN KEY (granter_id) REFERENCES public.granters(id);


--
-- TOC entry 3399 (class 2606 OID 123439)
-- Name: grant_qualitative_kpi_data fkn34tany3kjr076gbk9otq63y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_qualitative_kpi_data
    ADD CONSTRAINT fkn34tany3kjr076gbk9otq63y FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- TOC entry 3388 (class 2606 OID 123444)
-- Name: grant_document_attributes fknuwf3wvq93wu1phuao51v1dje; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_document_attributes
    ADD CONSTRAINT fknuwf3wvq93wu1phuao51v1dje FOREIGN KEY (section_attribute_id) REFERENCES public.grant_specific_section_attributes(id);


--
-- TOC entry 3404 (class 2606 OID 123449)
-- Name: grant_specific_section_attributes fkog7mxdfqa5ngcywqhqj7yub4v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_specific_section_attributes
    ADD CONSTRAINT fkog7mxdfqa5ngcywqhqj7yub4v FOREIGN KEY (section_id) REFERENCES public.grant_specific_sections(id);


--
-- TOC entry 3445 (class 2606 OID 123454)
-- Name: submissions fkps9tdguurx5s3f5hc8j5s3bwl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fkps9tdguurx5s3f5hc8j5s3bwl FOREIGN KEY (grant_id) REFERENCES public.grants(id);


--
-- TOC entry 3454 (class 2606 OID 123459)
-- Name: workflow_status_transitions fkpu2gecbcrsvf2ofw7uaye2nme; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_status_transitions
    ADD CONSTRAINT fkpu2gecbcrsvf2ofw7uaye2nme FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 3428 (class 2606 OID 123464)
-- Name: qualitative_kpi_notes fkq01w3ym97a2c2sjwbssxc7n6p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualitative_kpi_notes
    ADD CONSTRAINT fkq01w3ym97a2c2sjwbssxc7n6p FOREIGN KEY (kpi_data_id) REFERENCES public.grant_qualitative_kpi_data(id);


--
-- TOC entry 3389 (class 2606 OID 123469)
-- Name: grant_document_attributes fkqe5w0pys59b28wcs78qkvgq6i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_document_attributes
    ADD CONSTRAINT fkqe5w0pys59b28wcs78qkvgq6i FOREIGN KEY (grant_id) REFERENCES public.grants(id);


--
-- TOC entry 3440 (class 2606 OID 123474)
-- Name: roles fkqjj9a6xa11cu9ch24cjo4a7lc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT fkqjj9a6xa11cu9ch24cjo4a7lc FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- TOC entry 3410 (class 2606 OID 123479)
-- Name: users fkqpugllwvyv37klq7ft9m8aqxk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fkqpugllwvyv37klq7ft9m8aqxk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- TOC entry 3385 (class 2606 OID 123484)
-- Name: doc_kpi_data_document fkqq0q2blu7i17tf5cvbbwn2tga; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_kpi_data_document
    ADD CONSTRAINT fkqq0q2blu7i17tf5cvbbwn2tga FOREIGN KEY (doc_kpi_data_id) REFERENCES public.grant_document_kpi_data(id);


--
-- TOC entry 3401 (class 2606 OID 123489)
-- Name: grant_quantitative_kpi_data fkqug9yc5krkhldtu4mn6b1yjys; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_quantitative_kpi_data
    ADD CONSTRAINT fkqug9yc5krkhldtu4mn6b1yjys FOREIGN KEY (grant_kpi_id) REFERENCES public.grant_kpis(id);


--
-- TOC entry 3408 (class 2606 OID 123494)
-- Name: grant_string_attributes fkqwys16hap4lvhe2uucqhsvmo7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_string_attributes
    ADD CONSTRAINT fkqwys16hap4lvhe2uucqhsvmo7 FOREIGN KEY (section_id) REFERENCES public.grant_specific_sections(id);


--
-- TOC entry 3426 (class 2606 OID 123499)
-- Name: qual_kpi_data_document fkr8y48i4gsqpjk9984traqneg8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qual_kpi_data_document
    ADD CONSTRAINT fkr8y48i4gsqpjk9984traqneg8 FOREIGN KEY (qual_kpi_data_id) REFERENCES public.grant_qualitative_kpi_data(id);


--
-- TOC entry 3439 (class 2606 OID 123504)
-- Name: rfps fks7co3jiv2plm3i63rrk2kht4a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rfps
    ADD CONSTRAINT fks7co3jiv2plm3i63rrk2kht4a FOREIGN KEY (granter_id) REFERENCES public.granters(id);


--
-- TOC entry 3390 (class 2606 OID 123509)
-- Name: grant_document_attributes fksidslnyudy16lf7tkrrxlb75i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_document_attributes
    ADD CONSTRAINT fksidslnyudy16lf7tkrrxlb75i FOREIGN KEY (section_id) REFERENCES public.grant_specific_sections(id);


--
-- TOC entry 3450 (class 2606 OID 123514)
-- Name: workflow_state_permissions fksnxqpq7xuci1fd5muwwl75pss; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_state_permissions
    ADD CONSTRAINT fksnxqpq7xuci1fd5muwwl75pss FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 3417 (class 2606 OID 123519)
-- Name: granter_grant_section_attributes fkt0fnvb7pgysqnrlb92r2pafxh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.granter_grant_section_attributes
    ADD CONSTRAINT fkt0fnvb7pgysqnrlb92r2pafxh FOREIGN KEY (granter_id) REFERENCES public.granters(id);


--
-- TOC entry 3639 (class 0 OID 122648)
-- Dependencies: 249 3725
-- Name: granter_active_users; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.granter_active_users;


--
-- TOC entry 3642 (class 0 OID 122668)
-- Dependencies: 252 3725
-- Name: granter_count_and_amount_totals; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.granter_count_and_amount_totals;


--
-- TOC entry 3649 (class 0 OID 122696)
-- Dependencies: 259 3725
-- Name: granter_grantees; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.granter_grantees;


-- Completed on 2021-01-12 21:59:17

--
-- PostgreSQL database dump complete
--

