//
//  Logger.swift
//  Places-Demo-App
//
//  Purpose: Simple logger for errors and analytics.
//  Dependencies: Foundation, os.log.
//  Usage: Optional; call from ViewModels when handling errors (e.g. Logger.shared.log(error:context:)).
//

import Foundation
import os.log

/// Simple logger for errors and analytics
///
/// In production, this could send to analytics service (e.g., Firebase Crashlytics).
actor Logger {
    static let shared = Logger()

    private let osLog = OSLog(subsystem: "com.bafsheh.Places-Demo-App", category: "Error")

    func log(error: Error, context: String) {
        os_log(.error, log: osLog, "%{public}@: %{public}@", context, error.localizedDescription)

        // In production, send to analytics:
        // Analytics.logError(error, context: context)
    }
}
