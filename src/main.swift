import Foundation
import AppKit
import PDFKit

_ = NSApplication.shared
NSApp.setActivationPolicy(.prohibited)

// ------------------------------------------------------------
// Usage:
// PDFPrintTool <pdfPath> <printerName> <fit|actual> [pagesize]
//
// pagesize (optional):
//   a4   -> A4
//   b5   -> B5
//   pdf  -> Use PDF's original page size (default)
// ------------------------------------------------------------

// Ensure we have required arguments
guard CommandLine.arguments.count >= 4 else {
    fputs("Usage: PDFPrintTool <pdfPath> <printerName> <fit|actual> [pagesize]\n", stderr)
    exit(1)
}

let pdfPath = CommandLine.arguments[1]
let printerName = CommandLine.arguments[2]
let scalingModeArg = CommandLine.arguments[3].lowercased()
let pageSizeArg = CommandLine.arguments.count >= 5
    ? CommandLine.arguments[4].lowercased()
    : "pdf"

enum ScalingMode: String {
    case fit
    case actual
}

guard let scalingMode = ScalingMode(rawValue: scalingModeArg) else {
    fputs("Invalid scaling mode. Use: fit, actual\n", stderr)
    exit(1)
}

enum PaperSizeOption: String {
    case a4
    case b5
    case pdf
}

guard let paperOption = PaperSizeOption(rawValue: pageSizeArg) else {
    fputs("Invalid pagesize. Use: a4, b5, pdf\n", stderr)
    exit(1)
}

// Standard Paper Sizes (Points)
let A4 = NSSize(width: 595.2, height: 841.8)
let B5 = NSSize(width: 498.9, height: 708.7)

// Validate File
let pdfURL = URL(fileURLWithPath: pdfPath)

var isDir: ObjCBool = false
if !FileManager.default.fileExists(atPath: pdfURL.path, isDirectory: &isDir) || isDir.boolValue {
    fputs("PDF file not found at path: \(pdfURL.path)\n", stderr)
    exit(1)
}

// Load PDF document and first page
guard let pdfDocument = PDFDocument(url: pdfURL),
      let firstPage = pdfDocument.page(at: 0) else {
    fputs("Failed to load PDF or its first page.\n", stderr)
    exit(1)
}

// Resolve Printer (Accept CUPS or Display Name)
func resolvePrinter(named name: String) -> NSPrinter? {
    
    // Exact match (display name)
    if let p = NSPrinter(name: name) {
        return p
    }
    
    // Underscore to Space Normalization
    let normalized = name.replacingOccurrences(of: "_", with: " ")
    if let p = NSPrinter(name: normalized) {
        return p
    }
    
    // Loose Matching Against printerNames
    for available in NSPrinter.printerNames {
        if available.replacingOccurrences(of: " ", with: "_") == name {
            return NSPrinter(name: available)
        }
    }
    
    return nil
}

guard let printer = resolvePrinter(named: printerName) else {
    fputs("Printer not found: \(printerName)\n", stderr)
    fputs("Available printers:\n", stderr)
    for name in NSPrinter.printerNames {
        fputs("  \(name)\n", stderr)
    }
    exit(1)
}

// Prepare Print Info
let printInfo = (NSPrintInfo.shared.copy() as! NSPrintInfo)
printInfo.printer = printer

// Spool Silently
if printInfo.responds(to: NSSelectorFromString("setJobDisposition:")) {
    // Use the typed API when available
    printInfo.jobDisposition = .spool
} else {
    // Fallback via KVC to set the job disposition in the underlying dictionary
    printInfo.setValue(NSPrintInfo.JobDisposition.spool.rawValue,
                       forKey: NSPrintInfo.AttributeKey.jobDisposition.rawValue)
}

// Duplex long-edge (2 = long, 3 = short, 1 = off)
printInfo.dictionary()["NSPrintDuplex"] = 2
printInfo.dictionary()["com.apple.print.PrintSettings.PMDuplexing"] = 2

// Determine Paper Size
let pdfPageSize = firstPage.bounds(for: .mediaBox).size
let selectedPaperSize: NSSize

switch paperOption {
case .a4:
    selectedPaperSize = A4
case .b5:
    selectedPaperSize = B5
case .pdf:
    selectedPaperSize = pdfPageSize
}

printInfo.paperSize = selectedPaperSize

// Scaling Mode
let scaling: PDFPrintScalingMode

switch scalingMode {
case .fit:
    scaling = .pageScaleToFit
case .actual:
    scaling = .pageScaleNone
}

// Create Print Operation
guard let printOperation = pdfDocument.printOperation(
    for: printInfo,
    scalingMode: scaling,
    autoRotate: true
) else {
    fputs("Failed to create print operation.\n", stderr)
    exit(1)
}

// Fully Silent Print Operation
printOperation.showsPrintPanel = false
printOperation.showsProgressPanel = false

// Execute
let success = printOperation.run()
exit(success ? 0 : 1)
