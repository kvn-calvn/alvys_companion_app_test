#import <Foundation/Foundation.h>

/**
 The different possible values for a color palette.
 */
typedef NS_CLOSED_ENUM(NSInteger, GSKFilterColorPalette) {
    /// Monochrome (black or white)
    GSKFilterColorPaletteMonochrome,
    /// Grayscale (256 shades of gray)
    GSKFilterColorPaletteGrayscale,
    /// Color
    GSKFilterColorPaletteColor
};
