//
//  LocationRow.swift
//  Places-Demo-App
//
//  Purpose: Single row in the locations list (name, coordinates, open-in-Wikipedia action).
//  Dependencies: SwiftUI, Location (domain model with Coordinate), LocalizationHelper, Accessibility.
//  Usage: Used in LocationListView's List. Uses location.formattedCoordinates (Coordinate has no UI dependency).
//

import SwiftUI

/// Row component for displaying a single location in the list (name, coordinates, chevron).
///
/// Tapping the row is handled by the parent (e.g. open in Wikipedia). Uses `AccessibilityID.locationRow(id:)` for UI tests.
///
/// - SeeAlso: `LocationListView`, `Location`, `AccessibilityID`
struct LocationRow: View {

    /// The location to display (name, coordinates).
    let location: Location

    /// HStack with icon, name/coordinates, and chevron; accessibility combined and hint for Wikipedia.
    var body: some View {
        HStack(spacing: 16) {
            iconView

            VStack(alignment: .leading, spacing: 4) {
                Text(location.name ?? LocalizationHelper.Location.unnamedLocation)
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
        .accessibilityLabel("\(location.name ?? LocalizationHelper.Location.unnamedLocation), \(location.formattedCoordinates)")
        .accessibilityHint(Accessibility.opensInWikipedia)
        .accessibilityIdentifier(AccessibilityID.locationRow(id: location.id.uuidString))
    }

    // MARK: - Private

    /// Map pin icon in a circular gradient background; hidden from accessibility (label on row).
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
