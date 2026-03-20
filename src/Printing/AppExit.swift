//
//  AppExit.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/20/26.
//

import Foundation

/// Stable exit codes for shell/AppleScript integration
enum AppExit: Int32 {
    case printerNotFound = 2
    case invalidPDF = 3
    case operationFailed = 4
    case printFailed = 5
    case partialFailure = 6
}

extension PrintError {
    var appExit: AppExit {
        switch self {
        case .printerNotFound:
            return .printerNotFound
        case .invalidPDF:
            return .invalidPDF
        case .operationFailed:
            return .operationFailed
        case .printFailed:
            return .printFailed
        case .partialFailure:
            return .partialFailure
        }
    }
}
