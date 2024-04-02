use std::{
    collections::{HashMap, HashSet},
    path::PathBuf,
};

// #[cfg(feature = "olap")]
// use analytics::{OpensearchConfig, ReportConfig};
use common_utils::ext_traits::ConfigExt;
use config::{Environment, File};
#[cfg(feature = "email")]
use external_services::email::EmailSettings;

use external_services::managers::{
    encryption_management::EncryptionManagementConfig, secrets_management::SecretsManagementConfig,
};
use hyperswitch_interfaces::secrets_interface::secret_state::{
    SecretState, SecretStateContainer, SecuredSecret,
};
use masking::{Maskable, Secret};
use redis_interface::RedisSettings;
pub use router_env::config::{Log, LogConsole, LogFile, LogTelemetry};
use rust_decimal::Decimal;
use scheduler::{errors::ApplicationError, SchedulerSettings};
use serde::Deserialize;
use storage_impl::config::QueueStrategy;

// #[cfg(feature = "olap")]
// use crate::analytics::AnalyticsConfig;
use crate::{
    // core::errors::{ApplicationError, ApplicationResult},
    env::{self, logger, Env},
    events::EventsConfig,
};

#[derive(Debug, Eq, PartialEq)]
pub enum ApplicationResponses<R> {
    Json(R),
    StatusOk,
    TextPlain(String),
    FileData((Vec<u8>, mime::Mime)),
    JsonWithHeaders((R, Vec<(String, Maskable<String>)>)),
}

pub type ApplicationResult<T> = Result<T, ApplicationError>;
pub type ApplicationResponse<T> = ApplicationResult<ApplicationResponses<T>>;

#[derive(clap::Parser, Default)]
#[cfg_attr(feature = "vergen", command(version = router_env::version!()))]
pub struct CmdLineConf {
    /// Config file.
    /// Application will look for "config/config.toml" if this option isn't specified.
    #[arg(short = 'f', long, value_name = "FILE")]
    pub config_path: Option<PathBuf>,

    #[command(subcommand)]
    pub subcommand: Option<Subcommand>,
}

#[derive(clap::Parser)]
pub enum Subcommand {
    #[cfg(feature = "openapi")]
    /// Generate the OpenAPI specification file from code.
    GenerateOpenapiSpec,
}

#[derive(Debug, Deserialize, Clone, Default)]
#[serde(default)]
pub struct Settings<S: SecretState> {
    pub server: Server,
    pub proxy: Proxy,
    pub env: Env,
    pub master_database: SecretStateContainer<Database, S>,
    #[cfg(feature = "olap")]
    pub replica_database: SecretStateContainer<Database, S>,
    pub redis: RedisSettings,
    pub log: Log,
    pub secrets: SecretStateContainer<Secrets, S>,
    pub locker: Locker,
    pub eph_key: EphemeralConfig,
    pub scheduler: Option<SchedulerSettings>,
    #[cfg(feature = "kv_store")]
    pub drainer: DrainerSettings,
    pub jwekey: SecretStateContainer<Jwekey, S>,
    pub webhooks: WebhooksSettings,
    pub api_keys: SecretStateContainer<ApiKeys, S>,
    // pub file_storage: FileStorageConfig,
    pub encryption_management: EncryptionManagementConfig,
    pub secrets_management: SecretsManagementConfig,

    #[cfg(feature = "dummy_connector")]
    pub dummy_connector: DummyConnector,
    #[cfg(feature = "email")]
    pub email: EmailSettings,
    pub cors: CorsSettings,
    #[cfg(feature = "payouts")]
    pub payouts: Payouts,
    pub lock_settings: LockSettings,
    // #[cfg(feature = "olap")]
    // pub analytics: SecretStateContainer<AnalyticsConfig, S>,
    #[cfg(feature = "kv_store")]
    pub kv_config: KvConfig,
    #[cfg(feature = "frm")]
    pub frm: Frm,
    // #[cfg(feature = "olap")]
    // pub report_download_config: ReportConfig,
    // #[cfg(feature = "olap")]
    // pub opensearch: OpensearchConfig,
    pub events: EventsConfig,
    pub unmasked_headers: UnmaskedHeaders,
}

