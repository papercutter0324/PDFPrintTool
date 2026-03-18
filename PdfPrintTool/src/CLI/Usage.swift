//
//  Usage.swift
//  PdfPrintTool
//
//  Created by Warren Feltmate on 3/18/26.
//

import Foundation

enum Usage {
    static let full = """
Usage: PDFPrintTool -f <path>[,<path2>...] -d <printer> -s <fit|actual> [-p <size>] [--fast-fail]

Options:
  -h, --help, --Help                  Show this help and exit
  -f, --file, --File <path(s)>        One or more PDF paths. Accepts a comma-separated list
                                      (e.g., file1.pdf,file2.pdf) or repeated -f flags.
  -d, --printer, --Printer <name>     Target printer name
  -s, --scaling, --Scaling <mode>     Scaling mode: fit or actual
  -p, --papersize, --Papersize <size> Paper size (A4, B5, pdf (default), etc.)
                                      You can also use --papersize=A4
  --fast-fail                         Exit immediately on first error (default: continue on error)

Examples:
  PDFPrintTool -f "/path/to/file1.pdf,/path/to/file2.pdf" -d "HP LaserJet" -s fit -p A4
  PDFPrintTool -f "/path/to/file1.pdf" -f "/path/to/file2.pdf" -d "HP LaserJet" -s actual --fast-fail
  PDFPrintTool --File="/path/to/file.pdf" --Printer="HP LaserJet" --Scaling=actual --papersize=pdf

"""
    
    static let short = """
PDFPrintTool: missing arguments.
Example:
  PDFPrintTool -f "/path/to/file.pdf" -d "HP LaserJet" -s fit -p A4
Use -h or --Help for more information.

"""
}
