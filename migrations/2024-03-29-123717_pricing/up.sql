-- Your SQL goes here
--
-- TOC entry 218 (class 1259 OID 135908)
-- Name: price; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    rules_count integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity numeric,
    max_quantity numeric
);

--
-- TOC entry 222 (class 1259 OID 135984)
-- Name: price_list; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE price_list (
    id text NOT NULL,
    status text DEFAULT 'draft' :: text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0 NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale' :: text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK (
        (
            status = ANY (ARRAY ['active'::text, 'draft'::text])
        )
    ),
    CONSTRAINT price_list_type_check CHECK (
        (
            type = ANY (ARRAY ['sale'::text, 'override'::text])
        )
    )
);

--
-- TOC entry 223 (class 1259 OID 135994)
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE price_list_rule (
    id text NOT NULL,
    rule_type_id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 224 (class 1259 OID 136013)
-- Name: price_list_rule_value; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE price_list_rule_value (
    id text NOT NULL,
    value text NOT NULL,
    price_list_rule_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 221 (class 1259 OID 135939)
-- Name: price_rule; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE price_rule (
    id text NOT NULL,
    price_set_id text NOT NULL,
    rule_type_id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 217 (class 1259 OID 135899)
-- Name: price_set; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 220 (class 1259 OID 135930)
-- Name: price_set_rule_type; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE price_set_rule_type (
    id text NOT NULL,
    price_set_id text NOT NULL,
    rule_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 219 (class 1259 OID 135920)
-- Name: rule_type; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE rule_type (
    id text NOT NULL,
    name text NOT NULL,
    rule_attribute text NOT NULL,
    default_priority integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 3474 (class 0 OID 135908)
-- Dependencies: 218
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3478 (class 0 OID 135984)
-- Dependencies: 222
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3479 (class 0 OID 135994)
-- Dependencies: 223
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3480 (class 0 OID 136013)
-- Dependencies: 224
-- Data for Name: price_list_rule_value; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3477 (class 0 OID 135939)
-- Dependencies: 221
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3473 (class 0 OID 135899)
-- Dependencies: 217
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3476 (class 0 OID 135930)
-- Dependencies: 220
-- Data for Name: price_set_rule_type; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3475 (class 0 OID 135920)
-- Dependencies: 219
-- Data for Name: rule_type; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3310 (class 2606 OID 135993)
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_list
ADD
    CONSTRAINT price_list_pkey PRIMARY KEY (id);

--
-- TOC entry 3315 (class 2606 OID 136002)
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_list_rule
ADD
    CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);

--
-- TOC entry 3319 (class 2606 OID 136021)
-- Name: price_list_rule_value price_list_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_list_rule_value
ADD
    CONSTRAINT price_list_rule_value_pkey PRIMARY KEY (id);

--
-- TOC entry 3292 (class 2606 OID 135917)
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price
ADD
    CONSTRAINT price_pkey PRIMARY KEY (id);

--
-- TOC entry 3307 (class 2606 OID 135948)
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_rule
ADD
    CONSTRAINT price_rule_pkey PRIMARY KEY (id);

--
-- TOC entry 3286 (class 2606 OID 135907)
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_set
ADD
    CONSTRAINT price_set_pkey PRIMARY KEY (id);

--
-- TOC entry 3301 (class 2606 OID 135938)
-- Name: price_set_rule_type price_set_rule_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_set_rule_type
ADD
    CONSTRAINT price_set_rule_type_pkey PRIMARY KEY (id);

--
-- TOC entry 3296 (class 2606 OID 135929)
-- Name: rule_type rule_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY rule_type
ADD
    CONSTRAINT rule_type_pkey PRIMARY KEY (id);

--
-- TOC entry 3287 (class 1259 OID 136078)
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_currency_code" ON price USING btree (currency_code)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3288 (class 1259 OID 136038)
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_deleted_at" ON price USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3308 (class 1259 OID 136033)
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_list_deleted_at" ON price_list USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3311 (class 1259 OID 136050)
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_list_rule_deleted_at" ON price_list_rule USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3312 (class 1259 OID 136049)
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_list_rule_price_list_id" ON price_list_rule USING btree (price_list_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3313 (class 1259 OID 136048)
-- Name: IDX_price_list_rule_rule_type_id_unique; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_price_list_rule_rule_type_id_unique" ON price_list_rule USING btree (rule_type_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3316 (class 1259 OID 136052)
-- Name: IDX_price_list_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_list_rule_value_deleted_at" ON price_list_rule_value USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3317 (class 1259 OID 136051)
-- Name: IDX_price_list_rule_value_price_list_rule_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_list_rule_value_price_list_rule_id" ON price_list_rule_value USING btree (price_list_rule_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3289 (class 1259 OID 136037)
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_price_list_id" ON price USING btree (price_list_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3290 (class 1259 OID 136035)
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_price_set_id" ON price USING btree (price_set_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3302 (class 1259 OID 136047)
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_rule_deleted_at" ON price_rule USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3303 (class 1259 OID 136085)
-- Name: IDX_price_rule_price_id_rule_type_id_unique; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_price_rule_price_id_rule_type_id_unique" ON price_rule USING btree (price_id, rule_type_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3304 (class 1259 OID 136044)
-- Name: IDX_price_rule_price_set_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_rule_price_set_id" ON price_rule USING btree (price_set_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3305 (class 1259 OID 136045)
-- Name: IDX_price_rule_rule_type_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_rule_rule_type_id" ON price_rule USING btree (rule_type_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3284 (class 1259 OID 136034)
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_set_deleted_at" ON price_set USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3297 (class 1259 OID 136043)
-- Name: IDX_price_set_rule_type_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_set_rule_type_deleted_at" ON price_set_rule_type USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3298 (class 1259 OID 136041)
-- Name: IDX_price_set_rule_type_price_set_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_set_rule_type_price_set_id" ON price_set_rule_type USING btree (price_set_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3299 (class 1259 OID 136042)
-- Name: IDX_price_set_rule_type_rule_type_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_price_set_rule_type_rule_type_id" ON price_set_rule_type USING btree (rule_type_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3293 (class 1259 OID 136040)
-- Name: IDX_rule_type_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_rule_type_deleted_at" ON rule_type USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3294 (class 1259 OID 136039)
-- Name: IDX_rule_type_rule_attribute; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_rule_type_rule_attribute" ON rule_type USING btree (rule_attribute)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3327 (class 2606 OID 136068)
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_list_rule
ADD
    CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3328 (class 2606 OID 136003)
-- Name: price_list_rule price_list_rule_rule_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_list_rule
ADD
    CONSTRAINT price_list_rule_rule_type_id_foreign FOREIGN KEY (rule_type_id) REFERENCES rule_type(id) ON UPDATE CASCADE;

--
-- TOC entry 3329 (class 2606 OID 136022)
-- Name: price_list_rule_value price_list_rule_value_price_list_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_list_rule_value
ADD
    CONSTRAINT price_list_rule_value_price_list_rule_id_foreign FOREIGN KEY (price_list_rule_id) REFERENCES price_list_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3320 (class 2606 OID 136053)
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price
ADD
    CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3321 (class 2606 OID 135949)
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price
ADD
    CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3324 (class 2606 OID 136079)
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_rule
ADD
    CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES price(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3325 (class 2606 OID 135969)
-- Name: price_rule price_rule_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_rule
ADD
    CONSTRAINT price_rule_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3326 (class 2606 OID 136063)
-- Name: price_rule price_rule_rule_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_rule
ADD
    CONSTRAINT price_rule_rule_type_id_foreign FOREIGN KEY (rule_type_id) REFERENCES rule_type(id) ON UPDATE CASCADE;

--
-- TOC entry 3322 (class 2606 OID 135959)
-- Name: price_set_rule_type price_set_rule_type_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_set_rule_type
ADD
    CONSTRAINT price_set_rule_type_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3323 (class 2606 OID 136073)
-- Name: price_set_rule_type price_set_rule_type_rule_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY price_set_rule_type
ADD
    CONSTRAINT price_set_rule_type_rule_type_id_foreign FOREIGN KEY (rule_type_id) REFERENCES rule_type(id) ON UPDATE CASCADE ON DELETE CASCADE;