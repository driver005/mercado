use common_utils::{consts, date_time};
use data_models::errors;
use data_models::errors::api_error::ApplicationResponse;
use data_models::transformers::ForeignInto;
use data_models::{api_key::PlaintextApiKey, errors::RouterResponse};
use diesel_models::api_key::{ApiKey, ApiKeyNew};
use error_stack::ResultExt;
use masking::PeekInterface;
use router_env::{instrument, tracing};

use crate::app::AppState;
use crate::routes::metrics;

#[instrument(skip_all)]
pub async fn create_api_key(
    state: AppState,
    api_key: api_models::api_keys::CreateApiKeyRequest,
    merchant_id: String,
) -> RouterResponse<api_models::api_keys::CreateApiKeyResponse> {
    let api_key_config = state.conf.api_keys.get_inner();
    let store = state.store.as_ref();

    let hash_key = api_key_config.get_hash_key()?;
    let plaintext_api_key = PlaintextApiKey::new(consts::API_KEY_LENGTH);
    let api_key = ApiKeyNew {
        token: plaintext_api_key.keyed_hash(hash_key.peek()).into(),
        salt: plaintext_api_key.prefix(),
        redacted: plaintext_api_key.prefix(),
        title: api_key.title,
        type_: api_key.type_,
        last_used_at: None,
        created_by: merchant_id.clone(),
        created_at: date_time::now(),
        revoked_by: None,
        revoked_at: None,
    };

    let api_key = store
        .insert_api_key(api_key)
        .await
        .change_context(errors::ApiErrorResponse::InternalServerError)
        .attach_printable("Failed to insert new API key")?;

    metrics::API_KEY_CREATED.add(
        1,
        &[metrics::request::add_attributes("merchant", merchant_id)],
    );

    Ok(ApplicationResponse::Json(
        (api_key, plaintext_api_key).foreign_into(),
    ))
}
