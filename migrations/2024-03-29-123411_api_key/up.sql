-- Your SQL goes here
-- Create the enum type 'ApiKeyType'
CREATE TYPE "ApiKeyType" AS ENUM ('Publishable', 'Secret');

-- TOC entry 217 (class 1259 OID 134986)
-- Name: api_key; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type "ApiKeyType" NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone
);

--
-- TOC entry 3387 (class 0 OID 134986)
-- Dependencies: 217
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3243 (class 2606 OID 134993)
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY api_key
ADD
    CONSTRAINT api_key_pkey PRIMARY KEY (id);

--
-- TOC entry 3240 (class 1259 OID 134994)
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON api_key USING btree (token);

--
-- TOC entry 3241 (class 1259 OID 134995)
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_api_key_type" ON api_key USING btree (type);