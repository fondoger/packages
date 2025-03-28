// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@import camera_avfoundation;
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

/// Mock implementation of `FLTCapturePhotoOutput` protocol which allows injecting a custom
/// implementation.
@interface MockCapturePhotoOutput : NSObject <FLTCapturePhotoOutput>

// Properties re-declared as read/write so a mocked value can be set during testing.
@property(nonatomic, strong) AVCapturePhotoOutput *avOutput;
@property(nonatomic, strong) NSArray<AVVideoCodecType> *availablePhotoCodecTypes;
@property(nonatomic, assign) BOOL highResolutionCaptureEnabled;
@property(nonatomic, strong) NSArray<NSNumber *> *supportedFlashModes;

// Stub that is called when the corresponding public method is called.
@property(nonatomic, copy) void (^capturePhotoWithSettingsStub)
    (AVCapturePhotoSettings *, NSObject<AVCapturePhotoCaptureDelegate> *);

// Stub that is called when the corresponding public method is called.
@property(nonatomic, copy) NSObject<FLTCaptureConnection> * (^connectionWithMediaTypeStub)
    (AVMediaType);

@end

NS_ASSUME_NONNULL_END
