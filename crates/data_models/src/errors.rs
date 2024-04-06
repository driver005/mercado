pub mod api_error;
pub mod customers_error_response;
pub mod db;
pub mod error_handlers;
pub mod transformers;
#[cfg(feature = "olap")]
pub mod user;
pub mod utils;

use common_utils::errors::CustomResult;
pub use redis_interface::errors::RedisError;
#[cfg(feature = "olap")]
pub use user::*;

use actix_web::ResponseError;
use config::ConfigError;
use diesel_models::errors::DatabaseError;
use router_env::opentelemetry::metrics::MetricsError;
use std::fmt::Display;

pub use self::{
    api_error::{ApiErrorResponse, NotImplementedMessage},
    customers_error_response::CustomersErrorResponse,
    db::StorageError,
    utils::StorageErrorExt,
};

pub type StorageResult<T> = error_stack::Result<T, StorageError>;

pub type RouterResult<T> = CustomResult<T, ApiErrorResponse>;
pub type RouterResponse<T> = CustomResult<api_error::ApplicationResponse<T>, ApiErrorResponse>;

pub type ApplicationResult<T> = Result<T, ApplicationError>;
pub type ApplicationResponse<T> = ApplicationResult<api_error::ApplicationResponse<T>>;

pub type CustomerResponse<T> = CustomResult<ApplicationResponse<T>, CustomersErrorResponse>;

macro_rules! impl_error_display {
    ($st: ident, $arg: tt) => {
        impl Display for $st {
            fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
                write!(
                    fmt,
                    "{{ error_type: {:?}, error_description: {} }}",
                    self, $arg
                )
            }
        }
    };
}
macro_rules! impl_error_type {
    ($name: ident, $arg: tt) => {
        #[derive(Debug)]
        pub struct $name;

        impl_error_display!($name, $arg);

        impl std::error::Error for $name {}
    };
}

impl From<error_stack::Report<RedisError>> for StorageError {
    fn from(err: error_stack::Report<RedisError>) -> Self {
        Self::RedisError(err)
    }
}

impl From<error_stack::Report<DatabaseError>> for StorageError {
    fn from(err: error_stack::Report<DatabaseError>) -> Self {
        Self::DatabaseError(err)
    }
}

pub trait RedisErrorExt {
    #[track_caller]
    fn to_redis_failed_response(self, key: &str) -> error_stack::Report<StorageError>;
}

impl RedisErrorExt for error_stack::Report<RedisError> {
    fn to_redis_failed_response(self, key: &str) -> error_stack::Report<StorageError> {
        match self.current_context() {
            RedisError::NotFound => self.change_context(StorageError::ValueNotFound(format!(
                "Data does not exist for key {key}",
            ))),
            RedisError::SetNxFailed | RedisError::SetAddMembersFailed => {
                self.change_context(StorageError::DuplicateValue {
                    entity: "redis",
                    key: Some(key.to_string()),
                })
            }
            _ => self.change_context(StorageError::KVError),
        }
    }
}

impl_error_type!(EncryptionError, "Encryption error");

#[derive(Debug, thiserror::Error)]
pub enum ApplicationError {
    // Display's impl can be overridden by the attribute error marco.
    // Don't use Debug here, Debug gives error stack in response.
    #[error("Application configuration error: {0}")]
    ConfigurationError(ConfigError),

    #[error("Invalid configuration value provided: {0}")]
    InvalidConfigurationValueError(String),

    #[error("Metrics error: {0}")]
    MetricsError(MetricsError),

    #[error("I/O: {0}")]
    IoError(std::io::Error),

    #[error("Error while constructing api client: {0}")]
    ApiClientError(ApiClientError),
}

impl From<MetricsError> for ApplicationError {
    fn from(err: MetricsError) -> Self {
        Self::MetricsError(err)
    }
}

impl From<std::io::Error> for ApplicationError {
    fn from(err: std::io::Error) -> Self {
        Self::IoError(err)
    }
}

impl From<ring::error::Unspecified> for EncryptionError {
    fn from(_: ring::error::Unspecified) -> Self {
        Self
    }
}

impl From<ConfigError> for ApplicationError {
    fn from(err: ConfigError) -> Self {
        Self::ConfigurationError(err)
    }
}

