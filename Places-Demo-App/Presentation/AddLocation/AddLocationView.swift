//
//  AddLocationView.swift
//  Places-Demo-App
//
//  Purpose: Sheet for adding a custom location (name, lat/long); submits or cancels via ViewModel.
//  Dependencies: SwiftUI, AddLocationViewModel, LocalizationHelper, Accessibility.
//  Usage: Presented as sheet from LocationListView when user taps add; created with dependencies.makeAddLocationViewModel.
//

import SwiftUI

/// Sheet for entering a custom location (name, latitude, longitude); submit validates and completes the continuation, cancel dismisses.
///
/// Uses a form with name and coordinate fields; shows an alert when validation fails. On valid submit, the view model resumes its continuation with the `Location` and the parent dismisses. On cancel or swipe-dismiss, the view model resumes with `nil`.
///
struct AddLocationView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: AddLocationViewModel

    // MARK: - Lifecycle

    /// Creates the view with the given view model (form state and submit callback).
    ///
    /// - Parameter viewModel: Binds form fields and performs validation on submit.
    init(viewModel: AddLocationViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    /// NavigationStack with form (name, lat/long), toolbar cancel/add, and invalid-input alert; medium detent.
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
                        viewModel.cancel()
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
        .onDisappear {
            viewModel.cancel()
        }
    }
}
