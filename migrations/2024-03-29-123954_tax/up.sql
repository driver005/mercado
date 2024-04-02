-- Your SQL goes here
--
-- TOC entry 217 (class 1259 OID 136565)
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);

--
-- TOC entry 219 (class 1259 OID 136587)
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE tax_rate (
    id text NOT NULL,
    rate real,
    code text,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);

--
-- TOC entry 220 (class 1259 OID 136601)
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);

--
-- TOC entry 218 (class 1259 OID 136573)
-- Name: tax_region; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (
        (
            (parent_id IS NULL)
            OR (province_code IS NOT NULL)
        )
    ),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (
        (
            (parent_id IS NULL)
            OR (provider_id IS NULL)
        )
    )
);

--
-- TOC entry 3424 (class 0 OID 136565)
-- Dependencies: 217
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3426 (class 0 OID 136587)
-- Dependencies: 219
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3427 (class 0 OID 136601)
-- Dependencies: 220
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3425 (class 0 OID 136573)
-- Dependencies: 218
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3260 (class 2606 OID 136572)
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY tax_provider
ADD
    CONSTRAINT tax_provider_pkey PRIMARY KEY (id);

--
-- TOC entry 3270 (class 2606 OID 136597)
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY tax_rate
ADD
    CONSTRAINT tax_rate_pkey PRIMARY KEY (id);

--
-- TOC entry 3276 (class 2606 OID 136609)
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY tax_rate_rule
ADD
    CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);

--
-- TOC entry 3265 (class 2606 OID 136583)
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY tax_region
ADD
    CONSTRAINT tax_region_pkey PRIMARY KEY (id);

--
-- TOC entry 3266 (class 1259 OID 136600)
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_single_default_region" ON tax_rate USING btree (tax_region_id)
WHERE
    (
        (is_default = true)
        AND (deleted_at IS NULL)
    );

--
-- TOC entry 3267 (class 1259 OID 136599)
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_tax_rate_deleted_at" ON tax_rate USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3271 (class 1259 OID 136612)
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON tax_rate_rule USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3272 (class 1259 OID 136611)
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_tax_rate_rule_reference_id" ON tax_rate_rule USING btree (reference_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3273 (class 1259 OID 136610)
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON tax_rate_rule USING btree (tax_rate_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3274 (class 1259 OID 136613)
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON tax_rate_rule USING btree (tax_rate_id, reference_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3268 (class 1259 OID 136598)
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_tax_rate_tax_region_id" ON tax_rate USING btree (tax_region_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3261 (class 1259 OID 136585)
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_tax_region_deleted_at" ON tax_region USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3262 (class 1259 OID 136584)
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_tax_region_parent_id" ON tax_region USING btree (parent_id);

--
-- TOC entry 3263 (class 1259 OID 136586)
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON tax_region USING btree (country_code, province_code);

--
-- TOC entry 3280 (class 2606 OID 136629)
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY tax_rate_rule
ADD
    CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES tax_rate(id) ON DELETE CASCADE;

--
-- TOC entry 3279 (class 2606 OID 136624)
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY tax_rate
ADD
    CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES tax_region(id) ON DELETE CASCADE;

--
-- TOC entry 3277 (class 2606 OID 136619)
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY tax_region
ADD
    CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES tax_region(id) ON DELETE CASCADE;

--
-- TOC entry 3278 (class 2606 OID 136614)
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY tax_region
ADD
    CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES tax_provider(id) ON DELETE
SET
    NULL;