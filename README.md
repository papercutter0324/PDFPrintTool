# PDFPrintTool
A command line PDF print tool for MacOS.

### Command:
PDFPrintTool 'pdfPath' 'printerName' 'fit|actual' (pagesize)

### Notes:
It currently only supports A4 and B5 page sizes, but more can easily be added to suit your needs.
It is recommended to always pass in the PDF path using quotes in order to avoid parsing errors. I haven't had time to consider how to handle troublesome characters (such as '(' ) in non-quoted filepaths yet.
