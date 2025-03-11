//
//  GSKLog.h
//  GSSDK
//

#import <Foundation/Foundation.h>

#import "GSKLogger.h"

NS_ASSUME_NONNULL_BEGIN

/**
 An object to control the logging of the Genius Scan SDK.
 */
@interface GSKLog : NSObject<GSKLogger>

/**
 The SDK logger.

 By default, the SDK will log using NSLog and will not log debug messages.

 Pass nil if you don't want anything logged at all.
 */
@property (class, nonatomic, nullable) id<GSKLogger> logger;

/// The defaut log level used  if `logger` doesn't implement `logLevel`.
@property (class, nonatomic, readonly) GSKLoggerSeverity defaultLogLevel;
/**
 Log a verbose message directly to the SDK logger.

 This is for the SDK internal use. If you want to customize the logger, inject your own GSKLogger as logger.
 */
+ (void)logVerbose:(NSString *)format, ...;
+ (void)logVerbose:(NSString *)format arguments:(va_list)arguments;

/**
 Log a debug message directly to the SDK logger.

 This is for the SDK internal use. If you want to customize the logger, inject your own GSKLogger as logger.
 */
+ (void)logDebug:(NSString *)format, ...;
+ (void)logDebug:(NSString *)format arguments:(va_list)arguments;

/**
 Log an info message directly to the SDK logger.

 This is for the SDK internal use. If you want to customize the logger, inject your own GSKLogger as logger.
 */
+ (void)logInfo:(NSString *)format, ...;
+ (void)logInfo:(NSString *)format arguments:(va_list)arguments;

/**
 Log a warning message directly to the SDK logger.

 This is for the SDK internal use. If you want to customize the logger, inject your own GSKLogger as logger.
 */
+ (void)logWarn:(NSString *)format, ...;
+ (void)logWarn:(NSString *)format arguments:(va_list)arguments;

/**
 Log an error message directly to the SDK logger.

 This is for the SDK internal use. If you want to customize the logger, inject your own GSKLogger as logger.
 */
+ (void)logError:(NSString *)format, ...;
+ (void)logError:(NSString *)format arguments:(va_list)arguments;

@end

NS_ASSUME_NONNULL_END
