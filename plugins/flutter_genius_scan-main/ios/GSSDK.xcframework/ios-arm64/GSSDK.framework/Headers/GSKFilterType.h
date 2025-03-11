//
// Genius Scan SDK
//
// Copyright 2010-2020 The Grizzly Labs
//
// Subject to the Genius Scan SDK Licensing Agreement
// sdk@thegrizzlylabs.com
//

#ifndef GSKFilterType_h
#define GSKFilterType_h

/**
 The different possible enhancements.

 Deprecated in favor of GSKFilterConfiguration.
 */
typedef NS_CLOSED_ENUM(NSInteger, GSKFilterType) {
    /// No post processing
    GSKFilterNone = 0,
    /**
     The black and white enhancement results in a mostly black and white image but gray levels
     are used for antialiasing. The background is turned white.

     Deprecated in favor of GSKEnhancementConfiguration.automatic(with: .grayscale)
     */
    GSKFilterBlackAndWhite,
    /// Turns the background white but preserves the color.
    ///
    /// Deprecated in favor of GSKEnhancementConfiguration.automatic(with: .color)
    GSKFilterColor,
    /// Enhancement to apply to photographs.
    ///
    /// Deprecated in favor of GSKEnhancementConfiguration.withFilterConfiguration(.photo)
    GSKFilterPhoto,
    /// Monochrome enhancement. The resulting image contains only two colors.
    ///
    /// Deprecated in favor of GSKEnhancementConfiguration.automatic(with: .monochrome)
    GSKFilterMonochrome,
};


#endif /* GSKFilterType_h */
