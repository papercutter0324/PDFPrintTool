//
//  CLIOptions.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import Foundation

struct CLIOptions {
    let pdfPaths: [String]
    let printerName: String
    let scaling: ScalingMode
    let paperSize: PaperSize
    let fastFail: Bool
}
