//
//  NIMMessageCell+XKIMMultipleSelection.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMMessageCell+XKIMMultipleSelection.h"
#import "NIMMessageModel.h"
#import "NIMAvatarImageView.h"
#import "NIMBadgeView.h"
#import "NIMSessionMessageContentView.h"
#import "NIMKitUtil.h"
#import "NIMSessionAudioContentView.h"
#import "UIView+NIM.h"
#import "NIMKitDependency.h"
#import "M80AttributedLabel.h"
#import "UIImage+NIMKit.h"
#import "NIMSessionUnknowContentView.h"
#import "NIMKitConfig.h"
#import "NIMKit.h"

@implementation NIMMessageCell (XKIMMultipleSelection)

+ (void)load {
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"avatarViewRect")),
                                   class_getInstanceMethod(self.class, @selector(XK_IMMultipleSelection_avatarViewRect)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"makeComponents")),
                                   class_getInstanceMethod(self.class, @selector(XK_IMMultipleSelection_makeComponents)));
}

- (CGRect)XK_IMMultipleSelection_avatarViewRect {
    CGFloat cellWidth = self.contentView.bounds.size.width;
    CGFloat protraitImageWidth = [self avatarSize].width;
    CGFloat protraitImageHeight = [self avatarSize].height;
    CGFloat selfProtraitOriginX   = (cellWidth - self.cellPaddingToAvatar.x - protraitImageWidth);
    return [self model].shouldShowLeft ? CGRectMake(self.cellPaddingToAvatar.x,self.cellPaddingToAvatar.y,protraitImageWidth, protraitImageHeight) :  CGRectMake(selfProtraitOriginX, self.cellPaddingToAvatar.y,protraitImageWidth,protraitImageHeight);
}

- (NIMMessageModel *)model {
    return (NIMMessageModel *)[self valueForKey:@"_model"];
}

- (CGPoint)cellPaddingToAvatar
{
    return [self model].avatarMargin;
}

- (CGSize)avatarSize {
    return [self model].avatarSize;
}

-(void)XK_IMMultipleSelection_makeComponents{
    static UIImage *NIMRetryButtonImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NIMRetryButtonImage = [UIImage nim_imageInKit:@"icon_message_cell_error"];
    });
    //retyrBtn
    self.retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.retryButton setImage:NIMRetryButtonImage forState:UIControlStateNormal];
    [self.retryButton setImage:NIMRetryButtonImage forState:UIControlStateHighlighted];
    [self.retryButton setFrame:CGRectMake(0, 0, 20, 20)];
    [self.retryButton addTarget:self action:@selector(onRetryMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.retryButton];
    
    //audioPlayedIcon
    self.audioPlayedIcon = [NIMBadgeView viewWithBadgeTip:@""];
    [self.contentView addSubview:self.audioPlayedIcon];
    
    //traningActivityIndicator
    self.traningActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    self.traningActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.contentView addSubview:self.traningActivityIndicator];
    
    //headerView
    self.headImageView = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.headImageView addTarget:self action:@selector(onTapAvatar:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressAvatar:)];
    [self.headImageView addGestureRecognizer:gesture];
    [self.contentView addSubview:self.headImageView];
    
    //nicknamel
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.opaque = YES;
    self.nameLabel.font   = [NIMKit sharedKit].config.nickFont;
    self.nameLabel.textColor = [NIMKit sharedKit].config.nickColor;
    [self.nameLabel setHidden:YES];
    [self.contentView addSubview:self.nameLabel];
    
    //readlabel
    self.readButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.readButton.opaque = YES;
    self.readButton.titleLabel.font   = [NIMKit sharedKit].config.receiptFont;
    [self.readButton setTitleColor:[NIMKit sharedKit].config.receiptColor forState:UIControlStateNormal];
    [self.readButton setTitleColor:[NIMKit sharedKit].config.receiptColor forState:UIControlStateHighlighted];
    [self.readButton setHidden:YES];
    [self.readButton addTarget:self action:@selector(onPressReadButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.readButton];
}
@end
