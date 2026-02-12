import Foundation

/// Endpoint for the locations API. Extracted so new entities can add their own endpoint types
/// without editing this file. To add a new remote entity: add a new DTO, response type,
/// endpoint type (e.g. FavoritesEndpoint), and a dedicated data source that uses it.
enum LocationsEndpoint: EndpointProtocol, Sendable {

    case locations

    var path: String {
        switch self {
        case .locations:
            return "/abnamrocoesd/assignment-ios/main/locations.json"
        }
    }

    var method: HTTPMethod {
        .get
    }

    func urlRequest(with configuration: NetworkConfiguration) throws -> URLRequest {
        guard let url = URL(string: configuration.baseURL + path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = configuration.timeout

        configuration.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
