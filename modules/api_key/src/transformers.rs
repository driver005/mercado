use common_utils::date_time;
use data_models::transformers::ForeignFrom;

use crate::models;

impl ForeignFrom<(data_models::api_key::PlaintextApiKey, models::ApiKey)>
    for api_models::api_keys::CreateApiKeyResponse
{
    fn foreign_from(item: (data_models::api_key::PlaintextApiKey, models::ApiKey)) -> Self {
        use masking::StrongSecret;

        let (plaintext_api_key, api_key) = item;
        Self {
            id: api_key.id,
            token: StrongSecret::from(plaintext_api_key.peek().to_owned()),
            salt: api_key.salt,
            redacted: api_key.redacted.into(),
            title: api_key.title,
            type_: api_key.type_,
            last_used_at: api_key.last_used_at,
            created_by: api_key.created_by,
            created_at: api_key.created_at,
            revoked_by: api_key.revoked_by,
            revoked_at: api_key.revoked_at,
        }
    }
}

impl ForeignFrom<models::ApiKey> for api_models::api_keys::RetrieveApiKeyResponse {
    fn foreign_from(api_key: models::ApiKey) -> Self {
        Self {
            id: api_key.id,
            salt: api_key.salt,
            redacted: api_key.redacted.into(),
            title: api_key.title,
            type_: api_key.type_,
            last_used_at: api_key.last_used_at,
            created_by: api_key.created_by,
            created_at: api_key.created_at,
            revoked_by: api_key.revoked_by,
            revoked_at: api_key.revoked_at,
        }
    }
}

impl ForeignFrom<api_models::api_keys::UpdateApiKeyRequest> for models::ApiKeyUpdate {
    fn foreign_from(api_key: api_models::api_keys::UpdateApiKeyRequest) -> Self {
        Self::Update {
            title: Some(api_key.title),
            type_: None,
            last_used_at: Some(Some(date_time::now())),
            revoked_by: None,
            revoked_at: None,
        }
    }
}
