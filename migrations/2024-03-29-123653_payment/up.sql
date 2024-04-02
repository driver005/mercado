-- Your SQL goes here
--
-- TOC entry 224 (class 1259 OID 135832)
-- Name: capture; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);

--
-- TOC entry 222 (class 1259 OID 135814)
-- Name: payment; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    cart_id text,
    order_id text,
    customer_id text,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);

--
-- TOC entry 217 (class 1259 OID 135768)
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    region_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid' :: text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK (
        (
            status = ANY (
                ARRAY ['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text]
            )
        )
    )
);

--
-- TOC entry 220 (class 1259 OID 135796)
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);

--
-- TOC entry 218 (class 1259 OID 135779)
-- Name: payment_method_token; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE payment_method_token (
    id text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    name text NOT NULL,
    type_detail text,
    description_detail text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 219 (class 1259 OID 135788)
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);

--
-- TOC entry 221 (class 1259 OID 135803)
-- Name: payment_session; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending' :: text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK (
        (
            status = ANY (
                ARRAY ['authorized'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text]
            )
        )
    )
);

--
-- TOC entry 223 (class 1259 OID 135823)
-- Name: refund; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);

--
-- TOC entry 3460 (class 0 OID 135832)
-- Dependencies: 224
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3458 (class 0 OID 135814)
-- Dependencies: 222
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3453 (class 0 OID 135768)
-- Dependencies: 217
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3456 (class 0 OID 135796)
-- Dependencies: 220
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3454 (class 0 OID 135779)
-- Dependencies: 218
-- Data for Name: payment_method_token; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3455 (class 0 OID 135788)
-- Dependencies: 219
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3457 (class 0 OID 135803)
-- Dependencies: 221
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3459 (class 0 OID 135823)
-- Dependencies: 223
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3303 (class 2606 OID 135840)
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY capture
ADD
    CONSTRAINT capture_pkey PRIMARY KEY (id);

--
-- TOC entry 3287 (class 2606 OID 135802)
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment_collection_payment_providers
ADD
    CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);

--
-- TOC entry 3280 (class 2606 OID 135778)
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment_collection
ADD
    CONSTRAINT payment_collection_pkey PRIMARY KEY (id);

--
-- TOC entry 3283 (class 2606 OID 135787)
-- Name: payment_method_token payment_method_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment_method_token
ADD
    CONSTRAINT payment_method_token_pkey PRIMARY KEY (id);

--
-- TOC entry 3297 (class 2606 OID 135822)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment
ADD
    CONSTRAINT payment_pkey PRIMARY KEY (id);

--
-- TOC entry 3285 (class 2606 OID 135795)
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment_provider
ADD
    CONSTRAINT payment_provider_pkey PRIMARY KEY (id);

--
-- TOC entry 3290 (class 2606 OID 135813)
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment_session
ADD
    CONSTRAINT payment_session_pkey PRIMARY KEY (id);

--
-- TOC entry 3300 (class 2606 OID 135831)
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY refund
ADD
    CONSTRAINT refund_pkey PRIMARY KEY (id);

--
-- TOC entry 3291 (class 1259 OID 135850)
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_capture_deleted_at" ON payment USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3301 (class 1259 OID 135849)
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_capture_payment_id" ON capture USING btree (payment_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3277 (class 1259 OID 135846)
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_payment_collection_deleted_at" ON payment_collection USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3278 (class 1259 OID 135845)
-- Name: IDX_payment_collection_region_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_payment_collection_region_id" ON payment_collection USING btree (region_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3292 (class 1259 OID 135841)
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_payment_deleted_at" ON payment USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3281 (class 1259 OID 135843)
-- Name: IDX_payment_method_token_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_payment_method_token_deleted_at" ON payment_method_token USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3293 (class 1259 OID 135842)
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_payment_payment_collection_id" ON payment USING btree (payment_collection_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3294 (class 1259 OID 135844)
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_payment_provider_id" ON payment USING btree (provider_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3288 (class 1259 OID 135851)
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_payment_session_payment_collection_id" ON payment_session USING btree (payment_collection_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3295 (class 1259 OID 135848)
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_refund_deleted_at" ON payment USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3298 (class 1259 OID 135847)
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_refund_payment_id" ON refund USING btree (payment_id)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3309 (class 2606 OID 135872)
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY capture
ADD
    CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES payment(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3304 (class 2606 OID 135852)
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_coll_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment_collection_payment_providers
ADD
    CONSTRAINT payment_collection_payment_providers_payment_coll_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3305 (class 2606 OID 135857)
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_provider_id_foreig; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment_collection_payment_providers
ADD
    CONSTRAINT payment_collection_payment_providers_payment_provider_id_foreig FOREIGN KEY (payment_provider_id) REFERENCES payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3307 (class 2606 OID 135867)
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment
ADD
    CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3306 (class 2606 OID 135862)
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY payment_session
ADD
    CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3308 (class 2606 OID 135877)
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY refund
ADD
    CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES payment(id) ON UPDATE CASCADE ON DELETE CASCADE;