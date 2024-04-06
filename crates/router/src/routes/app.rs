use std::sync::Arc;

use data_models::configs::{secrets_transformers, settings};
use hyperswitch_interfaces::secrets_interface::secret_state::{RawSecret, SecuredSecret};
use router_env::tracing_actix_web::RequestId;
use scheduler::SchedulerInterface;
use storage_impl::mock_db::MockDb;
use tokio::sync::oneshot;

use crate::db::{StorageImpl, StorageInterface};

#[derive(Clone)]
pub struct AppState {
    pub flow_name: String,
    pub store: Box<dyn StorageInterface>,
    pub conf: Arc<settings::Settings<RawSecret>>,
    // pub event_handler: EventsHandler,
    #[cfg(feature = "email")]
    pub email_client: Arc<dyn EmailService>,
    // pub api_client: Box<dyn crate::services::ApiClient>,
    #[cfg(feature = "olap")]
    // pub pool: crate::analytics::AnalyticsProvider,
    pub request_id: Option<RequestId>,
    // pub file_storage_client: Box<dyn FileStorageInterface>,
    // pub encryption_client: Box<dyn EncryptionManagementInterface>,
}

impl scheduler::SchedulerAppState for AppState {
    fn get_db(&self) -> Box<dyn SchedulerInterface> {
        self.store.get_scheduler_db()
    }
}

pub trait AppStateInfo {
    fn conf(&self) -> settings::Settings<RawSecret>;
    fn store(&self) -> Box<dyn StorageInterface>;
    // fn event_handler(&self) -> EventsHandler;
    #[cfg(feature = "email")]
    fn email_client(&self) -> Arc<dyn EmailService>;
    // fn add_request_id(&mut self, request_id: RequestId);
    // fn add_merchant_id(&mut self, merchant_id: Option<String>);
    // fn add_flow_name(&mut self, flow_name: String);
    // fn get_request_id(&self) -> Option<String>;
}

impl AppStateInfo for AppState {
    fn conf(&self) -> settings::Settings<RawSecret> {
        self.conf.as_ref().to_owned()
    }
    fn store(&self) -> Box<dyn StorageInterface> {
        self.store.to_owned()
    }
    #[cfg(feature = "email")]
    fn email_client(&self) -> Arc<dyn EmailService> {
        self.email_client.to_owned()
    }
    // fn event_handler(&self) -> EventsHandler {
    //     self.event_handler.clone()
    // }
    // fn add_request_id(&mut self, request_id: RequestId) {
    //     self.api_client.add_request_id(request_id);
    //     self.store.add_request_id(request_id.to_string());
    //     self.request_id.replace(request_id);
    // }

    // fn add_merchant_id(&mut self, merchant_id: Option<String>) {
    //     self.api_client.add_merchant_id(merchant_id);
    // }
    // fn add_flow_name(&mut self, flow_name: String) {
    //     self.api_client.add_flow_name(flow_name);
    // }
    // fn get_request_id(&self) -> Option<String> {
    //     self.api_client.get_request_id()
    // }
}

impl AsRef<Self> for AppState {
    fn as_ref(&self) -> &Self {
        self
    }
}

#[cfg(feature = "email")]
pub async fn create_email_client(settings: &settings::Settings<RawSecret>) -> impl EmailService {
    match settings.email.active_email_client {
        external_services::email::AvailableEmailClients::SES => {
            AwsSes::create(&settings.email, settings.proxy.https_url.to_owned()).await
        }
    }
}

impl AppState {
    /// # Panics
    ///
    /// Panics if Store can't be created or JWE decryption fails
    pub async fn with_storage(
        conf: settings::Settings<SecuredSecret>,
        storage_impl: StorageImpl,
        shut_down_signal: oneshot::Sender<()>,
    ) -> Self {
        #[allow(clippy::expect_used)]
        let secret_management_client = conf
            .secrets_management
            .get_secret_management_client()
            .await
            .expect("Failed to create secret management client");

        let conf = secrets_transformers::fetch_raw_secrets(conf, &*secret_management_client).await;

        // #[allow(clippy::expect_used)]
        // let encryption_client = conf
        //     .encryption_management
        //     .get_encryption_management_client()
        //     .await
        //     .expect("Failed to create encryption client");

        Box::pin(async move {
            let testable = storage_impl == StorageImpl::PostgresqlTest;
            // #[allow(clippy::expect_used)]
            // let event_handler = conf
            //     .events
            //     .get_event_handler()
            //     .await
            //     .expect("Failed to create event handler");

            let store: Box<dyn StorageInterface> = match storage_impl {
                _ => Box::new(
                    MockDb::new(&conf.redis)
                        .await
                        .expect("Failed to create mock store"),
                ),
                // StorageImpl::Postgresql | StorageImpl::PostgresqlTest => match &event_handler {
                //     EventsHandler::Kafka(kafka_client) => Box::new(
                //         crate::db::KafkaStore::new(
                //             #[allow(clippy::expect_used)]
                //             get_store(&conf.clone(), shut_down_signal, testable)
                //                 .await
                //                 .expect("Failed to create store"),
                //             kafka_client.clone(),
                //         )
                //         .await,
                //     ),
                //     EventsHandler::Logs(_) => Box::new(
                //         #[allow(clippy::expect_used)]
                //         get_store(&conf, shut_down_signal, testable)
                //             .await
                //             .expect("Failed to create store"),
                //     ),
                // },
                // #[allow(clippy::expect_used)]
                // StorageImpl::Mock => Box::new(
                //     MockDb::new(&conf.redis)
                //         .await
                //         .expect("Failed to create mock store"),
                // ),
            };

            // #[cfg(feature = "olap")]
            // let pool =
            //     crate::analytics::AnalyticsProvider::from_conf(conf.analytics.get_inner()).await;

            #[cfg(feature = "email")]
            let email_client = Arc::new(create_email_client(&conf).await);

            // let file_storage_client = conf.file_storage.get_file_storage_client().await;

            Self {
                flow_name: String::from("default"),
                store,
                conf: Arc::new(conf),
                #[cfg(feature = "email")]
                email_client,
                // api_client,
                // event_handler,
                // #[cfg(feature = "olap")]
                // pool,
                request_id: None,
                // file_storage_client,
                // encryption_client,
            }
        })
        .await
    }

    pub async fn new(
        conf: settings::Settings<SecuredSecret>,
        shut_down_signal: oneshot::Sender<()>,
    ) -> Self {
        Box::pin(Self::with_storage(
            conf,
            StorageImpl::Postgresql,
            shut_down_signal,
        ))
        .await
    }
}
