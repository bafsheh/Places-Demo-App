//
//  ViewState.swift
//  Places-Demo-App
//
//  Purpose: Generic view state for async flows (idle, loading, loaded, error).
//  Dependencies: None.
//  Usage: Used by ViewModels (e.g. LocationListViewModel) to drive UI state.
//

import Foundation

/// Reusable view state for async loading: idle, loading, loaded content, or error.
///
/// ViewModels expose this so views can switch on the state to show loading UI, content, or error with retry. `Content` must be `Equatable` for SwiftUI diffing and `Sendable` for Swift 6 strict concurrency.
///
/// - SeeAlso: `LocationListViewModel`, `LoadingView`, `ErrorView`
enum ViewState<Content: Equatable & Sendable>: Equatable, Sendable {

    /// Initial state before any load has started.
    case idle

    /// A load is in progress; show loading indicator.
    case loading

    /// Load succeeded; show the associated content.
    case loaded(Content)

    /// Load failed; associated string is the error message to display (e.g. for retry UI).
    case error(String)
}
