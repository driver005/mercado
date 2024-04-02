// @generated automatically by Diesel CLI.

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    api_key (id) {
        id -> Text,
        token -> Text,
        salt -> Text,
        redacted -> Text,
        title -> Text,
        #[sql_name = "type"]
        type_ -> ApiKeyType,
        last_used_at -> Nullable<Timestamptz>,
        created_by -> Text,
        created_at -> Timestamptz,
        revoked_by -> Nullable<Text>,
        revoked_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    application_method_buy_rules (application_method_id, promotion_rule_id) {
        application_method_id -> Text,
        promotion_rule_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    application_method_target_rules (application_method_id, promotion_rule_id) {
        application_method_id -> Text,
        promotion_rule_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    auth_user (id) {
        id -> Text,
        entity_id -> Text,
        provider -> Text,
        scope -> Text,
        user_metadata -> Nullable<Jsonb>,
        app_metadata -> Jsonb,
        provider_metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    capture (id) {
        id -> Text,
        amount -> Numeric,
        raw_amount -> Jsonb,
        payment_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        created_by -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    cart (id) {
        id -> Text,
        region_id -> Nullable<Text>,
        customer_id -> Nullable<Text>,
        sales_channel_id -> Nullable<Text>,
        email -> Nullable<Text>,
        currency_code -> Text,
        shipping_address_id -> Nullable<Text>,
        billing_address_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    cart_address (id) {
        id -> Text,
        customer_id -> Nullable<Text>,
        company -> Nullable<Text>,
        first_name -> Nullable<Text>,
        last_name -> Nullable<Text>,
        address_1 -> Nullable<Text>,
        address_2 -> Nullable<Text>,
        city -> Nullable<Text>,
        country_code -> Nullable<Text>,
        province -> Nullable<Text>,
        postal_code -> Nullable<Text>,
        phone -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    cart_line_item (id) {
        id -> Text,
        cart_id -> Text,
        title -> Text,
        subtitle -> Nullable<Text>,
        thumbnail -> Nullable<Text>,
        quantity -> Int4,
        variant_id -> Nullable<Text>,
        product_id -> Nullable<Text>,
        product_title -> Nullable<Text>,
        product_description -> Nullable<Text>,
        product_subtitle -> Nullable<Text>,
        product_type -> Nullable<Text>,
        product_collection -> Nullable<Text>,
        product_handle -> Nullable<Text>,
        variant_sku -> Nullable<Text>,
        variant_barcode -> Nullable<Text>,
        variant_title -> Nullable<Text>,
        variant_option_values -> Nullable<Jsonb>,
        requires_shipping -> Bool,
        is_discountable -> Bool,
        is_tax_inclusive -> Bool,
        compare_at_unit_price -> Nullable<Numeric>,
        raw_compare_at_unit_price -> Nullable<Jsonb>,
        unit_price -> Numeric,
        raw_unit_price -> Jsonb,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    cart_line_item_adjustment (id) {
        id -> Text,
        description -> Nullable<Text>,
        promotion_id -> Nullable<Text>,
        code -> Nullable<Text>,
        amount -> Numeric,
        raw_amount -> Jsonb,
        provider_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        item_id -> Nullable<Text>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    cart_line_item_tax_line (id) {
        id -> Text,
        description -> Nullable<Text>,
        tax_rate_id -> Nullable<Text>,
        code -> Text,
        rate -> Numeric,
        provider_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        item_id -> Nullable<Text>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    cart_shipping_method (id) {
        id -> Text,
        cart_id -> Text,
        name -> Text,
        description -> Nullable<Jsonb>,
        amount -> Numeric,
        raw_amount -> Jsonb,
        is_tax_inclusive -> Bool,
        shipping_option_id -> Nullable<Text>,
        data -> Nullable<Jsonb>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    cart_shipping_method_adjustment (id) {
        id -> Text,
        description -> Nullable<Text>,
        promotion_id -> Nullable<Text>,
        code -> Nullable<Text>,
        amount -> Numeric,
        raw_amount -> Jsonb,
        provider_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        shipping_method_id -> Nullable<Text>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    cart_shipping_method_tax_line (id) {
        id -> Text,
        description -> Nullable<Text>,
        tax_rate_id -> Nullable<Text>,
        code -> Text,
        rate -> Numeric,
        provider_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        shipping_method_id -> Nullable<Text>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    currency (code) {
        code -> Text,
        symbol -> Text,
        symbol_native -> Text,
        name -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    customer (id) {
        id -> Text,
        company_name -> Nullable<Text>,
        first_name -> Nullable<Text>,
        last_name -> Nullable<Text>,
        email -> Nullable<Text>,
        phone -> Nullable<Text>,
        has_account -> Bool,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        created_by -> Nullable<Text>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    customer_address (id) {
        id -> Text,
        customer_id -> Text,
        address_name -> Nullable<Text>,
        is_default_shipping -> Bool,
        is_default_billing -> Bool,
        company -> Nullable<Text>,
        first_name -> Nullable<Text>,
        last_name -> Nullable<Text>,
        address_1 -> Nullable<Text>,
        address_2 -> Nullable<Text>,
        city -> Nullable<Text>,
        country_code -> Nullable<Text>,
        province -> Nullable<Text>,
        postal_code -> Nullable<Text>,
        phone -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    customer_group (id) {
        id -> Text,
        name -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_by -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    customer_group_customer (id) {
        id -> Text,
        customer_id -> Text,
        customer_group_id -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        created_by -> Nullable<Text>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    fulfillment (id) {
        id -> Text,
        location_id -> Text,
        packed_at -> Nullable<Timestamptz>,
        shipped_at -> Nullable<Timestamptz>,
        delivered_at -> Nullable<Timestamptz>,
        canceled_at -> Nullable<Timestamptz>,
        data -> Nullable<Jsonb>,
        provider_id -> Nullable<Text>,
        shipping_option_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        delivery_address_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    fulfillment_address (id) {
        id -> Text,
        company -> Nullable<Text>,
        first_name -> Nullable<Text>,
        last_name -> Nullable<Text>,
        address_1 -> Nullable<Text>,
        address_2 -> Nullable<Text>,
        city -> Nullable<Text>,
        country_code -> Nullable<Text>,
        province -> Nullable<Text>,
        postal_code -> Nullable<Text>,
        phone -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    fulfillment_item (id) {
        id -> Text,
        title -> Text,
        sku -> Text,
        barcode -> Text,
        quantity -> Numeric,
        raw_quantity -> Jsonb,
        line_item_id -> Nullable<Text>,
        inventory_item_id -> Nullable<Text>,
        fulfillment_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    fulfillment_label (id) {
        id -> Text,
        tracking_number -> Text,
        tracking_url -> Text,
        label_url -> Text,
        fulfillment_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    fulfillment_provider (id) {
        id -> Text,
        is_enabled -> Bool,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    fulfillment_set (id) {
        id -> Text,
        name -> Text,
        #[sql_name = "type"]
        type_ -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    geo_zone (id) {
        id -> Text,
        #[sql_name = "type"]
        type_ -> Text,
        country_code -> Text,
        province_code -> Nullable<Text>,
        city -> Nullable<Text>,
        service_zone_id -> Text,
        postal_expression -> Nullable<Jsonb>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    image (id) {
        id -> Text,
        url -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    inventory_item (id) {
        id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        sku -> Nullable<Text>,
        origin_country -> Nullable<Text>,
        hs_code -> Nullable<Text>,
        mid_code -> Nullable<Text>,
        material -> Nullable<Text>,
        weight -> Nullable<Int4>,
        length -> Nullable<Int4>,
        height -> Nullable<Int4>,
        width -> Nullable<Int4>,
        requires_shipping -> Bool,
        description -> Nullable<Text>,
        title -> Nullable<Text>,
        thumbnail -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    inventory_level (id) {
        id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        inventory_item_id -> Text,
        location_id -> Text,
        stocked_quantity -> Int4,
        reserved_quantity -> Int4,
        incoming_quantity -> Int4,
        metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    invite (id) {
        id -> Text,
        email -> Text,
        accepted -> Bool,
        token -> Text,
        expires_at -> Timestamptz,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order (id) {
        id -> Text,
        region_id -> Nullable<Text>,
        customer_id -> Nullable<Text>,
        version -> Int4,
        sales_channel_id -> Nullable<Text>,
        status -> Text,
        email -> Nullable<Text>,
        currency_code -> Text,
        shipping_address_id -> Nullable<Text>,
        billing_address_id -> Nullable<Text>,
        no_notification -> Nullable<Bool>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        canceled_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_address (id) {
        id -> Text,
        customer_id -> Nullable<Text>,
        company -> Nullable<Text>,
        first_name -> Nullable<Text>,
        last_name -> Nullable<Text>,
        address_1 -> Nullable<Text>,
        address_2 -> Nullable<Text>,
        city -> Nullable<Text>,
        country_code -> Nullable<Text>,
        province -> Nullable<Text>,
        postal_code -> Nullable<Text>,
        phone -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_change (id) {
        id -> Text,
        order_id -> Text,
        version -> Int4,
        description -> Nullable<Text>,
        status -> Text,
        internal_note -> Nullable<Text>,
        created_by -> Text,
        requested_by -> Nullable<Text>,
        requested_at -> Nullable<Timestamptz>,
        confirmed_by -> Nullable<Text>,
        confirmed_at -> Nullable<Timestamptz>,
        declined_by -> Nullable<Text>,
        declined_reason -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        declined_at -> Nullable<Timestamptz>,
        canceled_by -> Nullable<Text>,
        canceled_at -> Nullable<Timestamptz>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_change_action (id) {
        id -> Text,
        order_id -> Nullable<Text>,
        version -> Nullable<Int4>,
        ordering -> Int8,
        order_change_id -> Nullable<Text>,
        reference -> Nullable<Text>,
        reference_id -> Nullable<Text>,
        action -> Text,
        details -> Nullable<Jsonb>,
        amount -> Nullable<Numeric>,
        raw_amount -> Nullable<Jsonb>,
        internal_note -> Nullable<Text>,
        applied -> Bool,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_item (id) {
        id -> Text,
        order_id -> Text,
        version -> Int4,
        item_id -> Text,
        quantity -> Numeric,
        raw_quantity -> Jsonb,
        fulfilled_quantity -> Numeric,
        raw_fulfilled_quantity -> Jsonb,
        shipped_quantity -> Numeric,
        raw_shipped_quantity -> Jsonb,
        return_requested_quantity -> Numeric,
        raw_return_requested_quantity -> Jsonb,
        return_received_quantity -> Numeric,
        raw_return_received_quantity -> Jsonb,
        return_dismissed_quantity -> Numeric,
        raw_return_dismissed_quantity -> Jsonb,
        written_off_quantity -> Numeric,
        raw_written_off_quantity -> Jsonb,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_line_item (id) {
        id -> Text,
        totals_id -> Nullable<Text>,
        title -> Text,
        subtitle -> Nullable<Text>,
        thumbnail -> Nullable<Text>,
        variant_id -> Nullable<Text>,
        product_id -> Nullable<Text>,
        product_title -> Nullable<Text>,
        product_description -> Nullable<Text>,
        product_subtitle -> Nullable<Text>,
        product_type -> Nullable<Text>,
        product_collection -> Nullable<Text>,
        product_handle -> Nullable<Text>,
        variant_sku -> Nullable<Text>,
        variant_barcode -> Nullable<Text>,
        variant_title -> Nullable<Text>,
        variant_option_values -> Nullable<Jsonb>,
        requires_shipping -> Bool,
        is_discountable -> Bool,
        is_tax_inclusive -> Bool,
        compare_at_unit_price -> Nullable<Numeric>,
        raw_compare_at_unit_price -> Nullable<Jsonb>,
        unit_price -> Numeric,
        raw_unit_price -> Jsonb,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_line_item_adjustment (id) {
        id -> Text,
        description -> Nullable<Text>,
        promotion_id -> Nullable<Text>,
        code -> Nullable<Text>,
        amount -> Numeric,
        raw_amount -> Jsonb,
        provider_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        item_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_line_item_tax_line (id) {
        id -> Text,
        description -> Nullable<Text>,
        tax_rate_id -> Nullable<Text>,
        code -> Text,
        rate -> Numeric,
        raw_rate -> Jsonb,
        provider_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        item_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_shipping_method (id) {
        id -> Text,
        order_id -> Text,
        version -> Int4,
        name -> Text,
        description -> Nullable<Jsonb>,
        amount -> Numeric,
        raw_amount -> Jsonb,
        is_tax_inclusive -> Bool,
        shipping_option_id -> Nullable<Text>,
        data -> Nullable<Jsonb>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_shipping_method_adjustment (id) {
        id -> Text,
        description -> Nullable<Text>,
        promotion_id -> Nullable<Text>,
        code -> Nullable<Text>,
        amount -> Numeric,
        raw_amount -> Jsonb,
        provider_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        shipping_method_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_shipping_method_tax_line (id) {
        id -> Text,
        description -> Nullable<Text>,
        tax_rate_id -> Nullable<Text>,
        code -> Text,
        rate -> Numeric,
        raw_rate -> Jsonb,
        provider_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        shipping_method_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_summary (id) {
        id -> Text,
        order_id -> Text,
        version -> Int4,
        totals -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    order_transaction (id) {
        id -> Text,
        order_id -> Text,
        amount -> Numeric,
        raw_amount -> Jsonb,
        currency_code -> Text,
        reference -> Nullable<Text>,
        reference_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    payment (id) {
        id -> Text,
        amount -> Numeric,
        raw_amount -> Jsonb,
        currency_code -> Text,
        provider_id -> Text,
        cart_id -> Nullable<Text>,
        order_id -> Nullable<Text>,
        customer_id -> Nullable<Text>,
        data -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        captured_at -> Nullable<Timestamptz>,
        canceled_at -> Nullable<Timestamptz>,
        payment_collection_id -> Text,
        payment_session_id -> Text,
        metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    payment_collection (id) {
        id -> Text,
        currency_code -> Text,
        amount -> Numeric,
        raw_amount -> Jsonb,
        region_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        completed_at -> Nullable<Timestamptz>,
        status -> Text,
        metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    payment_collection_payment_providers (payment_collection_id, payment_provider_id) {
        payment_collection_id -> Text,
        payment_provider_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    payment_method_token (id) {
        id -> Text,
        provider_id -> Text,
        data -> Nullable<Jsonb>,
        name -> Text,
        type_detail -> Nullable<Text>,
        description_detail -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    payment_provider (id) {
        id -> Text,
        is_enabled -> Bool,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    payment_session (id) {
        id -> Text,
        currency_code -> Text,
        amount -> Numeric,
        raw_amount -> Jsonb,
        provider_id -> Text,
        data -> Jsonb,
        context -> Nullable<Jsonb>,
        status -> Text,
        authorized_at -> Nullable<Timestamptz>,
        payment_collection_id -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    price (id) {
        id -> Text,
        title -> Nullable<Text>,
        price_set_id -> Text,
        currency_code -> Text,
        rules_count -> Int4,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        price_list_id -> Nullable<Text>,
        amount -> Numeric,
        min_quantity -> Nullable<Numeric>,
        max_quantity -> Nullable<Numeric>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    price_list (id) {
        id -> Text,
        status -> Text,
        starts_at -> Nullable<Timestamptz>,
        ends_at -> Nullable<Timestamptz>,
        rules_count -> Int4,
        title -> Text,
        description -> Text,
        #[sql_name = "type"]
        type_ -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    price_list_rule (id) {
        id -> Text,
        rule_type_id -> Text,
        price_list_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    price_list_rule_value (id) {
        id -> Text,
        value -> Text,
        price_list_rule_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    price_rule (id) {
        id -> Text,
        price_set_id -> Text,
        rule_type_id -> Text,
        value -> Text,
        priority -> Int4,
        price_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    price_set (id) {
        id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    price_set_rule_type (id) {
        id -> Text,
        price_set_id -> Text,
        rule_type_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    process_tracker (id) {
        #[max_length = 127]
        id -> Varchar,
        #[max_length = 255]
        name -> Nullable<Varchar>,
        tag -> Array<Nullable<Text>>,
        #[max_length = 255]
        runner -> Nullable<Varchar>,
        retry_count -> Int4,
        schedule_time -> Nullable<Timestamp>,
        #[max_length = 255]
        rule -> Varchar,
        tracking_data -> Json,
        #[max_length = 255]
        business_status -> Varchar,
        status -> ProcessTrackerStatus,
        event -> Array<Nullable<Text>>,
        created_at -> Timestamp,
        updated_at -> Timestamp,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product (id) {
        id -> Text,
        title -> Text,
        handle -> Text,
        subtitle -> Nullable<Text>,
        description -> Nullable<Text>,
        is_giftcard -> Bool,
        status -> Text,
        thumbnail -> Nullable<Text>,
        weight -> Nullable<Text>,
        length -> Nullable<Text>,
        height -> Nullable<Text>,
        width -> Nullable<Text>,
        origin_country -> Nullable<Text>,
        hs_code -> Nullable<Text>,
        mid_code -> Nullable<Text>,
        material -> Nullable<Text>,
        collection_id -> Nullable<Text>,
        type_id -> Nullable<Text>,
        discountable -> Bool,
        external_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_category (id) {
        id -> Text,
        name -> Text,
        description -> Text,
        handle -> Text,
        mpath -> Text,
        is_active -> Bool,
        is_internal -> Bool,
        rank -> Numeric,
        parent_category_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_category_product (product_id, product_category_id) {
        product_id -> Text,
        product_category_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_collection (id) {
        id -> Text,
        title -> Text,
        handle -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_images (product_id, image_id) {
        product_id -> Text,
        image_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_option (id) {
        id -> Text,
        title -> Text,
        product_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_option_value (id) {
        id -> Text,
        value -> Text,
        option_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_tag (id) {
        id -> Text,
        value -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_tags (product_id, product_tag_id) {
        product_id -> Text,
        product_tag_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_type (id) {
        id -> Text,
        value -> Text,
        metadata -> Nullable<Json>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_variant (id) {
        id -> Text,
        title -> Text,
        sku -> Nullable<Text>,
        barcode -> Nullable<Text>,
        ean -> Nullable<Text>,
        upc -> Nullable<Text>,
        inventory_quantity -> Numeric,
        allow_backorder -> Bool,
        manage_inventory -> Bool,
        hs_code -> Nullable<Text>,
        origin_country -> Nullable<Text>,
        mid_code -> Nullable<Text>,
        material -> Nullable<Text>,
        weight -> Nullable<Numeric>,
        length -> Nullable<Numeric>,
        height -> Nullable<Numeric>,
        width -> Nullable<Numeric>,
        metadata -> Nullable<Jsonb>,
        variant_rank -> Nullable<Numeric>,
        product_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    product_variant_option (id) {
        id -> Text,
        option_value_id -> Nullable<Text>,
        variant_id -> Nullable<Text>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    promotion (id) {
        id -> Text,
        code -> Text,
        campaign_id -> Nullable<Text>,
        is_automatic -> Bool,
        #[sql_name = "type"]
        type_ -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    promotion_application_method (id) {
        id -> Text,
        value -> Nullable<Numeric>,
        raw_value -> Nullable<Jsonb>,
        max_quantity -> Nullable<Numeric>,
        apply_to_quantity -> Nullable<Numeric>,
        buy_rules_min_quantity -> Nullable<Numeric>,
        #[sql_name = "type"]
        type_ -> Text,
        target_type -> Text,
        allocation -> Nullable<Text>,
        promotion_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    promotion_campaign (id) {
        id -> Text,
        name -> Text,
        description -> Nullable<Text>,
        currency -> Nullable<Text>,
        campaign_identifier -> Text,
        starts_at -> Nullable<Timestamptz>,
        ends_at -> Nullable<Timestamptz>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    promotion_campaign_budget (id) {
        id -> Text,
        #[sql_name = "type"]
        type_ -> Text,
        campaign_id -> Text,
        limit -> Nullable<Numeric>,
        raw_limit -> Nullable<Jsonb>,
        used -> Nullable<Numeric>,
        raw_used -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    promotion_promotion_rule (promotion_id, promotion_rule_id) {
        promotion_id -> Text,
        promotion_rule_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    promotion_rule (id) {
        id -> Text,
        description -> Nullable<Text>,
        attribute -> Text,
        operator -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    promotion_rule_value (id) {
        id -> Text,
        promotion_rule_id -> Text,
        value -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    refund (id) {
        id -> Text,
        amount -> Numeric,
        raw_amount -> Jsonb,
        payment_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        created_by -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    region (id) {
        id -> Text,
        name -> Text,
        currency_code -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        automatic_taxes -> Bool,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    region_country (iso_2) {
        iso_2 -> Text,
        iso_3 -> Text,
        num_code -> Int4,
        name -> Text,
        display_name -> Text,
        region_id -> Nullable<Text>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    reservation_item (id) {
        id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        line_item_id -> Nullable<Text>,
        location_id -> Text,
        quantity -> Int4,
        external_id -> Nullable<Text>,
        description -> Nullable<Text>,
        created_by -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        inventory_item_id -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    rule_type (id) {
        id -> Text,
        name -> Text,
        rule_attribute -> Text,
        default_priority -> Int4,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    sales_channel (id) {
        id -> Text,
        name -> Text,
        description -> Nullable<Text>,
        is_disabled -> Bool,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    service_zone (id) {
        id -> Text,
        name -> Text,
        metadata -> Nullable<Jsonb>,
        fulfillment_set_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    shipping_option (id) {
        id -> Text,
        name -> Text,
        price_type -> Text,
        service_zone_id -> Text,
        shipping_profile_id -> Nullable<Text>,
        provider_id -> Nullable<Text>,
        data -> Nullable<Jsonb>,
        metadata -> Nullable<Jsonb>,
        shipping_option_type_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    shipping_option_rule (id) {
        id -> Text,
        attribute -> Text,
        operator -> Text,
        value -> Nullable<Jsonb>,
        shipping_option_id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    shipping_option_type (id) {
        id -> Text,
        label -> Text,
        description -> Nullable<Text>,
        code -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    shipping_profile (id) {
        id -> Text,
        name -> Text,
        #[sql_name = "type"]
        type_ -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    stock_location (id) {
        id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        name -> Text,
        address_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    stock_location_address (id) {
        id -> Text,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
        address_1 -> Text,
        address_2 -> Nullable<Text>,
        company -> Nullable<Text>,
        city -> Nullable<Text>,
        country_code -> Text,
        phone -> Nullable<Text>,
        province -> Nullable<Text>,
        postal_code -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    store (id) {
        id -> Text,
        name -> Text,
        supported_currency_codes -> Array<Nullable<Text>>,
        default_currency_code -> Nullable<Text>,
        default_sales_channel_id -> Nullable<Text>,
        default_region_id -> Nullable<Text>,
        default_location_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    tax_provider (id) {
        id -> Text,
        is_enabled -> Bool,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    tax_rate (id) {
        id -> Text,
        rate -> Nullable<Float4>,
        code -> Nullable<Text>,
        name -> Text,
        is_default -> Bool,
        is_combinable -> Bool,
        tax_region_id -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        created_by -> Nullable<Text>,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    tax_rate_rule (id) {
        id -> Text,
        tax_rate_id -> Text,
        reference_id -> Text,
        reference -> Text,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        created_by -> Nullable<Text>,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    tax_region (id) {
        id -> Text,
        provider_id -> Nullable<Text>,
        country_code -> Text,
        province_code -> Nullable<Text>,
        parent_id -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        created_by -> Nullable<Text>,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use crate::enums::diesel_exports::*;

    user (id) {
        id -> Text,
        first_name -> Nullable<Text>,
        last_name -> Nullable<Text>,
        email -> Text,
        avatar_url -> Nullable<Text>,
        metadata -> Nullable<Jsonb>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::joinable!(application_method_buy_rules -> promotion_application_method (application_method_id));
diesel::joinable!(application_method_buy_rules -> promotion_rule (promotion_rule_id));
diesel::joinable!(application_method_target_rules -> promotion_application_method (application_method_id));
diesel::joinable!(application_method_target_rules -> promotion_rule (promotion_rule_id));
diesel::joinable!(capture -> payment (payment_id));
diesel::joinable!(cart_line_item -> cart (cart_id));
diesel::joinable!(cart_line_item_adjustment -> cart_line_item (item_id));
diesel::joinable!(cart_line_item_tax_line -> cart_line_item (item_id));
diesel::joinable!(cart_shipping_method -> cart (cart_id));
diesel::joinable!(cart_shipping_method_adjustment -> cart_shipping_method (shipping_method_id));
diesel::joinable!(cart_shipping_method_tax_line -> cart_shipping_method (shipping_method_id));
diesel::joinable!(customer_address -> customer (customer_id));
diesel::joinable!(customer_group_customer -> customer (customer_id));
diesel::joinable!(customer_group_customer -> customer_group (customer_group_id));
diesel::joinable!(fulfillment -> fulfillment_address (delivery_address_id));
diesel::joinable!(fulfillment -> fulfillment_provider (provider_id));
diesel::joinable!(fulfillment -> shipping_option (shipping_option_id));
diesel::joinable!(fulfillment_item -> fulfillment (fulfillment_id));
diesel::joinable!(fulfillment_label -> fulfillment (fulfillment_id));
diesel::joinable!(geo_zone -> service_zone (service_zone_id));
diesel::joinable!(inventory_level -> inventory_item (inventory_item_id));
diesel::joinable!(order_change -> order (order_id));
diesel::joinable!(order_change_action -> order_change (order_change_id));
diesel::joinable!(order_item -> order (order_id));
diesel::joinable!(order_line_item_adjustment -> order_line_item (item_id));
diesel::joinable!(order_line_item_tax_line -> order_line_item (item_id));
diesel::joinable!(order_shipping_method -> order (order_id));
diesel::joinable!(order_shipping_method_adjustment -> order_shipping_method (shipping_method_id));
diesel::joinable!(order_shipping_method_tax_line -> order_shipping_method (shipping_method_id));
diesel::joinable!(order_transaction -> order (order_id));
diesel::joinable!(payment -> payment_collection (payment_collection_id));
diesel::joinable!(payment_collection_payment_providers -> payment_collection (payment_collection_id));
diesel::joinable!(payment_collection_payment_providers -> payment_provider (payment_provider_id));
diesel::joinable!(payment_session -> payment_collection (payment_collection_id));
diesel::joinable!(price -> price_list (price_list_id));
diesel::joinable!(price -> price_set (price_set_id));
diesel::joinable!(price_list_rule -> price_list (price_list_id));
diesel::joinable!(price_list_rule -> rule_type (rule_type_id));
diesel::joinable!(price_list_rule_value -> price_list_rule (price_list_rule_id));
diesel::joinable!(price_rule -> price (price_id));
diesel::joinable!(price_rule -> price_set (price_set_id));
diesel::joinable!(price_rule -> rule_type (rule_type_id));
diesel::joinable!(price_set_rule_type -> price_set (price_set_id));
diesel::joinable!(price_set_rule_type -> rule_type (rule_type_id));
diesel::joinable!(product -> product_collection (collection_id));
diesel::joinable!(product -> product_type (type_id));
diesel::joinable!(product_category_product -> product (product_id));
diesel::joinable!(product_category_product -> product_category (product_category_id));
diesel::joinable!(product_images -> image (image_id));
diesel::joinable!(product_images -> product (product_id));
diesel::joinable!(product_option -> product (product_id));
diesel::joinable!(product_option_value -> product_option (option_id));
diesel::joinable!(product_tags -> product (product_id));
diesel::joinable!(product_tags -> product_tag (product_tag_id));
diesel::joinable!(product_variant -> product (product_id));
diesel::joinable!(product_variant_option -> product_option_value (option_value_id));
diesel::joinable!(product_variant_option -> product_variant (variant_id));
diesel::joinable!(promotion -> promotion_campaign (campaign_id));
diesel::joinable!(promotion_application_method -> promotion (promotion_id));
diesel::joinable!(promotion_campaign_budget -> promotion_campaign (campaign_id));
diesel::joinable!(promotion_promotion_rule -> promotion (promotion_id));
diesel::joinable!(promotion_promotion_rule -> promotion_rule (promotion_rule_id));
diesel::joinable!(promotion_rule_value -> promotion_rule (promotion_rule_id));
diesel::joinable!(refund -> payment (payment_id));
diesel::joinable!(region_country -> region (region_id));
diesel::joinable!(reservation_item -> inventory_item (inventory_item_id));
diesel::joinable!(service_zone -> fulfillment_set (fulfillment_set_id));
diesel::joinable!(shipping_option -> fulfillment_provider (provider_id));
diesel::joinable!(shipping_option -> service_zone (service_zone_id));
diesel::joinable!(shipping_option -> shipping_option_type (shipping_option_type_id));
diesel::joinable!(shipping_option -> shipping_profile (shipping_profile_id));
diesel::joinable!(shipping_option_rule -> shipping_option (shipping_option_id));
diesel::joinable!(stock_location -> stock_location_address (address_id));
diesel::joinable!(tax_rate -> tax_region (tax_region_id));
diesel::joinable!(tax_rate_rule -> tax_rate (tax_rate_id));
diesel::joinable!(tax_region -> tax_provider (provider_id));

diesel::allow_tables_to_appear_in_same_query!(
    api_key,
    application_method_buy_rules,
    application_method_target_rules,
    auth_user,
    capture,
    cart,
    cart_address,
    cart_line_item,
    cart_line_item_adjustment,
    cart_line_item_tax_line,
    cart_shipping_method,
    cart_shipping_method_adjustment,
    cart_shipping_method_tax_line,
    currency,
    customer,
    customer_address,
    customer_group,
    customer_group_customer,
    fulfillment,
    fulfillment_address,
    fulfillment_item,
    fulfillment_label,
    fulfillment_provider,
    fulfillment_set,
    geo_zone,
    image,
    inventory_item,
    inventory_level,
    invite,
    order,
    order_address,
    order_change,
    order_change_action,
    order_item,
    order_line_item,
    order_line_item_adjustment,
    order_line_item_tax_line,
    order_shipping_method,
    order_shipping_method_adjustment,
    order_shipping_method_tax_line,
    order_summary,
    order_transaction,
    payment,
    payment_collection,
    payment_collection_payment_providers,
    payment_method_token,
    payment_provider,
    payment_session,
    price,
    price_list,
    price_list_rule,
    price_list_rule_value,
    price_rule,
    price_set,
    price_set_rule_type,
    process_tracker,
    product,
    product_category,
    product_category_product,
    product_collection,
    product_images,
    product_option,
    product_option_value,
    product_tag,
    product_tags,
    product_type,
    product_variant,
    product_variant_option,
    promotion,
    promotion_application_method,
    promotion_campaign,
    promotion_campaign_budget,
    promotion_promotion_rule,
    promotion_rule,
    promotion_rule_value,
    refund,
    region,
    region_country,
    reservation_item,
    rule_type,
    sales_channel,
    service_zone,
    shipping_option,
    shipping_option_rule,
    shipping_option_type,
    shipping_profile,
    stock_location,
    stock_location_address,
    store,
    tax_provider,
    tax_rate,
    tax_rate_rule,
    tax_region,
    user,
);
