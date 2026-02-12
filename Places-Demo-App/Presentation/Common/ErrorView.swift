import SwiftUI

/// View displayed when an error occurs
struct ErrorView: View {

    let message: String
    let retry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(LocalizedStrings.Common.error, systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text(message)
        } actions: {
            Button(LocalizedStrings.Common.retry, action: retry)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(LocalizedStrings.Common.error): \(message)")
        .accessibilityHint(LocalizedStrings.Common.accessibilityRetryHint)
    }
}

#Preview {
    ErrorView(message: "Something went wrong", retry: {})
}
