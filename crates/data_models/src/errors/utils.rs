use crate::errors;

pub trait StorageErrorExt<T, E> {
    #[track_caller]
    fn to_not_found_response(self, not_found_response: E) -> error_stack::Result<T, E>;

    #[track_caller]
    fn to_duplicate_response(self, duplicate_response: E) -> error_stack::Result<T, E>;
}

impl<T> StorageErrorExt<T, errors::CustomersErrorResponse>
    for error_stack::Result<T, errors::StorageError>
{
    #[track_caller]
    fn to_not_found_response(
        self,
        not_found_response: errors::CustomersErrorResponse,
    ) -> error_stack::Result<T, errors::CustomersErrorResponse> {
        self.map_err(|err| match err.current_context() {
            error if error.is_db_not_found() => err.change_context(not_found_response),
            errors::StorageError::CustomerRedacted => {
                err.change_context(errors::CustomersErrorResponse::CustomerRedacted)
            }
            _ => err.change_context(errors::CustomersErrorResponse::InternalServerError),
        })
    }

    fn to_duplicate_response(
        self,
        duplicate_response: errors::CustomersErrorResponse,
    ) -> error_stack::Result<T, errors::CustomersErrorResponse> {
        self.map_err(|err| {
            if err.current_context().is_db_unique_violation() {
                err.change_context(duplicate_response)
            } else {
                err.change_context(errors::CustomersErrorResponse::InternalServerError)
            }
        })
    }
}

impl<T> StorageErrorExt<T, errors::ApiErrorResponse>
    for error_stack::Result<T, errors::StorageError>
{
    #[track_caller]
    fn to_not_found_response(
        self,
        not_found_response: errors::ApiErrorResponse,
    ) -> error_stack::Result<T, errors::ApiErrorResponse> {
        self.map_err(|err| {
            let new_err = match err.current_context() {
                errors::StorageError::ValueNotFound(_) => not_found_response,
                errors::StorageError::CustomerRedacted => {
                    errors::ApiErrorResponse::CustomerRedacted
                }
                _ => errors::ApiErrorResponse::InternalServerError,
            };
            err.change_context(new_err)
        })
    }

    #[track_caller]
    fn to_duplicate_response(
        self,
        duplicate_response: errors::ApiErrorResponse,
    ) -> error_stack::Result<T, errors::ApiErrorResponse> {
        self.map_err(|err| {
            let new_err = match err.current_context() {
                errors::StorageError::DuplicateValue { .. } => duplicate_response,
                _ => errors::ApiErrorResponse::InternalServerError,
            };
            err.change_context(new_err)
        })
    }
}

// impl<T> StorageErrorExt<T, errors::ApiErrorResponse>
//     for error_stack::Result<T, errors::StorageError>
// {
//     #[track_caller]
//     fn to_not_found_response(
//         self,
//         not_found_response: errors::ApiErrorResponse,
//     ) -> error_stack::Result<T, errors::ApiErrorResponse> {
//         self.map_err(|err| {
//             if err.current_context().is_db_not_found() {
//                 return err.change_context(not_found_response);
//             };
//             match err.current_context() {
//                 errors::StorageError::CustomerRedacted => {
//                     err.change_context(errors::ApiErrorResponse::CustomerRedacted)
//                 }
//                 _ => err.change_context(errors::ApiErrorResponse::InternalServerError),
//             }
//         })
//     }

//     #[track_caller]
//     fn to_duplicate_response(
//         self,
//         duplicate_response: errors::ApiErrorResponse,
//     ) -> error_stack::Result<T, errors::ApiErrorResponse> {
//         self.map_err(|err| {
//             if err.current_context().is_db_unique_violation() {
//                 err.change_context(duplicate_response)
//             } else {
//                 err.change_context(errors::ApiErrorResponse::InternalServerError)
//             }
//         })
//     }
// }

pub trait RedisErrorExt {
    #[track_caller]
    fn to_redis_failed_response(self, key: &str) -> error_stack::Report<errors::StorageError>;
}

impl RedisErrorExt for error_stack::Report<redis_interface::errors::RedisError> {
    fn to_redis_failed_response(self, key: &str) -> error_stack::Report<errors::StorageError> {
        match self.current_context() {
            redis_interface::errors::RedisError::NotFound => self.change_context(
                errors::StorageError::ValueNotFound(format!("Data does not exist for key {key}",)),
            ),
            redis_interface::errors::RedisError::SetNxFailed => {
                self.change_context(errors::StorageError::DuplicateValue {
                    entity: "redis",
                    key: Some(key.to_string()),
                })
            }
            _ => self.change_context(errors::StorageError::KVError),
        }
    }
}

#[cfg(feature = "olap")]
impl<T> StorageErrorExt<T, errors::UserErrors> for error_stack::Result<T, errors::StorageError> {
    #[track_caller]
    fn to_not_found_response(
        self,
        not_found_response: errors::UserErrors,
    ) -> error_stack::Result<T, errors::UserErrors> {
        self.map_err(|e| {
            if e.current_context().is_db_not_found() {
                e.change_context(not_found_response)
            } else {
                e.change_context(errors::UserErrors::InternalServerError)
            }
        })
    }

    #[track_caller]
    fn to_duplicate_response(
        self,
        duplicate_response: errors::UserErrors,
    ) -> error_stack::Result<T, errors::UserErrors> {
        self.map_err(|e| {
            if e.current_context().is_db_unique_violation() {
                e.change_context(duplicate_response)
            } else {
                e.change_context(errors::UserErrors::InternalServerError)
            }
        })
    }
}
