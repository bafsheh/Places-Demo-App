//
//  MockURLProtocol.swift
//  Places-Demo-AppTests
//
//  URLProtocol that returns configurable response/data/error per request URL for NetworkService tests.
//

import Foundation

final class MockURLProtocol: URLProtocol {

    struct MockResult {
        var response: URLResponse?
        var data: Data?
        var error: Error?
    }

    nonisolated(unsafe) static var mockResultsByURL: [String: MockResult] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let key = request.url?.absoluteString ?? ""
        let result = MockURLProtocol.mockResultsByURL[key] ?? MockResult()
        if let error = result.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        if let response = result.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        client?.urlProtocol(self, didLoad: result.data ?? Data())
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
