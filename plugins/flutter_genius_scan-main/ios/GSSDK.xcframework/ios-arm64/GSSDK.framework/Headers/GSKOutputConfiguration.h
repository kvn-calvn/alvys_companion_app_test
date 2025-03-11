//
//  GSKOutputConfiguration.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A configuration that defines the output of the processing.
 */
@interface GSKOutputConfiguration : NSObject
/**
 JPEG for color images.
 PNG for monochrome images.
 A default, sensible configuration: jpegQuality: 0.60
 */
+ (instancetype)defaultConfiguration;

/**
 JPEG for color images with the specified quality.
 PNG for monochrome images.
 */
+ (instancetype)automaticConfigurationWithJPEGQuality:(CGFloat)quality;

/// Image output will be JPEG, quality 0.60.
+ (instancetype)jpegOutputConfiguration;

/// Image output will be JPEG with specified quality.
+ (instancetype)jpegOutputConfigurationWithQuality:(CGFloat)quality;

/// Image output will be PNG.
+ (instancetype)pngOutputConfiguration;

@end

NS_ASSUME_NONNULL_END
