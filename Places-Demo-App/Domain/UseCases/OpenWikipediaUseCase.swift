import Foundation

/// Use case responsible for opening Wikipedia app with deep link
final class OpenWikipediaUseCase: Sendable {

    private let deepLinkService: WikipediaDeepLinkServiceProtocol

    init(deepLinkService: WikipediaDeepLinkServiceProtocol) {
        self.deepLinkService = deepLinkService
    }

    /// Opens Wikipedia Places tab at the specified location
    func execute(location: Location) async throws {
        try await deepLinkService.openPlaces(at: location)
    }
}
