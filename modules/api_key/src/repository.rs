use diesel::dsl::Asc;
use diesel::pg::Pg;
use diesel::query_dsl::methods::{FilterDsl, OrderDsl};
use diesel::{BoxableExpression, QueryDsl};

use diesel::{associations::HasTable, ExpressionMethods};
use diesel_models::{errors, generics, schema::api_key::dsl, PgPooledConn, StorageResult};

use crate::models::{ApiKey, ApiKeyNew, ApiKeyUpdateInternal, HashedApiKey};

impl ApiKeyNew {
    pub async fn insert(self, conn: &PgPooledConn) -> StorageResult<ApiKey> {
        generics::generic_insert(conn, self).await
    }
}

impl ApiKey {
    pub async fn find_by_id(conn: &PgPooledConn, id: &str) -> StorageResult<Self> {
        generics::generic_find_by_id::<<Self as HasTable>::Table, _, _>(conn, id.to_owned()).await
    }

    pub async fn find_optional_by_id(conn: &PgPooledConn, id: &str) -> StorageResult<Option<Self>> {
        generics::generic_find_by_id_optional::<<Self as HasTable>::Table, _, _>(
            conn,
            id.to_owned(),
        )
        .await
    }

    pub async fn filter<P, O>(
        conn: &PgPooledConn,
        filters: P,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<O>,
    ) -> StorageResult<Vec<ApiKey>>
    where
        P: BoxableExpression<ApiKey, Pg> + FilterDsl<P> + Send + 'static,
        O: BoxableExpression<ApiKey, Pg> + OrderDsl<O> + Send + 'static,
    {
        generics::generic_filter::<<Self as HasTable>::Table, P, _, ApiKey>(
            conn,
            filters,
            limit,
            offset,
            Some(dsl::id.eq("test")),
        )
        .await
    }

    pub async fn update_by_id(
        conn: &PgPooledConn,
        id: String,
        values: ApiKeyUpdateInternal,
    ) -> StorageResult<Self> {
        match generics::generic_update_by_id::<<Self as HasTable>::Table, _, _, _>(
            conn,
            id.clone(),
            values,
        )
        .await
        {
            Err(error) => match error.current_context() {
                errors::DatabaseError::NotFound => {
                    Err(error.attach_printable("values with the given ID doesn't exist"))
                }
                errors::DatabaseError::NoFieldsToUpdate => {
                    generics::generic_find_by_id::<<Self as HasTable>::Table, _, _>(
                        conn,
                        id.clone(),
                    )
                    .await
                }
                _ => Err(error),
            },
            result => result,
        }
    }

    pub async fn delete_by_id(conn: &PgPooledConn, id: &str) -> StorageResult<bool> {
        generics::generic_delete::<<Self as HasTable>::Table, _>(conn, dsl::id.eq(id.to_owned()))
            .await
    }

    pub async fn find_optional_by_hashed_api_key(
        conn: &PgPooledConn,
        hashed_api_key: HashedApiKey,
    ) -> StorageResult<Option<Self>> {
        generics::generic_find_one_optional::<<Self as HasTable>::Table, _, _>(
            conn,
            dsl::token.eq(hashed_api_key),
        )
        .await
    }
}
