-- Your SQL goes here
--
-- TOC entry 217 (class 1259 OID 136512)
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 3388 (class 0 OID 136512)
-- Dependencies: 217
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3244 (class 2606 OID 136521)
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY sales_channel
ADD
    CONSTRAINT sales_channel_pkey PRIMARY KEY (id);

--
-- TOC entry 3242 (class 1259 OID 136522)
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_sales_channel_deleted_at" ON sales_channel USING btree (deleted_at);