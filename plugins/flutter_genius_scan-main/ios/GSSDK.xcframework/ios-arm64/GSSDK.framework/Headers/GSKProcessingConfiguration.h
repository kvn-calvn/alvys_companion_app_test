//
//  GSKProcessingConfiguration.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSKPerspectiveCorrectionConfiguration;
@class GSKCurvatureCorrectionConfiguration;
@class GSKEnhancementConfiguration;
@class GSKRotationConfiguration;
@class GSKOutputConfiguration;

NS_ASSUME_NONNULL_BEGIN

/**
 The configuration object to configure the GSKProcessor's behavior.

 You can use the default constructors.
 */
@interface GSKProcessingConfiguration : NSObject

+ (instancetype)configurationWithPerspectiveCorrectionConfiguration:(GSKPerspectiveCorrectionConfiguration *)perspectiveCorrectionConfiguration
                                   curvatureCorrectionConfiguration:(GSKCurvatureCorrectionConfiguration *)curvatureCorrectionConfiguration
                                           enhancementConfiguration:(GSKEnhancementConfiguration *)enhancementConfiguration
                                              rotationConfiguration:(GSKRotationConfiguration *)rotationConfiguration
                                                outputConfiguration:(GSKOutputConfiguration *)outputConfiguration;

/**
 Automatic perspective correction, distortion correction, followed by automatic enhancement and automatic rotation. Output is JPEG.
 */
+ (instancetype)defaultConfiguration;

/// Specify how to correct perspective distortions present in the scan (such as when the scan was taken with an angle)
@property (nonatomic, strong, readonly) GSKPerspectiveCorrectionConfiguration *perspectiveCorrectionConfiguration;

/// Specify how to correct curvature distortions present in the scan (such as a bent book)
@property (nonatomic, strong, readonly) GSKCurvatureCorrectionConfiguration *curvatureCorrectionConfiguration;

/// The enhancement configuration. This includes the filters enhancing the legibility of the document.
@property (nonatomic, strong, readonly) GSKEnhancementConfiguration *enhancementConfiguration;

/// The rotation configuration. The rotation will be applied after all the other processing.
@property (nonatomic, strong, readonly) GSKRotationConfiguration *rotationConfiguration;

/// Configures the output format of the processing.
@property (nonatomic, strong, readonly) GSKOutputConfiguration *outputConfiguration;

@end

NS_ASSUME_NONNULL_END
