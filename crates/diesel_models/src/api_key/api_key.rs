use diesel::{
    expression::AsExpression, query_builder::AsChangeset, Identifiable, Insertable, Queryable,
};

use serde::{Deserialize, Serialize};
use time::PrimitiveDateTime;

use crate::{enums::ApiKeyType, schema::api_key};

#[derive(Clone, Debug, Queryable, Identifiable, Serialize, Deserialize, AsChangeset)]
#[diesel(table_name = api_key, primary_key(id))]
pub struct ApiKey {
    pub id: String,
    pub token: HashedApiKey,
    pub salt: String,
    pub redacted: String,
    pub title: String,
    pub type_: ApiKeyType,
    pub last_used_at: Option<PrimitiveDateTime>,
    pub created_by: String,
    pub created_at: PrimitiveDateTime,
    pub revoked_by: Option<String>,
    pub revoked_at: Option<PrimitiveDateTime>,
}

#[derive(Clone, Debug, Insertable, Serialize, Deserialize, router_derive::DebugAsDisplay)]
#[diesel(table_name = api_key)]
pub struct ApiKeyNew {
    pub token: HashedApiKey,
    pub salt: String,
    pub redacted: String,
    pub title: String,
    pub type_: ApiKeyType,
    pub last_used_at: Option<PrimitiveDateTime>,
    pub created_by: String,
    pub created_at: PrimitiveDateTime,
    pub revoked_by: Option<String>,
    pub revoked_at: Option<PrimitiveDateTime>,
}

#[derive(Debug, Clone)]
pub enum ApiKeyUpdate {
    Update {
        title: Option<String>,
        type_: Option<ApiKeyType>,
        last_used_at: Option<Option<PrimitiveDateTime>>,
        revoked_by: Option<Option<String>>,
        revoked_at: Option<Option<PrimitiveDateTime>>,
    },
    Upsert {
        token: Option<HashedApiKey>,
        salt: Option<String>,
        redacted: Option<String>,
        title: Option<String>,
        type_: Option<ApiKeyType>,
        created_by: Option<String>,
        created_at: Option<PrimitiveDateTime>,
        last_used_at: Option<Option<PrimitiveDateTime>>,
        revoked_by: Option<Option<String>>,
        revoked_at: Option<Option<PrimitiveDateTime>>,
    },
    Revoke {
        revoked_by: Option<String>,
        revoked_at: Option<PrimitiveDateTime>,
    },
    LastUsedUpdate {
        last_used_at: Option<PrimitiveDateTime>,
    },
}

#[derive(Debug, AsChangeset)]
#[diesel(table_name = api_key)]
pub struct ApiKeyUpdateInternal {
    pub token: Option<HashedApiKey>,
    pub salt: Option<String>,
    pub redacted: Option<String>,
    pub title: Option<String>,
    pub type_: Option<ApiKeyType>,
    pub created_by: Option<String>,
    pub created_at: Option<PrimitiveDateTime>,
    pub last_used_at: Option<Option<PrimitiveDateTime>>,
    pub revoked_by: Option<Option<String>>,
    pub revoked_at: Option<Option<PrimitiveDateTime>>,
}

impl From<ApiKeyUpdate> for ApiKeyUpdateInternal {
    fn from(api_key_update: ApiKeyUpdate) -> Self {
        match api_key_update {
            ApiKeyUpdate::Update {
                title,
                type_,
                last_used_at,
                revoked_by,
                revoked_at,
            } => Self {
                token: None,
                salt: None,
                redacted: None,
                title,
                type_,
                created_at: None,
                created_by: None,
                last_used_at,
                revoked_by,
                revoked_at,
            },
            ApiKeyUpdate::Upsert {
                token,
                salt,
                redacted,
                title,
                type_,
                created_at,
                created_by,
                last_used_at,
                revoked_by,
                revoked_at,
            } => Self {
                token,
                salt,
                redacted,
                title,
                type_,
                created_at,
                created_by,
                last_used_at,
                revoked_by,
                revoked_at,
            },
            ApiKeyUpdate::Revoke {
                revoked_by,
                revoked_at,
            } => Self {
                token: None,
                salt: None,
                redacted: None,
                title: None,
                type_: None,
                created_at: None,
                created_by: None,
                last_used_at: None,
                revoked_by: Some(revoked_by),
                revoked_at: Some(revoked_at),
            },
            ApiKeyUpdate::LastUsedUpdate { last_used_at } => Self {
                token: None,
                salt: None,
                redacted: None,
                title: None,
                type_: None,
                created_at: None,
                created_by: None,
                last_used_at: Some(last_used_at),
                revoked_by: None,
                revoked_at: None,
            },
        }
    }
}

impl TryFrom<ApiKeyUpdateInternal> for ApiKeyNew {
    type Error = &'static str; // Define an appropriate error type

    fn try_from(api_key_update: ApiKeyUpdateInternal) -> Result<Self, Self::Error> {
        Ok(Self {
            token: api_key_update.token.ok_or("token is required")?,
            salt: api_key_update.salt.ok_or("salt is required")?,
            redacted: api_key_update.redacted.ok_or("redacted is required")?,
            title: api_key_update.title.ok_or("title is required")?,
            type_: api_key_update.type_.ok_or("type is required")?,
            last_used_at: api_key_update
                .last_used_at
                .ok_or("last_used_at is required")?,
            created_by: api_key_update.created_by.ok_or("created_by is required")?, // Provide a default value or handle this differently
            created_at: api_key_update.created_at.ok_or("created_at is required")?, // Provide a default value or handle this differently
            revoked_by: api_key_update.revoked_by.ok_or("revoked_by is required")?,
            revoked_at: api_key_update.revoked_at.ok_or("revoked_at is required")?,
        })
    }
}

#[derive(serde::Serialize, serde::Deserialize, Debug, Clone, AsExpression, PartialEq)]
#[diesel(sql_type = diesel::sql_types::Text)]
pub struct HashedApiKey(String);

impl HashedApiKey {
    pub fn into_inner(self) -> String {
        self.0
    }
}

impl From<String> for HashedApiKey {
    fn from(hashed_api_key: String) -> Self {
        Self(hashed_api_key)
    }
}

mod diesel_impl {
    use diesel::{
        backend::Backend,
        deserialize::FromSql,
        serialize::{Output, ToSql},
        sql_types::Text,
        Queryable,
    };

    impl<DB> ToSql<Text, DB> for super::HashedApiKey
    where
        DB: Backend,
        String: ToSql<Text, DB>,
    {
        fn to_sql<'b>(&'b self, out: &mut Output<'b, '_, DB>) -> diesel::serialize::Result {
            self.0.to_sql(out)
        }
    }

    impl<DB> FromSql<Text, DB> for super::HashedApiKey
    where
        DB: Backend,
        String: FromSql<Text, DB>,
    {
        fn from_sql(bytes: DB::RawValue<'_>) -> diesel::deserialize::Result<Self> {
            Ok(Self(String::from_sql(bytes)?))
        }
    }

    impl<DB> Queryable<Text, DB> for super::HashedApiKey
    where
        DB: Backend,
        Self: FromSql<Text, DB>,
    {
        type Row = Self;

        fn build(row: Self::Row) -> diesel::deserialize::Result<Self> {
            Ok(row)
        }
    }
}
