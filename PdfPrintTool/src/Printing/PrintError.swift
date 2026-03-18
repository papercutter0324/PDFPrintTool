//
//  PrintError.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import Foundation

enum PrintError: Error {
    case printerNotFound(String)
    case invalidPDF(String)
    case operationFailed(String)
    case printFailed(String)
    case partialFailure
}

extension PrintError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .printerNotFound(let name):
            return "Printer not found: \(name)"
            
        case .invalidPDF(let path):
            return "Invalid or unreadable PDF: \(path)"
            
        case .operationFailed(let path):
            return "Failed to create print operation: \(path)"
            
        case .printFailed(let path):
            return "Printing failed: \(path)"
            
        case .partialFailure:
            return "One or more print jobs failed"
        }
    }
}
