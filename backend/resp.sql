--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

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
-- Name: movementtype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.movementtype AS ENUM (
    'ENTRY',
    'EXIT',
    'ADJUSTMENT',
    'TRANSFER'
);


ALTER TYPE public.movementtype OWNER TO postgres;

--
-- Name: paymentterms; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.paymentterms AS ENUM (
    'CASH',
    'NET_15',
    'NET_30',
    'NET_60',
    'NET_90'
);


ALTER TYPE public.paymentterms OWNER TO postgres;

--
-- Name: purchaseorderstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.purchaseorderstatus AS ENUM (
    'DRAFT',
    'PENDING',
    'APPROVED',
    'ORDERED',
    'PARTIALLY_RECEIVED',
    'RECEIVED',
    'CANCELLED'
);


ALTER TYPE public.purchaseorderstatus OWNER TO postgres;

--
-- Name: userrole; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.userrole AS ENUM (
    'ADMIN',
    'MANAGER',
    'EMPLOYEE',
    'VIEWER',
    'ALMACENISTA',
    'CAPTURISTA'
);


ALTER TYPE public.userrole OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_log (
    id integer NOT NULL,
    user_email character varying(255),
    action character varying(255) NOT NULL,
    details text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.activity_log OWNER TO postgres;

--
-- Name: activity_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_log_id_seq OWNER TO postgres;

--
-- Name: activity_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_log_id_seq OWNED BY public.activity_log.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: attendance_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance_logs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    office_id integer NOT NULL,
    check_type character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    is_valid boolean DEFAULT false,
    ip_address character varying,
    device_info character varying,
    selfie_url character varying,
    notes character varying
);


ALTER TABLE public.attendance_logs OWNER TO postgres;

--
-- Name: attendance_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendance_logs_id_seq OWNER TO postgres;

--
-- Name: attendance_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_logs_id_seq OWNED BY public.attendance_logs.id;


