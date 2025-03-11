#ifndef GSKScanFlowOCROutputFormats_h
#define GSKScanFlowOCROutputFormats_h

/**
 The various formats into which the OCR result can be made available.

 This is an option set so you can combine multiple formats.
 */
typedef NS_OPTIONS(NSUInteger, GSKScanFlowOCROutputFormats) {
    /// No output formats
    GSKScanFlowOCROutputFormatsNone = 0,
    /// Output OCR result as raw text
    GSKScanFlowOCROutputFormatsRawText = 1 << 0,
    /// Output OCR result in HOCR format
    GSKScanFlowOCROutputFormatsHOCR = 1 << 1,
    /// Add OCR result as a text layer in the generated PDF file (if any)
    GSKScanFlowOCROutputFormatsTextLayerInPDF = 1 << 2,
    /// All the output formats
    GSKScanFlowOCROutputFormatsAll = NSUIntegerMax,
};

#endif
