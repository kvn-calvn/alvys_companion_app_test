#import <Foundation/Foundation.h>

#ifndef GSKDocumentComposition_h
#define GSKDocumentComposition_h

/// Scanned documents can be text-only like a novel page, but can also include various illustrations.
/// The filter detector can estimate the document composition.
/// The scan processor can use the document composition to better enhance the scans.
typedef NS_ENUM(NSInteger, GSKDocumentComposition) {
  /// A document composed of text only.
  GSKDocumentCompositionText,
  /// A document composed of a mix of text and photos, illustrations.
  GSKDocumentCompositionTextAndPhoto
};

#endif /* GSKDocumentComposition_h */
