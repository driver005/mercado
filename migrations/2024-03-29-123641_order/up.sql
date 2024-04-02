-- Your SQL goes here
--
-- TOC entry 218 (class 1259 OID 135485)
-- Name: order; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE "order" (
    id text NOT NULL,
    region_id text,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status text DEFAULT 'pending' :: text NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    CONSTRAINT order_status_check CHECK (
        (
            status = ANY (
                ARRAY ['pending'::text, 'completed'::text, 'draft'::text, 'archived'::text, 'canceled'::text, 'requires_action'::text]
            )
        )
    )
);

--
-- TOC entry 217 (class 1259 OID 135475)
-- Name: order_address; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_address (
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
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--
-- TOC entry 220 (class 1259 OID 135514)
-- Name: order_change; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending' :: text NOT NULL,
    internal_note text,
    created_by text NOT NULL,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT order_change_status_check CHECK (
        (
            status = ANY (
                ARRAY ['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text]
            )
        )
    )
);

--
-- TOC entry 222 (class 1259 OID 135529)
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--
-- TOC entry 221 (class 1259 OID 135528)
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: -
--
CREATE SEQUENCE order_change_action_ordering_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 221
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--
ALTER SEQUENCE order_change_action_ordering_seq OWNED BY order_change_action.ordering;

--
-- TOC entry 223 (class 1259 OID 135543)
-- Name: order_item; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--
-- TOC entry 224 (class 1259 OID 135555)
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--
-- TOC entry 226 (class 1259 OID 135579)
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL
);

--
-- TOC entry 225 (class 1259 OID 135569)
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL
);

--
-- TOC entry 227 (class 1259 OID 135589)
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_shipping_method (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--
-- TOC entry 228 (class 1259 OID 135603)
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL
);

--
-- TOC entry 229 (class 1259 OID 135613)
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL
);

--
-- TOC entry 219 (class 1259 OID 135503)
-- Name: order_summary; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--
-- TOC entry 230 (class 1259 OID 135623)
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--
-- TOC entry 3288 (class 2604 OID 135532)
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_change_action
ALTER COLUMN
    ordering
SET
    DEFAULT nextval(
        'order_change_action_ordering_seq' :: regclass
    );

--
-- TOC entry 3527 (class 0 OID 135485)
-- Dependencies: 218
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3526 (class 0 OID 135475)
-- Dependencies: 217
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3529 (class 0 OID 135514)
-- Dependencies: 220
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3531 (class 0 OID 135529)
-- Dependencies: 222
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3532 (class 0 OID 135543)
-- Dependencies: 223
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3533 (class 0 OID 135555)
-- Dependencies: 224
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3535 (class 0 OID 135579)
-- Dependencies: 226
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3534 (class 0 OID 135569)
-- Dependencies: 225
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3536 (class 0 OID 135589)
-- Dependencies: 227
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3537 (class 0 OID 135603)
-- Dependencies: 228
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3538 (class 0 OID 135613)
-- Dependencies: 229
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3528 (class 0 OID 135503)
-- Dependencies: 219
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3539 (class 0 OID 135623)
-- Dependencies: 230
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 221
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--
SELECT
    pg_catalog.setval(
        'order_change_action_ordering_seq',
        1,
        false
    );

--
-- TOC entry 3317 (class 2606 OID 135483)
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_address
ADD
    CONSTRAINT order_address_pkey PRIMARY KEY (id);

--
-- TOC entry 3338 (class 2606 OID 135539)
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_change_action
ADD
    CONSTRAINT order_change_action_pkey PRIMARY KEY (id);

--
-- TOC entry 3333 (class 2606 OID 135524)
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_change
ADD
    CONSTRAINT order_change_pkey PRIMARY KEY (id);

--
-- TOC entry 3343 (class 2606 OID 135551)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_item
ADD
    CONSTRAINT order_item_pkey PRIMARY KEY (id);

--
-- TOC entry 3353 (class 2606 OID 135587)
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_line_item_adjustment
ADD
    CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);

--
-- TOC entry 3347 (class 2606 OID 135566)
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_line_item
ADD
    CONSTRAINT order_line_item_pkey PRIMARY KEY (id);

--
-- TOC entry 3350 (class 2606 OID 135577)
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_line_item_tax_line
ADD
    CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);

--
-- TOC entry 3325 (class 2606 OID 135496)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY "order"
ADD
    CONSTRAINT order_pkey PRIMARY KEY (id);

--
-- TOC entry 3361 (class 2606 OID 135611)
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_shipping_method_adjustment
ADD
    CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);

--
-- TOC entry 3358 (class 2606 OID 135599)
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_shipping_method
ADD
    CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);

--
-- TOC entry 3364 (class 2606 OID 135621)
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_shipping_method_tax_line
ADD
    CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);

--
-- TOC entry 3328 (class 2606 OID 135512)
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_summary
ADD
    CONSTRAINT order_summary_pkey PRIMARY KEY (id);

--
-- TOC entry 3369 (class 2606 OID 135631)
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_transaction
ADD
    CONSTRAINT order_transaction_pkey PRIMARY KEY (id);