#[derive(Debug, Deserialize, Clone, Default)]
pub struct UnmaskedHeaders {
    #[serde(deserialize_with = "deserialize_hashset")]
    pub keys: HashSet<String>,
}

#[cfg(feature = "frm")]
#[derive(Debug, Deserialize, Clone, Default)]
pub struct Frm {
    pub enabled: bool,
}

#[derive(Debug, Deserialize, Clone)]
pub struct KvConfig {
    pub ttl: u32,
}

#[derive(Debug, Deserialize, Clone, Default)]
pub struct DefaultExchangeRates {
    pub base_currency: String,
    pub conversion: HashMap<String, Conversion>,
    pub timestamp: i64,
}

#[derive(Debug, Deserialize, Clone, Default)]
pub struct Conversion {
    #[serde(with = "rust_decimal::serde::str")]
    pub to_factor: Decimal,
    #[serde(with = "rust_decimal::serde::str")]
    pub from_factor: Decimal,
}

#[derive(Debug, Deserialize, Clone)]
pub struct CorsSettings {
    #[serde(default, deserialize_with = "deserialize_hashset")]
    pub origins: HashSet<String>,
    #[serde(default)]
    pub wildcard_origin: bool,
    pub max_age: usize,
    #[serde(deserialize_with = "deserialize_hashset")]
    pub allowed_methods: HashSet<String>,
}

#[derive(Debug, Default, Deserialize, Clone)]
#[serde(default)]
pub struct Secrets {
    pub jwt_secret: Secret<String>,
    pub admin_api_key: Secret<String>,
    pub recon_admin_api_key: Secret<String>,
    pub master_enc_key: Secret<String>,
}

#[derive(Debug, Deserialize, Clone)]
#[serde(default)]
pub struct Locker {
    pub host: String,
    pub host_rs: String,
    pub mock_locker: bool,
    pub basilisk_host: String,
    pub locker_signing_key_id: String,
    pub locker_enabled: bool,
}

#[derive(Debug, Deserialize, Clone)]
#[serde(default)]
pub struct EphemeralConfig {
    pub validity: i64,
}

#[derive(Debug, Deserialize, Clone, Default)]
#[serde(default)]
pub struct Jwekey {
    pub vault_encryption_key: Secret<String>,
    pub rust_locker_encryption_key: Secret<String>,
    pub vault_private_key: Secret<String>,
    pub tunnel_private_key: Secret<String>,
}

#[derive(Debug, Deserialize, Clone)]
#[serde(default)]
pub struct Proxy {
    pub http_url: Option<String>,
    pub https_url: Option<String>,
    pub idle_pool_connection_timeout: Option<u64>,
}

#[derive(Debug, Deserialize, Clone)]
#[serde(default)]
pub struct Server {
    pub port: u16,
    pub workers: usize,
    pub host: String,
    pub request_body_limit: usize,
    pub base_url: String,
    pub shutdown_timeout: u64,
}

#[derive(Debug, Deserialize, Clone)]
#[serde(default)]
pub struct Database {
    pub username: String,
    pub password: Secret<String>,
    pub host: String,
    pub port: u16,
    pub dbname: String,
    pub pool_size: u32,
    pub connection_timeout: u64,
    pub queue_strategy: QueueStrategy,
    pub min_idle: Option<u32>,
    pub max_lifetime: Option<u64>,
}

impl From<Database> for storage_impl::config::Database {
    fn from(val: Database) -> Self {
        Self {
            username: val.username,
            password: val.password,
            host: val.host,
            port: val.port,
            dbname: val.dbname,
            pool_size: val.pool_size,
            connection_timeout: val.connection_timeout,
            queue_strategy: val.queue_strategy,
            min_idle: val.min_idle,
            max_lifetime: val.max_lifetime,
        }
    }
}

