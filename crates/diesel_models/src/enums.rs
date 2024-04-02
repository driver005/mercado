#[doc(hidden)]
pub mod diesel_exports {
    pub use super::{
        DbApiKeyType as ApiKeyType, DbAttemptStatus as AttemptStatus,
        DbAuthenticationType as AuthenticationType, DbBlocklistDataKind as BlocklistDataKind,
        DbCaptureMethod as CaptureMethod, DbCaptureStatus as CaptureStatus,
        DbConnectorStatus as ConnectorStatus, DbConnectorType as ConnectorType,
        DbCountryAlpha2 as CountryAlpha2, DbCurrency as Currency, DbDisputeStatus as DisputeStatus,
        DbEventClass as EventClass, DbFutureUsage as FutureUsage, DbIntentStatus as IntentStatus,
        DbMerchantStorageScheme as MerchantStorageScheme,
        DbPaymentMethodIssuerCode as PaymentMethodIssuerCode, DbPaymentSource as PaymentSource,
        DbPaymentType as PaymentType, DbPayoutStatus as PayoutStatus, DbPayoutType as PayoutType,
        DbProcessTrackerStatus as ProcessTrackerStatus,
        DbRequestIncrementalAuthorization as RequestIncrementalAuthorization,
        DbWebhookDeliveryAttempt as WebhookDeliveryAttempt,
    };
}
pub use common_enums::*;
use router_derive::diesel_enum;

#[derive(
    Clone,
    Copy,
    Debug,
    Eq,
    PartialEq,
    serde::Deserialize,
    serde::Serialize,
    strum::Display,
    strum::EnumString,
)]
#[diesel_enum(storage_type = "db_enum")]
#[serde(rename_all = "snake_case")]
#[strum(serialize_all = "snake_case")]
pub enum ProcessTrackerStatus {
    // Picked by the producer
    Processing,
    // State when the task is added
    New,
    // Send to retry
    Pending,
    // Picked by consumer
    ProcessStarted,
    // Finished by consumer
    Finish,
}
