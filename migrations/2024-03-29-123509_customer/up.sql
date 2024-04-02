-- Your SQL goes here
--
-- TOC entry 217 (class 1259 OID 135191)
-- Name: customer; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);

--
-- TOC entry 218 (class 1259 OID 135201)
-- Name: customer_address; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--
-- TOC entry 219 (class 1259 OID 135215)
-- Name: customer_group; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE customer_group (
    id text NOT NULL,
    name text,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 220 (class 1259 OID 135225)
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text
);

--
-- TOC entry 3419 (class 0 OID 135191)
-- Dependencies: 217
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3420 (class 0 OID 135201)
-- Dependencies: 218
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3421 (class 0 OID 135215)
-- Dependencies: 219
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3422 (class 0 OID 135225)
-- Dependencies: 220
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3265 (class 2606 OID 135211)
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY customer_address
ADD
    CONSTRAINT customer_address_pkey PRIMARY KEY (id);

--
-- TOC entry 3272 (class 2606 OID 135233)
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY customer_group_customer
ADD
    CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);

--
-- TOC entry 3268 (class 2606 OID 135223)
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY customer_group
ADD
    CONSTRAINT customer_group_pkey PRIMARY KEY (id);

--
-- TOC entry 3260 (class 2606 OID 135200)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY customer
ADD
    CONSTRAINT customer_pkey PRIMARY KEY (id);

--
-- TOC entry 3261 (class 1259 OID 135212)
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_customer_address_customer_id" ON customer_address USING btree (customer_id);

--
-- TOC entry 3262 (class 1259 OID 135213)
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON customer_address USING btree (customer_id)
WHERE
    (is_default_billing = true);

--
-- TOC entry 3263 (class 1259 OID 135214)
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON customer_address USING btree (customer_id)
WHERE
    (is_default_shipping = true);

--
-- TOC entry 3269 (class 1259 OID 135235)
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_customer_group_customer_customer_id" ON customer_group_customer USING btree (customer_id);

--
-- TOC entry 3270 (class 1259 OID 135234)
-- Name: IDX_customer_group_customer_group_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_customer_group_customer_group_id" ON customer_group_customer USING btree (customer_group_id);

--
-- TOC entry 3266 (class 1259 OID 135224)
-- Name: IDX_customer_group_name; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_customer_group_name" ON customer_group USING btree (name)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3273 (class 2606 OID 135236)
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY customer_address
ADD
    CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES customer(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3274 (class 2606 OID 135241)
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY customer_group_customer
ADD
    CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES customer_group(id) ON DELETE CASCADE;

--
-- TOC entry 3275 (class 2606 OID 135246)
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY customer_group_customer
ADD
    CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE;