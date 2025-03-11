//
//  GSKResizeResult.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The result of a resizing operation
@interface GSKResizeResult : NSObject

- (instancetype)initWithResizedImagePath:(NSString *)path;

@property (nonatomic, readonly) NSString *resizedImagePath;

@end

NS_ASSUME_NONNULL_END
