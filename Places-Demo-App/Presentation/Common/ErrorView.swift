import SwiftUI

/// View displayed when an error occurs
struct ErrorView: View {

    let message: String
    let retry: () -> Void

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
