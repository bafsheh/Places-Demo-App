import SwiftUI

/// Row component for displaying a single location
struct LocationRow: View {

    let location: Location

    var body: some View {
        HStack(spacing: 16) {
            iconView

            VStack(alignment: .leading, spacing: 4) {
                Text(location.name ?? LocalizedStrings.Location.unnamedLocation)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(location.formattedCoordinates)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(location.name ?? LocalizedStrings.Location.unnamedLocation), \(location.formattedCoordinates)")
        .accessibilityHint(LocalizedStrings.Accessibility.opensInWikipedia)
    }

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 48, height: 48)

            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    List {
        LocationRow(
            location: Location(
                name: "Amsterdam",
                latitude: 52.3547498,
                longitude: 4.8339215
            )
        )
        LocationRow(
            location: Location(
                latitude: 40.4380638,
                longitude: -3.7495758
            )
        )
    }
}
