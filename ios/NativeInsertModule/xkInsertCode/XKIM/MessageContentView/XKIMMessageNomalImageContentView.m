//
//  XKIMMessageNomalImageContentView.m
//  XKSquare
//
//  Created by william on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageNomalImageContentView.h"
#import "NIMLoadProgressView.h"
#import "XKIMMessageNomalImageAttachment.h"
#import "BigPhotoPerviewHeader.h"
#import "XKTransformHelper.h"
#import "XKGlobleCommonTool.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"
NSString *const NIMMessageNommalImage = @"NIMMessageNommalImage";

@interface XKIMMessageNomalImageContentView()

@property (nonatomic,strong) NIMLoadProgressView * progressView;

@end

@implementation XKIMMessageNomalImageContentView

#pragma mark – Life Cycle

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        self.bubbleImageView.hidden = YES;
        self.backgroundColor = UIColorFromRGB(0xedf4ff);
        [self addSubview:self.imageView];
        [self addSubview:self.progressView];
    }
    return self;
}


#pragma mark – Private Methods
- (void)refresh:(NIMMessageModel *)data
{
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageNomalImageAttachment *attachment = object.attachment;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:attachment.imgUrl]];
    
    self.progressView.hidden = self.model.message.isOutgoingMsg ? (self.model.message.deliveryState != NIMMessageDeliveryStateDelivering) : (self.model.message.attachmentDownloadState != NIMMessageAttachmentDownloadStateDownloading);
    if (!self.progressView.hidden) {
        [self.progressView setProgress:[[[NIMSDK sharedSDK] chatManager] messageTransportProgress:self.model.message]];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.top.mas_equalTo(self.mas_top).offset(10 * ScreenScale);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenScale);
    }];
    
    _progressView.frame = self.bounds;
    
    [self handleFireView];
}

#pragma mark - Events
//点击事件
- (void)onTouchUpInside:(id)sender {
    NSLog(@"图片被点击");
    NSMutableArray *imageArr = [NSMutableArray array];
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
    option.limit = 0;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].conversationManager searchMessages:self.model.message.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        for (NIMMessage *message in messages) {
            if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
                NIMCustomObject *obj = message.messageObject;
                if ([obj.attachment isKindOfClass:[XKIMMessageNomalImageAttachment class]]) {
                    XKIMMessageNomalImageAttachment *attachment = obj.attachment;
                    if (attachment.imgUrl && attachment.imgUrl.length) {
                        [imageArr addObject:attachment.imgUrl];
                    }
                }
            }
        }
        if (imageArr.count) {
            NIMCustomObject *object = self.model.message.messageObject;
            XKIMMessageNomalImageAttachment *attachment = object.attachment;
            [XKGlobleCommonTool showBigImgWithImgsArr:imageArr defualtIndex:[imageArr indexOfObject:attachment.imgUrl] viewController: [self getCurrentUIVC]];
        }
    }];
    
}

- (void)updateProgress:(float)progress
{
    if (progress > 1.0) {
        progress = 1.0;
    }
    self.progressView.progress = progress;
}
#pragma mark – Getters and Setters
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = UIColorFromRGB(0xedf4ff);
    }
    return _imageView;
}

-(NIMLoadProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[NIMLoadProgressView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _progressView.maxProgress = 1.0f;
    }
    return _progressView;
}
@end
