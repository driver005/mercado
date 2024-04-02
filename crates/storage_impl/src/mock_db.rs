use std::sync::Arc;

use data_models::errors::StorageError;
use diesel_models::{self as store};
use error_stack::ResultExt;
use futures::lock::Mutex;
use redis_interface::RedisSettings;

use crate::redis::RedisStore;

pub mod redis_conn;

#[derive(Clone)]
pub struct MockDb {
    pub processes: Arc<Mutex<Vec<store::ProcessTracker>>>,
    pub redis: Arc<RedisStore>,
}

impl MockDb {
    pub async fn new(redis: &RedisSettings) -> error_stack::Result<Self, StorageError> {
        Ok(Self {
            processes: Default::default(),
            redis: Arc::new(
                RedisStore::new(redis)
                    .await
                    .change_context(StorageError::InitializationError)?,
            ),
        })
    }
}
