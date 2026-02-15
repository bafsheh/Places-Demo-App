//
//  AddLocationViewModelTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite("AddLocationViewModel validation, submit and cancel")
struct AddLocationViewModelTests {

    // MARK: - Dependencies.makeAddLocationViewModel

    @Test("makeAddLocationViewModel returns view model that on valid submit resumes continuation with Location")
    func makeAddLocationViewModel_validSubmit() async throws {
        let deps = TestDependencies.make()
        var showErrorAfterSubmit = false
        let resultOpt = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = deps.makeAddLocationViewModel(continuation: continuation)
            vm.name = "Amsterdam"
            vm.latitude = "52.37"
            vm.longitude = "4.89"
            vm.submit()
            showErrorAfterSubmit = vm.showError
        }

        let result = try #require(resultOpt)
        #expect(result.name == "Amsterdam")
        #expect(abs(result.coordinate.latitude - 52.37) < 0.001)
        #expect(abs(result.coordinate.longitude - 4.89) < 0.001)
        #expect(!showErrorAfterSubmit)
    }

    @Test("makeAddLocationViewModel returns view model that on cancel resumes continuation with nil")
    func makeAddLocationViewModel_cancel() async {
        let deps = TestDependencies.make()
        let result = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = deps.makeAddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "4.0"
            vm.cancel()
        }
        #expect(result == nil)
    }

    // MARK: - Validation and behavior

    @Test("submit with valid coordinates resumes continuation with Location and does not set showError")
    func validation_validCoordinates() async throws {
        var showErrorAfterSubmit = false
        let resultOpt = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "4.0"
            vm.submit()
            showErrorAfterSubmit = vm.showError
        }

        let result = try #require(resultOpt)
        #expect(result.name == "Test")
        #expect(abs(result.coordinate.latitude - 52.0) < 0.001)
        #expect(abs(result.coordinate.longitude - 4.0) < 0.001)
        #expect(!showErrorAfterSubmit)
    }

    @Test("submit with latitude above 90 sets showError")
    func validation_invalidLatitude_tooHigh() async {
        var showErrorValue = false

        let result = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "91.0"
            vm.longitude = "4.0"
            vm.submit()
            showErrorValue = vm.showError
            vm.cancel()
        }

        #expect(result == nil)
        #expect(showErrorValue)
    }

    @Test("submit with latitude below -90 sets showError")
    func validation_invalidLatitude_tooLow() async {
        var showErrorValue = false

        let result = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "-91.0"
            vm.longitude = "4.0"
            vm.submit()
            showErrorValue = vm.showError
            vm.cancel()
        }

        #expect(result == nil)
        #expect(showErrorValue)
    }

    @Test("submit with longitude above 180 sets showError")
    func validation_invalidLongitude_tooHigh() async {
        var showErrorValue = false

        let result = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "181.0"
            vm.submit()
            showErrorValue = vm.showError
            vm.cancel()
        }

        #expect(result == nil)
        #expect(showErrorValue)
    }

    @Test("submit with longitude below -180 sets showError")
    func validation_invalidLongitude_tooLow() async {
        var showErrorValue = false

        let result = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "-181.0"
            vm.submit()
            showErrorValue = vm.showError
            vm.cancel()
        }

        #expect(result == nil)
        #expect(showErrorValue)
    }

    @Test("submit with non-numeric latitude sets showError")
    func validation_invalidNumber() async {
        var showErrorValue = false

        let result = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "not a number"
            vm.longitude = "4.0"
            vm.submit()
            showErrorValue = vm.showError
            vm.cancel()
        }

        #expect(result == nil)
        #expect(showErrorValue)
    }

    @Test("cancel resumes continuation with nil and does not set showError")
    func cancel() async {
        var showErrorValue = false
        let result = await withCheckedContinuation { (continuation: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(continuation: continuation)
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "4.0"
            vm.cancel()
            showErrorValue = vm.showError
        }

        #expect(result == nil)
        #expect(!showErrorValue)
    }
}
