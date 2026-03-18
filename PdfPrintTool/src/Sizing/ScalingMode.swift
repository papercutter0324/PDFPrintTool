//
//  ScalingMode.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import PDFKit
import ArgumentParser

enum ScalingMode: String, ExpressibleByArgument {
    case fit
    case actual
    
    var pdfScaling: PDFPrintScalingMode {
        switch self {
        case .fit: return .pageScaleToFit
        case .actual: return .pageScaleNone
        }
    }
}
