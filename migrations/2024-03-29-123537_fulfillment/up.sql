-- Your SQL goes here
--
-- TOC entry 226 (class 1259 OID 135367)
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 217 (class 1259 OID 135259)
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE fulfillment_address (
    id text NOT NULL,
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
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 228 (class 1259 OID 135393)
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 227 (class 1259 OID 135382)
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 218 (class 1259 OID 135269)
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);

--
-- TOC entry 219 (class 1259 OID 135277)
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 221 (class 1259 OID 135300)
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country' :: text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK (
        (
            type = ANY (
                ARRAY ['country'::text, 'province'::text, 'city'::text, 'zip'::text]
            )
        )
    )
);

--
-- TOC entry 220 (class 1259 OID 135288)
-- Name: service_zone; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 224 (class 1259 OID 135337)
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat' :: text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK (
        (
            price_type = ANY (ARRAY ['calculated'::text, 'flat'::text])
        )
    )
);

--
-- TOC entry 225 (class 1259 OID 135355)
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK (
        (
            operator = ANY (
                ARRAY ['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text]
            )
        )
    )
);

--
-- TOC entry 222 (class 1259 OID 135316)
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 223 (class 1259 OID 135326)
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 3523 (class 0 OID 135367)
-- Dependencies: 226
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3514 (class 0 OID 135259)
-- Dependencies: 217
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3525 (class 0 OID 135393)
-- Dependencies: 228
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3524 (class 0 OID 135382)
-- Dependencies: 227
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3515 (class 0 OID 135269)
-- Dependencies: 218
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3516 (class 0 OID 135277)
-- Dependencies: 219
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3518 (class 0 OID 135300)
-- Dependencies: 221
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3517 (class 0 OID 135288)
-- Dependencies: 220
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3521 (class 0 OID 135337)
-- Dependencies: 224
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3522 (class 0 OID 135355)
-- Dependencies: 225
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3519 (class 0 OID 135316)
-- Dependencies: 222
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3520 (class 0 OID 135326)
-- Dependencies: 223
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3302 (class 2606 OID 135267)
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment_address
ADD
    CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);

--
-- TOC entry 3346 (class 2606 OID 135377)
-- Name: fulfillment fulfillment_delivery_address_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment
ADD
    CONSTRAINT fulfillment_delivery_address_id_unique UNIQUE (delivery_address_id);

--
-- TOC entry 3358 (class 2606 OID 135401)
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment_item
ADD
    CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);

--
-- TOC entry 3352 (class 2606 OID 135390)
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment_label
ADD
    CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);

--
-- TOC entry 3348 (class 2606 OID 135375)
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment
ADD
    CONSTRAINT fulfillment_pkey PRIMARY KEY (id);

--
-- TOC entry 3304 (class 2606 OID 135276)
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment_provider
ADD
    CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);

--
-- TOC entry 3308 (class 2606 OID 135285)
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment_set
ADD
    CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);

--
-- TOC entry 3320 (class 2606 OID 135310)
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY geo_zone
ADD
    CONSTRAINT geo_zone_pkey PRIMARY KEY (id);

--
-- TOC entry 3313 (class 2606 OID 135296)
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY service_zone
ADD
    CONSTRAINT service_zone_pkey PRIMARY KEY (id);

--
-- TOC entry 3334 (class 2606 OID 135347)
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_option
ADD
    CONSTRAINT shipping_option_pkey PRIMARY KEY (id);

--
-- TOC entry 3340 (class 2606 OID 135364)
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_option_rule
ADD
    CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);

--
-- TOC entry 3336 (class 2606 OID 135349)
-- Name: shipping_option shipping_option_shipping_option_type_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_option
ADD
    CONSTRAINT shipping_option_shipping_option_type_id_unique UNIQUE (shipping_option_type_id);

--
-- TOC entry 3323 (class 2606 OID 135324)
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_option_type
ADD
    CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);

--
-- TOC entry 3327 (class 2606 OID 135334)
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_profile
ADD
    CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);

