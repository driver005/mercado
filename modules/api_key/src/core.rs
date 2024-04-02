use common_utils::consts;
use masking::{PeekInterface, StrongSecret};
use router::routes::app::AppState;
use router_env::{instrument, tracing};

use crate::models::{self, ApiKey};

// Defining new types `PlaintextApiKey` and `HashedApiKey` in the hopes of reducing the possibility
// of plaintext API key being stored in the data store.
pub struct PlaintextApiKey(StrongSecret<String>);

#[derive(Debug, PartialEq, Eq)]
pub struct HashedApiKey(String);

impl PlaintextApiKey {
    const HASH_KEY_LEN: usize = 32;

    const PREFIX_LEN: usize = 12;

    pub fn new(length: usize) -> Self {
        let env = router_env::env::prefix_for_env();
        let key = common_utils::crypto::generate_cryptographically_secure_random_string(length);
        Self(format!("{env}_{key}").into())
    }

    pub fn new_key_id() -> String {
        let env = router_env::env::prefix_for_env();
        common_utils::generate_id(consts::ID_LENGTH, env)
    }

    pub fn prefix(&self) -> String {
        self.0.peek().chars().take(Self::PREFIX_LEN).collect()
    }

    pub fn peek(&self) -> &str {
        self.0.peek()
    }

    pub fn keyed_hash(&self, key: &[u8; Self::HASH_KEY_LEN]) -> HashedApiKey {
        /*
        Decisions regarding API key hashing algorithm chosen:

        - Since API key hash verification would be done for each request, there is a requirement
          for the hashing to be quick.
        - Password hashing algorithms would not be suitable for this purpose as they're designed to
          prevent brute force attacks, considering that the same password could be shared  across
          multiple sites by the user.
        - Moreover, password hash verification happens once per user session, so the delay involved
          is negligible, considering the security benefits it provides.
          While with API keys (assuming uniqueness of keys across the application), the delay
          involved in hashing (with the use of a password hashing algorithm) becomes significant,
          considering that it must be done per request.
        - Since we are the only ones generating API keys and are able to guarantee their uniqueness,
          a simple hash algorithm is sufficient for this purpose.

        Hash algorithms considered:
        - Password hashing algorithms: Argon2id and PBKDF2
        - Simple hashing algorithms: HMAC-SHA256, HMAC-SHA512, BLAKE3

        After benchmarking the simple hashing algorithms, we decided to go with the BLAKE3 keyed
        hashing algorithm, with a randomly generated key for the hash key.
        */

        HashedApiKey(
            blake3::keyed_hash(key, self.0.peek().as_bytes())
                .to_hex()
                .to_string(),
        )
    }
}

impl settings::ApiKeys {
    pub fn get_hash_key(
        &self,
    ) -> errors::RouterResult<&'static StrongSecret<[u8; PlaintextApiKey::HASH_KEY_LEN]>> {
        HASH_KEY.get_or_try_init(|| {
            <[u8; PlaintextApiKey::HASH_KEY_LEN]>::try_from(
                hex::decode(self.hash_key.peek())
                    .into_report()
                    .change_context(errors::ApiErrorResponse::InternalServerError)
                    .attach_printable("API key hash key has invalid hexadecimal data")?
                    .as_slice(),
            )
            .into_report()
            .change_context(errors::ApiErrorResponse::InternalServerError)
            .attach_printable("The API hashing key has incorrect length")
            .map(StrongSecret::new)
        })
    }
}

impl From<&str> for PlaintextApiKey {
    fn from(s: &str) -> Self {
        Self(s.to_owned().into())
    }
}

impl From<String> for PlaintextApiKey {
    fn from(s: String) -> Self {
        Self(s.into())
    }
}

impl From<HashedApiKey> for models::HashedApiKey {
    fn from(hashed_api_key: HashedApiKey) -> Self {
        hashed_api_key.0.into()
    }
}

impl From<models::HashedApiKey> for HashedApiKey {
    fn from(hashed_api_key: models::HashedApiKey) -> Self {
        Self(hashed_api_key.into_inner())
    }
}

// #[instrument(skip_all)]
// pub async fn create_api_key(
//     state: AppState,
//     api_key: api_models::api_keys::CreateApiKeyRequest,
// ) -> RouterResponse<ApiKey> {
//     let api_key_config = state.conf.api_keys.get_inner();
//     let store = state.store.as_ref();

//     let hash_key = api_key_config.get_hash_key()?;
//     let plaintext_api_key = PlaintextApiKey::new(consts::API_KEY_LENGTH);
//     let api_key = models::ApiKeyNew {
//         token: plaintext_api_key.keyed_hash(hash_key.peek()).into(),
//         salt: api_key.salt,
//         redacted: api_key.redacted,
//         title: api_key.title,
//         type_: api_key.type_,
//         last_used_at: None,
//         created_by: api_key.created_by,
//         created_at: api_key.created_at,
//         revoked_by: api_key.revoked_by,
//         revoked_at: api_key.revoked_at,
//     };
// }
