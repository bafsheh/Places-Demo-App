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
                    TextField(LocalizedStrings.AddLocation.namePlaceholder, text: $viewModel.name)
                        .textContentType(.name)
                } header: {
                    Text(LocalizedStrings.AddLocation.sectionName)
                }

                Section {
                    TextField(LocalizedStrings.AddLocation.textFieldLatitude, text: $viewModel.latitude)
                        .keyboardType(.decimalPad)
                    TextField(LocalizedStrings.AddLocation.textFieldLongitude, text: $viewModel.longitude)
                        .keyboardType(.decimalPad)
                } header: {
                    Text(LocalizedStrings.AddLocation.sectionCoordinates)
                } footer: {
                    Text(LocalizedStrings.AddLocation.latLongFooter)
                }
            }
            .navigationTitle(LocalizedStrings.AddLocation.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedStrings.AddLocation.cancel) {
                        dismiss()
                    }
                    .accessibilityHint(LocalizedStrings.Accessibility.AddLocation.cancelButtonHint)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizedStrings.AddLocation.add) {
                        viewModel.submit()
                        
                        if viewModel.showError == false {
                            dismiss()
                        }
                    }
                    .accessibilityHint(LocalizedStrings.Accessibility.AddLocation.addButtonHint)
                }
            }
            .alert(LocalizedStrings.AddLocation.alertInvalidTitle, isPresented: $viewModel.showError) {
                Button(LocalizedStrings.AddLocation.alertOk) {
                    viewModel.showError = false
                }
            } message: {
                Text(LocalizedStrings.AddLocation.alertInvalidMessage)
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.Accessibility.AddLocation.formLabel)
    }
}

#Preview {
    AddLocationView(viewModel: AddLocationViewModel(onSubmit: { _ in }))
}
