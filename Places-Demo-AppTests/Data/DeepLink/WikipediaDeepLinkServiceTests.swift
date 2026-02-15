//
//  WikipediaDeepLinkServiceTests.swift
//  Places-Demo-AppTests
//

import Foundation
import Testing
@testable import Places_Demo_App

@Suite("WikipediaPlacesURLBuilder, WikipediaDeepLinkService and WikipediaDeepLinkAdapter")
struct WikipediaDeepLinkServiceTests {

    @Test("WikipediaPlacesURLBuilder builds URL with scheme wikipedia and host places and name query when location has name")
    func urlBuilder_withName() throws {
        let location = Location(name: "Amsterdam", latitude: 52.37, longitude: 4.89)
        let url = WikipediaPlacesURLBuilder.build(for: location)
        #expect(url != nil)
        let u = try #require(url)
        #expect(u.scheme == "wikipedia")
        #expect(u.host == "places")
        let components = URLComponents(url: u, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        #expect(queryItems.contains { $0.name == "lat" && $0.value == "52.37" })
        #expect(queryItems.contains { $0.name == "long" && $0.value == "4.89" })
        #expect(queryItems.contains { $0.name == "name" && $0.value == "Amsterdam" })
    }

    @Test("WikipediaPlacesURLBuilder builds URL without name query when location name is nil")
    func urlBuilder_withoutName() throws {
        let location = Location(name: nil, latitude: 52.0, longitude: 5.0)
        let url = WikipediaPlacesURLBuilder.build(for: location)
        #expect(url != nil)
        let u = try #require(url)
        #expect(u.scheme == "wikipedia")
        #expect(u.host == "places")
        let components = URLComponents(url: u, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        #expect(queryItems.contains { $0.name == "lat" })
        #expect(queryItems.contains { $0.name == "long" })
        #expect(!queryItems.contains { $0.name == "name" })
    }

    @Test("WikipediaDeepLinkService openPlaces succeeds and opens URL when deep link service succeeds")
    func wikipediaService_openSucceeds() async throws {
        let mockDeepLink = MockDeepLinkService()
        let service = WikipediaDeepLinkService(deepLinkService: mockDeepLink)
        let location = Location(name: "Paris", latitude: 48.85, longitude: 2.35)

        try await service.openPlaces(at: location)

        #expect(mockDeepLink.openedURLs.count == 1)
        let opened = try #require(mockDeepLink.openedURLs.first)
        #expect(opened.scheme == "wikipedia")
        #expect(opened.host == "places")
    }

    @Test("WikipediaDeepLinkService openPlaces throws appNotInstalled Wikipedia when deep link service throws")
    func wikipediaService_openThrows() async {
        let mockDeepLink = MockDeepLinkService()
        mockDeepLink.errorToThrow = DeepLinkError.appNotInstalled(appName: nil)
        let service = WikipediaDeepLinkService(deepLinkService: mockDeepLink)
        let location = Location(name: "Berlin", latitude: 52.52, longitude: 13.40)

        do {
            try await service.openPlaces(at: location)
            #expect(Bool(false), "Expected throw")
        } catch let error as DeepLinkError {
            if case .appNotInstalled(let name) = error {
                #expect(name == "Wikipedia")
            } else {
                #expect(Bool(false), "Expected appNotInstalled Wikipedia, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected DeepLinkError, got \(error)")
        }
    }

    @Test("WikipediaDeepLinkAdapter openPlaces propagates success")
    func adapter_success() async throws {
        let mockWiki = MockWikipediaDeepLinkService()
        let adapter = WikipediaDeepLinkAdapter(deepLinkService: mockWiki)
        let location = Location(name: "Rome", latitude: 41.9, longitude: 12.5)

        try await adapter.openPlaces(at: location)

        #expect(mockWiki.openedLocations.count == 1)
    }

    @Test("WikipediaDeepLinkAdapter maps urlCreationFailed to OpenWikipediaError.urlCreationFailed")
    func adapter_mapsUrlCreationFailed() async {
        let mockWiki = MockWikipediaDeepLinkService()
        mockWiki.errorToThrow = DeepLinkError.urlCreationFailed
        let adapter = WikipediaDeepLinkAdapter(deepLinkService: mockWiki)
        let location = Location(name: "X", latitude: 0, longitude: 0)

        do {
            try await adapter.openPlaces(at: location)
            #expect(Bool(false), "Expected throw")
        } catch let error as OpenWikipediaError {
            if case .urlCreationFailed = error { } else {
                #expect(Bool(false), "Expected urlCreationFailed, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected OpenWikipediaError, got \(error)")
        }
    }

    @Test("WikipediaDeepLinkAdapter maps cannotOpenURL to OpenWikipediaError.cannotOpenURL")
    func adapter_mapsCannotOpenURL() async {
        let mockWiki = MockWikipediaDeepLinkService()
        mockWiki.errorToThrow = DeepLinkError.cannotOpenURL
        let adapter = WikipediaDeepLinkAdapter(deepLinkService: mockWiki)
        let location = Location(name: "X", latitude: 0, longitude: 0)

        do {
            try await adapter.openPlaces(at: location)
            #expect(Bool(false), "Expected throw")
        } catch let error as OpenWikipediaError {
            if case .cannotOpenURL = error { } else {
                #expect(Bool(false), "Expected cannotOpenURL, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected OpenWikipediaError, got \(error)")
        }
    }

    @Test("WikipediaDeepLinkAdapter maps appNotInstalled to OpenWikipediaError.appNotInstalled")
    func adapter_mapsAppNotInstalled() async {
        let mockWiki = MockWikipediaDeepLinkService()
        mockWiki.errorToThrow = DeepLinkError.appNotInstalled(appName: "Wikipedia")
        let adapter = WikipediaDeepLinkAdapter(deepLinkService: mockWiki)
        let location = Location(name: "X", latitude: 0, longitude: 0)

        do {
            try await adapter.openPlaces(at: location)
            #expect(Bool(false), "Expected throw")
        } catch let error as OpenWikipediaError {
            if case .appNotInstalled(let name) = error {
                #expect(name == "Wikipedia")
            } else {
                #expect(Bool(false), "Expected appNotInstalled, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected OpenWikipediaError, got \(error)")
        }
    }
}
