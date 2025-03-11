//
//  GSKCurvatureCorrectionConfiguration.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A GSKCurvatureCorrectionConfiguration defines the behavior of a GSKScanProcessor when applying curvature correction.
@interface GSKCurvatureCorrectionConfiguration : NSObject

/// The default configuration. This currently doesn't apply the curvature correction configuration, but this can change in future versions
/// of the SDK.
+ (instancetype)defaultCurvatureCorrectionConfiguration;

/// No curvature correction
+ (instancetype)noCurvatureCorrectionConfiguration;

/// Specifies whether or not you want curvature correction
+ (instancetype)curvatureCorrectionConfigurationWithCurvatureCorrection:(BOOL)curvatureCorrection;

@end

NS_ASSUME_NONNULL_END
