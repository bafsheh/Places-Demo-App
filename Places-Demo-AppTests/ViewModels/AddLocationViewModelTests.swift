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

    @Test("makeAddLocationViewModel returns view model that on valid submit calls onComplete with Location")
    func makeAddLocationViewModel_validSubmit() async throws {
        let deps = TestDependencies.make()
        var showErrorAfterSubmit = false
        let resultOpt = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
            let vm = deps.makeAddLocationViewModel(onComplete: { cont.resume(returning: $0) })
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

    @Test("makeAddLocationViewModel returns view model that on cancel calls onComplete with nil")
    func makeAddLocationViewModel_cancel() async {
        let deps = TestDependencies.make()
        let result = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
            let vm = deps.makeAddLocationViewModel(onComplete: { cont.resume(returning: $0) })
            vm.name = "Test"
            vm.latitude = "52.0"
            vm.longitude = "4.0"
            vm.cancel()
        }
        #expect(result == nil)
    }

    // MARK: - Validation and behavior

    @Test("submit with valid coordinates calls onComplete with Location and does not set showError")
    func validation_validCoordinates() async throws {
        var showErrorAfterSubmit = false
        let resultOpt = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(onComplete: { cont.resume(returning: $0) })
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

        let result = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(onComplete: { cont.resume(returning: $0) })
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

        let result = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(onComplete: { cont.resume(returning: $0) })
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

        let result = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(onComplete: { cont.resume(returning: $0) })
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

        let result = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(onComplete: { cont.resume(returning: $0) })
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

        let result = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(onComplete: { cont.resume(returning: $0) })
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

    @Test("cancel calls onComplete with nil and does not set showError")
    func cancel() async {
        var showErrorValue = false
        let result = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
            let vm = AddLocationViewModel(onComplete: { cont.resume(returning: $0) })
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
