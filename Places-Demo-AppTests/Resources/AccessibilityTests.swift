//
//  AccessibilityTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@Suite("AccessibilityID locationRow and raw values")
struct AccessibilityTests {

    @Test("locationRow returns locationRowPrefix plus id")
    func locationRow() {
        #expect(AccessibilityID.locationRow(id: "abc") == "locationRow-abc")
        #expect(AccessibilityID.locationRow(id: "123") == AccessibilityID.locationRowPrefix + "123")
    }

    @Test("locationRowPrefix is stable")
    func locationRowPrefix() {
        #expect(AccessibilityID.locationRowPrefix == "locationRow-")
    }
}
