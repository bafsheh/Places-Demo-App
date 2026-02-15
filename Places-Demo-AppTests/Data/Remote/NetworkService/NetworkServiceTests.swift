//
//  NetworkServiceTests.swift
//  Places-Demo-AppTests
//

import Foundation
import Testing
@testable import Places_Demo_App

@Suite("NetworkService request success and failure modes")
struct NetworkServiceTests {

    private let path = "/abnamrocoesd/assignment-ios/main/locations.json"

    private func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    private func registerMock(baseURL: String, response: URLResponse?, data: Data?, error: Error?) {
        let key = baseURL + path
        MockURLProtocol.setResult(MockURLProtocol.MockResult(response: response, data: data, error: error), forKey: key)
    }

    @Test("request returns decoded value when response is 2xx and valid JSON")
    func request_success() async throws {
        let baseURL = "https://success.test"
        let json = """
        {"locations":[{"name":"Test","lat":52.0,"long":4.0}]}
        """
        registerMock(
            baseURL: baseURL,
            response: HTTPURLResponse(
                url: URL(string: baseURL + path)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            ),
            data: json.data(using: .utf8),
            error: nil
        )
        defer { MockURLProtocol.removeResult(forKey: baseURL + path) }
        let config = NetworkConfiguration(baseURL: baseURL)
        let service = NetworkService(session: makeSession(), configuration: config)
        let endpoint = LocationsEndpoint.locations

        let response: LocationsResponse = try await service.request(endpoint)

        #expect(response.locations.count == 1)
        #expect(response.locations[0].name == "Test")
    }

    @Test("request throws httpError when status code is 404")
    func request_httpError() async {
        let baseURL = "https://httperror.test"
        registerMock(
            baseURL: baseURL,
            response: HTTPURLResponse(
                url: URL(string: baseURL + path)!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            ),
            data: Data(),
            error: nil
        )
        defer { MockURLProtocol.removeResult(forKey: baseURL + path) }
        let config = NetworkConfiguration(baseURL: baseURL)
        let service = NetworkService(session: makeSession(), configuration: config)
        let endpoint = LocationsEndpoint.locations

        do {
            let _: LocationsResponse = try await service.request(endpoint)
            #expect(Bool(false), "Expected throw")
        } catch let error as NetworkError {
            if case .httpError(let code) = error {
                #expect(code == 404)
            } else {
                #expect(Bool(false), "Expected httpError 404, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError, got \(error)")
        }
    }

    @Test("request throws decodingError when response body is invalid JSON")
    func request_decodingError() async {
        let baseURL = "https://decodeerror.test"
        registerMock(
            baseURL: baseURL,
            response: HTTPURLResponse(
                url: URL(string: baseURL + path)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ),
            data: "not json".data(using: .utf8),
            error: nil
        )
        defer { MockURLProtocol.removeResult(forKey: baseURL + path) }
        let config = NetworkConfiguration(baseURL: baseURL)
        let service = NetworkService(session: makeSession(), configuration: config)
        let endpoint = LocationsEndpoint.locations

        do {
            let _: LocationsResponse = try await service.request(endpoint)
            #expect(Bool(false), "Expected throw")
        } catch let error as NetworkError {
            if case .decodingError = error { } else {
                #expect(Bool(false), "Expected decodingError, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError, got \(error)")
        }
    }

    @Test("request throws networkFailure when URLSession transport fails")
    func request_transportError() async {
        let baseURL = "https://transport.test"
        registerMock(
            baseURL: baseURL,
            response: nil,
            data: nil,
            error: URLError(.notConnectedToInternet)
        )
        defer { MockURLProtocol.removeResult(forKey: baseURL + path) }
        let config = NetworkConfiguration(baseURL: baseURL)
        let service = NetworkService(session: makeSession(), configuration: config)
        let endpoint = LocationsEndpoint.locations

        do {
            let _: LocationsResponse = try await service.request(endpoint)
            #expect(Bool(false), "Expected throw")
        } catch let error as NetworkError {
            if case .networkFailure = error { } else {
                #expect(Bool(false), "Expected networkFailure, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError, got \(error)")
        }
    }

    @Test("request throws unknown when response is not HTTPURLResponse")
    func request_unknown() async {
        let baseURL = "https://unknown.test"
        registerMock(
            baseURL: baseURL,
            response: URLResponse(
                url: URL(string: baseURL + path)!,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            ),
            data: Data(),
            error: nil
        )
        defer { MockURLProtocol.removeResult(forKey: baseURL + path) }
        let config = NetworkConfiguration(baseURL: baseURL)
        let service = NetworkService(session: makeSession(), configuration: config)
        let endpoint = LocationsEndpoint.locations

        do {
            let _: LocationsResponse = try await service.request(endpoint)
            #expect(Bool(false), "Expected throw")
        } catch let error as NetworkError {
            if case .unknown = error { } else {
                #expect(Bool(false), "Expected unknown, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError, got \(error)")
        }
    }
}
