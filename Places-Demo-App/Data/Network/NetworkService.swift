import Foundation

final class NetworkService: NetworkServiceProtocol {

    private let session: URLSession
    private let configuration: NetworkConfiguration
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        configuration: NetworkConfiguration,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.configuration = configuration
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T {
        let request = try endpoint.urlRequest(with: configuration)

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
            throw NetworkError.decodingError(error)
        }
    }
}
