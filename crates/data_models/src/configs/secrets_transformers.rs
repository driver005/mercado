use common_utils::errors::CustomResult;
use hyperswitch_interfaces::secrets_interface::{
    secret_handler::SecretsHandler,
    secret_state::{RawSecret, SecretStateContainer, SecuredSecret},
    SecretManagementInterface, SecretsManagementError,
};

use super::settings::{self, Settings};

#[async_trait::async_trait]
impl SecretsHandler for settings::Database {
    async fn convert_to_raw_secret(
        value: SecretStateContainer<Self, SecuredSecret>,
        secret_management_client: &dyn SecretManagementInterface,
    ) -> CustomResult<SecretStateContainer<Self, RawSecret>, SecretsManagementError> {
        let db = value.get_inner();
        let db_password = secret_management_client
            .get_secret(db.password.clone())
            .await?;

        Ok(value.transition_state(|db| Self {
            password: db_password,
            ..db
        }))
    }
}

#[async_trait::async_trait]
impl SecretsHandler for settings::Jwekey {
    async fn convert_to_raw_secret(
        value: SecretStateContainer<Self, SecuredSecret>,
        secret_management_client: &dyn SecretManagementInterface,
    ) -> CustomResult<SecretStateContainer<Self, RawSecret>, SecretsManagementError> {
        let jwekey = value.get_inner();
        let (
            vault_encryption_key,
            rust_locker_encryption_key,
            vault_private_key,
            tunnel_private_key,
        ) = tokio::try_join!(
            secret_management_client.get_secret(jwekey.vault_encryption_key.clone()),
            secret_management_client.get_secret(jwekey.rust_locker_encryption_key.clone()),
            secret_management_client.get_secret(jwekey.vault_private_key.clone()),
            secret_management_client.get_secret(jwekey.tunnel_private_key.clone())
        )?;
        Ok(value.transition_state(|_| Self {
            vault_encryption_key,
            rust_locker_encryption_key,
            vault_private_key,
            tunnel_private_key,
        }))
    }
}

#[async_trait::async_trait]
impl SecretsHandler for settings::ApiKeys {
    async fn convert_to_raw_secret(
        value: SecretStateContainer<Self, SecuredSecret>,
        secret_management_client: &dyn SecretManagementInterface,
    ) -> CustomResult<SecretStateContainer<Self, RawSecret>, SecretsManagementError> {
        let api_keys = value.get_inner();

        let hash_key = secret_management_client
            .get_secret(api_keys.hash_key.clone())
            .await?;

        #[cfg(feature = "email")]
        let expiry_reminder_days = api_keys.expiry_reminder_days.clone();

        Ok(value.transition_state(|_| Self {
            hash_key,
            #[cfg(feature = "email")]
            expiry_reminder_days,
        }))
    }
}

#[async_trait::async_trait]
impl SecretsHandler for settings::Secrets {
    async fn convert_to_raw_secret(
        value: SecretStateContainer<Self, SecuredSecret>,
        secret_management_client: &dyn SecretManagementInterface,
    ) -> CustomResult<SecretStateContainer<Self, RawSecret>, SecretsManagementError> {
        let secrets = value.get_inner();
        let (jwt_secret, admin_api_key, recon_admin_api_key, master_enc_key) = tokio::try_join!(
            secret_management_client.get_secret(secrets.jwt_secret.clone()),
            secret_management_client.get_secret(secrets.admin_api_key.clone()),
            secret_management_client.get_secret(secrets.recon_admin_api_key.clone()),
            secret_management_client.get_secret(secrets.master_enc_key.clone())
        )?;

        Ok(value.transition_state(|_| Self {
            jwt_secret,
            admin_api_key,
            recon_admin_api_key,
            master_enc_key,
        }))
    }
}

/// # Panics
///
/// Will panic even if kms decryption fails for at least one field
pub async fn fetch_raw_secrets(
    conf: Settings<SecuredSecret>,
    secret_management_client: &dyn SecretManagementInterface,
) -> Settings<RawSecret> {
    #[allow(clippy::expect_used)]
    let master_database =
        settings::Database::convert_to_raw_secret(conf.master_database, secret_management_client)
            .await
            .expect("Failed to decrypt master database configuration");

    // #[cfg(feature = "olap")]
    // #[allow(clippy::expect_used)]
    // let analytics =
    //     analytics::AnalyticsConfig::convert_to_raw_secret(conf.analytics, secret_management_client)
    //         .await
    //         .expect("Failed to decrypt analytics configuration");

    #[cfg(feature = "olap")]
    #[allow(clippy::expect_used)]
    let replica_database =
        settings::Database::convert_to_raw_secret(conf.replica_database, secret_management_client)
            .await
            .expect("Failed to decrypt replica database configuration");

    #[allow(clippy::expect_used)]
    let secrets = settings::Secrets::convert_to_raw_secret(conf.secrets, secret_management_client)
        .await
        .expect("Failed to decrypt secrets");

    #[allow(clippy::expect_used)]
    let jwekey = settings::Jwekey::convert_to_raw_secret(conf.jwekey, secret_management_client)
        .await
        .expect("Failed to decrypt jwekey configs");

    #[allow(clippy::expect_used)]
    let api_keys =
        settings::ApiKeys::convert_to_raw_secret(conf.api_keys, secret_management_client)
            .await
            .expect("Failed to decrypt api_keys configs");

    Settings {
        server: conf.server,
        master_database,
        redis: conf.redis,
        log: conf.log,
        #[cfg(feature = "kv_store")]
        drainer: conf.drainer,
        encryption_management: conf.encryption_management,
        secrets_management: conf.secrets_management,
        proxy: conf.proxy,
        env: conf.env,
        #[cfg(feature = "olap")]
        replica_database,
        secrets,
        locker: conf.locker,
        eph_key: conf.eph_key,
        scheduler: conf.scheduler,
        jwekey,
        webhooks: conf.webhooks,
        api_keys,
        #[cfg(feature = "email")]
        email: conf.email,
        lock_settings: conf.lock_settings,
        // #[cfg(feature = "olap")]
        // analytics,
        // #[cfg(feature = "olap")]
        // opensearch: conf.opensearch,
        #[cfg(feature = "kv_store")]
        kv_config: conf.kv_config,
        #[cfg(feature = "frm")]
        frm: conf.frm,
        // #[cfg(feature = "olap")]
        // report_download_config: conf.report_download_config,
        events: conf.events,
        cors: conf.cors,
        unmasked_headers: conf.unmasked_headers,
    }
}
