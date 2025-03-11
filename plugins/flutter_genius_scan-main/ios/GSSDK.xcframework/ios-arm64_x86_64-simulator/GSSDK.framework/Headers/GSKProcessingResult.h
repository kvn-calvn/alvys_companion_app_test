//
//  GSKProcessingResult.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GSSDK/GSKFilterType.h>
#import <GSSDK/GSKRotation.h>

@class GSKQuadrangle;
@class GSKFilterConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface GSKProcessingResult : NSObject
/// The output file.
/// It's located in the temporary directory, so you need to move it to a permanent destination.
@property (nonatomic, readonly) NSString *processedImagePath;

/// The quadrangle that was used for perspective correction
@property (nonatomic, strong, readonly) GSKQuadrangle *appliedQuadrangle;

/// The filter that was applied during the enhancement phase
@property (nonatomic, assign, readonly) GSKFilterType appliedFilter __deprecated_msg("Use appliedFilterConfiguration instead.");

/// The filter that was applied during the enhancement phase
@property (nonatomic, strong, readonly) GSKFilterConfiguration *appliedFilterConfiguration;

/**
 The rotation applied during the rotation phase.

 If you specified a rotation angle as part of GSKRotationConfiguration, you will get this angle back here.
 If you requested an automatic orientation detection as part of the GSKRotationConfiguration, appliedRotation will correspond the rotation applied by the SDK
 to rotate the image according to the estimated orientation.

 Note: The output of the processing is always an up-oriented image, even if the original image had an EXIF orientation (see UIImage's imageOrientation property).
 `appliedRotation` doesn't include the rotation applied to the image buffer to remove the EXIF information. The `appliedRotation` only includes the "visual" rotation
 needed to display the image to the user:

 - If the input image imageOrientation is UIImageOrientationUp, and you request a clockwise rotation, appliedRotation will be GSKRotationClockwise.
 - If the input image imageOrientation is UIImageOrientationUp, and you request an automatic rotation, which detects that the image must be rotated clockwise to
 look "straight", appliedRotation will be GSKRotationClockwise.
 - If the input image imageOrientation is UIImageOrientationRight, and you request a clockwise rotation, appliedRotation will be GSKRotationClockwise. The output
 image orientation will be UIImageOrientationUp.
 - If the input image imageOrientation is UIImageOrientationUp, and you request an automatic rotation, which detects that the image must be rotated clockwise to
 look "straight", appliedRotation will be GSKRotationClockwise. The output image orientation will be UIImageOrientationUp.
 */
@property (nonatomic, assign, readonly) GSKRotation appliedRotation;

@end

NS_ASSUME_NONNULL_END
