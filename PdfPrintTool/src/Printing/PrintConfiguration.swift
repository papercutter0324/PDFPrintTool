//
//  PrintConfiguration.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import AppKit

enum PrintConfiguration {
    
    static func create(printer: NSPrinter) -> NSPrintInfo {
        let info = NSPrintInfo.shared.copy() as! NSPrintInfo
        info.printer = printer
        
        info.jobDisposition = .spool
        
        info.dictionary()["NSPrintDuplex"] = 2
        info.dictionary()["com.apple.print.PrintSettings.PMDuplexing"] = 2
        
        return info
    }
}
