//
//  CLIError.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import Foundation

enum CLIError: Error {
    case missingArguments
    case helpRequested
    case missingFiles
    case missingPrinter
    case invalidScaling
    case invalidPaperSize
}

extension CLIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingArguments: return Usage.short
        case .helpRequested: return Usage.full
        case .missingFiles: return "Missing required option: -f or --file"
        case .missingPrinter: return "Missing required option: -d or --printer"
        case .invalidScaling: return "Missing or invalid scaling mode: -s or --scaling"
        case .invalidPaperSize: return "Missing or invalid paper size: -p or --papersize"
        }
    }
}
