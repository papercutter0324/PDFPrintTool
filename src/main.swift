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
    // A Sizes
    case a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10
    // B Sizes
    case b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10
    // C Sizes (Envelopes)
    case c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10
    // North American
    case letter, legal, tabloid, ledger, executive, statement
    // Common Photo Sizes
    case photo4x6, photo5x7, photo8x10
    // Use PDF size
    case pdf
}

guard let paperOption = PaperSizeOption(rawValue: pageSizeArg) else {
    fputs("Invalid pagesize. Use: A4, B5, PDF\n", stderr)
    exit(1)
}

// Standard Paper Sizes (Points)
let A0 = NSSize(width: 2383.94, height: 3370.39)
let A1 = NSSize(width: 1683.78, height: 2383.94)
let A2 = NSSize(width: 1190.55, height: 1683.78)
let A3 = NSSize(width: 841.89, height: 1190.55)
let A4 = NSSize(width: 595.28, height: 841.89)
let A5 = NSSize(width: 419.53, height: 595.28)
let A6 = NSSize(width: 297.64, height: 419.53)
let A7 = NSSize(width: 209.76, height: 297.64)
let A8 = NSSize(width: 147.40, height: 209.76)
let A9 = NSSize(width: 104.88, height: 147.40)
let A10 = NSSize(width: 73.70, height: 104.88)

let B0 = NSSize(width: 2834.65, height: 4008.19)
let B1 = NSSize(width: 2004.09, height: 2834.65)
let B2 = NSSize(width: 1417.32, height: 2004.09)
let B3 = NSSize(width: 1000.63, height: 1417.32)
let B4 = NSSize(width: 708.66, height: 1000.63)
let B5 = NSSize(width: 498.90, height: 708.66)
let B6 = NSSize(width: 354.33, height: 498.90)
let B7 = NSSize(width: 249.45, height: 354.33)
let B8 = NSSize(width: 175.75, height: 249.45)
let B9 = NSSize(width: 124.72, height: 175.75)
let B10 = NSSize(width: 87.87, height: 124.72)

let C0 = NSSize(width: 2599.37, height: 3676.54)
let C1 = NSSize(width: 1836.85, height: 2599.37)
let C2 = NSSize(width: 1298.27, height: 1836.85)
let C3 = NSSize(width: 918.43, height: 1298.27)
let C4 = NSSize(width: 649.13, height: 918.43)
let C5 = NSSize(width: 459.21, height: 649.13)
let C6 = NSSize(width: 323.15, height: 459.21)
let C7 = NSSize(width: 229.61, height: 323.15)
let C8 = NSSize(width: 161.57, height: 229.61)
let C9 = NSSize(width: 113.39, height: 161.57)
let C10 = NSSize(width: 79.37, height: 113.39)

// North American sizes
let Letter = NSSize(width: 612.0, height: 792.0)     // 8.5" × 11"
let Legal = NSSize(width: 612.0, height: 1008.0)     // 8.5" × 14"
let Tabloid = NSSize(width: 792.0, height: 1224.0)   // 11" × 17"
let Ledger = NSSize(width: 1224.0, height: 792.0)    // 17" × 11"
let Executive = NSSize(width: 522.0, height: 756.0)  // 7.25" × 10.5"
let Statement = NSSize(width: 396.0, height: 612.0)  // 5.5" × 8.5"

// Common photo sizes
let Photo4x6 = NSSize(width: 288.0, height: 432.0)
let Photo5x7 = NSSize(width: 360.0, height: 504.0)
let Photo8x10 = NSSize(width: 576.0, height: 720.0)

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

let pdfPageSize = firstPage.bounds(for: .mediaBox).size
let selectedPaperSize: NSSize

switch paperOption {
// ISO 216 A series
case .a0: selectedPaperSize = A0
case .a1: selectedPaperSize = A1
case .a2: selectedPaperSize = A2
case .a3: selectedPaperSize = A3
case .a4: selectedPaperSize = A4
case .a5: selectedPaperSize = A5
case .a6: selectedPaperSize = A6
case .a7: selectedPaperSize = A7
case .a8: selectedPaperSize = A8
case .a9: selectedPaperSize = A9
case .a10: selectedPaperSize = A10
// ISO 216 B series
case .b0: selectedPaperSize = B0
case .b1: selectedPaperSize = B1
case .b2: selectedPaperSize = B2
case .b3: selectedPaperSize = B3
case .b4: selectedPaperSize = B4
case .b5: selectedPaperSize = B5
case .b6: selectedPaperSize = B6
case .b7: selectedPaperSize = B7
case .b8: selectedPaperSize = B8
case .b9: selectedPaperSize = B9
case .b10: selectedPaperSize = B10
// ISO 269 C series (envelopes)
case .c0: selectedPaperSize = C0
case .c1: selectedPaperSize = C1
case .c2: selectedPaperSize = C2
case .c3: selectedPaperSize = C3
case .c4: selectedPaperSize = C4
case .c5: selectedPaperSize = C5
case .c6: selectedPaperSize = C6
case .c7: selectedPaperSize = C7
case .c8: selectedPaperSize = C8
case .c9: selectedPaperSize = C9
case .c10: selectedPaperSize = C10
// North American
case .letter: selectedPaperSize = Letter
case .legal: selectedPaperSize = Legal
case .tabloid: selectedPaperSize = Tabloid
case .ledger: selectedPaperSize = Ledger
case .executive: selectedPaperSize = Executive
case .statement: selectedPaperSize = Statement
// Photo sizes
case .photo4x6: selectedPaperSize = Photo4x6
case .photo5x7: selectedPaperSize = Photo5x7
case .photo8x10: selectedPaperSize = Photo8x10
// Use original PDF size
case .pdf:
    selectedPaperSize = pdfPageSize
}

printInfo.paperSize = selectedPaperSize

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
