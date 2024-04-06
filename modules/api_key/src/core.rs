use common_utils::{consts, date_time};
use data_models::{
    api_key::{HashedApiKey, PlaintextApiKey},
    errors::RouterResponse,
};
use masking::{PeekInterface, StrongSecret};
use router::{configs::settings::ApplicationResponses, routes::app::AppState};
use router_env::{instrument, tracing};

use crate::models::{self, ApiKey};

#[instrument(skip_all)]
pub async fn create_api_key(
    state: AppState,
    api_key: api_models::api_keys::CreateApiKeyRequest,
) -> RouterResponse<ApiKey> {
    let api_key_config = state.conf.api_keys.get_inner();
    let store = state.store.as_ref();

    let hash_key = api_key_config.get_hash_key()?;
    let plaintext_api_key = PlaintextApiKey::new(consts::API_KEY_LENGTH);
    let api_key = models::ApiKeyNew {
        token: plaintext_api_key.keyed_hash(hash_key.peek()).into(),
        salt: plaintext_api_key.prefix(),
        redacted: plaintext_api_key.prefix(),
        title: api_key.title,
        type_: api_key.type_,
        last_used_at: None,
        created_by: api_key.created_by,
        created_at: date_time::now(),
        revoked_by: None,
        revoked_at: None,
    };

    Ok(ApplicationResponses::Json(
        (api_key, plaintext_api_key).foreign_into(),
    ))
}
