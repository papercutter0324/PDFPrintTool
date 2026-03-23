//
//  PrintConfiguration.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import AppKit

extension NSPrintInfo.AttributeKey {
    static let duplex = NSPrintInfo.AttributeKey("NSPrintDuplex")
    static let pmDuplexing = NSPrintInfo.AttributeKey("com.apple.print.PrintSettings.PMDuplexing")
}

enum DuplexMode: Int {
    case none = 1        // simplex
    case longEdge = 2    // duplex, long-edge (NoTumble)
    case shortEdge = 3   // duplex, short-edge (Tumble)
}

enum PrintConfiguration {
    
    static func create(printer: NSPrinter) -> NSPrintInfo {
        let info = NSPrintInfo.shared.copy() as! NSPrintInfo
        info.printer = printer
        
        info.jobDisposition = .spool
        
        let duplexMode: DuplexMode = .longEdge
        
        info.dictionary()["NSPrintDuplex"] = duplexMode.rawValue
        info.dictionary()["com.apple.print.PrintSettings.PMDuplexing"] = duplexMode.rawValue
        
        return info
    }
}

import AppKit


