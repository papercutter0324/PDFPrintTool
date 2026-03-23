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
        commandName: "PdfPrintTool",
        abstract: "Print PDF files silently to a specified printer.",
        discussion: """
        Examples:
          PDFPrintTool -f "/path/to/file1.pdf,/path/to/file2.pdf" -d "HP LaserJet" -s fit -p A4
          PDFPrintTool -f "/path/to/file1.pdf" -f "/path/to/file2.pdf" -d "HP LaserJet" -s actual --fast-fail
          PDFPrintTool --File="/path/to/file.pdf" --Printer="HP LaserJet" --Scaling=actual --papersize=pdf
        """,
        version: "2.1.0 (Build: 14)"
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
    var scaling: ScalingMode = .fit
    
    @Option(
        name: [.customShort("p"), .long],
        help: "Paper size (A4, B5, Letter, pdf, etc.)."
    )
    var paper: Paper = .pdf
    
    @Flag(
        name: [.long],
        help: "Exit immediately on error."
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
            paper: paper,
            fastFail: fastFail
        )
        
        let manager = PrintManager(options: options)
        do {
            try manager.run()
        } catch let e as PrintError {
            // Map known print errors to specific exit codes
            throw ExitCode(e.appExit.rawValue)
        } catch {
            // Unknown errors: non-zero generic exit
            throw ExitCode(1)
        }
    }
}
