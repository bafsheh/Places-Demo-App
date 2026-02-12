//
//  AddLocationViewModel.swift
//  Places-Demo-App
//
//  Purpose: Form state and validation for add-location sheet; completes continuation with Location? (submit or cancel).
//  Dependencies: Observation, Location.
//  Usage: Created by Dependencies.makeAddLocationViewModel; owned by AddLocationView.
//

import Foundation
import Observation

/// View model for the add-location sheet: form state (name, lat/long strings), validation, and async completion via continuation.
///
/// Validates that lat/long parse to doubles in valid ranges (-90...90, -180...180). On valid submit resumes the continuation with the `Location`; on cancel or dismiss resumes with `nil`. Sets `showError` for invalid input to drive the alert.
///
@MainActor
@Observable
final class AddLocationViewModel {

    // MARK: - Properties

    /// User-entered name; trimmed on submit; empty becomes `nil` for `Location.name`.
    var name: String = ""

    /// User-entered latitude string; must parse to Double in -90...90.
    var latitude: String = ""

    /// User-entered longitude string; must parse to Double in -180...180.
    var longitude: String = ""

    /// When `true`, the invalid-input alert is shown; set by `submit()` when validation fails.
    var showError = false

    private var continuation: CheckedContinuation<Location?, Never>?
    private var didResume = false

    // MARK: - Lifecycle

    /// Creates the view model with a continuation that will be resumed with the submitted `Location` or `nil` on cancel.
    ///
    /// - Parameter continuation: Resumed once with the created `Location` on valid submit, or `nil` when the user cancels/dismisses.
    init(continuation: CheckedContinuation<Location?, Never>) {
        self.continuation = continuation
    }

    // MARK: - Public Methods

    /// Validates lat/long; if valid, creates a `Location` (with domain `Coordinate`), resumes the continuation with it, and clears it; otherwise sets `showError = true`.
    func submit() {
        guard let lat = Double(latitude),
              let lon = Double(longitude),
              lat >= -90, lat <= 90,
              lon >= -180, lon <= 180 else {
            showError = true
            return
        }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let location = Location(
            name: trimmedName.isEmpty ? nil : trimmedName,
            latitude: lat,
            longitude: lon
        )
        resume(returning: location)
    }

    /// Resumes the continuation with `nil` (e.g. user cancelled or dismissed). No-op if already resumed.
    func cancel() {
        resume(returning: nil)
    }

    // MARK: - Private

    private func resume(returning value: Location?) {
        guard !didResume, let cont = continuation else { return }
        didResume = true
        continuation = nil
        cont.resume(returning: value)
    }
}
