//
//  ErrorView.swift
//  Places-Demo-App
//
//  Purpose: Error state UI with message and retry action; uses ContentUnavailableView.
//  Dependencies: SwiftUI, LocalizationHelper, AccessibilityID.
//  Usage: Shown in LocationListView when state is .error.
//

import SwiftUI

/// View displayed when an error occurs; uses `ContentUnavailableView` with message and retry button.
///
/// Caller provides the error message and retry action (e.g. re-call `loadLocations()`). The message is typically taken from `ViewState.errorMessage` when switching on `ViewState.error(error:message:)`. Uses `AccessibilityID.errorViewRetryButton` for UI tests.
///
struct ErrorView: View {

    /// User-facing error message to display (e.g. from `ViewState.errorMessage` or `ViewState.error(_, message)`).
    let message: String

    /// Action to perform when the user taps Retry (e.g. reload locations).
    let retry: () -> Void

    /// ContentUnavailableView with error label, message, and retry button; accessibility combined.
    var body: some View {
        ContentUnavailableView {
            Label(LocalizationHelper.Common.error, systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text(message)
        } actions: {
            Button(LocalizationHelper.Common.retry, action: retry)
                .accessibilityIdentifier(AccessibilityID.errorViewRetryButton.rawValue)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(LocalizationHelper.Common.error): \(message)")
        .accessibilityHint(LocalizationHelper.Common.accessibilityRetryHint)
    }
}
