use common_utils::date_time;

use crate::api_key;

pub trait ForeignInto<T> {
    fn foreign_into(self) -> T;
}

pub trait ForeignTryInto<T> {
    type Error;

    fn foreign_try_into(self) -> Result<T, Self::Error>;
}

pub trait ForeignFrom<F> {
    fn foreign_from(from: F) -> Self;
}

pub trait ForeignTryFrom<F>: Sized {
    type Error;

    fn foreign_try_from(from: F) -> Result<Self, Self::Error>;
}

impl<F, T> ForeignInto<T> for F
where
    T: ForeignFrom<F>,
{
    fn foreign_into(self) -> T {
        T::foreign_from(self)
    }
}

impl<F, T> ForeignTryInto<T> for F
where
    T: ForeignTryFrom<F>,
{
    type Error = <T as ForeignTryFrom<F>>::Error;

    fn foreign_try_into(self) -> Result<T, Self::Error> {
        T::foreign_try_from(self)
    }
}

impl ForeignFrom<(diesel_models::api_key::ApiKey, api_key::PlaintextApiKey)>
    for api_models::api_keys::CreateApiKeyResponse
{
    fn foreign_from(item: (diesel_models::api_key::ApiKey, api_key::PlaintextApiKey)) -> Self {
        use masking::StrongSecret;

        let (api_key, plaintext_api_key) = item;
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

impl ForeignFrom<diesel_models::api_key::ApiKey> for api_models::api_keys::RetrieveApiKeyResponse {
    fn foreign_from(api_key: diesel_models::api_key::ApiKey) -> Self {
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

impl ForeignFrom<api_models::api_keys::UpdateApiKeyRequest>
    for diesel_models::api_key::ApiKeyUpdate
{
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
