use diesel::{pg::Pg, prelude::*};

use common_utils::errors::CustomResult;
use diesel_models::{
    models,
    schema::user::{self as model, BoxedQuery},
};
use router::{connection, services::Store};
use storage_impl::errors;

#[async_trait::async_trait]
pub trait UserInterface {
    async fn retrieve_user(
        &self,
        user_id: &str,
    ) -> CustomResult<models::User, errors::StorageError>;

    async fn list_users(
        &self,
        predicate: Box<dyn Send + Fn(&model::table) -> BoxedQuery<'static, Pg, model::table>>,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<Box<dyn Expression<SqlType = model::SqlType> + Send>>,
    ) -> CustomResult<Vec<models::User>, errors::StorageError>;

    async fn list_and_count_users(
        &self,
        predicate: Box<dyn Send + Fn(&model::table) -> BoxedQuery<'static, Pg, model::table>>,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<Box<dyn Expression<SqlType = model::SqlType> + Send>>,
    ) -> CustomResult<Vec<models::User>, errors::StorageError>;

    // async fn list_users<P, O>(
    //     &self,
    //     predicate: P,
    //     limit: Option<i64>,
    //     offset: Option<i64>,
    //     order: Option<O>,
    // ) -> CustomResult<Vec<models::User>, errors::StorageError>
    // where
    //     P: Send,
    //     O: Expression + Send,
    //     model::table: BoxedDsl<'static, Pg>,
    //     IntoBoxed<'static, model::table, Pg>: FilterDsl<P, Output = IntoBoxed<'static, model::table, Pg>>
    //         + LimitDsl<Output = IntoBoxed<'static, model::table, Pg>>
    //         + OffsetDsl<Output = IntoBoxed<'static, model::table, Pg>>
    //         + OrderDsl<O, Output = IntoBoxed<'static, model::table, Pg>>
    //         + LoadQuery<'static, PgConnection, models::User>
    //         + QueryFragment<Pg>
    //         + Send;

    async fn insert_user(
        &self,
        user: models::UserNew,
    ) -> CustomResult<models::User, errors::StorageError>;

    // async fn upsert_user(
    //     &self,
    //     user_id: &str,
    //     user: models::UserUpdate,
    // ) -> CustomResult<models::User, errors::StorageError>;

    async fn update_user(
        &self,
        user_id: &str,
        user: models::UserUpdate,
    ) -> CustomResult<models::User, errors::StorageError>;

    async fn delete_user(&self, user_id: &str) -> CustomResult<bool, errors::StorageError>;
}

#[async_trait::async_trait]
impl UserInterface for Store {
    async fn retrieve_user(
        &self,
        user_id: &str,
    ) -> CustomResult<models::User, errors::StorageError> {
        let conn = connection::pg_connection_write(self).await?;

        models::User::find_by_id(&conn, user_id)
            .await
            .map_err(|err| errors::StorageError::DatabaseError(err).into())
    }

    async fn list_users(
        &self,
        predicate: Box<dyn Send + Fn(&model::table) -> BoxedQuery<'static, Pg, model::table>>,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<Box<dyn Expression<SqlType = model::SqlType> + Send>>,
    ) -> CustomResult<Vec<models::User>, errors::StorageError> {
        let conn = connection::pg_connection_read(self).await?;

        models::User::filter(&conn, predicate, limit, offset, order)
            .await
            .map_err(|err| errors::StorageError::DatabaseError(err).into())
    }

    async fn list_and_count_users(
        &self,
        predicate: Box<dyn Send + Fn(&model::table) -> BoxedQuery<'static, Pg, model::table>>,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<Box<dyn Expression<SqlType = model::SqlType> + Send>>,
    ) -> CustomResult<Vec<models::User>, errors::StorageError> {
        let conn = connection::pg_connection_read(self).await?;

        models::User::filter(&conn, predicate, limit, offset, order)
            .await
            .map_err(|err| errors::StorageError::DatabaseError(err).into())
    }

