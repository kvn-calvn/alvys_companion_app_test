#ifndef GSKScanFlowPostProcessingActions_h
#define GSKScanFlowPostProcessingActions_h

/**
 The various image processing actions available in the post-processing screen.

 This is an option set so you can combine multiple actions.
 */
typedef NS_OPTIONS(NSUInteger, GSKScanFlowPostProcessingActions) {
    /// No actions
    GSKScanFlowPostProcessingActionNone = 0,
    /// The filter action
    GSKScanFlowPostProcessingActionEditFilter = 1 << 0,
    /// The rotate scan action
    GSKScanFlowPostProcessingActionRotate = 1 << 1,
    /// The distortion (book curvature) correction
    GSKScanFlowPostProcessingActionDistortionCorrection = 1 << 2,
    /// All the actions
    GSKScanFlowPostProcessingActionAll = NSUIntegerMax,
};

#endif
