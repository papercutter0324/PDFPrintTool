//
//  Logger.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import Foundation

enum Logger {
    
    static func error(_ text: String) {
        fputs(text + "\n", stderr)
        fflush(stderr)
    }
}
