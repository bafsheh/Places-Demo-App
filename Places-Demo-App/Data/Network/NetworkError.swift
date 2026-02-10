import Foundation

enum NetworkError: LocalizedError, Sendable {
    case invalidURL
    case noData
    case decodingError(Error)
    case httpError(statusCode: Int)
    case networkFailure(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Decoding error"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .networkFailure:
            return "Network failure"
        case .unknown:
            return "Unknown error"
        }
    }
}
