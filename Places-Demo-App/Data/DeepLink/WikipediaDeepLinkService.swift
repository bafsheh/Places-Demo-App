import Foundation
import CoreLocation

/// Builds Wikipedia Places deep link URLs.
enum WikipediaPlacesURLBuilder: Sendable {

    private enum Constants {
        static let scheme = "wikipedia"
        static let host = "places"
    }

    /// Builds a `wikipedia://places` URL for the given location.
    static func build(for location: Location) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host

        var queryItems = [
            URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "long", value: String(location.coordinate.longitude))
        ]
        if let name = location.name {
            queryItems.append(URLQueryItem(name: "name", value: name))
        }
        components.queryItems = queryItems

        return components.url
    }
}

/// Protocol for opening Wikipedia Places deep links. Implementations use the generic deep link service.
protocol WikipediaDeepLinkServiceProtocol: Sendable {

    /// Opens Wikipedia Places tab at the specified location.
    func openPlaces(at location: Location) async throws
}

/// Wikipedia-specific deep link handler. Uses the generic DeepLinkService and Wikipedia URL builder.
final class WikipediaDeepLinkService: WikipediaDeepLinkServiceProtocol {

    private let deepLinkService: DeepLinkServiceProtocol

    init(deepLinkService: DeepLinkServiceProtocol) {
        self.deepLinkService = deepLinkService
    }

    func openPlaces(at location: Location) async throws {
        guard let url = WikipediaPlacesURLBuilder.build(for: location) else {
            throw DeepLinkError.urlCreationFailed
        }
        do {
            try await deepLinkService.open(url)
        } catch {
            throw DeepLinkError.appNotInstalled(appName: "Wikipedia")
        }
    }
}