fn error_response<T: Display>(err: &T) -> actix_web::HttpResponse {
    actix_web::HttpResponse::BadRequest()
        .content_type(mime::APPLICATION_JSON)
        .body(format!(r#"{{ "error": {{ "message": "{err}" }} }}"#))
}

impl ResponseError for ApplicationError {
    fn status_code(&self) -> actix_web::http::StatusCode {
        match self {
            Self::MetricsError(_)
            | Self::IoError(_)
            | Self::ConfigurationError(_)
            | Self::InvalidConfigurationValueError(_)
            | Self::ApiClientError(_) => actix_web::http::StatusCode::INTERNAL_SERVER_ERROR,
        }
    }

    fn error_response(&self) -> actix_web::HttpResponse {
        error_response(self)
    }
}

#[derive(Debug, thiserror::Error, PartialEq, Clone)]
pub enum ApiClientError {
    #[error("Header map construction failed")]
    HeaderMapConstructionFailed,
    #[error("Invalid proxy configuration")]
    InvalidProxyConfiguration,
    #[error("Client construction failed")]
    ClientConstructionFailed,
    #[error("Certificate decode failed")]
    CertificateDecodeFailed,
    #[error("Request body serialization failed")]
    BodySerializationFailed,
    #[error("Unexpected state reached/Invariants conflicted")]
    UnexpectedState,

    #[error("URL encoding of request payload failed")]
    UrlEncodingFailed,
    #[error("Failed to send request to connector {0}")]
    RequestNotSent(String),
    #[error("Failed to decode response")]
    ResponseDecodingFailed,

    #[error("Server responded with Request Timeout")]
    RequestTimeoutReceived,

    #[error("connection closed before a message could complete")]
    ConnectionClosedIncompleteMessage,

    #[error("Server responded with Internal Server Error")]
    InternalServerErrorReceived,
    #[error("Server responded with Bad Gateway")]
    BadGatewayReceived,
    #[error("Server responded with Service Unavailable")]
    ServiceUnavailableReceived,
    #[error("Server responded with Gateway Timeout")]
    GatewayTimeoutReceived,
    #[error("Server responded with unexpected response")]
    UnexpectedServerResponse,
}

impl ApiClientError {
    pub fn is_upstream_timeout(&self) -> bool {
        self == &Self::RequestTimeoutReceived
    }
    pub fn is_connection_closed_before_message_could_complete(&self) -> bool {
        self == &Self::ConnectionClosedIncompleteMessage
    }
}

#[derive(Debug, thiserror::Error)]
pub enum HealthCheckDBError {
    #[error("Error while connecting to database")]
    DBError,
    #[error("Error while writing to database")]
    DBWriteError,
    #[error("Error while reading element in the database")]
    DBReadError,
    #[error("Error while deleting element in the database")]
    DBDeleteError,
    #[error("Unpredictable error occurred")]
    UnknownError,
    #[error("Error in database transaction")]
    TransactionError,
    #[error("Error while executing query in Sqlx Analytics")]
    SqlxAnalyticsError,
    #[error("Error while executing query in Clickhouse Analytics")]
    ClickhouseAnalyticsError,
}

impl From<diesel::result::Error> for HealthCheckDBError {
    fn from(error: diesel::result::Error) -> Self {
        match error {
            diesel::result::Error::DatabaseError(_, _) => Self::DBError,

            diesel::result::Error::RollbackErrorOnCommit { .. }
            | diesel::result::Error::RollbackTransaction
            | diesel::result::Error::AlreadyInTransaction
            | diesel::result::Error::NotInTransaction
            | diesel::result::Error::BrokenTransactionManager => Self::TransactionError,

            _ => Self::UnknownError,
        }
    }
}

#[derive(Debug, thiserror::Error)]
pub enum HealthCheckRedisError {
    #[error("Failed to establish Redis connection")]
    RedisConnectionError,
    #[error("Failed to set key value in Redis")]
    SetFailed,
    #[error("Failed to get key value in Redis")]
    GetFailed,
    #[error("Failed to delete key value in Redis")]
    DeleteFailed,
}

#[derive(Debug, Clone, thiserror::Error)]
pub enum HealthCheckLockerError {
    #[error("Failed to establish Locker connection")]
    FailedToCallLocker,
}
