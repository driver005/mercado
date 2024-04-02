-- Your SQL goes here
--
-- TOC entry 217 (class 1259 OID 135004)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE auth_user (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    scope text NOT NULL,
    user_metadata jsonb,
    app_metadata jsonb NOT NULL,
    provider_metadata jsonb
);

--
-- TOC entry 3386 (class 0 OID 135004)
-- Dependencies: 217
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3240 (class 2606 OID 135012)
-- Name: auth_user IDX_auth_user_provider_scope_entity_id; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY auth_user
ADD
    CONSTRAINT "IDX_auth_user_provider_scope_entity_id" UNIQUE (provider, scope, entity_id);

--
-- TOC entry 3242 (class 2606 OID 135010)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY auth_user
ADD
    CONSTRAINT auth_user_pkey PRIMARY KEY (id);