-- Your SQL goes here
--
-- TOC entry 217 (class 1259 OID 136322)
-- Name: region; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);

--
-- TOC entry 218 (class 1259 OID 136333)
-- Name: region_country; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code integer NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text
);

--
-- TOC entry 3395 (class 0 OID 136322)
-- Dependencies: 217
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3396 (class 0 OID 136333)
-- Dependencies: 218
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3250 (class 2606 OID 136339)
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY region_country
ADD
    CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);

--
-- TOC entry 3247 (class 2606 OID 136330)
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY region
ADD
    CONSTRAINT region_pkey PRIMARY KEY (id);

--
-- TOC entry 3248 (class 1259 OID 136340)
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON region_country USING btree (region_id, iso_2);

--
-- TOC entry 3245 (class 1259 OID 136332)
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_region_deleted_at" ON region USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3251 (class 2606 OID 136341)
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY region_country
ADD
    CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES region(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;