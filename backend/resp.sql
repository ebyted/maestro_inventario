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



--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.alembic_version VALUES ('065c831b33a1');


--
-- Data for Name: attendance_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.brands VALUES (1, 1, 'Coca-Cola', 'Bebidas refrescantes', 'CC', 'México', true, '2025-07-06 18:09:31.879353+00', NULL);
INSERT INTO public.brands VALUES (2, 1, 'Bimbo', 'Productos de panadería', 'BIM', 'México', true, '2025-07-06 18:09:31.879353+00', NULL);
INSERT INTO public.brands VALUES (3, 1, 'Nestlé', 'Alimentos y bebidas', 'NES', 'Suiza', true, '2025-07-06 18:09:31.879353+00', NULL);
INSERT INTO public.brands VALUES (4, 1, 'Lala', 'Productos lácteos', 'LAL', 'México', true, '2025-07-06 18:09:31.879353+00', NULL);
INSERT INTO public.brands VALUES (5, 1, 'Maseca', 'Harinas y tortillas', 'MAS', 'México', true, '2025-07-06 18:09:31.879353+00', NULL);
INSERT INTO public.brands VALUES (6, 1, 'Fabuloso', 'Productos de limpieza', 'FAB', 'México', true, '2025-07-06 18:09:31.879353+00', NULL);
INSERT INTO public.brands VALUES (7, 2, 'SANFER', NULL, 'SANFER', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (8, 2, 'SBL', NULL, 'SBL', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (9, 2, 'SCHERING-PLOUGH', NULL, 'SCHERING-PLOUGH', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (10, 2, 'IFA', NULL, 'IFA', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (11, 2, 'SANOFI', NULL, 'SANOFI', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (12, 2, 'COLLINS', NULL, 'COLLINS', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (13, 2, 'AMSA', NULL, 'AMSA', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (14, 2, 'LABS LOPEZ', NULL, 'LABS_LOPEZ', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (15, 2, 'CHINOIN', NULL, 'CHINOIN', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (16, 2, 'GENOMALAB', NULL, 'GENOMALAB', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (17, 2, 'SANA-X', NULL, 'SANA-X', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (18, 2, 'BAYER', NULL, 'BAYER', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (19, 2, 'APOTEX', NULL, 'APOTEX', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (20, 2, 'RANDALL', NULL, 'RANDALL', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (21, 2, 'PHARMAGEN', NULL, 'PHARMAGEN', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (22, 2, 'GLAXO SMITH KLINE', NULL, 'GLAXO_SMITH_KLINE', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (23, 2, 'HORMONA', NULL, 'HORMONA', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (24, 2, 'HEALTH TEC', NULL, 'HEALTH_TEC', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.brands VALUES (25, 2, 'NOVAG', NULL, 'NOVAG', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (26, 2, 'TERAMED', NULL, 'TERAMED', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (27, 2, 'SONS', NULL, 'SONS', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (28, 2, 'LOEFFLER', NULL, 'LOEFFLER', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (29, 2, 'ULTRA', NULL, 'ULTRA', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (30, 2, 'BIOKEMICAL', NULL, 'BIOKEMICAL', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (31, 2, 'MAVER', NULL, 'MAVER', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (32, 2, 'SANDOZ', NULL, 'SANDOZ', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (33, 2, 'MAVI', NULL, 'MAVI', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (34, 2, 'DEGORTS CHEMICAL', NULL, 'DEGORTS_CHEMICAL', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (35, 2, 'PROSA', NULL, 'PROSA', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.brands VALUES (36, 2, 'GROSSMAN', NULL, 'GROSSMAN', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (37, 2, 'GENOMA', NULL, 'GENOMA', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (38, 2, 'BOEHRINGER INGELHEIM', NULL, 'BOEHRINGER_INGELHEIM', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (39, 2, 'PFIZER', NULL, 'PFIZER', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (40, 2, 'RAYERE', NULL, 'RAYERE', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (41, 2, 'LIOMONT', NULL, 'LIOMONT', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (42, 2, 'BRULUART', NULL, 'BRULUART', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (43, 2, 'BIOSEARCH', NULL, 'BIOSEARCH', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (44, 2, 'SIEGFRIED RHEIN', NULL, 'SIEGFRIED_RHEIN', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (45, 2, 'LILLY', NULL, 'LILLY', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.brands VALUES (46, 2, 'MEDICOR', NULL, 'MEDICOR', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (47, 2, 'ALTIA', NULL, 'ALTIA', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (48, 2, 'SAIMED', NULL, 'SAIMED', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (49, 2, 'VICTORY', NULL, 'VICTORY', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (50, 2, 'PSICOFARMA', NULL, 'PSICOFARMA', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (51, 2, 'BIOMEP', NULL, 'BIOMEP', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (52, 2, 'SERRAL', NULL, 'SERRAL', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (53, 2, 'ARMSTRON', NULL, 'ARMSTRON', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (54, 2, 'AVIVIA', NULL, 'AVIVIA', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (55, 2, 'EVOLUTION', NULL, 'EVOLUTION', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (56, 2, 'WYETH', NULL, 'WYETH', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (57, 2, 'GENETICA', NULL, 'GENETICA', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (58, 2, 'GEL PHARMA', NULL, 'GEL_PHARMA', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.brands VALUES (59, 2, 'AVITUS', NULL, 'AVITUS', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.brands VALUES (60, 2, 'ALCON', NULL, 'ALCON', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.brands VALUES (61, 2, 'NORDIN', NULL, 'NORDIN', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.brands VALUES (62, 2, 'PISA', NULL, 'PISA', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.brands VALUES (63, 2, 'CHEMICAL', NULL, 'CHEMICAL', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.brands VALUES (64, 2, 'NOVO PHARMA', NULL, 'NOVO_PHARMA', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.brands VALUES (65, 2, 'ARMSTRONG', NULL, 'ARMSTRONG', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.brands VALUES (66, 2, 'CARNOT LABORATORIOS', NULL, 'CARNOT_LABORATORIOS', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.brands VALUES (67, 2, 'ALMIRALL', NULL, 'ALMIRALL', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.brands VALUES (68, 2, 'WANDELL', NULL, 'WANDELL', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.brands VALUES (69, 2, 'MEDLEY', NULL, 'MEDLEY', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.brands VALUES (70, 2, 'KURAMEX', NULL, 'KURAMEX', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.brands VALUES (71, 2, 'VIVALIVE', NULL, 'VIVALIVE', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.brands VALUES (72, 2, 'SEGFREID RHEIN', NULL, 'SEGFREID_RHEIN', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.brands VALUES (73, 2, 'LIFERPAL', NULL, 'LIFERPAL', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.brands VALUES (74, 2, 'SILANES', NULL, 'SILANES', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.brands VALUES (75, 2, 'ANAHUAC', NULL, 'ANAHUAC', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.brands VALUES (76, 2, 'RIMSA', NULL, 'RIMSA', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (77, 2, 'SANDY', NULL, 'SANDY', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (78, 2, 'INDIO PAPAGO', NULL, 'INDIO_PAPAGO', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (79, 2, 'FARNAT', NULL, 'FARNAT', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (80, 2, 'SALUS', NULL, 'SALUS', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (81, 2, 'UCB DE MEXICO', NULL, 'UCB_DE_MEXICO', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (82, 2, 'ARANDA', NULL, 'ARANDA', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (83, 2, 'PLANTIMEX', NULL, 'PLANTIMEX', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (84, 2, 'YPENSA', NULL, 'YPENSA', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (85, 2, 'BEKA', NULL, 'BEKA', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (86, 2, 'STILLMAN', NULL, 'STILLMAN', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (87, 2, 'EKO', NULL, 'EKO', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (88, 2, 'JOHNSON & JOHNSON', NULL, 'JOHNSON_&_JOHNSON', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (89, 2, 'BEST', NULL, 'BEST', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.brands VALUES (90, 2, 'BIORESEARCH', NULL, 'BIORESEARCH', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (91, 2, 'DEGORTS', NULL, 'DEGORTS', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (92, 2, 'GN+VIDA', NULL, 'GN+VIDA', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (93, 2, 'ALPRIMA', NULL, 'ALPRIMA', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (94, 2, 'LA SALUD ES PRIMERO', NULL, 'LA_SALUD_ES_PRIMERO', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (95, 2, 'BIOMIRAL', NULL, 'BIOMIRAL', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (96, 2, 'AZTRA ZENECA', NULL, 'AZTRA_ZENECA', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (97, 2, 'BUSTILLOS', NULL, 'BUSTILLOS', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (98, 2, 'VALEANT', NULL, 'VALEANT', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (99, 2, 'ATANTLIS', NULL, 'ATANTLIS', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (100, 2, 'COLUMBIA', NULL, 'COLUMBIA', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (101, 2, 'COYOACAN QUIMICA', NULL, 'COYOACAN_QUIMICA', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.brands VALUES (102, 2, 'PERRIGO', NULL, 'PERRIGO', NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.brands VALUES (103, 2, 'DEGORTS/CHEMICAL', NULL, 'DEGORTS/CHEMICAL', NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.brands VALUES (104, 2, 'GENOMMA', NULL, 'GENOMMA', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.brands VALUES (105, 2, 'SANOFI AVENTIS', NULL, 'SANOFI_AVENTIS', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.brands VALUES (106, 2, 'MERCK', NULL, 'MERCK', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.brands VALUES (107, 2, 'PHARMADIOL', NULL, 'PHARMADIOL', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.brands VALUES (108, 2, 'JANSSEN', NULL, 'JANSSEN', NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.brands VALUES (109, 2, 'L. SERRAL', NULL, 'L._SERRAL', NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.brands VALUES (110, 2, 'GRISI', NULL, 'GRISI', NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.brands VALUES (111, 2, 'ALPHARMA', NULL, 'ALPHARMA', NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.brands VALUES (112, 2, 'NEOLPHARMA', NULL, 'NEOLPHARMA', NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.brands VALUES (113, 2, 'L HIGIA', NULL, 'L_HIGIA', NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.brands VALUES (114, 2, 'SALUD NATURAL', NULL, 'SALUD_NATURAL', NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.brands VALUES (115, 2, 'FARMA HISP', NULL, 'FARMA_HISP', NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.brands VALUES (116, 2, 'NYCOMED', NULL, 'NYCOMED', NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.brands VALUES (117, 2, 'TAKEDA', NULL, 'TAKEDA', NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.brands VALUES (118, 2, 'DR MONTFORT', NULL, 'DR_MONTFORT', NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.brands VALUES (119, 2, 'BRISTOL MYERS SQUIBB', NULL, 'BRISTOL_MYERS_SQUIBB', NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.brands VALUES (120, 2, 'MEDICA NATURAL', NULL, 'MEDICA_NATURAL', NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.brands VALUES (121, 2, 'ADAMS', NULL, 'ADAMS', NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.brands VALUES (122, 2, 'NOVARTIS', NULL, 'NOVARTIS', NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.brands VALUES (123, 2, 'ZOETIS', NULL, 'ZOETIS', NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.brands VALUES (124, 2, 'SOPHIA GENERICO', NULL, 'SOPHIA_GENERICO', NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.brands VALUES (125, 2, 'GSK', NULL, 'GSK', NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.brands VALUES (126, 2, 'BRISTOL-MYERS', NULL, 'BRISTOL-MYERS', NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.brands VALUES (127, 2, 'GELPHARMA', NULL, 'GELPHARMA', NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.brands VALUES (128, 2, 'LAB DB', NULL, 'LAB_DB', NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.brands VALUES (129, 2, 'GENOMMA LAB', NULL, 'GENOMMA_LAB', NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.brands VALUES (130, 2, 'JANSSEN-CILAG', NULL, 'JANSSEN-CILAG', NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.brands VALUES (131, 2, 'LOREN', NULL, 'LOREN', NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.brands VALUES (132, 2, 'PROCTER & GAMBLE', NULL, 'PROCTER_&_GAMBLE', NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.brands VALUES (133, 2, 'SANAX', NULL, 'SANAX', NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.brands VALUES (134, 2, 'LA FLOR', NULL, 'LA_FLOR', NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.brands VALUES (135, 2, 'QUIMPHARMA', NULL, 'QUIMPHARMA', NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.brands VALUES (136, 2, 'INV FARMACEUTICAS', NULL, 'INV_FARMACEUTICAS', NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.brands VALUES (137, 2, 'PNS', NULL, 'PNS', NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.brands VALUES (138, 2, 'L LOPEZ', NULL, 'L_LOPEZ', NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.brands VALUES (139, 2, 'SENOSIAIN', NULL, 'SENOSIAIN', NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.brands VALUES (140, 2, 'DIALICELS', NULL, 'DIALICELS', NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.brands VALUES (141, 2, 'BRISTOL-MYERS SQUIBB', NULL, 'BRISTOL-MYERS_SQUIBB', NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.brands VALUES (142, 2, 'FARMA HISPANO', NULL, 'FARMA_HISPANO', NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.brands VALUES (143, 2, 'URANIA', NULL, 'URANIA', NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.brands VALUES (144, 2, 'CMD', NULL, 'CMD', NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.brands VALUES (145, 2, 'PAILL', NULL, 'PAILL', NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.brands VALUES (146, 2, 'MYGRA', NULL, 'MYGRA', NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.brands VALUES (147, 2, 'LASALUD', NULL, 'LASALUD', NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.brands VALUES (148, 2, 'SOPHIA', NULL, 'SOPHIA', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.brands VALUES (149, 2, 'HOMEOPATICOS MILENIUM', NULL, 'HOMEOPATICOS_MILENIUM', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.brands VALUES (150, 2, 'TOGOCINO', NULL, 'TOGOCINO', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.brands VALUES (151, 2, 'ATLANTIS', NULL, 'ATLANTIS', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.brands VALUES (152, 2, 'MK', NULL, 'MK', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.brands VALUES (153, 2, 'ARANTIZ', NULL, 'ARANTIZ', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.brands VALUES (154, 2, 'SANOFI AVENTS', NULL, 'SANOFI_AVENTS', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.brands VALUES (155, 2, 'JALOMA', NULL, 'JALOMA', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.brands VALUES (156, 2, 'BAJAMED', NULL, 'BAJAMED', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.brands VALUES (157, 2, 'ORDONEZ', NULL, 'ORDONEZ', NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.brands VALUES (158, 2, 'LAB LOPEZ', NULL, 'LAB_LOPEZ', NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.brands VALUES (159, 2, 'CHIAPAS', NULL, 'CHIAPAS', NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.brands VALUES (160, 2, 'VICK', NULL, 'VICK', NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.brands VALUES (161, 2, 'COYOACAN QUIMICAS', NULL, 'COYOACAN_QUIMICAS', NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.brands VALUES (162, 2, 'IPAL', NULL, 'IPAL', NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.brands VALUES (163, 2, 'OFFENBACH', NULL, 'OFFENBACH', NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.brands VALUES (164, 2, 'WERMAR', NULL, 'WERMAR', NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.brands VALUES (165, 2, 'ANCALMO', NULL, 'ANCALMO', NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.brands VALUES (167, 2, 'ASOFARMA', 'Brand imported from CSV on 2025-07-06', 'ASOFARMA', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (168, 2, 'ASPEN', 'Brand imported from CSV on 2025-07-06', 'ASPEN', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (169, 2, 'BOEHRINGER INGELHEM', 'Brand imported from CSV on 2025-07-06', 'BOEHRINGER_INGELHEM', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (170, 2, 'BQM', 'Brand imported from CSV on 2025-07-06', 'BQM', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (171, 2, 'BREMER', 'Brand imported from CSV on 2025-07-06', 'BREMER', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (172, 2, 'BRULART', 'Brand imported from CSV on 2025-07-06', 'BRULART', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (173, 2, 'BRULUAGSA', 'Brand imported from CSV on 2025-07-06', 'BRULUAGSA', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (174, 2, 'CB LA PIEDAD', 'Brand imported from CSV on 2025-07-06', 'CB_LA_PIEDAD', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (175, 2, 'DINA', 'Brand imported from CSV on 2025-07-06', 'DINA', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (176, 2, 'EDERKA', 'Brand imported from CSV on 2025-07-06', 'EDERKA', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (177, 2, 'ENER GREEN', 'Brand imported from CSV on 2025-07-06', 'ENER_GREEN', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (178, 2, 'GELpharma', 'Brand imported from CSV on 2025-07-06', 'GELPHARMA', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (179, 2, 'GENOMMALAB', 'Brand imported from CSV on 2025-07-06', 'GENOMMALAB', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (180, 2, 'GISEL', 'Brand imported from CSV on 2025-07-06', 'GISEL', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (181, 2, 'GLUNOVAG', 'Brand imported from CSV on 2025-07-06', 'GLUNOVAG', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (182, 2, 'GRIN', 'Brand imported from CSV on 2025-07-06', 'GRIN', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (183, 2, 'GRUNENTHAL', 'Brand imported from CSV on 2025-07-06', 'GRUNENTHAL', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (184, 2, 'HALEON', 'Brand imported from CSV on 2025-07-06', 'HALEON', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (185, 2, 'IFA CELTICS', 'Brand imported from CSV on 2025-07-06', 'IFA_CELTICS', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (186, 2, 'IMPLEMEDIX', 'Brand imported from CSV on 2025-07-06', 'IMPLEMEDIX', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (187, 2, 'JASSEN-CILAG', 'Brand imported from CSV on 2025-07-06', 'JASSEN_CILAG', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (188, 2, 'KENDRICK', 'Brand imported from CSV on 2025-07-06', 'KENDRICK', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (189, 2, 'KENER', 'Brand imported from CSV on 2025-07-06', 'KENER', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (190, 2, 'LAKESIDE', 'Brand imported from CSV on 2025-07-06', 'LAKESIDE', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (191, 2, 'LANDSTEINER', 'Brand imported from CSV on 2025-07-06', 'LANDSTEINER', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (192, 2, 'MEGAMIX', 'Brand imported from CSV on 2025-07-06', 'MEGAMIX', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (193, 2, 'NATURAL FLOWER', 'Brand imported from CSV on 2025-07-06', 'NATURAL_FLOWER', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (194, 2, 'NORDIMEX', 'Brand imported from CSV on 2025-07-06', 'NORDIMEX', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (195, 2, 'NUCITEC', 'Brand imported from CSV on 2025-07-06', 'NUCITEC', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (196, 2, 'ORAL-B', 'Brand imported from CSV on 2025-07-06', 'ORAL_B', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (197, 2, 'PHARMA RX', 'Brand imported from CSV on 2025-07-06', 'PHARMA_RX', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (198, 2, 'PONDS', 'Brand imported from CSV on 2025-07-06', 'PONDS', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (199, 2, 'PROBIOMED', 'Brand imported from CSV on 2025-07-06', 'PROBIOMED', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (200, 2, 'PSICOPHARMA', 'Brand imported from CSV on 2025-07-06', 'PSICOPHARMA', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (201, 2, 'ROCHE', 'Brand imported from CSV on 2025-07-06', 'ROCHE', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (202, 2, 'SCHOEN', 'Brand imported from CSV on 2025-07-06', 'SCHOEN', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (203, 2, 'STREGER', 'Brand imported from CSV on 2025-07-06', 'STREGER', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (204, 2, 'SYNTEX', 'Brand imported from CSV on 2025-07-06', 'SYNTEX', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (205, 2, 'VITAE', 'Brand imported from CSV on 2025-07-06', 'VITAE', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (206, 2, 'WANDEL', 'Brand imported from CSV on 2025-07-06', 'WANDEL', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (207, 2, 'WESER PHARMA', 'Brand imported from CSV on 2025-07-06', 'WESER_PHARMA', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (208, 2, 'ZAMBON', 'Brand imported from CSV on 2025-07-06', 'ZAMBON', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.brands VALUES (210, 1, 'Marca de Prueba 113926', 'Marca creada por script de prueba', 'TEST_113926', NULL, true, '2025-07-06 18:39:28.817846+00', NULL);
INSERT INTO public.brands VALUES (166, 2, 'ACCORD', '', 'ACCORD', NULL, true, '2025-07-06 18:23:27.519771+00', '2025-07-06 23:16:18.191168+00');


--
-- Data for Name: business_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.business_users VALUES (1, 1, 1, 'ADMIN', true, '2025-07-06 18:09:31.84859+00');
INSERT INTO public.business_users VALUES (2, 1, 2, 'MANAGER', true, '2025-07-06 18:09:31.84859+00');
INSERT INTO public.business_users VALUES (3, 1, 3, 'EMPLOYEE', true, '2025-07-06 18:09:31.84859+00');
INSERT INTO public.business_users VALUES (4, 4, 4, 'EMPLOYEE', true, '2025-07-07 05:17:51.960368+00');
INSERT INTO public.business_users VALUES (5, 4, 5, 'EMPLOYEE', true, '2025-07-07 05:34:28.113084+00');
INSERT INTO public.business_users VALUES (6, 4, 6, 'EMPLOYEE', true, '2025-07-07 05:34:28.113084+00');


--
-- Data for Name: businesses; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.businesses VALUES (1, 'Tienda Maestro', 'Tienda de abarrotes y productos diversos', 'TM001', 'RFC123456789', NULL, 'Av. Principal 123, Ciudad, Estado', '555-0123', 'info@maestroinventario.com', true, '2025-07-06 18:09:31.837843+00', NULL);
INSERT INTO public.businesses VALUES (2, 'Default Business', NULL, 'DEFAULT_BUSINESS', NULL, NULL, NULL, NULL, NULL, true, '2025-07-06 18:11:16.23098+00', NULL);
INSERT INTO public.businesses VALUES (4, 'Maestro Inventario', 'Negocio principal para pruebas', 'MI001', 'XAXX010101000', 'XAXX010101000', 'Dirección de prueba', '0000000000', 'admin@maestro.com', true, '2025-07-07 05:17:51.960368+00', NULL);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categories VALUES (1, 1, 'Abarrotes', 'Productos básicos de despensa', 'ABR', NULL, true, '2025-07-06 18:09:31.867493+00', NULL);
INSERT INTO public.categories VALUES (2, 1, 'Bebidas', 'Bebidas alcohólicas y no alcohólicas', 'BEB', NULL, true, '2025-07-06 18:09:31.867493+00', NULL);
INSERT INTO public.categories VALUES (3, 1, 'Lácteos', 'Productos lácteos y derivados', 'LAC', NULL, true, '2025-07-06 18:09:31.867493+00', NULL);
INSERT INTO public.categories VALUES (4, 1, 'Carnes', 'Carnes rojas, blancas y embutidos', 'CAR', NULL, true, '2025-07-06 18:09:31.867493+00', NULL);
INSERT INTO public.categories VALUES (5, 1, 'Frutas y Verduras', 'Productos frescos', 'FYV', NULL, true, '2025-07-06 18:09:31.867493+00', NULL);
INSERT INTO public.categories VALUES (6, 1, 'Limpieza', 'Productos de limpieza e higiene', 'LIM', NULL, true, '2025-07-06 18:09:31.867493+00', NULL);
INSERT INTO public.categories VALUES (7, 2, 'ASMA / BRONCOESPASMO', NULL, 'ASMA_/_BRONCOESPASMO', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (8, 2, 'ANALGESICO OPIODE', NULL, 'ANALGESICO_OPIODE', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (9, 2, 'ANTIGRIPALES', NULL, 'ANTIGRIPALES', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (10, 2, 'SUPLEMENTOS', NULL, 'SUPLEMENTOS', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (11, 2, 'PERDIDA PESO', NULL, 'PERDIDA_PESO', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (12, 2, 'VITAMINA', NULL, 'VITAMINA', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (13, 2, 'ANTI ACIDO', NULL, 'ANTI_ACIDO', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (14, 2, 'ANTI HIPERTENSIVO', NULL, 'ANTI_HIPERTENSIVO', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (15, 2, 'CORTICOESTEROIDE', NULL, 'CORTICOESTEROIDE', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (16, 2, 'DESCONGESTIVO NASAL', NULL, 'DESCONGESTIVO_NASAL', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (17, 2, 'ANTIINFLAMATORIO', NULL, 'ANTIINFLAMATORIO', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (18, 2, 'GOTA', NULL, 'GOTA', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (19, 2, 'ANTITUSIGENO', NULL, 'ANTITUSIGENO', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (20, 2, 'ANTIBIOTICO', NULL, 'ANTIBIOTICO', NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.categories VALUES (21, 2, 'ANTIBIOTICO/ANTIGRIPAL', NULL, 'ANTIBIOTICO/ANTIGRIPAL', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (22, 2, 'HIPERPLASIA PROSTATICA', NULL, 'HIPERPLASIA_PROSTATICA', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (23, 2, 'ANALGESICO', NULL, 'ANALGESICO', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (24, 2, 'DIABETES MELLITUS', NULL, 'DIABETES_MELLITUS', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (25, 2, 'QUEMADURA', NULL, 'QUEMADURA', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (26, 2, 'COLESTEROL', NULL, 'COLESTEROL', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (27, 2, 'ANTIHISTAMINICO', NULL, 'ANTIHISTAMINICO', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (28, 2, 'INFECCION ORINA', NULL, 'INFECCION_ORINA', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (29, 2, 'ANTIBIOTICO TOPICO', NULL, 'ANTIBIOTICO_TOPICO', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (30, 2, 'SUPLEMENTO', NULL, 'SUPLEMENTO', NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.categories VALUES (31, 2, 'HIDRATAR PIEL', NULL, 'HIDRATAR_PIEL', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (32, 2, 'HORMONA', NULL, 'HORMONA', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (33, 2, 'ANTIGRIPAL', NULL, 'ANTIGRIPAL', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (34, 2, 'NAUSEAS/VOMITO', NULL, 'NAUSEAS/VOMITO', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (35, 2, 'HERPES BUCAL', NULL, 'HERPES_BUCAL', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (36, 2, 'ANALGESICO TOPICO', NULL, 'ANALGESICO_TOPICO', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (37, 2, 'ANTIMICOTICO', NULL, 'ANTIMICOTICO', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (38, 2, 'ANTIHIPERTENSIVO', NULL, 'ANTIHIPERTENSIVO', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (39, 2, 'EPILEPSIA', NULL, 'EPILEPSIA', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (40, 2, 'DISFUNSION ERECTIL', NULL, 'DISFUNSION_ERECTIL', NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.categories VALUES (41, 2, 'FUEGO LABIAL', NULL, 'FUEGO_LABIAL', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.categories VALUES (42, 2, 'ANALGESICO OPIOIDE', NULL, 'ANALGESICO_OPIOIDE', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.categories VALUES (43, 2, 'BENZODIACEPINA', NULL, 'BENZODIACEPINA', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.categories VALUES (44, 2, 'ANTIVIRAL', NULL, 'ANTIVIRAL', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.categories VALUES (45, 2, 'HIPERTENSION ARTERIAL', NULL, 'HIPERTENSION_ARTERIAL', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.categories VALUES (46, 2, 'HIPERTENSION', NULL, 'HIPERTENSION', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.categories VALUES (47, 2, 'Antibiotico', NULL, 'ANTIBIOTICO', NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.categories VALUES (48, 2, 'DESINFLAMATORIO', NULL, 'DESINFLAMATORIO', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.categories VALUES (49, 2, 'DESCONGESTIVO', NULL, 'DESCONGESTIVO', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.categories VALUES (50, 2, 'DOLOR', NULL, 'DOLOR', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.categories VALUES (51, 2, 'GRIPA', NULL, 'GRIPA', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.categories VALUES (52, 2, 'ESTRENIMIENTO', NULL, 'ESTRENIMIENTO', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.categories VALUES (53, 2, 'MALESTAR ESTOMACAL', NULL, 'MALESTAR_ESTOMACAL', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.categories VALUES (54, 2, 'ANSIOLITICO / DORMIR', NULL, 'ANSIOLITICO_/_DORMIR', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.categories VALUES (55, 2, 'ASMA', NULL, 'ASMA', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.categories VALUES (56, 2, 'DISFUNCION ERECTIL', NULL, 'DISFUNCION_ERECTIL', NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.categories VALUES (57, 2, 'DIABETES', NULL, 'DIABETES', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.categories VALUES (58, 2, 'ANTIBIOTC0', NULL, 'ANTIBIOTC0', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.categories VALUES (59, 2, 'BAJAR PESO', NULL, 'BAJAR_PESO', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.categories VALUES (60, 2, 'LAXANTE', NULL, 'LAXANTE', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.categories VALUES (61, 2, 'QUEMADURAS Y COMEZON', NULL, 'QUEMADURAS_Y_COMEZON', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.categories VALUES (62, 2, 'DOLOR GARGANTA', NULL, 'DOLOR_GARGANTA', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.categories VALUES (63, 2, 'ANALGESICO.', NULL, 'ANALGESICO.', NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.categories VALUES (64, 2, 'ASEO PERSONAL', NULL, 'ASEO_PERSONAL', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.categories VALUES (65, 2, 'INSUMOS', NULL, 'INSUMOS', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.categories VALUES (66, 2, 'ACEITES', NULL, 'ACEITES', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.categories VALUES (67, 2, 'ALERGIA CUTANEA', NULL, 'ALERGIA_CUTANEA', NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.categories VALUES (68, 2, 'DULCE', NULL, 'DULCE', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.categories VALUES (69, 2, 'CHUPON', NULL, 'CHUPON', NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.categories VALUES (70, 2, 'CREMA ACLARADORA', NULL, 'CREMA_ACLARADORA', NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.categories VALUES (71, 2, 'QUEMADURAS', NULL, 'QUEMADURAS', NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.categories VALUES (72, 2, 'ANTICONCEPTIVO', NULL, 'ANTICONCEPTIVO', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.categories VALUES (73, 2, 'ESTEROIDE TOPICO', NULL, 'ESTEROIDE_TOPICO', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.categories VALUES (74, 2, 'ANTIVERRUGAS', NULL, 'ANTIVERRUGAS', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.categories VALUES (75, 2, 'ANTIFUNGICO', NULL, 'ANTIFUNGICO', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.categories VALUES (76, 2, 'HEMORROIDE', NULL, 'HEMORROIDE', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.categories VALUES (77, 2, 'DOLOR MUSCULAR', NULL, 'DOLOR_MUSCULAR', NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.categories VALUES (78, 2, 'NAUSEAS/VOMITO/MAREO', NULL, 'NAUSEAS/VOMITO/MAREO', NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.categories VALUES (79, 2, 'ANTIESPAMODICO', NULL, 'ANTIESPAMODICO', NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.categories VALUES (80, 2, 'HIPOTIROIDISMO', NULL, 'HIPOTIROIDISMO', NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.categories VALUES (81, 2, 'VERRUGAS/CALLOS', NULL, 'VERRUGAS/CALLOS', NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.categories VALUES (82, 2, 'ANTIACIDO', NULL, 'ANTIACIDO', NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.categories VALUES (83, 2, 'HIGIENE PERSONAL', NULL, 'HIGIENE_PERSONAL', NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.categories VALUES (84, 2, 'ANTISEPTICO ORAL', NULL, 'ANTISEPTICO_ORAL', NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.categories VALUES (85, 2, 'INSUMOS MEDICOS', NULL, 'INSUMOS_MEDICOS', NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.categories VALUES (86, 2, 'ANTIDIARREICO', NULL, 'ANTIDIARREICO', NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.categories VALUES (87, 2, 'ANTIINFLAMATORIO TOPICO', NULL, 'ANTIINFLAMATORIO_TOPICO', NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.categories VALUES (88, 2, 'OFTALMICO', NULL, 'OFTALMICO', NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.categories VALUES (89, 2, 'ANTIFUGICO', NULL, 'ANTIFUGICO', NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.categories VALUES (90, 2, 'ANTICOCEPTIVO', NULL, 'ANTICOCEPTIVO', NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.categories VALUES (91, 2, 'ANESTESICO TOPICO', NULL, 'ANESTESICO_TOPICO', NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.categories VALUES (92, 2, 'ANTIDEPRESIVO', NULL, 'ANTIDEPRESIVO', NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.categories VALUES (93, 2, 'BARRERA PARA PIEL', NULL, 'BARRERA_PARA_PIEL', NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.categories VALUES (94, 2, 'INDIGESTION', NULL, 'INDIGESTION', NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.categories VALUES (95, 2, 'VERRUGAS', NULL, 'VERRUGAS', NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.categories VALUES (96, 2, 'DISLIPIDEMIA', NULL, 'DISLIPIDEMIA', NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.categories VALUES (97, 2, 'DEFICIENCIA DE TESTOSTERONA', NULL, 'DEFICIENCIA_DE_TESTOSTERONA', NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.categories VALUES (98, 2, 'COLITIS', NULL, 'COLITIS', NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.categories VALUES (99, 2, 'SARNA', NULL, 'SARNA', NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.categories VALUES (100, 2, 'OJO ROJO', NULL, 'OJO_ROJO', NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.categories VALUES (101, 2, 'HERPES LABIAL', NULL, 'HERPES_LABIAL', NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.categories VALUES (102, 2, 'DEFICIENCIA DE TESTOTERONA', NULL, 'DEFICIENCIA_DE_TESTOTERONA', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.categories VALUES (103, 2, 'HERIDAS', NULL, 'HERIDAS', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.categories VALUES (104, 2, 'FUNGICIDA', NULL, 'FUNGICIDA', NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.categories VALUES (105, 2, 'ANTBIOTICO', 'Category imported from CSV on 2025-07-06', 'ANTBIOTICO', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.categories VALUES (106, 2, 'ANTINFLAMATORIO', 'Category imported from CSV on 2025-07-06', 'ANTINFLAMATORIO', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.categories VALUES (107, 2, 'DOLOR CABEZA', 'Category imported from CSV on 2025-07-06', 'DOLOR_CABEZA', NULL, true, '2025-07-06 18:23:27.519771+00', NULL);
INSERT INTO public.categories VALUES (109, 1, 'Categoría de Prueba 113924', 'Categoría creada por script de prueba', 'TEST_113924', NULL, true, '2025-07-06 18:39:26.744288+00', NULL);


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: inventory_adjustment_items; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: inventory_adjustments; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: inventory_movements; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.inventory_movements VALUES (1, 1, 1, 7, 3, 'ENTRY', 100, 12, 0, 100, NULL, NULL, 'INIT-001', 'Stock inicial', 'Inventario inicial del sistema', NULL, NULL, NULL, '2025-07-06 18:09:32.099261+00');
INSERT INTO public.inventory_movements VALUES (2, 1, 2, 7, 3, 'ENTRY', 75, 25, 0, 75, NULL, NULL, 'INIT-002', 'Stock inicial', 'Inventario inicial del sistema', NULL, NULL, NULL, '2025-07-06 18:09:32.099261+00');
INSERT INTO public.inventory_movements VALUES (3, 1, 1, 7, 3, 'EXIT', 15, 12, 100, 85, NULL, NULL, 'SALE-001', 'Venta', 'Venta a cliente', NULL, NULL, NULL, '2025-07-06 18:09:32.099261+00');
INSERT INTO public.inventory_movements VALUES (4, 1, 1, 7, 4, 'ENTRY', 1, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL, NULL, NULL, '2025-07-08 17:06:27.300297+00');


--
-- Data for Name: login_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.login_attempts VALUES (1, 'admin@maestro.com', '::1', true, '2025-07-08 08:13:42.39904');
INSERT INTO public.login_attempts VALUES (2, 'admin@maestro.com', '::1', true, '2025-07-08 14:34:37.879013');
INSERT INTO public.login_attempts VALUES (3, 'admin@maestro.com', '::1', true, '2025-07-08 14:36:52.068328');
INSERT INTO public.login_attempts VALUES (4, 'admin@maestro.com', '::1', true, '2025-07-08 14:50:05.119384');
INSERT INTO public.login_attempts VALUES (5, 'admin@maestro.com', '::1', true, '2025-07-08 16:01:40.706623');
INSERT INTO public.login_attempts VALUES (6, 'admin@maestro.com', '::1', true, '2025-07-08 16:53:25.057231');


--
-- Data for Name: offices; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_variants VALUES (1, 1, 'Coca-Cola 600ml', 'CC-600', NULL, NULL, 12, 18, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.product_variants VALUES (2, 1, 'Coca-Cola 2L', 'CC-2L', NULL, NULL, 25, 35, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.product_variants VALUES (3, 2, 'Leche Lala Entera 1L', 'LL-1L', NULL, NULL, 18, 25, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.product_variants VALUES (4, 2, 'Leche Lala Deslactosada 1L', 'LL-DL-1L', NULL, NULL, 22, 30, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.product_variants VALUES (5, 3, 'Pan Blanco Grande', 'PB-BG', NULL, NULL, 28, 38, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.product_variants VALUES (6, 3, 'Pan Integral', 'PB-INT', NULL, NULL, 32, 42, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.product_variants VALUES (7, 4, 'Harina Maseca 1kg', 'HM-1K', NULL, NULL, 18, 25, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.product_variants VALUES (8, 4, 'Harina Maseca 4kg', 'HM-4K', NULL, NULL, 65, 85, true, '2025-07-06 18:09:31.973069+00', NULL);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES (1, 1, 2, 1, 'Coca-Cola', 'Producto Coca-Cola', 'PROD-001', NULL, 7, 5, 100, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.products VALUES (2, 1, 3, 4, 'Leche Lala', 'Producto Leche Lala', 'PROD-002', NULL, 7, 5, 100, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.products VALUES (3, 1, 1, 2, 'Pan Bimbo', 'Producto Pan Bimbo', 'PROD-003', NULL, 7, 5, 100, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.products VALUES (4, 1, 1, 5, 'Harina Maseca', 'Producto Harina Maseca', 'PROD-004', NULL, 7, 5, 100, true, '2025-07-06 18:09:31.973069+00', NULL);
INSERT INTO public.products VALUES (5, 2, 7, 7, 'AEROFLUX SALBUTAMOL 120ML SALBUTAMOL , AMBROXOL (SANFER) (1)', NULL, '1', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (6, 2, 8, 8, 'ADIOLOL 100MG C/50 + 50 DUO CAPS TRAMADOL (SBL) (2)', NULL, '2', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (7, 2, 9, 9, 'AFRINEX ACTIVE C/20 TABS  CLORFENAMINA/FENILEFRINA/PARACETAMOL (SCHERING-PLOUGH)', NULL, '3', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (8, 2, 10, NULL, 'AJO KING C/100 TABS (PLANTAS MEDICINALES DE MEXICO) (4)', NULL, '4', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (9, 2, 11, 10, 'ACXION 30MG C/30 TABS FENTERMINA (IFA) (5)', NULL, '5', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (10, 2, 12, 11, 'ADEROGYL 15 C/1 AMP (SANOFI) (6)', NULL, '6', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (11, 2, 13, 12, 'ALBOZ  OMEPRAZOL DUOS C/60 + 60 CAPS  (COLLINS) (7)', NULL, '7', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (12, 2, 14, 13, 'LOSARTAN 50MG C/30 TABS (AMSA) (8)', NULL, '8', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (13, 2, 9, 14, 'ALERFIN EXHIBIDOR C/200 TABS (LABORATORIOS LOPEZ) (9) X', NULL, '9', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (14, 2, 15, 15, 'ALIN SOL INY 8MG/2ML DEXAMETASONA (CHINOIN) (10)', NULL, '10', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (15, 2, 16, 15, 'ALIN NASAL 20ML GOTAS DEXAMETASONA, NEOMICINA , FENILEFRINA (CHINOIN) (11)', NULL, '11', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (16, 2, 17, 15, 'ALIN OFTALMICO 5ML DEXAMETASONA, NEOMICINA (CHINOIN) (12)', NULL, '12', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (17, 2, 16, 15, 'ALIN 0.75MG C/30 TABS DEXAMETASONA (CHINOIN) (13)', NULL, '13', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (18, 2, 17, 16, 'ALIVIAX 550MG C/10 TABS NAPROXENO SODICO (GENOMMA LAB) (14)', NULL, '14', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (19, 2, NULL, 17, 'BICARBONATO DE SODIO PURO 100GR (Ayesha)  (15)', NULL, '15', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (20, 2, 13, 18, 'ALKA-SELTZER C/12 TABS (BAYER) (16)', NULL, '16', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (21, 2, 18, 19, 'ALOPURINOL 300MG C/20 TABS (APOTEX)', NULL, '17', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (22, 2, 19, 20, 'AMBROXOL 120 ML (LOEFFLER) (18)', NULL, '18', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (23, 2, 19, 21, 'AMBROXOL 30ML PEDIATRICO (PHARMAGEN) (19)', NULL, '19', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (24, 2, 20, 13, 'AMCEF 1G I.M CEFTRIAXONA (AMSA) (20)', NULL, '20', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (25, 2, 20, 22, 'AMOXIBRON 250MG SUSP AMOXICILINA, BROMHEXINA (GLAXO SMITH KLINE) (21)', NULL, '21', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (26, 2, 20, 23, 'AMOXICILINA 250MG SUSP  (HORMONA) (22)', NULL, '22', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (27, 2, 20, 24, 'AMOXICILINA 500MG C/100 CAPS BIOTICILINA  (HEALTH TEC) (23)', NULL, '23', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (28, 2, 20, 23, 'AMPICILINA 250MG SUSP (HORMONA)(24)', NULL, '24', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:31.579651+00', NULL);
INSERT INTO public.products VALUES (29, 2, 21, 12, 'AMPIGRIN ADULTO C/3 INY AMPICILINA, METAMIZOL, GUAIFENESINA, LIDOCAINA (COLLINS) (25)', NULL, '25', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (30, 2, 21, 12, 'AMPIGRIN INFANTIL  60ML AMANTADINA, CLORFENAMINA,PARACETAMOL (COLLINS) (26)', NULL, '26', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (31, 2, 21, 12, 'AMPIGRIN PFC C/24 TABS AMANTADINA,CLORFENAMINA,PARACETAMOL (COLLINS) (27)', NULL, '27', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (32, 2, 21, 12, 'AMPIGRIN PFC PEDIATRICO 30ML AMANTADINA,CLORFENAMINA,PARACETAMOL (COLLINS) (28)', NULL, '28', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (33, 2, 22, 25, 'AMZUVAG 0.4MG C/20 TABS TAMSULOSINA (NOVAG) (29)', NULL, '29', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (34, 2, 23, 26, 'ANA-DENT C/100 TABS (LABORATORIOS TERAMED) (30)', NULL, '30', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (35, 2, 24, 12, 'Anglucid 850mg c/30 Caps Metformina (Collins)', NULL, '31', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (36, 2, 23, 27, 'ARDOSONS C/20 CAPS INDOMETACINA, BETAMETASONA, METOCARBAMOL (SON''S) (32)', NULL, '32', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (37, 2, 25, 28, 'ARGEMOL 1% CREMA 28G SULFADIAZINA DE PLATA (LOEFFLER) (33)', NULL, '33', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (38, 2, 17, 29, 'ARIFLAM 100MG C/20 TABS DICLOFENACO (ULTRA) (34)', NULL, '34', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (39, 2, 17, 30, 'ARTRIBION C/80 CAPSULAS DICLOFENACO, TIAMINA, PIRIDOXINA, CIANOCOBALAMINA (BIOKEMICAL) (35)', NULL, '35', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (40, 2, 23, 18, 'ASPIRINA 500MG C/100 TABS  (BAYER) (36)', NULL, '36', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (41, 2, 26, NULL, 'ALINA  20MG C/100 TABS ATORVASTATINA (', NULL, '37', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (42, 2, 20, 18, 'AMOBAY 500MG C/15 CAPS  AMOXICILINA ACIDO CLAVULANICO (BAYER)', NULL, '38', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (43, 2, 17, 31, 'FLEXIVER 15MG C/10 TABS MELOXICAM (MAVER) (39)', NULL, '39', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (44, 2, 27, 32, 'AVAPENA 25MG C/20 TABS CLOROPIRAMINA (SANDOZ) (40)', NULL, '40', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (45, 2, 20, 33, 'AZIBIOT 500MG  C/3 TABS AZITROMICINA  (MAVI) (41)', NULL, '41', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (46, 2, 28, 34, 'AZOGEN C/20 TABS ACIDO NALIDIXICO, FENAZOPIRIDINA (DEGORT''S CHEMICAL) (42)', NULL, '42', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (47, 2, 20, 31, 'BACTIVER 100ML SULFAMETOXAZOL/ TRIMETROPRIMA ( MAVER) (43)', NULL, '43', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (48, 2, 20, 27, 'BARMICIL 40G BETAMETASONA, GENTAMICINA, CLOTRIMAZOL (SON''S) (44)', NULL, '44', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (49, 2, 29, 18, 'BAYCUTEN 30G CLOTRIMAZOL, DEXAMETASONA (BAYER) (45)', NULL, '45', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (50, 2, 30, 35, 'BACAOMAX 340ML ACEITE HIGADO DE BACALAO (PROSA) (46)', NULL, '46', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.131756+00', NULL);
INSERT INTO public.products VALUES (51, 2, 12, 36, 'BEDOYECTA CAPSULAS C/30 VITAMINAS Y MINERALES (GROSSMAN) (47)', NULL, '47', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (52, 2, 20, 13, 'BENCILPENICILINA 1,200,000 U (AMSA) (48)', NULL, '48', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (53, 2, 31, 18, 'BEPANTHEN 100G DEXPANTENOL (BAYER) (49)', NULL, '49', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (54, 2, 32, 18, 'BINODIAN DEPOT INY 200MG PRASTERONA, ESTRADIOL (BAYER) (50)', NULL, '50', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (55, 2, 33, 37, 'BIO-ELECTRO MIGRANA C/24 TABS PARACETAMOL, ACIDO ACETILSALICILICO, CAFEINA (GENOMMA)(51)', NULL, '51', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (56, 2, 19, 38, 'BISOLVON ADULTO 120ML BROMHEXINA (BOEHRINGER INGELHEIM) (52)', NULL, '52', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (57, 2, 19, 38, 'BISOLVON INFANTIL 120ML BROMHEXINA (BOEHRINGER INGELHEIM)  (53)', NULL, '53', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (58, 2, 34, 39, 'BONADOXINA 120ML MECLIZINA, PIRIDOXINA (PFIZER) (54)', NULL, '54', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (59, 2, 34, 39, 'BONADOXINA C/5 AMP MECLIZINA, PIRIDOXINA (PFIZER) (55)', NULL, '55', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (60, 2, 34, 39, 'BONADOXINA C/25 TABS MECLIZINA, PIRIDOXINA (PFIZER) (56)', NULL, '56', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (61, 2, 34, 39, 'BONADOXINA 20ML MECLIZINA, PIRIDOXINA (PFIZER) (57)', NULL, '57', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (62, 2, 30, NULL, 'BonaProst 760mg c/60 Caps (Nature''s ´P.e.t. ) (58)', NULL, '58', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (63, 2, 19, 40, 'BROGAL T ADULTO 120ML DEXTROMETORFANO/ AMBROXOL (RAYERE) (59)', NULL, '59', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (64, 2, 19, 40, 'BROGAL T INFANTIL 120ML DEXTROMETORFANO/ AMBROXOL (RAYERE) (60)', NULL, '60', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (65, 2, 35, 31, 'BENZOCAINA  BUCAL 9.7ML (MAVER) (61)', NULL, '61', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (66, 2, 36, 31, 'LUMBOXEN GEL ROJO 35G NAPROXENO, LIDOCAINA (MAVER) (62)', NULL, '62', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (67, 2, 23, 38, 'BUSCAPINA COMP C/36 TABS BUTILlHIOSCINA o HIOSCINA , METAMIZOL SODICO (BOEHRINGER)  (63)', NULL, '63', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (68, 2, 23, 38, 'BUSCAPINA 10MG C/24 TABS BUTILIHIOSCINA O HIOSCINA, PARACETAMOL (BOEHRINGER INGELHEIM) (64)', NULL, '64', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (69, 2, 23, 39, 'LYRICA 75MG C/14 CAPS PREGABALINA (PFIZER) (65)', NULL, '65', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (70, 2, 12, 11, 'CALCIGENOL DOBLE SUSP 340ML (SANOFI)  (66)', NULL, '66', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (71, 2, 37, 41, 'CANDIFLUX 150MG C/1 CAP FLUCONAZOL (LIOMONT) (67)', NULL, '67', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (72, 2, 37, 18, 'CANESTEN 30G CREMA  CLOTRIMAZOL(BAYER) (68)', NULL, '68', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (73, 2, 38, 42, 'BRUCAP 25MG C/30 TABS CAPTOPRIL (BRULUART)', NULL, '69', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (74, 2, 39, 43, 'BIONEURIL c/20 TABS. 200 MG. (BIORESEARCH) (70)', NULL, '70', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (75, 2, 20, 13, 'CEFALEXINA (Amsa) SUSP. Fco. 100 ML. 250 MG/5 ML.', NULL, '71', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (76, 2, 20, 13, 'CEFALEXINA (Amsa) c/20 CAPS. 500 MG.', NULL, '72', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (77, 2, 20, 44, 'CEFTREX 1GR IM', NULL, '73', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (78, 2, 33, 9, 'CELESTAMINE NS 60ML LORATADINA/ BETAMETASONA (SCHERING-PLOUGH)', NULL, '74', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (79, 2, 33, 9, 'CELESTAMINE NS C/10 TABS 5.0MG/0.25MG LORATADINA/BETAMETASONA (SCHERING-PLOUGH)', NULL, '75', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (80, 2, 33, 9, 'CELESTAMINE NS C/20 TABS 5.0MG/0.25MG LORATADINA/ BETAMETASONA (SCHERING-PLOUGH)', NULL, '76', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (81, 2, 40, 45, 'CIALIS 20MG C/1 (LILLY)', NULL, '77', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:32.596194+00', NULL);
INSERT INTO public.products VALUES (82, 2, 41, 41, 'CICLOFERON 2G CREMA ACICLOVIR (LIOMONT)', NULL, '78', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (83, 2, 20, 12, 'CIGMADIL 300MG C/16 CAPS CLINDAMICINA (COLLINS)', NULL, '79', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (84, 2, NULL, 46, 'CINERARIA MARITIMA 10ML (MEDICOR)', NULL, '80', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (85, 2, 20, 47, 'CIPROFLOX 500MG C/12 CAPS CIPROFLOXACINO (ALTIA)', NULL, '81', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (86, 2, 20, 48, 'CIPROFLOXACINO 500MG C/100 CAPS (SAIMED) G', NULL, '82', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (87, 2, 20, 13, 'CIPROFLOXACINO 500MG C/14 TABS  (AMSA)', NULL, '83', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (88, 2, 42, 49, 'CITRA 100MG C/120 TABS TRAMADOL (VICTORY)', NULL, '84', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (89, 2, 42, 49, 'CITRA 100MG C/60 TABS TRAMADOL (VICTORY)', NULL, '85', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (90, 2, 17, 49, 'CLONAFEC C/120 TABS DICLOFENACO (VICTORY)', NULL, '86', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (91, 2, 43, 50, 'CLONAZEPAM 10ML GOTAS (PSICOFARMA)', NULL, '87', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (92, 2, 43, 50, 'CLONAZEPAM 2MG C/100 TABS (PSICOFARMA)', NULL, '88', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (93, 2, 43, 50, 'CLONAZEPAM 2MG C/30 TABS (PSICOFARMA)', NULL, '89', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (94, 2, 43, 50, 'CLONAZEPAM 2MG C/60 TABS (PSICOFARMA)', NULL, '90', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (95, 2, NULL, 7, 'A.S. COR 24ml GOTAS (SANFER)', NULL, '91', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (96, 2, NULL, 42, 'ABRUNT 5MG C/10 TABS DESLORATADINA (BRULUART)', NULL, '92', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (97, 2, NULL, 32, 'ACC 600MG C/20 TABS EFERVECENTES ACETILCISTEINA (SANDOZ)', NULL, '93', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (98, 2, NULL, 40, 'Acetafen 500mg c/12 Tabs Paracetamol (Rayere)', NULL, '94', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (99, 2, NULL, 40, 'Acetafen 750mg c/12 Tabs Paracetamol (Rayere)', NULL, '95', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (100, 2, NULL, NULL, 'BUSCAPINA DUO C/10 HIOSCINA /PARACETAMOL (BOEHRINGER INGELHEIM)', NULL, '96', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (101, 2, 23, 51, 'BRAX 200/275MG C/10 TABS NAPROXENO SODICO/PARACETAMOL (BIOMEP)', NULL, '97', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (102, 2, 17, 44, 'FEBRAX SUSP 100ML NAPROXENO SODICO , PARACETAMOL (SIEGFRIED RHEIN)', NULL, '98', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (103, 2, 44, 13, 'ACICLOVIR 400MG C/35 TABS (AMSA)', NULL, '99', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (104, 2, 44, 41, 'CICLOFERON CREMA 10G ACICLOVIR (LIOMONT)', NULL, '100', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (105, 2, 44, 41, 'CICLOFERON 200MG C/25 TABS ACICLOVIR (LIOMONT)', NULL, '101', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (106, 2, 44, 49, 'CLORIXAN 800MG C/50 TABS ACICLOVIR (VICTORY)', NULL, '102', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (107, 2, 44, 41, 'CICLOFERON 200MG/5ML ACICLOVIR SUSPENSION (LIOMONT)', NULL, '103', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (108, 2, 44, 52, 'VALACICLOVIR 500MG C/10 TABS ACICLOVIR (SERRAL)', NULL, '104', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (109, 2, 44, 53, 'ACOMEXOL 30G CREMA  (ARMSTRONG)', NULL, '105', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (110, 2, 45, 49, 'ACORTIZ  25MG C/100 TABS HIDROCLOROTIAZIDA (VICTORY)', NULL, '106', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (111, 2, 45, 31, 'CO-TARSAN C/30 COMPS. 50/12.5 MG. LOSARTAN/HIDROCLOROTIAZIDA (MAVER)', NULL, '107', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (112, 2, 45, 54, 'LOSARTAN/HIDROCLOROTIAZIDA 50MG/25MG C/15 TABS (AVIVIA)', NULL, '108', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (113, 2, 45, 13, 'LOSARTÁN/HIDROCLOROTIAZIDA C/15 TABS (AMSA)', NULL, '109', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (114, 2, NULL, 55, 'BLEDROMIN c/28 TABS. 80/12.5 MG. (EVOLUTION)', NULL, '110', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (115, 2, 46, 18, 'Adalat 10mg c/30 Tabs Nifedipino (Bayer)', NULL, '111', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (116, 2, 46, 29, 'ANHITEN-A 30MG C/30 COMP L.P NIFEDIPINO (ULTRA)', NULL, '112', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (117, 2, 46, NULL, 'NIFEDIPINO 30MG C/100 COMP', NULL, '113', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (118, 2, 47, 56, 'ACROMICINA 250MG C/20 TABS  (WYETH)', NULL, '114', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (119, 2, 23, 57, 'ADOPREN 800MG C/60 TABS IBUPROFENO (GENETICA)', NULL, '115', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (120, 2, NULL, 39, 'ADVIL INFANTIL 2-12 ANOS 120ML', NULL, '116', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (121, 2, NULL, 39, 'ADVIL MAX C/10 CAPSULAS', NULL, '117', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (469, 2, NULL, NULL, 'Cura Hongos Aerosol 64g (Sante)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (122, 2, 23, 57, 'ADOPREN Caja c/10 TABS. 800 MG. (GENETICA)', NULL, '118', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (123, 2, 23, 31, 'DOLVER 800MG C/20 TABS IBUPROFENO (MAVER)', NULL, '119', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (124, 2, 23, 49, 'Viczen 800mg c/100 Tabs Ibuprofeno (Victory)', NULL, '120', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (125, 2, NULL, 58, 'ADMIDOXIL C/10 CAPS AMBROXOL, DEXTROMETORFANO (GEL PHARMA)', NULL, '121', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.119584+00', NULL);
INSERT INTO public.products VALUES (126, 2, 33, 11, 'HISTIACIL NF C/20 CÁPS DEXTROMETORFANO/ AMBROXOL (SANOFI)', NULL, '122', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (127, 2, 48, 59, 'ADRECORT 1MG c/20 TABS DEXAMETASONA (AVITUS)', NULL, '123', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (128, 2, 48, 59, 'ADRECORT Cja/Fco. c/30 TABS. 0.5 MG. (AVITUS)', NULL, '124', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (129, 2, 48, 15, 'ALIN DEPOT SOL INY C/1 8MG DEXAMETASONA (CHINOIN)', NULL, '125', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (130, 2, 48, 13, 'COMBEDI 4MG DX C/3 AMP COMPLEJO B, DEXAMETASONA, LIDOCAINA (AMSA)', NULL, '126', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (131, 2, 48, 27, 'DEXIMET C/30 CAPS  (SONS)', NULL, '127', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (132, 2, 48, 60, 'TOBRADEX 5ML GOTAS DEXAMETASONA, TOBRAMICINA (ALCON)', NULL, '128', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (133, 2, 48, 12, 'VENGESIC C/20 TABS FENILBUTAZONA, DEXAMETASONA, METOCARBAMOL, HIDROXIDO DE ALUMINIO (COLLINS)', NULL, '129', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (134, 2, 48, 12, 'ZOLIDIME C/20 GRAGEAS Dexametasona+Fenilbutazona+Acido Acetilsalicílico+Aluminio. (COLLINS)', NULL, '130', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (135, 2, 48, 39, 'ADVIL EXHIBIDOR TABLETAS C/15 ENVASES', NULL, '131', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (136, 2, 49, 9, 'AFRIN ADULTO DESCONGESTIVO NASAL 20ML  (SCHERING-PLOUGH)', NULL, '132', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (137, 2, 49, 9, 'AFRIN INFANTIL DESCONGESTIVO NASAL 20ML  (SCHERING-PLOUGH)', NULL, '133', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (138, 2, 37, 47, 'AFUMIX  C/4 TABS (ALTIA)', NULL, '134', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (139, 2, 50, 61, 'AGIN C/20 TABS (NORDIN)', NULL, '135', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (140, 2, 51, 62, 'Agrifen Adulto Parches Paracetamol, Cafeina, Fenilefrina y Clorfenamina (Pisa)', NULL, '136', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (141, 2, 51, 62, 'AGRIFEN INFANTIL PARCHES (PISA)', NULL, '137', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (142, 2, 52, 62, 'AGRULAX POLVO (PISA)', NULL, '138', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (143, 2, 37, 12, 'AKORAZOL 60G CREMA KETOCONAZOL (COLLINS)', NULL, '139', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (144, 2, 37, 41, 'CONAZOL 2% 40G CREMA KETOCONAZOL (LIOMONT)', NULL, '140', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (145, 2, 37, 36, 'FEMISAN VAGINAL 30G KETOCONAZOL, CLINDAMICINA (GROSSMAN)', NULL, '141', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (146, 2, 37, 19, 'KETOCONAZOL 30G CREMA (APOTEX)', NULL, '142', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (147, 2, 37, 41, 'CONAZOL 200MG C/10 TABS KETOCONAZOL (LIOMONT)', NULL, '143', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (148, 2, 37, NULL, 'TINAZOL 120ML KETOCONAZOL SHAMPOO', NULL, '144', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (149, 2, 37, 63, 'PRENALON 60ML SUSPENSION KETOCONAZOL (CHEMICAL)', NULL, '145', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (150, 2, 20, 28, 'CLINDAMICINA/KETOCONAZOL (Loeffler) c/7 ÓVULOS 100/400 MG. (LOEFFLER)', NULL, '146', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (151, 2, NULL, 12, 'ALBOZ 20MG C/60 CAPS (COLLINS)', NULL, '147', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (152, 2, 45, 31, 'ALDERAN 100MG C/15 TABS LOSARTAN (MAVER)', NULL, '148', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (153, 2, 45, 31, 'ALDERAN 50MG C/30 TABS LOSARTAN (MAVER)', NULL, '149', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (154, 2, 45, 8, 'COLIBS 50MG C/60 TABS LOSARTAN (SBL)', NULL, '150', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (155, 2, 9, 58, 'ANTIGRIPAL C/12 CAPS DEXTROMETORFANO, FENILEFRINA, CLORFENAMINA, PARACETAMOL (GEL PHARMA)', NULL, '151', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (156, 2, 9, 18, 'DESENFRIOL-ITO PLUS SOL GOTAS 30ML CLORFENAMINA , PARACETAMOL, FENILEFRINA (BAYER)', NULL, '152', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (157, 2, 9, 64, 'DILARMINE 100ML PARAMETASONA, CLORFENAMINA (NOVO PHARMA)', NULL, '153', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (158, 2, 9, 65, 'PRINDEX 150ML SOLUCION DEXTROMETORFANO, FENILEFRINA, CLORFENAMINA, PARACETAMOL (ARMSTRONG)', NULL, '154', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (159, 2, 9, 34, 'BLENDOX 4MG C/20 TABS CLORFENAMINA (DEGORTS CHEMICAL)', NULL, '155', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (160, 2, 9, 18, 'CLORO-TRIMETON 10MG C/5 AMP CLORFENAMINA (BAYER)', NULL, '156', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (161, 2, 9, 65, 'PRINDEX NEO 60ML SOLUCION , FENILEFRINA, CLORFENAMINA, PARACETAMOL (ARMSTRONG)', NULL, '157', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (162, 2, 9, 66, 'RINOFREN 120ML  CLORFENAMINA/FENILEFRINA/PARACETAMOL (CARNOT)', NULL, '158', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (163, 2, 9, 18, 'DESENFRIOL-D c/24 TABS. 2/5/500 MG CLORFENAMINA/FENILEFRINA/PARACETAMOL (BAYER)', NULL, '159', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (164, 2, 9, 66, 'RINOFREN PEDIATRICO 30ML CLORFENAMINA/PARACETAMOL (CARNOT)', NULL, '160', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (165, 2, 9, 54, 'DEXTRFNO/GUIAFNA/PARCTML.  JBE. Ped. Fco.118 ML Dextrometorfano+Guaifenesina+Clorfenamina. (AVIVIA)', NULL, '161', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (166, 2, 20, 36, 'ALIVIN PLUS INY  (GROSSMAN)', NULL, '162', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (167, 2, 53, 18, 'ALKA-SELTZER C/100 TABS EXHIBIDOR  (BAYER)', NULL, '163', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (168, 2, 53, 18, 'ALKA-SELTZER LIMON C/12 TABS (BAYER)', NULL, '164', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (169, 2, 9, 11, 'ALLEGRA 120MG C/10 TABS FEXOFENADINA (SANOFI)', NULL, '165', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (170, 2, 9, 11, 'ALLEGRA PEDIATRICO 150ML FEXOFENADINA (SANOFI)', NULL, '166', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (171, 2, 13, 67, 'ALMAX 13.3GR/100ML 225ML (ALMIRALL)', NULL, '167', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (172, 2, 13, 67, 'ALMAX C/30 SOBRES 15ML  (ALMIRALL)', NULL, '168', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (173, 2, 54, 50, 'ALPRAZOLAM  c/30 TABS. 0.50 MG.(Psicofarma)', NULL, '169', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (174, 2, 54, 50, 'ALZAM 2MG  C/30 TABS (PSICOFARMA)', NULL, '170', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (175, 2, 38, 31, 'ALTIVER 50MG C/30 TABS CAPTOPRIL (MAVER)', NULL, '171', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (176, 2, 55, 38, 'Alupent 0.5mg c/5 Amp Orciprenalina (Boehringer Ingelheim)', NULL, '172', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (177, 2, 56, 12, 'ALZOCID 20MG C/8 TABS TADALAFIL (COLLINS)', NULL, '173', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:33.734133+00', NULL);
INSERT INTO public.products VALUES (178, 2, 57, 11, 'AMARYL MX TABS 4MG C/16 TABS (SANOFI)', NULL, '174', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (179, 2, 58, 68, 'AMIFARIN 500MG C/12 CAPS DICLOXACILINA (WANDEL)', NULL, '175', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (180, 2, 58, 23, 'BRISPEN 500MG C/20 TABS DICLOXACILINA (HORMONA)', NULL, '176', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (181, 2, 58, 7, 'Posipen 12h 1g c/10 Caps Dicloxacilina (Sanfer)', NULL, '177', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (182, 2, 20, 13, 'Amikacina 2ml Iny (Amsa)', NULL, '178', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (183, 2, NULL, 29, 'AMLODIPINO 5MG C/10 TABS (ULTRA)', NULL, '179', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (184, 2, NULL, 54, 'AMLODIPINO 5MG C/100 TABS (AVIVIA)', NULL, '180', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (185, 2, NULL, 69, 'AMLODIPINO 5MG C/30 TABS (MEDLEY)', NULL, '181', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (186, 2, 20, 49, 'AMOXICILINA 500MG C/100 TABS (VICTORY)', NULL, '182', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (187, 2, 20, 12, 'Gimabrol 500mg/30mg  c/12 Caps Amoxicilina, Ambroxol (Collins)', NULL, '183', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (188, 2, 20, 12, 'GIMALXINA 250 MG SUSP AMOXICILINA (COLLINS)', NULL, '184', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (189, 2, 59, 13, 'AMSAFAST 120MG C/21 CAPS ORLISTAT (AMSA)', NULL, '185', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (190, 2, 23, 41, 'ANALGEN 220MG C/20 TABS (LIOMONT) NAPROXENO', NULL, '186', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (191, 2, 23, 18, 'Flanax 40g Gel Naproxeno Sodico 5.5% (Bayer)', NULL, '187', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (192, 2, 23, 13, 'NAPROXENO 500MG C/45 TABS (AMSA)', NULL, '188', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (193, 2, 23, 44, 'Naxodol 250mg-200mg c/30 Caps Naproxeno-Carisoprodol (Siegfried Rhein)', NULL, '189', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (194, 2, 23, 27, 'VELSAY-S COMPUESTO 100ML SUSP NAPROXENO,PARACETAMOL (SONS)', NULL, '190', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (195, 2, 36, NULL, 'ARNICA CON NAPROXENO', NULL, '191', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (196, 2, 36, NULL, 'FORMULA CHINA CON DICLOFENACO Y NAPROXENO  125GR', NULL, '192', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (197, 2, 36, NULL, 'MAMISAN C/ARNICA Y NAPROXENO 100GR', NULL, '193', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (198, 2, 20, 36, 'ANAPENIL INY 400,000 U  (GROSSMAN) BENCIPENICILINA', NULL, '194', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (199, 2, 20, 13, 'BENCILPENICILINA PROCAINA 800,000 U C/1 AMP (AMSA)', NULL, '195', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (200, 2, 20, 24, 'PENICILINA 500MG 800,000 UI C/100 CAPS PENIXILIN (HEALTH TEC)', NULL, '196', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (201, 2, 20, 70, 'PENICILINA POMADA 12GR  (KURAMEX)', NULL, '197', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (202, 2, 60, 15, 'ANARA 125ML JARABE (CHINOIN) PICOSULFATO', NULL, '198', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (203, 2, 61, 7, 'ANDANTOL 25G  (SANFER)', NULL, '199', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (204, 2, 62, 71, 'ANGIN 30 TABS (VIVALIVE)', NULL, '200', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (205, 2, 24, 72, 'DIMEFOR G 5MG METFORMINA/GLIBENCLAMIDA (SEGFREID RHEIN)', NULL, '201', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (206, 2, 24, 73, 'DINAMEL 500MG C/30 TABS METFORMINA (LIFERPAL)', NULL, '202', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (207, 2, 24, 74, 'METDUAL C/30 TABS GLIPIZIDA/METFORMINA (SILANES)', NULL, '203', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (208, 2, NULL, 29, 'ARIFLAM 100MG C/50 TABS DICLOFENACO (ULTRA)', NULL, '204', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (209, 2, 63, 75, 'ARNICA C/60 CAPS (ANAHUAC)', NULL, '205', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.431597+00', NULL);
INSERT INTO public.products VALUES (210, 2, NULL, 76, 'ARTIDOL GEL 60GR (RIMSA)', NULL, '206', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (211, 2, NULL, 76, 'ARTRIDOL C/20 CAPS  (RIMSA)', NULL, '207', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (212, 2, NULL, 77, 'ARTRIFLEX C/60 TABS  (SANDY)', NULL, '208', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (213, 2, 23, 18, 'ASPIRINA 500MG C/40 TABS  (BAYER)', NULL, '209', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (214, 2, 23, 18, 'ASPIRINA JUNIOR 100MG C/60 TABS (BAYER)', NULL, '210', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (215, 2, 64, 78, 'ACONDICIONADOR COLA DE CABALLO 1.1 L (INDIO PAPAGO)', NULL, '1000', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (216, 2, 65, 62, 'AGUA INY 3ML (PISA)', NULL, '1001', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (217, 2, 10, 79, 'Ajo Japones c/60 Tabs (Farnat)', NULL, '1002', NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (218, 2, NULL, 80, 'ASSAL SALBUTAMOL AEROSOL  C/200 DOSIS (SALUS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (219, 2, NULL, 22, 'ASTRINGOSOL ANTISEPTICO  (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (220, 2, NULL, 81, 'ATARAX 25MG C/25 TABS (UCB DE MÉXICO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (221, 2, NULL, 65, 'ATEMPERATOR 400MG C/30 TABS VALPROATO DE MAGNESIO (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (222, 2, NULL, 75, 'AUTENTICA VIBORA DE CASCABEL C/50 CAPS (ANAHUAC)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (223, 2, NULL, 65, 'AUTRIN 600MG C/36 TABS VITAMINAS, HIERRO (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (224, 2, NULL, 32, 'AVAPENA C/5 AMP CLOROPIRAMINA (SANDOZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (225, 2, NULL, NULL, 'BABA DE CARACOL CREMA 150GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (226, 2, NULL, 7, 'BABY KANK-A GEL 10GR SABOR UVA (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (227, 2, NULL, 22, 'Bactroban Unguento 2% 15g Mupirocina (Glaxo Smith Kline)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (228, 2, NULL, 82, 'Balsamo Blanco Pomada 240g (Aranda)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (229, 2, NULL, 82, 'Balsamo Blanco Pomada 60g (Aranda)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (230, 2, NULL, NULL, 'BALSAMO DEL PERU GEL 120GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (231, 2, NULL, 83, 'BALSAMO DEL TIGRE 100GR  (PLANTIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (232, 2, NULL, NULL, 'BALSAMO DEL TRIGRE 125GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (233, 2, NULL, NULL, 'BALSAMO DENTAL SAN JORGE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (234, 2, NULL, NULL, 'BALSAMO NEGRO 125GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (235, 2, NULL, 18, 'BAMITOL POMADA 200GRM (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (236, 2, NULL, NULL, 'BAÑO COLOIDE POLVO 90G ARDOR Y COMEZON', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (237, 2, NULL, 27, 'BAYCUTEN N CREMA 35G (SON''S)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (238, 2, NULL, 84, 'BEBIDA DE ALPISTE 1.1KG(YPENSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (239, 2, NULL, 36, 'Bedoyecta G c/30 Tabs Multivitaminico, Extracto de Ginseng (Grossman)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (240, 2, NULL, 85, 'BEKA C/10 PEINES PIOJOS PLASTICO (BEKA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (241, 2, NULL, 86, 'BELLA AURORA CREMA ACLARANTE (STILLMAN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (242, 2, NULL, 87, 'BELLODECTA C/10 AMP (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (243, 2, NULL, 88, 'BENADREX 120ML  DIFENHIDRAMINA,DEXTROMETORFANO (JOHNSON & JOHNSON)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (244, 2, NULL, 88, 'BENADRYL ALERGIA C/24 TABS (JOHNSON & JOHNSON)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (245, 2, NULL, 88, 'BENADRYL ALERGIA JBE 120ML (JOHNSON & JOHNSON)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (246, 2, NULL, 88, 'BENADRYL E 150ML JARABE  (JOHNSON & JOHNSON)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (247, 2, NULL, 18, 'BENEXOL C/30 COMPRIMIDOS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (248, 2, NULL, NULL, 'BENZAL DOUCHE CLASICO CUIDADO INTIMO FEMENINO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (249, 2, NULL, NULL, 'BENZAL POLVO C/12 SOBRES CUIDADO INTIMO FEMENINO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (250, 2, 66, 83, 'BERGAMOTA HAIR OIL 2 OZ (PLANTIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (251, 2, NULL, 89, 'BETAMETASONA , CLOTRIMAZOL , GENTAMICINA 40GR (BEST)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (252, 2, 67, 22, 'BETNOVATE 100ML LOCION (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (253, 2, NULL, 22, 'BETNOVATE CREMA 40GR (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (254, 2, NULL, 50, 'BEZAFIBRATO 200MG C/30 TABS (PSICOFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (255, 2, NULL, NULL, 'BINAFEX C20 TABS 250 MG', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (256, 2, NULL, 18, 'BINOTAL 1G C/12 TABS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (257, 2, NULL, 18, 'BINOTAL 250MG SUSP (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (258, 2, NULL, 18, 'BINOTAL 500MG C/30 CAPS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (259, 2, NULL, 18, 'BINOTAL 500MG SUSP (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:34.993098+00', NULL);
INSERT INTO public.products VALUES (260, 2, NULL, 90, 'BIODAN c/50 TABS. 100 MG. FENITOINA (BIORESEARCH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (261, 2, NULL, 90, 'BIOFENOR c/30 TABS. SULFATO FERROSO (BIORESEARCH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (262, 2, NULL, 91, 'BIOFILEN 100MG c/28 TABS ATENOLOL (DEGORTS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (263, 2, NULL, 90, 'BIOFUROSO 200MG C/50 TABS FUMARATO FERROSO (BIORESEARCH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (264, 2, NULL, 40, 'BIOKACIN 500MG SOLUCION INY (RAYERE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (265, 2, NULL, 9, 'BIOMETRIX AOX C/100 CAPS  (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (266, 2, NULL, 9, 'BIOMETRIX AOX C/60 CAPS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (267, 2, NULL, 9, 'BIOMETRIX C/100 CAPS  (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (268, 2, NULL, 9, 'BIOMETRIX C/30 CAPS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (269, 2, NULL, 92, 'BIOTINA 500MG C/30 CAPS (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (270, 2, NULL, 31, 'BIPALVER 75MG C/28 TABS PREGABALINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (271, 2, NULL, 38, 'Bipasmin Compuesto N c/20 Tabs (Boehringer Ingelheim)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (272, 2, NULL, 93, 'Bismuto 1g Subnitrato (Alprima)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (273, 2, NULL, 94, 'Boldo 400mg c/150 Caps (La Salud es Primero )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (274, 2, NULL, 95, 'B-PLEX c/30 TABS. 500 MG.(BIOMIRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (275, 2, NULL, 36, 'BRE-A-COL ADULTO 120ML  (GROSSMAN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (276, 2, NULL, 96, 'BRILINTA 90MG C/60  (AZTRA ZENECA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (277, 2, NULL, NULL, 'BRINTELLIX 10MG C/28 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (278, 2, NULL, 27, 'BROMINOL-C 120ML DEXTROMETORFANO/AMBROXOL (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (279, 2, NULL, 79, 'BRONALIN INFANTIL 120ML (FARNAT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (280, 2, NULL, NULL, 'BRONCO FRESH C/12 PIEZAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (281, 2, NULL, NULL, 'BRONCOLIN 140ML JARABE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (282, 2, NULL, NULL, 'BRONCOLIN 250ML JARABE ETIQUETA AZUL', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (283, 2, NULL, NULL, 'BRONCOLIN PALETAS C/10', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (284, 2, NULL, NULL, 'BRONCOLIN RUB C/12 LATITAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (285, 2, NULL, NULL, 'BRONCOLIN RUB VITROLERO C/40 LATITAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (286, 2, NULL, NULL, 'BRONCOMED 120ML ADULTO DEXTROMETORFANO, GUAIFENESINA (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (287, 2, NULL, NULL, 'BROXTORFAN 120ML ADULTO AMBROXOL/DEXTROMETORFANO (BIOMEP)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (288, 2, NULL, NULL, 'BRUBIOL 500MG C/10 TABS CIPROFLOXACINO (BRULUART)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (289, 2, NULL, NULL, 'BRUMAX 250MG SUSP (BRULUAGSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (290, 2, NULL, NULL, 'BRUMAX 500MG C/12 CAPS (BRULUAGSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (291, 2, NULL, NULL, 'BRUPEN 500MG C/20  (BRULUAGSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (292, 2, NULL, NULL, 'BUENA NOCHE C/60 CAPS  (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (293, 2, NULL, NULL, 'Buscapina 20mg c/3 Amp HIOSCINA (Boehringer Ingelheim)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (294, 2, NULL, NULL, 'BUSCAPINA COMP C/10 TABS BUTILlHIOSCINA o HIOSCINA , METAMIZOL SODICO (BOEHRINGER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (295, 2, NULL, NULL, 'BUSCAPINA DISPLAY 220MG  C/120 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (296, 2, NULL, NULL, 'BUSCAPINA FEM C/10 TABS HIOSCINA (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (297, 2, NULL, NULL, 'BUSCONET 250MG C/10 TABS (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (298, 2, NULL, 97, 'BUSTILLOS CREMA BLANCA 100G (BUSTILLOS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (299, 2, NULL, NULL, 'BUTILHIOSCINA  10MG C/10 TABS. (SCHOEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (300, 2, NULL, NULL, 'BUTILHIOSCINA (Apotex) c/10 TABS. 10 MG.', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (301, 2, NULL, NULL, 'C. de Indias 50mg c/60 Tabletas (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (302, 2, NULL, NULL, 'C. Mariano Reforzado 125mg c/30 Tabletas (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (303, 2, NULL, NULL, 'CAFERGOT C/30 COMPRIMIDOS (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (304, 2, NULL, NULL, 'CAJETA ONDULADA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (305, 2, NULL, NULL, 'CAJETA REDONDA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (306, 2, NULL, NULL, 'CAJETA ZAGALA C/24 KILO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (307, 2, NULL, 98, 'CALADRYL 180ML LOCION (VALEANT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (308, 2, NULL, 99, 'CALANDA C/30 CAPS (ATANTLIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (309, 2, NULL, NULL, 'CALCIO 600 + D3 C/60 (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (310, 2, NULL, NULL, 'CALCORT 30MG C/10 TABS DEFLAZACORT (SANOFI AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (311, 2, NULL, NULL, 'CALOMEL POLVO 10', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (312, 2, NULL, NULL, 'Caltrate 600 + D c/30 Tabs (Wyeth)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (313, 2, NULL, NULL, 'CALTRATE 600 + D C/60 TABS (WYETH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (314, 2, NULL, NULL, 'CALTRATE 600 PLUS C/60 TABS (WYETH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (315, 2, NULL, NULL, 'CALTRON 600 + D C/60 TAB (SALUD NATURAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (316, 2, NULL, NULL, 'CALTRON 600 C/60 TAB (SALUD NATURAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (317, 2, NULL, 100, 'CAPENT POMADA ROZADURAS 110GR  (COLUMBIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (318, 2, NULL, 100, 'CAPENT POMADA ROZADURAS 20GR (COLUMBIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (319, 2, NULL, 100, 'CAPENT POMADA ROZADURAS 45GR (COLUMBIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (320, 2, NULL, NULL, 'CAPRICE ALGAS SPRAY 316ML C/12 (PALMOLIVE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (321, 2, NULL, NULL, 'CAPRICE BIOTINA SPRAY 316ML C/12 (PALMOLIVE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (322, 2, NULL, NULL, 'CAPRICE KIWI SPRAY 316ML C/12 (PALMOLIVE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (323, 2, NULL, NULL, 'CARBALAN 200MG C/20 TABS CARBAMAZEPINA (QUIFA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (324, 2, NULL, 101, 'CARBONATO DE MAGNESIA PURO 7G (COYOACAN QUIMICA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (325, 2, NULL, NULL, 'CARDISPAN 1G /20 TABS (GROSSMAN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (326, 2, NULL, NULL, 'CARDISPAN C/5 AMP (GROSSMAN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (327, 2, NULL, NULL, 'CARNOTPRIM 10MG C/20 COMPRIMIDOS (CARNOT LABS.)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (328, 2, NULL, NULL, 'CARPIN 200MG c/20 TABS. CARBAMAZEPINA (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (329, 2, NULL, NULL, 'CARTICAP FOR C/60 CAPS GLUCOSAMINA CONDROITINA (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (330, 2, NULL, NULL, 'CARTILAGO DE TIBURON &  NONI COMPLEX C/180 TAB', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (331, 2, NULL, NULL, 'Cartilogo de Tiburon y Glucosamina c/90 Caps', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (332, 2, NULL, NULL, 'CASTAÑO DE INDIAS 1G C/90 (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (333, 2, NULL, NULL, 'CASTAÑO DE INDIAS 500MG C/90 (FARNAT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (334, 2, NULL, NULL, 'CASTAÑO DE INDIAS C/60 CÁPSULAS (YPENZA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (335, 2, NULL, NULL, 'CASTAÑO DE INDIAS CREMA 150GR (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (336, 2, NULL, NULL, 'CDS3 B-12 C/60CAPS (NORDIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (337, 2, NULL, NULL, 'CEFAXONA 1G I.M CEFTRIAXONA (PISA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (338, 2, NULL, NULL, 'Celebrex 200mg c/10 Caps Celecoxib (Pfizer)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (339, 2, NULL, NULL, 'Celecoxib 200mg c/20 Tabs (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (340, 2, NULL, NULL, 'CELESTONE 0.5MG C/50 TABS  (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (341, 2, NULL, NULL, 'CELESTONE PEDIATRICO 60ML GOTAS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (342, 2, NULL, NULL, 'CELESTONE SOL  3MG 1ML (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (343, 2, NULL, NULL, 'CELESTONE SOL INY 2ML (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (344, 2, NULL, NULL, 'CENTRUM C/ 60 TABS (WYETH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (345, 2, NULL, NULL, 'CENTRUM KIDS C/60 TABS (WYETH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (346, 2, NULL, NULL, 'CEVALIN INFANTIL 100MG C/100 TABS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (347, 2, 68, NULL, 'CHACA CHACA BARRA C/30 C/16', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (348, 2, NULL, NULL, 'CHACA CHACA TROZO C/32', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (349, 2, NULL, NULL, 'CHAMOY NAVOLATO C/15', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (350, 2, NULL, NULL, 'Chaparro Amargo 400mg c/150 Caps (La Salud es Primero)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (351, 2, NULL, NULL, 'CHOLAL MODIFICADO C/10 AMP (ITALMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (352, 2, NULL, NULL, 'CHUPA PANZA CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (353, 2, 69, NULL, 'CHUPON C/MIEL C/25 (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (354, 2, 69, NULL, 'CHUPON C/MIEL D''DITO C/25 (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (355, 2, NULL, NULL, 'CICATRICURE 150ML SOL 365 50 SPF  (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (356, 2, NULL, NULL, 'CICATRICURE CREMA OJOS 8.5G  (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (357, 2, NULL, NULL, 'CICATRICURE GEL 30GR (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (358, 2, NULL, NULL, 'CILOCID 5MG C/20 TABLETAS ACIDFO FOLICO (BRULUAGSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:35.590019+00', NULL);
INSERT INTO public.products VALUES (359, 2, NULL, NULL, 'CINARIZINA 75MG C/60 (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (360, 2, NULL, NULL, 'Cinarizina 75mg c/60 (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (361, 2, NULL, NULL, 'CINCO COMBINACIONES 500MG C/60 (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (362, 2, NULL, NULL, 'CINEPRAC 200MG C/20 TABS TRIMEBUTINA (LIFERPAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (363, 2, NULL, NULL, 'CIPRAIN 500MG C/10 TABS (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (364, 2, NULL, NULL, 'CIPROFLOXACINO 250MG C/8 TABS  (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (365, 2, NULL, NULL, 'CIPROFLOXACINO 500MG C/12 TABS  (AVIVIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (366, 2, NULL, NULL, 'CIPROFLOXACINO 500MG C/12 TABS  (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (367, 2, NULL, NULL, 'CIPROFLOXACINO 5ML OFTALMICAS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (368, 2, NULL, NULL, 'CIPROLISINA 220ML CIPROHEPTADINA CIANOCOBALAMINA (CARNOT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (369, 2, NULL, NULL, 'CIPROXINA 250MG SUSPENSION CIPROFLOXACINO (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (370, 2, NULL, NULL, 'CIPROXINA 500MG  C/8 TABS CIPROFLOXACIONO (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (371, 2, NULL, NULL, 'CIPROXINA 500MG C/14 COMPRIMIDOS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (372, 2, NULL, NULL, 'CIRKUSED 140MG C/40 GRAGEAS (FARMASA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (373, 2, NULL, NULL, 'CIRULAN 10MG C/20 TABS METOCLOPRAMIDA (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (374, 2, NULL, NULL, 'CLARITYNE 24 HORAS C/10 TABLETAS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (375, 2, NULL, NULL, 'CLARITYNE D 5/30 MG C/20 TABLETAS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (376, 2, NULL, NULL, 'CLARITYNE D SOL. INF. 60ML (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (377, 2, NULL, NULL, 'CLARITYNE D SOL. PED. 30ML (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (378, 2, NULL, NULL, 'CLAVULIN 250-62.5MG/5ML SUSP (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (379, 2, NULL, NULL, 'CLAVULIN 500MG C/15 TABS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (380, 2, NULL, NULL, 'Clindamicina 300mg c/16 Caps (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (381, 2, NULL, NULL, 'Clindamicina 300mg c/16 Caps (Maver)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (382, 2, NULL, NULL, 'Clindamicina 300mg c/16 Caps (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (383, 2, NULL, NULL, 'CLISON 200MG C/20 TAB (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (384, 2, NULL, NULL, 'CLOBESOL 30G CREMA 5% CLOBETASOL (VALEANT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (385, 2, NULL, NULL, 'CLONAFEC C/60 TABS DICLOFENACO (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (386, 2, NULL, NULL, 'Clorafenicol Oftalmico 15ml Gotas (Amsa)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (387, 2, NULL, NULL, 'CLORANFENICOL 5MG UNG  (OPKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (388, 2, NULL, NULL, 'CLORANFENICOL OFTALMICAS 15ML (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (389, 2, NULL, NULL, 'CLORANFENICOL OFTALMICAS 15ML (GRIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (390, 2, NULL, NULL, 'CLORANFENICOL OFTALMICAS 15ML (OPKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (391, 2, NULL, NULL, 'CLOROPIRAMINA 25MG C/20 TABS (SANDOZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (392, 2, 33, 9, 'CLORO-TRIMETON 4HRS C/20 (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (393, 2, NULL, NULL, 'CLORTORY 500MG C/16 TABS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (394, 2, NULL, NULL, 'CLORURO DE MAGNESIO 100G VIDA MAGNESIO (QUIMICA COYOCAN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (395, 2, NULL, NULL, 'Cloruro de Magnesio c/ Hierbabuena 100g Vida Magnesio (Quimica Coyoacan)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (470, 2, NULL, NULL, 'CURA HONGOS CREMA 125GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (396, 2, NULL, NULL, 'Cloruro de Magnesio c/ Hierbabuena 50g Vida Magnesio (Quimica Coyoacan)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (397, 2, 19, 31, 'COBADEX ADULTO 120ML DEXTROMETORFANO/ AMBROXOL (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (398, 2, 19, 31, 'COBADEX INFANTIL 120ML DEXTROMETORFANO/ AMBROXOL (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (399, 2, NULL, NULL, 'Cola de Caballo 350mg c/150 Capsulas (La Salud es Primero)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (400, 2, NULL, NULL, 'COLAGENO 1 KILO (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (401, 2, NULL, NULL, 'Colageno 1g c/90 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (402, 2, NULL, NULL, 'COLAGENO C/60 TABS (I PHARMA INNOVATION)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (403, 2, NULL, NULL, 'COLAGENO HIDROLIZADO POLVO 250GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (404, 2, NULL, NULL, 'COLAGENO POLVO CIRUELA 500MG (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (405, 2, NULL, NULL, 'COLAGENO POLVO LIMON 500MG (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (406, 2, NULL, NULL, 'COLCHICINA 1MG C/30 TABS (PERRIGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (407, 2, 18, 102, 'COLCHIQUIM 1MG C/20 TABS COLCHICINA (PERRIGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (408, 2, NULL, NULL, 'COLDTAC PLUS 72PZ C/2 TABS (RRX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (409, 2, NULL, NULL, 'COLDTAC PLUS C/12 TABS (RRX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (410, 2, NULL, NULL, 'COLESCONTROL C/90 TABS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (411, 2, NULL, NULL, 'COLESTOPDIN 1G C/90 CAPS (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (412, 2, NULL, NULL, 'COLLICORT 1% 60G CREMA HIDROCORTISONA (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (413, 2, NULL, NULL, 'COLLICORT 2.5% 60G CREMA HIDROCORTISONA (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (414, 2, NULL, NULL, 'COMBEDI 50,000 C/5 AMP TIAMINA, PIRIDOXINA, CIANOCOBALAMINA (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (415, 2, NULL, NULL, 'COMBEDI DL 5MG C/3 AMP COMPLEJO B , DICLOFENACO , LIDOCAINA (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (416, 2, NULL, NULL, 'COMBIVENT C/10 AMPOLLETAS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (417, 2, NULL, NULL, 'COMPLEJO B INY 10ML C/5 JERINGAS (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (418, 2, NULL, NULL, 'COMPLEJO B RIMSA SOL INY (RIMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (419, 2, NULL, NULL, 'COMPLEJO B Y B12 MULTIVITAMINICO C/50 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (420, 2, 37, 41, 'CONAZOL CREMA 40G + CONAZOL CREMA 30GR (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (421, 2, NULL, NULL, 'CONCHA NACAR CREMA 150GR (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (422, 2, 33, 22, 'CONTAC ULTRA C/12 TABLETAS (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (423, 2, 33, 22, 'CONTAC ULTRA EXHIBIDOR C/25 SOBRES C/2 C/U (GSK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (424, 2, 12, 103, 'CONVIFER C/ HIERRO SOL 110ML (DEGORT''S/CHEMICAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (425, 2, NULL, NULL, 'CONVIFER C/HIERRO 220ML (DEGORT''S CHEMICAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (426, 2, NULL, NULL, 'COREGA C/30 TABS EFERVECENTES (GSK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (427, 2, NULL, NULL, 'CORPOTASIN CL C/50 TABS (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (428, 2, NULL, NULL, 'CREMA ACEITE DE ARGAN 4,23 OZ FPS 45', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (429, 2, NULL, NULL, 'Crema Camote Silvestre 120ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (430, 2, NULL, NULL, 'CREMA CAMOTE Y LINAZA 60G  (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (431, 2, NULL, NULL, 'CREMA CONCHA NACAR 60G  (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (432, 2, NULL, NULL, 'CREMA COSMETICA C/10 FRASCOS (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (433, 2, NULL, NULL, 'CREMA DE CARACOL C/ROSAMOSQUETA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (434, 2, NULL, NULL, 'CREMA DE MANZANILLA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (435, 2, NULL, NULL, 'CREMA LECHE DE BURRA 150ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (436, 2, NULL, NULL, 'CREMA LECHE DE BURRA Y JALEA REAL 60G  (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (437, 2, 70, NULL, 'CREMA MYRIAM DE DIA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (438, 2, 70, NULL, 'CREMA MYRIAM NOCHE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (439, 2, NULL, NULL, 'CREMA NUTRIDERM TEPEZCOHUITE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (440, 2, NULL, NULL, 'Crema Nutritiva 120ml (Mega Mix)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (441, 2, NULL, NULL, 'CREMA ÑAME 60GR  Eliminar', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (442, 2, NULL, NULL, 'CREMA REDUCTORA BICOLOR 250GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (443, 2, NULL, NULL, 'CREMA REDUCTORA DE TORONJA 500G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (444, 2, NULL, NULL, 'CREMA REDUCTORA LIMON 250GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (445, 2, NULL, NULL, 'CREMA REDUCTORA TORONJA 250GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (446, 2, NULL, NULL, 'CREMA REPELNTE DE MOSQUITOS 150ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (447, 2, NULL, NULL, 'CREMA ROSA MOSQUETA 150GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (448, 2, NULL, NULL, 'CREMA ROSA MOSQUETA FPS 45 4,23 OZ', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (449, 2, NULL, NULL, 'CREMA RUSA .42 (MEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (450, 2, NULL, NULL, 'CREMA SUAVISANTE DE MANZANA 30GR (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (451, 2, NULL, NULL, 'CREMA SUAVISANTE DE MANZANA 60GR (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (452, 2, 71, NULL, 'CREMA TEPEZCOHUITE 150GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (453, 2, 71, NULL, 'CREMA TEPEZCOHUITE 60GR DE DÍA (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (454, 2, 71, NULL, 'CREMA TEPEZCOHUITE DIA 120GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (455, 2, 71, NULL, 'CREMA TEPEZCOHUITE NOCHE 120GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (456, 2, 71, NULL, 'CREMA TEPEZCOHUITE NOCHE 60GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (457, 2, 71, NULL, 'CREMA TEPEZCOUITE ECO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.165131+00', NULL);
INSERT INTO public.products VALUES (458, 2, NULL, NULL, 'CREMA VITAMINA E Y JALEA REAL 120GR  (NATURAMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (459, 2, NULL, NULL, 'Creolina Liquida 250ml (Bremer)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (460, 2, NULL, NULL, 'Creolina Liquida 500ml (Bremer)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (461, 2, NULL, NULL, 'Creolina Liquida 500ml (Cedrosa)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (462, 2, NULL, NULL, 'CRESTOR 10MG C/30 TABS ROSUVASTATINA (AZTRA ZENECA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (463, 2, NULL, NULL, 'CRONADYN 15MG PAROXETINA (MORE PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (464, 2, NULL, NULL, 'CRONOCAPS M3G C/30 CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (465, 2, NULL, NULL, 'CUACHALALATE C/150 CAPS  (YAZMIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (466, 2, NULL, NULL, 'CUAJO HANSEN C/100 SOBRES (3 MUÑECAS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (467, 2, NULL, NULL, 'CUBRE BOCAS C/10 PIEZAS (AMBID)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (468, 2, NULL, 23, 'CUERPO AMARILLO FUERTE C/6 AMP (HORMONA LABS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (471, 2, NULL, NULL, 'CURCUMA 1G C/90 TABS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (472, 2, NULL, NULL, 'CURITAS C/100 (GALLITO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (473, 2, NULL, NULL, 'CYCLOFEMINA C/1 INY (CARNOT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (474, 2, NULL, NULL, 'CYRUX 200MG C/28 TABS MISOPROSTOL', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (475, 2, NULL, NULL, 'CYTOTEC 200MG C/28 TAB (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (476, 2, NULL, NULL, 'DABEON C/30 CAPS MINERALES Y VITAMINAS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (477, 2, NULL, NULL, 'DAFLON 500MG C/20 TABS(SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (478, 2, NULL, NULL, 'DAFLOXEN 100ML JARABE (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (479, 2, NULL, NULL, 'DAKTARIN 30GR MICONAZOL  (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (480, 2, NULL, NULL, 'DAKTARIN GEL 78GR (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (481, 2, 20, 39, 'DALACIN T 30G GEL (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (482, 2, NULL, NULL, 'DALACIN T 30ML(PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (483, 2, NULL, NULL, 'DALACIN T PLEDGETS C/30 SOBRES  (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (484, 2, NULL, NULL, 'DALACIN V 100MG C/3 ÓVULOS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (485, 2, 29, 33, 'DALATINA 30G GEL 1G CLINDAMICINA (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (486, 2, 30, 104, 'DALAY C/30 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (487, 2, NULL, NULL, 'DALAY TE C/25 SOBRES (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (488, 2, 19, 44, 'DALVEAR 200ML ADULTO DROPROPIZINA,BROMHEXINA (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (489, 2, NULL, NULL, 'DAXON 500MG C/6 TAB (SIEGFRIED-RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (490, 2, NULL, NULL, 'DEAFORT C/2 AMP. 10ML C/5 JGS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (491, 2, NULL, NULL, 'DECA-DURABOLIN 1ML/50MG INY (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (492, 2, NULL, NULL, 'DELECON 200MG C/10 TABS CELECOXIB (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (493, 2, NULL, NULL, 'DELINEADOR PROSA 4 EN 1 (PROSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (494, 2, NULL, NULL, 'DEMOGRASS C/30 CAPS CLASICO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (495, 2, NULL, NULL, 'DEMOGRASS C/30 CAPS PLUS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (496, 2, NULL, NULL, 'DEMOGRASS C/30 CAPS PREMIER', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (497, 2, NULL, NULL, 'Depo-Medrol 40mg Iny Metilprednisolona (Pfizer)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (498, 2, 72, 39, 'DEPO-PROVERA 150MG/ML INY (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (499, 2, NULL, NULL, 'DERMAN CREMA 25GR (LABORATORIOS KSK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (500, 2, NULL, NULL, 'DERMAN POLVO FUNGICIDA 80G  (LABORATORIOS KSK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (501, 2, 73, 22, 'DERMATOVATE CREMA 40G (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (502, 2, 73, 22, 'DERMATOVATE UNGUENTO 40G (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (503, 2, NULL, NULL, 'DERMOLIMPIADOR NEUTRO CON ACEITE DE JOJOBA 125GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (504, 2, 74, 104, 'DERMO-PRADA 10ML ANTIVERRUGAS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (505, 2, 75, 105, 'DESENEX 28G ACIDO UNDECILENICO SANOFI AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (506, 2, NULL, NULL, 'DESENFRIOL D C/24 TABS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (507, 2, 33, 9, 'DESENFRIOL D C/30 TABLETAS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (508, 2, NULL, NULL, 'DESENFRIOL-ITO PEDIATRICO GOTAS AZUL 120ML (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (509, 2, 33, 9, 'DESENFRIOL-ITO PLUS C/24 TABS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (510, 2, NULL, NULL, 'DESENFRIOL-ITO SOL GOTAS 60ML (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (511, 2, NULL, NULL, 'DESENFRIOL-ITO TF JARABE 120ML (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (512, 2, NULL, NULL, 'DESINTOXICADOR  ''''A''''  C/60 CAPS (ANAHUAC)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (513, 2, NULL, NULL, 'DESINTOXICADOR ''''B''''  C/60 CAPS (ANAHUAC)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (514, 2, NULL, NULL, 'DESINTOXICADOR ''''C'''' C/60 CAPS (ANAHUAC)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (515, 2, NULL, NULL, 'DESODORANTE OBAO FRESCURA BAMBOO 150ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (516, 2, NULL, NULL, 'DESODORANTE OBAO FRESCURA INTENSA 150ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (517, 2, NULL, NULL, 'DESODORANTE OBAO FRESCURA PIEL DELICADA 150ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (518, 2, NULL, NULL, 'DESODORANTE OBAO FRESCURA POWDER 150ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (519, 2, NULL, NULL, 'DESODORANTE OBAO FRESCURA SENSITIVE ANGEL 150ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (520, 2, NULL, NULL, 'DESODORANTE OBAO FRESCURA SUAVE 150ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (521, 2, NULL, NULL, 'DESODORANTE OBAO FRESQUISSIMA 150ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (522, 2, NULL, NULL, 'DESPAMEN C/1 AMP TETOSTERONA/ ESTRADIOL (CARNOT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (523, 2, 76, 28, 'DESYN-N C/6 SUPOSITORIOS LIDOCAINA/ HIDROCORTISONA (LOEFFLER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (524, 2, NULL, NULL, 'DEXABIÓN DC C/1 AMP (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (525, 2, NULL, NULL, 'DEXABIÓN DC C/2 AMP (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (526, 2, 12, 106, 'DEXABIÓN DC C/3 AMP (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (527, 2, NULL, NULL, 'DEXTREVIT SOL INY C/2 FRASCOS MULTIVITAMINAS (VALEANT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (528, 2, NULL, NULL, 'Diabedin 1g c/90 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (529, 2, NULL, NULL, 'DIABINESE 250MG C/100 TABS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (530, 2, NULL, NULL, 'DIANE C/21 GRAGEAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (531, 2, NULL, NULL, 'DIAZEPAM 10MG C/20 TABS (PSICOFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (532, 2, NULL, NULL, 'DIBENEL 0.940G C/30 TABLETAS (CMD)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (533, 2, NULL, NULL, 'DICETEL 100MG C/14 TABS (ALTANA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (534, 2, NULL, NULL, 'DICETEL 100MG C/28 TABS (ABBOT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (535, 2, NULL, NULL, 'DICLOFENACO / COMPLEJO B C/30 TABS (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (536, 2, NULL, NULL, 'DICLOFENACO 100MG C/20 TABS (AVIVIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (537, 2, NULL, NULL, 'DICLOFENACO 100MG C/20 TABS (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (538, 2, NULL, NULL, 'DICLOFENACO 50MG C/100 CAPS (SAIMED)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (539, 2, NULL, NULL, 'DIETALAX 1G C/90 (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (540, 2, NULL, NULL, 'Dieter''s Drink 690mg c/30 Capsulas (La Salud es Primero)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (541, 2, NULL, NULL, 'DIFENHIDRAMINA 25MG C/10 CAPS (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (542, 2, NULL, NULL, 'DILACORAN 80MG C/30 TABLETAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (543, 2, NULL, NULL, 'DILAR 2MG C/30 TAB (SYNTEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (544, 2, NULL, NULL, 'DILARMINE 1MG C/25 TABS (SYNTEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (545, 2, 19, 56, 'DIMACOL ADULTO FRAMBUESA 150ML (WYETH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (546, 2, 19, 56, 'DIMACOL INFANTIL FRAMBUESA 150ML (WYETH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (547, 2, 19, 56, 'DIMACOL PEDIATRICO FRAMBUESA 60ML (WYETH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (548, 2, 19, 39, 'DIMETAPP INFANTIL JARABE 150ML UVA (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (549, 2, 19, 39, 'DIMETAPP PEDIATRICO 60ML (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (550, 2, 77, 107, 'DIOLMEX 120G POMADA (PHARMADIOL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (551, 2, 77, 107, 'DIOLMEX 40G POMADA (PHARMADIOL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (552, 2, 77, 107, 'DIOLMEX 60G POMADA (PHARMADIOL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (553, 2, NULL, NULL, 'DIPROSONE CREMA 30GR (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (554, 2, NULL, NULL, 'DIPROSONE G CREMA 30GR (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (555, 2, NULL, NULL, 'DIPROSONE Y CREMA 30GR (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (556, 2, NULL, NULL, 'DIPROSPAN 5ML  INY 5MG/2MG (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:36.725591+00', NULL);
INSERT INTO public.products VALUES (557, 2, 17, 9, 'DIPROSPAN HYPAK AMP 1ML (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (558, 2, NULL, NULL, 'Disons Dex c/1 Amp Iny Betametasona (Son''s)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (559, 2, NULL, NULL, 'DISPERA 2MG C/100 TABS LOPERAMIDA (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (560, 2, NULL, NULL, 'DISTENTAL 100MG 14 TABS (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (561, 2, NULL, NULL, 'DITIZIDOL FORTE DICLOFENACO /TIAMINA/ PIRIDOXINA/ CIANOCOBALAMINA C/30 TABS (BEST)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (562, 2, 38, 51, 'DIURMESSEL 40MG c/20 TABS FUROSEMIDA (BIOMEP)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (563, 2, NULL, NULL, 'Divanamia 700mg c/60 Capsulas (Nature''s´P.e.t. )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (564, 2, 72, 27, 'DIVILTAC INY C/1 AMP ALGESTONA+ESTRADIOL (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (565, 2, 17, 44, 'DOLAC  30MG c/4 TABS SUBLINGUAL KETOROLACO  (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (566, 2, 17, 44, 'DOLAC 10MG C/10 TABS (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (567, 2, 17, 44, 'DOLAC 10MG C/20 TABS (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (568, 2, 17, 44, 'DOLAC 30 C/2 TABLETAS (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (569, 2, 17, 44, 'DOLAC 30MG C/3 AMP (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (570, 2, NULL, NULL, 'DOLBUTIN 200MG C/30 TABS TRIMEBUTINA (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (571, 2, NULL, NULL, 'DOLFLAM C/4 AMP DICLOFENACO (RAYERE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (572, 2, NULL, NULL, 'DOLIKAN 10MG C/10 TABS KETOROLACO (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (573, 2, NULL, NULL, 'Dolo Bedoyecta Iny Hidroxocobalamina, Tiamina, Piridoxina y Ketoprofeno (Grossman)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (574, 2, 17, 48, 'DOLO NEUROTROPAS VITAMINADO EXHIBIDOR C/100 TABS (SAIMED)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (575, 2, 17, 30, 'DOLODOL VITAMINADO EXHIBIDOR C/80 TABS (BIOKEMICAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (576, 2, 17, 106, 'DOLO-NEORUBIÓN DC C/3 AMP (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (577, 2, NULL, NULL, 'DOLO-NEUROBION C/20 TABLETAS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (578, 2, NULL, NULL, 'DOLO-NEUROBION C/30 CAPSULAS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (579, 2, 17, 106, 'DOLO-NEUROBION DC FORTE INY (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (580, 2, 17, 106, 'DOLO-NEUROBION FORTE C/30 TABS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (581, 2, NULL, NULL, 'DOLPROFEN 600MG TABS (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (582, 2, 17, 12, 'DOLPROFEN 800MG C/60 + 60  TABS (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (583, 2, NULL, NULL, 'DOLTRIX 125MG C/20 TABS CLONIXINATO DE LISINA , HIOSCINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (584, 2, NULL, NULL, 'DOLTRIX 250MG C/10 TABS CLONIXINATO DE LISINA , HIOSCINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (585, 2, NULL, NULL, 'DON BRONQUIO 240ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (586, 2, NULL, NULL, 'DONSICOL 20MG C/30 PREDNISONA (RAAM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (587, 2, NULL, NULL, 'DONSICOL 20MG C/30 TABS PREDNISONA (RAAM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (588, 2, NULL, NULL, 'DORSAL 15MG/200MG C/7 TABS (SILANES)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (589, 2, NULL, NULL, 'Dosteril 10mg c/30 Tabs Lisinopril (Biomep)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (590, 2, NULL, NULL, 'DOXICICILINA 100MG C/10 TABS (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (591, 2, NULL, NULL, 'DOXICICILINA 100MG C/10 TABS (RANDALL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (592, 2, 78, 108, 'DRAMAMINE 50MG C/24 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (593, 2, NULL, NULL, 'DRAMAMINE INFANTIL 25MG SUPOSITORIOS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (594, 2, 78, 108, 'DRAMAMINE JBE INF. 120ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (595, 2, 12, 61, 'DUAL''S NORDIN ADULTO C/10 DOSIS (NORDIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (596, 2, NULL, NULL, 'DUAL''S NORDIN INF C/10 DOSIS (NORDIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (597, 2, NULL, NULL, 'DULCOLAX C/30 TABLETAS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (598, 2, NULL, NULL, 'EASY FIGURE FORTE C/30', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (599, 2, NULL, NULL, 'EASY FIGURE NORMAL C/30', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (600, 2, NULL, NULL, 'Echin Gold 50g c/40 Tabletas (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (601, 2, NULL, NULL, 'ECODINE-BF 120ML YODOPOVIDONA (CODIFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (602, 2, NULL, NULL, 'EDEGRA 100MG C/10 TABS SILDENAFIL (L.SERRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (603, 2, 56, 109, 'EDEGRA 100MG C/20 TABS SILDENAFIL (L.SERRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (604, 2, NULL, NULL, 'EFFORTIL GOTAS 7.5ML (ETILEFRINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (605, 2, NULL, NULL, 'EINAMEN 120ML HEDERA HELIX (PERRIGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (606, 2, NULL, NULL, 'El Garrotazo 500mg c/10 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (607, 2, NULL, NULL, 'El Viejito Pomada 120gr (Producto Pro Live Naturales)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (608, 2, NULL, NULL, 'ELDOPAQUE 2% CREMA 30G  Hidroquinona, Silicato de Magnesio (VALEANT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (609, 2, NULL, NULL, 'Eldopaque 4% Crema 30g Hidroquinona, Silicato de Magnesio (Valeant)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (610, 2, NULL, NULL, 'ELDOQUIN 4% CREMA 30GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (611, 2, NULL, NULL, 'ELECTROLITOS APO C/4 SOBRES LIMA-LIMON (PROTEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (612, 2, NULL, NULL, 'ELECTROLITOS APO C/4 SOBRES LIMON (PROTEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (1120, 2, NULL, NULL, 'LOTRIMIN 30GR (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (613, 2, NULL, NULL, 'ELECTROLITOS APO C/4 SOBRES MANZANA (PROTEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (614, 2, NULL, NULL, 'ELECTROLITOS APO C/4 SOBRES NARANJA  (PROTEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (615, 2, NULL, NULL, 'ELECTROLITOS APO C/4 SOBRES PIÑA (PROTEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (616, 2, NULL, NULL, 'ELECTROLITOS C/25 SOBRES SUERO ORAL (PROTEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (617, 2, NULL, NULL, 'ELICA 0.1% UNG', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (618, 2, NULL, NULL, 'ELITE CLOFENAMINA COMPUESTO C/10', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (619, 2, NULL, NULL, 'ELOMET 30G UNG MOMETASONA (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (620, 2, NULL, NULL, 'ELYM K 250ML JARABE (API ROYAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (621, 2, NULL, NULL, 'EMLA CREMA 30G LIDOCAINA,PRILOCAINA (ASPEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (622, 2, NULL, 110, 'EMPLASTO MONOPOLIS C/20 PARCHES (GRISI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (623, 2, NULL, NULL, 'ENALADIL 10MG C/30 COMPRIMIDOS (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (624, 2, NULL, NULL, 'ENALAPRIL  10MG C/60 TABS (Avivia)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (625, 2, NULL, NULL, 'ENALAPRIL 10MG C/30 TABS (AVIVIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (626, 2, 38, 50, 'ENALAPRIL 10MG C/30 TABS (PSICOFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (627, 2, NULL, NULL, 'ENALAPRIL 10MG C/30 TABS (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (628, 2, NULL, NULL, 'ENJUAGUE A BASE DE SAVILA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (629, 2, NULL, NULL, 'ENOVAL 10MG C/30 TABS ENALAPRIL (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (630, 2, NULL, NULL, 'EPAMIN 100MG C/50 CAPS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (631, 2, NULL, NULL, 'Equinacea Complex 1g c/90 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (632, 2, NULL, NULL, 'EQUINAFORTE 1GR C/90 (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (633, 2, NULL, NULL, 'EQUINOFORTE C/90 (Sandy)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (634, 2, 75, 28, 'ERBITRAX  30G TERBINAFINA (LOEFFLER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (635, 2, 75, 28, 'ERBITRAX-T  250MG C/28 TABS TERBINAFINA (LOEFFLER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (636, 2, 75, 28, 'ERBITRAX-T  250MG C/7 TABS TERBINAFINA (LOEFFLER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (637, 2, 15, 31, 'ERISPAN  C/1 AMP Y JERINGA BETAMETASONA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (638, 2, 15, 31, 'ERISPAN COMPUESTO PEDIATRICO 60ML (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (639, 2, 20, 73, 'ERITROLAT 60ML ERITROMICINA (LIFERPAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (640, 2, 20, 111, 'ERITROMICINA  500MG C/20 TABS. (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (641, 2, 20, 112, 'ERITROMICINA 250MG SUSP (NEOLPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (642, 2, 20, 20, 'ERITROMICINA 500MG C/20 TABS (RANDALL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (643, 2, NULL, NULL, 'ERITROVIER T 500MG C/20 TABS ERITROMICINA (TECNOFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (644, 2, NULL, NULL, 'ESCITALOPRAM 10MG C/28 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (645, 2, NULL, NULL, 'ESKAFIAM C/30 TABLETAS (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (646, 2, NULL, NULL, 'ESKAPAR 200MG C/16 CAPS NIFUROXAZIDA (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (647, 2, NULL, NULL, 'ESPABION 100ML SUSP TRIMEBUTINA (DEGORTS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (648, 2, NULL, NULL, 'ESPABION 200MG C/20 TABS TRIMEBUTINA (DEGORTS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (649, 2, 79, 91, 'ESPABION 200MG C/40 TABS TRIMEBUTINA (DEGORTS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (650, 2, NULL, NULL, 'ESPACIL COMPUESTO 125MG/10MG C/20 CAPS (VALEANT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (651, 2, 79, 98, 'ESPAVEN 30ML PEDIATRICO DIMETICONA (VALEANT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (652, 2, NULL, NULL, 'ESPAVEN 40/50MG C/24 TABS (VALEANT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (653, 2, 79, 98, 'Espaven Enzimatico c/50 Grageas (Valeant)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (654, 2, NULL, NULL, 'ESPERMA VIBORA DE CASCABEL INCIENSO C/2', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (655, 2, NULL, NULL, 'ESPINICIDA VOAM 19GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (656, 2, NULL, NULL, 'Espino Blanco c/150 Caps (Prosa)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:37.399769+00', NULL);
INSERT INTO public.products VALUES (657, 2, 13, 113, 'ESTOMAQUIL POLVO C/20 SOBRES 13G C/U (L.HIGIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (658, 2, NULL, NULL, 'ESTOMAQUIL TIRA C/24 TABS MASTICABLES MENTA (L.HIGIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (659, 2, NULL, NULL, 'ESTROGENOL C/100 CAPS (PLANTIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (660, 2, NULL, NULL, 'Etabus 250mg c/15  Tabs Disulfiram (Ferring)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (661, 2, NULL, NULL, 'Etabus 250mg c/36 Tabs Disulfiram (Ferring)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (662, 2, NULL, NULL, 'ETER 250ML (LA FLOR)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (663, 2, NULL, NULL, 'ETER 500ML (LA FLOR)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (664, 2, 30, 114, 'EUCALIN 120ML JARABE (SALUD NATURAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (665, 2, 30, 114, 'EUCALIN 240ML JARABE (SALUD NATURAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (666, 2, 30, 114, 'Eucalin Infantil Jarabe 240ml (Salud Natural)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (667, 2, 30, 114, 'EUCALIN KID''S 240ML JARABE (SALUD NATURAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (668, 2, 30, 62, 'EUCALIPTINE 100MG C/10 AMP (PISA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (669, 2, 19, 62, 'EUCALIPTINE JARABE 140ML (PISA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (670, 2, 30, 75, 'Eucamiel Unguento 60g (Anahuac)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (671, 2, NULL, NULL, 'EUGLUCON 5MG C/50 TABS (ROCHE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (672, 2, NULL, NULL, 'EUTIROX 100MG C/50 TABS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (673, 2, 80, 106, 'EUTIROX 150MG C/50 (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (674, 2, NULL, NULL, 'EUTIROX 50MG C/50', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (675, 2, NULL, NULL, 'EXCEDRIN DOLOR DE CABEZA C/10 TAB', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (676, 2, NULL, NULL, 'EXCEDRIN MIGRAÑA C/24 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (677, 2, 81, 110, 'EXCELSIOR POMADA CALLICIDA 8G C/10 (GRISI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (678, 2, NULL, NULL, 'Extermina Grasa 1g c/30 Tabletas (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (679, 2, NULL, NULL, 'Extracto 7 Azahares 80ml (Energreen)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (680, 2, NULL, NULL, 'Extracto Boldo 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (681, 2, NULL, NULL, 'EXTRACTO CALENDULA 60ML (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (682, 2, NULL, NULL, 'Extracto Cascara Sagrada 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (683, 2, NULL, NULL, 'Extracto Cascara Sagrada 80ml (Energreen)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (684, 2, NULL, NULL, 'Extracto Castaño de Indias 120ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (1265, 2, NULL, NULL, 'MUCIBRON 120ML AMBROXOL (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (685, 2, NULL, NULL, 'Extracto Castaño de Indias 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (686, 2, NULL, NULL, 'Extracto Castaño de Indias 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (687, 2, NULL, NULL, 'Extracto Chaparro Amargo 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (688, 2, NULL, NULL, 'Extracto Chaparro Amargo 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (689, 2, NULL, NULL, 'Extracto Cola de Caballo 80ml (Energreen)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (690, 2, NULL, NULL, 'Extracto Compuesto de Chaparro Amargo Ajo 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (691, 2, NULL, NULL, 'EXTRACTO CUACHALATE 60ML (NATURAL FLOWER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (692, 2, NULL, NULL, 'Extracto Cuasia 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (693, 2, NULL, NULL, 'Extracto de Ajo 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (694, 2, NULL, NULL, 'Extracto de Ajo Compuesto 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (695, 2, NULL, NULL, 'Extracto de Alcachofa 120ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (696, 2, NULL, NULL, 'Extracto de Alcachofa 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (697, 2, NULL, NULL, 'Extracto de Artrikar Plus 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (698, 2, NULL, NULL, 'Extracto de Copalquin 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (699, 2, NULL, NULL, 'EXTRACTO DE DAMIANA 75ML (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (700, 2, NULL, NULL, 'Extracto de Damiana 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (701, 2, NULL, NULL, 'Extracto de Dolokar Plus 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (702, 2, NULL, NULL, 'EXTRACTO DE ENEBRO 75ML (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (703, 2, NULL, NULL, 'Extracto de Equinacea c/ Propoleo 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (704, 2, NULL, NULL, 'Extracto de Fenogreco 80ml (Ener Green )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (705, 2, NULL, NULL, 'Extracto de Hongo Michoacano c/10 Amp (GN + Vida)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (706, 2, NULL, NULL, 'Extracto de Muerdago 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (707, 2, NULL, NULL, 'EXTRACTO DE PANCREATYN 75ML (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (708, 2, NULL, NULL, 'Extracto de Pasiflora 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (709, 2, NULL, NULL, 'Extracto de Tepezcohuite 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (710, 2, NULL, NULL, 'Extracto de Uva Ursi Compuesto 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (711, 2, NULL, NULL, 'EXTRACTO DE VAINILLA 60ML (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (712, 2, NULL, NULL, 'Extracto Diabe Pax 120ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (713, 2, NULL, NULL, 'Extracto Diabekar 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (714, 2, NULL, NULL, 'Extracto Diabetina 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (715, 2, NULL, NULL, 'Extracto Diente de Leon 80ml (Energreen)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (716, 2, NULL, NULL, 'Extracto Enebro 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (717, 2, NULL, NULL, 'Extracto Equinace 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (718, 2, NULL, NULL, 'Extracto Espino Blanco 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (719, 2, NULL, NULL, 'Extracto Espino Blanco 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (720, 2, NULL, NULL, 'Extracto Gastri Pax 120ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (721, 2, NULL, NULL, 'Extracto Ginkgo Biloba 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (722, 2, NULL, NULL, 'Extracto Golden Seal , Echinacea Ginkgobiloba 30ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (723, 2, NULL, NULL, 'Extracto H. de SN Jn 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (724, 2, NULL, NULL, 'Extracto H-Fin 30ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (725, 2, NULL, NULL, 'Extracto Hierba de San Juan 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (726, 2, NULL, NULL, 'Extracto Lechuga 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (727, 2, NULL, NULL, 'Extracto Meno Pax 120ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (728, 2, NULL, NULL, 'Extracto Migra Green 80ml (Energreen)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (729, 2, NULL, NULL, 'EXTRACTO NATURAL DE CASTAÑO DE INIDIAS CON HAMAMELIS 60ML (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (730, 2, NULL, NULL, 'Extracto Natural Ginkgo Biloba 60ml (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (731, 2, NULL, NULL, 'Extracto Natural Lina-Sen 60ml (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (732, 2, NULL, NULL, 'Extracto Natural Neem 60ml (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (733, 2, NULL, NULL, 'Extracto Neem 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (734, 2, NULL, NULL, 'Extracto Nlerim 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (735, 2, NULL, NULL, 'Extracto Ojo de Gallina 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (736, 2, NULL, NULL, 'Extracto Palo de Arco 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (737, 2, NULL, NULL, 'Extracto Phytolaca Compuesta Tlanchalagua 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (738, 2, NULL, NULL, 'Extracto Precardil 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (739, 2, NULL, NULL, 'Extracto R1ñobil 80ml (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (740, 2, NULL, NULL, 'Extracto Raiz de Yuca 60ml (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (741, 2, NULL, NULL, 'Extracto Riño Pax 120ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (742, 2, NULL, NULL, 'Extracto Sarivan-O 80ml (Energreen)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (743, 2, NULL, NULL, 'Extracto Semilla de Uva 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (744, 2, NULL, NULL, 'Extracto Sinusol 80ml (Energreen)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (745, 2, NULL, NULL, 'Extracto Tepescouite 60ml (Natural Flower)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (746, 2, NULL, NULL, 'Extracto Thuja 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (747, 2, NULL, NULL, 'Extracto Tila, Azahar,Valeriana 60ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (748, 2, NULL, NULL, 'Extracto Uri Health 80ml (Energreen)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (749, 2, 20, 12, 'FACELIT 500MG C/20 CAPS CEFALEXINA (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (750, 2, NULL, NULL, 'FACICAM C/20 CÁPSULAS (IPAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (751, 2, 76, 115, 'FASTERIX UNG RECTAL 20G LIDOCAINA/ HIDROCORTISONA (FARMA HISP)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (752, 2, NULL, NULL, 'FAZOLIN F 15ML  NAFAZOLINA, FENIRAMINA (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (753, 2, 17, 44, 'FEBRAX C/5 SUPOSITORIOS (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (754, 2, NULL, NULL, 'FEDPROS 0.4MG c/20 CAPS. TAMSULOCINA (RAAM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (755, 2, NULL, NULL, 'FELDENE 20MG C/20 CAPS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (756, 2, NULL, NULL, 'FENICOL OFTÁLMICO 10ML GOTAS (OFFENBACH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.158083+00', NULL);
INSERT INTO public.products VALUES (757, 2, NULL, NULL, 'FENTERMINA (Psicofarma) c/30 TABS. 30 MG.', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (758, 2, NULL, NULL, 'FERDEPSA 15 ML. GOTAS SULFATO FERROSO (FARMADEXTRUM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (759, 2, NULL, NULL, 'FER-IN-SOL PEDIÁTRICO SOL 50ML (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (760, 2, NULL, NULL, 'FERMIG 50 MG.C/20 TABS. SUMATRIPTAN (RAAM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (761, 2, NULL, NULL, 'FEROMONAS HOMBRE INIDIAN (CHAKRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (762, 2, NULL, NULL, 'FEROMONAS MUJER INDIAN (CHAKRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (763, 2, 12, 116, 'Ferranina 100ml Solucion Hierro Polimaltosado (Nycomed)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (764, 2, 12, 117, 'FERRANINA COMPLEX C/30 TABLETAS (TAKEDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (765, 2, 12, 117, 'FERRANINA FOL C/30 TABLETAS (TAKEDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (766, 2, 12, 117, 'FERRANINA I.M. C/3 AMP (TAKEDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (767, 2, NULL, NULL, 'Ferro 4 c/30 Grageas Fumarato Ferroso, Vitamina C,B1,B6,B12 (Streger)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (768, 2, NULL, NULL, 'FIBRA XOTZIL DURAZNO 620GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (769, 2, NULL, NULL, 'FIBRA XOTZIL MANGOO 620GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (770, 2, NULL, NULL, 'FIBRA XOTZIL MANZANA VERDE 620GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (771, 2, NULL, NULL, 'FIBRA XOTZIL NARANJA 620GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (772, 2, NULL, NULL, 'FIBRA XOTZIL ORIGINAL 620GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (773, 2, NULL, NULL, 'FIBRA XOTZIL VAINILLA 620GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (774, 2, NULL, NULL, 'FIGRAL 100MG C/4 TABS SILDENAFIL (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (775, 2, 56, 33, 'FIGRAL 100MG EXH C/20 TABS SILDENAFIL (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (776, 2, NULL, NULL, 'FINASTERIDA 5MG C/30 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (777, 2, 20, 41, 'FLAGENASE 400 C/30 CAPSULAS METRONIDAZOL, (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (778, 2, 20, 41, 'FLAGENASE 400 PEDIÁTRICO SUSP 120ML (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (779, 2, 20, 41, 'FLAGENASE 500MG C/30 TABLETAS (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (780, 2, NULL, NULL, 'FLAGYL 250MG C/30 COMPRIMIDOS (MEDLEY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (781, 2, NULL, NULL, 'FLAGYL 500MG C/10 OVULOS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (782, 2, NULL, NULL, 'FLAGYL 500MG C/30 COMPRIMIDOS METRONIDAZOL  (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (783, 2, NULL, NULL, 'FLAGYL/METRONIDAZOL 125MG SUSPENSION 120ML  (MEDLEY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (784, 2, NULL, NULL, 'FLAGYSTATIN V 500MG/1000,000UI C/10 ÓVULOS(MEDLEY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (785, 2, NULL, NULL, 'FLANAX 550MG  C/24 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (786, 2, NULL, NULL, 'FLANAX 550MG C/30 TABS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (787, 2, NULL, NULL, 'FLAUSIVER 450/50MG C/20 TABS DIOSMINA/HESPERIDINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (788, 2, NULL, NULL, 'FLEBOCAPS C/30 TABS (PHARMACAPS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (789, 2, NULL, NULL, 'FLENALUD 120ML HEDERA HELIX (SALUD NATURAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (790, 2, NULL, NULL, 'FLOXANTINA 500MG C/12 TABS CIPROFLOXACINO (DEGORTS CHEMICAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (791, 2, 20, 28, 'FLUOCINOLONA/METRONIDAZOL/NISTATINA c/10 OVULOS  (LOEFFLER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (792, 2, NULL, NULL, 'FLUOXETINA 20MG C/14 CAPS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (793, 2, NULL, NULL, 'FLUOXETINA 20MG C/14 CAPS (PSICOFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (794, 2, NULL, NULL, 'FOLIVITAL 0.4MG C/30 TABS (SILANES)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (795, 2, NULL, NULL, 'Folivital 4mg c/90 Tabs (Silanes)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (796, 2, NULL, NULL, 'FORTICAL B C/30 GRAGEAS (SERRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (797, 2, NULL, NULL, 'Fortical Forte Iny c/3 Amp Diclofenaco, B1,B2,B12 (Serral)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (798, 2, NULL, NULL, 'FOSFOCIL 500MG C/12 CAPS FOSFOMICINA (CETUS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (799, 2, NULL, NULL, 'FOSFOCIL I.M 1G  FOSFOMICINA (CETUS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (800, 2, NULL, NULL, 'FOSHLENN 300MG C/16 CAPS CLINDAMICINA (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (801, 2, NULL, NULL, 'FURACIN POMADA 85GR (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (802, 2, NULL, NULL, 'FUROSEMIDA 40MG C/100 TABS (NEOLPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (803, 2, NULL, NULL, 'FUROSEMIDA 40MG C/100 TABS (PHARMA RX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (804, 2, NULL, NULL, 'GABADIOL 150 MG C/60 TABS PREGABALINA (SBL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (805, 2, NULL, NULL, 'Gabapentina 800mg c/30 Tabs (Ultra)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (806, 2, 82, 31, 'GALAVER GEL 250ML MAGALDRATO/ DIMETICONA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (807, 2, NULL, NULL, 'GARAMICINA G.U. 160MG C/5 AMP (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (808, 2, NULL, NULL, 'GARAMICINA G.U. 160MG HYPAC (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (809, 2, NULL, NULL, 'GARAMICINA OFTALMICA 10ML GOTAS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (810, 2, NULL, NULL, 'GARCINIA CAMBOGIA 50MMG C/60 CAPS (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (811, 2, NULL, NULL, 'GARCINIA GAMBOGIA 500MG C/60 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (812, 2, NULL, NULL, 'Garcinia Gambogia 50mg c/60 Caps (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (813, 2, NULL, NULL, 'GARCINIA GAMBOGIA C/60 (ANAHUAC)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (814, 2, NULL, NULL, 'Garcinia Gambogia Noche 1g c/90 Tabletas (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (815, 2, NULL, NULL, 'GASA 10 X 10 C/100 (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (816, 2, NULL, NULL, 'GB SHAMPOO DOS 230ML  (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (817, 2, NULL, NULL, 'GB SHAMPOO UNO 230ML (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (818, 2, NULL, NULL, 'GB SOLUCION ALOPECIA 60ML (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (819, 2, NULL, NULL, 'GEL ALGAS MARINAS Y EUCALIPTO 125GR (MEGAMIX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (820, 2, NULL, NULL, 'GEL CASTAÑO DE INDIAS 120GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (821, 2, NULL, NULL, 'GEL PEYOTE C/MARIHUANA 250GRS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (822, 2, NULL, NULL, 'GEL VENENO DE ABEJA 120GR (ECO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (823, 2, NULL, NULL, 'GEL VITAL SLIM 250GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (824, 2, NULL, NULL, 'GELDAKO 10MG C/10 CAPS KETOROLACO (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (825, 2, NULL, NULL, 'GELMICIN 60G Betametasona,Gentamicina,Clotrimazol (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (826, 2, NULL, NULL, 'GENKOVA C/5 AMP 80MG GENTAMICINA (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (827, 2, 20, 40, 'GENREX I.U C/5 AMP 160MG/2ML (RAYERE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (828, 2, NULL, NULL, 'Gentamicina c/5 Amp 160mg/2ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (829, 2, 60, 118, 'GENTILAX C/50 TABS LAXANTE (DR. MONTFORT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (830, 2, NULL, NULL, 'GERIAL B-12 JARABE  ELIXIR (ALLEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (831, 2, NULL, NULL, 'GESLUTIN 200MG C/15 PERLAS (ASOFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (832, 2, NULL, NULL, 'GLANIQUE 0.75 MG C/2 COMPRIMIDOS (ASOFARME)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (833, 2, NULL, NULL, 'GLIBENCLAMIDA 5MG C/100 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (834, 2, NULL, NULL, 'GLIBENCLAMIDA 5MG C/50 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (835, 2, NULL, NULL, 'GLIBENCLAMIDA 5MG C/50 TABS (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (836, 2, NULL, NULL, 'GLICERINA 120ML (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (837, 2, NULL, NULL, 'GLIMETAL 2MG/1000MG C/30 TABS (SILANES)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (838, 2, NULL, NULL, 'Glucobay 100mg c/30 Comprimidos Acarbosa (Bayer)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (839, 2, NULL, NULL, 'GLUCOBAY 50MG C/30 COMPRIMIDOS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (840, 2, NULL, NULL, 'Glucosamina 1g c/60 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (841, 2, NULL, NULL, 'GLUCOSAMINA 800MG C/60 TABS (FARNAT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (842, 2, NULL, NULL, 'GLUCOVANCE 500MG/2.5MG C/60 TABS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (843, 2, NULL, NULL, 'GLUCOVANCE 500MG/5MG C/60 TABS (GENERICO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (844, 2, NULL, NULL, 'GOICOTABS VARICES C/30 TABS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (845, 2, NULL, NULL, 'GOODSIT C/6 SUPOSITORIOS LIDOCAINA, HIDROCORTISONA (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (846, 2, NULL, NULL, 'GOTINAL 15ML (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (847, 2, NULL, NULL, 'GOTINAL AD NAZAL 15ML (PROMECO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (848, 2, NULL, NULL, 'GOTINAL INF NAZAL 15ML (PROMECO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (849, 2, NULL, NULL, 'GRANEODIN B C/24 MIEL LIMON', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (850, 2, NULL, NULL, 'GRANEODIN F C/16 TABS MIEL/LIMON FLURBIPROFENO  (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (851, 2, 50, 119, 'GRANEODIN FRAMBUESA C/24 TABS (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (852, 2, 50, 119, 'GRANEODIN MANDARINA C/24 TABS (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (853, 2, 50, 119, 'GRANEODIN MENTA/EUCALIPTO C/24 TABS (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (854, 2, NULL, NULL, 'GRANOEDIN B 10MG C/24 PASTILLAS FRAMBUESA (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (855, 2, NULL, NULL, 'GRAVIDINONA 500MG C/1 AMP (SCHERING)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:38.740333+00', NULL);
INSERT INTO public.products VALUES (856, 2, NULL, NULL, 'GRIMAL 10ML OFTALMICO (GRIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (857, 2, NULL, NULL, 'GRISOVIN F.P 500MG C/30 TABS  (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (858, 2, NULL, NULL, 'GROOBE 50MG C/24 CAPS DIMENHIDRINATO (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (859, 2, NULL, NULL, 'Guayacol con Eucalipto 650mg c/30 Caps (Anahuac)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (860, 2, 30, 120, 'Guayap-tol 740mg c/30 Caps Eucalipto, Menta y Vitamina E (Medica Natural)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (861, 2, NULL, NULL, 'Guayap-tol Adulto Jarabe 120ml Eucalipto y Guayacol (Medica Natural)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (862, 2, NULL, NULL, 'Guayap-tol Infantil Jarabe 120ml Eucalipto y Guayacol (Medica Natural)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (863, 2, NULL, NULL, 'GUAYATETRA ADULTO INY (RANDALL L)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (864, 2, NULL, NULL, 'Guayatetra c/30 Caps Eucalipto y Guayacol (Randall Laboratories)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (865, 2, NULL, NULL, 'GYNODAKTARIN 400MG OVULOS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (866, 2, NULL, NULL, 'GYNODAKTARIN CREMA 3 DIAS 25GR (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (867, 2, NULL, NULL, 'GYNOVIN C/21 GRAGEAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (868, 2, NULL, NULL, 'H. de SN Jn 500mg c/60 Tabletas (''''Garden Life'''' )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (869, 2, NULL, NULL, 'HABAS CON CASCARA C/20 BOLSAS 900GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (870, 2, NULL, NULL, 'HAIR CLEAN NEEM + PANTHENOL 2.0 OZ (PLANTIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (871, 2, 68, 121, 'HALLS CEREZA C/18  (ADAMS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (872, 2, NULL, 121, 'HALLS EXPERT MIX C/18  (ADAMS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (873, 2, NULL, 121, 'HALLS EXTRA STRONG C/18  (ADAMS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (874, 2, NULL, 121, 'HALLS MENTA C/18  (ADAMS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (875, 2, NULL, 121, 'HALLS MIEL Y LIMON C/18  (ADAMS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (876, 2, NULL, 121, 'HALLS MIX C/18  (ADAMS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (877, 2, NULL, 121, 'HALLS YERBABUENA C/18  (ADAMS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (878, 2, NULL, NULL, 'Hemanina c/10 Amp Extracto de Higado y Vitaminas del Complejo B (Altana)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (879, 2, NULL, NULL, 'HEMOBION 200MG C/30 TABS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (880, 2, NULL, NULL, 'HEMOSIN-K C/3 AMP (HORMONA LABS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (881, 2, NULL, NULL, 'HEMOSIN-K ORAL C/32 TABLETAS (HORMONA LABS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (882, 2, NULL, NULL, 'Henna Colorante Vegetal 70grs Bolsa c/10 Sobres (Avant) (TRACY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (883, 2, NULL, NULL, 'HEPANAT JBE HEPATICO Y COLERETICO  120ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (884, 2, NULL, NULL, 'HERKLIN KIT SHAMPOO 120ML + SPRAY 30ML C/PEINE (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (885, 2, NULL, NULL, 'HERKLIN SHAMPOO 120ML C/PEINE (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (886, 2, NULL, NULL, 'HERKLIN SHAMPOO 60ML C/PEINE (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (887, 2, 83, NULL, 'H-FIN JABON 100G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (888, 2, NULL, NULL, 'HI-DEX 100MG C/3 AMP HIERRO (HORMONA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (889, 2, NULL, NULL, 'HIERBA DE SAN JUAN 1200MG C/30 CAPS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (890, 2, NULL, NULL, 'Hierba del Sapo 50mg c/60 Tabletas (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (891, 2, NULL, NULL, 'HIERBA DEL SAPO C/150 CÁPSULAS (PROSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (892, 2, NULL, NULL, 'Hierba del Sapo Plus 1g c/90 Tabletas (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (893, 2, NULL, NULL, 'Hierro c/10 Amp (GN + Vida)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (894, 2, NULL, NULL, 'Hierro Jarabe 340ml (GN + Vida)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (895, 2, NULL, NULL, 'HIGROTON 50MG C/30 TABS CLORTALIDONA (SANDOZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (896, 2, NULL, NULL, 'HIPEBE 0.4MG C/20 TABS TAMSULOSINA LANDSTEINER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (897, 2, NULL, NULL, 'HIPOGLOS TARRO 110G POMADA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (898, 2, 33, 11, 'HISTIACIL FAM ADULTO 140 ML GUAIFENESINA, OXOLAMINA (SONOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (899, 2, 33, 11, 'HISTIACIL FAM INFANTIL 140 ML GUAIFENESINA, OXOLAMINA (SONOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (900, 2, 33, 11, 'HISTIACIL FAM PEDIATRICO 60ML GUAIFENESINA, OXOLAMINA  (SONOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (901, 2, NULL, NULL, 'HISTIACIL FLU ANTIGRIPAL C/20 TABS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (902, 2, NULL, NULL, 'HISTIACIL NATIX ADULTO 100ML HEDERA HELIX (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (903, 2, NULL, NULL, 'HISTIACIL NATIX INFANTIL 100ML HEDERA HELIX (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (904, 2, 33, 11, 'HISTIACIL NF PEDIATRICO 30ML DEXTROMETORFANO/ AMBROXOL (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (905, 2, NULL, NULL, 'HONGO FIN ESMALTE 15ML (ENER GREEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (906, 2, NULL, NULL, 'HONGO FIN POMADA 125GR (ENER GREEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (907, 2, NULL, NULL, 'HONGO FIN POMADA 40GR (ENER GREEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (908, 2, NULL, NULL, 'Hongo Michoacano 1Litro', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (909, 2, NULL, NULL, 'HONGO-FIN SHAMPOO 260ML (ENER GREEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (910, 2, NULL, NULL, 'HONGO-FIN SPRAY 150ML (ENER GREEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (911, 2, NULL, NULL, 'HUEVO C/12 (GREZON)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (912, 2, NULL, NULL, 'HUEVO KINDER C/12 (KINDER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (913, 2, NULL, NULL, 'HUEVO KINDER C/8 DE 12 PIEZAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (914, 2, NULL, NULL, 'HUEVO NATOONS C/12 (KINDER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (915, 2, NULL, NULL, 'HUEVO SORPRESA C/12 (KINDER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (916, 2, NULL, NULL, 'HYDRALITOS SUERO 1L (RRX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (917, 2, NULL, NULL, 'HYDRASOR C/25 SOBRES ELECTROLITOS (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (918, 2, NULL, NULL, 'I.Q Memory 800mg c/100 Capuslas (Nature''s ´P.e.t. )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (919, 2, NULL, NULL, 'I.Q Students Memory 520g c/90 Capsulas (Nature''s ´P.e.t. )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (920, 2, NULL, NULL, 'ICADEN CREMA 20GR (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (921, 2, NULL, NULL, 'Icy Hot c/5 Parches Mentol 5%', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (922, 2, NULL, NULL, 'Icy Hot Crema 85g', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (923, 2, NULL, NULL, 'Icy Hot Spray Mentol 5%', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (924, 2, NULL, NULL, 'ILIADIN AD GOTAS 20ML (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (925, 2, NULL, NULL, 'ILIADIN INF GOTAS 20ML (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (926, 2, NULL, NULL, 'ILIADIN LUB INF SPRAY 20ML (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (927, 2, NULL, NULL, 'ILIADIN OXIMETAZOLINA SPRAY ADULTO 30ML (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (928, 2, NULL, NULL, 'ILOSONE 125MG SUSP (LILLY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (929, 2, NULL, NULL, 'ILOSONE 250MG SUSP (LILLY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (930, 2, NULL, NULL, 'ILOSONE 500MG C/20 TABS (LILLY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (931, 2, NULL, NULL, 'IMODIUM C/12 TABLETAS (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (932, 2, NULL, NULL, 'INCIENSO VIBORA DE CASCABEL (ESOTERICO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (933, 2, NULL, NULL, 'INDERALICI 40MG C/30 TABLETAS (ASTRAZENECA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (934, 2, NULL, NULL, 'INSUSYM 5MG C/100 TABS GLIBENCLAMIDA (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (935, 2, NULL, NULL, 'INTERNOL 100MG C/100 TABS ATENOLOL (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (936, 2, NULL, NULL, 'INTERNOL 100MG C/28 TABS ATENOLOL (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (937, 2, 38, 49, 'INTERNOL 50MG C/100 TABS ATENOLOL (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (938, 2, 36, 22, 'IODEX CLASICO 60G (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (939, 2, 36, 22, 'IODEX CRITAL 60G  (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (940, 2, NULL, NULL, 'IRRESARTAN 150MG C/28 TABS (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (941, 2, 84, 38, 'ISODINE BUCOFARINGEO 120ML (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (942, 2, NULL, NULL, 'ISODINE DUCHA VAGINAL 120ML (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (943, 2, NULL, NULL, 'ISODINE ESPUMA 120ML (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (944, 2, 84, 38, 'ISODINE SOLUCIÓN 120ML (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (945, 2, NULL, NULL, 'ISORBID  10MG C/40 TABS DINITRATO DE ISOSORBIDA  (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (946, 2, NULL, NULL, 'Isox 15 D 100mg c/15 Caps Itraconazol (Senosiain)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (947, 2, NULL, NULL, 'ITRACONAZOL 100MG C/15 TABS  (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (948, 2, NULL, NULL, 'ITRACONAZOL 100MG C/15 TABS (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (949, 2, NULL, NULL, 'ITRAVIL 30MG C/6O CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (950, 2, NULL, NULL, 'IVEXTERM 6MG C/4 TABS IVERMECTINA (VALEANT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (951, 2, NULL, NULL, 'JABON ABRECAMINO 90GR (BLANCA FLOR MAGICA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (952, 2, NULL, NULL, 'JABON ACEITE DE COCO 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (953, 2, NULL, NULL, 'JABON ACEITE DE JOJOBA (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (954, 2, NULL, NULL, 'JABON ACEITE DE OSO ALMEDRAS,OLIVO Y RICINO 125GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (955, 2, NULL, NULL, 'JABON ALGAS 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:39.390765+00', NULL);
INSERT INTO public.products VALUES (956, 2, NULL, NULL, 'Jabon Aloe Vera con Pulpa Natural 90g (Prosa) (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (957, 2, NULL, NULL, 'Jabon Antimicotico Hongo Piel 100g', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (958, 2, NULL, NULL, 'JABON ARBOL DE TE Y EUCALIPTO 125G (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (959, 2, NULL, NULL, 'JABON ARRASA CON TODO (FLOR DE LUJO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (960, 2, NULL, NULL, 'Jabon Artesanal de Aguacate (Megamix)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (961, 2, NULL, NULL, 'Jabon Artesanal Hiel de Toro (Megamix)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (962, 2, NULL, NULL, 'JABON AVENA Y MIEL 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (963, 2, NULL, NULL, 'Jabon Avena, Trigo, Miel 120g (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (964, 2, NULL, NULL, 'Jabon Azufre Con Aloe Vera 90g (Prosa)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (965, 2, NULL, NULL, 'JABON BABA DE CARACOL 100GR (VIDA HERBAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (966, 2, NULL, NULL, 'JABON BABA DE CARACOL 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (967, 2, NULL, NULL, 'JABON CACAHUANANCHE 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (968, 2, NULL, NULL, 'JABON CALENDULA 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (969, 2, NULL, NULL, 'JABON CHILE 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (970, 2, NULL, NULL, 'Jabon Chile de Arbol 120gr (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (971, 2, NULL, NULL, 'JABON CON ARCILLA VERDE 100GR (GIZEH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (972, 2, NULL, NULL, 'JABON CONCHA NACAR 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (973, 2, NULL, NULL, 'JABON CREMOSO EXTRA C/COLAGENO 125GR(INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (974, 2, NULL, NULL, 'Jabon de Algas 90g (Prosa) (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (975, 2, NULL, NULL, 'Jabon de Avena 90gr (Prosa) (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (976, 2, NULL, NULL, 'Jabon de Cacahuananche con Aloe Vera 90gr (Prosa) (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (977, 2, NULL, NULL, 'Jabon de Calendula 120gr (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (978, 2, NULL, NULL, 'Jabon de Colageno 120gr (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (979, 2, NULL, NULL, 'Jabon de Creolina (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (980, 2, NULL, NULL, 'Jabon de Escencias 100g', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (981, 2, NULL, NULL, 'Jabon de Escencias Doble 100g', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (982, 2, NULL, NULL, 'Jabon de Jitomate 120gr (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (983, 2, NULL, NULL, 'JABON DE TEPEZCOHUITE 125G (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (984, 2, NULL, NULL, 'JABON DE TEPEZCOHUITE 200GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (985, 2, NULL, NULL, 'Jabon del Perro Agradecido 120gr (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (986, 2, NULL, NULL, 'Jabon Derma Organic 100g', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (987, 2, NULL, NULL, 'JABON DOBLE SUERTE RAPIDA (FLOR DE LUJO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (988, 2, NULL, NULL, 'JABON GALLINA NEGRA (FLOR DE LUJO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (989, 2, NULL, NULL, 'Jabon H-Fin 100g (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (990, 2, NULL, NULL, 'JABON HIEL DE TORO (LA SALUD ES PRIMERO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (991, 2, NULL, NULL, 'Jabon Hongosan Premium Plus (Producto Homeopatico )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (992, 2, NULL, NULL, 'JABON JITOMATE 125G (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (993, 2, NULL, NULL, 'JABON LECHE DE BURRA 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (994, 2, NULL, NULL, 'JABON LECHE DE BURRA BODY CREAM', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (995, 2, NULL, NULL, 'Jabon Limpia Piel 100g', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (996, 2, NULL, NULL, 'JABON LIMPIAS 90GR (FLOR DE LUJO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (997, 2, NULL, NULL, 'JABON MIEL DE AMOR ELLAS/FERONOMAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (998, 2, NULL, NULL, 'JABON NEUTRO 100G (GRISI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (999, 2, NULL, NULL, 'JABON NEUTRO 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1000, 2, NULL, NULL, 'JABON PARA PERROS 125G (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1001, 2, NULL, NULL, 'JABON PARA PIOJOS HR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1002, 2, NULL, NULL, 'JABON PERROS CON CREOLINA 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1003, 2, NULL, NULL, 'JABON RUDA DERMOLIMPIADOR 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1004, 2, NULL, NULL, 'JABON SAN RAMON 80GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1005, 2, NULL, NULL, 'JABON TEPEZCOUITE (OCOTZAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1006, 2, NULL, NULL, 'JABON TEPEZCOUITE 3.5 (DAP)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1007, 2, NULL, NULL, 'Jabon Tepezcouite con Corteza Natural 90g (Prosa) (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1008, 2, NULL, NULL, 'JABON VERDE 120GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1009, 2, NULL, NULL, 'JABON VIBORA DE CASCABEL  (LA SALUD ES PRIMERO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1010, 2, NULL, NULL, 'JABON VIBORA DE CASCABEL (CELOFAN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1011, 2, NULL, NULL, 'JABON VIVBORA DE CASCABEL 120GR (NUTRIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1012, 2, NULL, NULL, 'JABON ZABILA 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1013, 2, NULL, NULL, 'JABON ZABILA Y AZUFRE 125GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1014, 2, NULL, NULL, 'JALEA REAL CON TIAMINA 650MG C/30 CAPS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1015, 2, 85, NULL, 'JERINGA 3ML 21X32 PLASTIPAK', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1016, 2, NULL, NULL, 'JERINGA 5ML 21X32 PLASTIPAK', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1017, 2, NULL, NULL, 'JUGO VERDE MIX 1 KILO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1018, 2, NULL, NULL, 'JUGO VERDE MIX 2 KILOS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1019, 2, NULL, NULL, 'KALIOLITE 500MG C/50 GRAGEAS CLORURO DE POTASIO (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1020, 2, 86, 65, 'KAOMYCIN 180ML NEOMICINA,CAOLIN,PECTINA (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1021, 2, 86, 65, 'KAOMYCIN C/20 TABS NEOMICINA,CAOLIN,PECTINA (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1022, 2, NULL, NULL, 'KAOPECTATE C/20 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1023, 2, NULL, NULL, 'KAPOSALT C/50 TABS SALES DE POTASIO (TECNOFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1024, 2, NULL, NULL, 'KASTORAAM 10MG C/10 TABS MONTELUKAST (RAAM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1025, 2, NULL, NULL, 'KEFLEX 1G C/12 TABS CEFALEXINA (LILLY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1026, 2, NULL, NULL, 'KEFLEX 250MG SUSP (LILLY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1027, 2, NULL, NULL, 'KEFLEX 500MG C/12 TABS CEFALEXINA (LILLY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1028, 2, NULL, NULL, 'KEFLEX 500MG C/20 TABS CEFALEXINA (LILLY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1029, 2, NULL, NULL, 'KENCICLEN 100MG C/10 CAPS DOXICICLINA (KENER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1030, 2, NULL, NULL, 'KENZOFLEX 500MG C/12 TABS BOTE CIPROFLOXACINO (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1031, 2, NULL, NULL, 'KENZOFLEX 500MG C/12 TABS CIPROFLOXACINO (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1032, 2, NULL, NULL, 'KENZOFLEX 500MG C/28 TABS CIPROFLOXACINO (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1033, 2, NULL, NULL, 'KESIPRIL 10MG C/10 TABS LISINOPRIL (KENER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1034, 2, NULL, NULL, 'KETOROLACO 10MG C/10 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1035, 2, NULL, NULL, 'KETOROLACO 10MG C/10 TABS (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1036, 2, NULL, NULL, 'KETOROLACO 10MG C/10 TABS (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1037, 2, NULL, NULL, 'KETOROLACO 30MG C/3 AMP (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1038, 2, 12, 38, 'KIDDI PHARMATON 100ML SUSP (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1039, 2, 12, 38, 'KIDDI PHARMATON 200ML SABOR NARANJA (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1040, 2, 12, 38, 'KIDDI PHARMATON C/30 TABS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1041, 2, NULL, NULL, 'Kitoscell 3.5g Gel (CTT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1042, 2, NULL, NULL, 'Kitoscell 30g Gel (CTT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1043, 2, 20, 31, 'KLARIX 250MG SUSP CLARITROMICINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1044, 2, 20, 31, 'KLARIX 500MG C/10 TABS CLARITROMICINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1045, 2, NULL, NULL, 'KLODEX 2MG C/100 TABS CLONAZEPAM (IFA CELTICS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1046, 2, NULL, NULL, 'Kola Loka 5g Goterito (Krazy)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1047, 2, 12, 30, 'KORTRIBION C/80 CAPSULAS (BIOKEMICAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1048, 2, NULL, NULL, 'KRAFASIN 40G Betametasona,Gentamicina,Clotrimazol (DANKEL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1049, 2, NULL, NULL, 'KROBICIN 250MG SUSP CLARITROMICINA (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1050, 2, NULL, NULL, 'LA MILAGROSA CREMA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1051, 2, NULL, NULL, 'La Tia Mana 50g Crema Acne, Espinillas, Paño, Pecas, Manchas de Sol y Arrugas Prematuras', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1052, 2, NULL, NULL, 'LABELLO 24HRS PROTECTOR LABIAL CEREZA (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1053, 2, NULL, NULL, 'LABELLO 24HRS PROTECTOR LABIAL FRESA (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.071399+00', NULL);
INSERT INTO public.products VALUES (1054, 2, NULL, NULL, 'LABELLO 24HRS PROTECTOR LABIAL HYDROCARE (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1055, 2, NULL, NULL, 'LABELLO 24HRS PROTECTOR LABIAL ORIGINAL (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1056, 2, NULL, NULL, 'LACTREX CREMA 60G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1057, 2, NULL, NULL, 'LACTREX LOCION 125ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1058, 2, 37, 104, 'LAKESIA 3ML CICLOPIROX (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1059, 2, NULL, NULL, 'LAMISIL 250MG C/10 TABLETAS (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1060, 2, NULL, NULL, 'LAMISIL 250MG C/20 TABLETAS (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1061, 2, NULL, NULL, 'LAMISIL 250MG C/30 TABLETAS (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1062, 2, 37, 122, 'LAMISIL CREMA 1% 30GR (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1063, 2, NULL, NULL, 'LAMISIL CREMA 15 GR (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1064, 2, NULL, NULL, 'LAMISIL SPRAY 30ML (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1065, 2, NULL, NULL, 'Laritol 10mg c/10 Tabs Loratadina (Maver)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1066, 2, NULL, NULL, 'LARITOL D 120ML ADULTO LORATADINA, FENILEFRINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1067, 2, NULL, NULL, 'LARITOL D 120ML INF LORATADINA, FENILEFRINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1068, 2, NULL, NULL, 'LARITOL EX 120ML LORATADINA, AMBROXOL  (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1069, 2, NULL, NULL, 'LARITOL EX C/10 TABS LORATADINA/ AMBROXOL (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1070, 2, NULL, NULL, 'LASIX 40MG C/24 TABS (AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1071, 2, NULL, NULL, 'LAWAZIN 5MG C/100 TABS GLIBENCLAMIDA (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1072, 2, NULL, NULL, 'LAXOBERON 30ML GOTAS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1073, 2, NULL, NULL, 'LAXOBERON C/20 TABLETAS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1074, 2, NULL, NULL, 'LECHE DE MAGNESIA NORMEX 180ML (PERRIGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1075, 2, NULL, NULL, 'LECHE DE MAGNESIA NORMEX 360ML (PERRIGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1076, 2, NULL, NULL, 'LECODER CREMA 20GR 2% MICONAZOL (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1077, 2, NULL, NULL, 'Lerk 100mg c/4 Comprimidos Sildenafil (Siegfried Rhein)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1078, 2, NULL, NULL, 'LEVADURA DE CERVEZA C/150 TABS (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1079, 2, NULL, NULL, 'LEVADURA DE CERVEZA C/250 CAPLETAS (PRONAT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1080, 2, NULL, NULL, 'LEVETIRACETAM 500MG C/60 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1081, 2, NULL, NULL, 'LEVITRA 20MG C/1 TAB (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1082, 2, NULL, NULL, 'Levofloxacino 500mg c/7 Tabletas (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1083, 2, NULL, NULL, 'LEVOFLOXACINO 500MG C/7 TABS (NEOLPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1084, 2, NULL, NULL, 'LEVONORGESTREL-ETINILESTRADIOL c/21 tabs (Tempus Pharma)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1085, 2, NULL, NULL, 'LEVONORGESTREL-ETINILESTRADIOL c/28 tabs (PERRIGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1086, 2, NULL, NULL, 'Levotiroxina  c/100 TABS. 0.100 MG.', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1087, 2, NULL, NULL, 'LEXOTAN 6MG C/100 TABS BROMAZEPAM (ROCHE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1088, 2, NULL, NULL, 'Libertrim 200mg c/24 Comprimidos Trimebutina (Carnot)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1089, 2, NULL, NULL, 'LIBIOCID 500MG C/ LINCOMICINA (RAYERE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1090, 2, NULL, NULL, 'LIBIOCID 600MG C/6 AMP LINCOMICINA (RAYERE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1091, 2, NULL, NULL, 'LIDOCAINA 35GR POMADA (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1092, 2, NULL, NULL, 'LINAZA PLUS 450GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1093, 2, NULL, NULL, 'LINCOCIN 100ML JARABE (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1094, 2, NULL, NULL, 'LINCOCIN 500MG C/16 CAPS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1095, 2, 20, 39, 'LINCOCIN 600MG/2 ML C/6 AMP (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1096, 2, NULL, NULL, 'LINCOCIN SOL 300MG/ML INY C/6 AMP (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1097, 2, NULL, NULL, 'LINCOMICINA 600MG C/6 AMPOLLETAS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1098, 2, 20, 31, 'LINCOVER 500MG C/16 CAPSULAS LINCOMICINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1099, 2, NULL, NULL, 'LINCOVER 600MG C/3 LINCOMICINA (MAVER )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1100, 2, NULL, NULL, 'LIPITOR 40MG C/15 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1101, 2, NULL, NULL, 'LIQUIDO CA-LLOSOL', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1102, 2, NULL, NULL, 'LIQUIDO MARAVILLA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1103, 2, NULL, NULL, 'LISINOPRIL 10MG C/30 TABS (MEDLEY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1104, 2, NULL, NULL, 'LISINOPRIL 20MG C/100 TABS (PHARMARX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1105, 2, NULL, NULL, 'LISONIN 500MG C/12 CAPS (SON''S)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1106, 2, NULL, NULL, 'LISONIN 600 INY C/6 (SON''S)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1107, 2, NULL, NULL, 'LISONIN C/1 AMP AD (SON''S)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1108, 2, NULL, NULL, 'LITIWEN 20MG C/100 TABS LISINOPRIL (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1109, 2, NULL, NULL, 'LOCION ABRAKADABRA PARA LIMPIAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1110, 2, NULL, NULL, 'LOCION GITANA PARA LIMPIAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1111, 2, NULL, NULL, 'LOCOID 15GR HIDROCORTISONA 1% (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1112, 2, NULL, NULL, 'LOMECAN V 20G (GENNOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1113, 2, NULL, NULL, 'LOMOTIL 2MG C/5 SOBRES (JANSSEN-CILAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1114, 2, NULL, NULL, 'LOMOTIL C/8 TABLETAS (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1115, 2, NULL, NULL, 'LONOL 60G CREMA (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1116, 2, NULL, NULL, 'LOPRESOR 100MG C/10 TABS (SANDOZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1117, 2, NULL, NULL, 'LORATADINA 10MG C/10 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1118, 2, NULL, NULL, 'LOROTEC 10MG C/10 (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1119, 2, NULL, NULL, 'LOSEC A-20 C/14 CÁPSULAS (GENOMMA LABS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1121, 2, NULL, NULL, 'LOTRIMIN AEROSOL (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1122, 2, NULL, NULL, 'LOVARIN EX 120ML AMBROXOL/ LORATADINA (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1123, 2, NULL, NULL, 'LOXCELL C/1 TAB ALBENDAZOL/ QUINFAMIDA (CELLPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1124, 2, NULL, NULL, 'LOXCELL JUNIOR ALBENDAZOL/ QUINFAMIDA (CELLPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1125, 2, NULL, NULL, 'LOXCELL PEDIATRICO ALBENDAZOL/ QUINFAMIDA (CELLPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1126, 2, NULL, NULL, 'LUNARIUM 100/300 MG C/14 CAPS BROMURO DE PINAVERIO-DIMECOTINA  (ITALMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1127, 2, NULL, NULL, 'LUTORAL - E C/20 TABS 2MG/80MCG (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1128, 2, NULL, NULL, 'Lydhia Pinckham 500mg c/90 Tabletas (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1129, 2, NULL, NULL, 'LYRICA 150MG C/14 CAPS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1130, 2, NULL, NULL, 'LYRICA 300MG C/14 CAPS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1131, 2, NULL, NULL, 'LYRICA 75MG C/14 CAPS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1132, 2, NULL, NULL, 'M FORCE C/10 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1133, 2, NULL, NULL, 'M FORCE C/30 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1134, 2, NULL, NULL, 'M FORCE C/30 CONDONES (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1135, 2, NULL, NULL, 'MACA 100% C/60 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1136, 2, NULL, NULL, 'MACROFURIN 100MG C/40 CAPS NITROFURANTOINA (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1137, 2, NULL, NULL, 'MADECASSOL  C/12 OVULOS  METRONIDAZOL,CENTELLA ASIATICA,NITROFURAL (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1138, 2, NULL, NULL, 'MAFENA RETARD 100MG C/20 TABS (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1139, 2, 82, 54, 'MAGALDRATO/DIMETICONA 10ML GEL C/10 SOBRES (AVIVIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1140, 2, NULL, NULL, 'MAGNOPYROL 500 MG C/10 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1141, 2, NULL, NULL, 'MAGNOPYROL 500MG C/50 COMPRIMIDOS (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1142, 2, 60, NULL, 'MAGSOKON TRIANGULO 26G C/20', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1143, 2, 60, NULL, 'MAGSOKON TRIANGULO 26G C/50', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1144, 2, NULL, NULL, 'MALIVAL 25MG C/30 CÁPSULAS (SILANES)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1145, 2, NULL, NULL, 'MALIVAL AP 50MG C/28 CAPSULAS (SILANES)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1146, 2, NULL, NULL, 'Malival Compuesto c/32 Caps Metocarbamol/Indometacina (Silanes)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1147, 2, 87, 123, 'MAMISAN 100GR (PFIZER) P. AMARILLA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1148, 2, 87, 123, 'MAMISAN 200GR (PFIZER) P. AMARILLA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1149, 2, 87, 123, 'MAMISAN 200GR (ZOETIS) ORIGINAL', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1150, 2, NULL, NULL, 'MAMISAN CON DICLOFENACO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1151, 2, NULL, NULL, 'MAMISAN CON DICLOFENACO GEL', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1152, 2, NULL, NULL, 'Mamisan Unguento 100gr (Plantimex)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1153, 2, NULL, NULL, 'Mamisan Unguento 200gr (Plantimex)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:40.754061+00', NULL);
INSERT INTO public.products VALUES (1154, 2, NULL, NULL, 'MANGO AFRICANO C/60 TABS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1155, 2, NULL, NULL, 'MANTECA C/12 KG', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1156, 2, NULL, NULL, 'MANTECA INCA C/12 KG', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1157, 2, 88, 124, 'MANZANILLA 15 GOTAS (SOPHIA-GENERICO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1158, 2, 88, 124, 'MANZANILLA GOTAS 15ML (SOPHIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1159, 2, NULL, NULL, 'MARIGUANOL BALSAMO (CBD)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1160, 2, NULL, NULL, 'MARIGUANOL POMADA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1161, 2, NULL, NULL, 'MASCARILLA ARCILLA BENTONITA 150GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1162, 2, NULL, NULL, 'MASCARILLA ARCILLA ROSA 100GR (GIZEH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1163, 2, NULL, NULL, 'MASCARILLA ARCILLA VERDE 100GR (GIZEH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1164, 2, NULL, NULL, 'Mascarilla de Arcilla 100gr (La Salud es Primero )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1165, 2, 17, 33, 'MAVIDOL 10MG C/10 TABS KETOROLACO (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1166, 2, 17, 33, 'MAVIDOL C/3 AMP KETOROLACO (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1167, 2, 17, 33, 'Mavidol SL 30mg c/4 Tabs Ketorolaco (Mavi)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1168, 2, 17, 33, 'MAVIDOL TR C/10 TABS KETOROLACO / TRAMADOL (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1169, 2, 17, 33, 'MAVIDOL TR C/3 AMP KETOROLACO-TRAMADOL (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1170, 2, 17, 33, 'MAVIDOL TR SUBLINGUAL  C/4 TABS KETOROLACO / TRAMADOL (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1171, 2, NULL, NULL, 'Maxifort 50mg c/4 Sildenafil (Degorts Chemical)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1172, 2, 56, 34, 'Maxifort ZIMAX 100mg c/10 Sildenafil (Degorts Chemical)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1173, 2, NULL, NULL, 'Mazzogran 100mg c/1 Tabs Sildenafil (Collins)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1174, 2, NULL, NULL, 'Mazzogran 100mg c/10 Tabs Sildenafil  3 Pack (Collins)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1175, 2, NULL, NULL, 'Mazzogran 100mg c/10 Tabs Sildenafil (Collins)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1176, 2, 30, NULL, 'Me Vale Madre 500mg c/60 Tabs (Nutri)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1177, 2, NULL, NULL, 'ME VALE MADRE 60ML (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1178, 2, NULL, NULL, 'Me Vale Madre c/60 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1179, 2, NULL, NULL, 'Me Vale Madre Gotas 60ml (Nutri)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1180, 2, NULL, NULL, 'MECLISON 15ML GOTAS MECLIZINA, PIRIDOXINA (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1181, 2, 83, 104, 'MEDICASP SHAMPOO 130ML (GENOMMA LABS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1182, 2, 86, NULL, 'MEDICINA PERCY SUSP 90ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1183, 2, NULL, NULL, 'MEDIGEN 10MG C/10 TABS KETOROLACO (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1184, 2, NULL, NULL, 'MEDIGEN 250MG SUSP CEFALEXINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1185, 2, NULL, NULL, 'MEGA-R 600MG C/30 CAPS (NATURAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1186, 2, NULL, NULL, 'Mejoral 500 c/12 tabs', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1187, 2, NULL, NULL, 'MEJORAL 500 EXHIBIDOR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1188, 2, NULL, NULL, 'MEJORALITO DISPLAY (GSK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1189, 2, NULL, NULL, 'MEJORALITO JUNIOR 120ML DE 6 A 11 AÑOS (GSK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1190, 2, 23, 22, 'MEJORALITO PED GOTAS 30ML (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1191, 2, 23, 125, 'MEJORALITO PEDIATRICO DE 2 A 7 AÑOS C/30 TABS (GSK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1192, 2, 23, 125, 'MEJORALITO PEDIATRICO SOLUCION 120ML DE 2 A 5 AÑOS (GSK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1193, 2, NULL, NULL, 'MELADININA 10MG C/30 TABS (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1194, 2, NULL, NULL, 'MELADININA 30GR POMADA (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1195, 2, NULL, NULL, 'MELIDEN 100MG C/10 TABS NIMESULIDA (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1196, 2, NULL, NULL, 'MELLITRON C/80 TABS (JANSSEN CILAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1197, 2, NULL, NULL, 'Melox Noche AntiReflujo c/10 Sobres (Sanofi-Aventis)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1198, 2, 13, 11, 'MELOX PLUS  MENTA 360ML ALUMINIO, MAGNESIO, DIMETICONA (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1199, 2, 13, 11, 'MELOX PLUS C/30 TABLETAS CEREZA (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1200, 2, 13, 11, 'MELOX PLUS C/50 TABS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1201, 2, 13, 11, 'Melox Plus c/50 Tabs Menta, Cereza, Lima / Limon (Sanofi-Aventis)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1202, 2, 13, 11, 'MELOX PLUS CEREZA 360ML ALUMINIO, MAGNESIO, DIMETICONA (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1203, 2, NULL, NULL, 'MEMOACTIVE  C/90 TABS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1204, 2, NULL, NULL, 'MEMOACTIVE C/90 (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1205, 2, NULL, NULL, 'Memorix 1g c/100 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1206, 2, NULL, NULL, 'MENAZAN CREMA 20 GR MICONAZOL (BIOMEP)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1207, 2, NULL, NULL, 'MENNEN ACEITE 200ML (PALMOLIVE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1208, 2, NULL, NULL, 'MENNEN COLONIA 200ML (PALMOLIVE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1209, 2, NULL, NULL, 'Menopauxil 750mg c/60 Capsulas (Nature''s ´P.e.t. )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1210, 2, NULL, NULL, 'MENOPAZ C/90 CAPS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1211, 2, NULL, NULL, 'MERTODOL BLANCO 40ML (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1212, 2, NULL, NULL, 'MERTODOL TINTURA 40ML (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1213, 2, NULL, NULL, 'MESBRU C/1 AMP Y JERINGA ALGESTONA 150MG + ESTRADIOL 10MG (BRULUART)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1214, 2, NULL, NULL, 'Mesigyna c/1 Amp 1ml Noretisterona-Estradiol (Bayer)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1215, 2, NULL, NULL, 'MESSELDAZOL 500MG C/20 TABS METRONIDAZOL (BIOMEP)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1216, 2, NULL, NULL, 'MESSELDAZOL 500MG C/30 TABS METRONIDAZOL (BIOMEP)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1217, 2, NULL, NULL, 'MESULID C/10 TABLETAS (ROCHE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1218, 2, NULL, NULL, 'METICORTEN 20MG C/30 (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1219, 2, NULL, NULL, 'METICORTEN 50MG C/20 TABS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1220, 2, NULL, NULL, 'METICORTEN 5MG C/30 TABS (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1221, 2, NULL, NULL, 'METOCLOPRAMIDA  C/20  TABS. 10 MG. (AVIVIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1222, 2, NULL, NULL, 'METOCLOPRAMIDA 10MG C/20 TABS (LOEFFLER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1223, 2, NULL, NULL, 'METOPROLOL 100MG /20 TABS (APOTEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1224, 2, NULL, NULL, 'METOPROLOL 100MG C/20 (SERRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1225, 2, NULL, NULL, 'METRIGEN FUERTE INY (ORGANON MEXICANA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1226, 2, NULL, NULL, 'METRONIDAZOL 500MG C/30 TABS (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1227, 2, NULL, NULL, 'MEXAPIN  500MG CAPS C/20', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1228, 2, NULL, NULL, 'MEXAPIN 500MG C/100 CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1229, 2, NULL, NULL, 'MEXSANA TALCO 160G (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1230, 2, NULL, NULL, 'MEXSANA TALCO 80G (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1231, 2, 38, 49, 'MEZELOL 100MG C/100 TABS METOPROLOL (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1232, 2, 38, 49, 'MEZELOL 50MG C/100 TABS METOPROLOL (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1233, 2, NULL, NULL, 'MEZELOL 50MG C/20 TABS (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1234, 2, NULL, NULL, 'MI ARROZ C/10 PIEZAS (KNORR)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1235, 2, NULL, NULL, 'MICARDIS  40MG C/14 TABS TELMISARTAN  (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1236, 2, NULL, NULL, 'MICARDIS  80MG c/14 TABS TELMISARTAN (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1237, 2, NULL, NULL, 'MICARDIS  80MG c/28 TABS TELMISARTAN (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1238, 2, NULL, NULL, 'MICARDIS PLUS 80MG c/14 TABS TELMISARTAN (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1239, 2, NULL, NULL, 'MICCIL 1MG C/20 COMPRIMIDOS (IPAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1240, 2, NULL, NULL, 'MICONAZOL 20G CREMA (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1241, 2, 89, 126, 'MICOSTATIN BABY 30GR UNGUENTO (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1242, 2, 89, 126, 'MICOSTATIN C/30 TABLETAS (BRISTOL/MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1243, 2, 89, 126, 'MICOSTATIN INF GOTAS 10,000,000UI 60ML (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1244, 2, 89, 126, 'MICOSTATIN SUSPENSIÓN 100,000UI/ML (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1245, 2, 89, 126, 'MICOSTATIN V CREMA 60GR (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1246, 2, NULL, NULL, 'MICRODACYN 120ML ANTISEPTICO (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1247, 2, 90, 18, 'MICROGYNON C/21 TABLETAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1248, 2, 90, 18, 'MICROGYNON CD C/28 TABLETAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1249, 2, NULL, NULL, 'MICTASOL C/16 TABS. NORFLOXACINO-FENAZOPIRIDINA  (ASOFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1250, 2, NULL, NULL, 'MIEL DE AMOR LOCION', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1251, 2, NULL, NULL, 'MIEL DE AMOR SPRAY', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1252, 2, NULL, NULL, 'MINOCIN 100MG C/12 TABS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:41.41129+00', NULL);
INSERT INTO public.products VALUES (1253, 2, NULL, NULL, 'MIRIAM DIA CREMA 50G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1254, 2, NULL, NULL, 'MIRIAM NOCHE CREMA 50G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1255, 2, 23, 127, 'ML-PRIM C/12 CAPS METOCARBAMOL, IBUPROFENO (GELPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1256, 2, NULL, NULL, 'MOCO DE GORILA 340GR (NATURAL LABS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1257, 2, NULL, NULL, 'MOCO DE GORILA PUNK 85GR(NATURALABS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1258, 2, NULL, NULL, 'MOMENTS 50MG C/30 TABS CLORNIFENO (IFA CELTICS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1259, 2, NULL, NULL, 'MONTELUKAST 10MG C/20 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1260, 2, NULL, NULL, 'Moringa Complex 500mg c/30 Capsulas (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1261, 2, NULL, NULL, 'MORINGA OLEIFERA C/90 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1262, 2, NULL, NULL, 'MOTRIN 800MG C/45 GRAGEAS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1263, 2, NULL, NULL, 'MOTRIN INF 120ML FRUTAS (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1264, 2, NULL, NULL, 'MOTRIN PEDIATRICO 15ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1266, 2, 19, 38, 'MUCOANGIN GROSELLA  20MG C/18 PASTILLAS AMBROXOL (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1267, 2, 19, 38, 'MUCOANGIN LIMON 20MG C/18 PASTILLAS AMBROXOL (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1268, 2, 19, 38, 'MUCOANGIN MENTA 20MG C/18 PASTILLAS AMBROXOL (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1269, 2, 19, 41, 'MUCOFLUX 120ML  SALBUTAMOL/AMBROXOL (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1270, 2, 19, 38, 'MUCOSOLVAN C/10 AMP (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1271, 2, 19, 38, 'MUCOSOLVAN C/20 PASTILLAS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1272, 2, 19, 38, 'MUCOSOLVAN COMPUESTO 120ML (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1273, 2, 19, 41, 'MUCOVIBROL C 120ML (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1274, 2, 19, 41, 'MUCOVIBROL C GOTAS 20ML (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1275, 2, 19, 41, 'MUCOVIBROL C/20 COMPRIMIDOS (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1276, 2, NULL, NULL, 'MUEGANOS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1277, 2, NULL, NULL, 'MUICOSOLVAN RETARD 24HRS C/10 TABLETAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1278, 2, NULL, NULL, 'MUITO CXO LADY 400ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1279, 2, NULL, NULL, 'MUITO CXO MEN 400ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1280, 2, NULL, NULL, 'MULTIVITAMINAS EFERVECENTES INFANTIL (SELTZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1281, 2, NULL, NULL, 'MULTIVITAMINICO MULTIMINERAL C/30 CAPS (PHARMA LIFE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1282, 2, NULL, NULL, 'MUSTELA CREMA CONTRA LAS ROSADURAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1283, 2, NULL, NULL, 'MYFUNGAR 20GR CREMA (ITALMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1284, 2, NULL, NULL, 'MYRYAM CREMA 15G (PLANTIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1285, 2, 37, NULL, 'NAILEX 15ML DESENTERRADOR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1286, 2, 37, NULL, 'NAILEX 15ML UNA AMARILLA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1287, 2, NULL, NULL, 'NALIXONE 500MG C/20 TABS ACIDO NALIDIXICO/FENAZOPIRIDINA (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1288, 2, NULL, NULL, 'NARTEX ALCOHOLISMO C/9 PASTILLAS (NARTEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1289, 2, NULL, NULL, 'NASALUB ADULTO SOLUCION 30ML (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1290, 2, NULL, NULL, 'NASALUB INFANTIL SOLUCION 30ML (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1291, 2, NULL, NULL, 'Nasalub Max 100ml (Genomalab)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1292, 2, NULL, NULL, 'NATRAZIM 40MG C/28 TABS TELMISARTAN (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1293, 2, NULL, NULL, 'NAXEN 250MG C/45 TABS (SYNTEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1294, 2, NULL, NULL, 'NAZIL 15ML (SOPHIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1295, 2, NULL, NULL, 'NEBIDO 1000MG INY TETOSTERONA (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1296, 2, NULL, NULL, 'NEBIVOLOL 5MG C/14TABS (CAMBER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1297, 2, NULL, NULL, 'NEMORIL 40MG C/30 CAPS GINKO BILOBA (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1298, 2, 91, 116, 'NENEDENT 10G GEL (NYCOMED)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1299, 2, NULL, NULL, 'Neo Omega 3 Salmon + Q c/100 Caps (Anahuac)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1300, 2, NULL, NULL, 'Neo Omega 3 Salmon c/100 Caps (Anahuac)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1301, 2, 72, 18, 'NEOGYNON C/21 TABS LEVONORGESTREL/ETINILESTRADIOL (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1302, 2, NULL, NULL, 'NEOMELUBRINA 500MG GOTAS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1303, 2, 23, 11, 'NEO-MELUBRINA C/5 AMP (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1304, 2, 23, 11, 'NEO-MELUBRINA C/5 SUPOSITORIOS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1305, 2, 23, 11, 'NEO-MELUBRINA JBE INF 100ML (SANOFI AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1306, 2, 23, 11, 'NEO-MELUBRINA TABS 500MG C/10 TAB METAMIZOL SODICO (SANOFI AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1307, 2, NULL, NULL, 'NERVICALM C/90 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1308, 2, 72, 58, 'NESAJAR C/16 CAPS  PINAVERIO / DIMETICONA  (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1309, 2, NULL, NULL, 'NEURALIN SOL INY (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1310, 2, 23, 106, 'NEUROBION C/30 TABS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1311, 2, NULL, NULL, 'NEUROBION C/60 TABS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1312, 2, 23, 106, 'NEUROBION DC 10MG C/3 AMP (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1313, 2, 23, 106, 'NEUROBION DC 10MG C/5 AMP (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1314, 2, 23, 11, 'Neuroflax 20mg/4mg Iny c/1 Frasco (Sanofi)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1315, 2, 23, 11, 'Neuroflax 20mg/4mg Iny c/3 Frascos (Sanofi)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1316, 2, 23, 39, 'Neurontin 300mg c/30 Caps Gabapentina (Pfizer)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1317, 2, 12, 128, 'NEUROTROPAS-DB C/10. VIALES 15ML MULTIVITAMINICO (LAB DB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1318, 2, NULL, NULL, 'NIKSON C/40 TABS (GENOMMA LAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1319, 2, 76, 129, 'NIKSON C/90 TABS (GENOMMA LAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1320, 2, NULL, NULL, 'NIMESULIDA 100MG C/10 TABLETAS (PHARMA RX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1321, 2, NULL, NULL, 'NIMOTOP INYECTABLE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1322, 2, 75, 102, 'NISTATINA 24ML 2,400,000 U (PERRIGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1323, 2, NULL, NULL, 'NIVEA CREMA 100ML (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1324, 2, NULL, NULL, 'NIVEA CREMA 200ML (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1325, 2, NULL, NULL, 'NIVEA CREMA 400ML + 100ML (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1326, 2, NULL, NULL, 'NIVEA CREMA 50ML (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1327, 2, NULL, NULL, 'NIVEA CREMA 50ML TARRO (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1328, 2, NULL, NULL, 'NIVEA CREMA DISPENSER C/24 LATITAS 20G (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1329, 2, NULL, NULL, 'NIVEA DESODORANTE ACLARADO CLASSIC TOUCH SPRAY (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1330, 2, NULL, NULL, 'NIVEA DESODORANTE ACLARADO NATURAL BEAUTY TOUCH SPRAY (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1331, 2, NULL, NULL, 'NIVEA DESODORANTE ROLL-ON (BEIERSDORF)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1332, 2, 75, 130, 'NIZORAL 200MG C/10 TABS (JANSSEN-CILAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1333, 2, 75, 130, 'NIZORAL 200MG C/20 TABS (JANSSEN-CILAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1334, 2, 75, 108, 'NIZORAL CREMA 40GR (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1335, 2, NULL, NULL, 'NO + KOLICOS C/90 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1336, 2, NULL, NULL, 'NOGASLAN 40MG C/28 TABS PANTOPRAZOL (LANDSTEINER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1337, 2, NULL, NULL, 'NOGRAINE 100MG C/5 TABS (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1338, 2, NULL, NULL, 'NOGRAINE 50MG C/8 TABS SUMATRIPTAN (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1339, 2, NULL, NULL, 'NOPAL 7 DE POTENCIAS C/150 CAPS (PLANTIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1340, 2, NULL, NULL, 'Nopal Sabila 450mg c/150 Capsulas (La Salud es Primero )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1341, 2, NULL, NULL, 'NOPIKEX REPELENTE SPRAY', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1342, 2, NULL, NULL, 'NO-PIO-JIN 125ml Shampoo', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1343, 2, NULL, NULL, 'NO-PIO-JIN GEL REPELENTE DE PIOJOS 500GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1344, 2, NULL, NULL, 'NO-PIO-JIN SHAMPOO 125ML CON PEINE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1345, 2, NULL, NULL, 'NORAPRED 50MG C/20 TABS PREDNISONA (BRULUART)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1346, 2, 20, 39, 'NORDET C/21 TABLETAS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1347, 2, 23, 61, 'NORDINET ADULTO C/20 TABS (NORDIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1348, 2, NULL, NULL, 'NOREX 50MG C/30 TABS ANFEPRAMONA (IFA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1349, 2, NULL, NULL, 'NORISTERAT 200MG C/1 AMP NORETISTERONA (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1350, 2, NULL, NULL, 'NOSIPREN 20MG c/100 TABS PREDNISONA (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1351, 2, 15, 12, 'NOSIPREN 20MG c/30 TABS PREDNISONA (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.250056+00', NULL);
INSERT INTO public.products VALUES (1352, 2, NULL, NULL, 'Nucleo C.M.P. Forte 5mg /3mg c/30 Caps (Ferrer)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1353, 2, NULL, NULL, 'NURO-B C/10 TABLETAS (RIMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1354, 2, NULL, NULL, 'NUTRIDERM CREMA TEPEZCOUITE 60GR (NUTRIDERM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1355, 2, 75, 27, 'NYSMOSONS-V C/10 OVULOS METRODINAZOL, NISTATINA, FLUOCINOLONA (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1356, 2, NULL, NULL, 'OBAO ANGEL 24HR (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1357, 2, NULL, NULL, 'OBAO AZUL MORADO OCEANIC 48HRS 65G HOMBRE (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1358, 2, NULL, NULL, 'OBAO BAMBOO 150ML SPRAY (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1359, 2, NULL, NULL, 'OBAO FRESCURA FLORAL 65G (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1360, 2, NULL, NULL, 'OBAO FRESCURA POWDER 65G (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1361, 2, NULL, NULL, 'OBAO FRESCURA SUAVE 65GR (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1362, 2, NULL, NULL, 'OBAO FRESQUISIMA 65G (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1363, 2, NULL, NULL, 'OBAO FRESQUISSIMA 150ML SPRAY (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1364, 2, NULL, NULL, 'OBAO MAN NEGRO 65GR (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1365, 2, NULL, NULL, 'OBAO MEN CLASSIC 24H (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1366, 2, NULL, NULL, 'OBAO NARANJA FRESCURA INTENSA 65G (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1367, 2, NULL, NULL, 'OBAO PIEL DELICADA 150ML SPRAY (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1368, 2, NULL, NULL, 'OBAO PIEL DELICADA 65GR (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1369, 2, NULL, NULL, 'OBAO POWDER 65GR (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1370, 2, NULL, NULL, 'OBAO SEDA 65GR (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1371, 2, NULL, NULL, 'OBAO SENSITIVE AZUL CIELO (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1372, 2, NULL, NULL, 'OBAO SENSITIVE SEDA 65G (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1373, 2, NULL, NULL, 'OBAO SUAVE 65GR (GARNIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1374, 2, NULL, NULL, 'OBECLOX  30MG C/60 CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1375, 2, NULL, NULL, 'O-Dolex 150g Talco (Avant)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1376, 2, NULL, NULL, 'O-DOLEX 300 GR Talco (Avant)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1377, 2, NULL, NULL, 'OJO ROJO 5ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1378, 2, NULL, NULL, 'Omega 3 c/90 Tabs (Sandy)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1379, 2, NULL, NULL, 'OMEOPRAZOL 20MG C/60 CAPS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1380, 2, NULL, NULL, 'OMIFIN 50MG C/30 TABS (AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1381, 2, NULL, NULL, 'ONCOLIVE C/90 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1382, 2, NULL, NULL, 'ONCOLIVE C/90 TABS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1383, 2, NULL, NULL, 'ONOTON C/20 TABS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1384, 2, NULL, NULL, 'ONOTON C/50 TABS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1385, 2, NULL, NULL, 'OPTICAL DEVLYN EQ GOTAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1386, 2, NULL, NULL, 'ORDEGAN C/10 TABS KETOROLACO/ TRAMADOL (RAAM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1387, 2, NULL, NULL, 'OREGANO C/60 CAPSULAS (ANAHUAC)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1388, 2, NULL, NULL, 'ORTIGA + AJO REY AZUL C/60 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1389, 2, NULL, NULL, 'ORTIGA + AJO REY VERDE C/60 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1390, 2, NULL, NULL, 'ORTIGA C/30 TABS (BOTANICA SANTIAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1391, 2, 20, 27, 'ORTORA SOL GOTAS 20ML NEOMICINA, LIDOCAINA (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1392, 2, NULL, NULL, 'OSAKO 15ML SPRAY PROPOLEO Y EUCALIPTO (OSAKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1393, 2, NULL, NULL, 'OSIDEA GL C/1 SOBRES 100MG SILDENAFIL GEL ORAL (AVIVIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1394, 2, NULL, NULL, 'OSIDEA GL C/4 SOBRES 100MG SILDENAFIL GEL ORAL (AVIVIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1395, 2, 20, 12, 'OTILIN SOL GOTAS 20ML NEOMICINA, LIDOCAINA (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1396, 2, NULL, NULL, 'OTO ENI 10ML CIPROFLOXACINO, HIDROCORTISONA Y LIDOCAINA (GROOSMAN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1397, 2, 20, 131, 'OTOLONE 5ML GOTAS SOL (LOREN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1398, 2, NULL, NULL, 'OXITAL-C FORTE C/10 TABS EFERVECENTES  SABOR NARANJA (SERRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1399, 2, NULL, NULL, 'OXYGRICOL C/12 TABS (RIMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1400, 2, NULL, NULL, 'PALADAC''S 150ML SUSP (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1401, 2, NULL, NULL, 'PALMOLIVE BRILLANTINA 199ML (PALMOLIVE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1402, 2, NULL, NULL, 'PALMOLIVE BRILLANTINA 99ML (PALMOLIVE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1403, 2, NULL, NULL, 'PALSIN STRESS 500MG C/24 CAPS (MEDICAMENTOS NATURALES)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1404, 2, NULL, NULL, 'PANCLASA C/20 CÁPSULAS  floroglucinol trimetilfloroglucinol  (ATLANTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1405, 2, NULL, NULL, 'PANCLASA C/5 AMP 2ML INY (ATLANTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1406, 2, NULL, NULL, 'PANCLASA GOTAS CÓLICO INF 30ML (ATLANTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1407, 2, NULL, NULL, 'PANGAVIT PEDIATRICO 120ML (CHURCH AND DWIGHT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1408, 2, NULL, NULL, 'PANGAVIT TAB (CHURCH AND DWIGHT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1409, 2, 19, 44, 'PANOTO-S 100ML  HEDERA HELIX (SIEGFRIED-RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1481, 2, NULL, NULL, 'POMADA AZUFRE 100G (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1410, 2, NULL, NULL, 'PANTOPRAZOL 20MG C/7 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1411, 2, NULL, NULL, 'Pantoprazol c/30 Caps', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1412, 2, NULL, NULL, 'Pantozol 40mg c/7 Tabs Pantoprazol (Nycomed)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1413, 2, NULL, NULL, 'PARAMIX 500MG C/6 GRAGEAS NITAZOXANIDA (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1414, 2, 92, 50, 'PAROXETINA 20MG  C/20 TABS (PSICOFARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1415, 2, NULL, NULL, 'PAROXETINA 20MG C/10 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1416, 2, NULL, NULL, 'PAROXETINA 20MG C/10 TABS (AVIVIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1417, 2, NULL, NULL, 'PAROXETINA 20MG C/10 TABS (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1418, 2, NULL, NULL, 'PAROXETINA 20MG c/10 TABS. (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1419, 2, NULL, NULL, 'PASMODIL C/1 AMP Butilhioscina ó Hioscina+Paracetamo (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1420, 2, NULL, NULL, 'PASMODIL DUO C/24 TABS Butilhioscina ó Hioscina+Paracetamo (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1421, 2, NULL, NULL, 'PASTA COLGATE 50ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1422, 2, 93, 101, 'PASTA DE LASSAR OXIDO DE ZINC 145GR (COYOACAN QUIMICA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1423, 2, 93, 101, 'PASTA LASSAR 110 GR (COYOACAN QUIMICA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1424, 2, 93, 101, 'Pasta Lassar 50g Oxido de Zinc (Coyoacan Quimica)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1425, 2, 72, 66, 'PATECTOR ROSA C/1 AMP (CARNOT LABORATORIOS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1426, 2, NULL, NULL, 'PEBANIC 200MG C/100 TABS CARBAMAZEPINA (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1427, 2, NULL, NULL, 'PEDIALYTE 500ML CEREZA C/12 (ABBOTT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1428, 2, NULL, NULL, 'PEDIALYTE 500ML COCO C/12 (ABBOTT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1429, 2, NULL, NULL, 'PEDIALYTE 500ML DURAZNO C/12 (ABBOTT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1430, 2, NULL, NULL, 'PEDIALYTE 500ML MANZANA C/12 (ABBOTT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1431, 2, NULL, NULL, 'Peine Saca Piojos de Acero (Gadiz)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1432, 2, NULL, NULL, 'PEINES PARA PIOJOS GRANDE C/12 (PREMIER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1433, 2, NULL, NULL, 'PENSIRAL 400MG C/30 CAPS (SERRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1434, 2, NULL, NULL, 'PENTOXIFILINA 400MG C/30 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1435, 2, NULL, NULL, 'PENTREXCILINA 72PZ C/2TABS (BIOQUIMICA MEED)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1436, 2, NULL, NULL, 'PENTREXCILINA 9.4GR (RRX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1437, 2, NULL, NULL, 'PENTREXCILINA NF INF CEREZA 237ML (BIOQUIMICA MEED', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1438, 2, NULL, NULL, 'PENTREXYL 100MG GOTAS (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1439, 2, NULL, NULL, 'PENTREXYL 125MG SUSP (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1440, 2, NULL, NULL, 'PENTREXYL 250MG C/3 AMP  (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1441, 2, NULL, NULL, 'PENTREXYL 250MG/5ML SUSP (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1442, 2, NULL, NULL, 'PENTREXYLIN 500 C/30 CAPS (BIOQUIMICA MEED)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1443, 2, NULL, NULL, 'PEPTIMAX C/12 TABLETAS (COLUMBIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1444, 2, 94, 132, 'PEPTO-BISMOL 118ML SUSP (PROCTER & GAMBLE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1445, 2, 94, 132, 'PEPTO-BISMOL C/100 TABS (PROCTER & GAMBLE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1446, 2, 94, 132, 'PEPTO-BISMOL SUSP 236ML (PROCTER & GAMBLE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1447, 2, 94, 132, 'PEPTO-BISMOL TIRA C/24 TABS (PROCTER & GAMBLE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1448, 2, NULL, NULL, 'PERIOSAN 100MG C/10 CAPS DOXICICILINA (VITAE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1449, 2, 94, 133, 'PERLAS DE ETER C/3 C/50 BOLSITAS  (sanax)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1450, 2, 94, 134, 'PERLAS DE ETER C/50 (LA FLOR)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1451, 2, NULL, NULL, 'Perlas de Higado de Tiburon c/90 Tabletas (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:42.979666+00', NULL);
INSERT INTO public.products VALUES (1452, 2, 72, 12, 'PERLUDIL C/1 AMP ALGESTONA/ ESTRADIUOL (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1453, 2, 72, 38, 'PERLUTAL C/1 AMP (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1454, 2, NULL, NULL, 'PHARBEN 100MG C/20 CAPS BENZONATATO (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1455, 2, 91, 135, 'PHARMACAINE SPRAY 115ML LIDOCAINA (QUIMPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1456, 2, 12, 38, 'PHARMATON C/100 CAPS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1457, 2, 12, 38, 'PHARMATON C/30 CAPS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1458, 2, NULL, NULL, 'PHARMATON COMPLEX C/100 CAPS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1459, 2, NULL, NULL, 'PHARMATON MATRUELLE C/60 CAPS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1460, 2, NULL, NULL, 'PHARSENG C/30 CAPS PANAX GISENG (PHARMA GEL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1461, 2, NULL, NULL, 'PICOSEND 11ML SOL (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1462, 2, NULL, NULL, 'Piel Sana Jabon', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1463, 2, NULL, NULL, 'PINTURA DE ROPA COLOR AZUL', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1464, 2, NULL, NULL, 'PINTURA DE ROPA COLOR NEGRO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1465, 2, NULL, NULL, 'PIREMOL 300MG C/3 SUP (LOEFFLER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1466, 2, NULL, NULL, 'PIRIMIR 100MG C/24 TABS (MEDLEY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1467, 2, 17, 29, 'Piroxicam 20mg c/20 Tabs (Ultra)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1468, 2, 91, 62, 'PISACAINA 115ML ATOMIZADOR LIDOCAINA (PISA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1469, 2, 91, 62, 'PISACAINA 2% FRASCO 20MG/50ML LIDOCAINA (PISA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1470, 2, NULL, NULL, 'PLANEX C/30 CAPS (RIMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1471, 2, NULL, NULL, 'PLANTILLAS HONGOSAN', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1472, 2, NULL, NULL, 'PLAQUENIL 200MG HIDROXICLOROQUINA (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1473, 2, NULL, NULL, 'PLASIL ENZIMATICO C/30 GRAGEAS (MEDLEY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1474, 2, 95, 97, 'PODOFILIA #2 BUSTILLOS 5ML (BUSTILLOS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1475, 2, NULL, NULL, 'POINTTS VERRUGAS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1476, 2, NULL, NULL, 'POLI-VI-SOL PEDIATRICO (SIEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1477, 2, NULL, NULL, 'Polvos de Juanes 7g c/50 Sobres (Crystal)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1478, 2, NULL, NULL, 'POMADA 7 FLORES 120GR (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1479, 2, NULL, NULL, 'POMADA AJO 125GR  (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1480, 2, NULL, NULL, 'POMADA ALCANFOR 100G (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1482, 2, NULL, NULL, 'POMADA BELLADONA 100GR (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1483, 2, NULL, NULL, 'POMADA BLANCAVIT 120GR (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1484, 2, NULL, NULL, 'POMADA CALENDULA CON TEPEZCOUITE 120GR (ECO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1485, 2, NULL, NULL, 'POMADA CAMPANA TEPEZCOHUITE 35G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1486, 2, NULL, NULL, 'POMADA CEBO DE COYOTE 100G (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1487, 2, NULL, NULL, 'POMADA DE AZUFRE 125GR (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1488, 2, NULL, NULL, 'Pomada de la Abuela 125gr', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1489, 2, NULL, NULL, 'POMADA DE MAMEY 125GR (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1490, 2, NULL, NULL, 'POMADA DE MANZANA (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1491, 2, NULL, NULL, 'POMADA DE OXIDO DE ZINC 50GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1492, 2, NULL, NULL, 'POMADA DE PEYOTE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1493, 2, NULL, NULL, 'POMADA DE SAVILA 50GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1494, 2, NULL, NULL, 'POMADA DE VENENO DE ABEJA 100GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1495, 2, NULL, NULL, 'POMADA DEL TIGRE 100G (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1496, 2, NULL, NULL, 'POMADA DISPAN DOBLE 40MG', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1497, 2, NULL, NULL, 'POMADA DRAGON 19G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1498, 2, NULL, NULL, 'POMADA LA CAMPANA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1499, 2, NULL, NULL, 'POMADA MILAGROSA 100G (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1500, 2, NULL, NULL, 'POMADA NATURAL NUTRISAN', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1501, 2, NULL, NULL, 'POMADA PAN PUERCO 50GR (GISEL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1502, 2, NULL, NULL, 'POMADA QUERATOLITICA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1503, 2, NULL, NULL, 'POMADA TEPEZCOHUITE 100G (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1504, 2, NULL, NULL, 'POMADA TEPEZCOUITE 125GR (ARBOL VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1505, 2, NULL, NULL, 'POMADA VENENO ABEJA C/ VIBORA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1506, 2, NULL, NULL, 'POMADA ZORRILLO 100G (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1507, 2, NULL, NULL, 'POMDA DE AJOLOTE CON ACEITE DE SABILA 125GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1508, 2, NULL, NULL, 'POND''S CLARANT B3 100G PIEL NORMAL A SECA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1509, 2, NULL, NULL, 'POND''S CLARANT B3 200G PIEL NORMAL A SECA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1510, 2, NULL, NULL, 'POND''S CLARANT B3 400G PIEL NORMAL A SECA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1511, 2, NULL, NULL, 'POPRAM 40MG /14 TABS PANTOPRAZOL (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1512, 2, NULL, NULL, 'POROXALIN', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1513, 2, NULL, NULL, 'POSIPEN 500MG C/12 CAPS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1514, 2, 72, 136, 'POSTDAY C/2 COMPRIMIDOS 0.75G (INV FARMACÉUTICAS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1515, 2, NULL, NULL, 'POSTINOR UNIDOSIS C/1 TAB (GEDEON RICHTER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1516, 2, NULL, NULL, 'PRAMIGEL C/10 TABS (CARNOT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1517, 2, NULL, NULL, 'PRAMIGEL C/20 TABS (CARNOT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1518, 2, 96, 31, 'PRASIVER 10MG C/15 TABS PRAVASTATINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1519, 2, NULL, NULL, 'PRAVASTATINA 10MG C/15 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1520, 2, NULL, NULL, 'PREBIOS PRUEBA DE EMBARAZO C/10', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1521, 2, NULL, NULL, 'PREMARIN C/28 TABLETAS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1522, 2, NULL, NULL, 'PREMARIN C/42 TABLETAS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1523, 2, NULL, NULL, 'PREPARATION H UNGUENTO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1524, 2, NULL, NULL, 'PRESISTIN 10MG C/30 TABS CISAPRIDA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1525, 2, NULL, NULL, 'PRIMAZEN 10MG C/100 TABS ENALAPRIL (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1526, 2, 38, 49, 'PRIMAZEN 20MG C/100 TABS ENALAPRIL (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1527, 2, NULL, NULL, 'PRIMAZEN 5MG C/100 TABS ENALAPRIL (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1528, 2, 97, 18, 'PRIMOTESTON DEPOT 250MG C/1 AMP TESTOSTERONA (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1529, 2, NULL, NULL, 'PRINDEX NEO PEDIATRICO 15ML (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1530, 2, NULL, NULL, 'PROCTOACID 100MG C/5 SUPOSITORIOS (NYCOMED)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1531, 2, NULL, NULL, 'PROCTOACID 50GR (TAKEDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1532, 2, NULL, NULL, 'PROCTO-GLYVENOL 30GR (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1533, 2, NULL, NULL, 'PROCTO-GLYVENOL C/5 SUPOSITORIOS 400MG-40MG (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1534, 2, NULL, NULL, 'PRODOLINA 500MG C/10 TABLETAS (PROMECO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1535, 2, NULL, NULL, 'PRODOLINA C/3 AMP (PROMECO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1536, 2, 12, 137, 'PROGYL 30 VITAMINA A,C Y D MIEL, PROPOLEEO Y GORDOLOBO (PNS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1537, 2, NULL, NULL, 'PROGYLUTON  C/21 GRAGEAS ESTRADIOL-NOGESTREL (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1538, 2, NULL, NULL, 'PRONTOL 100MG C/20 TABS METOPROLOL  (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1539, 2, NULL, NULL, 'PROPANOLOL 80MG C/100 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1540, 2, NULL, NULL, 'PROSGUTT C/40 CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1541, 2, NULL, NULL, 'PROSTABEN C/90 TABS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1542, 2, NULL, NULL, 'PROVERA 10MG C/10 MEDROXIPROGESTERONA  (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1543, 2, NULL, NULL, 'PROVERA MEDROXIPROGESTERONA  5MG c/24 TAB (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1544, 2, NULL, NULL, 'PROVIRON 250MG C/10 TABS (bayer)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1545, 2, NULL, NULL, 'PTX 500 C/30 CAPS(NORDIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1546, 2, NULL, NULL, 'Pulmo Calcio 180ml (L. Lopez)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1547, 2, 33, 138, 'PULMO CALCIO ANTIGRIPAL EXHIBIDOR C/100 TABS (L. LOPEZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1548, 2, 33, 138, 'PULMO CALCIO FRESA EXHIBIDOR C/200 CARAMELOS (L. LOPEZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1549, 2, NULL, NULL, 'PULMOGRIP 120ML JARABE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1550, 2, NULL, NULL, 'PULMONAROM 3ML C/20 AMP (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1551, 2, NULL, NULL, 'PULMONARUM C/10 AMP LISADOS BACTERIANOS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:43.716223+00', NULL);
INSERT INTO public.products VALUES (1552, 2, NULL, NULL, 'QG5 C/10 TABLETAS (GENOMMA LAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1553, 2, 98, 129, 'QG5 C/30 TABLETAS (GENOMMA LAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1554, 2, 72, 18, 'QLAIRA C/28 TABLETAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1555, 2, NULL, NULL, 'QUADRIDERM NF 15GR (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1556, 2, NULL, NULL, 'QUIMARA 3G CREMA 5% (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1557, 2, NULL, NULL, 'Quita Dolor Gel 200ml  (C.B. Marylu)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1558, 2, 30, 35, 'RABANO YODADO 340MML (PROSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1559, 2, NULL, 139, 'RANISEN 150MG 1+1 C/20 TABS (SENOSIAIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1560, 2, NULL, NULL, 'RANISEN 150MG C/60 TABS TABS (SENOSIAIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1561, 2, NULL, NULL, 'RANISEN 300MG 1+1 C/10 TABS (SENOSIAIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1562, 2, NULL, NULL, 'RANITIDINA 150MG C/100 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1563, 2, 13, 13, 'RANITIDINA 300MG C/10 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1564, 2, NULL, NULL, 'RANITIDINA 50MG/2ML INYECATBLE (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1565, 2, NULL, NULL, 'RANTUDIL 60MG C/14 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1566, 2, NULL, NULL, 'Recoveron-C 40 (Armstrong)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1567, 2, NULL, NULL, 'RECOVERÓN-N 40GR (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1568, 2, NULL, NULL, 'RECTANYL 0.05% 30GR CREMA (GALDERMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1569, 2, NULL, NULL, 'REDAFLAM 100MG C/10 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1570, 2, NULL, NULL, 'Redalip 200mg c/30 Tabs Bezafibrato (Maver)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1571, 2, 19, 62, 'REDDY 120ML ADULTO AMBROXOL/DEXTROMETORFANO (PISA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1572, 2, 11, 140, 'REDOTEX C/30 TABS (DIALICELS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1573, 2, NULL, NULL, 'REDOXON 1G SOL INY 10ML (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1574, 2, NULL, NULL, 'REDOXON 1GR  NARANJA C/10 TABS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1575, 2, NULL, NULL, 'REGENESIS MAX OMEGA 3 C/30 TABS (DHA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1576, 2, 42, 8, 'RELIVIUM 100MG c/60 + 60 TABS TRAMADOL (SBL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1577, 2, NULL, NULL, 'RENALIP C/90  TABS 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1578, 2, NULL, NULL, 'REPELENTE DE INSECTOS 60ML (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1579, 2, NULL, NULL, 'RESFRIOLI-TO BB RUB 50GR (RRX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1580, 2, NULL, NULL, 'RESFRIOL-ITO CHILDRENS 118ML (RRX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1581, 2, 20, 139, 'RESPICIL ADULTO INY (SENOSIAIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1582, 2, NULL, NULL, 'RETARDIN LOCION 15ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1583, 2, NULL, NULL, 'RETIN-A 0.05% 40G (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1584, 2, NULL, NULL, 'RETOFLAM  15MG C/10 TABS MELOXICAM  (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1585, 2, NULL, NULL, 'Reumadol Balsamo 125g', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1586, 2, NULL, NULL, 'REUMATOLUM 60 GRS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1587, 2, NULL, NULL, 'Reumofan Plus Verde C/30 Tabs (Riger Naturals)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1588, 2, NULL, NULL, 'REUMOPHAN C/20 TABS (GRISI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1589, 2, NULL, NULL, 'REVITRON PLEX C/30 CAPS GINKO BILOBA, PANAX GINSENG (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1590, 2, NULL, NULL, 'REXONA DESODORANTE SPRAY', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1591, 2, NULL, NULL, 'R-Flex c/30 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1592, 2, NULL, NULL, 'R-GAST 500MG C/30 TABS (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1593, 2, NULL, NULL, 'RICITOS DE ORO SHAMPOO 100ML (GRIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1594, 2, NULL, NULL, 'Rimel Aguacate Organico (Hollywood)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1595, 2, NULL, NULL, 'Rimel Alargador (Hollywood)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1596, 2, NULL, NULL, 'RIMEL ALARGADOR 13GR TAPA AZUL (BQ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1597, 2, NULL, NULL, 'Rimel Argan Oro Liquido (Hollywood)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1598, 2, NULL, NULL, 'RIMEL BLACK NIGHT 13GR (BQ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1599, 2, NULL, NULL, 'Rimel Definidas (Hollywood)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1600, 2, NULL, NULL, 'RIMEL ENGROSADOR 13GR (BQ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1601, 2, NULL, NULL, 'RIMEL EXTENCION 13GR (BQ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1602, 2, NULL, NULL, 'Rimel Extra Largas (Hollywood)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1603, 2, NULL, NULL, 'Rimel Extra Volumen (Hollywood)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1604, 2, NULL, NULL, 'RIMEL HENNA 13GR (BQ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1605, 2, NULL, NULL, 'RIMEL MAKE UP PINK 13GR (BQ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1606, 2, NULL, NULL, 'Rimel Mamey Organico (Hollywood)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1607, 2, NULL, NULL, 'RIMEL TE VERDE 13GR (BQ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1608, 2, NULL, NULL, 'Rimel Volumen Alargador (Hollywood)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1609, 2, NULL, NULL, 'Riñobien 1g c/90 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1610, 2, 13, 116, 'RIOPAN 10ML C/10 SOBRES  (NYCOMED)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1611, 2, 13, 116, 'RIOPAN ANTIACIDO C/24 TABS (NYCOMED)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1612, 2, 13, 117, 'RIOPAN GEL ANTIACIDO 250ML (TAKEDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1613, 2, 75, 25, 'RIXTAL 100MG C/15 TABS ITRACONAZOL (NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1614, 2, NULL, NULL, 'RM FLEX 850MG C/30 CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1615, 2, 23, 39, 'ROBAX GOLD C/24 TABS 500MG/200MG METOCARBAMOL/ IBUPROFENO (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1616, 2, NULL, NULL, 'ROCAINOL BALSAMO 45G (CIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1617, 2, NULL, NULL, 'ROCAVIT C/30 CAPS MULTI VITAMINAS (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1618, 2, NULL, NULL, 'Rosa Mosqueta Crema 120g', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1619, 2, NULL, NULL, 'ROTUMAL 25MG C/30 CAPS DICLOFENACO (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1620, 2, NULL, NULL, 'R-Press c/Chia 500mg c/30 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1621, 2, NULL, NULL, 'RUMOQUIN N.F C/90 TABS (MARCEL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1622, 2, NULL, NULL, 'RUMOQUIN NF C/10 TABS (SCHOEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1623, 2, NULL, NULL, 'RUMOQUIN NF C/20 TABS (SCHOEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1624, 2, NULL, NULL, 'RUVOLSY 12MG C/30 CAPS CASSIA ANGUSTIFOLIA (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1625, 2, NULL, NULL, 'Sabila 400mg c/150 (La Salud es Primero)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1626, 2, NULL, NULL, 'SabiNopal 500mg c/150 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1627, 2, NULL, NULL, 'SADOCIN 120ML JARABE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1628, 2, NULL, NULL, 'Sahumerio Azteca (Productos Trebol)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1629, 2, 38, 141, 'SAL DE UVAS PICOT C/10 SOBRES (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1630, 2, NULL, NULL, 'SAL DE UVAS PICOT C/12 SOBRES (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1631, 2, NULL, NULL, 'SAL DE UVAS PICOT C/50 SOBRES (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1632, 2, NULL, NULL, 'SALBUTAMOL AEROSOL C/1 5 MG  (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1633, 2, NULL, NULL, 'SALBUTAMOL AEROSOL C/200 DOSIS  (BRESALTEC)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1634, 2, 55, 49, 'SALBUTAMOL AEROSOL C/200 DOSIS (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1635, 2, NULL, NULL, 'SALOFALK 500MG C/4', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1636, 2, NULL, NULL, 'SALSA LA PERRONA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1637, 2, NULL, NULL, 'SALUFILA SOL 500ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1638, 2, NULL, NULL, 'SANBORNS COLONIA 115ML (GENNOMA LAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1639, 2, NULL, NULL, 'SANGRE DE VENADO PREPARADA  (ESOTERICO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1640, 2, NULL, NULL, 'Sanzadoll duo 37.5/325 mg c/20 Tabs', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1641, 2, NULL, NULL, 'SARIDON 500MG C/100 COMPRIMIDOS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1642, 2, 23, 18, 'SARIDON 500MG C/20 COMPRIMIDOS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1643, 2, NULL, NULL, 'SAVILE CREMA ACEITE DE ARGAN RIZO 300ML C/2', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1644, 2, NULL, NULL, 'SAVILE CREMA CHILE RIZO 300ML C/2', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1645, 2, NULL, NULL, 'SAVILE SHAMPOO ACEITE DE ARGAN 750ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1646, 2, NULL, NULL, 'SAVILE SHAMPOO AGUACATE 750ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1647, 2, NULL, NULL, 'SAVILE SHAMPOO KERATINA 750ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1648, 2, NULL, NULL, 'SAVILE SHAMPOO SABILA/MIEL 750ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1649, 2, NULL, NULL, 'SBELTA C/90 TABS 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1650, 2, NULL, NULL, 'SbeltNat 850mg c/90 Capsulas (Nature''s ´P.e.t. )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1651, 2, 99, 15, 'SCABISAN 60G CREMA PERMETRINA (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:44.466511+00', NULL);
INSERT INTO public.products VALUES (1652, 2, NULL, NULL, 'Scabisan Emulsion 120ml Permetrina (Chinoin)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1653, 2, NULL, NULL, 'Sebryl Shampoo 150ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1654, 2, NULL, NULL, 'SEDALMERCK C/20 TABS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1655, 2, 23, 106, 'SEDALMERCK C/40 TABS NUEVA IMAGEN (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1656, 2, 23, 106, 'SEDALMERCK EXHIBIDOR C/200 TABS (MERK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1657, 2, NULL, NULL, 'SEDALMERCK MAX C/24 TABLETAS (MERCK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1658, 2, NULL, NULL, 'SEDANTREX VAL C/60 CAPS (VIDA HERBAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1659, 2, 72, 142, 'SEGFEMIOL c/21 TABS. 0.15/0.03 MG.(FARMA HISPANO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1660, 2, 72, 142, 'SEGFEMIOL c/28 TABS. 0.15/0.03 MG.(FARMA HISPANO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1661, 2, NULL, NULL, 'SELECTIVE 10MG C/14', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1662, 2, NULL, NULL, 'SELOKEN ZOK 95MG C/20 TABS (AZTRA ZENECA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1663, 2, NULL, NULL, 'SEMILLA DE BRASIL C/10 FRASCOS 15ML C/U', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1664, 2, NULL, NULL, 'SENOKOT 15MG C/18 TAB (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1665, 2, NULL, NULL, 'SENOKOT F 17.2MG C/30 TABLETAS (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1666, 2, 52, 139, 'SENOSIAIN ADULTO C/10 SUPOSITORIOS (SENOSIAIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1667, 2, 52, 139, 'SENOSIAIN BEBE C/10 SUPOSITORIOS (SENOSIAIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1668, 2, 52, 139, 'SENOSIAIN INFANTIL C/10 SUPOSITORIOS (SENOSIAIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1669, 2, NULL, NULL, 'SENSIBIT ALERGIAS 10MG C/10 TABS (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1670, 2, 33, 41, 'Sensibit D c/12 Tabs Loratadina, Fenilefrina, Paracetamol (Liomont)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1671, 2, 33, 41, 'Sensibit D Pediatrico 120ml Fenilefrina, Loratadina, Paracetamol (Liomont)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1672, 2, NULL, NULL, 'SENSIBIT INF 5MG C/10 TABS LORATADINA (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1673, 2, NULL, NULL, 'SEPIBEST 200MG C/20 TABS CARBAMAZEPINA (BEST)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1674, 2, NULL, NULL, 'SERRACAL 500MG C/12 TABS (SERRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1675, 2, NULL, NULL, 'SERTRALINA 50MG C/14 TABS (TEMPUSPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1676, 2, NULL, NULL, 'SEXTASIS HOMBRE C/60 TABS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1677, 2, NULL, NULL, 'SEXTASIS MUJER C/60 TABS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1678, 2, NULL, NULL, 'SHAMPOO A BASE DE SAVILA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1679, 2, NULL, NULL, 'SHAMPOO ACEITE DE OSO (GIZEH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1680, 2, NULL, NULL, 'SHAMPOO ALMENDRAS OLIVO Y RICINO 550ML(INDIO P)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1681, 2, NULL, NULL, 'SHAMPOO ARGAN DE MARRUECOS 550ML (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1682, 2, NULL, NULL, 'Shampoo Bergamota 500ml (Aucar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1683, 2, NULL, NULL, 'SHAMPOO CABALLO 1.1.L (VIDARELA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1684, 2, NULL, NULL, 'SHAMPOO CABALLO 550ML (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1685, 2, NULL, NULL, 'SHAMPOO CHILE (MEGAMIX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1686, 2, NULL, NULL, 'SHAMPOO COLA DE CABALLO 1.1 L (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1687, 2, NULL, NULL, 'SHAMPOO CON AC.DE JOJOBA 240ML (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1688, 2, NULL, NULL, 'SHAMPOO CRE-C FEM 3 PIEZAS 250ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1689, 2, NULL, NULL, 'SHAMPOO CRE-C MAX 1 PIEZA 250ML + 1 PIEZA TRATAMIENTO NOCTURNO GEL 150G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1690, 2, NULL, NULL, 'SHAMPOO CRE-C MAX 3 PIEZAS 250ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1691, 2, NULL, NULL, 'SHAMPOO DE TEPEZCOUITE (OCOTZAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1692, 2, NULL, NULL, 'SHAMPOO HAIRKLYN 59ML (NORDIMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1693, 2, NULL, NULL, 'SHAMPOO HENNA EGIPTO 400ML (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1694, 2, NULL, NULL, 'SHAMPOO HENNA+NOGAL 550ML (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1695, 2, NULL, NULL, 'SHAMPOO HERBAL ARBOL DE TE+ROMERO 550ML (INDIO P)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1696, 2, NULL, NULL, 'SHAMPOO NEEM+VITAMINAS 550ML (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1697, 2, NULL, NULL, 'SHAMPOO PARA BEBE 120ML (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1698, 2, NULL, NULL, 'SHAMPOO REPELENTE PARA PIOJOS 250ML (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1699, 2, NULL, NULL, 'SHAMPOO REPELENTE PARA PIOJOS 550ML (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1700, 2, NULL, NULL, 'SHAMPOO SANGRE DE GRADO CON ESPINOSILLA (GIZEH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1701, 2, NULL, NULL, 'SHAMPOO ZAPOYULO 550ML (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1702, 2, NULL, NULL, 'SHAMPOO/REPELENTE XTERMIN PIOJOS FRUTAS 550ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1703, 2, NULL, NULL, 'SHAMPOO/REPELENTE XTERMIN PIOJOS SANDIA 550ML', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1704, 2, NULL, NULL, 'SHOT B GS MAX C/30 TABS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1705, 2, NULL, NULL, 'SHOT-B C/30 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1706, 2, NULL, NULL, 'SHOT-B DIABETICO C/30 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1707, 2, NULL, NULL, 'SHOT-B GS C/30 + 30 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1708, 2, NULL, NULL, 'SHOT-B GS C/30 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1709, 2, NULL, NULL, 'SHOT-B I.Q. C/30 TABS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1710, 2, NULL, NULL, 'SIES 200MG C/20 CAPS (CETUS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1711, 2, 83, 143, 'Siete Machos Jabon 90g (Urania)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1712, 2, NULL, 143, 'Siete Machos Locion 1000ml (Urania)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1713, 2, NULL, 143, 'SIETE MACHOS LOCION 10ML (URANIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1714, 2, NULL, 143, 'Siete Machos Locion 110ml (Urania)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1715, 2, NULL, 143, 'Siete Machos Locion 250ml (Urania)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1716, 2, NULL, 143, 'Siete Machos Locion 400ml (Urania)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1717, 2, NULL, 143, 'Siete Machos Locion 750ml (Urania)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1718, 2, NULL, 143, 'Siete Machos Perfume 30ml (Urania)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1719, 2, NULL, 143, 'SIETE MACHOS SPRAY 220ML (URANIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1720, 2, NULL, NULL, 'SILDENAFIL 100MG C/1 TAB (HORMONA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1721, 2, NULL, NULL, 'Silimarino 1gc/60 Tabletas (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1722, 2, NULL, NULL, 'SILIMARINO 800MG C/90 (FARNAT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1723, 2, NULL, NULL, 'SILIMARINO C/60 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1724, 2, 75, 129, 'SILKA-MEDIC GEL 30G TERBINAFINA (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1725, 2, 52, NULL, 'SIMILAXOL C/50 TAB', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1726, 2, NULL, NULL, 'SIMPLEX C/60 TABLETAS (NARTEX LABS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1727, 2, NULL, NULL, 'SINGASTRI C/90 TABS 1G (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1728, 2, NULL, NULL, 'SINTROCID c/100 TABS. 0.100 MG.Levotiroxina Sódica (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1729, 2, NULL, NULL, 'SINUBERASE C/10 AMP ESPORAS BACILLUS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1730, 2, NULL, NULL, 'SINUBERASE C/12 COMPRIMIDOS ESPORAS BACILLUS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1731, 2, NULL, NULL, 'SINUBERASE C/20 AMP ESPORAS BACILLUS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1732, 2, NULL, NULL, 'SINUBERASE C/48 COMPRIMIDOS ESPORAS BACILLUS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1733, 2, NULL, NULL, 'SINUBERASE C/5 AMP ESPORAS BACILLUS (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1734, 2, 19, 31, 'SIRACUX ADULTO 120 ML OXELADINA+AMBROXOL  (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1735, 2, 19, 31, 'SIRACUX INF 120 ML OXELADINA+AMBROXOL  (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1736, 2, 19, 144, 'SITO-GRIX 120ML HEDERA HELIX (CMD)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1737, 2, NULL, NULL, 'SIXOL 1MG C/30 TABS COLCHICINA (BIOMEP)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1738, 2, 20, 62, 'SOLDRIN OFTÁLMICO 10ML (PISA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1739, 2, 20, 62, 'SOLDRIN OTICO 10ML (PISA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1740, 2, NULL, NULL, 'SOLUCION REMOVEDORA DE VERRUGAS 9ML (CERTUS PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1741, 2, 100, 60, 'SOLUTINA F GOTAS 20ML (ALCON)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1742, 2, NULL, NULL, 'SOLUTINA F GOTAS 20ML (ALCON) BLISTER', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1743, 2, NULL, NULL, 'SOLUTINA OJO ROJO 15ML (ALCON)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1744, 2, NULL, NULL, 'SONS  25MG C/30 TABS DIFENIDOL (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1745, 2, NULL, NULL, 'SOSTENON 250 (SCHERING-PLOUGH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1746, 2, 101, 12, 'SOVICLOR 200MG C/25 TABLETAS (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1747, 2, NULL, NULL, 'SOVICLOR 200MG C/70 TABLETAS (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1748, 2, 101, 12, 'SOVICLOR 400MG C/35 TABLETAS (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1749, 2, 101, 12, 'SOVICLOR 800MG C/35 TABLETAS (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1750, 2, NULL, NULL, 'SPORANOX 15D C/15 CAPS (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1751, 2, NULL, NULL, 'Stressnat 500mg c/60 Capsulas (Nature''s P.e.t. )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:45.227187+00', NULL);
INSERT INTO public.products VALUES (1752, 2, NULL, NULL, 'STUGERON 75MG C/20 TABS (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1753, 2, NULL, NULL, 'STUGERON FORTE 75MG C/60 TABS (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1754, 2, 33, 145, 'SUDAGRIP ANTIGRIPAL EXHIBIDOR C/100 CAPS  (PAILL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1755, 2, 33, 145, 'SUDAGRIP ANTIGRIPAL TE GRANULADO C/25 SOBRES (PAILL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1756, 2, 19, 145, 'SUDAGRIP TOS 120ML JARABE (PAILL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1757, 2, NULL, NULL, 'Suit-C Complex 600mg c/300 Tabs (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1758, 2, NULL, NULL, 'SUKROL C/100 TAB', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1759, 2, NULL, NULL, 'SUKROL MUJER C/30 TABS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1760, 2, NULL, NULL, 'SUKROL VIGOR C/50', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1761, 2, NULL, NULL, 'SUKROLITO INF JARABE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1762, 2, NULL, NULL, 'SUKUNAI KIROS 200MG C/30 CAPS (NATURA CASTLE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1763, 2, NULL, NULL, 'SUKUNAI KIROS MAX 200MG C/30 CAPS (NATURA CASTLE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1764, 2, NULL, NULL, 'SULFAMETOXAZOL/ TRIMETROPRIMA 100ML ( PHARMAGEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1765, 2, 20, 93, 'SULFATIAZOL POLVO 10G  (ALPRIMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1766, 2, 20, 70, 'SULFATIAZOL POLVO 12G  (KURAMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1767, 2, 20, 146, 'SULFATIAZOL POLVO 5G (MYGRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1768, 2, 20, 133, 'SULFATIAZOL POLVO 6G (SANAX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1769, 2, 20, NULL, 'SULFATIAZOL POMADA 27 GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1770, 2, NULL, NULL, 'SULFATIAZOL POMADA 27G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1771, 2, NULL, NULL, 'SULFAWAL-S 100ML SULFAMETOXAZOL/ TRIMETROPRIMA  ( NOVAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1772, 2, 12, 15, 'SUMA-B SOL INY TIAMINA-PIRIDOXINA-HIDROXOCOBALAMINA (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1773, 2, NULL, NULL, 'SUPER CREMA MILAGROSA CON ARCINA Y BELLADONA 29', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1774, 2, NULL, NULL, 'Super Dieter''s Drink 690mg c/120 Capsulas (La Salud es Primero)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1775, 2, NULL, NULL, 'Super Dieter''s Drink 690mg c/30 Capsulas (La Salud es Primero)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1776, 2, NULL, NULL, 'Super Dieter''s Drink 690mg c/90 Capsulas (La Salud es Primero )', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1777, 2, NULL, NULL, 'SUPER TIAMINA C/10 AMP (LABORATORIOS VENEZUELA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1778, 2, NULL, NULL, 'Suplemento Alimenticio # 3 (Farmacia de Ahorro)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1779, 2, NULL, NULL, 'SUPRADOL C/10 TABLETAS (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1780, 2, NULL, NULL, 'SUPRADOL C/2 TABLETAS (LIOMONT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1781, 2, NULL, NULL, 'SYDOLIL. 1MG C/36 TABS ERGOTAMINA/CAFEINA/ACIDO ACETILSALICILICO (SEGFRIED RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1782, 2, 17, 15, 'SYNALAR OFTALMICO 15ML (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1783, 2, 17, 15, 'SYNALAR OTICO 15ML GOTAS (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1784, 2, NULL, NULL, 'SYNALAR SIMPLE 0.01% 20G (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1785, 2, 17, 15, 'SYNALAR SIMPLE 40G (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1786, 2, 17, 15, 'SYNALAR-C 40GR (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1787, 2, NULL, NULL, 'SYNCOL C/24 TABS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1788, 2, NULL, NULL, 'SYNCOL MAX C/12 COMPRIMIDOS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1789, 2, NULL, NULL, 'SYNCOL NOCTURNO C/12 COMPRIMIDOS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1790, 2, NULL, NULL, 'SYNCOL TEEN C/12 COMPRIMIDOS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1791, 2, NULL, NULL, 'TABCIN  AZUL C/60 TABLETAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1792, 2, 33, 18, 'TABCIN 500 C/12 CAPSULAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1793, 2, 33, 18, 'TABCIN 500 EXHIBIDOR ROJO C/60 TABLETAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1794, 2, 33, 18, 'TABCIN ACTIVE C/12 CAPSULAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1795, 2, 33, 18, 'TABCIN AZUL C/12 TABS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1796, 2, NULL, NULL, 'TABCIN INFANTIL C/12 TABS EFERVECENTES (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1797, 2, NULL, NULL, 'TABCIN NOCHE C/12 CAPSULAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1798, 2, NULL, NULL, 'TAMANZELA C/12 CORTA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1799, 2, NULL, NULL, 'TAMANZELA C/6 GRANDE', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1800, 2, 33, 52, 'TAMEX C/10 TABS LORATADINA/ BETAMETASONA (SERRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1801, 2, 33, 52, 'TAMEX SUSP 60ML  LORATADINA/ BETAMETASONA (SERRAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1802, 2, NULL, NULL, 'TAMSULOSINA 0.4MG C/20 CAPS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1803, 2, 22, 111, 'TAMSULOSINA 0.4MG C/20 TABS (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1804, 2, NULL, NULL, 'TAMSULOSINA 0.4MG C/20 TABS (BEADVANCE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1805, 2, NULL, NULL, 'TAMSULOSINA 0.4MG C/20 TABS (HORMONA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1806, 2, NULL, NULL, 'TAMSULOSINA 0.4MG C/20 TABS (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1807, 2, NULL, NULL, 'Te 7 Azahares 150g (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1808, 2, NULL, NULL, 'Te Boldo c/25 sobres (Therbal)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1809, 2, NULL, NULL, 'Te Cerebryl 150g (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1810, 2, 30, 92, 'TE CHUPA GRASS  C/30 SOBRES (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1811, 2, NULL, 92, 'TE CHUPA GRASS  C/30 SOBRES (GN+VIDA)  USA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1812, 2, NULL, 92, 'TE CHUPA PANZA C/30 SOBRES (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1813, 2, NULL, 92, 'TE CHUPA PANZA C/30 SOBRES (GN+VIDA). USA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1814, 2, NULL, NULL, 'Te Cola de Caballo c/30 bolsitas (Anahuac)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1815, 2, NULL, NULL, 'Te de Chicura 150g (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1816, 2, NULL, 147, 'TÉ DIETERS DRINK C/36 SOBRES (LASALUD)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1817, 2, NULL, NULL, 'Te Hierba de San Juan c/25 Sobres (Therbal) (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1818, 2, NULL, NULL, 'Te Hierba del Sapo c/25 sobres (Therbal)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1819, 2, NULL, NULL, 'Te Manzanilla con Anis c/25 sobres (Therbal)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1820, 2, NULL, NULL, 'TE ME VALE MADRE (DINA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1821, 2, NULL, NULL, 'TE PINGUICA C/30 SOBRES (ANAHUAC)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1822, 2, NULL, 92, 'TE PIÑALIM C/30 SOBRES (GN+VD)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1823, 2, NULL, 92, 'TE PIÑALIM C/30 SOBRES (GN+VD).  USA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1824, 2, NULL, NULL, 'Te Sabila con Nopal c/30 bolsitas (Anahuac)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1825, 2, NULL, 75, 'TE TIZANA DE AZAHARES C/30 SOBRES (ANAHUAC)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1826, 2, NULL, NULL, 'Te Tiziana Betel 150g (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1827, 2, NULL, NULL, 'Te Uva Ursi Compuesto 150g (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1828, 2, NULL, NULL, 'Te Valeriana Compuesto 150g (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1829, 2, NULL, NULL, 'TEATRICAL CREMA 400G ACLARADORA (GENOMMA LAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1830, 2, NULL, NULL, 'TEATRICAL CREMA AZUL 230G (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1831, 2, NULL, NULL, 'TEATRICAL CREMA AZUL 400G (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1832, 2, NULL, NULL, 'TEATRICAL CREMA AZUL 52G (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1833, 2, NULL, NULL, 'TEATRICAL CREMA ROSA 130G (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1834, 2, NULL, NULL, 'TEATRICAL CREMA ROSA 230G (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1835, 2, NULL, NULL, 'TEATRICAL CREMA ROSA 400G (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1836, 2, NULL, NULL, 'TEGRETOL 2% 100ML SUSP (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1837, 2, NULL, NULL, 'TEGRETOL 200MG C/30 COMP (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1838, 2, 39, 122, 'TEGRETOL 200MG C/50 COMPRIMIDOS CARBAMAZEPINA (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1839, 2, 38, 38, 'TELMISARTAN 40MG  C/14 TABS (BOEHRINGER INGELHEIM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1840, 2, NULL, NULL, 'TELMISARTAN 40MG C/28 TABS (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1841, 2, NULL, NULL, 'TELMISARTAN 40MG C/30 (ULTRA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1842, 2, 23, 141, 'TEMPRA 500MG C/20 TABS (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1843, 2, 23, 141, 'TEMPRA FORTE 650MG C/24 TABS (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1844, 2, 23, 141, 'TEMPRA INFANTIL 120ML PARACETAMOL (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1845, 2, 23, 141, 'TEMPRA INFANTIL 150MG C/10 SUPOSITORIOS PARACETAMOL (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1846, 2, NULL, NULL, 'TEMPRA INFANTIL 6-11 Años PARACETAMOL (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1847, 2, 23, 141, 'TEMPRA INFANTIL 80MG C/10 SUPOSITORIOS PARACETAMOL (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1848, 2, 23, 141, 'TEMPRA PEDIATRICO 100ML PARACETAMOL (BRISTOL-MYERS SQUIBB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1849, 2, NULL, NULL, 'TENORETIC 100MG C/28 tabs (AZTRA ZENECA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1850, 2, NULL, NULL, 'TENORMIN 100MG C/28 TABS ATENOLOL (AZTRA ZENECA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1851, 2, NULL, NULL, 'TEPEZCOHUITE 15ML GOTAS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.046284+00', NULL);
INSERT INTO public.products VALUES (1852, 2, NULL, NULL, 'Tepezcohuite Polvo 35g (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1853, 2, NULL, NULL, 'TEPEZCOUITE CREMA 120GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1854, 2, NULL, NULL, 'TEPEZCOUITE CREMA 60GR (INDIO PAPAGO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1855, 2, NULL, NULL, 'TERBINAFINA 250 MG. C/28 TABS. (Megamed)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1856, 2, NULL, NULL, 'TERFAMEX 30MG C/30 TABS FENTERMINA (MEDIX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1857, 2, 20, 39, 'TERRAMICINA 10G OFTALMICA OXITETRACICLINA-POLIMIXINA B (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1858, 2, 20, 39, 'TERRAMICINA 125MG C/24 PAST OXITETRACICLINA (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1859, 2, 20, 39, 'TERRAMICINA 500MG C/16 CAPS OXITETRACICLINA (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1860, 2, 20, 39, 'TERRAMICINA P 28.4GR (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1861, 2, NULL, NULL, 'TERRA-TROCISCOS 15MG C/18 PAST (RRX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1862, 2, 20, 148, 'TERRAXIN UNGUENTO 10G - OXITETRACICLINA POLIMIXINA (SOPHIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1863, 2, 60, 101, 'Terron de magnesia 7g c/3 (Coyoacan Quimica)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1864, 2, NULL, NULL, 'TERVICALM 15ML DESENTERRADOR (HOMEOPATICOS MILENIUM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1865, 2, 75, 149, 'TERVIRAX 15ML HONGOS (HOMEOPATICOS MILENIUM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1866, 2, NULL, NULL, 'TESALITOS PARCHES', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1867, 2, NULL, NULL, 'TESALON INFANTIL SUPOSITORIOS C/12 (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1868, 2, NULL, NULL, 'TESALON PERLAS C/10 CAPS (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1869, 2, 19, 122, 'TESALON PERLAS C/20 CAPS (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1870, 2, NULL, NULL, 'TESALON TENALIF AD JARABE 150ML (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1871, 2, 19, 122, 'TESALON TENALIF AD MIEL-FRESA 150ML (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1872, 2, 19, 122, 'TESALON TENALIF INF MIEL-LIMON 150ML (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1873, 2, 19, 122, 'TESALON TESACOF ADULTO CEREZA 100ML (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1874, 2, 19, 122, 'TESALON TESACOF INFANTIL 100ML (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1875, 2, 102, 150, 'TESTOPRIM-D C/1 AMP (TOGOCINO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1876, 2, 102, 150, 'TESTOPRIM-D C/3 AMP (TOGOCINO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1877, 2, 20, 151, 'TETRA ATLANTIS 500MG C/20 CAPS TETRACICLINA (ATLANTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1878, 2, 20, 152, 'TETRACICLINA 500MG C/100 CAPS (MK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1879, 2, 20, 48, 'TETRACICLINA 500MG C/100 CAPS (SAIMED)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1880, 2, 20, 153, 'TETRACICLINA 500MG CAPS TETRIN (ARANTIZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1881, 2, NULL, NULL, 'TETRA-ZIL 500MG C/16 CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1882, 2, 20, 23, 'TETREX 500MG C/20 CAPS TETRACICLINA (HORMONA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1883, 2, NULL, NULL, 'THERAFLU EXTHEGRAN ROJO 10MG C/6 SOBRES (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1884, 2, NULL, NULL, 'THERAFLU EXTHEGRAN VERDE 10MG C/6 SOBRES (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1885, 2, NULL, NULL, 'TIAMINA 550 C/60 TABS (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1886, 2, NULL, NULL, 'TIAMINA JARABE 340ML (GN+VIDA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1887, 2, 12, 74, 'TIAMINAL B12 50,000 AMPULA C/5 JERINGAS (SILANES)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1888, 2, 12, 74, 'TIAMINAL B12 C/3 AMP (SILANES)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1889, 2, 12, 74, 'TIAMINAL B12 C/30 CAPSULAS (SILANES)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1890, 2, 12, 74, 'Tiaminal B-12 Trivalente AP c/3 Amp  Cianocobalamina, Tiamina y Piridoxina (Silanes)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1891, 2, 12, 74, 'Tiaminal B-12 Trivalente AP c/30 Caps Cianocobalamina, Tiamina y Piridoxina (Silanes)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1892, 2, NULL, NULL, 'TIBUVIT 259MG C/25 CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1893, 2, 75, 11, 'TING AEROSOL 160 GR (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1894, 2, 75, 11, 'TING AEROSOL 80G (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1895, 2, 75, 11, 'TING CREMA 28GR (SANOFI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1896, 2, 75, 154, 'TING CREMA 72GR (SANOFI AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1897, 2, 75, 154, 'TING TALCO 160G (SANOFI AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1898, 2, 75, 154, 'TING TALCO 45GR (SANOFI AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1899, 2, 75, 154, 'TING TALCO 85GR (SANOFI AVENTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1900, 2, 103, 155, 'TINTURA DE VIOLETA DE GENCINA 20ML (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1901, 2, 103, 155, 'TINTURA DE YODO 40ML (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1902, 2, NULL, NULL, 'TIO NACHO SHAMPOO 415ML (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1903, 2, NULL, NULL, 'TIRA NO/PIO/JIN SHAMPOO 12ML C/20 PZ', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1904, 2, NULL, NULL, 'T-Kita Estress 600mg c/60 Tabletas (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1905, 2, NULL, NULL, 'Tlanchalagua 400mg c/150 Caps (La Salud es Primero)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1906, 2, NULL, NULL, 'TOBRADEX 5ML (ALCON)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1907, 2, NULL, NULL, 'TOLUACHE CONCENTRADO', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1908, 2, 104, 15, 'TOPSYN GEL 0.05% 40G FLUOCINONIDA/ CILOQUINOL (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1909, 2, 104, 15, 'TOPSYN Y 40G GEL FLUOCINONIDA (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1910, 2, NULL, NULL, 'TOSTI CAJA C/24', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1911, 2, NULL, NULL, 'TRAMADOL 100MG C/100 CAPS (PHARMA RX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1912, 2, NULL, NULL, 'TRAMADOL 100MG C/50  CAPS (PHARMA RX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1913, 2, NULL, NULL, 'TRAMADOL 100MG C/60 + 60 DUO CAPS   (PHARMA RX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1914, 2, NULL, 156, 'TRAMED AZUL 100MG C/60 + 60 CAPS DUO TRAMADOL (BAJAMED) (2)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1915, 2, NULL, 156, 'TRAMED RV 100MG C/60 + 60 CAPS DUO TRAMADOL (BAJAMED) (2)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1916, 2, NULL, NULL, 'TREDA C/10 TABLETAS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1917, 2, 86, 7, 'TREDA C/20 + 10  TABLETAS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1918, 2, 86, 7, 'TREDA C/20 TABLETAS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1919, 2, 86, 7, 'TREDA SUSP NEOMICINA/CAOLIN/PECTINA (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1920, 2, NULL, NULL, 'TRIATOP SHAMPOO AZUL 400ML (GENOMMA LAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1921, 2, NULL, NULL, 'TRIATOP SHAMPOO ROJO 400ML (GENOMMA LAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1922, 2, 12, 42, 'TRIBEDOCE 50,000 C/5 AMP 2ML (BRULUART)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1923, 2, NULL, NULL, 'TRIBEDOCE C/10 AMP (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1924, 2, NULL, NULL, 'TRIBEDOCE C/30 TABS (BRULUART)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1925, 2, NULL, NULL, 'TRIBEDOCE C/L 2ML C/5 AMP (BRULUART)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1926, 2, 12, 42, 'TRIBEDOCE COMPUESTO C/3 AMP (BRULUART)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1927, 2, 12, 42, 'TRIBEDOCE DX C/3 AMP (BRULUART)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1928, 2, NULL, NULL, 'TRIBEDOCE FRASCO (EKO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1929, 2, NULL, NULL, 'TRIBEDOCE KIDS 240ML MULTIVITAMINAS (BRULUART)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1930, 2, NULL, NULL, 'Tri-luma 15g Fluocinolona, Hidroquinona, Tretinoina (Galderma)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1931, 2, 72, 18, 'TRIQUILAR C/21 TABLETAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1932, 2, NULL, NULL, 'TRI-VI-SOL PEDIATRICO 50ML (SIEGFRIED-RHEIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1933, 2, NULL, NULL, 'TROFERIT 120ML DROPROPIZINA (CHINOIN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1934, 2, 20, 111, 'TROPHARMA 500MG C/20 TABS ERITROMICINA (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1935, 2, NULL, NULL, 'TUKALIV C/20 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1936, 2, 19, 16, 'TUKELI NATURAL 120ML ADULTO-INFANTIL (GENOMALAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1937, 2, 19, 16, 'TUKOL-D ADULTO 125ML DEXTROMETORFANO/GUAIFENESINA  (GENOMALAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1938, 2, NULL, NULL, 'TUKOL-D DIABETES 120ML DEXTROMETORFANO/GUAIFENESINA (GENOMALAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1939, 2, 19, 16, 'TUKOL-D INFANTIL 125ML DEXTROMETORFANO/GUAIFENESINA (GENOMALAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1940, 2, 19, 16, 'TUKOL-D MIEL  INFANTIL 120ML DEXTROMETORFANO/GUAIFENESINA (GENOMALAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1941, 2, 19, 16, 'TUKOL-D MIEL ADULTO 120ML DEXTROMETORFANO/GUAIFENESINA (GENOMALAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1942, 2, NULL, NULL, 'TYLENOL C/20 TABLETAS (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1943, 2, NULL, NULL, 'TYLENOL SUSPENSION INFANTIL 120ML (JAUSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1944, 2, NULL, NULL, 'ULSEN 1+1 20MG C/7 CÁPSULAS (ALTIA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1945, 2, NULL, NULL, 'UNAMOL 10MG C/30 TABS CISAPRIDA (EXEA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1946, 2, NULL, NULL, 'UNAMOL 60ML PEDIATRICO CISAPRIDA (EXEA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1947, 2, 75, 104, 'UNESIA 20GR UNG BIOFONAZOL (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1948, 2, 75, 104, 'UNESIA TALCO 90GR  (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1949, 2, NULL, NULL, 'UNGÜENTO BRONCO RUB 40GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1950, 2, NULL, NULL, 'UNGUENTO DRAGON', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1951, 2, NULL, NULL, 'UNGÜENTO FORAPIÑA 125GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:46.944767+00', NULL);
INSERT INTO public.products VALUES (1952, 2, NULL, NULL, 'UNGÜENTO RESINA DE OCOTE 125GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1953, 2, 17, 157, 'UNGUENTO VETERINARIO LA TIA 125GR (ORDOÑEZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1954, 2, 17, 157, 'UNGUENTO VETERINARIO LA TIA 60GR (ORDOÑEZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1955, 2, NULL, NULL, 'UNIVAL 1G C/40 TABLETAS (EXEA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1956, 2, NULL, NULL, 'UÑA DE GATO C/60 CÁPSULAS (YPENZA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1957, 2, NULL, 33, 'UREZOL 100MG C/20 TABS FENAZOPIRIDINA (MAVI)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1958, 2, NULL, NULL, 'UROCLASIO NF 150ML CITRATO DE POTASIO, ACIDO CITRICO (ITALMEX)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1959, 2, NULL, 158, 'UROFIN 500MG C/100 TABS (LABORATORIOS LOPEZ)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1960, 2, NULL, NULL, 'UROGUTT 160MMG C/40 CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1961, 2, NULL, 12, 'UROVEC C/24 TABS TETRACICLINA,FENAZOPIRIDINA,SULFAMETOXAZOL (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1962, 2, NULL, 18, 'VAGITROL-V C/10 OVULOS ACETONIDO DE FLUOCINOLONA, METRONIDAZOL, NISTATINA (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1963, 2, NULL, NULL, 'VALERIANA 50ML (CENTRO BOTANICO LA PIEDAD)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1964, 2, NULL, NULL, 'Valeriana 60ml Gotas (Aukar)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1965, 2, NULL, NULL, 'VALPROATO DE MAGNESIO 200MG C/40 TABS (GENERICOS ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1966, 2, NULL, NULL, 'VARITON 500MG C/20 CAPS', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1967, 2, NULL, NULL, 'VASCULFLOW C/30 TABS (TEVA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1968, 2, NULL, NULL, 'VASELINA BLANCA BEBE 60GR (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1969, 2, NULL, NULL, 'VELA COLOR ROJO (PAREJA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1970, 2, NULL, NULL, 'VELAS COLOR ROJO C/20 PZ (BLANCA FLOR MAGICA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1971, 2, NULL, NULL, 'Venalot Depot c/30 Tabs Troxerutina/Cumarina (Nycomed)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1972, 2, NULL, NULL, 'VENASTAT C/60 CAPS VARICES (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1973, 2, NULL, NULL, 'Venda Elastica 10cm (Jaloma)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1974, 2, NULL, NULL, 'VENDA ELASTICA 15CM (JALOMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1975, 2, NULL, NULL, 'Venda Elastica 25cm (Jaloma)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1976, 2, NULL, NULL, 'Venda Elastica 30cm (Jaloma)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1977, 2, NULL, NULL, 'VENDA ELASTICA PREMIUM 10CM/500CM (LEROY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1978, 2, NULL, NULL, 'VENDA ELASTICA PREMIUM 15CM/500CM (LEROY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1979, 2, NULL, NULL, 'VENTOLIN 4MG C/ 30 TABS (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1980, 2, NULL, 22, 'VENTOLIN SALBUTAMOL C/200 DOSIS (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1981, 2, NULL, NULL, 'VENTOLIN SALBUTAMOL JBE 200ML (GLAXO SMITH KLINE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1982, 2, NULL, 31, 'VERIDEX 6MG C/2 TABS IVERMECTINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1983, 2, NULL, NULL, 'VERIDEX 6MG C/4 TABS IVERMECTINA (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1984, 2, NULL, NULL, 'VERISAN TRIPLEX', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1985, 2, NULL, NULL, 'VERMICOL 30ML MEBENDAZOL (DEGORTS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1986, 2, NULL, 108, 'VERMOX 1 DIA CEREZA 10ML (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1987, 2, NULL, 130, 'VERMOX 100MG C/6 TABS MEBENDAZOL (JANSSEN-CILAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1988, 2, NULL, 108, 'VERMOX 30ML PLATANO MEBENDAZOL (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1989, 2, NULL, 130, 'VERMOX 500MG C/1 TAB MEBENDAZOL (JANSSEN-CILAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1990, 2, NULL, 108, 'VERMOX PLUS 1 DIA C/2 TABLETAS (JANSSEN)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1991, 2, NULL, 130, 'VERMOX PLUS INF 10ML SABOR CEREZA (JANSSEN-CILAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1992, 2, NULL, 130, 'VERMOX PLUS INF 10ML SABOR PLATANO (JANSSEN-CILAG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1993, 2, NULL, 51, 'VEXOTIL 10MG C/30 TABS ENALAPRIL (BIOMEP)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1994, 2, NULL, 39, 'VIAGRA 100MG C/1 TAB SILDENAFIL (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1995, 2, NULL, 39, 'VIAGRA 100MG C/4 TAB SILDENAFIL (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1996, 2, NULL, NULL, 'VIAGRA 100MG DISPLAY C/10 TAB SILDENAFIL (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1997, 2, NULL, 31, 'VIAXOL 30ML GOTAS AMBROXOL (MAVER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1998, 2, NULL, NULL, 'Vibora de Cascabel 600mg c/150 Caps (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (1999, 2, NULL, 159, 'VIBORA DE CASCABEL C/50 CAPS (CHIAPAS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2000, 2, NULL, NULL, 'VIBORA DE CASCABEL C/90 (FARNAT)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2001, 2, NULL, 39, 'VIBRAMICINA 100MG C/10 CAPS (PFIZER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2002, 2, NULL, NULL, 'VICK 44 120ML GUAIFENESINA', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2003, 2, NULL, NULL, 'VICK BABY BALM 50G (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2004, 2, NULL, NULL, 'VICK CEREZA EXH C/10 C/20 PASTILLAS (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2005, 2, NULL, NULL, 'VICK LIMON EXH C/10 C/20 PASTILLAS (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2006, 2, NULL, NULL, 'VICK MENTOL EXH C/10 C/20 PASTILLAS (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2007, 2, NULL, NULL, 'VICK PYRENA MIEl/ LIMON C/12 SOBRES (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2008, 2, NULL, 160, 'VICK VAPORUB  C/40 LATITAS 12GR (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2009, 2, NULL, 160, 'VICK VAPORUB 100GR (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2010, 2, NULL, 160, 'VICK VAPORUB 5OGR (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2011, 2, NULL, 160, 'VICK VAPORUB C/12 LATITAS 12GR (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2012, 2, NULL, 160, 'VICK VAPORUB INHALADOR (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2013, 2, NULL, 160, 'VICK VAPORUB INHALADOR C/12 PIEZAS (VICK)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2014, 2, NULL, 161, 'VIDA MAGNESIO PLUS C/60 CAPS (COYOACAN QUIMICAS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2015, 2, NULL, NULL, 'VIDAMIL C/5 AMP RETINOL, ACIDO ASCORBICO,COLECALSIFEROL (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2016, 2, NULL, NULL, 'VITACILINA 16GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2017, 2, NULL, NULL, 'VITACILINA 28GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2018, 2, NULL, NULL, 'VITACILINA 32G', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2019, 2, NULL, NULL, 'VITACILINA BEBE 110GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2020, 2, NULL, NULL, 'VITACILINA BEBE 50GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2021, 2, NULL, NULL, 'VITAMINA E UI 1200MG C/30 CAPS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2022, 2, NULL, NULL, 'VITAMINA E UI 500MG CON GERMEN C/30 CAPS (SANDY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2023, 2, NULL, 162, 'VITERNUM 140ML JBE  (IPAL)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2024, 2, NULL, NULL, 'VIVINOX-N C/40 TABS (BOMUCA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2025, 2, NULL, NULL, 'Vivioptal Active c/30 Softgel Caps 2x1 (Bomuca)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2026, 2, NULL, NULL, 'VIVIOPTAL C/105 CAPS (BOMUCA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2027, 2, NULL, NULL, 'VIVIOPTAL C/30 CAPS (BOMUCA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2028, 2, NULL, NULL, 'VIVIOPTAL C/90 CAPS (BOMUCA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2029, 2, NULL, NULL, 'VIVIOPTAL JUNIOR  250ML (BOMUCA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2030, 2, NULL, NULL, 'Vivioptal Multi c/30 Softgel Caps 2x1 (Bomuca)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2031, 2, NULL, NULL, 'Vivioptal Women c/30 Softgel Caps 2x1 (Bomuca)  (USA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2032, 2, NULL, 111, 'VIVRADOXIL 100MG C/10 TABS DOXICICLINA (ALPHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2033, 2, NULL, NULL, 'VOLFENAC C/2 AMP 75MG (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2034, 2, NULL, 12, 'VOLFENAC C/4 AMP 75MG DICLOFENACO (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2035, 2, NULL, 12, 'VOLFENAC GEL 60GR DICLOFENACO (COLLINS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2036, 2, NULL, 13, 'VOLPROATO DE MAGNESIO 250MG C/30 TABS (AMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2037, 2, NULL, NULL, 'VOLTAREN C/5 AMP 3ML DICLOFENACO (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2038, 2, NULL, NULL, 'VOLTAREN DOLO C/20 CAPS 25MG (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2039, 2, NULL, 122, 'VOLTAREN EMULGEL 100GR DICLOFENACO (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2040, 2, NULL, NULL, 'VOLTAREN EMUNGEL 12H 100G (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2041, 2, NULL, NULL, 'VOLTAREN RETARD 100MG C/10 GRAGEAS (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2042, 2, NULL, 122, 'VOLTAREN RETARD 100MG C/20 TABS (NOVARTIS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2043, 2, NULL, 40, 'VOMISIN 15ML GOTAS DIMENHIDRINATO (RAYERE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2044, 2, NULL, 40, 'VOMISIN 50MG C/20 TABS DIMENHIDRINATO (RAYERE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2045, 2, NULL, NULL, 'VOMISIN SOL INY C/3 AMP DIMENHIDRINATO (RAYERE)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2046, 2, NULL, 7, 'VONTROL C/25 TABS DIFENIDOL (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2047, 2, NULL, NULL, 'VONTROL SOL INY 40MG/2ML (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2048, 2, NULL, 163, 'VO-REMI 15ML GOTAS MECLIZINA, PIRIDOXINA (OFFENBACH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2049, 2, NULL, 62, 'Votripax Forte 5mg c/3 Amp Complejo-Diclofenaco Sodico (Pisa)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2050, 2, NULL, NULL, 'VOYDOL 10MG C/10 TABS KETOROLACO (RAAM)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2051, 2, NULL, NULL, 'WereNopal 500mg c/150 Tabletas (Dina)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:47.873718+00', NULL);
INSERT INTO public.products VALUES (2052, 2, NULL, 164, 'WERMY 300MG C/15 TABS GABAPENTINA (WERMAR)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2053, 2, NULL, 164, 'WERMY 300MG C/30 TABS GABAPENTINA (WERMAR)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2054, 2, NULL, 104, 'XL-3 ANTIGRIPAL C/10 TABS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2055, 2, NULL, 104, 'XL-3 ANTIGRIPAL EXHIBIDOR C/25 CARTERAS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2056, 2, NULL, NULL, 'XL-3 Dia c/12 Tabs (Selder)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2057, 2, NULL, 104, 'XL-3 VR C/24 TABS ANTIGRIPAL CON ACCION ANTIVIRAL (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2058, 2, NULL, 16, 'XL-3 XTRA C/12 CAPS (GENOMALAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2059, 2, NULL, NULL, 'XL-DOL 500MG C/20 TABS (GENOMALAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2060, 2, NULL, NULL, 'XOTZILAC C/COLAGENO POLVO 470GR (SIEMPRE POSITIVO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2061, 2, NULL, NULL, 'X-RAY C/40 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2062, 2, NULL, NULL, 'X-RAY DOL C/20 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2063, 2, NULL, NULL, 'X-Ray Gel 30g Diclofenaco (Genomma Lab)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2064, 2, NULL, NULL, 'X-RAY SISTEMA OSEO C/30 CAPS (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2065, 2, NULL, NULL, 'XREY GEL ROJO 125GR', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2066, 2, NULL, NULL, 'XYLOCAÍNA 5% 35GR (RIMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2067, 2, NULL, NULL, 'Xylocaina EV 50ml', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2068, 2, NULL, NULL, 'XYLOCAÍNA SPRAY SOL 10% 115ML (RIMSA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2069, 2, NULL, 104, 'XYLOPROCT PLUS 30G UNGUENTO (GENOMMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2070, 2, NULL, 16, 'XYLOPROCT PLUS 60MG/5MG C/6 SUP (GENOMMA LAB)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2071, 2, NULL, 18, 'YASMIN 24/4 C/28 (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2072, 2, NULL, 18, 'YASMIN 3MG/0.03MG C/21 GRAGEAS (BAYER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2073, 2, NULL, NULL, 'Z-Blanco Reforzado 500mg c/60 Capsulas (Ener Green)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2074, 2, NULL, NULL, 'ZEBETYN C/30 CAPS COMPLEJO B (GEL PHARMA)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2075, 2, NULL, NULL, 'ZENTEL 10ML SUSPENSION (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2076, 2, NULL, NULL, 'ZENTEL 200MG C/10 TABS (SANFER)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2077, 2, NULL, NULL, 'ZERO PIOJO SHAMPIOJO 120ML C/PEINE DE LUJO (GBH)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2078, 2, NULL, 27, 'ZISUAL-C 30G UNG RECTAL C/6 CANULAS LIDOCAINA/ HIDROCORTISONA (SONS)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2079, 2, NULL, NULL, 'ZORRITONE BOLSA C/15  CARAMELOS (ANCALMO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2080, 2, NULL, 165, 'ZORRITONE JARABE 120ML (ANCALMO)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2081, 2, NULL, NULL, 'Zorromex Jarabe 120ml (Grupo Naturalmex)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2082, 2, NULL, NULL, 'ZUPAREX 20MG C/100 CAPS. PIROXICAM (VICTORY)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2083, 2, NULL, NULL, 'ZYPLO 60MG C/20 TABS LEVODROPROPIZINA (ARMSTRONG)', NULL, NULL, NULL, NULL, 0, NULL, true, '2025-07-06 18:15:48.729115+00', NULL);
INSERT INTO public.products VALUES (2085, 1, NULL, NULL, 'Test Product API Updated', 'Producto de prueba creado por test automático', 'TESTSKU1751958520', 'TESTBAR1751958520', 1, 0, NULL, true, '2025-07-08 07:08:40.461648+00', '2025-07-08 07:08:40.502236+00');
INSERT INTO public.products VALUES (2086, 1, NULL, NULL, 'Test Product API Updated', 'Producto de prueba creado por test automático', 'TESTSKU1751958582', 'TESTBAR1751958582', 1, 0, NULL, true, '2025-07-08 07:09:42.632762+00', '2025-07-08 07:09:42.656936+00');
INSERT INTO public.products VALUES (2087, 1, NULL, NULL, 'Test Product API Updated', 'Producto de prueba creado por test automático', 'TESTSKU1751958646', 'TESTBAR1751958646', 1, 0, NULL, true, '2025-07-08 07:10:46.006764+00', '2025-07-08 07:10:46.032825+00');
INSERT INTO public.products VALUES (2088, 1, NULL, NULL, 'Test Product API Updated', 'Producto de prueba creado por test automático', 'TESTSKU1751958707', 'TESTBAR1751958707', 1, 0, NULL, true, '2025-07-08 07:11:47.674504+00', '2025-07-08 07:11:47.697913+00');
INSERT INTO public.products VALUES (2089, 1, 1, 1, 'Producto Test Directo', 'Descripción de prueba', 'DIRECT001', NULL, 1, 0, NULL, true, '2025-07-10 07:02:54.610524+00', NULL);


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.purchase_order_items VALUES (1, 1, 1, 7, 50, 0, 50, 12, 600, 'Coca-Cola 600ml', 'CC-600', 'SUP-CC-600', NULL, '2025-07-06 18:09:32.066258+00', NULL);
INSERT INTO public.purchase_order_items VALUES (2, 1, 2, 7, 30, 0, 30, 25, 750, 'Coca-Cola 2L', 'CC-2L', 'SUP-CC-2L', NULL, '2025-07-06 18:09:32.066258+00', NULL);
INSERT INTO public.purchase_order_items VALUES (3, 2, 3, 7, 40, 0, 40, 18, 720, 'Leche Lala Entera 1L', 'LL-1L', 'SUP-LL-1L', NULL, '2025-07-06 18:09:32.066258+00', NULL);


--
-- Data for Name: purchase_order_receipt_items; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: purchase_order_receipts; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.purchase_orders VALUES (1, 1, 1, 1, 2, 'PO-20250106-001', NULL, 'PENDING', '2025-07-04 11:09:32.073607+00', '2025-07-11 11:09:32.073657', NULL, 1000, 160, 0, 0, 1160, 'NET_30', 'pending', 'Orden urgente para restock', NULL, '2025-07-06 18:09:32.066258+00', NULL, NULL, NULL);
INSERT INTO public.purchase_orders VALUES (2, 1, 2, 1, 2, 'PO-20250105-002', NULL, 'APPROVED', '2025-07-03 11:09:32.084368+00', '2025-07-09 11:09:32.084376', NULL, 750, 120, 0, 0, 870, 'NET_15', 'pending', 'Productos lácteos y abarrotes', NULL, '2025-07-06 18:09:32.066258+00', NULL, '2025-07-05 11:09:32.084378', 1);


--
-- Data for Name: sale_items; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: stock_alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: supplier_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.supplier_products VALUES (1, 1, 1, 'SUP-CC-600', 'Coca-Cola 600ml', 10.8, 10, 9, true, true, '2025-07-06 18:09:32.038154+00', NULL);
INSERT INTO public.supplier_products VALUES (2, 2, 2, 'SUP-CC-2L', 'Coca-Cola 2L', 22.5, 10, 15, true, true, '2025-07-06 18:09:32.038154+00', NULL);
INSERT INTO public.supplier_products VALUES (3, 3, 3, 'SUP-LL-1L', 'Leche Lala Entera 1L', 16.2, 10, 5, true, true, '2025-07-06 18:09:32.038154+00', NULL);
INSERT INTO public.supplier_products VALUES (4, 1, 4, 'SUP-LL-DL-1L', 'Leche Lala Deslactosada 1L', 19.8, 10, 5, true, false, '2025-07-06 18:09:32.038154+00', NULL);
INSERT INTO public.supplier_products VALUES (5, 2, 5, 'SUP-PB-BG', 'Pan Blanco Grande', 25.2, 10, 5, true, false, '2025-07-06 18:09:32.038154+00', NULL);
INSERT INTO public.supplier_products VALUES (6, 3, 6, 'SUP-PB-INT', 'Pan Integral', 28.8, 10, 13, true, false, '2025-07-06 18:09:32.038154+00', NULL);
INSERT INTO public.supplier_products VALUES (7, 1, 7, 'SUP-HM-1K', 'Harina Maseca 1kg', 16.2, 10, 9, true, false, '2025-07-06 18:09:32.038154+00', NULL);
INSERT INTO public.supplier_products VALUES (8, 2, 8, 'SUP-HM-4K', 'Harina Maseca 4kg', 58.5, 10, 13, true, false, '2025-07-06 18:09:32.038154+00', NULL);


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.suppliers VALUES (1, 1, 'Distribuidora Central', 'Distribuidora Central S.A. de C.V.', 'DCE120415AB1', 'ventas@distcentral.com', '555-1001', NULL, NULL, 'Zona Industrial Norte 100', 'Ciudad', NULL, NULL, NULL, 'NET_30', 50000, 0, 'Roberto Martinez', NULL, 'roberto@distcentral.com', NULL, true, NULL, '2025-07-06 18:09:31.904463+00', NULL);
INSERT INTO public.suppliers VALUES (2, 1, 'Comercializadora del Valle', 'Comercializadora del Valle S.A.', 'CDV091205XY2', 'contacto@comvalle.com', '555-2002', NULL, NULL, 'Av. del Valle 250', 'Ciudad', NULL, NULL, NULL, 'NET_15', 25000, 0, 'Ana Gutierrez', NULL, 'ana@comvalle.com', NULL, true, NULL, '2025-07-06 18:09:31.904463+00', NULL);
INSERT INTO public.suppliers VALUES (3, 1, 'Abarrotes El Mayorista', 'Abarrotes El Mayorista S.C.', 'AEM150820ZW3', 'ventas@mayorista.com', '555-3003', NULL, NULL, 'Mercado Central Local 45', 'Ciudad', NULL, NULL, NULL, 'CASH', 15000, 0, 'Carlos Lopez', NULL, 'carlos@mayorista.com', NULL, true, NULL, '2025-07-06 18:09:31.904463+00', NULL);


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.units VALUES (1, 'Kilogramo', 'kg', 'weight', 1, true, '2025-07-06 18:09:31.024157+00');
INSERT INTO public.units VALUES (2, 'Gramo', 'g', 'weight', 0.001, true, '2025-07-06 18:09:31.024157+00');
INSERT INTO public.units VALUES (3, 'Litro', 'L', 'volume', 1, true, '2025-07-06 18:09:31.024157+00');
INSERT INTO public.units VALUES (4, 'Mililitro', 'ml', 'volume', 0.001, true, '2025-07-06 18:09:31.024157+00');
INSERT INTO public.units VALUES (5, 'Metro', 'm', 'length', 1, true, '2025-07-06 18:09:31.024157+00');
INSERT INTO public.units VALUES (6, 'Centímetro', 'cm', 'length', 0.01, true, '2025-07-06 18:09:31.024157+00');
INSERT INTO public.units VALUES (7, 'Pieza', 'pza', 'count', 1, true, '2025-07-06 18:09:31.024157+00');
INSERT INTO public.units VALUES (8, 'Caja', 'caja', 'count', 1, true, '2025-07-06 18:09:31.024157+00');
INSERT INTO public.units VALUES (9, 'Paquete', 'paq', 'count', 1, true, '2025-07-06 18:09:31.024157+00');


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (1, 'admin@maestroinventario.com', '$2b$12$K5RE5gMyAdwRpYRvTL96fuOnN43HyYRmQASIGbYADkL1sTn1/oXTO', 'Administrador', 'Sistema', 'ADMIN', true, true, '2025-07-06 18:09:31.826123+00', NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2b$12$K5RE5gMyAdwRpYRvTL96fuOnN43HyYRmQASIGbYADkL1sTn1/oXTO');
INSERT INTO public.users VALUES (2, 'manager@maestroinventario.com', '$2b$12$2yvIidjTgXZlvdTCz6e9duV6pyYHlmHlhASxcTqWabDeyHaGkoDDe', 'Maria', 'Gonzalez', 'MANAGER', true, false, '2025-07-06 18:09:31.826123+00', NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2b$12$2yvIidjTgXZlvdTCz6e9duV6pyYHlmHlhASxcTqWabDeyHaGkoDDe');
INSERT INTO public.users VALUES (3, 'employee@maestroinventario.com', '$2b$12$l1JaszOgsVttKW0Pgsn.zeeBYw9Nlv3s1pLL0fnv2hjJv9hSQ/OrS', 'Juan', 'Perez', 'EMPLOYEE', true, false, '2025-07-06 18:09:31.826123+00', NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2b$12$l1JaszOgsVttKW0Pgsn.zeeBYw9Nlv3s1pLL0fnv2hjJv9hSQ/OrS');
INSERT INTO public.users VALUES (4, 'admin@maestro.com', '$2b$12$mEGX8Kq6XfXrstNo1A0Ga.rm3ofvCi3HEHTEoFsWjQEZ2QhLnjaa.', 'Administrador', 'de Prueba', 'ADMIN', true, true, '2025-07-07 05:17:51.960368+00', NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2b$12$mEGX8Kq6XfXrstNo1A0Ga.rm3ofvCi3HEHTEoFsWjQEZ2QhLnjaa.');
INSERT INTO public.users VALUES (5, 'capturista@maestro.com', '$2b$12$JGReK6UbbCE.xOp2iY5M..B4G/PVfww8fbEmcntAY12xgX3bO.78G', 'Capturista', 'de Prueba', 'CAPTURISTA', true, false, '2025-07-07 05:34:28.113084+00', NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2b$12$JGReK6UbbCE.xOp2iY5M..B4G/PVfww8fbEmcntAY12xgX3bO.78G');
INSERT INTO public.users VALUES (6, 'almacenista@maestro.com', '$2b$12$XB/OJX1BYi2c3dbbX2g0dOidAh6Yx/qqpiOcbRamkUPdXVZPPnF9a', 'Almacenista', 'de Prueba', 'ALMACENISTA', true, false, '2025-07-07 05:34:28.113084+00', NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2b$12$XB/OJX1BYi2c3dbbX2g0dOidAh6Yx/qqpiOcbRamkUPdXVZPPnF9a');


--
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.warehouses VALUES (1, 1, 'Almacén Principal', 'Almacén principal de la tienda', 'AP001', 'Av. Principal 123, Bodega A', true, '2025-07-06 18:09:31.891835+00', NULL);
INSERT INTO public.warehouses VALUES (2, 1, 'Almacén Secundario', 'Almacén para productos no perecederos', 'AS001', 'Calle Secundaria 456, Bodega B', true, '2025-07-06 18:09:31.891835+00', NULL);


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

