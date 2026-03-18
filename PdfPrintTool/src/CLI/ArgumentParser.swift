//
//  ArgumentParser.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import Foundation
import ArgumentParser

struct PDFPrintTool: ParsableCommand {
    
    // MARK: - Configuration
    
    static let configuration = CommandConfiguration(
        commandName: "PDFPrintTool",
        abstract: "Print PDF files silently to a specified printer.",
        version: "2.0.0"
    )
    
    // MARK: - Options
    
    @Option(
        name: [.customShort("f"), .long],
        help: "PDF file paths. Supports comma-separated values or repeated flags."
    )
    var file: [String]
    
    @Option(
        name: [.customShort("d"), .long],
        help: "Target printer name."
    )
    var printer: String
    
    @Option(
        name: [.customShort("s"), .customLong("scaling")],
        help: "Scaling mode: fit or actual."
    )
    var scaling: ScalingMode
    
    @Option(
        name: [.customShort("p"), .long],
        help: "Paper size (A4, Letter, Legal, pdf, etc.)."
    )
    var papersize: PaperSize = .pdf
    
    @Flag(
        name: [.long],
        help: "Exit immediately on first error."
    )
    var fastFail: Bool = false
    
    // MARK: - Execution
    
    func run() throws {
        
        // Expand comma-separated values
        let pdfPaths = file.flatMap {
            $0.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        }.filter { !$0.isEmpty }
        
        guard !pdfPaths.isEmpty else {
            throw ValidationError("At least one PDF file must be provided using -f or --file.")
        }
        
        let options = CLIOptions(
            pdfPaths: pdfPaths,
            printerName: printer,
            scaling: scaling,
            paperSize: papersize,
            fastFail: fastFail
        )
        
        let manager = PrintManager(options: options)
        try manager.run()
    }
}
