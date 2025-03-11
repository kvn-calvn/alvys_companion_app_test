//
//  GSKEnhancementConfiguration.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GSSDK/GSKFilterColorPalette.h>
#import <GSSDK/GSKFilterStyle.h>
#import <GSSDK/GSKFilterType.h>

@class GSKFilterConfiguration;

NS_ASSUME_NONNULL_BEGIN

/// A GSKEnhancementConfiguration defines the behavior of a GSKScanProcessor when applying legibility enhancements.
@interface GSKEnhancementConfiguration : NSObject

/**
 An enhancement configuration that will result in using the best filter, as detected by the Genius Scan SDK.
 */
+ (instancetype)automaticEnhancementConfiguration;

/**
 An enhancement configuration that will result in using the best filter, as detected by the Genius Scan SDK while taking in account the specified constraints.
 */
+ (instancetype)automaticEnhancementConfigurationWithFilterStyle:(GSKFilterStyle)FilterStyle
                                                    colorPalette:(GSKFilterColorPalette)colorPalette NS_SWIFT_NAME(automatic(filterStyle:colorPalette:));

/**
 An enhancement configuration that will result in using the best filter, as detected by the Genius Scan SDK while taking in account the specified constraints.
 */
+ (instancetype)automaticEnhancementConfigurationWithColorPalette:(GSKFilterColorPalette)colorPalette NS_SWIFT_NAME(automatic(colorPalette:));

/**
 An enhancement configuration that will result in using the specified legacy filter.

 Deprecated.
 */
+ (instancetype)enhancementConfigurationWithFilter:(GSKFilterType)filter DEPRECATED_MSG_ATTRIBUTE("Use `filterConfiguration` instead.");

/**
 An enhancement configuration that will result in using the specified filter.
 */
+ (instancetype)fixedEnhancementConfigurationWithFilterConfiguration:(GSKFilterConfiguration *)filterConfiguration NS_SWIFT_NAME(fixed(filterConfiguration:));

@end

NS_ASSUME_NONNULL_END