--
-- TOC entry 3315 (class 1259 OID 135484)
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_address_customer_id" ON order_address USING btree (customer_id);

--
-- TOC entry 3318 (class 1259 OID 135501)
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_billing_address_id" ON "order" USING btree (billing_address_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3334 (class 1259 OID 135540)
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_change_action_order_change_id" ON order_change_action USING btree (order_change_id);

--
-- TOC entry 3335 (class 1259 OID 135541)
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_change_action_order_id" ON order_change_action USING btree (order_id);

--
-- TOC entry 3336 (class 1259 OID 135542)
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_change_action_ordering" ON order_change_action USING btree (ordering);

--
-- TOC entry 3329 (class 1259 OID 135525)
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_change_order_id" ON order_change USING btree (order_id);

--
-- TOC entry 3330 (class 1259 OID 135526)
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_change_order_id_version" ON order_change USING btree (order_id, version);

--
-- TOC entry 3331 (class 1259 OID 135527)
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_change_status" ON order_change USING btree (status);

--
-- TOC entry 3319 (class 1259 OID 135499)
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_currency_code" ON "order" USING btree (currency_code)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3320 (class 1259 OID 135498)
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_customer_id" ON "order" USING btree (customer_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3321 (class 1259 OID 135502)
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_deleted_at" ON "order" USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3339 (class 1259 OID 135554)
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_item_item_id" ON order_item USING btree (item_id);

--
-- TOC entry 3340 (class 1259 OID 135552)
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_item_order_id" ON order_item USING btree (order_id);

--
-- TOC entry 3341 (class 1259 OID 135553)
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_item_order_id_version" ON order_item USING btree (order_id, version);

--
-- TOC entry 3351 (class 1259 OID 135588)
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON order_line_item_adjustment USING btree (item_id);

--
-- TOC entry 3344 (class 1259 OID 135568)
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_line_item_product_id" ON order_line_item USING btree (product_id);

--
-- TOC entry 3348 (class 1259 OID 135578)
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON order_line_item_tax_line USING btree (item_id);

--
-- TOC entry 3345 (class 1259 OID 135567)
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_line_item_variant_id" ON order_line_item USING btree (variant_id);

--
-- TOC entry 3322 (class 1259 OID 135497)
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_region_id" ON "order" USING btree (region_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3323 (class 1259 OID 135500)
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_shipping_address_id" ON "order" USING btree (shipping_address_id)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3359 (class 1259 OID 135612)
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON order_shipping_method_adjustment USING btree (shipping_method_id);

--
-- TOC entry 3354 (class 1259 OID 135600)
-- Name: IDX_order_shipping_method_order_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_shipping_method_order_id" ON order_shipping_method USING btree (order_id);

--
-- TOC entry 3355 (class 1259 OID 135601)
-- Name: IDX_order_shipping_method_order_id_version; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_shipping_method_order_id_version" ON order_shipping_method USING btree (order_id, version);

--
-- TOC entry 3356 (class 1259 OID 135602)
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON order_shipping_method USING btree (shipping_option_id);

--
-- TOC entry 3362 (class 1259 OID 135622)
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON order_shipping_method_tax_line USING btree (shipping_method_id);

--
-- TOC entry 3326 (class 1259 OID 135513)
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_summary_order_id_version" ON order_summary USING btree (order_id, version);

--
-- TOC entry 3365 (class 1259 OID 135633)
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_transaction_currency_code" ON order_transaction USING btree (currency_code);

--
-- TOC entry 3366 (class 1259 OID 135632)
-- Name: IDX_order_transaction_order_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_transaction_order_id" ON order_transaction USING btree (order_id);

--
-- TOC entry 3367 (class 1259 OID 135634)
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_order_transaction_reference_id" ON order_transaction USING btree (reference_id);

--
-- TOC entry 3370 (class 2606 OID 135640)
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY "order"
ADD
    CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES order_address(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3373 (class 2606 OID 135650)
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_change_action
ADD
    CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3372 (class 2606 OID 135645)
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_change
ADD
    CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3374 (class 2606 OID 135660)
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_item
ADD
    CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3375 (class 2606 OID 135655)
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_item
ADD
    CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3378 (class 2606 OID 135675)
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_line_item_adjustment
ADD
    CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3377 (class 2606 OID 135670)
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_line_item_tax_line
ADD
    CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3376 (class 2606 OID 135665)
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_line_item
ADD
    CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3371 (class 2606 OID 135635)
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY "order"
ADD
    CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES order_address(id) ON UPDATE CASCADE ON DELETE
SET
    NULL;

--
-- TOC entry 3380 (class 2606 OID 135685)
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_shipping_method_adjustment
ADD
    CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3379 (class 2606 OID 135680)
-- Name: order_shipping_method order_shipping_method_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_shipping_method
ADD
    CONSTRAINT order_shipping_method_order_id_foreign FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3381 (class 2606 OID 135690)
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_shipping_method_tax_line
ADD
    CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3382 (class 2606 OID 135695)
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY order_transaction
ADD
    CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE CASCADE;