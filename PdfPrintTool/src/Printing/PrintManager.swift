//
//  PrintManager.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import Foundation
import AppKit
import PDFKit

final class PrintManager {
    
    private let options: CLIOptions
    
    init(options: CLIOptions) {
        self.options = options
    }
    
    func run() throws {
        
        guard let printer = PrinterResolver.resolve(named: options.printerName) else {
            throw PrintError.printerNotFound(options.printerName)
        }
        
        let printInfo = PrintConfiguration.create(printer: printer)
        
        var anyFailure = false
        
        for path in options.pdfPaths {
            do {
                try printPDF(at: path, printInfo: printInfo)
            } catch {
                Logger.error(error.localizedDescription)
                
                if options.fastFail {
                    throw error
                }
                anyFailure = true
            }
        }
        
        if anyFailure {
            throw PrintError.partialFailure
        }
    }
    
    private func printPDF(at path: String, printInfo: NSPrintInfo) throws {
        let url = URL(fileURLWithPath: path)
        
        guard let doc = PDFDocument(url: url),
              let firstPage = doc.page(at: 0) else {
            throw PrintError.invalidPDF(path)
        }
        
        let size = options.paperSize.size ?? firstPage.bounds(for: .mediaBox).size
        printInfo.paperSize = size
        
        guard let op = doc.printOperation(
            for: printInfo,
            scalingMode: options.scaling.pdfScaling,
            autoRotate: true
        ) else {
            throw PrintError.operationFailed(path)
        }
        
        op.showsPrintPanel = false
        op.showsProgressPanel = false
        
        guard op.run() else {
            throw PrintError.printFailed(path)
        }
    }
}
