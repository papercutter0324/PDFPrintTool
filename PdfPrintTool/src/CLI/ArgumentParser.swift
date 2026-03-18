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
        version: "1.0.0"
    )
    
    // MARK: - Options
    
    @Option(
        name: [.short, .long],
        help: "PDF file paths. Supports comma-separated values or repeated flags."
    )
    var file: [String]
    
    @Option(
        name: [.short, .long],
        help: "Target printer name."
    )
    var printer: String
    
    @Option(
        name: [.short, .long],
        help: "Scaling mode: fit or actual."
    )
    var scaling: ScalingMode
    
    @Option(
        name: [.short, .long],
        help: "Paper size (A4, Letter, Legal, pdf, etc.)."
    )
    var papersize: PaperSize = .pdf
    
    @Flag(
        name: [.long],
        help: "Exit immediately on first error."
    )
    var fastFail: Bool = false
    
    // Optional explicit version flag (in addition to built-in)
    @Flag(
        name: [.long],
        help: "Show version information."
    )
    var version: Bool = false
    
    // MARK: - Execution
    
    func run() throws {
        
        // Handle explicit version flag (optional)
        if version {
            print(Self.configuration.version)
            return
        }
        
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
