#ifndef GSKBackgroundKind_h
#define GSKBackgroundKind_h

/**
 Defines the document's background.
 */
typedef NS_ENUM(NSInteger, GSKBackgroundKind) {
    /// A light background. Typically white or a very pale color. This is the most common type of documents and is the default.
    GSKBackgroundKindLight,
    /// A dark background. Typically, a business card with a black background.
    GSKBackgroundKindDark
};

#endif /* GSKBackgroundKind_h */
