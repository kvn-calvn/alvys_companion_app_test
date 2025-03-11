#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GSKLoggerSeverity)
{
    /** The severity of a verbose message. Logging verbose messages can have a performance impact. */
    GSKLoggerSeverityVerboseLevel,
    /** The severity of a debug message. Logging debug messages can have a performance impact. Debug messages shouldn't be used in production. */
    GSKLoggerSeverityDebugLevel,
    /** The severity of informative messages. */
    GSKLoggerSeverityInfoLevel,
    /** The severity of warning messages. */
    GSKLoggerSeverityWarnLevel,
    /** The severity of error messages. */
    GSKLoggerSeverityErrorLevel,
};
