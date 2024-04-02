use diesel::{
    associations::Identifiable, deserialize::Queryable, prelude::Insertable,
    query_builder::AsChangeset,
};
use diesel_models::schema::user;
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
