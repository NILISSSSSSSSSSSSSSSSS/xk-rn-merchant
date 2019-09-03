//
//  XKIMBaseChatInputView.h
//  XKSquare
//
//  Created by william on 2018/8/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NIMInputProtocol.h"
#import "NIMSessionConfig.h"
#import "NIMInputAtCache.h"
#import "XKIMBaseChatInputToolbar.h"
@class NIMInputMoreContainerView;
@class NIMInputEmoticonContainerView;


@protocol XKIMBaseChatInputDelegate <NSObject>

@optional

- (void)didChangeInputHeight:(CGFloat)inputHeight;

@end
@interface XKIMBaseChatInputView : UIView
@property (nonatomic, strong) NIMSession             *session;

@property (nonatomic, assign) NSInteger              maxTextLength;

@property (assign, nonatomic, getter=isRecording)    BOOL recording;

@property (strong, nonatomic)  XKIMBaseChatInputToolbar *toolBar;
@property (strong, nonatomic)  UIView *moreContainer;
@property (strong, nonatomic)  UIView *emoticonContainer;

@property (nonatomic, assign) XKIMInputStatus status;
@property (nonatomic, strong) NIMInputAtCache *atCache;

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<NIMSessionConfig>)config;

- (void)reset;

- (void)refreshStatus:(XKIMInputStatus)status;

- (void)setInputDelegate:(id<XKIMBaseChatInputDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<NIMInputActionDelegate>)actionDelegate;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;
- (void)updateAudioRecordTime:(NSTimeInterval)time;
- (void)updateVoicePower:(float)power;

@end
