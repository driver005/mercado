use common_utils::errors::CustomResult;
use error_stack::ResultExt;
use hyperswitch_interfaces::{
    encryption_interface::{EncryptionError, EncryptionManagementInterface},
    secrets_interface::{SecretManagementInterface, SecretsManagementError},
};
use masking::{ExposeInterface, Secret};

#[derive(Debug, Clone)]
pub struct NoEncryption;

impl NoEncryption {
    /// Encryption functionality
    pub fn encrypt(&self, data: impl AsRef<[u8]>) -> Vec<u8> {
        data.as_ref().into()
    }

    /// Decryption functionality
    pub fn decrypt(&self, data: impl AsRef<[u8]>) -> Vec<u8> {
        data.as_ref().into()
    }
}

#[async_trait::async_trait]
impl EncryptionManagementInterface for NoEncryption {
    async fn encrypt(&self, input: &[u8]) -> CustomResult<Vec<u8>, EncryptionError> {
        Ok(self.encrypt(input))
    }

    async fn decrypt(&self, input: &[u8]) -> CustomResult<Vec<u8>, EncryptionError> {
        Ok(self.decrypt(input))
    }
}

#[async_trait::async_trait]
impl SecretManagementInterface for NoEncryption {
    async fn get_secret(
        &self,
        input: Secret<String>,
    ) -> CustomResult<Secret<String>, SecretsManagementError> {
        String::from_utf8(self.decrypt(input.expose()))
            .map(Into::into)
            .change_context(SecretsManagementError::FetchSecretFailed)
            .attach_printable("Failed to convert decrypted value to UTF-8")
    }
}

/// Enum representing configuration options for secrets management.
#[derive(Debug, Clone, Default, serde::Deserialize)]
#[serde(tag = "secrets_manager")]
#[serde(rename_all = "snake_case")]
pub enum SecretsManagementConfig {
    #[default]
    NoEncryption,
}

impl SecretsManagementConfig {
    /// Verifies that the client configuration is usable
    pub fn validate(&self) -> Result<(), &'static str> {
        match self {
            _ => Ok(()),
        }
    }

    /// Retrieves the appropriate secret management client based on the configuration.
    pub async fn get_secret_management_client(
        &self,
    ) -> CustomResult<Box<dyn SecretManagementInterface>, SecretsManagementError> {
        match self {
            _ => Ok(Box::new(NoEncryption)),
        }
    }
}
