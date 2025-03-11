//
//  GSKFilterStyle.h
//  GSSDK
//
//  Created by Bruno Virlet on 27/03/2024.
//  Copyright © 2024 The Grizzly Labs. All rights reserved.
//

#ifndef GSKFilterStyle_h
#define GSKFilterStyle_h

/// Style for the magic filter
typedef NS_CLOSED_ENUM(NSInteger, GSKFilterStyle) {
    /// Hint that the scan should be enhanced as a document
    /// (e.g. apply background cleaning)
    GSKFilterStyleDocument
};

#endif /* GSKFilterStyle_h */
