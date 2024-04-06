use diesel::{
    dsl::IntoBoxed,
    pg::Pg,
    prelude::*,
    query_builder::QueryFragment,
    query_dsl::methods::{BoxedDsl, FilterDsl, LimitDsl, LoadQuery, OffsetDsl, OrderDsl},
};

use diesel_models::schema::api_key as model;

use common_utils::errors::CustomResult;
use diesel_models::errors::DatabaseError;
use error_stack::Report;
use router::{connection, services::Store};
use storage_impl::errors;

use crate::models::{self, ApiKeyUpdateInternal, HashedApiKey};

#[async_trait::async_trait]
pub trait ApiKeyInterface {
    async fn retrieve_api_key(
        &self,
        key_id: &str,
    ) -> CustomResult<models::ApiKey, errors::StorageError>;

    async fn list_api_keys<P, O>(
        &self,
        predicate: P,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<O>,
    ) -> CustomResult<Vec<models::ApiKey>, errors::StorageError>
    where
        P: Send,
        O: Expression + Send,
        model::table: BoxedDsl<'static, Pg>,
        IntoBoxed<'static, model::table, Pg>: FilterDsl<P, Output = IntoBoxed<'static, model::table, Pg>>
            + LimitDsl<Output = IntoBoxed<'static, model::table, Pg>>
            + OffsetDsl<Output = IntoBoxed<'static, model::table, Pg>>
            + OrderDsl<O, Output = IntoBoxed<'static, model::table, Pg>>
            + LoadQuery<'static, PgConnection, models::ApiKey>
            + QueryFragment<Pg>
            + Send;

    async fn list_and_count_api_keys<P, O>(
        &self,
        predicate: P,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<O>,
    ) -> CustomResult<Vec<models::ApiKey>, errors::StorageError>
    where
        P: Send,
        O: Expression + Send,
        model::table: BoxedDsl<'static, Pg>,
        IntoBoxed<'static, model::table, Pg>: FilterDsl<P, Output = IntoBoxed<'static, model::table, Pg>>
            + LimitDsl<Output = IntoBoxed<'static, model::table, Pg>>
            + OffsetDsl<Output = IntoBoxed<'static, model::table, Pg>>
            + OrderDsl<O, Output = IntoBoxed<'static, model::table, Pg>>
            + LoadQuery<'static, PgConnection, models::ApiKey>
            + QueryFragment<Pg>
            + Send;

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

    async fn list_api_keys<P, O>(
        &self,
        predicate: P,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<O>,
    ) -> CustomResult<Vec<models::ApiKey>, errors::StorageError>
    where
        P: Send,
        O: Expression + Send,
        model::table: BoxedDsl<'static, Pg>,
        IntoBoxed<'static, model::table, Pg>: FilterDsl<P, Output = IntoBoxed<'static, model::table, Pg>>
            + LimitDsl<Output = IntoBoxed<'static, model::table, Pg>>
            + OffsetDsl<Output = IntoBoxed<'static, model::table, Pg>>
            + OrderDsl<O, Output = IntoBoxed<'static, model::table, Pg>>
            + LoadQuery<'static, PgConnection, models::ApiKey>
            + QueryFragment<Pg>
            + Send,
    {
        let conn = connection::pg_connection_read(self).await?;

        models::ApiKey::filter(&conn, predicate, limit, offset, order)
            .await
            .map_err(|err| errors::StorageError::DatabaseError(err).into())
    }

    async fn list_and_count_api_keys<P, O>(
        &self,
        predicate: P,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<O>,
    ) -> CustomResult<Vec<models::ApiKey>, errors::StorageError>
    where
        P: Send,
        O: Expression + Send,
        model::table: BoxedDsl<'static, Pg>,
        IntoBoxed<'static, model::table, Pg>: FilterDsl<P, Output = IntoBoxed<'static, model::table, Pg>>
            + LimitDsl<Output = IntoBoxed<'static, model::table, Pg>>
            + OffsetDsl<Output = IntoBoxed<'static, model::table, Pg>>
            + OrderDsl<O, Output = IntoBoxed<'static, model::table, Pg>>
            + LoadQuery<'static, PgConnection, models::ApiKey>
            + QueryFragment<Pg>
            + Send,
    {
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
                            err.to_owned(),
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
            models::ApiKey::update_by_id(
                &conn,
                key_id.to_owned(),
                ApiKeyUpdateInternal::from(api_key),
            )
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

        match models::ApiKey::find_optional_by_hashed_api_key(&conn, HashedApiKey::from(token))
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
