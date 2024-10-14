extension Error {
    internal func toResponseError() -> NetworkError {
        if let responseError = self as? NetworkError {
            return responseError
        } else {
            return .genericError(error: self)
        }
    }
}
