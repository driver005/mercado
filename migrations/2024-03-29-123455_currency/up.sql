-- Your SQL goes here
CREATE TABLE currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    name text NOT NULL
);

--
-- TOC entry 3384 (class 0 OID 135176)
-- Dependencies: 217
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3240 (class 2606 OID 135182)
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY currency
ADD
    CONSTRAINT currency_pkey PRIMARY KEY (code);