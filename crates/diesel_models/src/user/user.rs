use crate::schema::user;
use diesel::{
    associations::Identifiable, deserialize::Queryable, prelude::Insertable,
    query_builder::AsChangeset,
};
use serde::{Deserialize, Serialize};
use time::PrimitiveDateTime;

#[derive(Clone, Debug, Queryable, Identifiable, Serialize, Deserialize, AsChangeset)]
#[diesel(table_name = user, primary_key(id))]
pub struct User {
    pub id: String,
    pub first_name: Option<String>,
    pub last_name: Option<String>,
    pub email: String,
    pub avatar_url: Option<String>,
    pub metadata: Option<serde_json::Value>,
    pub created_at: PrimitiveDateTime,
    pub updated_at: PrimitiveDateTime,
    pub deleted_at: Option<PrimitiveDateTime>,
}

#[derive(Clone, Debug, Insertable, Serialize, Deserialize, router_derive::DebugAsDisplay)]
#[diesel(table_name = user)]
pub struct UserNew {
    pub first_name: Option<String>,
    pub last_name: Option<String>,
    pub email: String,
    pub avatar_url: Option<String>,
    pub metadata: Option<serde_json::Value>,
    pub created_at: PrimitiveDateTime,
    pub updated_at: PrimitiveDateTime,
    pub deleted_at: Option<PrimitiveDateTime>,
}

#[derive(Clone, Debug, AsChangeset, router_derive::DebugAsDisplay)]
#[diesel(table_name = user)]
pub struct UserUpdateInternal {
    pub id: Option<String>,
    pub first_name: Option<Option<String>>,
    pub last_name: Option<Option<String>>,
    pub avatar_url: Option<Option<String>>,
    pub metadata: Option<Option<serde_json::Value>>,
    pub updated_at: Option<PrimitiveDateTime>,
}

#[derive(Debug, Clone)]
pub enum UserUpdate {
    Update {
        id: Option<String>,
        first_name: Option<Option<String>>,
        last_name: Option<Option<String>>,
        avatar_url: Option<Option<String>>,
        metadata: Option<Option<serde_json::Value>>,
        updated_at: Option<PrimitiveDateTime>,
    },
}

impl From<UserUpdate> for UserUpdateInternal {
    fn from(update: UserUpdate) -> Self {
        match update {
            UserUpdate::Update {
                id,
                first_name,
                last_name,
                avatar_url,
                metadata,
                updated_at,
            } => UserUpdateInternal {
                id,
                first_name,
                last_name,
                avatar_url,
                metadata,
                updated_at,
            },
        }
    }
}