--
-- TOC entry 3300 (class 1259 OID 135268)
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_address_deleted_at" ON fulfillment_address USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3341 (class 1259 OID 135381)
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_deleted_at" ON fulfillment USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3353 (class 1259 OID 135405)
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_item_deleted_at" ON fulfillment_item USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3354 (class 1259 OID 135404)
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON fulfillment_item USING btree (fulfillment_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3355 (class 1259 OID 135403)
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON fulfillment_item USING btree (inventory_item_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3356 (class 1259 OID 135402)
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_item_line_item_id" ON fulfillment_item USING btree (line_item_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3349 (class 1259 OID 135392)
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_label_deleted_at" ON fulfillment_label USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3350 (class 1259 OID 135391)
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON fulfillment_label USING btree (fulfillment_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3342 (class 1259 OID 135378)
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_location_id" ON fulfillment USING btree (location_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3343 (class 1259 OID 135379)
-- Name: IDX_fulfillment_provider_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_provider_id" ON fulfillment USING btree (provider_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3305 (class 1259 OID 135287)
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_set_deleted_at" ON fulfillment_set USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3306 (class 1259 OID 135286)
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON fulfillment_set USING btree (name)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3344 (class 1259 OID 135380)
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_fulfillment_shipping_option_id" ON fulfillment USING btree (shipping_option_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3314 (class 1259 OID 135313)
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_geo_zone_city" ON geo_zone USING btree (city)
WHERE
    (
        (deleted_at IS NULL)
        AND (city IS NOT NULL)
    );

--
-- TOC entry 3315 (class 1259 OID 135311)
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_geo_zone_country_code" ON geo_zone USING btree (country_code)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3316 (class 1259 OID 135315)
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_geo_zone_deleted_at" ON geo_zone USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3317 (class 1259 OID 135312)
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_geo_zone_province_code" ON geo_zone USING btree (province_code)
WHERE
    (
        (deleted_at IS NULL)
        AND (province_code IS NOT NULL)
    );

--
-- TOC entry 3318 (class 1259 OID 135314)
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_geo_zone_service_zone_id" ON geo_zone USING btree (service_zone_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3309 (class 1259 OID 135299)
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_service_zone_deleted_at" ON service_zone USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3310 (class 1259 OID 135298)
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON service_zone USING btree (fulfillment_set_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3311 (class 1259 OID 135297)
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON service_zone USING btree (name)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3328 (class 1259 OID 135354)
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_option_deleted_at" ON shipping_option USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3329 (class 1259 OID 135352)
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_option_provider_id" ON shipping_option USING btree (provider_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3337 (class 1259 OID 135366)
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON shipping_option_rule USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3338 (class 1259 OID 135365)
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON shipping_option_rule USING btree (shipping_option_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3330 (class 1259 OID 135350)
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_option_service_zone_id" ON shipping_option USING btree (service_zone_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3331 (class 1259 OID 135353)
-- Name: IDX_shipping_option_shipping_option_type_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_option_shipping_option_type_id" ON shipping_option USING btree (shipping_option_type_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3332 (class 1259 OID 135351)
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON shipping_option USING btree (shipping_profile_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3321 (class 1259 OID 135325)
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_option_type_deleted_at" ON shipping_option_type USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3324 (class 1259 OID 135336)
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_profile_deleted_at" ON shipping_profile USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3325 (class 1259 OID 135335)
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON shipping_profile USING btree (name)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3366 (class 2606 OID 135451)
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment
ADD
    CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES fulfillment_address(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3370 (class 2606 OID 135461)
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment_item
ADD
    CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3369 (class 2606 OID 135456)
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment_label
ADD
    CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3367 (class 2606 OID 135441)
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment
ADD
    CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES fulfillment_provider(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3368 (class 2606 OID 135446)
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY fulfillment
ADD
    CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES shipping_option(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3360 (class 2606 OID 135411)
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY geo_zone
ADD
    CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3359 (class 2606 OID 135406)
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY service_zone
ADD
    CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3361 (class 2606 OID 135426)
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_option
ADD
    CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES fulfillment_provider(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3365 (class 2606 OID 135436)
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_option_rule
ADD
    CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3362 (class 2606 OID 135416)
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_option
ADD
    CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3363 (class 2606 OID 135431)
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_option
ADD
    CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES shipping_option_type(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3364 (class 2606 OID 135421)
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY shipping_option
ADD
    CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES shipping_profile(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;