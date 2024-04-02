-- Your SQL goes here
--
-- TOC entry 217 (class 1259 OID 136675)
-- Name: store; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store' :: text NOT NULL,
    supported_currency_codes text [] DEFAULT '{}' :: text [] NOT NULL,
    default_currency_code text,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 3389 (class 0 OID 136675)
-- Dependencies: 217
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3245 (class 2606 OID 136685)
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY store
ADD
    CONSTRAINT store_pkey PRIMARY KEY (id);

--
-- TOC entry 3243 (class 1259 OID 136686)
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_store_deleted_at" ON store USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);