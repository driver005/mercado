use crate::enums::ApiKeyType;
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;

#[derive(Debug, Deserialize, ToSchema, Serialize)]
#[serde(deny_unknown_fields)]
pub struct RetrieveApiKeyRequest;

#[derive(Debug, Deserialize, ToSchema, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ListApiKeyRequest {
    pub id: Option<Vec<String>>,

    pub title: Option<Vec<String>>,

    pub token: Option<Vec<String>>,

    #[serde(rename = "type")]
    pub type_: Option<ApiKeyType>,

    #[serde(rename = "$and")]
    pub and: Option<Vec<ListApiKeyRequest>>,

    #[serde(rename = "$or")]
    pub or: Option<Vec<ListApiKeyRequest>>,

    #[serde(default = "crate::utils::default_offset")]
    pub offset: Option<u32>,

    #[serde(default = "crate::utils::default_limit")]
    pub limit: Option<u32>,

    pub order: Option<String>,
}

#[derive(Debug, Deserialize, ToSchema, Serialize)]
#[serde(deny_unknown_fields)]
pub struct CreateApiKeyRequest {
    pub title: String,

    #[serde(rename = "type")]
    pub type_: ApiKeyType,
}

#[derive(Debug, Deserialize, ToSchema, Serialize)]
#[serde(deny_unknown_fields)]
pub struct UpdateApiKeyRequest {
    pub title: String,
}

#[derive(Debug, Deserialize, ToSchema, Serialize)]
#[serde(deny_unknown_fields)]
pub struct RevokeApiKeyRequest {
    pub revoke_in: Option<u32>,
}

#[derive(Debug, Deserialize, ToSchema, Serialize)]
#[serde(deny_unknown_fields)]
pub struct DeleteApiKeyRequest {}

#[derive(Debug, Deserialize, ToSchema, Serialize)]
#[serde(deny_unknown_fields)]
pub struct AddApiKeyToSalesChannelsRequest {
    pub sales_channel_ids: Vec<String>,
}
