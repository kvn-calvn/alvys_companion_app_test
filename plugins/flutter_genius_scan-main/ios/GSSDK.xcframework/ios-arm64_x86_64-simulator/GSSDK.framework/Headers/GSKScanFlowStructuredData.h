#ifndef GSKScanFlowStructuredData_h
#define GSKScanFlowStructuredData_h

/**
 The types of structured data to extract.
 */
typedef NS_OPTIONS(NSUInteger, GSKScanFlowStructuredData) {
    GSKScanFlowStructuredDataNone = 0,
    /// To scan IBAN and BIC/SWIFT codes
    GSKScanFlowStructuredDataBankDetails = 1 << 0,
    /// To scan business card information
    GSKScanFlowStructuredDataBusinessCard = 1 << 1,
    /// To scan receipt/invoice information
    GSKScanFlowStructuredDataReceipt = 1 << 2,
    /// To scan barcodes and QR codes. The SDK can detect multiple readable codes on a single page.
    GSKScanFlowStructuredDataReadableCode = 1 << 3,
};

#endif
