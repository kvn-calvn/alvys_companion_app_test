//
//  GSKRotationConfiguration.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GSSDK/GSKRotation.h>

NS_ASSUME_NONNULL_BEGIN

/// A GSKRotationConfiguration defines the behavior of a GSKScanProcessor when rotating the processed image.
@interface GSKRotationConfiguration : NSObject

/**
 A rotation configuration where no rotation is applied.
 */
+ (instancetype)noRotationConfiguration;

/**
 A rotation configuration where Genius Scan automatically detects the document's orientation.
 */
+ (instancetype)automaticRotationConfiguration;

/**
 A rotation with a specific angle. No automatic rotation is applied.
 */
+ (instancetype)rotationConfigurationWithRotation:(GSKRotation)rotation;

@end

NS_ASSUME_NONNULL_END
