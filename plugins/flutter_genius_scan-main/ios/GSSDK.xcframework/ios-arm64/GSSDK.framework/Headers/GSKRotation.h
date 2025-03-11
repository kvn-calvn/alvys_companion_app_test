//
//  GSKRotation.h
//  GSSDK
//
//  Created by Bruno Virlet on 16/04/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef GSKRotation_h
#define GSKRotation_h

/// Defines an image rotation by increment of 90 degrees.
typedef NS_ENUM(NSInteger, GSKRotation) {
    GSKRotationNone = 0,
    GSKRotationClockwise = 1,
    GSKRotation180 = 2,
    GSKRotationCounterClockwise = 3
};

#endif /* GSKRotation_h */

/// Returns the resulting rotation when applying firstRotation, then secondRotation.
FOUNDATION_EXPORT GSKRotation GSKCombineRotation(GSKRotation firstRotation, GSKRotation secondRotation);
/// Returns the resulting rotation when applying firstRotation, then subtracting secondRotation.
FOUNDATION_EXPORT GSKRotation GSKSubtractRotation(GSKRotation firstRotation, GSKRotation secondRotation);