#[cfg(feature = "kv_store")]
#[derive(Debug, Clone, Deserialize)]
#[serde(default)]
pub struct DrainerSettings {
    pub stream_name: String,
    pub num_partitions: u8,
    pub max_read_count: u64,
    pub shutdown_interval: u32, // in milliseconds
    pub loop_interval: u32,     // in milliseconds
}

#[derive(Debug, Clone, Default, Deserialize)]
#[serde(default)]
pub struct WebhooksSettings {
    pub outgoing_enabled: bool,
    pub ignore_error: WebhookIgnoreErrorSettings,
}

#[derive(Debug, Clone, Deserialize, Default)]
#[serde(default)]
pub struct WebhookIgnoreErrorSettings {
    pub event_type: Option<bool>,
    pub payment_not_found: Option<bool>,
}

#[derive(Debug, Deserialize, Clone)]
#[serde(default)]
pub struct ApiKeys {
    /// Hex-encoded 32-byte long (64 characters long when hex-encoded) key used for calculating
    /// hashes of API keys
    pub hash_key: Secret<String>,

    // Specifies the number of days before API key expiry when email reminders should be sent
    #[cfg(feature = "email")]
    pub expiry_reminder_days: Vec<u8>,
}

impl Settings<SecuredSecret> {
    pub fn new() -> ApplicationResult<Self> {
        Self::with_config_path(None)
    }

    pub fn with_config_path(config_path: Option<PathBuf>) -> ApplicationResult<Self> {
        // Configuration values are picked up in the following priority order (1 being least
        // priority):
        // 1. Defaults from the implementation of the `Default` trait.
        // 2. Values from config file. The config file accessed depends on the environment
        //    specified by the `RUN_ENV` environment variable. `RUN_ENV` can be one of
        //    `development`, `sandbox` or `production`. If nothing is specified for `RUN_ENV`,
        //    `/config/development.toml` file is read.
        // 3. Environment variables prefixed with `ROUTER` and each level separated by double
        //    underscores.
        //
        // Values in config file override the defaults in `Default` trait, and the values set using
        // environment variables override both the defaults and the config file values.

        let environment = env::which();
        let config_path = router_env::Config::config_path(&environment.to_string(), config_path);

        let config = router_env::Config::builder(&environment.to_string())?
            .add_source(File::from(config_path).required(false))
            .add_source(
                Environment::with_prefix("ROUTER")
                    .try_parsing(true)
                    .separator("__")
                    .list_separator(",")
                    .with_list_parse_key("log.telemetry.route_to_trace")
                    .with_list_parse_key("redis.cluster_urls")
                    .with_list_parse_key("events.kafka.brokers")
                    .with_list_parse_key("connectors.supported.wallets")
                    .with_list_parse_key("connector_request_reference_id_config.merchant_ids_send_payment_id_as_connector_request_id"),

            )
            .build()?;

        serde_path_to_error::deserialize(config).map_err(|error| {
            logger::error!(%error, "Unable to deserialize application configuration");
            eprintln!("Unable to deserialize application configuration: {error}");
            ApplicationError::from(error.into_inner())
        })
    }

