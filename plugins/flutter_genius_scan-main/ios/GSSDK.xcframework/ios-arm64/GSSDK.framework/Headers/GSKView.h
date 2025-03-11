//
// Genius Scan SDK
//
// Copyright 2010-2019 The Grizzly Labs
//
// Subject to the Genius Scan SDK Licensing Agreement
// sdk@thegrizzlylabs.com
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GSKCameraSession;
@class GSKQuadrangle;
@class GSKView;

@protocol GSKViewDelegate <NSObject>

- (void)cameraView:(GSKView *)cameraView requestedFocusAtPoint:(CGPoint)focusPoint;

@end

@interface GSKView : UIView

/// Handle interface orientation change
- (void)initializeRotationWithInterfaceOrientation:(UIInterfaceOrientation)orientation;
- (void)rotateWithCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;

/// Displays the focus indicator at the requested location
- (void)animateFocusAtLocation:(CGPoint)location;

/// Updates the quadrangle overlay. Removes the quadrangle if @param quadrangle is nil.
- (void)updateQuadrangle:(GSKQuadrangle * _Nullable)quadrangle;

- (void)setCameraSession:(GSKCameraSession *)session;
- (void)setCaptureSession:(AVCaptureSession *)session; // Deprecated. Use `setCameraSession` instead.

/**
 Freeze the capture preview. This is very fast as this doesn't interrupt the camera session.
 */
- (void)pausePreview;

/**
 Resumes the capture preview.
 */
- (void)resumePreview;

@property (nonatomic, readonly) UIView *previewView;

/**
 The document frame layer
 */
@property (nonatomic, readonly) CAShapeLayer *frameLayer;
@property (nonatomic, readonly) CAShapeLayer *snapFrameLayer;

@property (nonatomic, copy) UIColor *overlayColor;

@property (nonatomic, weak) id<GSKViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