--
-- Name: brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brands (
    id integer NOT NULL,
    business_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    code character varying(50),
    country character varying(100),
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.brands OWNER TO postgres;

--
-- Name: brands_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.brands_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.brands_id_seq OWNER TO postgres;

--
-- Name: brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.brands_id_seq OWNED BY public.brands.id;


--
-- Name: business_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business_users (
    id integer NOT NULL,
    business_id integer NOT NULL,
    user_id integer NOT NULL,
    role public.userrole,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.business_users OWNER TO postgres;

--
-- Name: business_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.business_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.business_users_id_seq OWNER TO postgres;

--
-- Name: business_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.business_users_id_seq OWNED BY public.business_users.id;


--
-- Name: businesses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.businesses (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    code character varying(50),
    tax_id character varying(50),
    rfc character varying(50),
    address text,
    phone character varying(20),
    email character varying(255),
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.businesses OWNER TO postgres;

--
-- Name: businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.businesses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.businesses_id_seq OWNER TO postgres;

--
-- Name: businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.businesses_id_seq OWNED BY public.businesses.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    business_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    code character varying(50),
    parent_id integer,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    product_variant_id integer NOT NULL,
    unit_id integer NOT NULL,
    quantity double precision,
    minimum_stock double precision,
    maximum_stock double precision,
    updated_at timestamp with time zone
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- Name: inventory_adjustment_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_adjustment_items (
    id integer NOT NULL,
    adjustment_id integer NOT NULL,
    product_variant_id integer NOT NULL,
    unit_id integer NOT NULL,
    expected_quantity double precision NOT NULL,
    actual_quantity double precision NOT NULL,
    difference double precision NOT NULL,
    unit_cost double precision,
    total_cost_impact double precision
);


ALTER TABLE public.inventory_adjustment_items OWNER TO postgres;

--
-- Name: inventory_adjustment_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_adjustment_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_adjustment_items_id_seq OWNER TO postgres;

--
-- Name: inventory_adjustment_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_adjustment_items_id_seq OWNED BY public.inventory_adjustment_items.id;


--
-- Name: inventory_adjustments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_adjustments (
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    adjustment_number character varying NOT NULL,
    adjustment_type character varying NOT NULL,
    reason character varying NOT NULL,
    notes text,
    user_id integer NOT NULL,
    status character varying,
    approved_by integer,
    approved_at timestamp with time zone,
    applied_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.inventory_adjustments OWNER TO postgres;

--
-- Name: inventory_adjustments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_adjustments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_adjustments_id_seq OWNER TO postgres;

--
-- Name: inventory_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_adjustments_id_seq OWNED BY public.inventory_adjustments.id;


--
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_id_seq OWNER TO postgres;

--
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventory.id;


--
-- Name: inventory_movements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_movements (
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    product_variant_id integer NOT NULL,
    unit_id integer NOT NULL,
    user_id integer NOT NULL,
    movement_type public.movementtype NOT NULL,
    quantity double precision NOT NULL,
    cost_per_unit double precision,
    previous_quantity double precision,
    new_quantity double precision,
    batch_number character varying(100),
    expiry_date timestamp without time zone,
    reference_number character varying(100),
    reason character varying(500),
    notes text,
    destination_warehouse_id integer,
    purchase_order_id integer,
    purchase_order_receipt_id integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.inventory_movements OWNER TO postgres;

--
-- Name: inventory_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_movements_id_seq OWNER TO postgres;

--
-- Name: inventory_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_movements_id_seq OWNED BY public.inventory_movements.id;


--
-- Name: login_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_attempts (
    id integer NOT NULL,
    user_email character varying(255) NOT NULL,
    ip_address character varying(64),
    success boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.login_attempts OWNER TO postgres;

--
-- Name: login_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.login_attempts_id_seq OWNER TO postgres;

--
-- Name: login_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_attempts_id_seq OWNED BY public.login_attempts.id;


--
-- Name: offices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offices (
    id integer NOT NULL,
    name character varying NOT NULL,
    gps_lat double precision NOT NULL,
    gps_lng double precision NOT NULL,
    radius_meters integer NOT NULL,
    checkin_start character varying NOT NULL,
    checkout_end character varying NOT NULL
);


ALTER TABLE public.offices OWNER TO postgres;

--
-- Name: offices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.offices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.offices_id_seq OWNER TO postgres;

--
-- Name: offices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.offices_id_seq OWNED BY public.offices.id;


--
-- Name: product_variants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variants (
    id integer NOT NULL,
    product_id integer NOT NULL,
    name character varying(200),
    sku character varying(100),
    barcode character varying(100),
    attributes text,
    cost_price double precision,
    selling_price double precision,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.product_variants OWNER TO postgres;

--
-- Name: product_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_variants_id_seq OWNER TO postgres;

--
-- Name: product_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_variants_id_seq OWNED BY public.product_variants.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    business_id integer NOT NULL,
    category_id integer,
    brand_id integer,
    name character varying(200) NOT NULL,
    description text,
    sku character varying(100),
    barcode character varying(100),
    base_unit_id integer,
    minimum_stock double precision,
    maximum_stock double precision,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    start_date date,
    end_date date,
    budget integer,
    notes text,
    owner_id integer
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_id_seq OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_order_items (
    id integer NOT NULL,
    purchase_order_id integer NOT NULL,
    product_variant_id integer NOT NULL,
    unit_id integer NOT NULL,
    quantity_ordered double precision NOT NULL,
    quantity_received double precision,
    quantity_pending double precision,
    unit_cost double precision NOT NULL,
    total_cost double precision,
    product_name character varying(200),
    product_sku character varying(100),
    supplier_sku character varying(100),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.purchase_order_items OWNER TO postgres;

--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_order_items_id_seq OWNER TO postgres;

--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_order_items_id_seq OWNED BY public.purchase_order_items.id;


--
-- Name: purchase_order_receipt_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_order_receipt_items (
    id integer NOT NULL,
    receipt_id integer NOT NULL,
    purchase_order_item_id integer NOT NULL,
    quantity_received double precision NOT NULL,
    quantity_accepted double precision,
    quantity_rejected double precision,
    batch_number character varying(100),
    expiry_date timestamp without time zone,
    quality_status character varying(50),
    notes text,
    rejection_reason text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.purchase_order_receipt_items OWNER TO postgres;

--
-- Name: purchase_order_receipt_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_order_receipt_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_order_receipt_items_id_seq OWNER TO postgres;

--
-- Name: purchase_order_receipt_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_order_receipt_items_id_seq OWNED BY public.purchase_order_receipt_items.id;


--
-- Name: purchase_order_receipts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_order_receipts (
    id integer NOT NULL,
    purchase_order_id integer NOT NULL,
    warehouse_id integer NOT NULL,
    user_id integer NOT NULL,
    receipt_number character varying(100),
    receipt_date timestamp with time zone DEFAULT now(),
    supplier_invoice_number character varying(100),
    supplier_delivery_note character varying(100),
    status character varying(50),
    notes text,
    quality_notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.purchase_order_receipts OWNER TO postgres;

--
-- Name: purchase_order_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_order_receipts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_order_receipts_id_seq OWNER TO postgres;

--
-- Name: purchase_order_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_order_receipts_id_seq OWNED BY public.purchase_order_receipts.id;


--
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_orders (
    id integer NOT NULL,
    business_id integer NOT NULL,
    supplier_id integer NOT NULL,
    warehouse_id integer NOT NULL,
    user_id integer NOT NULL,
    order_number character varying(100) NOT NULL,
    supplier_reference character varying(100),
    status public.purchaseorderstatus,
    order_date timestamp with time zone DEFAULT now(),
    expected_delivery_date timestamp without time zone,
    actual_delivery_date timestamp without time zone,
    subtotal double precision,
    tax_amount double precision,
    shipping_cost double precision,
    discount_amount double precision,
    total_amount double precision,
    payment_terms public.paymentterms,
    payment_status character varying(50),
    notes text,
    internal_notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    approved_at timestamp without time zone,
    approved_by_id integer
);


ALTER TABLE public.purchase_orders OWNER TO postgres;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_orders_id_seq OWNER TO postgres;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_orders_id_seq OWNED BY public.purchase_orders.id;


--
-- Name: sale_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sale_items (
    id integer NOT NULL,
    sale_id integer NOT NULL,
    product_variant_id integer NOT NULL,
    unit_id integer NOT NULL,
    quantity double precision NOT NULL,
    unit_price double precision NOT NULL,
    total_price double precision NOT NULL
);


ALTER TABLE public.sale_items OWNER TO postgres;

--
-- Name: sale_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sale_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sale_items_id_seq OWNER TO postgres;

--
-- Name: sale_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sale_items_id_seq OWNED BY public.sale_items.id;


--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    user_id integer NOT NULL,
    sale_number character varying NOT NULL,
    date timestamp with time zone DEFAULT now(),
    payment_method character varying NOT NULL,
    subtotal double precision,
    tax double precision,
    discount double precision,
    total double precision,
    customer_name character varying,
    customer_email character varying,
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_id_seq OWNER TO postgres;

--
-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;


--
-- Name: stock_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_alerts (
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    product_variant_id integer NOT NULL,
    alert_type character varying NOT NULL,
    current_quantity double precision NOT NULL,
    minimum_quantity double precision,
    maximum_quantity double precision,
    is_resolved boolean,
    resolved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.stock_alerts OWNER TO postgres;

--
-- Name: stock_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_alerts_id_seq OWNER TO postgres;

--
-- Name: stock_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stock_alerts_id_seq OWNED BY public.stock_alerts.id;


--
-- Name: supplier_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier_products (
    id integer NOT NULL,
    supplier_id integer NOT NULL,
    product_variant_id integer NOT NULL,
    supplier_sku character varying(100),
    supplier_product_name character varying(200),
    cost_price double precision NOT NULL,
    minimum_order_quantity double precision,
    lead_time_days integer,
    is_active boolean,
    is_preferred boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.supplier_products OWNER TO postgres;

--
-- Name: supplier_products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplier_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supplier_products_id_seq OWNER TO postgres;

--
-- Name: supplier_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplier_products_id_seq OWNED BY public.supplier_products.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    business_id integer NOT NULL,
    name character varying(200) NOT NULL,
    company_name character varying(200),
    tax_id character varying(50),
    email character varying(255),
    phone character varying(20),
    mobile character varying(20),
    website character varying(255),
    address text,
    city character varying(100),
    state character varying(100),
    postal_code character varying(20),
    country character varying(100),
    payment_terms public.paymentterms,
    credit_limit double precision,
    discount_percentage double precision,
    contact_person character varying(200),
    contact_title character varying(100),
    contact_email character varying(255),
    contact_phone character varying(20),
    is_active boolean,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suppliers_id_seq OWNER TO postgres;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    project_id integer,
    title character varying NOT NULL,
    description text,
    status character varying DEFAULT 'pendiente'::character varying,
    priority character varying DEFAULT 'media'::character varying,
    due_date date,
    reminder_date date,
    responsible_id integer,
    checklist text,
    comments text,
    attachments text,
    history text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasks_id_seq OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.units (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    symbol character varying(10) NOT NULL,
    unit_type character varying(20),
    conversion_factor double precision,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.units OWNER TO postgres;

--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.units_id_seq OWNER TO postgres;

--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    business_id integer NOT NULL,
    role character varying NOT NULL,
    permissions json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_roles_id_seq OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    role public.userrole,
    is_active boolean,
    is_superuser boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    must_change_password boolean DEFAULT false,
    "position" character varying(100),
    hire_date timestamp without time zone,
    phone character varying(20),
    address text,
    birth_date timestamp without time zone,
    nss character varying(20),
    curp character varying(20),
    emergency_contact character varying(100),
    emergency_phone character varying(20),
    hashed_password character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: warehouses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warehouses (
    id integer NOT NULL,
    business_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    code character varying(50),
    address text,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.warehouses OWNER TO postgres;

--
-- Name: warehouses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.warehouses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouses_id_seq OWNER TO postgres;

--
-- Name: warehouses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.warehouses_id_seq OWNED BY public.warehouses.id;


--
-- Name: activity_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_log ALTER COLUMN id SET DEFAULT nextval('public.activity_log_id_seq'::regclass);


--
-- Name: attendance_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_logs ALTER COLUMN id SET DEFAULT nextval('public.attendance_logs_id_seq'::regclass);


--
-- Name: brands id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands ALTER COLUMN id SET DEFAULT nextval('public.brands_id_seq'::regclass);


--
-- Name: business_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_users ALTER COLUMN id SET DEFAULT nextval('public.business_users_id_seq'::regclass);


--
-- Name: businesses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesses ALTER COLUMN id SET DEFAULT nextval('public.businesses_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: inventory id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- Name: inventory_adjustment_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment_items ALTER COLUMN id SET DEFAULT nextval('public.inventory_adjustment_items_id_seq'::regclass);


--
-- Name: inventory_adjustments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustments ALTER COLUMN id SET DEFAULT nextval('public.inventory_adjustments_id_seq'::regclass);


--
-- Name: inventory_movements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements ALTER COLUMN id SET DEFAULT nextval('public.inventory_movements_id_seq'::regclass);


--
-- Name: login_attempts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_attempts ALTER COLUMN id SET DEFAULT nextval('public.login_attempts_id_seq'::regclass);


--
-- Name: offices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offices ALTER COLUMN id SET DEFAULT nextval('public.offices_id_seq'::regclass);


--
-- Name: product_variants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants ALTER COLUMN id SET DEFAULT nextval('public.product_variants_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: purchase_order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_items_id_seq'::regclass);


--
-- Name: purchase_order_receipt_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_receipt_items ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_receipt_items_id_seq'::regclass);


--
-- Name: purchase_order_receipts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_receipts ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_receipts_id_seq'::regclass);


--
-- Name: purchase_orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders ALTER COLUMN id SET DEFAULT nextval('public.purchase_orders_id_seq'::regclass);


--
-- Name: sale_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_items ALTER COLUMN id SET DEFAULT nextval('public.sale_items_id_seq'::regclass);


--
-- Name: sales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- Name: stock_alerts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_alerts ALTER COLUMN id SET DEFAULT nextval('public.stock_alerts_id_seq'::regclass);


--
-- Name: supplier_products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_products ALTER COLUMN id SET DEFAULT nextval('public.supplier_products_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: warehouses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouses ALTER COLUMN id SET DEFAULT nextval('public.warehouses_id_seq'::regclass);


--
-- Data for Name: activity_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_log (id, user_email, action, details, created_at) FROM stdin;
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
065c831b33a1
\.


--
-- Data for Name: attendance_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance_logs (id, user_id, office_id, check_type, "timestamp", latitude, longitude, is_valid, ip_address, device_info, selfie_url, notes) FROM stdin;
\.


--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brands (id, business_id, name, description, code, country, is_active, created_at, updated_at) FROM stdin;
1	1	Coca-Cola	Bebidas refrescantes	CC	México	t	2025-07-06 18:09:31.879353+00	\N
2	1	Bimbo	Productos de panadería	BIM	México	t	2025-07-06 18:09:31.879353+00	\N
3	1	Nestlé	Alimentos y bebidas	NES	Suiza	t	2025-07-06 18:09:31.879353+00	\N
4	1	Lala	Productos lácteos	LAL	México	t	2025-07-06 18:09:31.879353+00	\N
5	1	Maseca	Harinas y tortillas	MAS	México	t	2025-07-06 18:09:31.879353+00	\N
6	1	Fabuloso	Productos de limpieza	FAB	México	t	2025-07-06 18:09:31.879353+00	\N
7	2	SANFER	\N	SANFER	\N	t	2025-07-06 18:15:31.579651+00	\N
8	2	SBL	\N	SBL	\N	t	2025-07-06 18:15:31.579651+00	\N
9	2	SCHERING-PLOUGH	\N	SCHERING-PLOUGH	\N	t	2025-07-06 18:15:31.579651+00	\N
10	2	IFA	\N	IFA	\N	t	2025-07-06 18:15:31.579651+00	\N
11	2	SANOFI	\N	SANOFI	\N	t	2025-07-06 18:15:31.579651+00	\N
12	2	COLLINS	\N	COLLINS	\N	t	2025-07-06 18:15:31.579651+00	\N
13	2	AMSA	\N	AMSA	\N	t	2025-07-06 18:15:31.579651+00	\N
14	2	LABS LOPEZ	\N	LABS_LOPEZ	\N	t	2025-07-06 18:15:31.579651+00	\N
15	2	CHINOIN	\N	CHINOIN	\N	t	2025-07-06 18:15:31.579651+00	\N
16	2	GENOMALAB	\N	GENOMALAB	\N	t	2025-07-06 18:15:31.579651+00	\N
17	2	SANA-X	\N	SANA-X	\N	t	2025-07-06 18:15:31.579651+00	\N
18	2	BAYER	\N	BAYER	\N	t	2025-07-06 18:15:31.579651+00	\N
19	2	APOTEX	\N	APOTEX	\N	t	2025-07-06 18:15:31.579651+00	\N
20	2	RANDALL	\N	RANDALL	\N	t	2025-07-06 18:15:31.579651+00	\N
21	2	PHARMAGEN	\N	PHARMAGEN	\N	t	2025-07-06 18:15:31.579651+00	\N
22	2	GLAXO SMITH KLINE	\N	GLAXO_SMITH_KLINE	\N	t	2025-07-06 18:15:31.579651+00	\N
23	2	HORMONA	\N	HORMONA	\N	t	2025-07-06 18:15:31.579651+00	\N
24	2	HEALTH TEC	\N	HEALTH_TEC	\N	t	2025-07-06 18:15:31.579651+00	\N
25	2	NOVAG	\N	NOVAG	\N	t	2025-07-06 18:15:32.131756+00	\N
26	2	TERAMED	\N	TERAMED	\N	t	2025-07-06 18:15:32.131756+00	\N
27	2	SONS	\N	SONS	\N	t	2025-07-06 18:15:32.131756+00	\N
28	2	LOEFFLER	\N	LOEFFLER	\N	t	2025-07-06 18:15:32.131756+00	\N
29	2	ULTRA	\N	ULTRA	\N	t	2025-07-06 18:15:32.131756+00	\N
30	2	BIOKEMICAL	\N	BIOKEMICAL	\N	t	2025-07-06 18:15:32.131756+00	\N
31	2	MAVER	\N	MAVER	\N	t	2025-07-06 18:15:32.131756+00	\N
32	2	SANDOZ	\N	SANDOZ	\N	t	2025-07-06 18:15:32.131756+00	\N
33	2	MAVI	\N	MAVI	\N	t	2025-07-06 18:15:32.131756+00	\N
34	2	DEGORTS CHEMICAL	\N	DEGORTS_CHEMICAL	\N	t	2025-07-06 18:15:32.131756+00	\N
35	2	PROSA	\N	PROSA	\N	t	2025-07-06 18:15:32.131756+00	\N
36	2	GROSSMAN	\N	GROSSMAN	\N	t	2025-07-06 18:15:32.596194+00	\N
37	2	GENOMA	\N	GENOMA	\N	t	2025-07-06 18:15:32.596194+00	\N
38	2	BOEHRINGER INGELHEIM	\N	BOEHRINGER_INGELHEIM	\N	t	2025-07-06 18:15:32.596194+00	\N
39	2	PFIZER	\N	PFIZER	\N	t	2025-07-06 18:15:32.596194+00	\N
40	2	RAYERE	\N	RAYERE	\N	t	2025-07-06 18:15:32.596194+00	\N
41	2	LIOMONT	\N	LIOMONT	\N	t	2025-07-06 18:15:32.596194+00	\N
42	2	BRULUART	\N	BRULUART	\N	t	2025-07-06 18:15:32.596194+00	\N
43	2	BIOSEARCH	\N	BIOSEARCH	\N	t	2025-07-06 18:15:32.596194+00	\N
44	2	SIEGFRIED RHEIN	\N	SIEGFRIED_RHEIN	\N	t	2025-07-06 18:15:32.596194+00	\N
45	2	LILLY	\N	LILLY	\N	t	2025-07-06 18:15:32.596194+00	\N
46	2	MEDICOR	\N	MEDICOR	\N	t	2025-07-06 18:15:33.119584+00	\N
47	2	ALTIA	\N	ALTIA	\N	t	2025-07-06 18:15:33.119584+00	\N
48	2	SAIMED	\N	SAIMED	\N	t	2025-07-06 18:15:33.119584+00	\N
49	2	VICTORY	\N	VICTORY	\N	t	2025-07-06 18:15:33.119584+00	\N
50	2	PSICOFARMA	\N	PSICOFARMA	\N	t	2025-07-06 18:15:33.119584+00	\N
51	2	BIOMEP	\N	BIOMEP	\N	t	2025-07-06 18:15:33.119584+00	\N
52	2	SERRAL	\N	SERRAL	\N	t	2025-07-06 18:15:33.119584+00	\N
53	2	ARMSTRON	\N	ARMSTRON	\N	t	2025-07-06 18:15:33.119584+00	\N
54	2	AVIVIA	\N	AVIVIA	\N	t	2025-07-06 18:15:33.119584+00	\N
55	2	EVOLUTION	\N	EVOLUTION	\N	t	2025-07-06 18:15:33.119584+00	\N
56	2	WYETH	\N	WYETH	\N	t	2025-07-06 18:15:33.119584+00	\N
57	2	GENETICA	\N	GENETICA	\N	t	2025-07-06 18:15:33.119584+00	\N
58	2	GEL PHARMA	\N	GEL_PHARMA	\N	t	2025-07-06 18:15:33.119584+00	\N
59	2	AVITUS	\N	AVITUS	\N	t	2025-07-06 18:15:33.734133+00	\N
60	2	ALCON	\N	ALCON	\N	t	2025-07-06 18:15:33.734133+00	\N
61	2	NORDIN	\N	NORDIN	\N	t	2025-07-06 18:15:33.734133+00	\N
62	2	PISA	\N	PISA	\N	t	2025-07-06 18:15:33.734133+00	\N
63	2	CHEMICAL	\N	CHEMICAL	\N	t	2025-07-06 18:15:33.734133+00	\N
64	2	NOVO PHARMA	\N	NOVO_PHARMA	\N	t	2025-07-06 18:15:33.734133+00	\N
65	2	ARMSTRONG	\N	ARMSTRONG	\N	t	2025-07-06 18:15:33.734133+00	\N
66	2	CARNOT LABORATORIOS	\N	CARNOT_LABORATORIOS	\N	t	2025-07-06 18:15:33.734133+00	\N
67	2	ALMIRALL	\N	ALMIRALL	\N	t	2025-07-06 18:15:33.734133+00	\N
68	2	WANDELL	\N	WANDELL	\N	t	2025-07-06 18:15:34.431597+00	\N
69	2	MEDLEY	\N	MEDLEY	\N	t	2025-07-06 18:15:34.431597+00	\N
70	2	KURAMEX	\N	KURAMEX	\N	t	2025-07-06 18:15:34.431597+00	\N
71	2	VIVALIVE	\N	VIVALIVE	\N	t	2025-07-06 18:15:34.431597+00	\N
72	2	SEGFREID RHEIN	\N	SEGFREID_RHEIN	\N	t	2025-07-06 18:15:34.431597+00	\N
73	2	LIFERPAL	\N	LIFERPAL	\N	t	2025-07-06 18:15:34.431597+00	\N
74	2	SILANES	\N	SILANES	\N	t	2025-07-06 18:15:34.431597+00	\N
75	2	ANAHUAC	\N	ANAHUAC	\N	t	2025-07-06 18:15:34.431597+00	\N
76	2	RIMSA	\N	RIMSA	\N	t	2025-07-06 18:15:34.993098+00	\N
77	2	SANDY	\N	SANDY	\N	t	2025-07-06 18:15:34.993098+00	\N
78	2	INDIO PAPAGO	\N	INDIO_PAPAGO	\N	t	2025-07-06 18:15:34.993098+00	\N
79	2	FARNAT	\N	FARNAT	\N	t	2025-07-06 18:15:34.993098+00	\N
80	2	SALUS	\N	SALUS	\N	t	2025-07-06 18:15:34.993098+00	\N
81	2	UCB DE MEXICO	\N	UCB_DE_MEXICO	\N	t	2025-07-06 18:15:34.993098+00	\N
82	2	ARANDA	\N	ARANDA	\N	t	2025-07-06 18:15:34.993098+00	\N
83	2	PLANTIMEX	\N	PLANTIMEX	\N	t	2025-07-06 18:15:34.993098+00	\N
84	2	YPENSA	\N	YPENSA	\N	t	2025-07-06 18:15:34.993098+00	\N
85	2	BEKA	\N	BEKA	\N	t	2025-07-06 18:15:34.993098+00	\N
86	2	STILLMAN	\N	STILLMAN	\N	t	2025-07-06 18:15:34.993098+00	\N
87	2	EKO	\N	EKO	\N	t	2025-07-06 18:15:34.993098+00	\N
88	2	JOHNSON & JOHNSON	\N	JOHNSON_&_JOHNSON	\N	t	2025-07-06 18:15:34.993098+00	\N
89	2	BEST	\N	BEST	\N	t	2025-07-06 18:15:34.993098+00	\N
90	2	BIORESEARCH	\N	BIORESEARCH	\N	t	2025-07-06 18:15:35.590019+00	\N
91	2	DEGORTS	\N	DEGORTS	\N	t	2025-07-06 18:15:35.590019+00	\N
92	2	GN+VIDA	\N	GN+VIDA	\N	t	2025-07-06 18:15:35.590019+00	\N
93	2	ALPRIMA	\N	ALPRIMA	\N	t	2025-07-06 18:15:35.590019+00	\N
94	2	LA SALUD ES PRIMERO	\N	LA_SALUD_ES_PRIMERO	\N	t	2025-07-06 18:15:35.590019+00	\N
95	2	BIOMIRAL	\N	BIOMIRAL	\N	t	2025-07-06 18:15:35.590019+00	\N
96	2	AZTRA ZENECA	\N	AZTRA_ZENECA	\N	t	2025-07-06 18:15:35.590019+00	\N
97	2	BUSTILLOS	\N	BUSTILLOS	\N	t	2025-07-06 18:15:35.590019+00	\N
98	2	VALEANT	\N	VALEANT	\N	t	2025-07-06 18:15:35.590019+00	\N
99	2	ATANTLIS	\N	ATANTLIS	\N	t	2025-07-06 18:15:35.590019+00	\N
100	2	COLUMBIA	\N	COLUMBIA	\N	t	2025-07-06 18:15:35.590019+00	\N
101	2	COYOACAN QUIMICA	\N	COYOACAN_QUIMICA	\N	t	2025-07-06 18:15:35.590019+00	\N
102	2	PERRIGO	\N	PERRIGO	\N	t	2025-07-06 18:15:36.165131+00	\N
103	2	DEGORTS/CHEMICAL	\N	DEGORTS/CHEMICAL	\N	t	2025-07-06 18:15:36.165131+00	\N
104	2	GENOMMA	\N	GENOMMA	\N	t	2025-07-06 18:15:36.725591+00	\N
105	2	SANOFI AVENTIS	\N	SANOFI_AVENTIS	\N	t	2025-07-06 18:15:36.725591+00	\N
106	2	MERCK	\N	MERCK	\N	t	2025-07-06 18:15:36.725591+00	\N
107	2	PHARMADIOL	\N	PHARMADIOL	\N	t	2025-07-06 18:15:36.725591+00	\N
108	2	JANSSEN	\N	JANSSEN	\N	t	2025-07-06 18:15:37.399769+00	\N
109	2	L. SERRAL	\N	L._SERRAL	\N	t	2025-07-06 18:15:37.399769+00	\N
110	2	GRISI	\N	GRISI	\N	t	2025-07-06 18:15:37.399769+00	\N
111	2	ALPHARMA	\N	ALPHARMA	\N	t	2025-07-06 18:15:37.399769+00	\N
112	2	NEOLPHARMA	\N	NEOLPHARMA	\N	t	2025-07-06 18:15:37.399769+00	\N
113	2	L HIGIA	\N	L_HIGIA	\N	t	2025-07-06 18:15:38.158083+00	\N
114	2	SALUD NATURAL	\N	SALUD_NATURAL	\N	t	2025-07-06 18:15:38.158083+00	\N
115	2	FARMA HISP	\N	FARMA_HISP	\N	t	2025-07-06 18:15:38.158083+00	\N
116	2	NYCOMED	\N	NYCOMED	\N	t	2025-07-06 18:15:38.740333+00	\N
117	2	TAKEDA	\N	TAKEDA	\N	t	2025-07-06 18:15:38.740333+00	\N
118	2	DR MONTFORT	\N	DR_MONTFORT	\N	t	2025-07-06 18:15:38.740333+00	\N
119	2	BRISTOL MYERS SQUIBB	\N	BRISTOL_MYERS_SQUIBB	\N	t	2025-07-06 18:15:38.740333+00	\N
120	2	MEDICA NATURAL	\N	MEDICA_NATURAL	\N	t	2025-07-06 18:15:39.390765+00	\N
121	2	ADAMS	\N	ADAMS	\N	t	2025-07-06 18:15:39.390765+00	\N
122	2	NOVARTIS	\N	NOVARTIS	\N	t	2025-07-06 18:15:40.754061+00	\N
123	2	ZOETIS	\N	ZOETIS	\N	t	2025-07-06 18:15:40.754061+00	\N
124	2	SOPHIA GENERICO	\N	SOPHIA_GENERICO	\N	t	2025-07-06 18:15:41.41129+00	\N
125	2	GSK	\N	GSK	\N	t	2025-07-06 18:15:41.41129+00	\N
126	2	BRISTOL-MYERS	\N	BRISTOL-MYERS	\N	t	2025-07-06 18:15:41.41129+00	\N
127	2	GELPHARMA	\N	GELPHARMA	\N	t	2025-07-06 18:15:42.250056+00	\N
128	2	LAB DB	\N	LAB_DB	\N	t	2025-07-06 18:15:42.250056+00	\N
129	2	GENOMMA LAB	\N	GENOMMA_LAB	\N	t	2025-07-06 18:15:42.250056+00	\N
130	2	JANSSEN-CILAG	\N	JANSSEN-CILAG	\N	t	2025-07-06 18:15:42.250056+00	\N
131	2	LOREN	\N	LOREN	\N	t	2025-07-06 18:15:42.979666+00	\N
132	2	PROCTER & GAMBLE	\N	PROCTER_&_GAMBLE	\N	t	2025-07-06 18:15:42.979666+00	\N
133	2	SANAX	\N	SANAX	\N	t	2025-07-06 18:15:42.979666+00	\N
134	2	LA FLOR	\N	LA_FLOR	\N	t	2025-07-06 18:15:42.979666+00	\N
135	2	QUIMPHARMA	\N	QUIMPHARMA	\N	t	2025-07-06 18:15:43.716223+00	\N
136	2	INV FARMACEUTICAS	\N	INV_FARMACEUTICAS	\N	t	2025-07-06 18:15:43.716223+00	\N
137	2	PNS	\N	PNS	\N	t	2025-07-06 18:15:43.716223+00	\N
138	2	L LOPEZ	\N	L_LOPEZ	\N	t	2025-07-06 18:15:43.716223+00	\N
139	2	SENOSIAIN	\N	SENOSIAIN	\N	t	2025-07-06 18:15:44.466511+00	\N
140	2	DIALICELS	\N	DIALICELS	\N	t	2025-07-06 18:15:44.466511+00	\N
141	2	BRISTOL-MYERS SQUIBB	\N	BRISTOL-MYERS_SQUIBB	\N	t	2025-07-06 18:15:44.466511+00	\N
142	2	FARMA HISPANO	\N	FARMA_HISPANO	\N	t	2025-07-06 18:15:45.227187+00	\N
143	2	URANIA	\N	URANIA	\N	t	2025-07-06 18:15:45.227187+00	\N
144	2	CMD	\N	CMD	\N	t	2025-07-06 18:15:45.227187+00	\N
145	2	PAILL	\N	PAILL	\N	t	2025-07-06 18:15:46.046284+00	\N
146	2	MYGRA	\N	MYGRA	\N	t	2025-07-06 18:15:46.046284+00	\N
147	2	LASALUD	\N	LASALUD	\N	t	2025-07-06 18:15:46.046284+00	\N
148	2	SOPHIA	\N	SOPHIA	\N	t	2025-07-06 18:15:46.944767+00	\N
149	2	HOMEOPATICOS MILENIUM	\N	HOMEOPATICOS_MILENIUM	\N	t	2025-07-06 18:15:46.944767+00	\N
150	2	TOGOCINO	\N	TOGOCINO	\N	t	2025-07-06 18:15:46.944767+00	\N
151	2	ATLANTIS	\N	ATLANTIS	\N	t	2025-07-06 18:15:46.944767+00	\N
152	2	MK	\N	MK	\N	t	2025-07-06 18:15:46.944767+00	\N
153	2	ARANTIZ	\N	ARANTIZ	\N	t	2025-07-06 18:15:46.944767+00	\N
154	2	SANOFI AVENTS	\N	SANOFI_AVENTS	\N	t	2025-07-06 18:15:46.944767+00	\N
155	2	JALOMA	\N	JALOMA	\N	t	2025-07-06 18:15:46.944767+00	\N
156	2	BAJAMED	\N	BAJAMED	\N	t	2025-07-06 18:15:46.944767+00	\N
157	2	ORDONEZ	\N	ORDONEZ	\N	t	2025-07-06 18:15:47.873718+00	\N
158	2	LAB LOPEZ	\N	LAB_LOPEZ	\N	t	2025-07-06 18:15:47.873718+00	\N
159	2	CHIAPAS	\N	CHIAPAS	\N	t	2025-07-06 18:15:47.873718+00	\N
160	2	VICK	\N	VICK	\N	t	2025-07-06 18:15:47.873718+00	\N
161	2	COYOACAN QUIMICAS	\N	COYOACAN_QUIMICAS	\N	t	2025-07-06 18:15:47.873718+00	\N
162	2	IPAL	\N	IPAL	\N	t	2025-07-06 18:15:47.873718+00	\N
163	2	OFFENBACH	\N	OFFENBACH	\N	t	2025-07-06 18:15:47.873718+00	\N
164	2	WERMAR	\N	WERMAR	\N	t	2025-07-06 18:15:48.729115+00	\N
165	2	ANCALMO	\N	ANCALMO	\N	t	2025-07-06 18:15:48.729115+00	\N
167	2	ASOFARMA	Brand imported from CSV on 2025-07-06	ASOFARMA	\N	t	2025-07-06 18:23:27.519771+00	\N
168	2	ASPEN	Brand imported from CSV on 2025-07-06	ASPEN	\N	t	2025-07-06 18:23:27.519771+00	\N
169	2	BOEHRINGER INGELHEM	Brand imported from CSV on 2025-07-06	BOEHRINGER_INGELHEM	\N	t	2025-07-06 18:23:27.519771+00	\N
170	2	BQM	Brand imported from CSV on 2025-07-06	BQM	\N	t	2025-07-06 18:23:27.519771+00	\N
171	2	BREMER	Brand imported from CSV on 2025-07-06	BREMER	\N	t	2025-07-06 18:23:27.519771+00	\N
172	2	BRULART	Brand imported from CSV on 2025-07-06	BRULART	\N	t	2025-07-06 18:23:27.519771+00	\N
173	2	BRULUAGSA	Brand imported from CSV on 2025-07-06	BRULUAGSA	\N	t	2025-07-06 18:23:27.519771+00	\N
174	2	CB LA PIEDAD	Brand imported from CSV on 2025-07-06	CB_LA_PIEDAD	\N	t	2025-07-06 18:23:27.519771+00	\N
175	2	DINA	Brand imported from CSV on 2025-07-06	DINA	\N	t	2025-07-06 18:23:27.519771+00	\N
176	2	EDERKA	Brand imported from CSV on 2025-07-06	EDERKA	\N	t	2025-07-06 18:23:27.519771+00	\N
177	2	ENER GREEN	Brand imported from CSV on 2025-07-06	ENER_GREEN	\N	t	2025-07-06 18:23:27.519771+00	\N
178	2	GELpharma	Brand imported from CSV on 2025-07-06	GELPHARMA	\N	t	2025-07-06 18:23:27.519771+00	\N
179	2	GENOMMALAB	Brand imported from CSV on 2025-07-06	GENOMMALAB	\N	t	2025-07-06 18:23:27.519771+00	\N
180	2	GISEL	Brand imported from CSV on 2025-07-06	GISEL	\N	t	2025-07-06 18:23:27.519771+00	\N
181	2	GLUNOVAG	Brand imported from CSV on 2025-07-06	GLUNOVAG	\N	t	2025-07-06 18:23:27.519771+00	\N
182	2	GRIN	Brand imported from CSV on 2025-07-06	GRIN	\N	t	2025-07-06 18:23:27.519771+00	\N
183	2	GRUNENTHAL	Brand imported from CSV on 2025-07-06	GRUNENTHAL	\N	t	2025-07-06 18:23:27.519771+00	\N
184	2	HALEON	Brand imported from CSV on 2025-07-06	HALEON	\N	t	2025-07-06 18:23:27.519771+00	\N
185	2	IFA CELTICS	Brand imported from CSV on 2025-07-06	IFA_CELTICS	\N	t	2025-07-06 18:23:27.519771+00	\N
186	2	IMPLEMEDIX	Brand imported from CSV on 2025-07-06	IMPLEMEDIX	\N	t	2025-07-06 18:23:27.519771+00	\N
187	2	JASSEN-CILAG	Brand imported from CSV on 2025-07-06	JASSEN_CILAG	\N	t	2025-07-06 18:23:27.519771+00	\N
188	2	KENDRICK	Brand imported from CSV on 2025-07-06	KENDRICK	\N	t	2025-07-06 18:23:27.519771+00	\N
189	2	KENER	Brand imported from CSV on 2025-07-06	KENER	\N	t	2025-07-06 18:23:27.519771+00	\N
190	2	LAKESIDE	Brand imported from CSV on 2025-07-06	LAKESIDE	\N	t	2025-07-06 18:23:27.519771+00	\N
191	2	LANDSTEINER	Brand imported from CSV on 2025-07-06	LANDSTEINER	\N	t	2025-07-06 18:23:27.519771+00	\N
192	2	MEGAMIX	Brand imported from CSV on 2025-07-06	MEGAMIX	\N	t	2025-07-06 18:23:27.519771+00	\N
193	2	NATURAL FLOWER	Brand imported from CSV on 2025-07-06	NATURAL_FLOWER	\N	t	2025-07-06 18:23:27.519771+00	\N
194	2	NORDIMEX	Brand imported from CSV on 2025-07-06	NORDIMEX	\N	t	2025-07-06 18:23:27.519771+00	\N
195	2	NUCITEC	Brand imported from CSV on 2025-07-06	NUCITEC	\N	t	2025-07-06 18:23:27.519771+00	\N
196	2	ORAL-B	Brand imported from CSV on 2025-07-06	ORAL_B	\N	t	2025-07-06 18:23:27.519771+00	\N
197	2	PHARMA RX	Brand imported from CSV on 2025-07-06	PHARMA_RX	\N	t	2025-07-06 18:23:27.519771+00	\N
198	2	PONDS	Brand imported from CSV on 2025-07-06	PONDS	\N	t	2025-07-06 18:23:27.519771+00	\N
199	2	PROBIOMED	Brand imported from CSV on 2025-07-06	PROBIOMED	\N	t	2025-07-06 18:23:27.519771+00	\N
200	2	PSICOPHARMA	Brand imported from CSV on 2025-07-06	PSICOPHARMA	\N	t	2025-07-06 18:23:27.519771+00	\N
201	2	ROCHE	Brand imported from CSV on 2025-07-06	ROCHE	\N	t	2025-07-06 18:23:27.519771+00	\N
202	2	SCHOEN	Brand imported from CSV on 2025-07-06	SCHOEN	\N	t	2025-07-06 18:23:27.519771+00	\N
203	2	STREGER	Brand imported from CSV on 2025-07-06	STREGER	\N	t	2025-07-06 18:23:27.519771+00	\N
204	2	SYNTEX	Brand imported from CSV on 2025-07-06	SYNTEX	\N	t	2025-07-06 18:23:27.519771+00	\N
205	2	VITAE	Brand imported from CSV on 2025-07-06	VITAE	\N	t	2025-07-06 18:23:27.519771+00	\N
206	2	WANDEL	Brand imported from CSV on 2025-07-06	WANDEL	\N	t	2025-07-06 18:23:27.519771+00	\N
207	2	WESER PHARMA	Brand imported from CSV on 2025-07-06	WESER_PHARMA	\N	t	2025-07-06 18:23:27.519771+00	\N
208	2	ZAMBON	Brand imported from CSV on 2025-07-06	ZAMBON	\N	t	2025-07-06 18:23:27.519771+00	\N
210	1	Marca de Prueba 113926	Marca creada por script de prueba	TEST_113926	\N	t	2025-07-06 18:39:28.817846+00	\N
166	2	ACCORD		ACCORD	\N	t	2025-07-06 18:23:27.519771+00	2025-07-06 23:16:18.191168+00
\.


--
-- Data for Name: business_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business_users (id, business_id, user_id, role, is_active, created_at) FROM stdin;
1	1	1	ADMIN	t	2025-07-06 18:09:31.84859+00
2	1	2	MANAGER	t	2025-07-06 18:09:31.84859+00
3	1	3	EMPLOYEE	t	2025-07-06 18:09:31.84859+00
4	4	4	EMPLOYEE	t	2025-07-07 05:17:51.960368+00
5	4	5	EMPLOYEE	t	2025-07-07 05:34:28.113084+00
6	4	6	EMPLOYEE	t	2025-07-07 05:34:28.113084+00
\.


--
-- Data for Name: businesses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.businesses (id, name, description, code, tax_id, rfc, address, phone, email, is_active, created_at, updated_at) FROM stdin;
1	Tienda Maestro	Tienda de abarrotes y productos diversos	TM001	RFC123456789	\N	Av. Principal 123, Ciudad, Estado	555-0123	info@maestroinventario.com	t	2025-07-06 18:09:31.837843+00	\N
2	Default Business	\N	DEFAULT_BUSINESS	\N	\N	\N	\N	\N	t	2025-07-06 18:11:16.23098+00	\N
4	Maestro Inventario	Negocio principal para pruebas	MI001	XAXX010101000	XAXX010101000	Dirección de prueba	0000000000	admin@maestro.com	t	2025-07-07 05:17:51.960368+00	\N
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, business_id, name, description, code, parent_id, is_active, created_at, updated_at) FROM stdin;
1	1	Abarrotes	Productos básicos de despensa	ABR	\N	t	2025-07-06 18:09:31.867493+00	\N
2	1	Bebidas	Bebidas alcohólicas y no alcohólicas	BEB	\N	t	2025-07-06 18:09:31.867493+00	\N
3	1	Lácteos	Productos lácteos y derivados	LAC	\N	t	2025-07-06 18:09:31.867493+00	\N
4	1	Carnes	Carnes rojas, blancas y embutidos	CAR	\N	t	2025-07-06 18:09:31.867493+00	\N
5	1	Frutas y Verduras	Productos frescos	FYV	\N	t	2025-07-06 18:09:31.867493+00	\N
6	1	Limpieza	Productos de limpieza e higiene	LIM	\N	t	2025-07-06 18:09:31.867493+00	\N
7	2	ASMA / BRONCOESPASMO	\N	ASMA_/_BRONCOESPASMO	\N	t	2025-07-06 18:15:31.579651+00	\N
8	2	ANALGESICO OPIODE	\N	ANALGESICO_OPIODE	\N	t	2025-07-06 18:15:31.579651+00	\N
9	2	ANTIGRIPALES	\N	ANTIGRIPALES	\N	t	2025-07-06 18:15:31.579651+00	\N
10	2	SUPLEMENTOS	\N	SUPLEMENTOS	\N	t	2025-07-06 18:15:31.579651+00	\N
11	2	PERDIDA PESO	\N	PERDIDA_PESO	\N	t	2025-07-06 18:15:31.579651+00	\N
12	2	VITAMINA	\N	VITAMINA	\N	t	2025-07-06 18:15:31.579651+00	\N
13	2	ANTI ACIDO	\N	ANTI_ACIDO	\N	t	2025-07-06 18:15:31.579651+00	\N
14	2	ANTI HIPERTENSIVO	\N	ANTI_HIPERTENSIVO	\N	t	2025-07-06 18:15:31.579651+00	\N
15	2	CORTICOESTEROIDE	\N	CORTICOESTEROIDE	\N	t	2025-07-06 18:15:31.579651+00	\N
16	2	DESCONGESTIVO NASAL	\N	DESCONGESTIVO_NASAL	\N	t	2025-07-06 18:15:31.579651+00	\N
17	2	ANTIINFLAMATORIO	\N	ANTIINFLAMATORIO	\N	t	2025-07-06 18:15:31.579651+00	\N
18	2	GOTA	\N	GOTA	\N	t	2025-07-06 18:15:31.579651+00	\N
19	2	ANTITUSIGENO	\N	ANTITUSIGENO	\N	t	2025-07-06 18:15:31.579651+00	\N
20	2	ANTIBIOTICO	\N	ANTIBIOTICO	\N	t	2025-07-06 18:15:31.579651+00	\N
21	2	ANTIBIOTICO/ANTIGRIPAL	\N	ANTIBIOTICO/ANTIGRIPAL	\N	t	2025-07-06 18:15:32.131756+00	\N
22	2	HIPERPLASIA PROSTATICA	\N	HIPERPLASIA_PROSTATICA	\N	t	2025-07-06 18:15:32.131756+00	\N
23	2	ANALGESICO	\N	ANALGESICO	\N	t	2025-07-06 18:15:32.131756+00	\N
24	2	DIABETES MELLITUS	\N	DIABETES_MELLITUS	\N	t	2025-07-06 18:15:32.131756+00	\N
25	2	QUEMADURA	\N	QUEMADURA	\N	t	2025-07-06 18:15:32.131756+00	\N
26	2	COLESTEROL	\N	COLESTEROL	\N	t	2025-07-06 18:15:32.131756+00	\N
27	2	ANTIHISTAMINICO	\N	ANTIHISTAMINICO	\N	t	2025-07-06 18:15:32.131756+00	\N
28	2	INFECCION ORINA	\N	INFECCION_ORINA	\N	t	2025-07-06 18:15:32.131756+00	\N
29	2	ANTIBIOTICO TOPICO	\N	ANTIBIOTICO_TOPICO	\N	t	2025-07-06 18:15:32.131756+00	\N
30	2	SUPLEMENTO	\N	SUPLEMENTO	\N	t	2025-07-06 18:15:32.131756+00	\N
31	2	HIDRATAR PIEL	\N	HIDRATAR_PIEL	\N	t	2025-07-06 18:15:32.596194+00	\N
32	2	HORMONA	\N	HORMONA	\N	t	2025-07-06 18:15:32.596194+00	\N
33	2	ANTIGRIPAL	\N	ANTIGRIPAL	\N	t	2025-07-06 18:15:32.596194+00	\N
34	2	NAUSEAS/VOMITO	\N	NAUSEAS/VOMITO	\N	t	2025-07-06 18:15:32.596194+00	\N
35	2	HERPES BUCAL	\N	HERPES_BUCAL	\N	t	2025-07-06 18:15:32.596194+00	\N
36	2	ANALGESICO TOPICO	\N	ANALGESICO_TOPICO	\N	t	2025-07-06 18:15:32.596194+00	\N
37	2	ANTIMICOTICO	\N	ANTIMICOTICO	\N	t	2025-07-06 18:15:32.596194+00	\N
38	2	ANTIHIPERTENSIVO	\N	ANTIHIPERTENSIVO	\N	t	2025-07-06 18:15:32.596194+00	\N
39	2	EPILEPSIA	\N	EPILEPSIA	\N	t	2025-07-06 18:15:32.596194+00	\N
40	2	DISFUNSION ERECTIL	\N	DISFUNSION_ERECTIL	\N	t	2025-07-06 18:15:32.596194+00	\N
41	2	FUEGO LABIAL	\N	FUEGO_LABIAL	\N	t	2025-07-06 18:15:33.119584+00	\N
42	2	ANALGESICO OPIOIDE	\N	ANALGESICO_OPIOIDE	\N	t	2025-07-06 18:15:33.119584+00	\N
43	2	BENZODIACEPINA	\N	BENZODIACEPINA	\N	t	2025-07-06 18:15:33.119584+00	\N
44	2	ANTIVIRAL	\N	ANTIVIRAL	\N	t	2025-07-06 18:15:33.119584+00	\N
45	2	HIPERTENSION ARTERIAL	\N	HIPERTENSION_ARTERIAL	\N	t	2025-07-06 18:15:33.119584+00	\N
46	2	HIPERTENSION	\N	HIPERTENSION	\N	t	2025-07-06 18:15:33.119584+00	\N
47	2	Antibiotico	\N	ANTIBIOTICO	\N	t	2025-07-06 18:15:33.119584+00	\N
48	2	DESINFLAMATORIO	\N	DESINFLAMATORIO	\N	t	2025-07-06 18:15:33.734133+00	\N
49	2	DESCONGESTIVO	\N	DESCONGESTIVO	\N	t	2025-07-06 18:15:33.734133+00	\N
50	2	DOLOR	\N	DOLOR	\N	t	2025-07-06 18:15:33.734133+00	\N
51	2	GRIPA	\N	GRIPA	\N	t	2025-07-06 18:15:33.734133+00	\N
52	2	ESTRENIMIENTO	\N	ESTRENIMIENTO	\N	t	2025-07-06 18:15:33.734133+00	\N
53	2	MALESTAR ESTOMACAL	\N	MALESTAR_ESTOMACAL	\N	t	2025-07-06 18:15:33.734133+00	\N
54	2	ANSIOLITICO / DORMIR	\N	ANSIOLITICO_/_DORMIR	\N	t	2025-07-06 18:15:33.734133+00	\N
55	2	ASMA	\N	ASMA	\N	t	2025-07-06 18:15:33.734133+00	\N
56	2	DISFUNCION ERECTIL	\N	DISFUNCION_ERECTIL	\N	t	2025-07-06 18:15:33.734133+00	\N
57	2	DIABETES	\N	DIABETES	\N	t	2025-07-06 18:15:34.431597+00	\N
58	2	ANTIBIOTC0	\N	ANTIBIOTC0	\N	t	2025-07-06 18:15:34.431597+00	\N
59	2	BAJAR PESO	\N	BAJAR_PESO	\N	t	2025-07-06 18:15:34.431597+00	\N
60	2	LAXANTE	\N	LAXANTE	\N	t	2025-07-06 18:15:34.431597+00	\N
61	2	QUEMADURAS Y COMEZON	\N	QUEMADURAS_Y_COMEZON	\N	t	2025-07-06 18:15:34.431597+00	\N
62	2	DOLOR GARGANTA	\N	DOLOR_GARGANTA	\N	t	2025-07-06 18:15:34.431597+00	\N
63	2	ANALGESICO.	\N	ANALGESICO.	\N	t	2025-07-06 18:15:34.431597+00	\N
64	2	ASEO PERSONAL	\N	ASEO_PERSONAL	\N	t	2025-07-06 18:15:34.993098+00	\N
65	2	INSUMOS	\N	INSUMOS	\N	t	2025-07-06 18:15:34.993098+00	\N
66	2	ACEITES	\N	ACEITES	\N	t	2025-07-06 18:15:34.993098+00	\N
67	2	ALERGIA CUTANEA	\N	ALERGIA_CUTANEA	\N	t	2025-07-06 18:15:34.993098+00	\N
68	2	DULCE	\N	DULCE	\N	t	2025-07-06 18:15:35.590019+00	\N
69	2	CHUPON	\N	CHUPON	\N	t	2025-07-06 18:15:35.590019+00	\N
70	2	CREMA ACLARADORA	\N	CREMA_ACLARADORA	\N	t	2025-07-06 18:15:36.165131+00	\N
71	2	QUEMADURAS	\N	QUEMADURAS	\N	t	2025-07-06 18:15:36.165131+00	\N
72	2	ANTICONCEPTIVO	\N	ANTICONCEPTIVO	\N	t	2025-07-06 18:15:36.725591+00	\N
73	2	ESTEROIDE TOPICO	\N	ESTEROIDE_TOPICO	\N	t	2025-07-06 18:15:36.725591+00	\N
74	2	ANTIVERRUGAS	\N	ANTIVERRUGAS	\N	t	2025-07-06 18:15:36.725591+00	\N
75	2	ANTIFUNGICO	\N	ANTIFUNGICO	\N	t	2025-07-06 18:15:36.725591+00	\N
76	2	HEMORROIDE	\N	HEMORROIDE	\N	t	2025-07-06 18:15:36.725591+00	\N
77	2	DOLOR MUSCULAR	\N	DOLOR_MUSCULAR	\N	t	2025-07-06 18:15:36.725591+00	\N
78	2	NAUSEAS/VOMITO/MAREO	\N	NAUSEAS/VOMITO/MAREO	\N	t	2025-07-06 18:15:37.399769+00	\N
79	2	ANTIESPAMODICO	\N	ANTIESPAMODICO	\N	t	2025-07-06 18:15:37.399769+00	\N
80	2	HIPOTIROIDISMO	\N	HIPOTIROIDISMO	\N	t	2025-07-06 18:15:38.158083+00	\N
81	2	VERRUGAS/CALLOS	\N	VERRUGAS/CALLOS	\N	t	2025-07-06 18:15:38.158083+00	\N
82	2	ANTIACIDO	\N	ANTIACIDO	\N	t	2025-07-06 18:15:38.740333+00	\N
83	2	HIGIENE PERSONAL	\N	HIGIENE_PERSONAL	\N	t	2025-07-06 18:15:39.390765+00	\N
84	2	ANTISEPTICO ORAL	\N	ANTISEPTICO_ORAL	\N	t	2025-07-06 18:15:39.390765+00	\N
85	2	INSUMOS MEDICOS	\N	INSUMOS_MEDICOS	\N	t	2025-07-06 18:15:40.071399+00	\N
86	2	ANTIDIARREICO	\N	ANTIDIARREICO	\N	t	2025-07-06 18:15:40.071399+00	\N
87	2	ANTIINFLAMATORIO TOPICO	\N	ANTIINFLAMATORIO_TOPICO	\N	t	2025-07-06 18:15:40.754061+00	\N
88	2	OFTALMICO	\N	OFTALMICO	\N	t	2025-07-06 18:15:41.41129+00	\N
89	2	ANTIFUGICO	\N	ANTIFUGICO	\N	t	2025-07-06 18:15:41.41129+00	\N
90	2	ANTICOCEPTIVO	\N	ANTICOCEPTIVO	\N	t	2025-07-06 18:15:41.41129+00	\N
91	2	ANESTESICO TOPICO	\N	ANESTESICO_TOPICO	\N	t	2025-07-06 18:15:42.250056+00	\N
92	2	ANTIDEPRESIVO	\N	ANTIDEPRESIVO	\N	t	2025-07-06 18:15:42.979666+00	\N
93	2	BARRERA PARA PIEL	\N	BARRERA_PARA_PIEL	\N	t	2025-07-06 18:15:42.979666+00	\N
94	2	INDIGESTION	\N	INDIGESTION	\N	t	2025-07-06 18:15:42.979666+00	\N
95	2	VERRUGAS	\N	VERRUGAS	\N	t	2025-07-06 18:15:43.716223+00	\N
96	2	DISLIPIDEMIA	\N	DISLIPIDEMIA	\N	t	2025-07-06 18:15:43.716223+00	\N
97	2	DEFICIENCIA DE TESTOSTERONA	\N	DEFICIENCIA_DE_TESTOSTERONA	\N	t	2025-07-06 18:15:43.716223+00	\N
98	2	COLITIS	\N	COLITIS	\N	t	2025-07-06 18:15:44.466511+00	\N
99	2	SARNA	\N	SARNA	\N	t	2025-07-06 18:15:44.466511+00	\N
100	2	OJO ROJO	\N	OJO_ROJO	\N	t	2025-07-06 18:15:45.227187+00	\N
101	2	HERPES LABIAL	\N	HERPES_LABIAL	\N	t	2025-07-06 18:15:45.227187+00	\N
102	2	DEFICIENCIA DE TESTOTERONA	\N	DEFICIENCIA_DE_TESTOTERONA	\N	t	2025-07-06 18:15:46.944767+00	\N
103	2	HERIDAS	\N	HERIDAS	\N	t	2025-07-06 18:15:46.944767+00	\N
104	2	FUNGICIDA	\N	FUNGICIDA	\N	t	2025-07-06 18:15:46.944767+00	\N
105	2	ANTBIOTICO	Category imported from CSV on 2025-07-06	ANTBIOTICO	\N	t	2025-07-06 18:23:27.519771+00	\N
106	2	ANTINFLAMATORIO	Category imported from CSV on 2025-07-06	ANTINFLAMATORIO	\N	t	2025-07-06 18:23:27.519771+00	\N
107	2	DOLOR CABEZA	Category imported from CSV on 2025-07-06	DOLOR_CABEZA	\N	t	2025-07-06 18:23:27.519771+00	\N
109	1	Categoría de Prueba 113924	Categoría creada por script de prueba	TEST_113924	\N	t	2025-07-06 18:39:26.744288+00	\N
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory (id, warehouse_id, product_variant_id, unit_id, quantity, minimum_stock, maximum_stock, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_adjustment_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_adjustment_items (id, adjustment_id, product_variant_id, unit_id, expected_quantity, actual_quantity, difference, unit_cost, total_cost_impact) FROM stdin;
\.


--
-- Data for Name: inventory_adjustments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_adjustments (id, warehouse_id, adjustment_number, adjustment_type, reason, notes, user_id, status, approved_by, approved_at, applied_at, created_at) FROM stdin;
\.


--
-- Data for Name: inventory_movements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_movements (id, warehouse_id, product_variant_id, unit_id, user_id, movement_type, quantity, cost_per_unit, previous_quantity, new_quantity, batch_number, expiry_date, reference_number, reason, notes, destination_warehouse_id, purchase_order_id, purchase_order_receipt_id, created_at) FROM stdin;
1	1	1	7	3	ENTRY	100	12	0	100	\N	\N	INIT-001	Stock inicial	Inventario inicial del sistema	\N	\N	\N	2025-07-06 18:09:32.099261+00
2	1	2	7	3	ENTRY	75	25	0	75	\N	\N	INIT-002	Stock inicial	Inventario inicial del sistema	\N	\N	\N	2025-07-06 18:09:32.099261+00
3	1	1	7	3	EXIT	15	12	100	85	\N	\N	SALE-001	Venta	Venta a cliente	\N	\N	\N	2025-07-06 18:09:32.099261+00
4	1	1	7	4	ENTRY	1	\N	\N	\N	\N	\N		\N		\N	\N	\N	2025-07-08 17:06:27.300297+00
\.


--
-- Data for Name: login_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_attempts (id, user_email, ip_address, success, created_at) FROM stdin;
1	admin@maestro.com	::1	t	2025-07-08 08:13:42.39904
2	admin@maestro.com	::1	t	2025-07-08 14:34:37.879013
3	admin@maestro.com	::1	t	2025-07-08 14:36:52.068328
4	admin@maestro.com	::1	t	2025-07-08 14:50:05.119384
5	admin@maestro.com	::1	t	2025-07-08 16:01:40.706623
6	admin@maestro.com	::1	t	2025-07-08 16:53:25.057231
\.


--
-- Data for Name: offices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.offices (id, name, gps_lat, gps_lng, radius_meters, checkin_start, checkout_end) FROM stdin;
\.


--
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variants (id, product_id, name, sku, barcode, attributes, cost_price, selling_price, is_active, created_at, updated_at) FROM stdin;
1	1	Coca-Cola 600ml	CC-600	\N	\N	12	18	t	2025-07-06 18:09:31.973069+00	\N
2	1	Coca-Cola 2L	CC-2L	\N	\N	25	35	t	2025-07-06 18:09:31.973069+00	\N
3	2	Leche Lala Entera 1L	LL-1L	\N	\N	18	25	t	2025-07-06 18:09:31.973069+00	\N
4	2	Leche Lala Deslactosada 1L	LL-DL-1L	\N	\N	22	30	t	2025-07-06 18:09:31.973069+00	\N
5	3	Pan Blanco Grande	PB-BG	\N	\N	28	38	t	2025-07-06 18:09:31.973069+00	\N
6	3	Pan Integral	PB-INT	\N	\N	32	42	t	2025-07-06 18:09:31.973069+00	\N
7	4	Harina Maseca 1kg	HM-1K	\N	\N	18	25	t	2025-07-06 18:09:31.973069+00	\N
8	4	Harina Maseca 4kg	HM-4K	\N	\N	65	85	t	2025-07-06 18:09:31.973069+00	\N
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, business_id, category_id, brand_id, name, description, sku, barcode, base_unit_id, minimum_stock, maximum_stock, is_active, created_at, updated_at) FROM stdin;
1	1	2	1	Coca-Cola	Producto Coca-Cola	PROD-001	\N	7	5	100	t	2025-07-06 18:09:31.973069+00	\N
2	1	3	4	Leche Lala	Producto Leche Lala	PROD-002	\N	7	5	100	t	2025-07-06 18:09:31.973069+00	\N
3	1	1	2	Pan Bimbo	Producto Pan Bimbo	PROD-003	\N	7	5	100	t	2025-07-06 18:09:31.973069+00	\N
4	1	1	5	Harina Maseca	Producto Harina Maseca	PROD-004	\N	7	5	100	t	2025-07-06 18:09:31.973069+00	\N
5	2	7	7	AEROFLUX SALBUTAMOL 120ML SALBUTAMOL , AMBROXOL (SANFER) (1)	\N	1	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
6	2	8	8	ADIOLOL 100MG C/50 + 50 DUO CAPS TRAMADOL (SBL) (2)	\N	2	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
7	2	9	9	AFRINEX ACTIVE C/20 TABS  CLORFENAMINA/FENILEFRINA/PARACETAMOL (SCHERING-PLOUGH)	\N	3	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
8	2	10	\N	AJO KING C/100 TABS (PLANTAS MEDICINALES DE MEXICO) (4)	\N	4	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
9	2	11	10	ACXION 30MG C/30 TABS FENTERMINA (IFA) (5)	\N	5	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
10	2	12	11	ADEROGYL 15 C/1 AMP (SANOFI) (6)	\N	6	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
11	2	13	12	ALBOZ  OMEPRAZOL DUOS C/60 + 60 CAPS  (COLLINS) (7)	\N	7	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
12	2	14	13	LOSARTAN 50MG C/30 TABS (AMSA) (8)	\N	8	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
13	2	9	14	ALERFIN EXHIBIDOR C/200 TABS (LABORATORIOS LOPEZ) (9) X	\N	9	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
14	2	15	15	ALIN SOL INY 8MG/2ML DEXAMETASONA (CHINOIN) (10)	\N	10	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
15	2	16	15	ALIN NASAL 20ML GOTAS DEXAMETASONA, NEOMICINA , FENILEFRINA (CHINOIN) (11)	\N	11	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
16	2	17	15	ALIN OFTALMICO 5ML DEXAMETASONA, NEOMICINA (CHINOIN) (12)	\N	12	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
17	2	16	15	ALIN 0.75MG C/30 TABS DEXAMETASONA (CHINOIN) (13)	\N	13	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
18	2	17	16	ALIVIAX 550MG C/10 TABS NAPROXENO SODICO (GENOMMA LAB) (14)	\N	14	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
19	2	\N	17	BICARBONATO DE SODIO PURO 100GR (Ayesha)  (15)	\N	15	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
20	2	13	18	ALKA-SELTZER C/12 TABS (BAYER) (16)	\N	16	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
21	2	18	19	ALOPURINOL 300MG C/20 TABS (APOTEX)	\N	17	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
22	2	19	20	AMBROXOL 120 ML (LOEFFLER) (18)	\N	18	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
23	2	19	21	AMBROXOL 30ML PEDIATRICO (PHARMAGEN) (19)	\N	19	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
24	2	20	13	AMCEF 1G I.M CEFTRIAXONA (AMSA) (20)	\N	20	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
25	2	20	22	AMOXIBRON 250MG SUSP AMOXICILINA, BROMHEXINA (GLAXO SMITH KLINE) (21)	\N	21	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
26	2	20	23	AMOXICILINA 250MG SUSP  (HORMONA) (22)	\N	22	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
27	2	20	24	AMOXICILINA 500MG C/100 CAPS BIOTICILINA  (HEALTH TEC) (23)	\N	23	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
28	2	20	23	AMPICILINA 250MG SUSP (HORMONA)(24)	\N	24	\N	\N	0	\N	t	2025-07-06 18:15:31.579651+00	\N
29	2	21	12	AMPIGRIN ADULTO C/3 INY AMPICILINA, METAMIZOL, GUAIFENESINA, LIDOCAINA (COLLINS) (25)	\N	25	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
30	2	21	12	AMPIGRIN INFANTIL  60ML AMANTADINA, CLORFENAMINA,PARACETAMOL (COLLINS) (26)	\N	26	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
31	2	21	12	AMPIGRIN PFC C/24 TABS AMANTADINA,CLORFENAMINA,PARACETAMOL (COLLINS) (27)	\N	27	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
32	2	21	12	AMPIGRIN PFC PEDIATRICO 30ML AMANTADINA,CLORFENAMINA,PARACETAMOL (COLLINS) (28)	\N	28	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
33	2	22	25	AMZUVAG 0.4MG C/20 TABS TAMSULOSINA (NOVAG) (29)	\N	29	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
34	2	23	26	ANA-DENT C/100 TABS (LABORATORIOS TERAMED) (30)	\N	30	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
35	2	24	12	Anglucid 850mg c/30 Caps Metformina (Collins)	\N	31	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
36	2	23	27	ARDOSONS C/20 CAPS INDOMETACINA, BETAMETASONA, METOCARBAMOL (SON'S) (32)	\N	32	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
37	2	25	28	ARGEMOL 1% CREMA 28G SULFADIAZINA DE PLATA (LOEFFLER) (33)	\N	33	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
38	2	17	29	ARIFLAM 100MG C/20 TABS DICLOFENACO (ULTRA) (34)	\N	34	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
39	2	17	30	ARTRIBION C/80 CAPSULAS DICLOFENACO, TIAMINA, PIRIDOXINA, CIANOCOBALAMINA (BIOKEMICAL) (35)	\N	35	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
40	2	23	18	ASPIRINA 500MG C/100 TABS  (BAYER) (36)	\N	36	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
41	2	26	\N	ALINA  20MG C/100 TABS ATORVASTATINA (	\N	37	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
42	2	20	18	AMOBAY 500MG C/15 CAPS  AMOXICILINA ACIDO CLAVULANICO (BAYER)	\N	38	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
43	2	17	31	FLEXIVER 15MG C/10 TABS MELOXICAM (MAVER) (39)	\N	39	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
44	2	27	32	AVAPENA 25MG C/20 TABS CLOROPIRAMINA (SANDOZ) (40)	\N	40	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
45	2	20	33	AZIBIOT 500MG  C/3 TABS AZITROMICINA  (MAVI) (41)	\N	41	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
46	2	28	34	AZOGEN C/20 TABS ACIDO NALIDIXICO, FENAZOPIRIDINA (DEGORT'S CHEMICAL) (42)	\N	42	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
47	2	20	31	BACTIVER 100ML SULFAMETOXAZOL/ TRIMETROPRIMA ( MAVER) (43)	\N	43	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
48	2	20	27	BARMICIL 40G BETAMETASONA, GENTAMICINA, CLOTRIMAZOL (SON'S) (44)	\N	44	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
49	2	29	18	BAYCUTEN 30G CLOTRIMAZOL, DEXAMETASONA (BAYER) (45)	\N	45	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
50	2	30	35	BACAOMAX 340ML ACEITE HIGADO DE BACALAO (PROSA) (46)	\N	46	\N	\N	0	\N	t	2025-07-06 18:15:32.131756+00	\N
51	2	12	36	BEDOYECTA CAPSULAS C/30 VITAMINAS Y MINERALES (GROSSMAN) (47)	\N	47	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
52	2	20	13	BENCILPENICILINA 1,200,000 U (AMSA) (48)	\N	48	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
53	2	31	18	BEPANTHEN 100G DEXPANTENOL (BAYER) (49)	\N	49	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
54	2	32	18	BINODIAN DEPOT INY 200MG PRASTERONA, ESTRADIOL (BAYER) (50)	\N	50	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
55	2	33	37	BIO-ELECTRO MIGRANA C/24 TABS PARACETAMOL, ACIDO ACETILSALICILICO, CAFEINA (GENOMMA)(51)	\N	51	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
56	2	19	38	BISOLVON ADULTO 120ML BROMHEXINA (BOEHRINGER INGELHEIM) (52)	\N	52	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
57	2	19	38	BISOLVON INFANTIL 120ML BROMHEXINA (BOEHRINGER INGELHEIM)  (53)	\N	53	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
58	2	34	39	BONADOXINA 120ML MECLIZINA, PIRIDOXINA (PFIZER) (54)	\N	54	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
59	2	34	39	BONADOXINA C/5 AMP MECLIZINA, PIRIDOXINA (PFIZER) (55)	\N	55	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
60	2	34	39	BONADOXINA C/25 TABS MECLIZINA, PIRIDOXINA (PFIZER) (56)	\N	56	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
61	2	34	39	BONADOXINA 20ML MECLIZINA, PIRIDOXINA (PFIZER) (57)	\N	57	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
62	2	30	\N	BonaProst 760mg c/60 Caps (Nature's ´P.e.t. ) (58)	\N	58	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
63	2	19	40	BROGAL T ADULTO 120ML DEXTROMETORFANO/ AMBROXOL (RAYERE) (59)	\N	59	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
64	2	19	40	BROGAL T INFANTIL 120ML DEXTROMETORFANO/ AMBROXOL (RAYERE) (60)	\N	60	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
65	2	35	31	BENZOCAINA  BUCAL 9.7ML (MAVER) (61)	\N	61	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
66	2	36	31	LUMBOXEN GEL ROJO 35G NAPROXENO, LIDOCAINA (MAVER) (62)	\N	62	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
67	2	23	38	BUSCAPINA COMP C/36 TABS BUTILlHIOSCINA o HIOSCINA , METAMIZOL SODICO (BOEHRINGER)  (63)	\N	63	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
68	2	23	38	BUSCAPINA 10MG C/24 TABS BUTILIHIOSCINA O HIOSCINA, PARACETAMOL (BOEHRINGER INGELHEIM) (64)	\N	64	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
69	2	23	39	LYRICA 75MG C/14 CAPS PREGABALINA (PFIZER) (65)	\N	65	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
70	2	12	11	CALCIGENOL DOBLE SUSP 340ML (SANOFI)  (66)	\N	66	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
71	2	37	41	CANDIFLUX 150MG C/1 CAP FLUCONAZOL (LIOMONT) (67)	\N	67	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
72	2	37	18	CANESTEN 30G CREMA  CLOTRIMAZOL(BAYER) (68)	\N	68	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
73	2	38	42	BRUCAP 25MG C/30 TABS CAPTOPRIL (BRULUART)	\N	69	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
74	2	39	43	BIONEURIL c/20 TABS. 200 MG. (BIORESEARCH) (70)	\N	70	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
75	2	20	13	CEFALEXINA (Amsa) SUSP. Fco. 100 ML. 250 MG/5 ML.	\N	71	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
76	2	20	13	CEFALEXINA (Amsa) c/20 CAPS. 500 MG.	\N	72	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
77	2	20	44	CEFTREX 1GR IM	\N	73	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
78	2	33	9	CELESTAMINE NS 60ML LORATADINA/ BETAMETASONA (SCHERING-PLOUGH)	\N	74	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
79	2	33	9	CELESTAMINE NS C/10 TABS 5.0MG/0.25MG LORATADINA/BETAMETASONA (SCHERING-PLOUGH)	\N	75	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
80	2	33	9	CELESTAMINE NS C/20 TABS 5.0MG/0.25MG LORATADINA/ BETAMETASONA (SCHERING-PLOUGH)	\N	76	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
81	2	40	45	CIALIS 20MG C/1 (LILLY)	\N	77	\N	\N	0	\N	t	2025-07-06 18:15:32.596194+00	\N
82	2	41	41	CICLOFERON 2G CREMA ACICLOVIR (LIOMONT)	\N	78	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
83	2	20	12	CIGMADIL 300MG C/16 CAPS CLINDAMICINA (COLLINS)	\N	79	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
84	2	\N	46	CINERARIA MARITIMA 10ML (MEDICOR)	\N	80	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
85	2	20	47	CIPROFLOX 500MG C/12 CAPS CIPROFLOXACINO (ALTIA)	\N	81	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
86	2	20	48	CIPROFLOXACINO 500MG C/100 CAPS (SAIMED) G	\N	82	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
87	2	20	13	CIPROFLOXACINO 500MG C/14 TABS  (AMSA)	\N	83	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
88	2	42	49	CITRA 100MG C/120 TABS TRAMADOL (VICTORY)	\N	84	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
89	2	42	49	CITRA 100MG C/60 TABS TRAMADOL (VICTORY)	\N	85	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
90	2	17	49	CLONAFEC C/120 TABS DICLOFENACO (VICTORY)	\N	86	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
91	2	43	50	CLONAZEPAM 10ML GOTAS (PSICOFARMA)	\N	87	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
92	2	43	50	CLONAZEPAM 2MG C/100 TABS (PSICOFARMA)	\N	88	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
93	2	43	50	CLONAZEPAM 2MG C/30 TABS (PSICOFARMA)	\N	89	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
94	2	43	50	CLONAZEPAM 2MG C/60 TABS (PSICOFARMA)	\N	90	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
95	2	\N	7	A.S. COR 24ml GOTAS (SANFER)	\N	91	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
96	2	\N	42	ABRUNT 5MG C/10 TABS DESLORATADINA (BRULUART)	\N	92	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
97	2	\N	32	ACC 600MG C/20 TABS EFERVECENTES ACETILCISTEINA (SANDOZ)	\N	93	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
98	2	\N	40	Acetafen 500mg c/12 Tabs Paracetamol (Rayere)	\N	94	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
99	2	\N	40	Acetafen 750mg c/12 Tabs Paracetamol (Rayere)	\N	95	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
100	2	\N	\N	BUSCAPINA DUO C/10 HIOSCINA /PARACETAMOL (BOEHRINGER INGELHEIM)	\N	96	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
101	2	23	51	BRAX 200/275MG C/10 TABS NAPROXENO SODICO/PARACETAMOL (BIOMEP)	\N	97	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
102	2	17	44	FEBRAX SUSP 100ML NAPROXENO SODICO , PARACETAMOL (SIEGFRIED RHEIN)	\N	98	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
103	2	44	13	ACICLOVIR 400MG C/35 TABS (AMSA)	\N	99	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
104	2	44	41	CICLOFERON CREMA 10G ACICLOVIR (LIOMONT)	\N	100	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
105	2	44	41	CICLOFERON 200MG C/25 TABS ACICLOVIR (LIOMONT)	\N	101	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
106	2	44	49	CLORIXAN 800MG C/50 TABS ACICLOVIR (VICTORY)	\N	102	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
107	2	44	41	CICLOFERON 200MG/5ML ACICLOVIR SUSPENSION (LIOMONT)	\N	103	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
108	2	44	52	VALACICLOVIR 500MG C/10 TABS ACICLOVIR (SERRAL)	\N	104	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
109	2	44	53	ACOMEXOL 30G CREMA  (ARMSTRONG)	\N	105	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
110	2	45	49	ACORTIZ  25MG C/100 TABS HIDROCLOROTIAZIDA (VICTORY)	\N	106	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
111	2	45	31	CO-TARSAN C/30 COMPS. 50/12.5 MG. LOSARTAN/HIDROCLOROTIAZIDA (MAVER)	\N	107	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
112	2	45	54	LOSARTAN/HIDROCLOROTIAZIDA 50MG/25MG C/15 TABS (AVIVIA)	\N	108	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
113	2	45	13	LOSARTÁN/HIDROCLOROTIAZIDA C/15 TABS (AMSA)	\N	109	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
114	2	\N	55	BLEDROMIN c/28 TABS. 80/12.5 MG. (EVOLUTION)	\N	110	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
115	2	46	18	Adalat 10mg c/30 Tabs Nifedipino (Bayer)	\N	111	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
116	2	46	29	ANHITEN-A 30MG C/30 COMP L.P NIFEDIPINO (ULTRA)	\N	112	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
117	2	46	\N	NIFEDIPINO 30MG C/100 COMP	\N	113	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
118	2	47	56	ACROMICINA 250MG C/20 TABS  (WYETH)	\N	114	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
119	2	23	57	ADOPREN 800MG C/60 TABS IBUPROFENO (GENETICA)	\N	115	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
120	2	\N	39	ADVIL INFANTIL 2-12 ANOS 120ML	\N	116	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
121	2	\N	39	ADVIL MAX C/10 CAPSULAS	\N	117	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
469	2	\N	\N	Cura Hongos Aerosol 64g (Sante)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
122	2	23	57	ADOPREN Caja c/10 TABS. 800 MG. (GENETICA)	\N	118	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
123	2	23	31	DOLVER 800MG C/20 TABS IBUPROFENO (MAVER)	\N	119	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
124	2	23	49	Viczen 800mg c/100 Tabs Ibuprofeno (Victory)	\N	120	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
125	2	\N	58	ADMIDOXIL C/10 CAPS AMBROXOL, DEXTROMETORFANO (GEL PHARMA)	\N	121	\N	\N	0	\N	t	2025-07-06 18:15:33.119584+00	\N
126	2	33	11	HISTIACIL NF C/20 CÁPS DEXTROMETORFANO/ AMBROXOL (SANOFI)	\N	122	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
127	2	48	59	ADRECORT 1MG c/20 TABS DEXAMETASONA (AVITUS)	\N	123	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
128	2	48	59	ADRECORT Cja/Fco. c/30 TABS. 0.5 MG. (AVITUS)	\N	124	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
129	2	48	15	ALIN DEPOT SOL INY C/1 8MG DEXAMETASONA (CHINOIN)	\N	125	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
130	2	48	13	COMBEDI 4MG DX C/3 AMP COMPLEJO B, DEXAMETASONA, LIDOCAINA (AMSA)	\N	126	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
131	2	48	27	DEXIMET C/30 CAPS  (SONS)	\N	127	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
132	2	48	60	TOBRADEX 5ML GOTAS DEXAMETASONA, TOBRAMICINA (ALCON)	\N	128	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
133	2	48	12	VENGESIC C/20 TABS FENILBUTAZONA, DEXAMETASONA, METOCARBAMOL, HIDROXIDO DE ALUMINIO (COLLINS)	\N	129	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
134	2	48	12	ZOLIDIME C/20 GRAGEAS Dexametasona+Fenilbutazona+Acido Acetilsalicílico+Aluminio. (COLLINS)	\N	130	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
135	2	48	39	ADVIL EXHIBIDOR TABLETAS C/15 ENVASES	\N	131	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
136	2	49	9	AFRIN ADULTO DESCONGESTIVO NASAL 20ML  (SCHERING-PLOUGH)	\N	132	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
137	2	49	9	AFRIN INFANTIL DESCONGESTIVO NASAL 20ML  (SCHERING-PLOUGH)	\N	133	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
138	2	37	47	AFUMIX  C/4 TABS (ALTIA)	\N	134	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
139	2	50	61	AGIN C/20 TABS (NORDIN)	\N	135	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
140	2	51	62	Agrifen Adulto Parches Paracetamol, Cafeina, Fenilefrina y Clorfenamina (Pisa)	\N	136	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
141	2	51	62	AGRIFEN INFANTIL PARCHES (PISA)	\N	137	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
142	2	52	62	AGRULAX POLVO (PISA)	\N	138	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
143	2	37	12	AKORAZOL 60G CREMA KETOCONAZOL (COLLINS)	\N	139	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
144	2	37	41	CONAZOL 2% 40G CREMA KETOCONAZOL (LIOMONT)	\N	140	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
145	2	37	36	FEMISAN VAGINAL 30G KETOCONAZOL, CLINDAMICINA (GROSSMAN)	\N	141	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
146	2	37	19	KETOCONAZOL 30G CREMA (APOTEX)	\N	142	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
147	2	37	41	CONAZOL 200MG C/10 TABS KETOCONAZOL (LIOMONT)	\N	143	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
148	2	37	\N	TINAZOL 120ML KETOCONAZOL SHAMPOO	\N	144	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
149	2	37	63	PRENALON 60ML SUSPENSION KETOCONAZOL (CHEMICAL)	\N	145	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
150	2	20	28	CLINDAMICINA/KETOCONAZOL (Loeffler) c/7 ÓVULOS 100/400 MG. (LOEFFLER)	\N	146	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
151	2	\N	12	ALBOZ 20MG C/60 CAPS (COLLINS)	\N	147	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
152	2	45	31	ALDERAN 100MG C/15 TABS LOSARTAN (MAVER)	\N	148	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
153	2	45	31	ALDERAN 50MG C/30 TABS LOSARTAN (MAVER)	\N	149	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
154	2	45	8	COLIBS 50MG C/60 TABS LOSARTAN (SBL)	\N	150	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
155	2	9	58	ANTIGRIPAL C/12 CAPS DEXTROMETORFANO, FENILEFRINA, CLORFENAMINA, PARACETAMOL (GEL PHARMA)	\N	151	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
156	2	9	18	DESENFRIOL-ITO PLUS SOL GOTAS 30ML CLORFENAMINA , PARACETAMOL, FENILEFRINA (BAYER)	\N	152	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
157	2	9	64	DILARMINE 100ML PARAMETASONA, CLORFENAMINA (NOVO PHARMA)	\N	153	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
158	2	9	65	PRINDEX 150ML SOLUCION DEXTROMETORFANO, FENILEFRINA, CLORFENAMINA, PARACETAMOL (ARMSTRONG)	\N	154	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
159	2	9	34	BLENDOX 4MG C/20 TABS CLORFENAMINA (DEGORTS CHEMICAL)	\N	155	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
160	2	9	18	CLORO-TRIMETON 10MG C/5 AMP CLORFENAMINA (BAYER)	\N	156	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
161	2	9	65	PRINDEX NEO 60ML SOLUCION , FENILEFRINA, CLORFENAMINA, PARACETAMOL (ARMSTRONG)	\N	157	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
162	2	9	66	RINOFREN 120ML  CLORFENAMINA/FENILEFRINA/PARACETAMOL (CARNOT)	\N	158	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
163	2	9	18	DESENFRIOL-D c/24 TABS. 2/5/500 MG CLORFENAMINA/FENILEFRINA/PARACETAMOL (BAYER)	\N	159	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
164	2	9	66	RINOFREN PEDIATRICO 30ML CLORFENAMINA/PARACETAMOL (CARNOT)	\N	160	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
165	2	9	54	DEXTRFNO/GUIAFNA/PARCTML.  JBE. Ped. Fco.118 ML Dextrometorfano+Guaifenesina+Clorfenamina. (AVIVIA)	\N	161	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
166	2	20	36	ALIVIN PLUS INY  (GROSSMAN)	\N	162	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
167	2	53	18	ALKA-SELTZER C/100 TABS EXHIBIDOR  (BAYER)	\N	163	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
168	2	53	18	ALKA-SELTZER LIMON C/12 TABS (BAYER)	\N	164	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
169	2	9	11	ALLEGRA 120MG C/10 TABS FEXOFENADINA (SANOFI)	\N	165	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
170	2	9	11	ALLEGRA PEDIATRICO 150ML FEXOFENADINA (SANOFI)	\N	166	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
171	2	13	67	ALMAX 13.3GR/100ML 225ML (ALMIRALL)	\N	167	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
172	2	13	67	ALMAX C/30 SOBRES 15ML  (ALMIRALL)	\N	168	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
173	2	54	50	ALPRAZOLAM  c/30 TABS. 0.50 MG.(Psicofarma)	\N	169	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
174	2	54	50	ALZAM 2MG  C/30 TABS (PSICOFARMA)	\N	170	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
175	2	38	31	ALTIVER 50MG C/30 TABS CAPTOPRIL (MAVER)	\N	171	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
176	2	55	38	Alupent 0.5mg c/5 Amp Orciprenalina (Boehringer Ingelheim)	\N	172	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
177	2	56	12	ALZOCID 20MG C/8 TABS TADALAFIL (COLLINS)	\N	173	\N	\N	0	\N	t	2025-07-06 18:15:33.734133+00	\N
178	2	57	11	AMARYL MX TABS 4MG C/16 TABS (SANOFI)	\N	174	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
179	2	58	68	AMIFARIN 500MG C/12 CAPS DICLOXACILINA (WANDEL)	\N	175	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
180	2	58	23	BRISPEN 500MG C/20 TABS DICLOXACILINA (HORMONA)	\N	176	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
181	2	58	7	Posipen 12h 1g c/10 Caps Dicloxacilina (Sanfer)	\N	177	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
182	2	20	13	Amikacina 2ml Iny (Amsa)	\N	178	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
183	2	\N	29	AMLODIPINO 5MG C/10 TABS (ULTRA)	\N	179	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
184	2	\N	54	AMLODIPINO 5MG C/100 TABS (AVIVIA)	\N	180	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
185	2	\N	69	AMLODIPINO 5MG C/30 TABS (MEDLEY)	\N	181	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
186	2	20	49	AMOXICILINA 500MG C/100 TABS (VICTORY)	\N	182	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
187	2	20	12	Gimabrol 500mg/30mg  c/12 Caps Amoxicilina, Ambroxol (Collins)	\N	183	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
188	2	20	12	GIMALXINA 250 MG SUSP AMOXICILINA (COLLINS)	\N	184	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
189	2	59	13	AMSAFAST 120MG C/21 CAPS ORLISTAT (AMSA)	\N	185	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
190	2	23	41	ANALGEN 220MG C/20 TABS (LIOMONT) NAPROXENO	\N	186	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
191	2	23	18	Flanax 40g Gel Naproxeno Sodico 5.5% (Bayer)	\N	187	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
192	2	23	13	NAPROXENO 500MG C/45 TABS (AMSA)	\N	188	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
193	2	23	44	Naxodol 250mg-200mg c/30 Caps Naproxeno-Carisoprodol (Siegfried Rhein)	\N	189	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
194	2	23	27	VELSAY-S COMPUESTO 100ML SUSP NAPROXENO,PARACETAMOL (SONS)	\N	190	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
195	2	36	\N	ARNICA CON NAPROXENO	\N	191	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
196	2	36	\N	FORMULA CHINA CON DICLOFENACO Y NAPROXENO  125GR	\N	192	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
197	2	36	\N	MAMISAN C/ARNICA Y NAPROXENO 100GR	\N	193	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
198	2	20	36	ANAPENIL INY 400,000 U  (GROSSMAN) BENCIPENICILINA	\N	194	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
199	2	20	13	BENCILPENICILINA PROCAINA 800,000 U C/1 AMP (AMSA)	\N	195	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
200	2	20	24	PENICILINA 500MG 800,000 UI C/100 CAPS PENIXILIN (HEALTH TEC)	\N	196	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
201	2	20	70	PENICILINA POMADA 12GR  (KURAMEX)	\N	197	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
202	2	60	15	ANARA 125ML JARABE (CHINOIN) PICOSULFATO	\N	198	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
203	2	61	7	ANDANTOL 25G  (SANFER)	\N	199	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
204	2	62	71	ANGIN 30 TABS (VIVALIVE)	\N	200	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
205	2	24	72	DIMEFOR G 5MG METFORMINA/GLIBENCLAMIDA (SEGFREID RHEIN)	\N	201	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
206	2	24	73	DINAMEL 500MG C/30 TABS METFORMINA (LIFERPAL)	\N	202	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
207	2	24	74	METDUAL C/30 TABS GLIPIZIDA/METFORMINA (SILANES)	\N	203	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
208	2	\N	29	ARIFLAM 100MG C/50 TABS DICLOFENACO (ULTRA)	\N	204	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
209	2	63	75	ARNICA C/60 CAPS (ANAHUAC)	\N	205	\N	\N	0	\N	t	2025-07-06 18:15:34.431597+00	\N
210	2	\N	76	ARTIDOL GEL 60GR (RIMSA)	\N	206	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
211	2	\N	76	ARTRIDOL C/20 CAPS  (RIMSA)	\N	207	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
212	2	\N	77	ARTRIFLEX C/60 TABS  (SANDY)	\N	208	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
213	2	23	18	ASPIRINA 500MG C/40 TABS  (BAYER)	\N	209	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
214	2	23	18	ASPIRINA JUNIOR 100MG C/60 TABS (BAYER)	\N	210	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
215	2	64	78	ACONDICIONADOR COLA DE CABALLO 1.1 L (INDIO PAPAGO)	\N	1000	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
216	2	65	62	AGUA INY 3ML (PISA)	\N	1001	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
217	2	10	79	Ajo Japones c/60 Tabs (Farnat)	\N	1002	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
218	2	\N	80	ASSAL SALBUTAMOL AEROSOL  C/200 DOSIS (SALUS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
219	2	\N	22	ASTRINGOSOL ANTISEPTICO  (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
220	2	\N	81	ATARAX 25MG C/25 TABS (UCB DE MÉXICO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
221	2	\N	65	ATEMPERATOR 400MG C/30 TABS VALPROATO DE MAGNESIO (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
222	2	\N	75	AUTENTICA VIBORA DE CASCABEL C/50 CAPS (ANAHUAC)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
223	2	\N	65	AUTRIN 600MG C/36 TABS VITAMINAS, HIERRO (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
224	2	\N	32	AVAPENA C/5 AMP CLOROPIRAMINA (SANDOZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
225	2	\N	\N	BABA DE CARACOL CREMA 150GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
226	2	\N	7	BABY KANK-A GEL 10GR SABOR UVA (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
227	2	\N	22	Bactroban Unguento 2% 15g Mupirocina (Glaxo Smith Kline)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
228	2	\N	82	Balsamo Blanco Pomada 240g (Aranda)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
229	2	\N	82	Balsamo Blanco Pomada 60g (Aranda)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
230	2	\N	\N	BALSAMO DEL PERU GEL 120GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
231	2	\N	83	BALSAMO DEL TIGRE 100GR  (PLANTIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
232	2	\N	\N	BALSAMO DEL TRIGRE 125GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
233	2	\N	\N	BALSAMO DENTAL SAN JORGE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
234	2	\N	\N	BALSAMO NEGRO 125GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
235	2	\N	18	BAMITOL POMADA 200GRM (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
236	2	\N	\N	BAÑO COLOIDE POLVO 90G ARDOR Y COMEZON	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
237	2	\N	27	BAYCUTEN N CREMA 35G (SON'S)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
238	2	\N	84	BEBIDA DE ALPISTE 1.1KG(YPENSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
239	2	\N	36	Bedoyecta G c/30 Tabs Multivitaminico, Extracto de Ginseng (Grossman)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
240	2	\N	85	BEKA C/10 PEINES PIOJOS PLASTICO (BEKA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
241	2	\N	86	BELLA AURORA CREMA ACLARANTE (STILLMAN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
242	2	\N	87	BELLODECTA C/10 AMP (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
243	2	\N	88	BENADREX 120ML  DIFENHIDRAMINA,DEXTROMETORFANO (JOHNSON & JOHNSON)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
244	2	\N	88	BENADRYL ALERGIA C/24 TABS (JOHNSON & JOHNSON)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
245	2	\N	88	BENADRYL ALERGIA JBE 120ML (JOHNSON & JOHNSON)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
246	2	\N	88	BENADRYL E 150ML JARABE  (JOHNSON & JOHNSON)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
247	2	\N	18	BENEXOL C/30 COMPRIMIDOS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
248	2	\N	\N	BENZAL DOUCHE CLASICO CUIDADO INTIMO FEMENINO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
249	2	\N	\N	BENZAL POLVO C/12 SOBRES CUIDADO INTIMO FEMENINO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
250	2	66	83	BERGAMOTA HAIR OIL 2 OZ (PLANTIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
251	2	\N	89	BETAMETASONA , CLOTRIMAZOL , GENTAMICINA 40GR (BEST)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
252	2	67	22	BETNOVATE 100ML LOCION (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
253	2	\N	22	BETNOVATE CREMA 40GR (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
254	2	\N	50	BEZAFIBRATO 200MG C/30 TABS (PSICOFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
255	2	\N	\N	BINAFEX C20 TABS 250 MG	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
256	2	\N	18	BINOTAL 1G C/12 TABS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
257	2	\N	18	BINOTAL 250MG SUSP (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
258	2	\N	18	BINOTAL 500MG C/30 CAPS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
259	2	\N	18	BINOTAL 500MG SUSP (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:34.993098+00	\N
260	2	\N	90	BIODAN c/50 TABS. 100 MG. FENITOINA (BIORESEARCH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
261	2	\N	90	BIOFENOR c/30 TABS. SULFATO FERROSO (BIORESEARCH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
262	2	\N	91	BIOFILEN 100MG c/28 TABS ATENOLOL (DEGORTS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
263	2	\N	90	BIOFUROSO 200MG C/50 TABS FUMARATO FERROSO (BIORESEARCH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
264	2	\N	40	BIOKACIN 500MG SOLUCION INY (RAYERE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
265	2	\N	9	BIOMETRIX AOX C/100 CAPS  (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
266	2	\N	9	BIOMETRIX AOX C/60 CAPS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
267	2	\N	9	BIOMETRIX C/100 CAPS  (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
268	2	\N	9	BIOMETRIX C/30 CAPS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
269	2	\N	92	BIOTINA 500MG C/30 CAPS (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
270	2	\N	31	BIPALVER 75MG C/28 TABS PREGABALINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
271	2	\N	38	Bipasmin Compuesto N c/20 Tabs (Boehringer Ingelheim)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
272	2	\N	93	Bismuto 1g Subnitrato (Alprima)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
273	2	\N	94	Boldo 400mg c/150 Caps (La Salud es Primero )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
274	2	\N	95	B-PLEX c/30 TABS. 500 MG.(BIOMIRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
275	2	\N	36	BRE-A-COL ADULTO 120ML  (GROSSMAN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
276	2	\N	96	BRILINTA 90MG C/60  (AZTRA ZENECA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
277	2	\N	\N	BRINTELLIX 10MG C/28 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
278	2	\N	27	BROMINOL-C 120ML DEXTROMETORFANO/AMBROXOL (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
279	2	\N	79	BRONALIN INFANTIL 120ML (FARNAT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
280	2	\N	\N	BRONCO FRESH C/12 PIEZAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
281	2	\N	\N	BRONCOLIN 140ML JARABE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
282	2	\N	\N	BRONCOLIN 250ML JARABE ETIQUETA AZUL	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
283	2	\N	\N	BRONCOLIN PALETAS C/10	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
284	2	\N	\N	BRONCOLIN RUB C/12 LATITAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
285	2	\N	\N	BRONCOLIN RUB VITROLERO C/40 LATITAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
286	2	\N	\N	BRONCOMED 120ML ADULTO DEXTROMETORFANO, GUAIFENESINA (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
287	2	\N	\N	BROXTORFAN 120ML ADULTO AMBROXOL/DEXTROMETORFANO (BIOMEP)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
288	2	\N	\N	BRUBIOL 500MG C/10 TABS CIPROFLOXACINO (BRULUART)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
289	2	\N	\N	BRUMAX 250MG SUSP (BRULUAGSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
290	2	\N	\N	BRUMAX 500MG C/12 CAPS (BRULUAGSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
291	2	\N	\N	BRUPEN 500MG C/20  (BRULUAGSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
292	2	\N	\N	BUENA NOCHE C/60 CAPS  (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
293	2	\N	\N	Buscapina 20mg c/3 Amp HIOSCINA (Boehringer Ingelheim)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
294	2	\N	\N	BUSCAPINA COMP C/10 TABS BUTILlHIOSCINA o HIOSCINA , METAMIZOL SODICO (BOEHRINGER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
295	2	\N	\N	BUSCAPINA DISPLAY 220MG  C/120 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
296	2	\N	\N	BUSCAPINA FEM C/10 TABS HIOSCINA (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
297	2	\N	\N	BUSCONET 250MG C/10 TABS (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
298	2	\N	97	BUSTILLOS CREMA BLANCA 100G (BUSTILLOS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
299	2	\N	\N	BUTILHIOSCINA  10MG C/10 TABS. (SCHOEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
300	2	\N	\N	BUTILHIOSCINA (Apotex) c/10 TABS. 10 MG.	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
301	2	\N	\N	C. de Indias 50mg c/60 Tabletas (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
302	2	\N	\N	C. Mariano Reforzado 125mg c/30 Tabletas (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
303	2	\N	\N	CAFERGOT C/30 COMPRIMIDOS (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
304	2	\N	\N	CAJETA ONDULADA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
305	2	\N	\N	CAJETA REDONDA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
306	2	\N	\N	CAJETA ZAGALA C/24 KILO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
307	2	\N	98	CALADRYL 180ML LOCION (VALEANT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
308	2	\N	99	CALANDA C/30 CAPS (ATANTLIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
309	2	\N	\N	CALCIO 600 + D3 C/60 (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
310	2	\N	\N	CALCORT 30MG C/10 TABS DEFLAZACORT (SANOFI AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
311	2	\N	\N	CALOMEL POLVO 10	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
312	2	\N	\N	Caltrate 600 + D c/30 Tabs (Wyeth)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
313	2	\N	\N	CALTRATE 600 + D C/60 TABS (WYETH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
314	2	\N	\N	CALTRATE 600 PLUS C/60 TABS (WYETH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
315	2	\N	\N	CALTRON 600 + D C/60 TAB (SALUD NATURAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
316	2	\N	\N	CALTRON 600 C/60 TAB (SALUD NATURAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
317	2	\N	100	CAPENT POMADA ROZADURAS 110GR  (COLUMBIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
318	2	\N	100	CAPENT POMADA ROZADURAS 20GR (COLUMBIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
319	2	\N	100	CAPENT POMADA ROZADURAS 45GR (COLUMBIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
320	2	\N	\N	CAPRICE ALGAS SPRAY 316ML C/12 (PALMOLIVE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
321	2	\N	\N	CAPRICE BIOTINA SPRAY 316ML C/12 (PALMOLIVE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
322	2	\N	\N	CAPRICE KIWI SPRAY 316ML C/12 (PALMOLIVE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
323	2	\N	\N	CARBALAN 200MG C/20 TABS CARBAMAZEPINA (QUIFA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
324	2	\N	101	CARBONATO DE MAGNESIA PURO 7G (COYOACAN QUIMICA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
325	2	\N	\N	CARDISPAN 1G /20 TABS (GROSSMAN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
326	2	\N	\N	CARDISPAN C/5 AMP (GROSSMAN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
327	2	\N	\N	CARNOTPRIM 10MG C/20 COMPRIMIDOS (CARNOT LABS.)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
328	2	\N	\N	CARPIN 200MG c/20 TABS. CARBAMAZEPINA (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
329	2	\N	\N	CARTICAP FOR C/60 CAPS GLUCOSAMINA CONDROITINA (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
330	2	\N	\N	CARTILAGO DE TIBURON &  NONI COMPLEX C/180 TAB	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
331	2	\N	\N	Cartilogo de Tiburon y Glucosamina c/90 Caps	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
332	2	\N	\N	CASTAÑO DE INDIAS 1G C/90 (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
333	2	\N	\N	CASTAÑO DE INDIAS 500MG C/90 (FARNAT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
334	2	\N	\N	CASTAÑO DE INDIAS C/60 CÁPSULAS (YPENZA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
335	2	\N	\N	CASTAÑO DE INDIAS CREMA 150GR (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
336	2	\N	\N	CDS3 B-12 C/60CAPS (NORDIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
337	2	\N	\N	CEFAXONA 1G I.M CEFTRIAXONA (PISA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
338	2	\N	\N	Celebrex 200mg c/10 Caps Celecoxib (Pfizer)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
339	2	\N	\N	Celecoxib 200mg c/20 Tabs (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
340	2	\N	\N	CELESTONE 0.5MG C/50 TABS  (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
341	2	\N	\N	CELESTONE PEDIATRICO 60ML GOTAS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
342	2	\N	\N	CELESTONE SOL  3MG 1ML (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
343	2	\N	\N	CELESTONE SOL INY 2ML (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
344	2	\N	\N	CENTRUM C/ 60 TABS (WYETH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
345	2	\N	\N	CENTRUM KIDS C/60 TABS (WYETH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
346	2	\N	\N	CEVALIN INFANTIL 100MG C/100 TABS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
347	2	68	\N	CHACA CHACA BARRA C/30 C/16	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
348	2	\N	\N	CHACA CHACA TROZO C/32	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
349	2	\N	\N	CHAMOY NAVOLATO C/15	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
350	2	\N	\N	Chaparro Amargo 400mg c/150 Caps (La Salud es Primero)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
351	2	\N	\N	CHOLAL MODIFICADO C/10 AMP (ITALMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
352	2	\N	\N	CHUPA PANZA CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
353	2	69	\N	CHUPON C/MIEL C/25 (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
354	2	69	\N	CHUPON C/MIEL D'DITO C/25 (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
355	2	\N	\N	CICATRICURE 150ML SOL 365 50 SPF  (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
356	2	\N	\N	CICATRICURE CREMA OJOS 8.5G  (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
357	2	\N	\N	CICATRICURE GEL 30GR (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
358	2	\N	\N	CILOCID 5MG C/20 TABLETAS ACIDFO FOLICO (BRULUAGSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:35.590019+00	\N
359	2	\N	\N	CINARIZINA 75MG C/60 (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
360	2	\N	\N	Cinarizina 75mg c/60 (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
361	2	\N	\N	CINCO COMBINACIONES 500MG C/60 (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
362	2	\N	\N	CINEPRAC 200MG C/20 TABS TRIMEBUTINA (LIFERPAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
363	2	\N	\N	CIPRAIN 500MG C/10 TABS (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
364	2	\N	\N	CIPROFLOXACINO 250MG C/8 TABS  (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
365	2	\N	\N	CIPROFLOXACINO 500MG C/12 TABS  (AVIVIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
366	2	\N	\N	CIPROFLOXACINO 500MG C/12 TABS  (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
367	2	\N	\N	CIPROFLOXACINO 5ML OFTALMICAS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
368	2	\N	\N	CIPROLISINA 220ML CIPROHEPTADINA CIANOCOBALAMINA (CARNOT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
369	2	\N	\N	CIPROXINA 250MG SUSPENSION CIPROFLOXACINO (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
370	2	\N	\N	CIPROXINA 500MG  C/8 TABS CIPROFLOXACIONO (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
371	2	\N	\N	CIPROXINA 500MG C/14 COMPRIMIDOS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
372	2	\N	\N	CIRKUSED 140MG C/40 GRAGEAS (FARMASA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
373	2	\N	\N	CIRULAN 10MG C/20 TABS METOCLOPRAMIDA (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
374	2	\N	\N	CLARITYNE 24 HORAS C/10 TABLETAS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
375	2	\N	\N	CLARITYNE D 5/30 MG C/20 TABLETAS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
376	2	\N	\N	CLARITYNE D SOL. INF. 60ML (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
377	2	\N	\N	CLARITYNE D SOL. PED. 30ML (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
378	2	\N	\N	CLAVULIN 250-62.5MG/5ML SUSP (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
379	2	\N	\N	CLAVULIN 500MG C/15 TABS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
380	2	\N	\N	Clindamicina 300mg c/16 Caps (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
381	2	\N	\N	Clindamicina 300mg c/16 Caps (Maver)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
382	2	\N	\N	Clindamicina 300mg c/16 Caps (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
383	2	\N	\N	CLISON 200MG C/20 TAB (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
384	2	\N	\N	CLOBESOL 30G CREMA 5% CLOBETASOL (VALEANT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
385	2	\N	\N	CLONAFEC C/60 TABS DICLOFENACO (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
386	2	\N	\N	Clorafenicol Oftalmico 15ml Gotas (Amsa)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
387	2	\N	\N	CLORANFENICOL 5MG UNG  (OPKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
388	2	\N	\N	CLORANFENICOL OFTALMICAS 15ML (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
389	2	\N	\N	CLORANFENICOL OFTALMICAS 15ML (GRIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
390	2	\N	\N	CLORANFENICOL OFTALMICAS 15ML (OPKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
391	2	\N	\N	CLOROPIRAMINA 25MG C/20 TABS (SANDOZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
392	2	33	9	CLORO-TRIMETON 4HRS C/20 (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
393	2	\N	\N	CLORTORY 500MG C/16 TABS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
394	2	\N	\N	CLORURO DE MAGNESIO 100G VIDA MAGNESIO (QUIMICA COYOCAN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
395	2	\N	\N	Cloruro de Magnesio c/ Hierbabuena 100g Vida Magnesio (Quimica Coyoacan)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
470	2	\N	\N	CURA HONGOS CREMA 125GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
396	2	\N	\N	Cloruro de Magnesio c/ Hierbabuena 50g Vida Magnesio (Quimica Coyoacan)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
397	2	19	31	COBADEX ADULTO 120ML DEXTROMETORFANO/ AMBROXOL (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
398	2	19	31	COBADEX INFANTIL 120ML DEXTROMETORFANO/ AMBROXOL (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
399	2	\N	\N	Cola de Caballo 350mg c/150 Capsulas (La Salud es Primero)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
400	2	\N	\N	COLAGENO 1 KILO (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
401	2	\N	\N	Colageno 1g c/90 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
402	2	\N	\N	COLAGENO C/60 TABS (I PHARMA INNOVATION)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
403	2	\N	\N	COLAGENO HIDROLIZADO POLVO 250GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
404	2	\N	\N	COLAGENO POLVO CIRUELA 500MG (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
405	2	\N	\N	COLAGENO POLVO LIMON 500MG (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
406	2	\N	\N	COLCHICINA 1MG C/30 TABS (PERRIGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
407	2	18	102	COLCHIQUIM 1MG C/20 TABS COLCHICINA (PERRIGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
408	2	\N	\N	COLDTAC PLUS 72PZ C/2 TABS (RRX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
409	2	\N	\N	COLDTAC PLUS C/12 TABS (RRX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
410	2	\N	\N	COLESCONTROL C/90 TABS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
411	2	\N	\N	COLESTOPDIN 1G C/90 CAPS (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
412	2	\N	\N	COLLICORT 1% 60G CREMA HIDROCORTISONA (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
413	2	\N	\N	COLLICORT 2.5% 60G CREMA HIDROCORTISONA (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
414	2	\N	\N	COMBEDI 50,000 C/5 AMP TIAMINA, PIRIDOXINA, CIANOCOBALAMINA (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
415	2	\N	\N	COMBEDI DL 5MG C/3 AMP COMPLEJO B , DICLOFENACO , LIDOCAINA (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
416	2	\N	\N	COMBIVENT C/10 AMPOLLETAS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
417	2	\N	\N	COMPLEJO B INY 10ML C/5 JERINGAS (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
418	2	\N	\N	COMPLEJO B RIMSA SOL INY (RIMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
419	2	\N	\N	COMPLEJO B Y B12 MULTIVITAMINICO C/50 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
420	2	37	41	CONAZOL CREMA 40G + CONAZOL CREMA 30GR (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
421	2	\N	\N	CONCHA NACAR CREMA 150GR (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
422	2	33	22	CONTAC ULTRA C/12 TABLETAS (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
423	2	33	22	CONTAC ULTRA EXHIBIDOR C/25 SOBRES C/2 C/U (GSK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
424	2	12	103	CONVIFER C/ HIERRO SOL 110ML (DEGORT'S/CHEMICAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
425	2	\N	\N	CONVIFER C/HIERRO 220ML (DEGORT'S CHEMICAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
426	2	\N	\N	COREGA C/30 TABS EFERVECENTES (GSK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
427	2	\N	\N	CORPOTASIN CL C/50 TABS (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
428	2	\N	\N	CREMA ACEITE DE ARGAN 4,23 OZ FPS 45	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
429	2	\N	\N	Crema Camote Silvestre 120ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
430	2	\N	\N	CREMA CAMOTE Y LINAZA 60G  (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
431	2	\N	\N	CREMA CONCHA NACAR 60G  (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
432	2	\N	\N	CREMA COSMETICA C/10 FRASCOS (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
433	2	\N	\N	CREMA DE CARACOL C/ROSAMOSQUETA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
434	2	\N	\N	CREMA DE MANZANILLA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
435	2	\N	\N	CREMA LECHE DE BURRA 150ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
436	2	\N	\N	CREMA LECHE DE BURRA Y JALEA REAL 60G  (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
437	2	70	\N	CREMA MYRIAM DE DIA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
438	2	70	\N	CREMA MYRIAM NOCHE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
439	2	\N	\N	CREMA NUTRIDERM TEPEZCOHUITE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
440	2	\N	\N	Crema Nutritiva 120ml (Mega Mix)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
441	2	\N	\N	CREMA ÑAME 60GR  Eliminar	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
442	2	\N	\N	CREMA REDUCTORA BICOLOR 250GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
443	2	\N	\N	CREMA REDUCTORA DE TORONJA 500G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
444	2	\N	\N	CREMA REDUCTORA LIMON 250GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
445	2	\N	\N	CREMA REDUCTORA TORONJA 250GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
446	2	\N	\N	CREMA REPELNTE DE MOSQUITOS 150ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
447	2	\N	\N	CREMA ROSA MOSQUETA 150GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
448	2	\N	\N	CREMA ROSA MOSQUETA FPS 45 4,23 OZ	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
449	2	\N	\N	CREMA RUSA .42 (MEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
450	2	\N	\N	CREMA SUAVISANTE DE MANZANA 30GR (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
451	2	\N	\N	CREMA SUAVISANTE DE MANZANA 60GR (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
452	2	71	\N	CREMA TEPEZCOHUITE 150GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
453	2	71	\N	CREMA TEPEZCOHUITE 60GR DE DÍA (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
454	2	71	\N	CREMA TEPEZCOHUITE DIA 120GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
455	2	71	\N	CREMA TEPEZCOHUITE NOCHE 120GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
456	2	71	\N	CREMA TEPEZCOHUITE NOCHE 60GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
457	2	71	\N	CREMA TEPEZCOUITE ECO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.165131+00	\N
458	2	\N	\N	CREMA VITAMINA E Y JALEA REAL 120GR  (NATURAMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
459	2	\N	\N	Creolina Liquida 250ml (Bremer)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
460	2	\N	\N	Creolina Liquida 500ml (Bremer)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
461	2	\N	\N	Creolina Liquida 500ml (Cedrosa)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
462	2	\N	\N	CRESTOR 10MG C/30 TABS ROSUVASTATINA (AZTRA ZENECA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
463	2	\N	\N	CRONADYN 15MG PAROXETINA (MORE PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
464	2	\N	\N	CRONOCAPS M3G C/30 CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
465	2	\N	\N	CUACHALALATE C/150 CAPS  (YAZMIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
466	2	\N	\N	CUAJO HANSEN C/100 SOBRES (3 MUÑECAS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
467	2	\N	\N	CUBRE BOCAS C/10 PIEZAS (AMBID)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
468	2	\N	23	CUERPO AMARILLO FUERTE C/6 AMP (HORMONA LABS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
471	2	\N	\N	CURCUMA 1G C/90 TABS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
472	2	\N	\N	CURITAS C/100 (GALLITO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
473	2	\N	\N	CYCLOFEMINA C/1 INY (CARNOT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
474	2	\N	\N	CYRUX 200MG C/28 TABS MISOPROSTOL	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
475	2	\N	\N	CYTOTEC 200MG C/28 TAB (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
476	2	\N	\N	DABEON C/30 CAPS MINERALES Y VITAMINAS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
477	2	\N	\N	DAFLON 500MG C/20 TABS(SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
478	2	\N	\N	DAFLOXEN 100ML JARABE (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
479	2	\N	\N	DAKTARIN 30GR MICONAZOL  (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
480	2	\N	\N	DAKTARIN GEL 78GR (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
481	2	20	39	DALACIN T 30G GEL (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
482	2	\N	\N	DALACIN T 30ML(PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
483	2	\N	\N	DALACIN T PLEDGETS C/30 SOBRES  (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
484	2	\N	\N	DALACIN V 100MG C/3 ÓVULOS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
485	2	29	33	DALATINA 30G GEL 1G CLINDAMICINA (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
486	2	30	104	DALAY C/30 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
487	2	\N	\N	DALAY TE C/25 SOBRES (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
488	2	19	44	DALVEAR 200ML ADULTO DROPROPIZINA,BROMHEXINA (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
489	2	\N	\N	DAXON 500MG C/6 TAB (SIEGFRIED-RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
490	2	\N	\N	DEAFORT C/2 AMP. 10ML C/5 JGS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
491	2	\N	\N	DECA-DURABOLIN 1ML/50MG INY (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
492	2	\N	\N	DELECON 200MG C/10 TABS CELECOXIB (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
493	2	\N	\N	DELINEADOR PROSA 4 EN 1 (PROSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
494	2	\N	\N	DEMOGRASS C/30 CAPS CLASICO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
495	2	\N	\N	DEMOGRASS C/30 CAPS PLUS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
496	2	\N	\N	DEMOGRASS C/30 CAPS PREMIER	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
497	2	\N	\N	Depo-Medrol 40mg Iny Metilprednisolona (Pfizer)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
498	2	72	39	DEPO-PROVERA 150MG/ML INY (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
499	2	\N	\N	DERMAN CREMA 25GR (LABORATORIOS KSK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
500	2	\N	\N	DERMAN POLVO FUNGICIDA 80G  (LABORATORIOS KSK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
501	2	73	22	DERMATOVATE CREMA 40G (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
502	2	73	22	DERMATOVATE UNGUENTO 40G (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
503	2	\N	\N	DERMOLIMPIADOR NEUTRO CON ACEITE DE JOJOBA 125GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
504	2	74	104	DERMO-PRADA 10ML ANTIVERRUGAS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
505	2	75	105	DESENEX 28G ACIDO UNDECILENICO SANOFI AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
506	2	\N	\N	DESENFRIOL D C/24 TABS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
507	2	33	9	DESENFRIOL D C/30 TABLETAS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
508	2	\N	\N	DESENFRIOL-ITO PEDIATRICO GOTAS AZUL 120ML (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
509	2	33	9	DESENFRIOL-ITO PLUS C/24 TABS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
510	2	\N	\N	DESENFRIOL-ITO SOL GOTAS 60ML (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
511	2	\N	\N	DESENFRIOL-ITO TF JARABE 120ML (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
512	2	\N	\N	DESINTOXICADOR  ''A''  C/60 CAPS (ANAHUAC)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
513	2	\N	\N	DESINTOXICADOR ''B''  C/60 CAPS (ANAHUAC)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
514	2	\N	\N	DESINTOXICADOR ''C'' C/60 CAPS (ANAHUAC)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
515	2	\N	\N	DESODORANTE OBAO FRESCURA BAMBOO 150ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
516	2	\N	\N	DESODORANTE OBAO FRESCURA INTENSA 150ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
517	2	\N	\N	DESODORANTE OBAO FRESCURA PIEL DELICADA 150ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
518	2	\N	\N	DESODORANTE OBAO FRESCURA POWDER 150ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
519	2	\N	\N	DESODORANTE OBAO FRESCURA SENSITIVE ANGEL 150ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
520	2	\N	\N	DESODORANTE OBAO FRESCURA SUAVE 150ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
521	2	\N	\N	DESODORANTE OBAO FRESQUISSIMA 150ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
522	2	\N	\N	DESPAMEN C/1 AMP TETOSTERONA/ ESTRADIOL (CARNOT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
523	2	76	28	DESYN-N C/6 SUPOSITORIOS LIDOCAINA/ HIDROCORTISONA (LOEFFLER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
524	2	\N	\N	DEXABIÓN DC C/1 AMP (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
525	2	\N	\N	DEXABIÓN DC C/2 AMP (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
526	2	12	106	DEXABIÓN DC C/3 AMP (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
527	2	\N	\N	DEXTREVIT SOL INY C/2 FRASCOS MULTIVITAMINAS (VALEANT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
528	2	\N	\N	Diabedin 1g c/90 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
529	2	\N	\N	DIABINESE 250MG C/100 TABS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
530	2	\N	\N	DIANE C/21 GRAGEAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
531	2	\N	\N	DIAZEPAM 10MG C/20 TABS (PSICOFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
532	2	\N	\N	DIBENEL 0.940G C/30 TABLETAS (CMD)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
533	2	\N	\N	DICETEL 100MG C/14 TABS (ALTANA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
534	2	\N	\N	DICETEL 100MG C/28 TABS (ABBOT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
535	2	\N	\N	DICLOFENACO / COMPLEJO B C/30 TABS (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
536	2	\N	\N	DICLOFENACO 100MG C/20 TABS (AVIVIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
537	2	\N	\N	DICLOFENACO 100MG C/20 TABS (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
538	2	\N	\N	DICLOFENACO 50MG C/100 CAPS (SAIMED)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
539	2	\N	\N	DIETALAX 1G C/90 (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
540	2	\N	\N	Dieter's Drink 690mg c/30 Capsulas (La Salud es Primero)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
541	2	\N	\N	DIFENHIDRAMINA 25MG C/10 CAPS (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
542	2	\N	\N	DILACORAN 80MG C/30 TABLETAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
543	2	\N	\N	DILAR 2MG C/30 TAB (SYNTEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
544	2	\N	\N	DILARMINE 1MG C/25 TABS (SYNTEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
545	2	19	56	DIMACOL ADULTO FRAMBUESA 150ML (WYETH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
546	2	19	56	DIMACOL INFANTIL FRAMBUESA 150ML (WYETH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
547	2	19	56	DIMACOL PEDIATRICO FRAMBUESA 60ML (WYETH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
548	2	19	39	DIMETAPP INFANTIL JARABE 150ML UVA (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
549	2	19	39	DIMETAPP PEDIATRICO 60ML (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
550	2	77	107	DIOLMEX 120G POMADA (PHARMADIOL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
551	2	77	107	DIOLMEX 40G POMADA (PHARMADIOL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
552	2	77	107	DIOLMEX 60G POMADA (PHARMADIOL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
553	2	\N	\N	DIPROSONE CREMA 30GR (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
554	2	\N	\N	DIPROSONE G CREMA 30GR (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
555	2	\N	\N	DIPROSONE Y CREMA 30GR (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
556	2	\N	\N	DIPROSPAN 5ML  INY 5MG/2MG (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:36.725591+00	\N
557	2	17	9	DIPROSPAN HYPAK AMP 1ML (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
558	2	\N	\N	Disons Dex c/1 Amp Iny Betametasona (Son's)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
559	2	\N	\N	DISPERA 2MG C/100 TABS LOPERAMIDA (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
560	2	\N	\N	DISTENTAL 100MG 14 TABS (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
561	2	\N	\N	DITIZIDOL FORTE DICLOFENACO /TIAMINA/ PIRIDOXINA/ CIANOCOBALAMINA C/30 TABS (BEST)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
562	2	38	51	DIURMESSEL 40MG c/20 TABS FUROSEMIDA (BIOMEP)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
563	2	\N	\N	Divanamia 700mg c/60 Capsulas (Nature's´P.e.t. )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
564	2	72	27	DIVILTAC INY C/1 AMP ALGESTONA+ESTRADIOL (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
565	2	17	44	DOLAC  30MG c/4 TABS SUBLINGUAL KETOROLACO  (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
566	2	17	44	DOLAC 10MG C/10 TABS (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
567	2	17	44	DOLAC 10MG C/20 TABS (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
568	2	17	44	DOLAC 30 C/2 TABLETAS (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
569	2	17	44	DOLAC 30MG C/3 AMP (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
570	2	\N	\N	DOLBUTIN 200MG C/30 TABS TRIMEBUTINA (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
571	2	\N	\N	DOLFLAM C/4 AMP DICLOFENACO (RAYERE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
572	2	\N	\N	DOLIKAN 10MG C/10 TABS KETOROLACO (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
573	2	\N	\N	Dolo Bedoyecta Iny Hidroxocobalamina, Tiamina, Piridoxina y Ketoprofeno (Grossman)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
574	2	17	48	DOLO NEUROTROPAS VITAMINADO EXHIBIDOR C/100 TABS (SAIMED)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
575	2	17	30	DOLODOL VITAMINADO EXHIBIDOR C/80 TABS (BIOKEMICAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
576	2	17	106	DOLO-NEORUBIÓN DC C/3 AMP (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
577	2	\N	\N	DOLO-NEUROBION C/20 TABLETAS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
578	2	\N	\N	DOLO-NEUROBION C/30 CAPSULAS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
579	2	17	106	DOLO-NEUROBION DC FORTE INY (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
580	2	17	106	DOLO-NEUROBION FORTE C/30 TABS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
581	2	\N	\N	DOLPROFEN 600MG TABS (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
582	2	17	12	DOLPROFEN 800MG C/60 + 60  TABS (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
583	2	\N	\N	DOLTRIX 125MG C/20 TABS CLONIXINATO DE LISINA , HIOSCINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
584	2	\N	\N	DOLTRIX 250MG C/10 TABS CLONIXINATO DE LISINA , HIOSCINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
585	2	\N	\N	DON BRONQUIO 240ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
586	2	\N	\N	DONSICOL 20MG C/30 PREDNISONA (RAAM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
587	2	\N	\N	DONSICOL 20MG C/30 TABS PREDNISONA (RAAM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
588	2	\N	\N	DORSAL 15MG/200MG C/7 TABS (SILANES)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
589	2	\N	\N	Dosteril 10mg c/30 Tabs Lisinopril (Biomep)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
590	2	\N	\N	DOXICICILINA 100MG C/10 TABS (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
591	2	\N	\N	DOXICICILINA 100MG C/10 TABS (RANDALL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
592	2	78	108	DRAMAMINE 50MG C/24 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
593	2	\N	\N	DRAMAMINE INFANTIL 25MG SUPOSITORIOS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
594	2	78	108	DRAMAMINE JBE INF. 120ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
595	2	12	61	DUAL'S NORDIN ADULTO C/10 DOSIS (NORDIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
596	2	\N	\N	DUAL'S NORDIN INF C/10 DOSIS (NORDIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
597	2	\N	\N	DULCOLAX C/30 TABLETAS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
598	2	\N	\N	EASY FIGURE FORTE C/30	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
599	2	\N	\N	EASY FIGURE NORMAL C/30	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
600	2	\N	\N	Echin Gold 50g c/40 Tabletas (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
601	2	\N	\N	ECODINE-BF 120ML YODOPOVIDONA (CODIFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
602	2	\N	\N	EDEGRA 100MG C/10 TABS SILDENAFIL (L.SERRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
603	2	56	109	EDEGRA 100MG C/20 TABS SILDENAFIL (L.SERRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
604	2	\N	\N	EFFORTIL GOTAS 7.5ML (ETILEFRINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
605	2	\N	\N	EINAMEN 120ML HEDERA HELIX (PERRIGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
606	2	\N	\N	El Garrotazo 500mg c/10 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
607	2	\N	\N	El Viejito Pomada 120gr (Producto Pro Live Naturales)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
608	2	\N	\N	ELDOPAQUE 2% CREMA 30G  Hidroquinona, Silicato de Magnesio (VALEANT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
609	2	\N	\N	Eldopaque 4% Crema 30g Hidroquinona, Silicato de Magnesio (Valeant)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
610	2	\N	\N	ELDOQUIN 4% CREMA 30GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
611	2	\N	\N	ELECTROLITOS APO C/4 SOBRES LIMA-LIMON (PROTEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
612	2	\N	\N	ELECTROLITOS APO C/4 SOBRES LIMON (PROTEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
1120	2	\N	\N	LOTRIMIN 30GR (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
613	2	\N	\N	ELECTROLITOS APO C/4 SOBRES MANZANA (PROTEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
614	2	\N	\N	ELECTROLITOS APO C/4 SOBRES NARANJA  (PROTEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
615	2	\N	\N	ELECTROLITOS APO C/4 SOBRES PIÑA (PROTEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
616	2	\N	\N	ELECTROLITOS C/25 SOBRES SUERO ORAL (PROTEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
617	2	\N	\N	ELICA 0.1% UNG	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
618	2	\N	\N	ELITE CLOFENAMINA COMPUESTO C/10	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
619	2	\N	\N	ELOMET 30G UNG MOMETASONA (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
620	2	\N	\N	ELYM K 250ML JARABE (API ROYAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
621	2	\N	\N	EMLA CREMA 30G LIDOCAINA,PRILOCAINA (ASPEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
622	2	\N	110	EMPLASTO MONOPOLIS C/20 PARCHES (GRISI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
623	2	\N	\N	ENALADIL 10MG C/30 COMPRIMIDOS (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
624	2	\N	\N	ENALAPRIL  10MG C/60 TABS (Avivia)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
625	2	\N	\N	ENALAPRIL 10MG C/30 TABS (AVIVIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
626	2	38	50	ENALAPRIL 10MG C/30 TABS (PSICOFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
627	2	\N	\N	ENALAPRIL 10MG C/30 TABS (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
628	2	\N	\N	ENJUAGUE A BASE DE SAVILA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
629	2	\N	\N	ENOVAL 10MG C/30 TABS ENALAPRIL (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
630	2	\N	\N	EPAMIN 100MG C/50 CAPS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
631	2	\N	\N	Equinacea Complex 1g c/90 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
632	2	\N	\N	EQUINAFORTE 1GR C/90 (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
633	2	\N	\N	EQUINOFORTE C/90 (Sandy)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
634	2	75	28	ERBITRAX  30G TERBINAFINA (LOEFFLER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
635	2	75	28	ERBITRAX-T  250MG C/28 TABS TERBINAFINA (LOEFFLER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
636	2	75	28	ERBITRAX-T  250MG C/7 TABS TERBINAFINA (LOEFFLER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
637	2	15	31	ERISPAN  C/1 AMP Y JERINGA BETAMETASONA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
638	2	15	31	ERISPAN COMPUESTO PEDIATRICO 60ML (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
639	2	20	73	ERITROLAT 60ML ERITROMICINA (LIFERPAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
640	2	20	111	ERITROMICINA  500MG C/20 TABS. (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
641	2	20	112	ERITROMICINA 250MG SUSP (NEOLPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
642	2	20	20	ERITROMICINA 500MG C/20 TABS (RANDALL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
643	2	\N	\N	ERITROVIER T 500MG C/20 TABS ERITROMICINA (TECNOFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
644	2	\N	\N	ESCITALOPRAM 10MG C/28 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
645	2	\N	\N	ESKAFIAM C/30 TABLETAS (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
646	2	\N	\N	ESKAPAR 200MG C/16 CAPS NIFUROXAZIDA (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
647	2	\N	\N	ESPABION 100ML SUSP TRIMEBUTINA (DEGORTS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
648	2	\N	\N	ESPABION 200MG C/20 TABS TRIMEBUTINA (DEGORTS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
649	2	79	91	ESPABION 200MG C/40 TABS TRIMEBUTINA (DEGORTS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
650	2	\N	\N	ESPACIL COMPUESTO 125MG/10MG C/20 CAPS (VALEANT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
651	2	79	98	ESPAVEN 30ML PEDIATRICO DIMETICONA (VALEANT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
652	2	\N	\N	ESPAVEN 40/50MG C/24 TABS (VALEANT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
653	2	79	98	Espaven Enzimatico c/50 Grageas (Valeant)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
654	2	\N	\N	ESPERMA VIBORA DE CASCABEL INCIENSO C/2	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
655	2	\N	\N	ESPINICIDA VOAM 19GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
656	2	\N	\N	Espino Blanco c/150 Caps (Prosa)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:37.399769+00	\N
657	2	13	113	ESTOMAQUIL POLVO C/20 SOBRES 13G C/U (L.HIGIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
658	2	\N	\N	ESTOMAQUIL TIRA C/24 TABS MASTICABLES MENTA (L.HIGIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
659	2	\N	\N	ESTROGENOL C/100 CAPS (PLANTIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
660	2	\N	\N	Etabus 250mg c/15  Tabs Disulfiram (Ferring)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
661	2	\N	\N	Etabus 250mg c/36 Tabs Disulfiram (Ferring)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
662	2	\N	\N	ETER 250ML (LA FLOR)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
663	2	\N	\N	ETER 500ML (LA FLOR)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
664	2	30	114	EUCALIN 120ML JARABE (SALUD NATURAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
665	2	30	114	EUCALIN 240ML JARABE (SALUD NATURAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
666	2	30	114	Eucalin Infantil Jarabe 240ml (Salud Natural)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
667	2	30	114	EUCALIN KID'S 240ML JARABE (SALUD NATURAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
668	2	30	62	EUCALIPTINE 100MG C/10 AMP (PISA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
669	2	19	62	EUCALIPTINE JARABE 140ML (PISA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
670	2	30	75	Eucamiel Unguento 60g (Anahuac)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
671	2	\N	\N	EUGLUCON 5MG C/50 TABS (ROCHE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
672	2	\N	\N	EUTIROX 100MG C/50 TABS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
673	2	80	106	EUTIROX 150MG C/50 (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
674	2	\N	\N	EUTIROX 50MG C/50	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
675	2	\N	\N	EXCEDRIN DOLOR DE CABEZA C/10 TAB	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
676	2	\N	\N	EXCEDRIN MIGRAÑA C/24 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
677	2	81	110	EXCELSIOR POMADA CALLICIDA 8G C/10 (GRISI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
678	2	\N	\N	Extermina Grasa 1g c/30 Tabletas (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
679	2	\N	\N	Extracto 7 Azahares 80ml (Energreen)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
680	2	\N	\N	Extracto Boldo 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
681	2	\N	\N	EXTRACTO CALENDULA 60ML (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
682	2	\N	\N	Extracto Cascara Sagrada 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
683	2	\N	\N	Extracto Cascara Sagrada 80ml (Energreen)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
684	2	\N	\N	Extracto Castaño de Indias 120ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
1265	2	\N	\N	MUCIBRON 120ML AMBROXOL (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
685	2	\N	\N	Extracto Castaño de Indias 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
686	2	\N	\N	Extracto Castaño de Indias 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
687	2	\N	\N	Extracto Chaparro Amargo 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
688	2	\N	\N	Extracto Chaparro Amargo 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
689	2	\N	\N	Extracto Cola de Caballo 80ml (Energreen)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
690	2	\N	\N	Extracto Compuesto de Chaparro Amargo Ajo 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
691	2	\N	\N	EXTRACTO CUACHALATE 60ML (NATURAL FLOWER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
692	2	\N	\N	Extracto Cuasia 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
693	2	\N	\N	Extracto de Ajo 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
694	2	\N	\N	Extracto de Ajo Compuesto 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
695	2	\N	\N	Extracto de Alcachofa 120ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
696	2	\N	\N	Extracto de Alcachofa 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
697	2	\N	\N	Extracto de Artrikar Plus 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
698	2	\N	\N	Extracto de Copalquin 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
699	2	\N	\N	EXTRACTO DE DAMIANA 75ML (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
700	2	\N	\N	Extracto de Damiana 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
701	2	\N	\N	Extracto de Dolokar Plus 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
702	2	\N	\N	EXTRACTO DE ENEBRO 75ML (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
703	2	\N	\N	Extracto de Equinacea c/ Propoleo 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
704	2	\N	\N	Extracto de Fenogreco 80ml (Ener Green )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
705	2	\N	\N	Extracto de Hongo Michoacano c/10 Amp (GN + Vida)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
706	2	\N	\N	Extracto de Muerdago 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
707	2	\N	\N	EXTRACTO DE PANCREATYN 75ML (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
708	2	\N	\N	Extracto de Pasiflora 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
709	2	\N	\N	Extracto de Tepezcohuite 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
710	2	\N	\N	Extracto de Uva Ursi Compuesto 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
711	2	\N	\N	EXTRACTO DE VAINILLA 60ML (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
712	2	\N	\N	Extracto Diabe Pax 120ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
713	2	\N	\N	Extracto Diabekar 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
714	2	\N	\N	Extracto Diabetina 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
715	2	\N	\N	Extracto Diente de Leon 80ml (Energreen)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
716	2	\N	\N	Extracto Enebro 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
717	2	\N	\N	Extracto Equinace 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
718	2	\N	\N	Extracto Espino Blanco 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
719	2	\N	\N	Extracto Espino Blanco 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
720	2	\N	\N	Extracto Gastri Pax 120ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
721	2	\N	\N	Extracto Ginkgo Biloba 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
722	2	\N	\N	Extracto Golden Seal , Echinacea Ginkgobiloba 30ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
723	2	\N	\N	Extracto H. de SN Jn 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
724	2	\N	\N	Extracto H-Fin 30ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
725	2	\N	\N	Extracto Hierba de San Juan 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
726	2	\N	\N	Extracto Lechuga 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
727	2	\N	\N	Extracto Meno Pax 120ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
728	2	\N	\N	Extracto Migra Green 80ml (Energreen)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
729	2	\N	\N	EXTRACTO NATURAL DE CASTAÑO DE INIDIAS CON HAMAMELIS 60ML (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
730	2	\N	\N	Extracto Natural Ginkgo Biloba 60ml (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
731	2	\N	\N	Extracto Natural Lina-Sen 60ml (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
732	2	\N	\N	Extracto Natural Neem 60ml (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
733	2	\N	\N	Extracto Neem 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
734	2	\N	\N	Extracto Nlerim 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
735	2	\N	\N	Extracto Ojo de Gallina 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
736	2	\N	\N	Extracto Palo de Arco 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
737	2	\N	\N	Extracto Phytolaca Compuesta Tlanchalagua 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
738	2	\N	\N	Extracto Precardil 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
739	2	\N	\N	Extracto R1ñobil 80ml (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
740	2	\N	\N	Extracto Raiz de Yuca 60ml (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
741	2	\N	\N	Extracto Riño Pax 120ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
742	2	\N	\N	Extracto Sarivan-O 80ml (Energreen)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
743	2	\N	\N	Extracto Semilla de Uva 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
744	2	\N	\N	Extracto Sinusol 80ml (Energreen)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
745	2	\N	\N	Extracto Tepescouite 60ml (Natural Flower)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
746	2	\N	\N	Extracto Thuja 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
747	2	\N	\N	Extracto Tila, Azahar,Valeriana 60ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
748	2	\N	\N	Extracto Uri Health 80ml (Energreen)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
749	2	20	12	FACELIT 500MG C/20 CAPS CEFALEXINA (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
750	2	\N	\N	FACICAM C/20 CÁPSULAS (IPAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
751	2	76	115	FASTERIX UNG RECTAL 20G LIDOCAINA/ HIDROCORTISONA (FARMA HISP)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
752	2	\N	\N	FAZOLIN F 15ML  NAFAZOLINA, FENIRAMINA (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
753	2	17	44	FEBRAX C/5 SUPOSITORIOS (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
754	2	\N	\N	FEDPROS 0.4MG c/20 CAPS. TAMSULOCINA (RAAM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
755	2	\N	\N	FELDENE 20MG C/20 CAPS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
756	2	\N	\N	FENICOL OFTÁLMICO 10ML GOTAS (OFFENBACH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.158083+00	\N
757	2	\N	\N	FENTERMINA (Psicofarma) c/30 TABS. 30 MG.	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
758	2	\N	\N	FERDEPSA 15 ML. GOTAS SULFATO FERROSO (FARMADEXTRUM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
759	2	\N	\N	FER-IN-SOL PEDIÁTRICO SOL 50ML (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
760	2	\N	\N	FERMIG 50 MG.C/20 TABS. SUMATRIPTAN (RAAM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
761	2	\N	\N	FEROMONAS HOMBRE INIDIAN (CHAKRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
762	2	\N	\N	FEROMONAS MUJER INDIAN (CHAKRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
763	2	12	116	Ferranina 100ml Solucion Hierro Polimaltosado (Nycomed)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
764	2	12	117	FERRANINA COMPLEX C/30 TABLETAS (TAKEDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
765	2	12	117	FERRANINA FOL C/30 TABLETAS (TAKEDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
766	2	12	117	FERRANINA I.M. C/3 AMP (TAKEDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
767	2	\N	\N	Ferro 4 c/30 Grageas Fumarato Ferroso, Vitamina C,B1,B6,B12 (Streger)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
768	2	\N	\N	FIBRA XOTZIL DURAZNO 620GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
769	2	\N	\N	FIBRA XOTZIL MANGOO 620GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
770	2	\N	\N	FIBRA XOTZIL MANZANA VERDE 620GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
771	2	\N	\N	FIBRA XOTZIL NARANJA 620GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
772	2	\N	\N	FIBRA XOTZIL ORIGINAL 620GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
773	2	\N	\N	FIBRA XOTZIL VAINILLA 620GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
774	2	\N	\N	FIGRAL 100MG C/4 TABS SILDENAFIL (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
775	2	56	33	FIGRAL 100MG EXH C/20 TABS SILDENAFIL (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
776	2	\N	\N	FINASTERIDA 5MG C/30 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
777	2	20	41	FLAGENASE 400 C/30 CAPSULAS METRONIDAZOL, (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
778	2	20	41	FLAGENASE 400 PEDIÁTRICO SUSP 120ML (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
779	2	20	41	FLAGENASE 500MG C/30 TABLETAS (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
780	2	\N	\N	FLAGYL 250MG C/30 COMPRIMIDOS (MEDLEY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
781	2	\N	\N	FLAGYL 500MG C/10 OVULOS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
782	2	\N	\N	FLAGYL 500MG C/30 COMPRIMIDOS METRONIDAZOL  (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
783	2	\N	\N	FLAGYL/METRONIDAZOL 125MG SUSPENSION 120ML  (MEDLEY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
784	2	\N	\N	FLAGYSTATIN V 500MG/1000,000UI C/10 ÓVULOS(MEDLEY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
785	2	\N	\N	FLANAX 550MG  C/24 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
786	2	\N	\N	FLANAX 550MG C/30 TABS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
787	2	\N	\N	FLAUSIVER 450/50MG C/20 TABS DIOSMINA/HESPERIDINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
788	2	\N	\N	FLEBOCAPS C/30 TABS (PHARMACAPS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
789	2	\N	\N	FLENALUD 120ML HEDERA HELIX (SALUD NATURAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
790	2	\N	\N	FLOXANTINA 500MG C/12 TABS CIPROFLOXACINO (DEGORTS CHEMICAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
791	2	20	28	FLUOCINOLONA/METRONIDAZOL/NISTATINA c/10 OVULOS  (LOEFFLER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
792	2	\N	\N	FLUOXETINA 20MG C/14 CAPS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
793	2	\N	\N	FLUOXETINA 20MG C/14 CAPS (PSICOFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
794	2	\N	\N	FOLIVITAL 0.4MG C/30 TABS (SILANES)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
795	2	\N	\N	Folivital 4mg c/90 Tabs (Silanes)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
796	2	\N	\N	FORTICAL B C/30 GRAGEAS (SERRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
797	2	\N	\N	Fortical Forte Iny c/3 Amp Diclofenaco, B1,B2,B12 (Serral)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
798	2	\N	\N	FOSFOCIL 500MG C/12 CAPS FOSFOMICINA (CETUS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
799	2	\N	\N	FOSFOCIL I.M 1G  FOSFOMICINA (CETUS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
800	2	\N	\N	FOSHLENN 300MG C/16 CAPS CLINDAMICINA (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
801	2	\N	\N	FURACIN POMADA 85GR (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
802	2	\N	\N	FUROSEMIDA 40MG C/100 TABS (NEOLPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
803	2	\N	\N	FUROSEMIDA 40MG C/100 TABS (PHARMA RX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
804	2	\N	\N	GABADIOL 150 MG C/60 TABS PREGABALINA (SBL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
805	2	\N	\N	Gabapentina 800mg c/30 Tabs (Ultra)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
806	2	82	31	GALAVER GEL 250ML MAGALDRATO/ DIMETICONA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
807	2	\N	\N	GARAMICINA G.U. 160MG C/5 AMP (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
808	2	\N	\N	GARAMICINA G.U. 160MG HYPAC (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
809	2	\N	\N	GARAMICINA OFTALMICA 10ML GOTAS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
810	2	\N	\N	GARCINIA CAMBOGIA 50MMG C/60 CAPS (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
811	2	\N	\N	GARCINIA GAMBOGIA 500MG C/60 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
812	2	\N	\N	Garcinia Gambogia 50mg c/60 Caps (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
813	2	\N	\N	GARCINIA GAMBOGIA C/60 (ANAHUAC)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
814	2	\N	\N	Garcinia Gambogia Noche 1g c/90 Tabletas (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
815	2	\N	\N	GASA 10 X 10 C/100 (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
816	2	\N	\N	GB SHAMPOO DOS 230ML  (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
817	2	\N	\N	GB SHAMPOO UNO 230ML (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
818	2	\N	\N	GB SOLUCION ALOPECIA 60ML (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
819	2	\N	\N	GEL ALGAS MARINAS Y EUCALIPTO 125GR (MEGAMIX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
820	2	\N	\N	GEL CASTAÑO DE INDIAS 120GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
821	2	\N	\N	GEL PEYOTE C/MARIHUANA 250GRS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
822	2	\N	\N	GEL VENENO DE ABEJA 120GR (ECO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
823	2	\N	\N	GEL VITAL SLIM 250GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
824	2	\N	\N	GELDAKO 10MG C/10 CAPS KETOROLACO (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
825	2	\N	\N	GELMICIN 60G Betametasona,Gentamicina,Clotrimazol (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
826	2	\N	\N	GENKOVA C/5 AMP 80MG GENTAMICINA (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
827	2	20	40	GENREX I.U C/5 AMP 160MG/2ML (RAYERE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
828	2	\N	\N	Gentamicina c/5 Amp 160mg/2ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
829	2	60	118	GENTILAX C/50 TABS LAXANTE (DR. MONTFORT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
830	2	\N	\N	GERIAL B-12 JARABE  ELIXIR (ALLEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
831	2	\N	\N	GESLUTIN 200MG C/15 PERLAS (ASOFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
832	2	\N	\N	GLANIQUE 0.75 MG C/2 COMPRIMIDOS (ASOFARME)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
833	2	\N	\N	GLIBENCLAMIDA 5MG C/100 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
834	2	\N	\N	GLIBENCLAMIDA 5MG C/50 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
835	2	\N	\N	GLIBENCLAMIDA 5MG C/50 TABS (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
836	2	\N	\N	GLICERINA 120ML (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
837	2	\N	\N	GLIMETAL 2MG/1000MG C/30 TABS (SILANES)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
838	2	\N	\N	Glucobay 100mg c/30 Comprimidos Acarbosa (Bayer)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
839	2	\N	\N	GLUCOBAY 50MG C/30 COMPRIMIDOS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
840	2	\N	\N	Glucosamina 1g c/60 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
841	2	\N	\N	GLUCOSAMINA 800MG C/60 TABS (FARNAT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
842	2	\N	\N	GLUCOVANCE 500MG/2.5MG C/60 TABS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
843	2	\N	\N	GLUCOVANCE 500MG/5MG C/60 TABS (GENERICO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
844	2	\N	\N	GOICOTABS VARICES C/30 TABS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
845	2	\N	\N	GOODSIT C/6 SUPOSITORIOS LIDOCAINA, HIDROCORTISONA (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
846	2	\N	\N	GOTINAL 15ML (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
847	2	\N	\N	GOTINAL AD NAZAL 15ML (PROMECO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
848	2	\N	\N	GOTINAL INF NAZAL 15ML (PROMECO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
849	2	\N	\N	GRANEODIN B C/24 MIEL LIMON	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
850	2	\N	\N	GRANEODIN F C/16 TABS MIEL/LIMON FLURBIPROFENO  (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
851	2	50	119	GRANEODIN FRAMBUESA C/24 TABS (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
852	2	50	119	GRANEODIN MANDARINA C/24 TABS (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
853	2	50	119	GRANEODIN MENTA/EUCALIPTO C/24 TABS (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
854	2	\N	\N	GRANOEDIN B 10MG C/24 PASTILLAS FRAMBUESA (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
855	2	\N	\N	GRAVIDINONA 500MG C/1 AMP (SCHERING)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:38.740333+00	\N
856	2	\N	\N	GRIMAL 10ML OFTALMICO (GRIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
857	2	\N	\N	GRISOVIN F.P 500MG C/30 TABS  (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
858	2	\N	\N	GROOBE 50MG C/24 CAPS DIMENHIDRINATO (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
859	2	\N	\N	Guayacol con Eucalipto 650mg c/30 Caps (Anahuac)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
860	2	30	120	Guayap-tol 740mg c/30 Caps Eucalipto, Menta y Vitamina E (Medica Natural)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
861	2	\N	\N	Guayap-tol Adulto Jarabe 120ml Eucalipto y Guayacol (Medica Natural)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
862	2	\N	\N	Guayap-tol Infantil Jarabe 120ml Eucalipto y Guayacol (Medica Natural)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
863	2	\N	\N	GUAYATETRA ADULTO INY (RANDALL L)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
864	2	\N	\N	Guayatetra c/30 Caps Eucalipto y Guayacol (Randall Laboratories)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
865	2	\N	\N	GYNODAKTARIN 400MG OVULOS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
866	2	\N	\N	GYNODAKTARIN CREMA 3 DIAS 25GR (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
867	2	\N	\N	GYNOVIN C/21 GRAGEAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
868	2	\N	\N	H. de SN Jn 500mg c/60 Tabletas (''Garden Life'' )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
869	2	\N	\N	HABAS CON CASCARA C/20 BOLSAS 900GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
870	2	\N	\N	HAIR CLEAN NEEM + PANTHENOL 2.0 OZ (PLANTIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
871	2	68	121	HALLS CEREZA C/18  (ADAMS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
872	2	\N	121	HALLS EXPERT MIX C/18  (ADAMS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
873	2	\N	121	HALLS EXTRA STRONG C/18  (ADAMS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
874	2	\N	121	HALLS MENTA C/18  (ADAMS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
875	2	\N	121	HALLS MIEL Y LIMON C/18  (ADAMS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
876	2	\N	121	HALLS MIX C/18  (ADAMS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
877	2	\N	121	HALLS YERBABUENA C/18  (ADAMS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
878	2	\N	\N	Hemanina c/10 Amp Extracto de Higado y Vitaminas del Complejo B (Altana)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
879	2	\N	\N	HEMOBION 200MG C/30 TABS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
880	2	\N	\N	HEMOSIN-K C/3 AMP (HORMONA LABS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
881	2	\N	\N	HEMOSIN-K ORAL C/32 TABLETAS (HORMONA LABS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
882	2	\N	\N	Henna Colorante Vegetal 70grs Bolsa c/10 Sobres (Avant) (TRACY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
883	2	\N	\N	HEPANAT JBE HEPATICO Y COLERETICO  120ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
884	2	\N	\N	HERKLIN KIT SHAMPOO 120ML + SPRAY 30ML C/PEINE (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
885	2	\N	\N	HERKLIN SHAMPOO 120ML C/PEINE (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
886	2	\N	\N	HERKLIN SHAMPOO 60ML C/PEINE (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
887	2	83	\N	H-FIN JABON 100G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
888	2	\N	\N	HI-DEX 100MG C/3 AMP HIERRO (HORMONA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
889	2	\N	\N	HIERBA DE SAN JUAN 1200MG C/30 CAPS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
890	2	\N	\N	Hierba del Sapo 50mg c/60 Tabletas (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
891	2	\N	\N	HIERBA DEL SAPO C/150 CÁPSULAS (PROSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
892	2	\N	\N	Hierba del Sapo Plus 1g c/90 Tabletas (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
893	2	\N	\N	Hierro c/10 Amp (GN + Vida)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
894	2	\N	\N	Hierro Jarabe 340ml (GN + Vida)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
895	2	\N	\N	HIGROTON 50MG C/30 TABS CLORTALIDONA (SANDOZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
896	2	\N	\N	HIPEBE 0.4MG C/20 TABS TAMSULOSINA LANDSTEINER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
897	2	\N	\N	HIPOGLOS TARRO 110G POMADA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
898	2	33	11	HISTIACIL FAM ADULTO 140 ML GUAIFENESINA, OXOLAMINA (SONOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
899	2	33	11	HISTIACIL FAM INFANTIL 140 ML GUAIFENESINA, OXOLAMINA (SONOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
900	2	33	11	HISTIACIL FAM PEDIATRICO 60ML GUAIFENESINA, OXOLAMINA  (SONOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
901	2	\N	\N	HISTIACIL FLU ANTIGRIPAL C/20 TABS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
902	2	\N	\N	HISTIACIL NATIX ADULTO 100ML HEDERA HELIX (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
903	2	\N	\N	HISTIACIL NATIX INFANTIL 100ML HEDERA HELIX (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
904	2	33	11	HISTIACIL NF PEDIATRICO 30ML DEXTROMETORFANO/ AMBROXOL (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
905	2	\N	\N	HONGO FIN ESMALTE 15ML (ENER GREEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
906	2	\N	\N	HONGO FIN POMADA 125GR (ENER GREEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
907	2	\N	\N	HONGO FIN POMADA 40GR (ENER GREEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
908	2	\N	\N	Hongo Michoacano 1Litro	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
909	2	\N	\N	HONGO-FIN SHAMPOO 260ML (ENER GREEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
910	2	\N	\N	HONGO-FIN SPRAY 150ML (ENER GREEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
911	2	\N	\N	HUEVO C/12 (GREZON)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
912	2	\N	\N	HUEVO KINDER C/12 (KINDER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
913	2	\N	\N	HUEVO KINDER C/8 DE 12 PIEZAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
914	2	\N	\N	HUEVO NATOONS C/12 (KINDER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
915	2	\N	\N	HUEVO SORPRESA C/12 (KINDER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
916	2	\N	\N	HYDRALITOS SUERO 1L (RRX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
917	2	\N	\N	HYDRASOR C/25 SOBRES ELECTROLITOS (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
918	2	\N	\N	I.Q Memory 800mg c/100 Capuslas (Nature's ´P.e.t. )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
919	2	\N	\N	I.Q Students Memory 520g c/90 Capsulas (Nature's ´P.e.t. )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
920	2	\N	\N	ICADEN CREMA 20GR (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
921	2	\N	\N	Icy Hot c/5 Parches Mentol 5%	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
922	2	\N	\N	Icy Hot Crema 85g	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
923	2	\N	\N	Icy Hot Spray Mentol 5%	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
924	2	\N	\N	ILIADIN AD GOTAS 20ML (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
925	2	\N	\N	ILIADIN INF GOTAS 20ML (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
926	2	\N	\N	ILIADIN LUB INF SPRAY 20ML (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
927	2	\N	\N	ILIADIN OXIMETAZOLINA SPRAY ADULTO 30ML (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
928	2	\N	\N	ILOSONE 125MG SUSP (LILLY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
929	2	\N	\N	ILOSONE 250MG SUSP (LILLY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
930	2	\N	\N	ILOSONE 500MG C/20 TABS (LILLY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
931	2	\N	\N	IMODIUM C/12 TABLETAS (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
932	2	\N	\N	INCIENSO VIBORA DE CASCABEL (ESOTERICO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
933	2	\N	\N	INDERALICI 40MG C/30 TABLETAS (ASTRAZENECA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
934	2	\N	\N	INSUSYM 5MG C/100 TABS GLIBENCLAMIDA (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
935	2	\N	\N	INTERNOL 100MG C/100 TABS ATENOLOL (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
936	2	\N	\N	INTERNOL 100MG C/28 TABS ATENOLOL (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
937	2	38	49	INTERNOL 50MG C/100 TABS ATENOLOL (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
938	2	36	22	IODEX CLASICO 60G (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
939	2	36	22	IODEX CRITAL 60G  (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
940	2	\N	\N	IRRESARTAN 150MG C/28 TABS (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
941	2	84	38	ISODINE BUCOFARINGEO 120ML (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
942	2	\N	\N	ISODINE DUCHA VAGINAL 120ML (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
943	2	\N	\N	ISODINE ESPUMA 120ML (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
944	2	84	38	ISODINE SOLUCIÓN 120ML (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
945	2	\N	\N	ISORBID  10MG C/40 TABS DINITRATO DE ISOSORBIDA  (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
946	2	\N	\N	Isox 15 D 100mg c/15 Caps Itraconazol (Senosiain)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
947	2	\N	\N	ITRACONAZOL 100MG C/15 TABS  (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
948	2	\N	\N	ITRACONAZOL 100MG C/15 TABS (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
949	2	\N	\N	ITRAVIL 30MG C/6O CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
950	2	\N	\N	IVEXTERM 6MG C/4 TABS IVERMECTINA (VALEANT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
951	2	\N	\N	JABON ABRECAMINO 90GR (BLANCA FLOR MAGICA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
952	2	\N	\N	JABON ACEITE DE COCO 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
953	2	\N	\N	JABON ACEITE DE JOJOBA (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
954	2	\N	\N	JABON ACEITE DE OSO ALMEDRAS,OLIVO Y RICINO 125GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
955	2	\N	\N	JABON ALGAS 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:39.390765+00	\N
956	2	\N	\N	Jabon Aloe Vera con Pulpa Natural 90g (Prosa) (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
957	2	\N	\N	Jabon Antimicotico Hongo Piel 100g	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
958	2	\N	\N	JABON ARBOL DE TE Y EUCALIPTO 125G (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
959	2	\N	\N	JABON ARRASA CON TODO (FLOR DE LUJO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
960	2	\N	\N	Jabon Artesanal de Aguacate (Megamix)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
961	2	\N	\N	Jabon Artesanal Hiel de Toro (Megamix)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
962	2	\N	\N	JABON AVENA Y MIEL 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
963	2	\N	\N	Jabon Avena, Trigo, Miel 120g (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
964	2	\N	\N	Jabon Azufre Con Aloe Vera 90g (Prosa)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
965	2	\N	\N	JABON BABA DE CARACOL 100GR (VIDA HERBAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
966	2	\N	\N	JABON BABA DE CARACOL 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
967	2	\N	\N	JABON CACAHUANANCHE 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
968	2	\N	\N	JABON CALENDULA 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
969	2	\N	\N	JABON CHILE 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
970	2	\N	\N	Jabon Chile de Arbol 120gr (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
971	2	\N	\N	JABON CON ARCILLA VERDE 100GR (GIZEH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
972	2	\N	\N	JABON CONCHA NACAR 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
973	2	\N	\N	JABON CREMOSO EXTRA C/COLAGENO 125GR(INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
974	2	\N	\N	Jabon de Algas 90g (Prosa) (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
975	2	\N	\N	Jabon de Avena 90gr (Prosa) (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
976	2	\N	\N	Jabon de Cacahuananche con Aloe Vera 90gr (Prosa) (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
977	2	\N	\N	Jabon de Calendula 120gr (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
978	2	\N	\N	Jabon de Colageno 120gr (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
979	2	\N	\N	Jabon de Creolina (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
980	2	\N	\N	Jabon de Escencias 100g	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
981	2	\N	\N	Jabon de Escencias Doble 100g	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
982	2	\N	\N	Jabon de Jitomate 120gr (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
983	2	\N	\N	JABON DE TEPEZCOHUITE 125G (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
984	2	\N	\N	JABON DE TEPEZCOHUITE 200GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
985	2	\N	\N	Jabon del Perro Agradecido 120gr (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
986	2	\N	\N	Jabon Derma Organic 100g	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
987	2	\N	\N	JABON DOBLE SUERTE RAPIDA (FLOR DE LUJO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
988	2	\N	\N	JABON GALLINA NEGRA (FLOR DE LUJO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
989	2	\N	\N	Jabon H-Fin 100g (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
990	2	\N	\N	JABON HIEL DE TORO (LA SALUD ES PRIMERO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
991	2	\N	\N	Jabon Hongosan Premium Plus (Producto Homeopatico )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
992	2	\N	\N	JABON JITOMATE 125G (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
993	2	\N	\N	JABON LECHE DE BURRA 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
994	2	\N	\N	JABON LECHE DE BURRA BODY CREAM	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
995	2	\N	\N	Jabon Limpia Piel 100g	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
996	2	\N	\N	JABON LIMPIAS 90GR (FLOR DE LUJO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
997	2	\N	\N	JABON MIEL DE AMOR ELLAS/FERONOMAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
998	2	\N	\N	JABON NEUTRO 100G (GRISI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
999	2	\N	\N	JABON NEUTRO 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1000	2	\N	\N	JABON PARA PERROS 125G (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1001	2	\N	\N	JABON PARA PIOJOS HR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1002	2	\N	\N	JABON PERROS CON CREOLINA 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1003	2	\N	\N	JABON RUDA DERMOLIMPIADOR 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1004	2	\N	\N	JABON SAN RAMON 80GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1005	2	\N	\N	JABON TEPEZCOUITE (OCOTZAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1006	2	\N	\N	JABON TEPEZCOUITE 3.5 (DAP)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1007	2	\N	\N	Jabon Tepezcouite con Corteza Natural 90g (Prosa) (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1008	2	\N	\N	JABON VERDE 120GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1009	2	\N	\N	JABON VIBORA DE CASCABEL  (LA SALUD ES PRIMERO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1010	2	\N	\N	JABON VIBORA DE CASCABEL (CELOFAN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1011	2	\N	\N	JABON VIVBORA DE CASCABEL 120GR (NUTRIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1012	2	\N	\N	JABON ZABILA 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1013	2	\N	\N	JABON ZABILA Y AZUFRE 125GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1014	2	\N	\N	JALEA REAL CON TIAMINA 650MG C/30 CAPS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1015	2	85	\N	JERINGA 3ML 21X32 PLASTIPAK	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1016	2	\N	\N	JERINGA 5ML 21X32 PLASTIPAK	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1017	2	\N	\N	JUGO VERDE MIX 1 KILO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1018	2	\N	\N	JUGO VERDE MIX 2 KILOS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1019	2	\N	\N	KALIOLITE 500MG C/50 GRAGEAS CLORURO DE POTASIO (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1020	2	86	65	KAOMYCIN 180ML NEOMICINA,CAOLIN,PECTINA (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1021	2	86	65	KAOMYCIN C/20 TABS NEOMICINA,CAOLIN,PECTINA (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1022	2	\N	\N	KAOPECTATE C/20 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1023	2	\N	\N	KAPOSALT C/50 TABS SALES DE POTASIO (TECNOFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1024	2	\N	\N	KASTORAAM 10MG C/10 TABS MONTELUKAST (RAAM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1025	2	\N	\N	KEFLEX 1G C/12 TABS CEFALEXINA (LILLY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1026	2	\N	\N	KEFLEX 250MG SUSP (LILLY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1027	2	\N	\N	KEFLEX 500MG C/12 TABS CEFALEXINA (LILLY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1028	2	\N	\N	KEFLEX 500MG C/20 TABS CEFALEXINA (LILLY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1029	2	\N	\N	KENCICLEN 100MG C/10 CAPS DOXICICLINA (KENER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1030	2	\N	\N	KENZOFLEX 500MG C/12 TABS BOTE CIPROFLOXACINO (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1031	2	\N	\N	KENZOFLEX 500MG C/12 TABS CIPROFLOXACINO (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1032	2	\N	\N	KENZOFLEX 500MG C/28 TABS CIPROFLOXACINO (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1033	2	\N	\N	KESIPRIL 10MG C/10 TABS LISINOPRIL (KENER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1034	2	\N	\N	KETOROLACO 10MG C/10 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1035	2	\N	\N	KETOROLACO 10MG C/10 TABS (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1036	2	\N	\N	KETOROLACO 10MG C/10 TABS (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1037	2	\N	\N	KETOROLACO 30MG C/3 AMP (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1038	2	12	38	KIDDI PHARMATON 100ML SUSP (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1039	2	12	38	KIDDI PHARMATON 200ML SABOR NARANJA (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1040	2	12	38	KIDDI PHARMATON C/30 TABS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1041	2	\N	\N	Kitoscell 3.5g Gel (CTT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1042	2	\N	\N	Kitoscell 30g Gel (CTT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1043	2	20	31	KLARIX 250MG SUSP CLARITROMICINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1044	2	20	31	KLARIX 500MG C/10 TABS CLARITROMICINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1045	2	\N	\N	KLODEX 2MG C/100 TABS CLONAZEPAM (IFA CELTICS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1046	2	\N	\N	Kola Loka 5g Goterito (Krazy)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1047	2	12	30	KORTRIBION C/80 CAPSULAS (BIOKEMICAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1048	2	\N	\N	KRAFASIN 40G Betametasona,Gentamicina,Clotrimazol (DANKEL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1049	2	\N	\N	KROBICIN 250MG SUSP CLARITROMICINA (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1050	2	\N	\N	LA MILAGROSA CREMA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1051	2	\N	\N	La Tia Mana 50g Crema Acne, Espinillas, Paño, Pecas, Manchas de Sol y Arrugas Prematuras	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1052	2	\N	\N	LABELLO 24HRS PROTECTOR LABIAL CEREZA (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1053	2	\N	\N	LABELLO 24HRS PROTECTOR LABIAL FRESA (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.071399+00	\N
1054	2	\N	\N	LABELLO 24HRS PROTECTOR LABIAL HYDROCARE (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1055	2	\N	\N	LABELLO 24HRS PROTECTOR LABIAL ORIGINAL (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1056	2	\N	\N	LACTREX CREMA 60G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1057	2	\N	\N	LACTREX LOCION 125ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1058	2	37	104	LAKESIA 3ML CICLOPIROX (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1059	2	\N	\N	LAMISIL 250MG C/10 TABLETAS (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1060	2	\N	\N	LAMISIL 250MG C/20 TABLETAS (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1061	2	\N	\N	LAMISIL 250MG C/30 TABLETAS (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1062	2	37	122	LAMISIL CREMA 1% 30GR (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1063	2	\N	\N	LAMISIL CREMA 15 GR (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1064	2	\N	\N	LAMISIL SPRAY 30ML (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1065	2	\N	\N	Laritol 10mg c/10 Tabs Loratadina (Maver)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1066	2	\N	\N	LARITOL D 120ML ADULTO LORATADINA, FENILEFRINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1067	2	\N	\N	LARITOL D 120ML INF LORATADINA, FENILEFRINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1068	2	\N	\N	LARITOL EX 120ML LORATADINA, AMBROXOL  (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1069	2	\N	\N	LARITOL EX C/10 TABS LORATADINA/ AMBROXOL (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1070	2	\N	\N	LASIX 40MG C/24 TABS (AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1071	2	\N	\N	LAWAZIN 5MG C/100 TABS GLIBENCLAMIDA (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1072	2	\N	\N	LAXOBERON 30ML GOTAS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1073	2	\N	\N	LAXOBERON C/20 TABLETAS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1074	2	\N	\N	LECHE DE MAGNESIA NORMEX 180ML (PERRIGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1075	2	\N	\N	LECHE DE MAGNESIA NORMEX 360ML (PERRIGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1076	2	\N	\N	LECODER CREMA 20GR 2% MICONAZOL (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1077	2	\N	\N	Lerk 100mg c/4 Comprimidos Sildenafil (Siegfried Rhein)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1078	2	\N	\N	LEVADURA DE CERVEZA C/150 TABS (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1079	2	\N	\N	LEVADURA DE CERVEZA C/250 CAPLETAS (PRONAT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1080	2	\N	\N	LEVETIRACETAM 500MG C/60 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1081	2	\N	\N	LEVITRA 20MG C/1 TAB (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1082	2	\N	\N	Levofloxacino 500mg c/7 Tabletas (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1083	2	\N	\N	LEVOFLOXACINO 500MG C/7 TABS (NEOLPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1084	2	\N	\N	LEVONORGESTREL-ETINILESTRADIOL c/21 tabs (Tempus Pharma)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1085	2	\N	\N	LEVONORGESTREL-ETINILESTRADIOL c/28 tabs (PERRIGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1086	2	\N	\N	Levotiroxina  c/100 TABS. 0.100 MG.	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1087	2	\N	\N	LEXOTAN 6MG C/100 TABS BROMAZEPAM (ROCHE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1088	2	\N	\N	Libertrim 200mg c/24 Comprimidos Trimebutina (Carnot)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1089	2	\N	\N	LIBIOCID 500MG C/ LINCOMICINA (RAYERE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1090	2	\N	\N	LIBIOCID 600MG C/6 AMP LINCOMICINA (RAYERE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1091	2	\N	\N	LIDOCAINA 35GR POMADA (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1092	2	\N	\N	LINAZA PLUS 450GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1093	2	\N	\N	LINCOCIN 100ML JARABE (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1094	2	\N	\N	LINCOCIN 500MG C/16 CAPS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1095	2	20	39	LINCOCIN 600MG/2 ML C/6 AMP (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1096	2	\N	\N	LINCOCIN SOL 300MG/ML INY C/6 AMP (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1097	2	\N	\N	LINCOMICINA 600MG C/6 AMPOLLETAS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1098	2	20	31	LINCOVER 500MG C/16 CAPSULAS LINCOMICINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1099	2	\N	\N	LINCOVER 600MG C/3 LINCOMICINA (MAVER )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1100	2	\N	\N	LIPITOR 40MG C/15 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1101	2	\N	\N	LIQUIDO CA-LLOSOL	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1102	2	\N	\N	LIQUIDO MARAVILLA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1103	2	\N	\N	LISINOPRIL 10MG C/30 TABS (MEDLEY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1104	2	\N	\N	LISINOPRIL 20MG C/100 TABS (PHARMARX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1105	2	\N	\N	LISONIN 500MG C/12 CAPS (SON'S)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1106	2	\N	\N	LISONIN 600 INY C/6 (SON'S)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1107	2	\N	\N	LISONIN C/1 AMP AD (SON'S)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1108	2	\N	\N	LITIWEN 20MG C/100 TABS LISINOPRIL (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1109	2	\N	\N	LOCION ABRAKADABRA PARA LIMPIAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1110	2	\N	\N	LOCION GITANA PARA LIMPIAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1111	2	\N	\N	LOCOID 15GR HIDROCORTISONA 1% (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1112	2	\N	\N	LOMECAN V 20G (GENNOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1113	2	\N	\N	LOMOTIL 2MG C/5 SOBRES (JANSSEN-CILAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1114	2	\N	\N	LOMOTIL C/8 TABLETAS (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1115	2	\N	\N	LONOL 60G CREMA (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1116	2	\N	\N	LOPRESOR 100MG C/10 TABS (SANDOZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1117	2	\N	\N	LORATADINA 10MG C/10 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1118	2	\N	\N	LOROTEC 10MG C/10 (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1119	2	\N	\N	LOSEC A-20 C/14 CÁPSULAS (GENOMMA LABS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1121	2	\N	\N	LOTRIMIN AEROSOL (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1122	2	\N	\N	LOVARIN EX 120ML AMBROXOL/ LORATADINA (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1123	2	\N	\N	LOXCELL C/1 TAB ALBENDAZOL/ QUINFAMIDA (CELLPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1124	2	\N	\N	LOXCELL JUNIOR ALBENDAZOL/ QUINFAMIDA (CELLPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1125	2	\N	\N	LOXCELL PEDIATRICO ALBENDAZOL/ QUINFAMIDA (CELLPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1126	2	\N	\N	LUNARIUM 100/300 MG C/14 CAPS BROMURO DE PINAVERIO-DIMECOTINA  (ITALMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1127	2	\N	\N	LUTORAL - E C/20 TABS 2MG/80MCG (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1128	2	\N	\N	Lydhia Pinckham 500mg c/90 Tabletas (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1129	2	\N	\N	LYRICA 150MG C/14 CAPS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1130	2	\N	\N	LYRICA 300MG C/14 CAPS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1131	2	\N	\N	LYRICA 75MG C/14 CAPS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1132	2	\N	\N	M FORCE C/10 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1133	2	\N	\N	M FORCE C/30 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1134	2	\N	\N	M FORCE C/30 CONDONES (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1135	2	\N	\N	MACA 100% C/60 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1136	2	\N	\N	MACROFURIN 100MG C/40 CAPS NITROFURANTOINA (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1137	2	\N	\N	MADECASSOL  C/12 OVULOS  METRONIDAZOL,CENTELLA ASIATICA,NITROFURAL (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1138	2	\N	\N	MAFENA RETARD 100MG C/20 TABS (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1139	2	82	54	MAGALDRATO/DIMETICONA 10ML GEL C/10 SOBRES (AVIVIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1140	2	\N	\N	MAGNOPYROL 500 MG C/10 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1141	2	\N	\N	MAGNOPYROL 500MG C/50 COMPRIMIDOS (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1142	2	60	\N	MAGSOKON TRIANGULO 26G C/20	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1143	2	60	\N	MAGSOKON TRIANGULO 26G C/50	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1144	2	\N	\N	MALIVAL 25MG C/30 CÁPSULAS (SILANES)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1145	2	\N	\N	MALIVAL AP 50MG C/28 CAPSULAS (SILANES)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1146	2	\N	\N	Malival Compuesto c/32 Caps Metocarbamol/Indometacina (Silanes)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1147	2	87	123	MAMISAN 100GR (PFIZER) P. AMARILLA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1148	2	87	123	MAMISAN 200GR (PFIZER) P. AMARILLA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1149	2	87	123	MAMISAN 200GR (ZOETIS) ORIGINAL	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1150	2	\N	\N	MAMISAN CON DICLOFENACO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1151	2	\N	\N	MAMISAN CON DICLOFENACO GEL	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1152	2	\N	\N	Mamisan Unguento 100gr (Plantimex)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1153	2	\N	\N	Mamisan Unguento 200gr (Plantimex)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:40.754061+00	\N
1154	2	\N	\N	MANGO AFRICANO C/60 TABS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1155	2	\N	\N	MANTECA C/12 KG	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1156	2	\N	\N	MANTECA INCA C/12 KG	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1157	2	88	124	MANZANILLA 15 GOTAS (SOPHIA-GENERICO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1158	2	88	124	MANZANILLA GOTAS 15ML (SOPHIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1159	2	\N	\N	MARIGUANOL BALSAMO (CBD)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1160	2	\N	\N	MARIGUANOL POMADA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1161	2	\N	\N	MASCARILLA ARCILLA BENTONITA 150GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1162	2	\N	\N	MASCARILLA ARCILLA ROSA 100GR (GIZEH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1163	2	\N	\N	MASCARILLA ARCILLA VERDE 100GR (GIZEH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1164	2	\N	\N	Mascarilla de Arcilla 100gr (La Salud es Primero )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1165	2	17	33	MAVIDOL 10MG C/10 TABS KETOROLACO (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1166	2	17	33	MAVIDOL C/3 AMP KETOROLACO (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1167	2	17	33	Mavidol SL 30mg c/4 Tabs Ketorolaco (Mavi)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1168	2	17	33	MAVIDOL TR C/10 TABS KETOROLACO / TRAMADOL (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1169	2	17	33	MAVIDOL TR C/3 AMP KETOROLACO-TRAMADOL (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1170	2	17	33	MAVIDOL TR SUBLINGUAL  C/4 TABS KETOROLACO / TRAMADOL (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1171	2	\N	\N	Maxifort 50mg c/4 Sildenafil (Degorts Chemical)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1172	2	56	34	Maxifort ZIMAX 100mg c/10 Sildenafil (Degorts Chemical)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1173	2	\N	\N	Mazzogran 100mg c/1 Tabs Sildenafil (Collins)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1174	2	\N	\N	Mazzogran 100mg c/10 Tabs Sildenafil  3 Pack (Collins)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1175	2	\N	\N	Mazzogran 100mg c/10 Tabs Sildenafil (Collins)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1176	2	30	\N	Me Vale Madre 500mg c/60 Tabs (Nutri)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1177	2	\N	\N	ME VALE MADRE 60ML (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1178	2	\N	\N	Me Vale Madre c/60 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1179	2	\N	\N	Me Vale Madre Gotas 60ml (Nutri)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1180	2	\N	\N	MECLISON 15ML GOTAS MECLIZINA, PIRIDOXINA (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1181	2	83	104	MEDICASP SHAMPOO 130ML (GENOMMA LABS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1182	2	86	\N	MEDICINA PERCY SUSP 90ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1183	2	\N	\N	MEDIGEN 10MG C/10 TABS KETOROLACO (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1184	2	\N	\N	MEDIGEN 250MG SUSP CEFALEXINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1185	2	\N	\N	MEGA-R 600MG C/30 CAPS (NATURAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1186	2	\N	\N	Mejoral 500 c/12 tabs	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1187	2	\N	\N	MEJORAL 500 EXHIBIDOR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1188	2	\N	\N	MEJORALITO DISPLAY (GSK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1189	2	\N	\N	MEJORALITO JUNIOR 120ML DE 6 A 11 AÑOS (GSK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1190	2	23	22	MEJORALITO PED GOTAS 30ML (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1191	2	23	125	MEJORALITO PEDIATRICO DE 2 A 7 AÑOS C/30 TABS (GSK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1192	2	23	125	MEJORALITO PEDIATRICO SOLUCION 120ML DE 2 A 5 AÑOS (GSK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1193	2	\N	\N	MELADININA 10MG C/30 TABS (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1194	2	\N	\N	MELADININA 30GR POMADA (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1195	2	\N	\N	MELIDEN 100MG C/10 TABS NIMESULIDA (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1196	2	\N	\N	MELLITRON C/80 TABS (JANSSEN CILAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1197	2	\N	\N	Melox Noche AntiReflujo c/10 Sobres (Sanofi-Aventis)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1198	2	13	11	MELOX PLUS  MENTA 360ML ALUMINIO, MAGNESIO, DIMETICONA (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1199	2	13	11	MELOX PLUS C/30 TABLETAS CEREZA (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1200	2	13	11	MELOX PLUS C/50 TABS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1201	2	13	11	Melox Plus c/50 Tabs Menta, Cereza, Lima / Limon (Sanofi-Aventis)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1202	2	13	11	MELOX PLUS CEREZA 360ML ALUMINIO, MAGNESIO, DIMETICONA (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1203	2	\N	\N	MEMOACTIVE  C/90 TABS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1204	2	\N	\N	MEMOACTIVE C/90 (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1205	2	\N	\N	Memorix 1g c/100 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1206	2	\N	\N	MENAZAN CREMA 20 GR MICONAZOL (BIOMEP)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1207	2	\N	\N	MENNEN ACEITE 200ML (PALMOLIVE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1208	2	\N	\N	MENNEN COLONIA 200ML (PALMOLIVE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1209	2	\N	\N	Menopauxil 750mg c/60 Capsulas (Nature's ´P.e.t. )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1210	2	\N	\N	MENOPAZ C/90 CAPS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1211	2	\N	\N	MERTODOL BLANCO 40ML (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1212	2	\N	\N	MERTODOL TINTURA 40ML (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1213	2	\N	\N	MESBRU C/1 AMP Y JERINGA ALGESTONA 150MG + ESTRADIOL 10MG (BRULUART)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1214	2	\N	\N	Mesigyna c/1 Amp 1ml Noretisterona-Estradiol (Bayer)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1215	2	\N	\N	MESSELDAZOL 500MG C/20 TABS METRONIDAZOL (BIOMEP)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1216	2	\N	\N	MESSELDAZOL 500MG C/30 TABS METRONIDAZOL (BIOMEP)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1217	2	\N	\N	MESULID C/10 TABLETAS (ROCHE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1218	2	\N	\N	METICORTEN 20MG C/30 (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1219	2	\N	\N	METICORTEN 50MG C/20 TABS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1220	2	\N	\N	METICORTEN 5MG C/30 TABS (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1221	2	\N	\N	METOCLOPRAMIDA  C/20  TABS. 10 MG. (AVIVIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1222	2	\N	\N	METOCLOPRAMIDA 10MG C/20 TABS (LOEFFLER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1223	2	\N	\N	METOPROLOL 100MG /20 TABS (APOTEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1224	2	\N	\N	METOPROLOL 100MG C/20 (SERRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1225	2	\N	\N	METRIGEN FUERTE INY (ORGANON MEXICANA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1226	2	\N	\N	METRONIDAZOL 500MG C/30 TABS (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1227	2	\N	\N	MEXAPIN  500MG CAPS C/20	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1228	2	\N	\N	MEXAPIN 500MG C/100 CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1229	2	\N	\N	MEXSANA TALCO 160G (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1230	2	\N	\N	MEXSANA TALCO 80G (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1231	2	38	49	MEZELOL 100MG C/100 TABS METOPROLOL (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1232	2	38	49	MEZELOL 50MG C/100 TABS METOPROLOL (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1233	2	\N	\N	MEZELOL 50MG C/20 TABS (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1234	2	\N	\N	MI ARROZ C/10 PIEZAS (KNORR)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1235	2	\N	\N	MICARDIS  40MG C/14 TABS TELMISARTAN  (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1236	2	\N	\N	MICARDIS  80MG c/14 TABS TELMISARTAN (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1237	2	\N	\N	MICARDIS  80MG c/28 TABS TELMISARTAN (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1238	2	\N	\N	MICARDIS PLUS 80MG c/14 TABS TELMISARTAN (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1239	2	\N	\N	MICCIL 1MG C/20 COMPRIMIDOS (IPAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1240	2	\N	\N	MICONAZOL 20G CREMA (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1241	2	89	126	MICOSTATIN BABY 30GR UNGUENTO (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1242	2	89	126	MICOSTATIN C/30 TABLETAS (BRISTOL/MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1243	2	89	126	MICOSTATIN INF GOTAS 10,000,000UI 60ML (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1244	2	89	126	MICOSTATIN SUSPENSIÓN 100,000UI/ML (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1245	2	89	126	MICOSTATIN V CREMA 60GR (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1246	2	\N	\N	MICRODACYN 120ML ANTISEPTICO (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1247	2	90	18	MICROGYNON C/21 TABLETAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1248	2	90	18	MICROGYNON CD C/28 TABLETAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1249	2	\N	\N	MICTASOL C/16 TABS. NORFLOXACINO-FENAZOPIRIDINA  (ASOFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1250	2	\N	\N	MIEL DE AMOR LOCION	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1251	2	\N	\N	MIEL DE AMOR SPRAY	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1252	2	\N	\N	MINOCIN 100MG C/12 TABS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:41.41129+00	\N
1253	2	\N	\N	MIRIAM DIA CREMA 50G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1254	2	\N	\N	MIRIAM NOCHE CREMA 50G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1255	2	23	127	ML-PRIM C/12 CAPS METOCARBAMOL, IBUPROFENO (GELPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1256	2	\N	\N	MOCO DE GORILA 340GR (NATURAL LABS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1257	2	\N	\N	MOCO DE GORILA PUNK 85GR(NATURALABS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1258	2	\N	\N	MOMENTS 50MG C/30 TABS CLORNIFENO (IFA CELTICS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1259	2	\N	\N	MONTELUKAST 10MG C/20 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1260	2	\N	\N	Moringa Complex 500mg c/30 Capsulas (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1261	2	\N	\N	MORINGA OLEIFERA C/90 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1262	2	\N	\N	MOTRIN 800MG C/45 GRAGEAS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1263	2	\N	\N	MOTRIN INF 120ML FRUTAS (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1264	2	\N	\N	MOTRIN PEDIATRICO 15ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1266	2	19	38	MUCOANGIN GROSELLA  20MG C/18 PASTILLAS AMBROXOL (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1267	2	19	38	MUCOANGIN LIMON 20MG C/18 PASTILLAS AMBROXOL (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1268	2	19	38	MUCOANGIN MENTA 20MG C/18 PASTILLAS AMBROXOL (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1269	2	19	41	MUCOFLUX 120ML  SALBUTAMOL/AMBROXOL (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1270	2	19	38	MUCOSOLVAN C/10 AMP (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1271	2	19	38	MUCOSOLVAN C/20 PASTILLAS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1272	2	19	38	MUCOSOLVAN COMPUESTO 120ML (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1273	2	19	41	MUCOVIBROL C 120ML (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1274	2	19	41	MUCOVIBROL C GOTAS 20ML (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1275	2	19	41	MUCOVIBROL C/20 COMPRIMIDOS (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1276	2	\N	\N	MUEGANOS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1277	2	\N	\N	MUICOSOLVAN RETARD 24HRS C/10 TABLETAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1278	2	\N	\N	MUITO CXO LADY 400ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1279	2	\N	\N	MUITO CXO MEN 400ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1280	2	\N	\N	MULTIVITAMINAS EFERVECENTES INFANTIL (SELTZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1281	2	\N	\N	MULTIVITAMINICO MULTIMINERAL C/30 CAPS (PHARMA LIFE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1282	2	\N	\N	MUSTELA CREMA CONTRA LAS ROSADURAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1283	2	\N	\N	MYFUNGAR 20GR CREMA (ITALMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1284	2	\N	\N	MYRYAM CREMA 15G (PLANTIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1285	2	37	\N	NAILEX 15ML DESENTERRADOR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1286	2	37	\N	NAILEX 15ML UNA AMARILLA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1287	2	\N	\N	NALIXONE 500MG C/20 TABS ACIDO NALIDIXICO/FENAZOPIRIDINA (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1288	2	\N	\N	NARTEX ALCOHOLISMO C/9 PASTILLAS (NARTEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1289	2	\N	\N	NASALUB ADULTO SOLUCION 30ML (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1290	2	\N	\N	NASALUB INFANTIL SOLUCION 30ML (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1291	2	\N	\N	Nasalub Max 100ml (Genomalab)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1292	2	\N	\N	NATRAZIM 40MG C/28 TABS TELMISARTAN (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1293	2	\N	\N	NAXEN 250MG C/45 TABS (SYNTEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1294	2	\N	\N	NAZIL 15ML (SOPHIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1295	2	\N	\N	NEBIDO 1000MG INY TETOSTERONA (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1296	2	\N	\N	NEBIVOLOL 5MG C/14TABS (CAMBER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1297	2	\N	\N	NEMORIL 40MG C/30 CAPS GINKO BILOBA (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1298	2	91	116	NENEDENT 10G GEL (NYCOMED)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1299	2	\N	\N	Neo Omega 3 Salmon + Q c/100 Caps (Anahuac)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1300	2	\N	\N	Neo Omega 3 Salmon c/100 Caps (Anahuac)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1301	2	72	18	NEOGYNON C/21 TABS LEVONORGESTREL/ETINILESTRADIOL (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1302	2	\N	\N	NEOMELUBRINA 500MG GOTAS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1303	2	23	11	NEO-MELUBRINA C/5 AMP (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1304	2	23	11	NEO-MELUBRINA C/5 SUPOSITORIOS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1305	2	23	11	NEO-MELUBRINA JBE INF 100ML (SANOFI AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1306	2	23	11	NEO-MELUBRINA TABS 500MG C/10 TAB METAMIZOL SODICO (SANOFI AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1307	2	\N	\N	NERVICALM C/90 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1308	2	72	58	NESAJAR C/16 CAPS  PINAVERIO / DIMETICONA  (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1309	2	\N	\N	NEURALIN SOL INY (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1310	2	23	106	NEUROBION C/30 TABS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1311	2	\N	\N	NEUROBION C/60 TABS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1312	2	23	106	NEUROBION DC 10MG C/3 AMP (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1313	2	23	106	NEUROBION DC 10MG C/5 AMP (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1314	2	23	11	Neuroflax 20mg/4mg Iny c/1 Frasco (Sanofi)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1315	2	23	11	Neuroflax 20mg/4mg Iny c/3 Frascos (Sanofi)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1316	2	23	39	Neurontin 300mg c/30 Caps Gabapentina (Pfizer)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1317	2	12	128	NEUROTROPAS-DB C/10. VIALES 15ML MULTIVITAMINICO (LAB DB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1318	2	\N	\N	NIKSON C/40 TABS (GENOMMA LAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1319	2	76	129	NIKSON C/90 TABS (GENOMMA LAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1320	2	\N	\N	NIMESULIDA 100MG C/10 TABLETAS (PHARMA RX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1321	2	\N	\N	NIMOTOP INYECTABLE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1322	2	75	102	NISTATINA 24ML 2,400,000 U (PERRIGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1323	2	\N	\N	NIVEA CREMA 100ML (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1324	2	\N	\N	NIVEA CREMA 200ML (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1325	2	\N	\N	NIVEA CREMA 400ML + 100ML (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1326	2	\N	\N	NIVEA CREMA 50ML (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1327	2	\N	\N	NIVEA CREMA 50ML TARRO (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1328	2	\N	\N	NIVEA CREMA DISPENSER C/24 LATITAS 20G (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1329	2	\N	\N	NIVEA DESODORANTE ACLARADO CLASSIC TOUCH SPRAY (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1330	2	\N	\N	NIVEA DESODORANTE ACLARADO NATURAL BEAUTY TOUCH SPRAY (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1331	2	\N	\N	NIVEA DESODORANTE ROLL-ON (BEIERSDORF)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1332	2	75	130	NIZORAL 200MG C/10 TABS (JANSSEN-CILAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1333	2	75	130	NIZORAL 200MG C/20 TABS (JANSSEN-CILAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1334	2	75	108	NIZORAL CREMA 40GR (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1335	2	\N	\N	NO + KOLICOS C/90 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1336	2	\N	\N	NOGASLAN 40MG C/28 TABS PANTOPRAZOL (LANDSTEINER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1337	2	\N	\N	NOGRAINE 100MG C/5 TABS (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1338	2	\N	\N	NOGRAINE 50MG C/8 TABS SUMATRIPTAN (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1339	2	\N	\N	NOPAL 7 DE POTENCIAS C/150 CAPS (PLANTIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1340	2	\N	\N	Nopal Sabila 450mg c/150 Capsulas (La Salud es Primero )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1341	2	\N	\N	NOPIKEX REPELENTE SPRAY	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1342	2	\N	\N	NO-PIO-JIN 125ml Shampoo	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1343	2	\N	\N	NO-PIO-JIN GEL REPELENTE DE PIOJOS 500GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1344	2	\N	\N	NO-PIO-JIN SHAMPOO 125ML CON PEINE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1345	2	\N	\N	NORAPRED 50MG C/20 TABS PREDNISONA (BRULUART)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1346	2	20	39	NORDET C/21 TABLETAS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1347	2	23	61	NORDINET ADULTO C/20 TABS (NORDIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1348	2	\N	\N	NOREX 50MG C/30 TABS ANFEPRAMONA (IFA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1349	2	\N	\N	NORISTERAT 200MG C/1 AMP NORETISTERONA (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1350	2	\N	\N	NOSIPREN 20MG c/100 TABS PREDNISONA (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1351	2	15	12	NOSIPREN 20MG c/30 TABS PREDNISONA (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.250056+00	\N
1352	2	\N	\N	Nucleo C.M.P. Forte 5mg /3mg c/30 Caps (Ferrer)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1353	2	\N	\N	NURO-B C/10 TABLETAS (RIMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1354	2	\N	\N	NUTRIDERM CREMA TEPEZCOUITE 60GR (NUTRIDERM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1355	2	75	27	NYSMOSONS-V C/10 OVULOS METRODINAZOL, NISTATINA, FLUOCINOLONA (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1356	2	\N	\N	OBAO ANGEL 24HR (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1357	2	\N	\N	OBAO AZUL MORADO OCEANIC 48HRS 65G HOMBRE (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1358	2	\N	\N	OBAO BAMBOO 150ML SPRAY (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1359	2	\N	\N	OBAO FRESCURA FLORAL 65G (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1360	2	\N	\N	OBAO FRESCURA POWDER 65G (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1361	2	\N	\N	OBAO FRESCURA SUAVE 65GR (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1362	2	\N	\N	OBAO FRESQUISIMA 65G (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1363	2	\N	\N	OBAO FRESQUISSIMA 150ML SPRAY (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1364	2	\N	\N	OBAO MAN NEGRO 65GR (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1365	2	\N	\N	OBAO MEN CLASSIC 24H (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1366	2	\N	\N	OBAO NARANJA FRESCURA INTENSA 65G (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1367	2	\N	\N	OBAO PIEL DELICADA 150ML SPRAY (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1368	2	\N	\N	OBAO PIEL DELICADA 65GR (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1369	2	\N	\N	OBAO POWDER 65GR (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1370	2	\N	\N	OBAO SEDA 65GR (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1371	2	\N	\N	OBAO SENSITIVE AZUL CIELO (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1372	2	\N	\N	OBAO SENSITIVE SEDA 65G (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1373	2	\N	\N	OBAO SUAVE 65GR (GARNIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1374	2	\N	\N	OBECLOX  30MG C/60 CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1375	2	\N	\N	O-Dolex 150g Talco (Avant)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1376	2	\N	\N	O-DOLEX 300 GR Talco (Avant)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1377	2	\N	\N	OJO ROJO 5ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1378	2	\N	\N	Omega 3 c/90 Tabs (Sandy)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1379	2	\N	\N	OMEOPRAZOL 20MG C/60 CAPS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1380	2	\N	\N	OMIFIN 50MG C/30 TABS (AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1381	2	\N	\N	ONCOLIVE C/90 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1382	2	\N	\N	ONCOLIVE C/90 TABS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1383	2	\N	\N	ONOTON C/20 TABS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1384	2	\N	\N	ONOTON C/50 TABS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1385	2	\N	\N	OPTICAL DEVLYN EQ GOTAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1386	2	\N	\N	ORDEGAN C/10 TABS KETOROLACO/ TRAMADOL (RAAM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1387	2	\N	\N	OREGANO C/60 CAPSULAS (ANAHUAC)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1388	2	\N	\N	ORTIGA + AJO REY AZUL C/60 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1389	2	\N	\N	ORTIGA + AJO REY VERDE C/60 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1390	2	\N	\N	ORTIGA C/30 TABS (BOTANICA SANTIAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1391	2	20	27	ORTORA SOL GOTAS 20ML NEOMICINA, LIDOCAINA (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1392	2	\N	\N	OSAKO 15ML SPRAY PROPOLEO Y EUCALIPTO (OSAKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1393	2	\N	\N	OSIDEA GL C/1 SOBRES 100MG SILDENAFIL GEL ORAL (AVIVIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1394	2	\N	\N	OSIDEA GL C/4 SOBRES 100MG SILDENAFIL GEL ORAL (AVIVIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1395	2	20	12	OTILIN SOL GOTAS 20ML NEOMICINA, LIDOCAINA (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1396	2	\N	\N	OTO ENI 10ML CIPROFLOXACINO, HIDROCORTISONA Y LIDOCAINA (GROOSMAN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1397	2	20	131	OTOLONE 5ML GOTAS SOL (LOREN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1398	2	\N	\N	OXITAL-C FORTE C/10 TABS EFERVECENTES  SABOR NARANJA (SERRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1399	2	\N	\N	OXYGRICOL C/12 TABS (RIMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1400	2	\N	\N	PALADAC'S 150ML SUSP (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1401	2	\N	\N	PALMOLIVE BRILLANTINA 199ML (PALMOLIVE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1402	2	\N	\N	PALMOLIVE BRILLANTINA 99ML (PALMOLIVE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1403	2	\N	\N	PALSIN STRESS 500MG C/24 CAPS (MEDICAMENTOS NATURALES)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1404	2	\N	\N	PANCLASA C/20 CÁPSULAS  floroglucinol trimetilfloroglucinol  (ATLANTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1405	2	\N	\N	PANCLASA C/5 AMP 2ML INY (ATLANTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1406	2	\N	\N	PANCLASA GOTAS CÓLICO INF 30ML (ATLANTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1407	2	\N	\N	PANGAVIT PEDIATRICO 120ML (CHURCH AND DWIGHT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1408	2	\N	\N	PANGAVIT TAB (CHURCH AND DWIGHT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1409	2	19	44	PANOTO-S 100ML  HEDERA HELIX (SIEGFRIED-RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1481	2	\N	\N	POMADA AZUFRE 100G (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1410	2	\N	\N	PANTOPRAZOL 20MG C/7 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1411	2	\N	\N	Pantoprazol c/30 Caps	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1412	2	\N	\N	Pantozol 40mg c/7 Tabs Pantoprazol (Nycomed)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1413	2	\N	\N	PARAMIX 500MG C/6 GRAGEAS NITAZOXANIDA (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1414	2	92	50	PAROXETINA 20MG  C/20 TABS (PSICOFARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1415	2	\N	\N	PAROXETINA 20MG C/10 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1416	2	\N	\N	PAROXETINA 20MG C/10 TABS (AVIVIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1417	2	\N	\N	PAROXETINA 20MG C/10 TABS (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1418	2	\N	\N	PAROXETINA 20MG c/10 TABS. (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1419	2	\N	\N	PASMODIL C/1 AMP Butilhioscina ó Hioscina+Paracetamo (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1420	2	\N	\N	PASMODIL DUO C/24 TABS Butilhioscina ó Hioscina+Paracetamo (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1421	2	\N	\N	PASTA COLGATE 50ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1422	2	93	101	PASTA DE LASSAR OXIDO DE ZINC 145GR (COYOACAN QUIMICA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1423	2	93	101	PASTA LASSAR 110 GR (COYOACAN QUIMICA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1424	2	93	101	Pasta Lassar 50g Oxido de Zinc (Coyoacan Quimica)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1425	2	72	66	PATECTOR ROSA C/1 AMP (CARNOT LABORATORIOS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1426	2	\N	\N	PEBANIC 200MG C/100 TABS CARBAMAZEPINA (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1427	2	\N	\N	PEDIALYTE 500ML CEREZA C/12 (ABBOTT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1428	2	\N	\N	PEDIALYTE 500ML COCO C/12 (ABBOTT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1429	2	\N	\N	PEDIALYTE 500ML DURAZNO C/12 (ABBOTT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1430	2	\N	\N	PEDIALYTE 500ML MANZANA C/12 (ABBOTT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1431	2	\N	\N	Peine Saca Piojos de Acero (Gadiz)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1432	2	\N	\N	PEINES PARA PIOJOS GRANDE C/12 (PREMIER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1433	2	\N	\N	PENSIRAL 400MG C/30 CAPS (SERRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1434	2	\N	\N	PENTOXIFILINA 400MG C/30 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1435	2	\N	\N	PENTREXCILINA 72PZ C/2TABS (BIOQUIMICA MEED)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1436	2	\N	\N	PENTREXCILINA 9.4GR (RRX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1437	2	\N	\N	PENTREXCILINA NF INF CEREZA 237ML (BIOQUIMICA MEED	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1438	2	\N	\N	PENTREXYL 100MG GOTAS (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1439	2	\N	\N	PENTREXYL 125MG SUSP (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1440	2	\N	\N	PENTREXYL 250MG C/3 AMP  (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1441	2	\N	\N	PENTREXYL 250MG/5ML SUSP (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1442	2	\N	\N	PENTREXYLIN 500 C/30 CAPS (BIOQUIMICA MEED)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1443	2	\N	\N	PEPTIMAX C/12 TABLETAS (COLUMBIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1444	2	94	132	PEPTO-BISMOL 118ML SUSP (PROCTER & GAMBLE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1445	2	94	132	PEPTO-BISMOL C/100 TABS (PROCTER & GAMBLE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1446	2	94	132	PEPTO-BISMOL SUSP 236ML (PROCTER & GAMBLE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1447	2	94	132	PEPTO-BISMOL TIRA C/24 TABS (PROCTER & GAMBLE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1448	2	\N	\N	PERIOSAN 100MG C/10 CAPS DOXICICILINA (VITAE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1449	2	94	133	PERLAS DE ETER C/3 C/50 BOLSITAS  (sanax)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1450	2	94	134	PERLAS DE ETER C/50 (LA FLOR)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1451	2	\N	\N	Perlas de Higado de Tiburon c/90 Tabletas (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:42.979666+00	\N
1452	2	72	12	PERLUDIL C/1 AMP ALGESTONA/ ESTRADIUOL (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1453	2	72	38	PERLUTAL C/1 AMP (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1454	2	\N	\N	PHARBEN 100MG C/20 CAPS BENZONATATO (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1455	2	91	135	PHARMACAINE SPRAY 115ML LIDOCAINA (QUIMPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1456	2	12	38	PHARMATON C/100 CAPS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1457	2	12	38	PHARMATON C/30 CAPS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1458	2	\N	\N	PHARMATON COMPLEX C/100 CAPS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1459	2	\N	\N	PHARMATON MATRUELLE C/60 CAPS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1460	2	\N	\N	PHARSENG C/30 CAPS PANAX GISENG (PHARMA GEL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1461	2	\N	\N	PICOSEND 11ML SOL (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1462	2	\N	\N	Piel Sana Jabon	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1463	2	\N	\N	PINTURA DE ROPA COLOR AZUL	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1464	2	\N	\N	PINTURA DE ROPA COLOR NEGRO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1465	2	\N	\N	PIREMOL 300MG C/3 SUP (LOEFFLER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1466	2	\N	\N	PIRIMIR 100MG C/24 TABS (MEDLEY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1467	2	17	29	Piroxicam 20mg c/20 Tabs (Ultra)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1468	2	91	62	PISACAINA 115ML ATOMIZADOR LIDOCAINA (PISA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1469	2	91	62	PISACAINA 2% FRASCO 20MG/50ML LIDOCAINA (PISA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1470	2	\N	\N	PLANEX C/30 CAPS (RIMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1471	2	\N	\N	PLANTILLAS HONGOSAN	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1472	2	\N	\N	PLAQUENIL 200MG HIDROXICLOROQUINA (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1473	2	\N	\N	PLASIL ENZIMATICO C/30 GRAGEAS (MEDLEY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1474	2	95	97	PODOFILIA #2 BUSTILLOS 5ML (BUSTILLOS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1475	2	\N	\N	POINTTS VERRUGAS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1476	2	\N	\N	POLI-VI-SOL PEDIATRICO (SIEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1477	2	\N	\N	Polvos de Juanes 7g c/50 Sobres (Crystal)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1478	2	\N	\N	POMADA 7 FLORES 120GR (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1479	2	\N	\N	POMADA AJO 125GR  (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1480	2	\N	\N	POMADA ALCANFOR 100G (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1482	2	\N	\N	POMADA BELLADONA 100GR (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1483	2	\N	\N	POMADA BLANCAVIT 120GR (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1484	2	\N	\N	POMADA CALENDULA CON TEPEZCOUITE 120GR (ECO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1485	2	\N	\N	POMADA CAMPANA TEPEZCOHUITE 35G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1486	2	\N	\N	POMADA CEBO DE COYOTE 100G (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1487	2	\N	\N	POMADA DE AZUFRE 125GR (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1488	2	\N	\N	Pomada de la Abuela 125gr	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1489	2	\N	\N	POMADA DE MAMEY 125GR (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1490	2	\N	\N	POMADA DE MANZANA (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1491	2	\N	\N	POMADA DE OXIDO DE ZINC 50GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1492	2	\N	\N	POMADA DE PEYOTE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1493	2	\N	\N	POMADA DE SAVILA 50GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1494	2	\N	\N	POMADA DE VENENO DE ABEJA 100GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1495	2	\N	\N	POMADA DEL TIGRE 100G (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1496	2	\N	\N	POMADA DISPAN DOBLE 40MG	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1497	2	\N	\N	POMADA DRAGON 19G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1498	2	\N	\N	POMADA LA CAMPANA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1499	2	\N	\N	POMADA MILAGROSA 100G (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1500	2	\N	\N	POMADA NATURAL NUTRISAN	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1501	2	\N	\N	POMADA PAN PUERCO 50GR (GISEL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1502	2	\N	\N	POMADA QUERATOLITICA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1503	2	\N	\N	POMADA TEPEZCOHUITE 100G (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1504	2	\N	\N	POMADA TEPEZCOUITE 125GR (ARBOL VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1505	2	\N	\N	POMADA VENENO ABEJA C/ VIBORA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1506	2	\N	\N	POMADA ZORRILLO 100G (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1507	2	\N	\N	POMDA DE AJOLOTE CON ACEITE DE SABILA 125GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1508	2	\N	\N	POND'S CLARANT B3 100G PIEL NORMAL A SECA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1509	2	\N	\N	POND'S CLARANT B3 200G PIEL NORMAL A SECA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1510	2	\N	\N	POND'S CLARANT B3 400G PIEL NORMAL A SECA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1511	2	\N	\N	POPRAM 40MG /14 TABS PANTOPRAZOL (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1512	2	\N	\N	POROXALIN	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1513	2	\N	\N	POSIPEN 500MG C/12 CAPS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1514	2	72	136	POSTDAY C/2 COMPRIMIDOS 0.75G (INV FARMACÉUTICAS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1515	2	\N	\N	POSTINOR UNIDOSIS C/1 TAB (GEDEON RICHTER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1516	2	\N	\N	PRAMIGEL C/10 TABS (CARNOT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1517	2	\N	\N	PRAMIGEL C/20 TABS (CARNOT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1518	2	96	31	PRASIVER 10MG C/15 TABS PRAVASTATINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1519	2	\N	\N	PRAVASTATINA 10MG C/15 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1520	2	\N	\N	PREBIOS PRUEBA DE EMBARAZO C/10	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1521	2	\N	\N	PREMARIN C/28 TABLETAS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1522	2	\N	\N	PREMARIN C/42 TABLETAS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1523	2	\N	\N	PREPARATION H UNGUENTO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1524	2	\N	\N	PRESISTIN 10MG C/30 TABS CISAPRIDA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1525	2	\N	\N	PRIMAZEN 10MG C/100 TABS ENALAPRIL (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1526	2	38	49	PRIMAZEN 20MG C/100 TABS ENALAPRIL (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1527	2	\N	\N	PRIMAZEN 5MG C/100 TABS ENALAPRIL (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1528	2	97	18	PRIMOTESTON DEPOT 250MG C/1 AMP TESTOSTERONA (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1529	2	\N	\N	PRINDEX NEO PEDIATRICO 15ML (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1530	2	\N	\N	PROCTOACID 100MG C/5 SUPOSITORIOS (NYCOMED)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1531	2	\N	\N	PROCTOACID 50GR (TAKEDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1532	2	\N	\N	PROCTO-GLYVENOL 30GR (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1533	2	\N	\N	PROCTO-GLYVENOL C/5 SUPOSITORIOS 400MG-40MG (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1534	2	\N	\N	PRODOLINA 500MG C/10 TABLETAS (PROMECO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1535	2	\N	\N	PRODOLINA C/3 AMP (PROMECO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1536	2	12	137	PROGYL 30 VITAMINA A,C Y D MIEL, PROPOLEEO Y GORDOLOBO (PNS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1537	2	\N	\N	PROGYLUTON  C/21 GRAGEAS ESTRADIOL-NOGESTREL (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1538	2	\N	\N	PRONTOL 100MG C/20 TABS METOPROLOL  (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1539	2	\N	\N	PROPANOLOL 80MG C/100 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1540	2	\N	\N	PROSGUTT C/40 CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1541	2	\N	\N	PROSTABEN C/90 TABS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1542	2	\N	\N	PROVERA 10MG C/10 MEDROXIPROGESTERONA  (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1543	2	\N	\N	PROVERA MEDROXIPROGESTERONA  5MG c/24 TAB (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1544	2	\N	\N	PROVIRON 250MG C/10 TABS (bayer)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1545	2	\N	\N	PTX 500 C/30 CAPS(NORDIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1546	2	\N	\N	Pulmo Calcio 180ml (L. Lopez)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1547	2	33	138	PULMO CALCIO ANTIGRIPAL EXHIBIDOR C/100 TABS (L. LOPEZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1548	2	33	138	PULMO CALCIO FRESA EXHIBIDOR C/200 CARAMELOS (L. LOPEZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1549	2	\N	\N	PULMOGRIP 120ML JARABE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1550	2	\N	\N	PULMONAROM 3ML C/20 AMP (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1551	2	\N	\N	PULMONARUM C/10 AMP LISADOS BACTERIANOS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:43.716223+00	\N
1552	2	\N	\N	QG5 C/10 TABLETAS (GENOMMA LAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1553	2	98	129	QG5 C/30 TABLETAS (GENOMMA LAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1554	2	72	18	QLAIRA C/28 TABLETAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1555	2	\N	\N	QUADRIDERM NF 15GR (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1556	2	\N	\N	QUIMARA 3G CREMA 5% (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1557	2	\N	\N	Quita Dolor Gel 200ml  (C.B. Marylu)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1558	2	30	35	RABANO YODADO 340MML (PROSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1559	2	\N	139	RANISEN 150MG 1+1 C/20 TABS (SENOSIAIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1560	2	\N	\N	RANISEN 150MG C/60 TABS TABS (SENOSIAIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1561	2	\N	\N	RANISEN 300MG 1+1 C/10 TABS (SENOSIAIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1562	2	\N	\N	RANITIDINA 150MG C/100 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1563	2	13	13	RANITIDINA 300MG C/10 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1564	2	\N	\N	RANITIDINA 50MG/2ML INYECATBLE (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1565	2	\N	\N	RANTUDIL 60MG C/14 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1566	2	\N	\N	Recoveron-C 40 (Armstrong)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1567	2	\N	\N	RECOVERÓN-N 40GR (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1568	2	\N	\N	RECTANYL 0.05% 30GR CREMA (GALDERMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1569	2	\N	\N	REDAFLAM 100MG C/10 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1570	2	\N	\N	Redalip 200mg c/30 Tabs Bezafibrato (Maver)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1571	2	19	62	REDDY 120ML ADULTO AMBROXOL/DEXTROMETORFANO (PISA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1572	2	11	140	REDOTEX C/30 TABS (DIALICELS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1573	2	\N	\N	REDOXON 1G SOL INY 10ML (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1574	2	\N	\N	REDOXON 1GR  NARANJA C/10 TABS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1575	2	\N	\N	REGENESIS MAX OMEGA 3 C/30 TABS (DHA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1576	2	42	8	RELIVIUM 100MG c/60 + 60 TABS TRAMADOL (SBL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1577	2	\N	\N	RENALIP C/90  TABS 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1578	2	\N	\N	REPELENTE DE INSECTOS 60ML (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1579	2	\N	\N	RESFRIOLI-TO BB RUB 50GR (RRX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1580	2	\N	\N	RESFRIOL-ITO CHILDRENS 118ML (RRX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1581	2	20	139	RESPICIL ADULTO INY (SENOSIAIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1582	2	\N	\N	RETARDIN LOCION 15ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1583	2	\N	\N	RETIN-A 0.05% 40G (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1584	2	\N	\N	RETOFLAM  15MG C/10 TABS MELOXICAM  (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1585	2	\N	\N	Reumadol Balsamo 125g	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1586	2	\N	\N	REUMATOLUM 60 GRS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1587	2	\N	\N	Reumofan Plus Verde C/30 Tabs (Riger Naturals)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1588	2	\N	\N	REUMOPHAN C/20 TABS (GRISI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1589	2	\N	\N	REVITRON PLEX C/30 CAPS GINKO BILOBA, PANAX GINSENG (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1590	2	\N	\N	REXONA DESODORANTE SPRAY	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1591	2	\N	\N	R-Flex c/30 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1592	2	\N	\N	R-GAST 500MG C/30 TABS (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1593	2	\N	\N	RICITOS DE ORO SHAMPOO 100ML (GRIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1594	2	\N	\N	Rimel Aguacate Organico (Hollywood)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1595	2	\N	\N	Rimel Alargador (Hollywood)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1596	2	\N	\N	RIMEL ALARGADOR 13GR TAPA AZUL (BQ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1597	2	\N	\N	Rimel Argan Oro Liquido (Hollywood)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1598	2	\N	\N	RIMEL BLACK NIGHT 13GR (BQ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1599	2	\N	\N	Rimel Definidas (Hollywood)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1600	2	\N	\N	RIMEL ENGROSADOR 13GR (BQ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1601	2	\N	\N	RIMEL EXTENCION 13GR (BQ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1602	2	\N	\N	Rimel Extra Largas (Hollywood)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1603	2	\N	\N	Rimel Extra Volumen (Hollywood)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1604	2	\N	\N	RIMEL HENNA 13GR (BQ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1605	2	\N	\N	RIMEL MAKE UP PINK 13GR (BQ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1606	2	\N	\N	Rimel Mamey Organico (Hollywood)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1607	2	\N	\N	RIMEL TE VERDE 13GR (BQ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1608	2	\N	\N	Rimel Volumen Alargador (Hollywood)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1609	2	\N	\N	Riñobien 1g c/90 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1610	2	13	116	RIOPAN 10ML C/10 SOBRES  (NYCOMED)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1611	2	13	116	RIOPAN ANTIACIDO C/24 TABS (NYCOMED)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1612	2	13	117	RIOPAN GEL ANTIACIDO 250ML (TAKEDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1613	2	75	25	RIXTAL 100MG C/15 TABS ITRACONAZOL (NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1614	2	\N	\N	RM FLEX 850MG C/30 CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1615	2	23	39	ROBAX GOLD C/24 TABS 500MG/200MG METOCARBAMOL/ IBUPROFENO (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1616	2	\N	\N	ROCAINOL BALSAMO 45G (CIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1617	2	\N	\N	ROCAVIT C/30 CAPS MULTI VITAMINAS (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1618	2	\N	\N	Rosa Mosqueta Crema 120g	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1619	2	\N	\N	ROTUMAL 25MG C/30 CAPS DICLOFENACO (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1620	2	\N	\N	R-Press c/Chia 500mg c/30 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1621	2	\N	\N	RUMOQUIN N.F C/90 TABS (MARCEL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1622	2	\N	\N	RUMOQUIN NF C/10 TABS (SCHOEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1623	2	\N	\N	RUMOQUIN NF C/20 TABS (SCHOEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1624	2	\N	\N	RUVOLSY 12MG C/30 CAPS CASSIA ANGUSTIFOLIA (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1625	2	\N	\N	Sabila 400mg c/150 (La Salud es Primero)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1626	2	\N	\N	SabiNopal 500mg c/150 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1627	2	\N	\N	SADOCIN 120ML JARABE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1628	2	\N	\N	Sahumerio Azteca (Productos Trebol)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1629	2	38	141	SAL DE UVAS PICOT C/10 SOBRES (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1630	2	\N	\N	SAL DE UVAS PICOT C/12 SOBRES (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1631	2	\N	\N	SAL DE UVAS PICOT C/50 SOBRES (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1632	2	\N	\N	SALBUTAMOL AEROSOL C/1 5 MG  (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1633	2	\N	\N	SALBUTAMOL AEROSOL C/200 DOSIS  (BRESALTEC)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1634	2	55	49	SALBUTAMOL AEROSOL C/200 DOSIS (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1635	2	\N	\N	SALOFALK 500MG C/4	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1636	2	\N	\N	SALSA LA PERRONA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1637	2	\N	\N	SALUFILA SOL 500ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1638	2	\N	\N	SANBORNS COLONIA 115ML (GENNOMA LAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1639	2	\N	\N	SANGRE DE VENADO PREPARADA  (ESOTERICO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1640	2	\N	\N	Sanzadoll duo 37.5/325 mg c/20 Tabs	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1641	2	\N	\N	SARIDON 500MG C/100 COMPRIMIDOS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1642	2	23	18	SARIDON 500MG C/20 COMPRIMIDOS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1643	2	\N	\N	SAVILE CREMA ACEITE DE ARGAN RIZO 300ML C/2	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1644	2	\N	\N	SAVILE CREMA CHILE RIZO 300ML C/2	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1645	2	\N	\N	SAVILE SHAMPOO ACEITE DE ARGAN 750ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1646	2	\N	\N	SAVILE SHAMPOO AGUACATE 750ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1647	2	\N	\N	SAVILE SHAMPOO KERATINA 750ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1648	2	\N	\N	SAVILE SHAMPOO SABILA/MIEL 750ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1649	2	\N	\N	SBELTA C/90 TABS 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1650	2	\N	\N	SbeltNat 850mg c/90 Capsulas (Nature's ´P.e.t. )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1651	2	99	15	SCABISAN 60G CREMA PERMETRINA (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:44.466511+00	\N
1652	2	\N	\N	Scabisan Emulsion 120ml Permetrina (Chinoin)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1653	2	\N	\N	Sebryl Shampoo 150ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1654	2	\N	\N	SEDALMERCK C/20 TABS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1655	2	23	106	SEDALMERCK C/40 TABS NUEVA IMAGEN (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1656	2	23	106	SEDALMERCK EXHIBIDOR C/200 TABS (MERK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1657	2	\N	\N	SEDALMERCK MAX C/24 TABLETAS (MERCK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1658	2	\N	\N	SEDANTREX VAL C/60 CAPS (VIDA HERBAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1659	2	72	142	SEGFEMIOL c/21 TABS. 0.15/0.03 MG.(FARMA HISPANO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1660	2	72	142	SEGFEMIOL c/28 TABS. 0.15/0.03 MG.(FARMA HISPANO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1661	2	\N	\N	SELECTIVE 10MG C/14	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1662	2	\N	\N	SELOKEN ZOK 95MG C/20 TABS (AZTRA ZENECA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1663	2	\N	\N	SEMILLA DE BRASIL C/10 FRASCOS 15ML C/U	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1664	2	\N	\N	SENOKOT 15MG C/18 TAB (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1665	2	\N	\N	SENOKOT F 17.2MG C/30 TABLETAS (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1666	2	52	139	SENOSIAIN ADULTO C/10 SUPOSITORIOS (SENOSIAIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1667	2	52	139	SENOSIAIN BEBE C/10 SUPOSITORIOS (SENOSIAIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1668	2	52	139	SENOSIAIN INFANTIL C/10 SUPOSITORIOS (SENOSIAIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1669	2	\N	\N	SENSIBIT ALERGIAS 10MG C/10 TABS (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1670	2	33	41	Sensibit D c/12 Tabs Loratadina, Fenilefrina, Paracetamol (Liomont)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1671	2	33	41	Sensibit D Pediatrico 120ml Fenilefrina, Loratadina, Paracetamol (Liomont)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1672	2	\N	\N	SENSIBIT INF 5MG C/10 TABS LORATADINA (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1673	2	\N	\N	SEPIBEST 200MG C/20 TABS CARBAMAZEPINA (BEST)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1674	2	\N	\N	SERRACAL 500MG C/12 TABS (SERRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1675	2	\N	\N	SERTRALINA 50MG C/14 TABS (TEMPUSPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1676	2	\N	\N	SEXTASIS HOMBRE C/60 TABS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1677	2	\N	\N	SEXTASIS MUJER C/60 TABS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1678	2	\N	\N	SHAMPOO A BASE DE SAVILA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1679	2	\N	\N	SHAMPOO ACEITE DE OSO (GIZEH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1680	2	\N	\N	SHAMPOO ALMENDRAS OLIVO Y RICINO 550ML(INDIO P)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1681	2	\N	\N	SHAMPOO ARGAN DE MARRUECOS 550ML (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1682	2	\N	\N	Shampoo Bergamota 500ml (Aucar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1683	2	\N	\N	SHAMPOO CABALLO 1.1.L (VIDARELA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1684	2	\N	\N	SHAMPOO CABALLO 550ML (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1685	2	\N	\N	SHAMPOO CHILE (MEGAMIX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1686	2	\N	\N	SHAMPOO COLA DE CABALLO 1.1 L (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1687	2	\N	\N	SHAMPOO CON AC.DE JOJOBA 240ML (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1688	2	\N	\N	SHAMPOO CRE-C FEM 3 PIEZAS 250ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1689	2	\N	\N	SHAMPOO CRE-C MAX 1 PIEZA 250ML + 1 PIEZA TRATAMIENTO NOCTURNO GEL 150G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1690	2	\N	\N	SHAMPOO CRE-C MAX 3 PIEZAS 250ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1691	2	\N	\N	SHAMPOO DE TEPEZCOUITE (OCOTZAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1692	2	\N	\N	SHAMPOO HAIRKLYN 59ML (NORDIMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1693	2	\N	\N	SHAMPOO HENNA EGIPTO 400ML (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1694	2	\N	\N	SHAMPOO HENNA+NOGAL 550ML (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1695	2	\N	\N	SHAMPOO HERBAL ARBOL DE TE+ROMERO 550ML (INDIO P)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1696	2	\N	\N	SHAMPOO NEEM+VITAMINAS 550ML (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1697	2	\N	\N	SHAMPOO PARA BEBE 120ML (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1698	2	\N	\N	SHAMPOO REPELENTE PARA PIOJOS 250ML (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1699	2	\N	\N	SHAMPOO REPELENTE PARA PIOJOS 550ML (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1700	2	\N	\N	SHAMPOO SANGRE DE GRADO CON ESPINOSILLA (GIZEH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1701	2	\N	\N	SHAMPOO ZAPOYULO 550ML (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1702	2	\N	\N	SHAMPOO/REPELENTE XTERMIN PIOJOS FRUTAS 550ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1703	2	\N	\N	SHAMPOO/REPELENTE XTERMIN PIOJOS SANDIA 550ML	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1704	2	\N	\N	SHOT B GS MAX C/30 TABS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1705	2	\N	\N	SHOT-B C/30 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1706	2	\N	\N	SHOT-B DIABETICO C/30 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1707	2	\N	\N	SHOT-B GS C/30 + 30 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1708	2	\N	\N	SHOT-B GS C/30 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1709	2	\N	\N	SHOT-B I.Q. C/30 TABS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1710	2	\N	\N	SIES 200MG C/20 CAPS (CETUS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1711	2	83	143	Siete Machos Jabon 90g (Urania)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1712	2	\N	143	Siete Machos Locion 1000ml (Urania)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1713	2	\N	143	SIETE MACHOS LOCION 10ML (URANIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1714	2	\N	143	Siete Machos Locion 110ml (Urania)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1715	2	\N	143	Siete Machos Locion 250ml (Urania)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1716	2	\N	143	Siete Machos Locion 400ml (Urania)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1717	2	\N	143	Siete Machos Locion 750ml (Urania)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1718	2	\N	143	Siete Machos Perfume 30ml (Urania)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1719	2	\N	143	SIETE MACHOS SPRAY 220ML (URANIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1720	2	\N	\N	SILDENAFIL 100MG C/1 TAB (HORMONA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1721	2	\N	\N	Silimarino 1gc/60 Tabletas (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1722	2	\N	\N	SILIMARINO 800MG C/90 (FARNAT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1723	2	\N	\N	SILIMARINO C/60 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1724	2	75	129	SILKA-MEDIC GEL 30G TERBINAFINA (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1725	2	52	\N	SIMILAXOL C/50 TAB	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1726	2	\N	\N	SIMPLEX C/60 TABLETAS (NARTEX LABS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1727	2	\N	\N	SINGASTRI C/90 TABS 1G (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1728	2	\N	\N	SINTROCID c/100 TABS. 0.100 MG.Levotiroxina Sódica (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1729	2	\N	\N	SINUBERASE C/10 AMP ESPORAS BACILLUS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1730	2	\N	\N	SINUBERASE C/12 COMPRIMIDOS ESPORAS BACILLUS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1731	2	\N	\N	SINUBERASE C/20 AMP ESPORAS BACILLUS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1732	2	\N	\N	SINUBERASE C/48 COMPRIMIDOS ESPORAS BACILLUS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1733	2	\N	\N	SINUBERASE C/5 AMP ESPORAS BACILLUS (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1734	2	19	31	SIRACUX ADULTO 120 ML OXELADINA+AMBROXOL  (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1735	2	19	31	SIRACUX INF 120 ML OXELADINA+AMBROXOL  (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1736	2	19	144	SITO-GRIX 120ML HEDERA HELIX (CMD)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1737	2	\N	\N	SIXOL 1MG C/30 TABS COLCHICINA (BIOMEP)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1738	2	20	62	SOLDRIN OFTÁLMICO 10ML (PISA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1739	2	20	62	SOLDRIN OTICO 10ML (PISA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1740	2	\N	\N	SOLUCION REMOVEDORA DE VERRUGAS 9ML (CERTUS PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1741	2	100	60	SOLUTINA F GOTAS 20ML (ALCON)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1742	2	\N	\N	SOLUTINA F GOTAS 20ML (ALCON) BLISTER	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1743	2	\N	\N	SOLUTINA OJO ROJO 15ML (ALCON)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1744	2	\N	\N	SONS  25MG C/30 TABS DIFENIDOL (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1745	2	\N	\N	SOSTENON 250 (SCHERING-PLOUGH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1746	2	101	12	SOVICLOR 200MG C/25 TABLETAS (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1747	2	\N	\N	SOVICLOR 200MG C/70 TABLETAS (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1748	2	101	12	SOVICLOR 400MG C/35 TABLETAS (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1749	2	101	12	SOVICLOR 800MG C/35 TABLETAS (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1750	2	\N	\N	SPORANOX 15D C/15 CAPS (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1751	2	\N	\N	Stressnat 500mg c/60 Capsulas (Nature's P.e.t. )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:45.227187+00	\N
1752	2	\N	\N	STUGERON 75MG C/20 TABS (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1753	2	\N	\N	STUGERON FORTE 75MG C/60 TABS (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1754	2	33	145	SUDAGRIP ANTIGRIPAL EXHIBIDOR C/100 CAPS  (PAILL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1755	2	33	145	SUDAGRIP ANTIGRIPAL TE GRANULADO C/25 SOBRES (PAILL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1756	2	19	145	SUDAGRIP TOS 120ML JARABE (PAILL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1757	2	\N	\N	Suit-C Complex 600mg c/300 Tabs (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1758	2	\N	\N	SUKROL C/100 TAB	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1759	2	\N	\N	SUKROL MUJER C/30 TABS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1760	2	\N	\N	SUKROL VIGOR C/50	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1761	2	\N	\N	SUKROLITO INF JARABE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1762	2	\N	\N	SUKUNAI KIROS 200MG C/30 CAPS (NATURA CASTLE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1763	2	\N	\N	SUKUNAI KIROS MAX 200MG C/30 CAPS (NATURA CASTLE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1764	2	\N	\N	SULFAMETOXAZOL/ TRIMETROPRIMA 100ML ( PHARMAGEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1765	2	20	93	SULFATIAZOL POLVO 10G  (ALPRIMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1766	2	20	70	SULFATIAZOL POLVO 12G  (KURAMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1767	2	20	146	SULFATIAZOL POLVO 5G (MYGRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1768	2	20	133	SULFATIAZOL POLVO 6G (SANAX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1769	2	20	\N	SULFATIAZOL POMADA 27 GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1770	2	\N	\N	SULFATIAZOL POMADA 27G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1771	2	\N	\N	SULFAWAL-S 100ML SULFAMETOXAZOL/ TRIMETROPRIMA  ( NOVAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1772	2	12	15	SUMA-B SOL INY TIAMINA-PIRIDOXINA-HIDROXOCOBALAMINA (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1773	2	\N	\N	SUPER CREMA MILAGROSA CON ARCINA Y BELLADONA 29	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1774	2	\N	\N	Super Dieter's Drink 690mg c/120 Capsulas (La Salud es Primero)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1775	2	\N	\N	Super Dieter's Drink 690mg c/30 Capsulas (La Salud es Primero)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1776	2	\N	\N	Super Dieter's Drink 690mg c/90 Capsulas (La Salud es Primero )	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1777	2	\N	\N	SUPER TIAMINA C/10 AMP (LABORATORIOS VENEZUELA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1778	2	\N	\N	Suplemento Alimenticio # 3 (Farmacia de Ahorro)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1779	2	\N	\N	SUPRADOL C/10 TABLETAS (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1780	2	\N	\N	SUPRADOL C/2 TABLETAS (LIOMONT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1781	2	\N	\N	SYDOLIL. 1MG C/36 TABS ERGOTAMINA/CAFEINA/ACIDO ACETILSALICILICO (SEGFRIED RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1782	2	17	15	SYNALAR OFTALMICO 15ML (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1783	2	17	15	SYNALAR OTICO 15ML GOTAS (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1784	2	\N	\N	SYNALAR SIMPLE 0.01% 20G (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1785	2	17	15	SYNALAR SIMPLE 40G (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1786	2	17	15	SYNALAR-C 40GR (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1787	2	\N	\N	SYNCOL C/24 TABS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1788	2	\N	\N	SYNCOL MAX C/12 COMPRIMIDOS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1789	2	\N	\N	SYNCOL NOCTURNO C/12 COMPRIMIDOS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1790	2	\N	\N	SYNCOL TEEN C/12 COMPRIMIDOS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1791	2	\N	\N	TABCIN  AZUL C/60 TABLETAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1792	2	33	18	TABCIN 500 C/12 CAPSULAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1793	2	33	18	TABCIN 500 EXHIBIDOR ROJO C/60 TABLETAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1794	2	33	18	TABCIN ACTIVE C/12 CAPSULAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1795	2	33	18	TABCIN AZUL C/12 TABS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1796	2	\N	\N	TABCIN INFANTIL C/12 TABS EFERVECENTES (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1797	2	\N	\N	TABCIN NOCHE C/12 CAPSULAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1798	2	\N	\N	TAMANZELA C/12 CORTA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1799	2	\N	\N	TAMANZELA C/6 GRANDE	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1800	2	33	52	TAMEX C/10 TABS LORATADINA/ BETAMETASONA (SERRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1801	2	33	52	TAMEX SUSP 60ML  LORATADINA/ BETAMETASONA (SERRAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1802	2	\N	\N	TAMSULOSINA 0.4MG C/20 CAPS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1803	2	22	111	TAMSULOSINA 0.4MG C/20 TABS (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1804	2	\N	\N	TAMSULOSINA 0.4MG C/20 TABS (BEADVANCE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1805	2	\N	\N	TAMSULOSINA 0.4MG C/20 TABS (HORMONA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1806	2	\N	\N	TAMSULOSINA 0.4MG C/20 TABS (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1807	2	\N	\N	Te 7 Azahares 150g (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1808	2	\N	\N	Te Boldo c/25 sobres (Therbal)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1809	2	\N	\N	Te Cerebryl 150g (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1810	2	30	92	TE CHUPA GRASS  C/30 SOBRES (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1811	2	\N	92	TE CHUPA GRASS  C/30 SOBRES (GN+VIDA)  USA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1812	2	\N	92	TE CHUPA PANZA C/30 SOBRES (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1813	2	\N	92	TE CHUPA PANZA C/30 SOBRES (GN+VIDA). USA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1814	2	\N	\N	Te Cola de Caballo c/30 bolsitas (Anahuac)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1815	2	\N	\N	Te de Chicura 150g (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1816	2	\N	147	TÉ DIETERS DRINK C/36 SOBRES (LASALUD)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1817	2	\N	\N	Te Hierba de San Juan c/25 Sobres (Therbal) (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1818	2	\N	\N	Te Hierba del Sapo c/25 sobres (Therbal)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1819	2	\N	\N	Te Manzanilla con Anis c/25 sobres (Therbal)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1820	2	\N	\N	TE ME VALE MADRE (DINA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1821	2	\N	\N	TE PINGUICA C/30 SOBRES (ANAHUAC)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1822	2	\N	92	TE PIÑALIM C/30 SOBRES (GN+VD)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1823	2	\N	92	TE PIÑALIM C/30 SOBRES (GN+VD).  USA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1824	2	\N	\N	Te Sabila con Nopal c/30 bolsitas (Anahuac)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1825	2	\N	75	TE TIZANA DE AZAHARES C/30 SOBRES (ANAHUAC)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1826	2	\N	\N	Te Tiziana Betel 150g (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1827	2	\N	\N	Te Uva Ursi Compuesto 150g (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1828	2	\N	\N	Te Valeriana Compuesto 150g (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1829	2	\N	\N	TEATRICAL CREMA 400G ACLARADORA (GENOMMA LAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1830	2	\N	\N	TEATRICAL CREMA AZUL 230G (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1831	2	\N	\N	TEATRICAL CREMA AZUL 400G (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1832	2	\N	\N	TEATRICAL CREMA AZUL 52G (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1833	2	\N	\N	TEATRICAL CREMA ROSA 130G (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1834	2	\N	\N	TEATRICAL CREMA ROSA 230G (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1835	2	\N	\N	TEATRICAL CREMA ROSA 400G (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1836	2	\N	\N	TEGRETOL 2% 100ML SUSP (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1837	2	\N	\N	TEGRETOL 200MG C/30 COMP (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1838	2	39	122	TEGRETOL 200MG C/50 COMPRIMIDOS CARBAMAZEPINA (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1839	2	38	38	TELMISARTAN 40MG  C/14 TABS (BOEHRINGER INGELHEIM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1840	2	\N	\N	TELMISARTAN 40MG C/28 TABS (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1841	2	\N	\N	TELMISARTAN 40MG C/30 (ULTRA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1842	2	23	141	TEMPRA 500MG C/20 TABS (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1843	2	23	141	TEMPRA FORTE 650MG C/24 TABS (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1844	2	23	141	TEMPRA INFANTIL 120ML PARACETAMOL (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1845	2	23	141	TEMPRA INFANTIL 150MG C/10 SUPOSITORIOS PARACETAMOL (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1846	2	\N	\N	TEMPRA INFANTIL 6-11 Años PARACETAMOL (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1847	2	23	141	TEMPRA INFANTIL 80MG C/10 SUPOSITORIOS PARACETAMOL (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1848	2	23	141	TEMPRA PEDIATRICO 100ML PARACETAMOL (BRISTOL-MYERS SQUIBB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1849	2	\N	\N	TENORETIC 100MG C/28 tabs (AZTRA ZENECA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1850	2	\N	\N	TENORMIN 100MG C/28 TABS ATENOLOL (AZTRA ZENECA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1851	2	\N	\N	TEPEZCOHUITE 15ML GOTAS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.046284+00	\N
1852	2	\N	\N	Tepezcohuite Polvo 35g (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1853	2	\N	\N	TEPEZCOUITE CREMA 120GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1854	2	\N	\N	TEPEZCOUITE CREMA 60GR (INDIO PAPAGO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1855	2	\N	\N	TERBINAFINA 250 MG. C/28 TABS. (Megamed)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1856	2	\N	\N	TERFAMEX 30MG C/30 TABS FENTERMINA (MEDIX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1857	2	20	39	TERRAMICINA 10G OFTALMICA OXITETRACICLINA-POLIMIXINA B (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1858	2	20	39	TERRAMICINA 125MG C/24 PAST OXITETRACICLINA (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1859	2	20	39	TERRAMICINA 500MG C/16 CAPS OXITETRACICLINA (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1860	2	20	39	TERRAMICINA P 28.4GR (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1861	2	\N	\N	TERRA-TROCISCOS 15MG C/18 PAST (RRX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1862	2	20	148	TERRAXIN UNGUENTO 10G - OXITETRACICLINA POLIMIXINA (SOPHIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1863	2	60	101	Terron de magnesia 7g c/3 (Coyoacan Quimica)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1864	2	\N	\N	TERVICALM 15ML DESENTERRADOR (HOMEOPATICOS MILENIUM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1865	2	75	149	TERVIRAX 15ML HONGOS (HOMEOPATICOS MILENIUM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1866	2	\N	\N	TESALITOS PARCHES	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1867	2	\N	\N	TESALON INFANTIL SUPOSITORIOS C/12 (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1868	2	\N	\N	TESALON PERLAS C/10 CAPS (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1869	2	19	122	TESALON PERLAS C/20 CAPS (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1870	2	\N	\N	TESALON TENALIF AD JARABE 150ML (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1871	2	19	122	TESALON TENALIF AD MIEL-FRESA 150ML (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1872	2	19	122	TESALON TENALIF INF MIEL-LIMON 150ML (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1873	2	19	122	TESALON TESACOF ADULTO CEREZA 100ML (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1874	2	19	122	TESALON TESACOF INFANTIL 100ML (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1875	2	102	150	TESTOPRIM-D C/1 AMP (TOGOCINO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1876	2	102	150	TESTOPRIM-D C/3 AMP (TOGOCINO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1877	2	20	151	TETRA ATLANTIS 500MG C/20 CAPS TETRACICLINA (ATLANTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1878	2	20	152	TETRACICLINA 500MG C/100 CAPS (MK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1879	2	20	48	TETRACICLINA 500MG C/100 CAPS (SAIMED)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1880	2	20	153	TETRACICLINA 500MG CAPS TETRIN (ARANTIZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1881	2	\N	\N	TETRA-ZIL 500MG C/16 CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1882	2	20	23	TETREX 500MG C/20 CAPS TETRACICLINA (HORMONA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1883	2	\N	\N	THERAFLU EXTHEGRAN ROJO 10MG C/6 SOBRES (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1884	2	\N	\N	THERAFLU EXTHEGRAN VERDE 10MG C/6 SOBRES (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1885	2	\N	\N	TIAMINA 550 C/60 TABS (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1886	2	\N	\N	TIAMINA JARABE 340ML (GN+VIDA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1887	2	12	74	TIAMINAL B12 50,000 AMPULA C/5 JERINGAS (SILANES)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1888	2	12	74	TIAMINAL B12 C/3 AMP (SILANES)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1889	2	12	74	TIAMINAL B12 C/30 CAPSULAS (SILANES)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1890	2	12	74	Tiaminal B-12 Trivalente AP c/3 Amp  Cianocobalamina, Tiamina y Piridoxina (Silanes)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1891	2	12	74	Tiaminal B-12 Trivalente AP c/30 Caps Cianocobalamina, Tiamina y Piridoxina (Silanes)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1892	2	\N	\N	TIBUVIT 259MG C/25 CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1893	2	75	11	TING AEROSOL 160 GR (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1894	2	75	11	TING AEROSOL 80G (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1895	2	75	11	TING CREMA 28GR (SANOFI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1896	2	75	154	TING CREMA 72GR (SANOFI AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1897	2	75	154	TING TALCO 160G (SANOFI AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1898	2	75	154	TING TALCO 45GR (SANOFI AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1899	2	75	154	TING TALCO 85GR (SANOFI AVENTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1900	2	103	155	TINTURA DE VIOLETA DE GENCINA 20ML (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1901	2	103	155	TINTURA DE YODO 40ML (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1902	2	\N	\N	TIO NACHO SHAMPOO 415ML (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1903	2	\N	\N	TIRA NO/PIO/JIN SHAMPOO 12ML C/20 PZ	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1904	2	\N	\N	T-Kita Estress 600mg c/60 Tabletas (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1905	2	\N	\N	Tlanchalagua 400mg c/150 Caps (La Salud es Primero)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1906	2	\N	\N	TOBRADEX 5ML (ALCON)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1907	2	\N	\N	TOLUACHE CONCENTRADO	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1908	2	104	15	TOPSYN GEL 0.05% 40G FLUOCINONIDA/ CILOQUINOL (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1909	2	104	15	TOPSYN Y 40G GEL FLUOCINONIDA (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1910	2	\N	\N	TOSTI CAJA C/24	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1911	2	\N	\N	TRAMADOL 100MG C/100 CAPS (PHARMA RX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1912	2	\N	\N	TRAMADOL 100MG C/50  CAPS (PHARMA RX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1913	2	\N	\N	TRAMADOL 100MG C/60 + 60 DUO CAPS   (PHARMA RX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1914	2	\N	156	TRAMED AZUL 100MG C/60 + 60 CAPS DUO TRAMADOL (BAJAMED) (2)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1915	2	\N	156	TRAMED RV 100MG C/60 + 60 CAPS DUO TRAMADOL (BAJAMED) (2)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1916	2	\N	\N	TREDA C/10 TABLETAS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1917	2	86	7	TREDA C/20 + 10  TABLETAS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1918	2	86	7	TREDA C/20 TABLETAS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1919	2	86	7	TREDA SUSP NEOMICINA/CAOLIN/PECTINA (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1920	2	\N	\N	TRIATOP SHAMPOO AZUL 400ML (GENOMMA LAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1921	2	\N	\N	TRIATOP SHAMPOO ROJO 400ML (GENOMMA LAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1922	2	12	42	TRIBEDOCE 50,000 C/5 AMP 2ML (BRULUART)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1923	2	\N	\N	TRIBEDOCE C/10 AMP (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1924	2	\N	\N	TRIBEDOCE C/30 TABS (BRULUART)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1925	2	\N	\N	TRIBEDOCE C/L 2ML C/5 AMP (BRULUART)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1926	2	12	42	TRIBEDOCE COMPUESTO C/3 AMP (BRULUART)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1927	2	12	42	TRIBEDOCE DX C/3 AMP (BRULUART)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1928	2	\N	\N	TRIBEDOCE FRASCO (EKO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1929	2	\N	\N	TRIBEDOCE KIDS 240ML MULTIVITAMINAS (BRULUART)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1930	2	\N	\N	Tri-luma 15g Fluocinolona, Hidroquinona, Tretinoina (Galderma)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1931	2	72	18	TRIQUILAR C/21 TABLETAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1932	2	\N	\N	TRI-VI-SOL PEDIATRICO 50ML (SIEGFRIED-RHEIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1933	2	\N	\N	TROFERIT 120ML DROPROPIZINA (CHINOIN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1934	2	20	111	TROPHARMA 500MG C/20 TABS ERITROMICINA (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1935	2	\N	\N	TUKALIV C/20 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1936	2	19	16	TUKELI NATURAL 120ML ADULTO-INFANTIL (GENOMALAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1937	2	19	16	TUKOL-D ADULTO 125ML DEXTROMETORFANO/GUAIFENESINA  (GENOMALAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1938	2	\N	\N	TUKOL-D DIABETES 120ML DEXTROMETORFANO/GUAIFENESINA (GENOMALAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1939	2	19	16	TUKOL-D INFANTIL 125ML DEXTROMETORFANO/GUAIFENESINA (GENOMALAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1940	2	19	16	TUKOL-D MIEL  INFANTIL 120ML DEXTROMETORFANO/GUAIFENESINA (GENOMALAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1941	2	19	16	TUKOL-D MIEL ADULTO 120ML DEXTROMETORFANO/GUAIFENESINA (GENOMALAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1942	2	\N	\N	TYLENOL C/20 TABLETAS (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1943	2	\N	\N	TYLENOL SUSPENSION INFANTIL 120ML (JAUSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1944	2	\N	\N	ULSEN 1+1 20MG C/7 CÁPSULAS (ALTIA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1945	2	\N	\N	UNAMOL 10MG C/30 TABS CISAPRIDA (EXEA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1946	2	\N	\N	UNAMOL 60ML PEDIATRICO CISAPRIDA (EXEA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1947	2	75	104	UNESIA 20GR UNG BIOFONAZOL (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1948	2	75	104	UNESIA TALCO 90GR  (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1949	2	\N	\N	UNGÜENTO BRONCO RUB 40GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1950	2	\N	\N	UNGUENTO DRAGON	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1951	2	\N	\N	UNGÜENTO FORAPIÑA 125GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:46.944767+00	\N
1952	2	\N	\N	UNGÜENTO RESINA DE OCOTE 125GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1953	2	17	157	UNGUENTO VETERINARIO LA TIA 125GR (ORDOÑEZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1954	2	17	157	UNGUENTO VETERINARIO LA TIA 60GR (ORDOÑEZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1955	2	\N	\N	UNIVAL 1G C/40 TABLETAS (EXEA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1956	2	\N	\N	UÑA DE GATO C/60 CÁPSULAS (YPENZA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1957	2	\N	33	UREZOL 100MG C/20 TABS FENAZOPIRIDINA (MAVI)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1958	2	\N	\N	UROCLASIO NF 150ML CITRATO DE POTASIO, ACIDO CITRICO (ITALMEX)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1959	2	\N	158	UROFIN 500MG C/100 TABS (LABORATORIOS LOPEZ)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1960	2	\N	\N	UROGUTT 160MMG C/40 CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1961	2	\N	12	UROVEC C/24 TABS TETRACICLINA,FENAZOPIRIDINA,SULFAMETOXAZOL (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1962	2	\N	18	VAGITROL-V C/10 OVULOS ACETONIDO DE FLUOCINOLONA, METRONIDAZOL, NISTATINA (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1963	2	\N	\N	VALERIANA 50ML (CENTRO BOTANICO LA PIEDAD)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1964	2	\N	\N	Valeriana 60ml Gotas (Aukar)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1965	2	\N	\N	VALPROATO DE MAGNESIO 200MG C/40 TABS (GENERICOS ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1966	2	\N	\N	VARITON 500MG C/20 CAPS	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1967	2	\N	\N	VASCULFLOW C/30 TABS (TEVA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1968	2	\N	\N	VASELINA BLANCA BEBE 60GR (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1969	2	\N	\N	VELA COLOR ROJO (PAREJA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1970	2	\N	\N	VELAS COLOR ROJO C/20 PZ (BLANCA FLOR MAGICA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1971	2	\N	\N	Venalot Depot c/30 Tabs Troxerutina/Cumarina (Nycomed)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1972	2	\N	\N	VENASTAT C/60 CAPS VARICES (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1973	2	\N	\N	Venda Elastica 10cm (Jaloma)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1974	2	\N	\N	VENDA ELASTICA 15CM (JALOMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1975	2	\N	\N	Venda Elastica 25cm (Jaloma)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1976	2	\N	\N	Venda Elastica 30cm (Jaloma)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1977	2	\N	\N	VENDA ELASTICA PREMIUM 10CM/500CM (LEROY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1978	2	\N	\N	VENDA ELASTICA PREMIUM 15CM/500CM (LEROY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1979	2	\N	\N	VENTOLIN 4MG C/ 30 TABS (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1980	2	\N	22	VENTOLIN SALBUTAMOL C/200 DOSIS (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1981	2	\N	\N	VENTOLIN SALBUTAMOL JBE 200ML (GLAXO SMITH KLINE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1982	2	\N	31	VERIDEX 6MG C/2 TABS IVERMECTINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1983	2	\N	\N	VERIDEX 6MG C/4 TABS IVERMECTINA (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1984	2	\N	\N	VERISAN TRIPLEX	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1985	2	\N	\N	VERMICOL 30ML MEBENDAZOL (DEGORTS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1986	2	\N	108	VERMOX 1 DIA CEREZA 10ML (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1987	2	\N	130	VERMOX 100MG C/6 TABS MEBENDAZOL (JANSSEN-CILAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1988	2	\N	108	VERMOX 30ML PLATANO MEBENDAZOL (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1989	2	\N	130	VERMOX 500MG C/1 TAB MEBENDAZOL (JANSSEN-CILAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1990	2	\N	108	VERMOX PLUS 1 DIA C/2 TABLETAS (JANSSEN)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1991	2	\N	130	VERMOX PLUS INF 10ML SABOR CEREZA (JANSSEN-CILAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1992	2	\N	130	VERMOX PLUS INF 10ML SABOR PLATANO (JANSSEN-CILAG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1993	2	\N	51	VEXOTIL 10MG C/30 TABS ENALAPRIL (BIOMEP)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1994	2	\N	39	VIAGRA 100MG C/1 TAB SILDENAFIL (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1995	2	\N	39	VIAGRA 100MG C/4 TAB SILDENAFIL (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1996	2	\N	\N	VIAGRA 100MG DISPLAY C/10 TAB SILDENAFIL (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1997	2	\N	31	VIAXOL 30ML GOTAS AMBROXOL (MAVER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1998	2	\N	\N	Vibora de Cascabel 600mg c/150 Caps (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
1999	2	\N	159	VIBORA DE CASCABEL C/50 CAPS (CHIAPAS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2000	2	\N	\N	VIBORA DE CASCABEL C/90 (FARNAT)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2001	2	\N	39	VIBRAMICINA 100MG C/10 CAPS (PFIZER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2002	2	\N	\N	VICK 44 120ML GUAIFENESINA	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2003	2	\N	\N	VICK BABY BALM 50G (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2004	2	\N	\N	VICK CEREZA EXH C/10 C/20 PASTILLAS (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2005	2	\N	\N	VICK LIMON EXH C/10 C/20 PASTILLAS (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2006	2	\N	\N	VICK MENTOL EXH C/10 C/20 PASTILLAS (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2007	2	\N	\N	VICK PYRENA MIEl/ LIMON C/12 SOBRES (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2008	2	\N	160	VICK VAPORUB  C/40 LATITAS 12GR (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2009	2	\N	160	VICK VAPORUB 100GR (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2010	2	\N	160	VICK VAPORUB 5OGR (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2011	2	\N	160	VICK VAPORUB C/12 LATITAS 12GR (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2012	2	\N	160	VICK VAPORUB INHALADOR (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2013	2	\N	160	VICK VAPORUB INHALADOR C/12 PIEZAS (VICK)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2014	2	\N	161	VIDA MAGNESIO PLUS C/60 CAPS (COYOACAN QUIMICAS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2015	2	\N	\N	VIDAMIL C/5 AMP RETINOL, ACIDO ASCORBICO,COLECALSIFEROL (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2016	2	\N	\N	VITACILINA 16GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2017	2	\N	\N	VITACILINA 28GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2018	2	\N	\N	VITACILINA 32G	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2019	2	\N	\N	VITACILINA BEBE 110GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2020	2	\N	\N	VITACILINA BEBE 50GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2021	2	\N	\N	VITAMINA E UI 1200MG C/30 CAPS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2022	2	\N	\N	VITAMINA E UI 500MG CON GERMEN C/30 CAPS (SANDY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2023	2	\N	162	VITERNUM 140ML JBE  (IPAL)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2024	2	\N	\N	VIVINOX-N C/40 TABS (BOMUCA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2025	2	\N	\N	Vivioptal Active c/30 Softgel Caps 2x1 (Bomuca)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2026	2	\N	\N	VIVIOPTAL C/105 CAPS (BOMUCA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2027	2	\N	\N	VIVIOPTAL C/30 CAPS (BOMUCA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2028	2	\N	\N	VIVIOPTAL C/90 CAPS (BOMUCA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2029	2	\N	\N	VIVIOPTAL JUNIOR  250ML (BOMUCA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2030	2	\N	\N	Vivioptal Multi c/30 Softgel Caps 2x1 (Bomuca)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2031	2	\N	\N	Vivioptal Women c/30 Softgel Caps 2x1 (Bomuca)  (USA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2032	2	\N	111	VIVRADOXIL 100MG C/10 TABS DOXICICLINA (ALPHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2033	2	\N	\N	VOLFENAC C/2 AMP 75MG (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2034	2	\N	12	VOLFENAC C/4 AMP 75MG DICLOFENACO (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2035	2	\N	12	VOLFENAC GEL 60GR DICLOFENACO (COLLINS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2036	2	\N	13	VOLPROATO DE MAGNESIO 250MG C/30 TABS (AMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2037	2	\N	\N	VOLTAREN C/5 AMP 3ML DICLOFENACO (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2038	2	\N	\N	VOLTAREN DOLO C/20 CAPS 25MG (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2039	2	\N	122	VOLTAREN EMULGEL 100GR DICLOFENACO (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2040	2	\N	\N	VOLTAREN EMUNGEL 12H 100G (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2041	2	\N	\N	VOLTAREN RETARD 100MG C/10 GRAGEAS (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2042	2	\N	122	VOLTAREN RETARD 100MG C/20 TABS (NOVARTIS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2043	2	\N	40	VOMISIN 15ML GOTAS DIMENHIDRINATO (RAYERE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2044	2	\N	40	VOMISIN 50MG C/20 TABS DIMENHIDRINATO (RAYERE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2045	2	\N	\N	VOMISIN SOL INY C/3 AMP DIMENHIDRINATO (RAYERE)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2046	2	\N	7	VONTROL C/25 TABS DIFENIDOL (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2047	2	\N	\N	VONTROL SOL INY 40MG/2ML (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2048	2	\N	163	VO-REMI 15ML GOTAS MECLIZINA, PIRIDOXINA (OFFENBACH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2049	2	\N	62	Votripax Forte 5mg c/3 Amp Complejo-Diclofenaco Sodico (Pisa)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2050	2	\N	\N	VOYDOL 10MG C/10 TABS KETOROLACO (RAAM)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2051	2	\N	\N	WereNopal 500mg c/150 Tabletas (Dina)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:47.873718+00	\N
2052	2	\N	164	WERMY 300MG C/15 TABS GABAPENTINA (WERMAR)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2053	2	\N	164	WERMY 300MG C/30 TABS GABAPENTINA (WERMAR)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2054	2	\N	104	XL-3 ANTIGRIPAL C/10 TABS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2055	2	\N	104	XL-3 ANTIGRIPAL EXHIBIDOR C/25 CARTERAS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2056	2	\N	\N	XL-3 Dia c/12 Tabs (Selder)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2057	2	\N	104	XL-3 VR C/24 TABS ANTIGRIPAL CON ACCION ANTIVIRAL (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2058	2	\N	16	XL-3 XTRA C/12 CAPS (GENOMALAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2059	2	\N	\N	XL-DOL 500MG C/20 TABS (GENOMALAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2060	2	\N	\N	XOTZILAC C/COLAGENO POLVO 470GR (SIEMPRE POSITIVO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2061	2	\N	\N	X-RAY C/40 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2062	2	\N	\N	X-RAY DOL C/20 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2063	2	\N	\N	X-Ray Gel 30g Diclofenaco (Genomma Lab)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2064	2	\N	\N	X-RAY SISTEMA OSEO C/30 CAPS (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2065	2	\N	\N	XREY GEL ROJO 125GR	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2066	2	\N	\N	XYLOCAÍNA 5% 35GR (RIMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2067	2	\N	\N	Xylocaina EV 50ml	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2068	2	\N	\N	XYLOCAÍNA SPRAY SOL 10% 115ML (RIMSA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2069	2	\N	104	XYLOPROCT PLUS 30G UNGUENTO (GENOMMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2070	2	\N	16	XYLOPROCT PLUS 60MG/5MG C/6 SUP (GENOMMA LAB)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2071	2	\N	18	YASMIN 24/4 C/28 (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2072	2	\N	18	YASMIN 3MG/0.03MG C/21 GRAGEAS (BAYER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2073	2	\N	\N	Z-Blanco Reforzado 500mg c/60 Capsulas (Ener Green)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2074	2	\N	\N	ZEBETYN C/30 CAPS COMPLEJO B (GEL PHARMA)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2075	2	\N	\N	ZENTEL 10ML SUSPENSION (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2076	2	\N	\N	ZENTEL 200MG C/10 TABS (SANFER)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2077	2	\N	\N	ZERO PIOJO SHAMPIOJO 120ML C/PEINE DE LUJO (GBH)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2078	2	\N	27	ZISUAL-C 30G UNG RECTAL C/6 CANULAS LIDOCAINA/ HIDROCORTISONA (SONS)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2079	2	\N	\N	ZORRITONE BOLSA C/15  CARAMELOS (ANCALMO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2080	2	\N	165	ZORRITONE JARABE 120ML (ANCALMO)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2081	2	\N	\N	Zorromex Jarabe 120ml (Grupo Naturalmex)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2082	2	\N	\N	ZUPAREX 20MG C/100 CAPS. PIROXICAM (VICTORY)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2083	2	\N	\N	ZYPLO 60MG C/20 TABS LEVODROPROPIZINA (ARMSTRONG)	\N	\N	\N	\N	0	\N	t	2025-07-06 18:15:48.729115+00	\N
2085	1	\N	\N	Test Product API Updated	Producto de prueba creado por test automático	TESTSKU1751958520	TESTBAR1751958520	1	0	\N	t	2025-07-08 07:08:40.461648+00	2025-07-08 07:08:40.502236+00
2086	1	\N	\N	Test Product API Updated	Producto de prueba creado por test automático	TESTSKU1751958582	TESTBAR1751958582	1	0	\N	t	2025-07-08 07:09:42.632762+00	2025-07-08 07:09:42.656936+00
2087	1	\N	\N	Test Product API Updated	Producto de prueba creado por test automático	TESTSKU1751958646	TESTBAR1751958646	1	0	\N	t	2025-07-08 07:10:46.006764+00	2025-07-08 07:10:46.032825+00
2088	1	\N	\N	Test Product API Updated	Producto de prueba creado por test automático	TESTSKU1751958707	TESTBAR1751958707	1	0	\N	t	2025-07-08 07:11:47.674504+00	2025-07-08 07:11:47.697913+00
2089	1	1	1	Producto Test Directo	Descripción de prueba	DIRECT001	\N	1	0	\N	t	2025-07-10 07:02:54.610524+00	\N
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, name, description, start_date, end_date, budget, notes, owner_id) FROM stdin;
\.


--
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_order_items (id, purchase_order_id, product_variant_id, unit_id, quantity_ordered, quantity_received, quantity_pending, unit_cost, total_cost, product_name, product_sku, supplier_sku, notes, created_at, updated_at) FROM stdin;
1	1	1	7	50	0	50	12	600	Coca-Cola 600ml	CC-600	SUP-CC-600	\N	2025-07-06 18:09:32.066258+00	\N
2	1	2	7	30	0	30	25	750	Coca-Cola 2L	CC-2L	SUP-CC-2L	\N	2025-07-06 18:09:32.066258+00	\N
3	2	3	7	40	0	40	18	720	Leche Lala Entera 1L	LL-1L	SUP-LL-1L	\N	2025-07-06 18:09:32.066258+00	\N
\.


--
-- Data for Name: purchase_order_receipt_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_order_receipt_items (id, receipt_id, purchase_order_item_id, quantity_received, quantity_accepted, quantity_rejected, batch_number, expiry_date, quality_status, notes, rejection_reason, created_at) FROM stdin;
\.


--
-- Data for Name: purchase_order_receipts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_order_receipts (id, purchase_order_id, warehouse_id, user_id, receipt_number, receipt_date, supplier_invoice_number, supplier_delivery_note, status, notes, quality_notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_orders (id, business_id, supplier_id, warehouse_id, user_id, order_number, supplier_reference, status, order_date, expected_delivery_date, actual_delivery_date, subtotal, tax_amount, shipping_cost, discount_amount, total_amount, payment_terms, payment_status, notes, internal_notes, created_at, updated_at, approved_at, approved_by_id) FROM stdin;
1	1	1	1	2	PO-20250106-001	\N	PENDING	2025-07-04 11:09:32.073607+00	2025-07-11 11:09:32.073657	\N	1000	160	0	0	1160	NET_30	pending	Orden urgente para restock	\N	2025-07-06 18:09:32.066258+00	\N	\N	\N
2	1	2	1	2	PO-20250105-002	\N	APPROVED	2025-07-03 11:09:32.084368+00	2025-07-09 11:09:32.084376	\N	750	120	0	0	870	NET_15	pending	Productos lácteos y abarrotes	\N	2025-07-06 18:09:32.066258+00	\N	2025-07-05 11:09:32.084378	1
\.


--
-- Data for Name: sale_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sale_items (id, sale_id, product_variant_id, unit_id, quantity, unit_price, total_price) FROM stdin;
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales (id, warehouse_id, user_id, sale_number, date, payment_method, subtotal, tax, discount, total, customer_name, customer_email, notes, created_at) FROM stdin;
\.


--
-- Data for Name: stock_alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_alerts (id, warehouse_id, product_variant_id, alert_type, current_quantity, minimum_quantity, maximum_quantity, is_resolved, resolved_at, created_at) FROM stdin;
\.


--
-- Data for Name: supplier_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier_products (id, supplier_id, product_variant_id, supplier_sku, supplier_product_name, cost_price, minimum_order_quantity, lead_time_days, is_active, is_preferred, created_at, updated_at) FROM stdin;
1	1	1	SUP-CC-600	Coca-Cola 600ml	10.8	10	9	t	t	2025-07-06 18:09:32.038154+00	\N
2	2	2	SUP-CC-2L	Coca-Cola 2L	22.5	10	15	t	t	2025-07-06 18:09:32.038154+00	\N
3	3	3	SUP-LL-1L	Leche Lala Entera 1L	16.2	10	5	t	t	2025-07-06 18:09:32.038154+00	\N
4	1	4	SUP-LL-DL-1L	Leche Lala Deslactosada 1L	19.8	10	5	t	f	2025-07-06 18:09:32.038154+00	\N
5	2	5	SUP-PB-BG	Pan Blanco Grande	25.2	10	5	t	f	2025-07-06 18:09:32.038154+00	\N
6	3	6	SUP-PB-INT	Pan Integral	28.8	10	13	t	f	2025-07-06 18:09:32.038154+00	\N
7	1	7	SUP-HM-1K	Harina Maseca 1kg	16.2	10	9	t	f	2025-07-06 18:09:32.038154+00	\N
8	2	8	SUP-HM-4K	Harina Maseca 4kg	58.5	10	13	t	f	2025-07-06 18:09:32.038154+00	\N
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (id, business_id, name, company_name, tax_id, email, phone, mobile, website, address, city, state, postal_code, country, payment_terms, credit_limit, discount_percentage, contact_person, contact_title, contact_email, contact_phone, is_active, notes, created_at, updated_at) FROM stdin;
1	1	Distribuidora Central	Distribuidora Central S.A. de C.V.	DCE120415AB1	ventas@distcentral.com	555-1001	\N	\N	Zona Industrial Norte 100	Ciudad	\N	\N	\N	NET_30	50000	0	Roberto Martinez	\N	roberto@distcentral.com	\N	t	\N	2025-07-06 18:09:31.904463+00	\N
2	1	Comercializadora del Valle	Comercializadora del Valle S.A.	CDV091205XY2	contacto@comvalle.com	555-2002	\N	\N	Av. del Valle 250	Ciudad	\N	\N	\N	NET_15	25000	0	Ana Gutierrez	\N	ana@comvalle.com	\N	t	\N	2025-07-06 18:09:31.904463+00	\N
3	1	Abarrotes El Mayorista	Abarrotes El Mayorista S.C.	AEM150820ZW3	ventas@mayorista.com	555-3003	\N	\N	Mercado Central Local 45	Ciudad	\N	\N	\N	CASH	15000	0	Carlos Lopez	\N	carlos@mayorista.com	\N	t	\N	2025-07-06 18:09:31.904463+00	\N
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, project_id, title, description, status, priority, due_date, reminder_date, responsible_id, checklist, comments, attachments, history, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.units (id, name, symbol, unit_type, conversion_factor, is_active, created_at) FROM stdin;
1	Kilogramo	kg	weight	1	t	2025-07-06 18:09:31.024157+00
2	Gramo	g	weight	0.001	t	2025-07-06 18:09:31.024157+00
3	Litro	L	volume	1	t	2025-07-06 18:09:31.024157+00
4	Mililitro	ml	volume	0.001	t	2025-07-06 18:09:31.024157+00
5	Metro	m	length	1	t	2025-07-06 18:09:31.024157+00
6	Centímetro	cm	length	0.01	t	2025-07-06 18:09:31.024157+00
7	Pieza	pza	count	1	t	2025-07-06 18:09:31.024157+00
8	Caja	caja	count	1	t	2025-07-06 18:09:31.024157+00
9	Paquete	paq	count	1	t	2025-07-06 18:09:31.024157+00
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (id, user_id, business_id, role, permissions, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password_hash, first_name, last_name, role, is_active, is_superuser, created_at, updated_at, must_change_password, "position", hire_date, phone, address, birth_date, nss, curp, emergency_contact, emergency_phone, hashed_password) FROM stdin;
1	admin@maestroinventario.com	$2b$12$K5RE5gMyAdwRpYRvTL96fuOnN43HyYRmQASIGbYADkL1sTn1/oXTO	Administrador	Sistema	ADMIN	t	t	2025-07-06 18:09:31.826123+00	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	$2b$12$K5RE5gMyAdwRpYRvTL96fuOnN43HyYRmQASIGbYADkL1sTn1/oXTO
2	manager@maestroinventario.com	$2b$12$2yvIidjTgXZlvdTCz6e9duV6pyYHlmHlhASxcTqWabDeyHaGkoDDe	Maria	Gonzalez	MANAGER	t	f	2025-07-06 18:09:31.826123+00	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	$2b$12$2yvIidjTgXZlvdTCz6e9duV6pyYHlmHlhASxcTqWabDeyHaGkoDDe
3	employee@maestroinventario.com	$2b$12$l1JaszOgsVttKW0Pgsn.zeeBYw9Nlv3s1pLL0fnv2hjJv9hSQ/OrS	Juan	Perez	EMPLOYEE	t	f	2025-07-06 18:09:31.826123+00	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	$2b$12$l1JaszOgsVttKW0Pgsn.zeeBYw9Nlv3s1pLL0fnv2hjJv9hSQ/OrS
4	admin@maestro.com	$2b$12$mEGX8Kq6XfXrstNo1A0Ga.rm3ofvCi3HEHTEoFsWjQEZ2QhLnjaa.	Administrador	de Prueba	ADMIN	t	t	2025-07-07 05:17:51.960368+00	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	$2b$12$mEGX8Kq6XfXrstNo1A0Ga.rm3ofvCi3HEHTEoFsWjQEZ2QhLnjaa.
5	capturista@maestro.com	$2b$12$JGReK6UbbCE.xOp2iY5M..B4G/PVfww8fbEmcntAY12xgX3bO.78G	Capturista	de Prueba	CAPTURISTA	t	f	2025-07-07 05:34:28.113084+00	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	$2b$12$JGReK6UbbCE.xOp2iY5M..B4G/PVfww8fbEmcntAY12xgX3bO.78G
6	almacenista@maestro.com	$2b$12$XB/OJX1BYi2c3dbbX2g0dOidAh6Yx/qqpiOcbRamkUPdXVZPPnF9a	Almacenista	de Prueba	ALMACENISTA	t	f	2025-07-07 05:34:28.113084+00	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	$2b$12$XB/OJX1BYi2c3dbbX2g0dOidAh6Yx/qqpiOcbRamkUPdXVZPPnF9a
\.


--
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.warehouses (id, business_id, name, description, code, address, is_active, created_at, updated_at) FROM stdin;
1	1	Almacén Principal	Almacén principal de la tienda	AP001	Av. Principal 123, Bodega A	t	2025-07-06 18:09:31.891835+00	\N
2	1	Almacén Secundario	Almacén para productos no perecederos	AS001	Calle Secundaria 456, Bodega B	t	2025-07-06 18:09:31.891835+00	\N
\.


--
-- Name: activity_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_log_id_seq', 1, false);


--
-- Name: attendance_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_logs_id_seq', 1, false);


--
-- Name: brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brands_id_seq', 210, true);


--
-- Name: business_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.business_users_id_seq', 6, true);


--
-- Name: businesses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.businesses_id_seq', 4, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 109, true);


--
-- Name: inventory_adjustment_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_adjustment_items_id_seq', 1, false);


--
-- Name: inventory_adjustments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_adjustments_id_seq', 1, false);


--
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_id_seq', 1, false);


--
-- Name: inventory_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_movements_id_seq', 4, true);


--
-- Name: login_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_attempts_id_seq', 6, true);


--
-- Name: offices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.offices_id_seq', 1, false);


--
-- Name: product_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variants_id_seq', 8, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 2089, true);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projects_id_seq', 1, false);


--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_order_items_id_seq', 3, true);


--
-- Name: purchase_order_receipt_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_order_receipt_items_id_seq', 1, false);


--
-- Name: purchase_order_receipts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_order_receipts_id_seq', 1, false);


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_orders_id_seq', 2, true);


--
-- Name: sale_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sale_items_id_seq', 1, false);


--
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_id_seq', 1, false);


--
-- Name: stock_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_alerts_id_seq', 1, false);


--
-- Name: supplier_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplier_products_id_seq', 8, true);


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 3, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_id_seq', 1, false);


--
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.units_id_seq', 9, true);


--
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: warehouses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.warehouses_id_seq', 2, true);


--
-- Name: activity_log activity_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_log
    ADD CONSTRAINT activity_log_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: attendance_logs attendance_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_logs
    ADD CONSTRAINT attendance_logs_pkey PRIMARY KEY (id);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: business_users business_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_users
    ADD CONSTRAINT business_users_pkey PRIMARY KEY (id);


--
-- Name: businesses businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: inventory_adjustment_items inventory_adjustment_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment_items
    ADD CONSTRAINT inventory_adjustment_items_pkey PRIMARY KEY (id);


--
-- Name: inventory_adjustments inventory_adjustments_adjustment_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustments
    ADD CONSTRAINT inventory_adjustments_adjustment_number_key UNIQUE (adjustment_number);


--
-- Name: inventory_adjustments inventory_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustments
    ADD CONSTRAINT inventory_adjustments_pkey PRIMARY KEY (id);


--
-- Name: inventory_movements inventory_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: login_attempts login_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_attempts
    ADD CONSTRAINT login_attempts_pkey PRIMARY KEY (id);


--
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id);


--
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_receipt_items purchase_order_receipt_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_receipt_items
    ADD CONSTRAINT purchase_order_receipt_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_receipts purchase_order_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_receipts
    ADD CONSTRAINT purchase_order_receipts_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: sale_items sale_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT sale_items_pkey PRIMARY KEY (id);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: sales sales_sale_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_sale_number_key UNIQUE (sale_number);


--
-- Name: stock_alerts stock_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_alerts
    ADD CONSTRAINT stock_alerts_pkey PRIMARY KEY (id);


--
-- Name: supplier_products supplier_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_products
    ADD CONSTRAINT supplier_products_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: warehouses warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_pkey PRIMARY KEY (id);


--
-- Name: ix_brands_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_brands_id ON public.brands USING btree (id);


--
-- Name: ix_business_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_business_users_id ON public.business_users USING btree (id);


--
-- Name: ix_businesses_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_businesses_code ON public.businesses USING btree (code);


--
-- Name: ix_businesses_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_businesses_id ON public.businesses USING btree (id);


--
-- Name: ix_categories_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_categories_id ON public.categories USING btree (id);


--
-- Name: ix_inventory_adjustment_items_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_adjustment_items_id ON public.inventory_adjustment_items USING btree (id);


--
-- Name: ix_inventory_adjustments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_adjustments_id ON public.inventory_adjustments USING btree (id);


--
-- Name: ix_inventory_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_id ON public.inventory USING btree (id);


--
-- Name: ix_inventory_movements_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inventory_movements_id ON public.inventory_movements USING btree (id);


--
-- Name: ix_product_variants_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_product_variants_id ON public.product_variants USING btree (id);


--
-- Name: ix_product_variants_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_product_variants_sku ON public.product_variants USING btree (sku);


--
-- Name: ix_products_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_products_id ON public.products USING btree (id);


--
-- Name: ix_products_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_products_sku ON public.products USING btree (sku);


--
-- Name: ix_purchase_order_items_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purchase_order_items_id ON public.purchase_order_items USING btree (id);


--
-- Name: ix_purchase_order_receipt_items_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purchase_order_receipt_items_id ON public.purchase_order_receipt_items USING btree (id);


--
-- Name: ix_purchase_order_receipts_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purchase_order_receipts_id ON public.purchase_order_receipts USING btree (id);


--
-- Name: ix_purchase_order_receipts_receipt_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_purchase_order_receipts_receipt_number ON public.purchase_order_receipts USING btree (receipt_number);


--
-- Name: ix_purchase_orders_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purchase_orders_id ON public.purchase_orders USING btree (id);


--
-- Name: ix_purchase_orders_order_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_purchase_orders_order_number ON public.purchase_orders USING btree (order_number);


--
-- Name: ix_sale_items_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sale_items_id ON public.sale_items USING btree (id);


--
-- Name: ix_sales_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sales_id ON public.sales USING btree (id);


--
-- Name: ix_stock_alerts_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stock_alerts_id ON public.stock_alerts USING btree (id);


--
-- Name: ix_supplier_products_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_supplier_products_id ON public.supplier_products USING btree (id);


--
-- Name: ix_suppliers_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_suppliers_id ON public.suppliers USING btree (id);


--
-- Name: ix_units_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_units_id ON public.units USING btree (id);


--
-- Name: ix_user_roles_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_user_roles_id ON public.user_roles USING btree (id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_warehouses_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_warehouses_id ON public.warehouses USING btree (id);


--
-- Name: attendance_logs attendance_logs_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_logs
    ADD CONSTRAINT attendance_logs_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.offices(id);


--
-- Name: attendance_logs attendance_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_logs
    ADD CONSTRAINT attendance_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: brands brands_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: business_users business_users_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_users
    ADD CONSTRAINT business_users_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: business_users business_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_users
    ADD CONSTRAINT business_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: categories categories_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: categories categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- Name: inventory_adjustment_items inventory_adjustment_items_adjustment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment_items
    ADD CONSTRAINT inventory_adjustment_items_adjustment_id_fkey FOREIGN KEY (adjustment_id) REFERENCES public.inventory_adjustments(id);


--
-- Name: inventory_adjustment_items inventory_adjustment_items_product_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment_items
    ADD CONSTRAINT inventory_adjustment_items_product_variant_id_fkey FOREIGN KEY (product_variant_id) REFERENCES public.product_variants(id);


--
-- Name: inventory_adjustment_items inventory_adjustment_items_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment_items
    ADD CONSTRAINT inventory_adjustment_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- Name: inventory_adjustments inventory_adjustments_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustments
    ADD CONSTRAINT inventory_adjustments_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: inventory_adjustments inventory_adjustments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustments
    ADD CONSTRAINT inventory_adjustments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: inventory_adjustments inventory_adjustments_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustments
    ADD CONSTRAINT inventory_adjustments_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: inventory_movements inventory_movements_destination_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_destination_warehouse_id_fkey FOREIGN KEY (destination_warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: inventory_movements inventory_movements_product_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_product_variant_id_fkey FOREIGN KEY (product_variant_id) REFERENCES public.product_variants(id);


--
-- Name: inventory_movements inventory_movements_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id);


--
-- Name: inventory_movements inventory_movements_purchase_order_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_purchase_order_receipt_id_fkey FOREIGN KEY (purchase_order_receipt_id) REFERENCES public.purchase_order_receipts(id);


--
-- Name: inventory_movements inventory_movements_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- Name: inventory_movements inventory_movements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: inventory_movements inventory_movements_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: inventory inventory_product_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_product_variant_id_fkey FOREIGN KEY (product_variant_id) REFERENCES public.product_variants(id);


--
-- Name: inventory inventory_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- Name: inventory inventory_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: product_variants product_variants_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products products_base_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_base_unit_id_fkey FOREIGN KEY (base_unit_id) REFERENCES public.units(id);


--
-- Name: products products_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id);


--
-- Name: products products_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: projects projects_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: purchase_order_items purchase_order_items_product_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_product_variant_id_fkey FOREIGN KEY (product_variant_id) REFERENCES public.product_variants(id);


--
-- Name: purchase_order_items purchase_order_items_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id);


--
-- Name: purchase_order_items purchase_order_items_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- Name: purchase_order_receipt_items purchase_order_receipt_items_purchase_order_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_receipt_items
    ADD CONSTRAINT purchase_order_receipt_items_purchase_order_item_id_fkey FOREIGN KEY (purchase_order_item_id) REFERENCES public.purchase_order_items(id);


--
-- Name: purchase_order_receipt_items purchase_order_receipt_items_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_receipt_items
    ADD CONSTRAINT purchase_order_receipt_items_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.purchase_order_receipts(id);


--
-- Name: purchase_order_receipts purchase_order_receipts_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_receipts
    ADD CONSTRAINT purchase_order_receipts_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id);


--
-- Name: purchase_order_receipts purchase_order_receipts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_receipts
    ADD CONSTRAINT purchase_order_receipts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: purchase_order_receipts purchase_order_receipts_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_receipts
    ADD CONSTRAINT purchase_order_receipts_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: purchase_orders purchase_orders_approved_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_approved_by_id_fkey FOREIGN KEY (approved_by_id) REFERENCES public.users(id);


--
-- Name: purchase_orders purchase_orders_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: purchase_orders purchase_orders_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: purchase_orders purchase_orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: purchase_orders purchase_orders_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: sale_items sale_items_product_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT sale_items_product_variant_id_fkey FOREIGN KEY (product_variant_id) REFERENCES public.product_variants(id);


--
-- Name: sale_items sale_items_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT sale_items_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: sale_items sale_items_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT sale_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- Name: sales sales_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: sales sales_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: stock_alerts stock_alerts_product_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_alerts
    ADD CONSTRAINT stock_alerts_product_variant_id_fkey FOREIGN KEY (product_variant_id) REFERENCES public.product_variants(id);


--
-- Name: stock_alerts stock_alerts_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_alerts
    ADD CONSTRAINT stock_alerts_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: supplier_products supplier_products_product_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_products
    ADD CONSTRAINT supplier_products_product_variant_id_fkey FOREIGN KEY (product_variant_id) REFERENCES public.product_variants(id);


--
-- Name: supplier_products supplier_products_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_products
    ADD CONSTRAINT supplier_products_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: suppliers suppliers_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: tasks tasks_responsible_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_responsible_id_fkey FOREIGN KEY (responsible_id) REFERENCES public.users(id);


--
-- Name: user_roles user_roles_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: warehouses warehouses_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- PostgreSQL database dump complete
--

