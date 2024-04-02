-- Your SQL goes here
--
-- TOC entry 218 (class 1259 OID 136542)
-- Name: stock_location; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);

--
-- TOC entry 217 (class 1259 OID 136532)
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);

--
-- TOC entry 3397 (class 0 OID 136542)
-- Dependencies: 218
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3396 (class 0 OID 136532)
-- Dependencies: 217
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3248 (class 2606 OID 136540)
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY stock_location_address
ADD
    CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);

--
-- TOC entry 3251 (class 2606 OID 136550)
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY stock_location
ADD
    CONSTRAINT stock_location_pkey PRIMARY KEY (id);

--
-- TOC entry 3246 (class 1259 OID 136541)
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_stock_location_address_deleted_at" ON stock_location_address USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3249 (class 1259 OID 136551)
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_stock_location_deleted_at" ON stock_location USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3252 (class 2606 OID 136552)
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY stock_location
ADD
    CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES stock_location_address(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;