    pub fn validate(&self) -> ApplicationResult<()> {
        self.server.validate()?;
        self.master_database.get_inner().validate()?;
        #[cfg(feature = "olap")]
        self.replica_database.get_inner().validate()?;
        self.redis.validate().map_err(|error| {
            println!("{error}");
            ApplicationError::InvalidConfigurationValueError("Redis configuration".into())
        })?;
        if self.log.file.enabled {
            if self.log.file.file_name.is_default_or_empty() {
                return Err(ApplicationError::InvalidConfigurationValueError(
                    "log file name must not be empty".into(),
                ));
            }

            if self.log.file.path.is_default_or_empty() {
                return Err(ApplicationError::InvalidConfigurationValueError(
                    "log directory path must not be empty".into(),
                ));
            }
        }
        self.secrets.get_inner().validate()?;
        self.locker.validate()?;

        self.cors.validate()?;

        self.scheduler
            .as_ref()
            .map(|scheduler_settings| scheduler_settings.validate())
            .transpose()?;
        #[cfg(feature = "kv_store")]
        self.drainer.validate()?;
        self.api_keys.get_inner().validate()?;

        // self.file_storage
        //     .validate()
        //     .map_err(|err| ApplicationError::InvalidConfigurationValueError(err.to_string()))?;

        self.lock_settings.validate()?;
        // self.events.validate()?;

        // self.encryption_management
        //     .validate()
        //     .map_err(|err| ApplicationError::InvalidConfigurationValueError(err.into()))?;

        self.secrets_management
            .validate()
            .map_err(|err| ApplicationError::InvalidConfigurationValueError(err.into()))?;
        Ok(())
    }
}

#[derive(Debug, Clone, Default)]
pub struct LockSettings {
    pub redis_lock_expiry_seconds: u32,
    pub delay_between_retries_in_milliseconds: u32,
    pub lock_retries: u32,
}

impl<'de> Deserialize<'de> for LockSettings {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        #[derive(Deserialize)]
        #[serde(deny_unknown_fields)]
        struct Inner {
            redis_lock_expiry_seconds: u32,
            delay_between_retries_in_milliseconds: u32,
        }

        let Inner {
            redis_lock_expiry_seconds,
            delay_between_retries_in_milliseconds,
        } = Inner::deserialize(deserializer)?;
        let redis_lock_expiry_milliseconds = redis_lock_expiry_seconds * 1000;
        Ok(Self {
            redis_lock_expiry_seconds,
            delay_between_retries_in_milliseconds,
            lock_retries: redis_lock_expiry_milliseconds / delay_between_retries_in_milliseconds,
        })
    }
}

fn deserialize_hashset_inner<T>(value: impl AsRef<str>) -> Result<HashSet<T>, String>
where
    T: Eq + std::str::FromStr + std::hash::Hash,
    <T as std::str::FromStr>::Err: std::fmt::Display,
{
    let (values, errors) = value
        .as_ref()
        .trim()
        .split(',')
        .map(|s| {
            T::from_str(s.trim()).map_err(|error| {
                format!(
                    "Unable to deserialize `{}` as `{}`: {error}",
                    s.trim(),
                    std::any::type_name::<T>()
                )
            })
        })
        .fold(
            (HashSet::new(), Vec::new()),
            |(mut values, mut errors), result| match result {
                Ok(t) => {
                    values.insert(t);
                    (values, errors)
                }
                Err(error) => {
                    errors.push(error);
                    (values, errors)
                }
            },
        );
    if !errors.is_empty() {
        Err(format!("Some errors occurred:\n{}", errors.join("\n")))
    } else {
        Ok(values)
    }
}

fn deserialize_hashset<'a, D, T>(deserializer: D) -> Result<HashSet<T>, D::Error>
where
    D: serde::Deserializer<'a>,
    T: Eq + std::str::FromStr + std::hash::Hash,
    <T as std::str::FromStr>::Err: std::fmt::Display,
{
    use serde::de::Error;

    deserialize_hashset_inner(<String>::deserialize(deserializer)?).map_err(D::Error::custom)
}

fn deserialize_optional_hashset<'a, D, T>(deserializer: D) -> Result<Option<HashSet<T>>, D::Error>
where
    D: serde::Deserializer<'a>,
    T: Eq + std::str::FromStr + std::hash::Hash,
    <T as std::str::FromStr>::Err: std::fmt::Display,
{
    use serde::de::Error;

    <Option<String>>::deserialize(deserializer).map(|value| {
        value.map_or(Ok(None), |inner: String| {
            let list = deserialize_hashset_inner(inner).map_err(D::Error::custom)?;
            match list.len() {
                0 => Ok(None),
                _ => Ok(Some(list)),
            }
        })
    })?
}
