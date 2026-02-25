# PDFPrintTool
A command line PDF print tool for MacOS.

### Command:
PDFPrintTool 'pdfPath' 'printerName' 'fit|actual' (pagesize)

### Notes:
It supports all ISO A, B, and C(envelops) page sizes. If the paper size is not specified (or 'pdf' is passed), then it will default to the PDF's original size.\n
It is recommended to always pass in the PDF path using quotes in order to avoid parsing errors. I haven't had time to consider how to handle troublesome characters (such as '(' ) in non-quoted filepaths yet.
