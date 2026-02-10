import Foundation

/// Reusable view state for async loading: idle, loading, loaded content, or error.
enum ViewState<Content: Equatable>: Equatable {
    case idle
    case loading
    case loaded(Content)
    case error(String)
}
