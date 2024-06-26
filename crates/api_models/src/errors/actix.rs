use super::types::ApiErrorResponse;

impl actix_web::ResponseError for ApiErrorResponse {
    fn status_code(&self) -> actix_web::http::StatusCode {
        use actix_web::http::StatusCode;

        match self {
            Self::Unauthorized(_) => StatusCode::UNAUTHORIZED,
            Self::ForbiddenCommonResource(_) => StatusCode::FORBIDDEN,
            Self::ForbiddenPrivateResource(_) => StatusCode::NOT_FOUND,
            Self::Conflict(_) => StatusCode::CONFLICT,
            Self::Gone(_) => StatusCode::GONE,
            Self::Unprocessable(_) => StatusCode::UNPROCESSABLE_ENTITY,
            Self::InternalServerError(_) => StatusCode::INTERNAL_SERVER_ERROR,
            Self::NotImplemented(_) => StatusCode::NOT_IMPLEMENTED,
            Self::ConnectorError(_, code) => *code,
            Self::MethodNotAllowed(_) => StatusCode::METHOD_NOT_ALLOWED,
            Self::NotFound(_) => StatusCode::NOT_FOUND,
            Self::BadRequest(_) => StatusCode::BAD_REQUEST,
            Self::DomainError(_) => StatusCode::OK,
        }
    }

    fn error_response(&self) -> actix_web::HttpResponse {
        use actix_web::http::header;

        actix_web::HttpResponseBuilder::new(self.status_code())
            .insert_header((header::CONTENT_TYPE, mime::APPLICATION_JSON))
            .body(self.to_string())
    }
}
