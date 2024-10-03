import Foundation

struct BaseResponse<T: Codable>: Codable {
    public let payload: T?
    public let errors: ResponseError?
    public let timeStamp: String?
    public let success: Bool?
}