    // async fn list_users<P, O>(
    //     &self,
    //     predicate: P,
    //     limit: Option<i64>,
    //     offset: Option<i64>,
    //     order: Option<O>,
    // ) -> CustomResult<Vec<models::User>, errors::StorageError>
    // where
    //     P: Send,
    //     O: Expression + Send,
    //     model::table: BoxedDsl<'static, Pg>,
    //     IntoBoxed<'static, model::table, Pg>: FilterDsl<P, Output = IntoBoxed<'static, model::table, Pg>>
    //         + LimitDsl<Output = IntoBoxed<'static, model::table, Pg>>
    //         + OffsetDsl<Output = IntoBoxed<'static, model::table, Pg>>
    //         + OrderDsl<O, Output = IntoBoxed<'static, model::table, Pg>>
    //         + LoadQuery<'static, PgConnection, models::User>
    //         + QueryFragment<Pg>
    //         + Send,
    // {
    //     let conn = connection::pg_connection_read(self).await?;

    //     models::User::filter(&conn, predicate, limit, offset, order)
    //         .await
    //         .map_err(|err| errors::StorageError::DatabaseError(err).into())
    // }

    // async fn list_and_count_users<P, O>(
    //     &self,
    //     predicate: P,
    //     limit: Option<i64>,
    //     offset: Option<i64>,
    //     order: Option<O>,
    // ) -> CustomResult<Vec<models::User>, errors::StorageError>
    // where
    //     P: Send,
    //     O: Expression + Send,
    //     model::table: BoxedDsl<'static, Pg>,
    //     IntoBoxed<'static, model::table, Pg>: FilterDsl<P, Output = IntoBoxed<'static, model::table, Pg>>
    //         + LimitDsl<Output = IntoBoxed<'static, model::table, Pg>>
    //         + OffsetDsl<Output = IntoBoxed<'static, model::table, Pg>>
    //         + OrderDsl<O, Output = IntoBoxed<'static, model::table, Pg>>
    //         + LoadQuery<'static, PgConnection, models::User>
    //         + QueryFragment<Pg>
    //         + Send,
    // {
    //     let conn = connection::pg_connection_read(self).await?;

    //     models::User::filter(&conn, predicate, limit, offset, order)
    //         .await
    //         .map_err(|err| errors::StorageError::DatabaseError(err).into())
    // }

    async fn insert_user(
        &self,
        user: models::UserNew,
    ) -> CustomResult<models::User, errors::StorageError> {
        let conn = connection::pg_connection_write(self).await?;

        user.insert(&conn)
            .await
            .map_err(|err| errors::StorageError::DatabaseError(err).into())
    }

    // async fn upsert_user(
    //     &self,
    //     user_id: &str,
    //     user: models::UserUpdate,
    // ) -> CustomResult<models::User, errors::StorageError> {
    //     let update_call = || async { self.update_user(user_id, user.clone()).await };

    //     let insert_call = || async {
    //         let new_user: models::UserNew = match <models::UserUpdate as std::convert::Into<
    //             models::UserUpdateInternal,
    //         >>::into(user.clone())
    //         .try_into()
    //         {
    //             Ok(new_user) => new_user,
    //             Err(err) => {
    //                 return Err(Report::from(errors::StorageError::ValueNotFound(
    //                     err.to_string(),
    //                 )))
    //             }
    //         };
    //         self.insert_user(new_user).await
    //     };

    //     match update_call().await {
    //         Ok(result) => Ok(result),
    //         Err(err) => match err.current_context() {
    //             errors::StorageError::DatabaseError(database_error) => {
    //                 match database_error.current_context() {
    //                     DatabaseError::NotFound => insert_call().await,
    //                     _ => Err(err),
    //                 }
    //             }
    //             _ => Err(err),
    //         },
    //     }
    // }

    async fn update_user(
        &self,
        user_id: &str,
        user: models::UserUpdate,
    ) -> CustomResult<models::User, errors::StorageError> {
        let conn = connection::pg_connection_write(self).await?;

        let update_call = || async {
            models::User::update_by_id(&conn, user_id.to_owned(), user)
                .await
                .map_err(|err| errors::StorageError::DatabaseError(err).into())
        };

        update_call().await
    }

    async fn delete_user(&self, user_id: &str) -> CustomResult<bool, errors::StorageError> {
        let conn = connection::pg_connection_write(self).await?;

        let delete_call = || async {
            models::User::delete_by_id(&conn, user_id)
                .await
                .map_err(|err| errors::StorageError::DatabaseError(err).into())
        };

        delete_call().await
    }

    // Custom functions
}
