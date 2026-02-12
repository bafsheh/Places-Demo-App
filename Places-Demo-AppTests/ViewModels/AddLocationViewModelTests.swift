//
//  AddLocationViewModelTests.swift
//  Places-Demo-AppTests
//
//  Purpose: Unit tests for AddLocationViewModel (validation, submit, cancel).
//  Dependencies: @testable Places_Demo_App, Location.
//

import CoreLocation
import Testing
@testable import Places_Demo_App

@MainActor
@Suite
struct AddLocationViewModelTests {

    // MARK: - validation_validCoordinates

    @Test
    func validation_validCoordinates() async throws {
        // Given: name="Test", lat="52.0", long="4.0"
        var showErrorAfterSubmit = false
        let resultOpt = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "4.0"
            vm.submit()
            showErrorAfterSubmit = vm.showError
        }

        // Then: continuation resumes with Location; showError is false
        let result = try #require(resultOpt)
        #expect(result.name == "Test")
        #expect(abs(result.coordinate.latitude - 52.0) < 0.001)
        #expect(abs(result.coordinate.longitude - 4.0) < 0.001)
        #expect(!showErrorAfterSubmit)
    }

    // MARK: - validation_invalidLatitude_tooHigh

    @Test
    func validation_invalidLatitude_tooHigh() async {
        // Given: lat="91.0"
        var showErrorValue = false
        _ = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "91.0"
            vm.longitude = "4.0"
            vm.submit()
            showErrorValue = vm.showError
            Task {
                try? await Task.sleep(nanoseconds: 50_000_000)
                continuation.resume(returning: nil)
            }
        }

        // Then: showError is true
        #expect(showErrorValue)
    }

    // MARK: - validation_invalidLatitude_tooLow

    @Test
    func validation_invalidLatitude_tooLow() async {
        // Given: lat="-91.0"
        var showErrorValue = false
        _ = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "-91.0"
            vm.longitude = "4.0"
            vm.submit()
            showErrorValue = vm.showError
            Task {
                try? await Task.sleep(nanoseconds: 50_000_000)
                continuation.resume(returning: nil)
            }
        }

        #expect(showErrorValue)
    }

    // MARK: - validation_invalidLongitude_tooHigh

    @Test
    func validation_invalidLongitude_tooHigh() async {
        // Given: long="181.0"
        var showErrorValue = false
        _ = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "181.0"
            vm.submit()
            showErrorValue = vm.showError
            Task {
                try? await Task.sleep(nanoseconds: 50_000_000)
                continuation.resume(returning: nil)
            }
        }

        #expect(showErrorValue)
    }

    // MARK: - validation_invalidLongitude_tooLow

    @Test
    func validation_invalidLongitude_tooLow() async {
        // Given: long="-181.0"
        var showErrorValue = false
        _ = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "-181.0"
            vm.submit()
            showErrorValue = vm.showError
            Task {
                try? await Task.sleep(nanoseconds: 50_000_000)
                continuation.resume(returning: nil)
            }
        }

        #expect(showErrorValue)
    }

    // MARK: - validation_invalidNumber

    @Test
    func validation_invalidNumber() async {
        // Given: lat="not a number"
        var showErrorValue = false
        _ = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "not a number"
            vm.longitude = "4.0"
            vm.submit()
            showErrorValue = vm.showError
            Task {
                try? await Task.sleep(nanoseconds: 50_000_000)
                continuation.resume(returning: nil)
            }
        }

        #expect(showErrorValue)
    }

    // MARK: - cancel

    @Test
    func cancel() async {
        // When: cancel() called
        var showErrorValue = false
        let result = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "4.0"
            vm.cancel()
            showErrorValue = vm.showError
        }

        // Then: continuation resumes with nil; showError is false
        #expect(result == nil)
        #expect(!showErrorValue)
    }
}
