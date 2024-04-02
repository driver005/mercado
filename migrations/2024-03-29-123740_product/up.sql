-- Your SQL goes here
--
-- TOC entry 219 (class 1259 OID 136121)
-- Name: image; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 222 (class 1259 OID 136152)
-- Name: product; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK (
        (
            status = ANY (
                ARRAY ['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text]
            )
        )
    )
);

--
-- TOC entry 217 (class 1259 OID 136095)
-- Name: product_category; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT '' :: text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank numeric DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--
-- TOC entry 227 (class 1259 OID 136203)
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);

--
-- TOC entry 218 (class 1259 OID 136109)
-- Name: product_collection; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 226 (class 1259 OID 136196)
-- Name: product_images; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_images (
    product_id text NOT NULL,
    image_id text NOT NULL
);

--
-- TOC entry 223 (class 1259 OID 136168)
-- Name: product_option; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 224 (class 1259 OID 136178)
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 220 (class 1259 OID 136132)
-- Name: product_tag; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 225 (class 1259 OID 136189)
-- Name: product_tags; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);

--
-- TOC entry 221 (class 1259 OID 136142)
-- Name: product_type; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 228 (class 1259 OID 136210)
-- Name: product_variant; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    inventory_quantity numeric DEFAULT 100 NOT NULL,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight numeric,
    length numeric,
    height numeric,
    width numeric,
    metadata jsonb,
    variant_rank numeric DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 229 (class 1259 OID 136233)
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE product_variant_option (
    id text NOT NULL,
    option_value_id text,
    variant_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 3517 (class 0 OID 136121)
-- Dependencies: 219
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3520 (class 0 OID 136152)
-- Dependencies: 222
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3515 (class 0 OID 136095)
-- Dependencies: 217
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3525 (class 0 OID 136203)
-- Dependencies: 227
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3516 (class 0 OID 136109)
-- Dependencies: 218
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3524 (class 0 OID 136196)
-- Dependencies: 226
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3521 (class 0 OID 136168)
-- Dependencies: 223
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3522 (class 0 OID 136178)
-- Dependencies: 224
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3518 (class 0 OID 136132)
-- Dependencies: 220
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3523 (class 0 OID 136189)
-- Dependencies: 225
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3519 (class 0 OID 136142)
-- Dependencies: 221
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3526 (class 0 OID 136210)
-- Dependencies: 228
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3527 (class 0 OID 136233)
-- Dependencies: 229
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3311 (class 2606 OID 136120)
-- Name: product_collection IDX_product_collection_handle_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_collection
ADD
    CONSTRAINT "IDX_product_collection_handle_unique" UNIQUE (handle);

--
-- TOC entry 3326 (class 2606 OID 136167)
-- Name: product IDX_product_handle_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product
ADD
    CONSTRAINT "IDX_product_handle_unique" UNIQUE (handle);

--
-- TOC entry 3344 (class 2606 OID 136228)
-- Name: product_variant IDX_product_variant_barcode_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_variant
ADD
    CONSTRAINT "IDX_product_variant_barcode_unique" UNIQUE (barcode);

--
-- TOC entry 3347 (class 2606 OID 136230)
-- Name: product_variant IDX_product_variant_ean_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_variant
ADD
    CONSTRAINT "IDX_product_variant_ean_unique" UNIQUE (ean);

--
-- TOC entry 3350 (class 2606 OID 136226)
-- Name: product_variant IDX_product_variant_sku_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_variant
ADD
    CONSTRAINT "IDX_product_variant_sku_unique" UNIQUE (sku);

--
-- TOC entry 3352 (class 2606 OID 136232)
-- Name: product_variant IDX_product_variant_upc_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_variant
ADD
    CONSTRAINT "IDX_product_variant_upc_unique" UNIQUE (upc);

--
-- TOC entry 3317 (class 2606 OID 136129)
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY image
ADD
    CONSTRAINT image_pkey PRIMARY KEY (id);

--
-- TOC entry 3308 (class 2606 OID 136107)
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_category
ADD
    CONSTRAINT product_category_pkey PRIMARY KEY (id);

--
-- TOC entry 3342 (class 2606 OID 136209)
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_category_product
ADD
    CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);

--
-- TOC entry 3313 (class 2606 OID 136117)
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_collection
ADD
    CONSTRAINT product_collection_pkey PRIMARY KEY (id);

--
-- TOC entry 3340 (class 2606 OID 136202)
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_images
ADD
    CONSTRAINT product_images_pkey PRIMARY KEY (product_id, image_id);

