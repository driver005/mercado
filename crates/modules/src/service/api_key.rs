use diesel::{pg::Pg, prelude::*};

use error_stack::Report;

use common_utils::errors::CustomResult;
use diesel_models::{
    errors::DatabaseError,
    models,
    schema::api_key::{self as model, BoxedQuery},
};
use router::{connection, services::Store};
use storage_impl::errors;

#[async_trait::async_trait]
pub trait ApiKeyInterface {
    async fn retrieve_api_key(
        &self,
        key_id: &str,
    ) -> CustomResult<models::ApiKey, errors::StorageError>;

    async fn list_api_keys(
        &self,
        predicate: Box<dyn Send + Fn(&model::table) -> BoxedQuery<'static, Pg, model::table>>,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<Box<dyn Expression<SqlType = model::SqlType> + Send>>,
    ) -> CustomResult<Vec<models::ApiKey>, errors::StorageError>;

    async fn list_and_count_api_keys(
        &self,
        predicate: Box<dyn Send + Fn(&model::table) -> BoxedQuery<'static, Pg, model::table>>,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<Box<dyn Expression<SqlType = model::SqlType> + Send>>,
    ) -> CustomResult<Vec<models::ApiKey>, errors::StorageError>;

    async fn insert_api_key(
        &self,
        api_key: models::ApiKeyNew,
    ) -> CustomResult<models::ApiKey, errors::StorageError>;

    async fn upsert_api_key(
        &self,
        key_id: &str,
        api_key: models::ApiKeyUpdate,
    ) -> CustomResult<models::ApiKey, errors::StorageError>;

    async fn update_api_key(
        &self,
        key_id: &str,
        api_key: models::ApiKeyUpdate,
    ) -> CustomResult<models::ApiKey, errors::StorageError>;

    async fn delete_api_key(&self, key_id: &str) -> CustomResult<bool, errors::StorageError>;

    // async fn revoke_api_key(
    //     &self,
    //     key_id: &str,
    //     api_key: models::ApiKeyUpdate,
    // ) -> CustomResult<models::ApiKey, errors::StorageError>;

    async fn authenticate_api_key(
        &self,
        token: String,
    ) -> CustomResult<models::ApiKey, errors::StorageError>;
}

#[async_trait::async_trait]
impl ApiKeyInterface for Store {
    async fn retrieve_api_key(
        &self,
        key_id: &str,
    ) -> CustomResult<models::ApiKey, errors::StorageError> {
        let conn = connection::pg_connection_write(self).await?;

        models::ApiKey::find_by_id(&conn, key_id)
            .await
            .map_err(|err| errors::StorageError::DatabaseError(err).into())
    }

    async fn list_api_keys(
        &self,
        predicate: Box<dyn Send + Fn(&model::table) -> BoxedQuery<'static, Pg, model::table>>,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<Box<dyn Expression<SqlType = model::SqlType> + Send>>,
    ) -> CustomResult<Vec<models::ApiKey>, errors::StorageError> {
        let conn = connection::pg_connection_read(self).await?;

        models::ApiKey::filter(&conn, predicate, limit, offset, order)
            .await
            .map_err(|err| errors::StorageError::DatabaseError(err).into())
    }

    async fn list_and_count_api_keys(
        &self,
        predicate: Box<dyn Send + Fn(&model::table) -> BoxedQuery<'static, Pg, model::table>>,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<Box<dyn Expression<SqlType = model::SqlType> + Send>>,
    ) -> CustomResult<Vec<models::ApiKey>, errors::StorageError> {
        let conn = connection::pg_connection_read(self).await?;

        models::ApiKey::filter(&conn, predicate, limit, offset, order)
            .await
            .map_err(|err| errors::StorageError::DatabaseError(err).into())
    }

    async fn insert_api_key(
        &self,
        api_key: models::ApiKeyNew,
    ) -> CustomResult<models::ApiKey, errors::StorageError> {
        let conn = connection::pg_connection_write(self).await?;

        api_key
            .insert(&conn)
            .await
            .map_err(|err| errors::StorageError::DatabaseError(err).into())
    }

    async fn upsert_api_key(
        &self,
        key_id: &str,
        api_key: models::ApiKeyUpdate,
    ) -> CustomResult<models::ApiKey, errors::StorageError> {
        let update_call = || async { self.update_api_key(key_id, api_key.clone()).await };

        let insert_call = || async {
            let new_api_key: models::ApiKeyNew =
                match <models::api_key::ApiKeyUpdate as std::convert::Into<
                    models::ApiKeyUpdateInternal,
                >>::into(api_key.clone())
                .try_into()
                {
                    Ok(new_api_key) => new_api_key,
                    Err(err) => {
                        return Err(Report::from(errors::StorageError::ValueNotFound(
                            err.to_string(),
                        )))
                    }
                };
            self.insert_api_key(new_api_key).await
        };

        match update_call().await {
            Ok(result) => Ok(result),
            Err(err) => match err.current_context() {
                errors::StorageError::DatabaseError(database_error) => {
                    match database_error.current_context() {
                        DatabaseError::NotFound => insert_call().await,
                        _ => Err(err),
                    }
                }
                _ => Err(err),
            },
        }
    }

    async fn update_api_key(
        &self,
        key_id: &str,
        api_key: models::ApiKeyUpdate,
    ) -> CustomResult<models::ApiKey, errors::StorageError> {
        let conn = connection::pg_connection_write(self).await?;

        let update_call = || async {
            models::ApiKey::update_by_id(&conn, key_id.to_owned(), api_key)
                .await
                .map_err(|err| errors::StorageError::DatabaseError(err).into())
        };

        update_call().await
    }

    async fn delete_api_key(&self, key_id: &str) -> CustomResult<bool, errors::StorageError> {
        let conn = connection::pg_connection_write(self).await?;

        let delete_call = || async {
            models::ApiKey::delete_by_id(&conn, key_id)
                .await
                .map_err(|err| errors::StorageError::DatabaseError(err).into())
        };

        delete_call().await
    }

    // Custom functions

    // async fn revoke_api_key(
    //     &self,
    //     key_id: &str,
    //     api_key: models::ApiKeyUpdate,
    // ) -> CustomResult<models::ApiKey, errors::StorageError> {
    //     let conn = connection::pg_connection_write(self).await?;

    //     self.update_api_key(key_id, api_key).await
    // }

    async fn authenticate_api_key(
        &self,
        token: String,
    ) -> CustomResult<models::ApiKey, errors::StorageError> {
        let conn = connection::pg_connection_write(self).await?;

        match models::ApiKey::find_optional_by_hashed_api_key(
            &conn,
            models::HashedApiKey::from(token),
        )
        .await
        {
            Ok(api_key) => match api_key {
                Some(api_key) => Ok(api_key),
                None => Err(Report::from(errors::StorageError::DatabaseError(
                    Report::from(DatabaseError::NotFound),
                ))),
            },
            Err(err) => Err(errors::StorageError::DatabaseError(err).into()),
        }
    }
}
