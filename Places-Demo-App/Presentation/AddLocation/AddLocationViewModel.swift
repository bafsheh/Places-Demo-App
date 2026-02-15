//
//  AddLocationViewModel.swift
//  Places-Demo-App
//
//  Purpose: Form state and validation for add-location sheet; completes via onComplete(Location?) (submit or cancel).
//  Dependencies: Observation, Location.
//  Usage: Created by Dependencies.makeAddLocationViewModel; owned by AddLocationView.
//

import Foundation
import Observation

/// View model for the add-location sheet: form state (name, lat/long strings), validation, and completion via callback.
///
/// Validates that lat/long parse to doubles in valid ranges (-90...90, -180...180). On valid submit calls `onComplete` with the `Location`; on cancel calls `onComplete(nil)`. Sets `showError` for invalid input to drive the alert. The view owns the continuation and passes a closure that resumes it so swipe-to-dismiss can also complete the flow in `onDismiss`.
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

    private var onComplete: ((Location?) -> Void)?

    // MARK: - Lifecycle

    /// Creates the view model with a completion handler invoked once with the submitted `Location` or `nil` on cancel.
    ///
    /// - Parameter onComplete: Called once with the created `Location` on valid submit, or `nil` when the user cancels. The view uses this to resume its continuation and clear it.
    init(onComplete: @escaping (Location?) -> Void) {
        self.onComplete = onComplete
    }

    // MARK: - Public Methods

    /// Validates lat/long; if valid, creates a `Location` (with domain `Coordinate`), calls `onComplete` with it, and clears it; otherwise sets `showError = true`.
    ///
    /// - Returns: `true` if validation passed and the location was submitted; `false` if validation failed.
    @discardableResult
    func submit() -> Bool {
        guard let lat = Double(latitude),
              let lon = Double(longitude),
              Coordinate.latitudeRange.contains(lat),
              Coordinate.longitudeRange.contains(lon) else {
            showError = true
            return false
        }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let location = Location(
            name: trimmedName.isEmpty ? nil : trimmedName,
            latitude: lat,
            longitude: lon
        )
        complete(with: location)
        return true
    }

    /// Calls `onComplete(nil)` (e.g. user cancelled). No-op if already completed.
    func cancel() {
        complete(with: nil)
    }

    // MARK: - Private

    private func complete(with value: Location?) {
        guard let completion = onComplete else { return }
        onComplete = nil
        completion(value)
    }
}
