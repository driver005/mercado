use crate::schema::invite;
use diesel::{
    associations::Identifiable, deserialize::Queryable, prelude::Insertable,
    query_builder::AsChangeset,
};
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

#[derive(Clone, Debug, AsChangeset, router_derive::DebugAsDisplay)]
#[diesel(table_name = invite)]
pub struct InviteUpdateInternal {
    id: Option<String>,
    accepted: Option<bool>,
    metadata: Option<Option<serde_json::Value>>,
    updated_at: Option<PrimitiveDateTime>,
}

#[derive(Debug, Clone)]
pub enum InviteUpdate {
    Update {
        id: Option<String>,
        accepted: Option<bool>,
        metadata: Option<Option<serde_json::Value>>,
    },
}

impl From<InviteUpdate> for InviteUpdateInternal {
    fn from(update: InviteUpdate) -> Self {
        match update {
            InviteUpdate::Update {
                id,
                accepted,
                metadata,
            } => Self {
                id,
                accepted,
                metadata,
                updated_at: None,
            },
        }
    }
}
