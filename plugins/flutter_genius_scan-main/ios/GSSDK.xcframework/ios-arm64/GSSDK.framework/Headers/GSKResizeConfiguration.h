//
//  GSKResizeConfiguration.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A GSKResizeConfiguration defines the behavior of a GSKScanProcessor when resizing the processed image.
@interface GSKResizeConfiguration : NSObject

- (instancetype)initWithMaxDimension:(NSUInteger)maxDimension;

@property (nonatomic, assign, readonly) NSUInteger maxDimension;

@end

NS_ASSUME_NONNULL_END
