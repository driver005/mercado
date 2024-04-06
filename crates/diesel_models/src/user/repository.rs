use diesel::{
    associations::HasTable,
    dsl::IntoBoxed,
    pg::Pg,
    prelude::*,
    query_builder::QueryFragment,
    query_dsl::methods::{BoxedDsl, FilterDsl, LimitDsl, LoadQuery, OffsetDsl, OrderDsl},
    ExpressionMethods,
};

use crate::{
    errors, generics,
    schema::invite::{self as model_invite, dsl as invite_dsl},
    schema::user::{self as model_user, dsl as user_dsl},
    user::{
        Invite, InviteNew, InviteUpdate, InviteUpdateInternal, User, UserNew, UserUpdate,
        UserUpdateInternal,
    },
    PgPooledConn, StorageResult,
};

impl UserNew {
    pub async fn insert(self, conn: &PgPooledConn) -> StorageResult<User> {
        generics::generic_insert(conn, self).await
    }
}

impl InviteNew {
    pub async fn insert(self, conn: &PgPooledConn) -> StorageResult<Invite> {
        generics::generic_insert(conn, self).await
    }
}

impl User {
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
        predicate: P,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<O>,
    ) -> StorageResult<Vec<Self>>
    where
        model_user::table: BoxedDsl<'static, Pg>,
        IntoBoxed<'static, model_user::table, Pg>: FilterDsl<P, Output = IntoBoxed<'static, model_user::table, Pg>>
            + LimitDsl<Output = IntoBoxed<'static, model_user::table, Pg>>
            + OffsetDsl<Output = IntoBoxed<'static, model_user::table, Pg>>
            + OrderDsl<O, Output = IntoBoxed<'static, model_user::table, Pg>>
            + LoadQuery<'static, PgConnection, Self>
            + QueryFragment<Pg>
            + Send,
        O: Expression,
    {
        generics::generic_filter::<model_user::table, P, O, Self>(
            conn, predicate, limit, offset, order,
        )
        .await
    }

    pub async fn update_by_id(
        conn: &PgPooledConn,
        id: String,
        values: UserUpdate,
    ) -> StorageResult<Self> {
        match generics::generic_update_by_id::<<Self as HasTable>::Table, _, _, _>(
            conn,
            id.clone(),
            UserUpdateInternal::from(values),
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
        generics::generic_delete::<<Self as HasTable>::Table, _>(
            conn,
            user_dsl::id.eq(id.to_owned()),
        )
        .await
    }
}

impl Invite {
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
        predicate: P,
        limit: Option<i64>,
        offset: Option<i64>,
        order: Option<O>,
    ) -> StorageResult<Vec<Self>>
    where
        model_invite::table: BoxedDsl<'static, Pg>,
        IntoBoxed<'static, model_invite::table, Pg>: FilterDsl<P, Output = IntoBoxed<'static, model_invite::table, Pg>>
            + LimitDsl<Output = IntoBoxed<'static, model_invite::table, Pg>>
            + OffsetDsl<Output = IntoBoxed<'static, model_invite::table, Pg>>
            + OrderDsl<O, Output = IntoBoxed<'static, model_invite::table, Pg>>
            + LoadQuery<'static, PgConnection, Self>
            + QueryFragment<Pg>
            + Send,
        O: Expression,
    {
        generics::generic_filter::<model_invite::table, P, O, Self>(
            conn, predicate, limit, offset, order,
        )
        .await
    }

    pub async fn update_by_id(
        conn: &PgPooledConn,
        id: String,
        values: InviteUpdate,
    ) -> StorageResult<Self> {
        match generics::generic_update_by_id::<<Self as HasTable>::Table, _, _, _>(
            conn,
            id.clone(),
            InviteUpdateInternal::from(values),
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
        generics::generic_delete::<<Self as HasTable>::Table, _>(
            conn,
            invite_dsl::id.eq(id.to_owned()),
        )
        .await
    }
}
