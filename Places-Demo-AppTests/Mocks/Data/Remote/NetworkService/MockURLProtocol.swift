//
//  MockURLProtocol.swift
//  Places-Demo-AppTests
//
//  URLProtocol that returns configurable response/data/error per request URL for NetworkService tests.
//  Access is synchronized via lock so tests can run in parallel.
//

import Foundation

final class MockURLProtocol: URLProtocol {

    struct MockResult {
        var response: URLResponse?
        var data: Data?
        var error: Error?
    }

    private static let lock = NSLock()
    /// Backing storage; access is guarded by `lock`. Marked nonisolated(unsafe) because we synchronize externally.
    private nonisolated(unsafe) static var storage: [String: MockResult] = [:]

    /// Thread-safe: set mock result for a URL key. Use from tests before triggering the request.
    static func setResult(_ result: MockResult, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        storage[key] = result
    }

    /// Thread-safe: get mock result for a URL key.
    static func result(forKey key: String) -> MockResult {
        lock.lock()
        defer { lock.unlock() }
        return storage[key] ?? MockResult()
    }

    /// Thread-safe: remove mock result for a URL key. Use in defer from tests to clean up.
    static func removeResult(forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        storage.removeValue(forKey: key)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let key = request.url?.absoluteString ?? ""
        let result = MockURLProtocol.result(forKey: key)
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
