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
                    TextField("Location name", text: $viewModel.name)
                        .textContentType(.name)
                } header: {
                    Text("Name")
                }

                Section {
                    TextField("Latitude", text: $viewModel.latitude)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $viewModel.longitude)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Coordinates")
                } footer: {
                    Text("Latitude -90 to 90, Longitude -180 to 180")
                }
            }
            .navigationTitle("Custom Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.submit()
                        
                        if viewModel.showError == false {
                            dismiss()
                        }
                    }
                }
            }
            .alert("Invalid coordinates", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.showError = false
                }
            } message: {
                Text("Please enter valid latitude (-90 to 90) and longitude (-180 to 180).")
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
