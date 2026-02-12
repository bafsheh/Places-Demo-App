import SwiftUI

/// Sheet for entering custom location coordinates
struct AddLocationView: View {

    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: AddLocationViewModel

    init(viewModel: AddLocationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(LocalizationHelper.AddLocation.namePlaceholder, text: $viewModel.name)
                        .textContentType(.name)
                        .accessibilityLabel(Accessibility.AddLocation.nameField)
                        .accessibilityHint(Accessibility.AddLocation.nameHint)
                        .accessibilityIdentifier(AccessibilityID.addLocationNameField.rawValue)
                } header: {
                    Text(LocalizationHelper.AddLocation.sectionName)
                }

                Section {
                    TextField(LocalizationHelper.AddLocation.textFieldLatitude, text: $viewModel.latitude)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel(Accessibility.AddLocation.latitudeField)
                        .accessibilityHint(Accessibility.AddLocation.latitudeHint)
                        .accessibilityIdentifier(AccessibilityID.addLocationLatitudeField.rawValue)
                    TextField(LocalizationHelper.AddLocation.textFieldLongitude, text: $viewModel.longitude)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel(Accessibility.AddLocation.longitudeField)
                        .accessibilityHint(Accessibility.AddLocation.longitudeHint)
                        .accessibilityIdentifier(AccessibilityID.addLocationLongitudeField.rawValue)
                } header: {
                    Text(LocalizationHelper.AddLocation.sectionCoordinates)
                } footer: {
                    Text(LocalizationHelper.AddLocation.latLongFooter)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Accessibility.AddLocation.formLabel)
            .accessibilityIdentifier(AccessibilityID.addLocationForm.rawValue)
            .navigationTitle(LocalizationHelper.AddLocation.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizationHelper.AddLocation.cancel) {
                        dismiss()
                    }
                    .accessibilityHint(Accessibility.AddLocation.cancelButtonHint)
                    .accessibilityIdentifier(AccessibilityID.addLocationCancelButton.rawValue)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizationHelper.AddLocation.add) {
                        viewModel.submit()
                        
                        if viewModel.showError == false {
                            dismiss()
                        }
                    }
                    .accessibilityHint(Accessibility.AddLocation.addButtonHint)
                    .accessibilityIdentifier(AccessibilityID.addLocationAddButton.rawValue)
                }
            }
            .alert(LocalizationHelper.AddLocation.alertInvalidTitle, isPresented: $viewModel.showError) {
                Button(LocalizationHelper.AddLocation.alertOk) {
                    viewModel.showError = false
                }
            } message: {
                Text(LocalizationHelper.AddLocation.alertInvalidMessage)
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