--
-- TOC entry 3332 (class 2606 OID 136176)
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_option
ADD
    CONSTRAINT product_option_pkey PRIMARY KEY (id);

--
-- TOC entry 3336 (class 2606 OID 136186)
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_option_value
ADD
    CONSTRAINT product_option_value_pkey PRIMARY KEY (id);

--
-- TOC entry 3329 (class 2606 OID 136163)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product
ADD
    CONSTRAINT product_pkey PRIMARY KEY (id);

--
-- TOC entry 3320 (class 2606 OID 136140)
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_tag
ADD
    CONSTRAINT product_tag_pkey PRIMARY KEY (id);

--
-- TOC entry 3338 (class 2606 OID 136195)
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_tags
ADD
    CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);

--
-- TOC entry 3323 (class 2606 OID 136150)
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_type
ADD
    CONSTRAINT product_type_pkey PRIMARY KEY (id);

--
-- TOC entry 3357 (class 2606 OID 136241)
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_variant_option
ADD
    CONSTRAINT product_variant_option_pkey PRIMARY KEY (id);

--
-- TOC entry 3354 (class 2606 OID 136222)
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_variant
ADD
    CONSTRAINT product_variant_pkey PRIMARY KEY (id);

--
-- TOC entry 3306 (class 1259 OID 136108)
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_category_path" ON product_category USING btree (mpath);

--
-- TOC entry 3309 (class 1259 OID 136118)
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_collection_deleted_at" ON product_collection USING btree (deleted_at);

--
-- TOC entry 3324 (class 1259 OID 136165)
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_deleted_at" ON product USING btree (deleted_at);

--
-- TOC entry 3314 (class 1259 OID 136131)
-- Name: IDX_product_image_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_image_deleted_at" ON image USING btree (deleted_at);

--
-- TOC entry 3315 (class 1259 OID 136130)
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_image_url" ON image USING btree (url);

--
-- TOC entry 3330 (class 1259 OID 136177)
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_option_deleted_at" ON product_option USING btree (deleted_at);

--
-- TOC entry 3333 (class 1259 OID 136188)
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_option_value_deleted_at" ON product_option_value USING btree (deleted_at);

--
-- TOC entry 3334 (class 1259 OID 136187)
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_option_value_option_id" ON product_option_value USING btree (option_id);

--
-- TOC entry 3318 (class 1259 OID 136141)
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_tag_deleted_at" ON product_tag USING btree (deleted_at);

--
-- TOC entry 3321 (class 1259 OID 136151)
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_type_deleted_at" ON product_type USING btree (deleted_at);

--
-- TOC entry 3327 (class 1259 OID 136164)
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_type_id" ON product USING btree (type_id);

--
-- TOC entry 3345 (class 1259 OID 136224)
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_variant_deleted_at" ON product_variant USING btree (deleted_at);

--
-- TOC entry 3355 (class 1259 OID 136242)
-- Name: IDX_product_variant_option_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_variant_option_deleted_at" ON product_variant_option USING btree (deleted_at);

--
-- TOC entry 3348 (class 1259 OID 136223)
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_product_variant_product_id" ON product_variant USING btree (product_id);

--
-- TOC entry 3358 (class 2606 OID 136243)
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_category
ADD
    CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES product_category(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3367 (class 2606 OID 136293)
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_category_product
ADD
    CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3368 (class 2606 OID 136288)
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_category_product
ADD
    CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES product(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3359 (class 2606 OID 136248)
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product
ADD
    CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES product_collection(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3365 (class 2606 OID 136283)
-- Name: product_images product_images_image_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_images
ADD
    CONSTRAINT product_images_image_id_foreign FOREIGN KEY (image_id) REFERENCES image(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3366 (class 2606 OID 136278)
-- Name: product_images product_images_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_images
ADD
    CONSTRAINT product_images_product_id_foreign FOREIGN KEY (product_id) REFERENCES product(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3361 (class 2606 OID 136258)
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_option
ADD
    CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES product(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3362 (class 2606 OID 136263)
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_option_value
ADD
    CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3363 (class 2606 OID 136268)
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_tags
ADD
    CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES product(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3364 (class 2606 OID 136273)
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_tags
ADD
    CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3360 (class 2606 OID 136253)
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product
ADD
    CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES product_type(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3370 (class 2606 OID 136303)
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_variant_option
ADD
    CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES product_option_value(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3371 (class 2606 OID 136308)
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_variant_option
ADD
    CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES product_variant(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3369 (class 2606 OID 136298)
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY product_variant
ADD
    CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES product(id) ON UPDATE CASCADE ON DELETE CASCADE;