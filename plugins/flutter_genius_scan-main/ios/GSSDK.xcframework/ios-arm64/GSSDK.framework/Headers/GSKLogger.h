//
//  GSKLogger.h
//  GSSDK
//
//  Created by Bruno Virlet on 09/01/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import "GSKLoggerSeverity.h"

#ifndef GSKLogger_h
#define GSKLogger_h

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_SENDABLE
@protocol GSKLogger <NSObject>

- (void)log:(NSString *)message severity:(GSKLoggerSeverity)severity;

@optional
/// Only log messages with a severity greater than `logLevel` will be sent to this logger.
@property (nonatomic, readonly) GSKLoggerSeverity logLevel;

@end

NS_ASSUME_NONNULL_END

#endif /* GSKLogger_h */
