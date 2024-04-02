-- Your SQL goes here
--
-- TOC entry 217 (class 1259 OID 136642)
-- Name: invite; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 218 (class 1259 OID 136655)
-- Name: user; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE "user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);

--
-- TOC entry 3399 (class 0 OID 136642)
-- Dependencies: 217
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3400 (class 0 OID 136655)
-- Dependencies: 218
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3251 (class 2606 OID 136651)
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY invite
ADD
    CONSTRAINT invite_pkey PRIMARY KEY (id);

--
-- TOC entry 3255 (class 2606 OID 136663)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY "user"
ADD
    CONSTRAINT user_pkey PRIMARY KEY (id);

--
-- TOC entry 3247 (class 1259 OID 136654)
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_invite_deleted_at" ON invite USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3248 (class 1259 OID 136652)
-- Name: IDX_invite_email; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_invite_email" ON invite USING btree (email)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3249 (class 1259 OID 136653)
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_invite_token" ON invite USING btree (token)
WHERE
    (deleted_at IS NULL);

--
-- TOC entry 3252 (class 1259 OID 136665)
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_user_deleted_at" ON "user" USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3253 (class 1259 OID 136664)
-- Name: IDX_user_email; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_user_email" ON "user" USING btree (email)
WHERE
    (deleted_at IS NULL);