//
//  PaperSize.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import AppKit
import ArgumentParser

enum PaperSize: String, ExpressibleByArgument {
    case a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10
    case b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10
    case c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10
    case letter, legal, tabloid, ledger, executive, statement
    case photo4x6, photo5x7, photo8x10
    case pdf
    
    init?(argument: String) {
        self.init(rawValue: argument.lowercased())
    }
    
    var size: NSSize? {
        switch self {
        // ISO paper sizes
        case .a0: return NSSize(width: 2383.94, height: 3370.39)
        case .a1: return NSSize(width: 1683.78, height: 2383.94)
        case .a2: return NSSize(width: 1190.55, height: 1683.78)
        case .a3: return NSSize(width: 841.89, height: 1190.55)
        case .a4: return NSSize(width: 595.28, height: 841.89)
        case .a5: return NSSize(width: 419.53, height: 595.28)
        case .a6: return NSSize(width: 297.64, height: 419.53)
        case .a7: return NSSize(width: 209.76, height: 297.64)
        case .a8: return NSSize(width: 147.40, height: 209.76)
        case .a9: return NSSize(width: 104.88, height: 147.40)
        case .a10: return NSSize(width: 73.70, height: 104.88)
            
        case .b0: return NSSize(width: 2834.65, height: 4008.19)
        case .b1: return NSSize(width: 2004.09, height: 2834.65)
        case .b2: return NSSize(width: 1417.32, height: 2004.09)
        case .b3: return NSSize(width: 1000.63, height: 1417.32)
        case .b4: return NSSize(width: 708.66, height: 1000.63)
        case .b5: return NSSize(width: 498.90, height: 708.66)
        case .b6: return NSSize(width: 354.33, height: 498.90)
        case .b7: return NSSize(width: 249.45, height: 354.33)
        case .b8: return NSSize(width: 175.75, height: 249.45)
        case .b9: return NSSize(width: 124.72, height: 175.75)
        case .b10: return NSSize(width: 87.87, height: 124.72)
         
        case .c0: return NSSize(width: 2599.37, height: 3676.54)
        case .c1: return NSSize(width: 1836.85, height: 2599.37)
        case .c2: return NSSize(width: 1298.27, height: 1836.85)
        case .c3: return NSSize(width: 918.43, height: 1298.27)
        case .c4: return NSSize(width: 649.13, height: 918.43)
        case .c5: return NSSize(width: 459.21, height: 649.13)
        case .c6: return NSSize(width: 323.15, height: 459.21)
        case .c7: return NSSize(width: 229.61, height: 323.15)
        case .c8: return NSSize(width: 161.57, height: 229.61)
        case .c9: return NSSize(width: 113.39, height: 161.57)
        case .c10: return NSSize(width: 79.37, height: 113.39)
            
        // North American sizes
        case .letter: return NSSize(width: 612.0, height: 792.0)
        case .legal: return NSSize(width: 612.0, height: 1008.0)
        case .tabloid: return NSSize(width: 792.0, height: 1224.0)
        case .ledger: return NSSize(width: 1224.0, height: 792.0)
        case .executive: return NSSize(width: 522.0, height: 756.0)
        case .statement: return NSSize(width: 396.0, height: 612.0)

        // Common photo sizes
        case .photo4x6: return NSSize(width: 288.0, height: 432.0)
        case .photo5x7: return NSSize(width: 360.0, height: 504.0)
        case .photo8x10: return NSSize(width: 576.0, height: 720.0)
        
        // Use internal pdf size
        case .pdf: return nil
        }
    }
}

