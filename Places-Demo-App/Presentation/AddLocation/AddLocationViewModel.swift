import Foundation
import Observation

/// View model for the add custom location form: form state, validation, and submit callback.
@MainActor
@Observable
final class AddLocationViewModel {

    var name: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var showError = false

    let onSubmit: (Location) -> Void

    init(onSubmit: @escaping (Location) -> Void) {
        self.onSubmit = onSubmit
    }
    
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
        onSubmit(location)
    }
}
