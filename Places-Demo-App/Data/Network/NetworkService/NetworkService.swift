import Foundation

/// Actor that performs HTTP requests and decodes JSON responses.
/// Isolates network I/O and is safe to use from concurrent contexts.
actor NetworkService: NetworkServiceProtocol {

    private let session: URLSession
    private let configuration: NetworkConfiguration
    private let decoder: JSONDecoder

    /// Creates a network service with optional custom session and decoder.
    init(
        session: URLSession = .shared,
        configuration: NetworkConfiguration,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.configuration = configuration
        self.decoder = decoder
    }

    /// Performs a network request for the given endpoint and decodes the response.
    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T {
        let request = try await endpoint.urlRequest(with: configuration)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
}
