//
//  NetworkConfigurationTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@Suite("NetworkConfiguration init and default")
struct NetworkConfigurationTests {

    @Test("init stores baseURL headers and timeout")
    func init_storesValues() {
        let config = NetworkConfiguration(
            baseURL: "https://api.test.com",
            headers: ["X-Custom": "value"],
            timeout: 10
        )
        #expect(config.baseURL == "https://api.test.com")
        #expect(config.headers["X-Custom"] == "value")
        #expect(config.timeout == 10)
    }

    @Test("default uses AppConfiguration apiBaseURL and sets JSON headers")
    func default_usesAppConfigAndHeaders() {
        let config = NetworkConfiguration.default
        #expect(config.baseURL == AppConfiguration.apiBaseURL)
        #expect(config.headers["Content-Type"] == "application/json")
        #expect(config.headers["Accept"] == "application/json")
    }
}
