-- Your SQL goes here
--
-- TOC entry 217 (class 1259 OID 135021)
-- Name: cart; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 218 (class 1259 OID 135036)
-- Name: cart_address; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE cart_address (
    id text NOT NULL,
    customer_id text,
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
-- TOC entry 219 (class 1259 OID 135045)
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0) :: numeric))
);

--
-- TOC entry 220 (class 1259 OID 135071)
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0) :: numeric))
);

--
-- TOC entry 221 (class 1259 OID 135083)
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);

--
-- TOC entry 222 (class 1259 OID 135094)
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0) :: numeric))
);

--
-- TOC entry 223 (class 1259 OID 135107)
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);

--
-- TOC entry 224 (class 1259 OID 135118)
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);

--
-- TOC entry 3477 (class 0 OID 135021)
-- Dependencies: 217
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3478 (class 0 OID 135036)
-- Dependencies: 218
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3479 (class 0 OID 135045)
-- Dependencies: 219
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3480 (class 0 OID 135071)
-- Dependencies: 220
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3481 (class 0 OID 135083)
-- Dependencies: 221
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3482 (class 0 OID 135094)
-- Dependencies: 222
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3483 (class 0 OID 135107)
-- Dependencies: 223
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3484 (class 0 OID 135118)
-- Dependencies: 224
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3294 (class 2606 OID 135044)
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_address
ADD
    CONSTRAINT cart_address_pkey PRIMARY KEY (id);

--
-- TOC entry 3305 (class 2606 OID 135080)
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_line_item_adjustment
ADD
    CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);

--
-- TOC entry 3300 (class 2606 OID 135057)
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_line_item
ADD
    CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);

--
-- TOC entry 3310 (class 2606 OID 135091)
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_line_item_tax_line
ADD
    CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);

--
-- TOC entry 3291 (class 2606 OID 135029)
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart
ADD
    CONSTRAINT cart_pkey PRIMARY KEY (id);

--
-- TOC entry 3320 (class 2606 OID 135115)
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_shipping_method_adjustment
ADD
    CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);

--
-- TOC entry 3315 (class 2606 OID 135104)
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_shipping_method
ADD
    CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);

--
-- TOC entry 3325 (class 2606 OID 135126)
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_shipping_method_tax_line
ADD
    CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);

--
-- TOC entry 3301 (class 1259 OID 135081)
-- Name: IDX_adjustment_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_adjustment_item_id" ON cart_line_item_adjustment USING btree (item_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3316 (class 1259 OID 135116)
-- Name: IDX_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_adjustment_shipping_method_id" ON cart_shipping_method_adjustment USING btree (shipping_method_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3292 (class 1259 OID 135160)
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_address_deleted_at" ON cart_address USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3283 (class 1259 OID 135032)
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_billing_address_id" ON cart USING btree (billing_address_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (billing_address_id IS NOT NULL)
    );

--
-- TOC entry 3284 (class 1259 OID 135035)
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_currency_code" ON cart USING btree (currency_code);

--
-- TOC entry 3285 (class 1259 OID 135030)
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_customer_id" ON cart USING btree (customer_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (customer_id IS NOT NULL)
    );

--
-- TOC entry 3286 (class 1259 OID 135159)
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_deleted_at" ON cart USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3302 (class 1259 OID 135161)
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON cart_line_item_adjustment USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3295 (class 1259 OID 135166)
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_line_item_deleted_at" ON cart_line_item USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3306 (class 1259 OID 135163)
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON cart_line_item_tax_line USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3287 (class 1259 OID 135033)
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_region_id" ON cart USING btree (region_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (region_id IS NOT NULL)
    );

--
-- TOC entry 3288 (class 1259 OID 135034)
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_sales_channel_id" ON cart USING btree (sales_channel_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (sales_channel_id IS NOT NULL)
    );

--
-- TOC entry 3289 (class 1259 OID 135031)
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_shipping_address_id" ON cart USING btree (shipping_address_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (shipping_address_id IS NOT NULL)
    );

--
-- TOC entry 3317 (class 1259 OID 135162)
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON cart_shipping_method_adjustment USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3311 (class 1259 OID 135165)
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON cart_shipping_method USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3321 (class 1259 OID 135164)
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON cart_shipping_method_tax_line USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3303 (class 1259 OID 135082)
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON cart_line_item_adjustment USING btree (promotion_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (promotion_id IS NOT NULL)
    );

--
-- TOC entry 3296 (class 1259 OID 135068)
-- Name: IDX_line_item_cart_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_line_item_cart_id" ON cart_line_item USING btree (cart_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3297 (class 1259 OID 135069)
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_line_item_product_id" ON cart_line_item USING btree (product_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (product_id IS NOT NULL)
    );

--
-- TOC entry 3307 (class 1259 OID 135093)
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON cart_line_item_tax_line USING btree (tax_rate_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (tax_rate_id IS NOT NULL)
    );

--
-- TOC entry 3298 (class 1259 OID 135070)
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_line_item_variant_id" ON cart_line_item USING btree (variant_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (variant_id IS NOT NULL)
    );

--
-- TOC entry 3318 (class 1259 OID 135117)
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON cart_shipping_method_adjustment USING btree (promotion_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (promotion_id IS NOT NULL)
    );

--
-- TOC entry 3312 (class 1259 OID 135105)
-- Name: IDX_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_method_cart_id" ON cart_shipping_method USING btree (cart_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3313 (class 1259 OID 135106)
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_method_option_id" ON cart_shipping_method USING btree (shipping_option_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (shipping_option_id IS NOT NULL)
    );

--
-- TOC entry 3322 (class 1259 OID 135128)
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON cart_shipping_method_tax_line USING btree (tax_rate_id)
WHERE
    (
        (deleted_at IS NULL)
        AND (tax_rate_id IS NOT NULL)
    );

--
-- TOC entry 3308 (class 1259 OID 135092)
-- Name: IDX_tax_line_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_tax_line_item_id" ON cart_line_item_tax_line USING btree (item_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3323 (class 1259 OID 135127)
-- Name: IDX_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_tax_line_shipping_method_id" ON cart_shipping_method_tax_line USING btree (shipping_method_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3326 (class 2606 OID 135063)
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart
ADD
    CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES cart_address(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3329 (class 2606 OID 135134)
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_line_item_adjustment
ADD
    CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3328 (class 2606 OID 135129)
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_line_item
ADD
    CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES cart(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3330 (class 2606 OID 135139)
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_line_item_tax_line
ADD
    CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3327 (class 2606 OID 135058)
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart
ADD
    CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES cart_address(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3332 (class 2606 OID 135149)
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_shipping_method_adjustment
ADD
    CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3331 (class 2606 OID 135144)
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_shipping_method
ADD
    CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES cart(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3333 (class 2606 OID 135154)
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY cart_shipping_method_tax_line
ADD
    CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;