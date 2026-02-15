import SwiftUI

/// Host that creates `AddLocationViewModel` with an onComplete closure that resumes the view's continuation when the sheet submits or cancels. The view keeps ownership of the continuation so `onDismiss` can resume with nil if the sheet is dismissed by swipe before completion.
struct AddLocationSheetHost: View {
    @Binding var continuation: CheckedContinuation<Location?, Never>?
    let dependencies: any AppDependenciesProtocol
    @State private var viewModel: AddLocationViewModel?
    
    var body: some View {
        Group {
            if let viewModel {
                AddLocationView(viewModel: viewModel)
            } else {
                ProgressView()
                    .onAppear {
                        if viewModel == nil {
                            let continuationBinding = continuation
                            let onComplete: (Location?) -> Void = { value in
                                continuationBinding?.resume(returning: value)
                                continuation = nil
                            }
                            viewModel = dependencies.makeAddLocationViewModel(onComplete: onComplete)
                        }
                    }
            }
        }
    }
}
