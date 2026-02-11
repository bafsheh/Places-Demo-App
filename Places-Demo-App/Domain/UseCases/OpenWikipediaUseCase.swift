import Foundation

/// Protocol for opening Wikipedia at a location. Allows injection of mocks in tests.
protocol OpenWikipediaUseCaseProtocol: Sendable {
    /// Opens Wikipedia Places tab at the specified location.
    func execute(location: Location) async throws
}

/// Use case responsible for opening Wikipedia app with deep link.
final class OpenWikipediaUseCase: OpenWikipediaUseCaseProtocol {

    private let deepLinkService: WikipediaDeepLinkServiceProtocol

    init(deepLinkService: WikipediaDeepLinkServiceProtocol) {
        self.deepLinkService = deepLinkService
    }

    /// Opens Wikipedia Places tab at the specified location
    func execute(location: Location) async throws {
        try await deepLinkService.openPlaces(at: location)
    }
}
