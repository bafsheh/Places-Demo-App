//
//  LoadingView.swift
//  Places-Demo-App
//
//  Purpose: Reusable loading indicator with optional message; used for async loading states.
//  Dependencies: SwiftUI, LocalizationHelper, AccessibilityID.
//  Usage: Shown in LocationListView when state is .idle or .loading.
//

import SwiftUI

/// Reusable loading view with optional message; shows a progress indicator and text.
///
/// Use for any loading state (e.g. `LoadingView()` or `LoadingView(message: "Loading locations...")`). Uses `AccessibilityID.loadingView` for UI tests.
///
/// - SeeAlso: `ViewState`, `LocationListView`
struct LoadingView: View {

    /// Message shown below the progress indicator; defaults to `LocalizationHelper.Common.loading`.
    var message: String = LocalizationHelper.Common.loading

    /// VStack with scaled ProgressView and message; accessibility combined and trait updatesFrequently.
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(message)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
        .accessibilityAddTraits(.updatesFrequently)
        .accessibilityIdentifier(AccessibilityID.loadingView.rawValue)
    }
}
