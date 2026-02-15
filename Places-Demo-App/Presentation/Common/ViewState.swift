//
//  ViewState.swift
//  Places-Demo-App
//
//  Purpose: Generic view state for async flows (idle, loading, loaded, error).
//  Dependencies: None.
//  Usage: Used by ViewModels (e.g. LocationListViewModel) to drive UI state.
//

import Foundation

/// Sendable error wrapper for `ViewState.error`; holds the underlying error's description for display/logging.
/// Allows `ViewState` to conform to `Sendable` without holding a non-Sendable `Error` across isolation boundaries.
struct ViewStateError: Error, Sendable, Equatable {
    let errorDescription: String
    init(describing error: Error) {
        self.errorDescription = error.localizedDescription
    }
}

/// Represents the state of a view's data fetching or operation
///
/// Generic over Content type to support different data models.
/// Error case uses `ViewStateError` (Sendable) so the enum remains Sendable.
enum ViewState<Content: Equatable & Sendable>: Sendable {

    /// Initial state before any operation
    case idle

    /// Operation in progress
    case loading

    /// Operation completed successfully with data
    case loaded(Content)

    /// Operation failed with error
    ///
    /// - Parameters:
    ///   - error: Sendable wrapper holding the underlying error's description (for display/logging).
    ///   - message: User-facing error message (localized)
    case error(error: ViewStateError, message: String)

    /// Convenience: Check if currently loading
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    /// Convenience: Get loaded content if available
    var content: Content? {
        if case .loaded(let content) = self { return content }
        return nil
    }

    /// Convenience: Get error message if in error state
    var errorMessage: String? {
        if case .error(_, let message) = self { return message }
        return nil
    }

    /// Convenience: Get underlying error (ViewStateError) if in error state
    var underlyingError: ViewStateError? {
        if case .error(let error, _) = self { return error }
        return nil
    }
}

// MARK: - Equatable

extension ViewState: Equatable {
    static func == (lhs: ViewState<Content>, rhs: ViewState<Content>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.loaded(let lhsContent), .loaded(let rhsContent)):
            return lhsContent == rhsContent
        case (.error(let lhsError, let lhsMessage), .error(let rhsError, let rhsMessage)):
            return lhsError == rhsError && lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
