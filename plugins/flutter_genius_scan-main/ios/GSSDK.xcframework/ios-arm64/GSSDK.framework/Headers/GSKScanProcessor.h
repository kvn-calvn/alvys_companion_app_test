//
// Genius Scan SDK
//
// Copyright 2010-2020 The Grizzly Labs
//
// Subject to the Genius Scan SDK Licensing Agreement
// sdk@thegrizzlylabs.com
//

#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <GSSDK/GSKFilterType.h>
#import <GSSDK/GSKRotation.h>

NS_ASSUME_NONNULL_BEGIN

@class GSKCurvatureCorrectionConfiguration;
@class GSKEnhancementConfiguration;
@class GSKFilterColorConfiguration;
@class GSKFilterConfiguration;
@class GSKOutputConfiguration;
@class GSKPerspectiveCorrectionConfiguration;
@class GSKProcessingConfiguration;
@class GSKProcessingResult;
@class GSKQuadrangle;
@class GSKQuadrangleDetectionConfiguration;
@class GSKResizeConfiguration;
@class GSKResizeResult;

/**
  The document processor is the central class of the GSSDK's image processing algorithms.

  With the document processor, you can correct the distortion in your documents, as well as improve their legibility.
  If you are only interested in the detecting a document in an image, please refer to GSKDocumentDetector.

  Warning: `GSKScanProcessor` is not thread-safe; you shouldn't reuse the same instance accross threads.
*/
@interface GSKScanProcessor : NSObject

/**
 This is the main SDK method and we recommend using this one. By combining multiple operations,
 it can achieve better performance.

 @param configuration The configuration of the different steps of the processing.

 @returns The result of the processing, nil if there is an error. The results includes the parameters that have been selected for the different processing steps,
 as well as the temporary path were the output was written. The output is written in a temporary folder. The caller can take ownership of this file.
 By default, the best output format will be chosen by this method. For instance, if the monochrome enhancement was selected, the output will not
 be saved as JPEG but as a 1-bit PNG image. The result's processedImagePath file extension will reflect this.
 */
- (GSKProcessingResult * _Nullable)processImage:(UIImage *)image
                                  configuration:(GSKProcessingConfiguration *)configuration
                                          error:(NSError **)error;

/**
 Downscale the image at the given path and stores the result in a temporary file.

 Note: this method will never upscale the image. If the image doesn't need downscaling, it will return a copy of the file.
 */
- (GSKResizeResult * _Nullable)resizeImageAtPath:(NSString *)imagePath
                             resizeConfiguration:(GSKResizeConfiguration *)resizeConfiguration
                             outputConfiguration:(GSKOutputConfiguration *)outputConfiguration
                                           error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
