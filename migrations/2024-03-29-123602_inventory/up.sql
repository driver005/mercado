-- Your SQL goes here
--
-- TOC entry 217 (class 1259 OID 135710)
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);

--
-- TOC entry 218 (class 1259 OID 135722)
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity integer DEFAULT 0 NOT NULL,
    reserved_quantity integer DEFAULT 0 NOT NULL,
    incoming_quantity integer DEFAULT 0 NOT NULL,
    metadata jsonb
);

--
-- TOC entry 219 (class 1259 OID 135737)
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity integer NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL
);

--
-- TOC entry 3415 (class 0 OID 135710)
-- Dependencies: 217
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3416 (class 0 OID 135722)
-- Dependencies: 218
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3417 (class 0 OID 135737)
-- Dependencies: 219
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: -
--
--
-- TOC entry 3258 (class 2606 OID 135719)
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY inventory_item
ADD
    CONSTRAINT inventory_item_pkey PRIMARY KEY (id);

--
-- TOC entry 3263 (class 2606 OID 135733)
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY inventory_level
ADD
    CONSTRAINT inventory_level_pkey PRIMARY KEY (id);

--
-- TOC entry 3269 (class 2606 OID 135745)
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY reservation_item
ADD
    CONSTRAINT reservation_item_pkey PRIMARY KEY (id);

--
-- TOC entry 3255 (class 1259 OID 135720)
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_inventory_item_deleted_at" ON inventory_item USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3256 (class 1259 OID 135721)
-- Name: IDX_inventory_item_sku_unique; Type: INDEX; Schema: public; Owner: -
--
CREATE UNIQUE INDEX "IDX_inventory_item_sku_unique" ON inventory_item USING btree (sku);

--
-- TOC entry 3259 (class 1259 OID 135734)
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_inventory_level_deleted_at" ON inventory_level USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3260 (class 1259 OID 135735)
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_inventory_level_inventory_item_id" ON inventory_level USING btree (inventory_item_id);

--
-- TOC entry 3261 (class 1259 OID 135736)
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_inventory_level_location_id" ON inventory_level USING btree (location_id);

--
-- TOC entry 3264 (class 1259 OID 135746)
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_reservation_item_deleted_at" ON reservation_item USING btree (deleted_at)
WHERE
    (deleted_at IS NOT NULL);

--
-- TOC entry 3265 (class 1259 OID 135749)
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_reservation_item_inventory_item_id" ON reservation_item USING btree (inventory_item_id);

--
-- TOC entry 3266 (class 1259 OID 135747)
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_reservation_item_line_item_id" ON reservation_item USING btree (line_item_id);

--
-- TOC entry 3267 (class 1259 OID 135748)
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: -
--
CREATE INDEX "IDX_reservation_item_location_id" ON reservation_item USING btree (location_id);

--
-- TOC entry 3270 (class 2606 OID 135750)
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY inventory_level
ADD
    CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- TOC entry 3271 (class 2606 OID 135755)
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE
    ONLY reservation_item
ADD
    CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;