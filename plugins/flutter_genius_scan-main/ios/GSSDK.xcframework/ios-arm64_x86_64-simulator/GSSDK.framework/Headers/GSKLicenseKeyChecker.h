//
//  GSKLicenseKeyChecker.h
//  GSSDK
//
//  Created by Bruno Virlet on 15/03/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSKLicenseKeyChecker : NSObject

+ (BOOL)checkLicenseWithError:(NSError *__autoreleasing  _Nullable * _Nullable)error;

#if DEBUG
/// Enables simulating an invalid license in the tests. 
@property (nonatomic, class, assign) BOOL simulateInvalid;
#endif

@end

NS_ASSUME_NONNULL_END
