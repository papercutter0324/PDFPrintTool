# PDFPrintTool

A macOS command‑line utility to silently print one or more PDF files to a specified printer.

## Features

- Silent printing (no print or progress panels)
- Print to a specific printer by name
- Multiple input PDFs via repeated `-f` flags or a single comma‑separated list
- Scaling modes: `fit` (default) or `actual`
- Paper size selection (A‑series, B‑series, C‑series, Letter/Legal/etc., or `pdf` to use the PDF’s original size)
- Error handling with specific exit codes for AppleScript/shell integration
- Optional fast‑fail behavior to stop on the first error

## Requirements

- macOS (AppKit/PDFKit)
- Xcode (to build)
- Swift ArgumentParser (SPM dependency included by the Xcode project)

## Installation

- Open the project in Xcode and build the “PdfPrintTool” scheme in Release.
- The resulting binary will be in your build products (DerivedData). Copy it to a location on your `$PATH` if desired.

## Usage

Run the tool from Terminal and provide one or more PDF paths and a destination printer.

### Basic Syntax

```sh
PdfPrintTool --file <file> ... --printer <printer> [--scaling <scaling>] [--paper <paper>] [--fast-fail]
```

---

## Options

| Flag | Description |
|------|------------|
| `-f`, `--file <file>` | One or more PDF file paths. Supports comma-separated values or repeated flags. |
| `-d`, `--printer <printer>` | Target printer name (case-sensitive). |
| `-s`, `--scaling <scaling>` | Scaling mode: `fit` or `actual`. *(default: fit)* |
| `-p`, `--paper <paper>` | Paper size (A4, B5, Letter, etc.) or `pdf` to use the document’s original size. *(default: pdf)* |
| `--fast-fail` | Exit immediately on the first error. |
| `--version` | Show the tool version. |
| `-h`, `--help` | Show help information. |

---

## Notes

- **Multiple files** can be passed in two ways:
  - Comma-separated:
    ```sh
    -f "file1.pdf,file2.pdf"
    ```
  - Repeated flags:
    ```sh
    -f file1.pdf -f file2.pdf
    ```

- `--file` and `--printer` values are **case-sensitive**.

- `--scaling` and `--paper` values are **case-insensitive**:
  ```sh
  -s FIT
  -p a4
  ```

---

## Examples

### Print multiple PDFs (comma-separated)
```sh
PDFPrintTool -f "/path/to/file1.pdf,/path/to/file2.pdf" -d "HP LaserJet" -s fit -p A4
```

### Print multiple PDFs (repeated flags)
```sh
PDFPrintTool -f "/path/to/file1.pdf" -f "/path/to/file2.pdf" -d "HP LaserJet" -s actual --fast-fail
```

### Use long-form flags
```sh
PDFPrintTool --file="/path/to/file.pdf" --printer="HP LaserJet" --scaling=actual --paper=pdf
```
