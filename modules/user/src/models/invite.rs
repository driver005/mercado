use diesel::{
    associations::Identifiable, deserialize::Queryable, prelude::Insertable,
    query_builder::AsChangeset,
};
use diesel_models::schema::invite;
use serde::{Deserialize, Serialize};
use time::PrimitiveDateTime;

#[derive(Clone, Debug, Queryable, Identifiable, Serialize, Deserialize, AsChangeset)]
#[diesel(table_name = invite, primary_key(id))]
pub struct Invite {
    pub id: String,
    pub email: String,
    pub accepted: bool,
    pub token: String,
    pub expires_at: PrimitiveDateTime,
    pub metadata: Option<serde_json::Value>,
    pub created_at: PrimitiveDateTime,
    pub updated_at: PrimitiveDateTime,
    pub deleted_at: Option<PrimitiveDateTime>,
}

#[derive(Clone, Debug, Insertable, Serialize, Deserialize, router_derive::DebugAsDisplay)]
#[diesel(table_name = invite)]
pub struct InviteNew {
    pub email: String,
    pub accepted: bool,
    pub token: String,
    pub expires_at: PrimitiveDateTime,
    pub metadata: Option<serde_json::Value>,
    pub created_at: PrimitiveDateTime,
    pub updated_at: PrimitiveDateTime,
    pub deleted_at: Option<PrimitiveDateTime>,
}
