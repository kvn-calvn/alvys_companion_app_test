//
//  GSKPerspectiveCorrectionConfiguration.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSKQuadrangle;

NS_ASSUME_NONNULL_BEGIN

/// A GSKPerspectiveCorrectionConfiguration defines the behavior of a GSKScanProcessor when applying perspective correction.
@interface GSKPerspectiveCorrectionConfiguration : NSObject

/**
 A configuration that will result in the document being auto-detected, and the perspective correction subsequently applied.
 */
+ (instancetype)automaticPerspectiveCorrectionConfiguration;

/**
 A configuration that will result in no perspective correction being applied.
 */
+ (instancetype)noPerspectiveCorrectionConfiguration;

/**
 A configuration that will result in applying the perspective correction defined by the quadrangle.
 */
+ (instancetype)perspectiveCorrectionConfigurationWithQuadrangle:(GSKQuadrangle *)quadrangle;

@end

NS_ASSUME_NONNULL_END
