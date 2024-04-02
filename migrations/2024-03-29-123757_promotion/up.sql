-- Your SQL goes here
--
-- TOC entry 224 (class 1259 OID 136437)
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);

--
-- TOC entry 223 (class 1259 OID 136430)
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);

--
-- TOC entry 219 (class 1259 OID 136379)
-- Name: promotion; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_type_check CHECK (
        (
            type = ANY (ARRAY ['standard'::text, 'buyget'::text])
        )
    )
);

--
-- TOC entry 220 (class 1259 OID 136394)
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity numeric,
    apply_to_quantity numeric,
    buy_rules_min_quantity numeric,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_application_method_allocation_check CHECK (
        (
            allocation = ANY (ARRAY ['each'::text, 'across'::text])
        )
    ),
    CONSTRAINT promotion_application_method_target_type_check CHECK (
        (
            target_type = ANY (
                ARRAY ['order'::text, 'shipping_methods'::text, 'items'::text]
            )
        )
    ),
    CONSTRAINT promotion_application_method_type_check CHECK (
        (
            type = ANY (ARRAY ['fixed'::text, 'percentage'::text])
        )
    )
);

--
-- TOC entry 217 (class 1259 OID 136355)
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    currency text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 218 (class 1259 OID 136366)
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric,
    raw_used jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_campaign_budget_type_check CHECK (
        (
            type = ANY (ARRAY ['spend'::text, 'usage'::text])
        )
    )
);

--
-- TOC entry 222 (class 1259 OID 136423)
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);

--
-- TOC entry 221 (class 1259 OID 136411)
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK (
        (
            operator = ANY (
                ARRAY ['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text]
            )
        )
    )
);

--
-- TOC entry 225 (class 1259 OID 136444)
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 3477 (class 0 OID 136437)
-- Dependencies: 224
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3476 (class 0 OID 136430)
-- Dependencies: 223
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3472 (class 0 OID 136379)
-- Dependencies: 219
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3473 (class 0 OID 136394)
-- Dependencies: 220
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3470 (class 0 OID 136355)
-- Dependencies: 217
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3471 (class 0 OID 136366)
-- Dependencies: 218
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3475 (class 0 OID 136423)
-- Dependencies: 222
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3474 (class 0 OID 136411)
-- Dependencies: 221
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3478 (class 0 OID 136444)
-- Dependencies: 225
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3283 (class 2606 OID 136365)
-- Name: promotion_campaign IDX_campaign_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_campaign
ADD
    CONSTRAINT "IDX_campaign_identifier_unique" UNIQUE (campaign_identifier);

--
-- TOC entry 3293 (class 2606 OID 136393)
-- Name: promotion IDX_promotion_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion
ADD
    CONSTRAINT "IDX_promotion_code_unique" UNIQUE (code);

--
-- TOC entry 3313 (class 2606 OID 136443)
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY application_method_buy_rules
ADD
    CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);

--
-- TOC entry 3311 (class 2606 OID 136436)
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY application_method_target_rules
ADD
    CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);

--
-- TOC entry 3301 (class 2606 OID 136405)
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_application_method
ADD
    CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);

--
-- TOC entry 3303 (class 2606 OID 136410)
-- Name: promotion_application_method promotion_application_method_promotion_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_application_method
ADD
    CONSTRAINT promotion_application_method_promotion_id_unique UNIQUE (promotion_id);

--
-- TOC entry 3288 (class 2606 OID 136378)
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_campaign_budget
ADD
    CONSTRAINT promotion_campaign_budget_campaign_id_unique UNIQUE (campaign_id);

--
-- TOC entry 3290 (class 2606 OID 136375)
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_campaign_budget
ADD
    CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);

--
-- TOC entry 3285 (class 2606 OID 136363)
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_campaign
ADD
    CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);

--
-- TOC entry 3296 (class 2606 OID 136389)
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion
ADD
    CONSTRAINT promotion_pkey PRIMARY KEY (id);

--
-- TOC entry 3309 (class 2606 OID 136429)
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_promotion_rule
ADD
    CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);

--
-- TOC entry 3307 (class 2606 OID 136420)
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_rule
ADD
    CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);

--
-- TOC entry 3316 (class 2606 OID 136452)
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_rule_value
ADD
    CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);

--
-- TOC entry 3297 (class 1259 OID 136408)
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_application_method_allocation" ON promotion_application_method USING btree (allocation);

--
-- TOC entry 3298 (class 1259 OID 136407)
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_application_method_target_type" ON promotion_application_method USING btree (target_type);

--
-- TOC entry 3299 (class 1259 OID 136406)
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_application_method_type" ON promotion_application_method USING btree (type);

--
-- TOC entry 3286 (class 1259 OID 136376)
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_campaign_budget_type" ON promotion_campaign_budget USING btree (type);

--
-- TOC entry 3291 (class 1259 OID 136390)
-- Name: IDX_promotion_code; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_promotion_code" ON promotion USING btree (code);

--
-- TOC entry 3304 (class 1259 OID 136421)
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_promotion_rule_attribute" ON promotion_rule USING btree (attribute);

--
-- TOC entry 3305 (class 1259 OID 136422)
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_promotion_rule_operator" ON promotion_rule USING btree (operator);

--
-- TOC entry 3314 (class 1259 OID 136453)
-- Name: IDX_promotion_rule_promotion_rule_value_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_promotion_rule_promotion_rule_value_id" ON promotion_rule_value USING btree (promotion_rule_id);

--
-- TOC entry 3294 (class 1259 OID 136391)
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_promotion_type" ON promotion USING btree (type);

--
-- TOC entry 3324 (class 2606 OID 136489)
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY application_method_buy_rules
ADD
    CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3325 (class 2606 OID 136494)
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY application_method_buy_rules
ADD
    CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3322 (class 2606 OID 136479)
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY application_method_target_rules
ADD
    CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3323 (class 2606 OID 136484)
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY application_method_target_rules
ADD
    CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3319 (class 2606 OID 136464)
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_application_method
ADD
    CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3317 (class 2606 OID 136454)
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_campaign_budget
ADD
    CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES promotion_campaign(id) ON UPDATE CASCADE;

--
-- TOC entry 3318 (class 2606 OID 136459)
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion
ADD
    CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES promotion_campaign(id) ON DELETE
SET
    NULL;

--
-- TOC entry 3320 (class 2606 OID 136469)
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_promotion_rule
ADD
    CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3321 (class 2606 OID 136474)
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_promotion_rule
ADD
    CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3326 (class 2606 OID 136499)
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY promotion_rule_value
ADD
    CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;