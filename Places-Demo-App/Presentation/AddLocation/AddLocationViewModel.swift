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

    var isValid: Bool {
        guard let lat = Double(latitude),
              let lon = Double(longitude),
              lat >= -90, lat <= 90,
              lon >= -180, lon <= 180 else {
            return false
        }
        return true
    }

    func submit() {
        guard let lat = Double(latitude),
              let lon = Double(longitude),
              lat >= -90, lat <= 90,
              lon >= -180, lon <= 180 else {
            showError = true
            return
        }
        let location = Location(
            name: name.isEmpty ? nil : name,
            latitude: lat,
            longitude: lon
        )
        onSubmit(location)
    }
}
