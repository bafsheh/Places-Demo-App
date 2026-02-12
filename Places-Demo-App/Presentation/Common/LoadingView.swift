import SwiftUI

/// Reusable loading view with optional message. Use for any loading state (e.g. `LoadingView()` or `LoadingView(message: "Loading locations...")`).
struct LoadingView: View {

    var message: String = LocalizedStrings.Common.loading

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
    }
}

#Preview {
    LoadingView()
}

#Preview("Loading locations") {
    LoadingView(message: LocalizedStrings.Places.loadingLocations)
}
