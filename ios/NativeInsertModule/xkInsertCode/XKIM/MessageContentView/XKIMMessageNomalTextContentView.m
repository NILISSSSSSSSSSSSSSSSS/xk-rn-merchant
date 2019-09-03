//
//  XKIMMessageNomalTextContentView.m
//  XKSquare
//
//  Created by william on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageNomalTextContentView.h"
#import <NIMMessageModel.h>
#import <NIMGlobalMacro.h>
#import <UIView+NIM.h>
#import "XKIMMessageNomalTextAttachment.h"
#import "XKSecretFrientManager.h"
#import "XKSecretMessageFireOtherModel.h"
#import "M80AttributedLabel+XKIM.h"

@interface XKIMMessageNomalTextContentView()

@end


@implementation XKIMMessageNomalTextContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        self.bubbleImageView.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    
  NIMCustomObject *object = data.message.messageObject;
  if ([object.attachment isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
    XKIMMessageNomalTextAttachment *attachment = object.attachment;
    NSString *text = attachment.msgContent;
    [self.textLabel xkim_setText:text];
    if (self.model.message.isOutgoingMsg) {
      self.backgroundColor = UIColorFromRGB(0xedf4ff);
    } else {
      self.backgroundColor = [UIColor whiteColor];
    }
  } else if ([object.attachment isKindOfClass:[XKIMMessageCustomerSerInviteEvaluateAttachment class]]) {
    [self.textLabel xkim_setText:@"邀请评分"];
    if (self.model.message.isOutgoingMsg) {
      self.backgroundColor = UIColorFromRGB(0xedf4ff);
    } else {
      self.backgroundColor = [UIColor whiteColor];
    }
  }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10.0 * ScreenScale, 10.0 * ScreenScale, 10.0 * ScreenScale, 10.0 * ScreenScale));
    }];
    
    [self handleFireView];
}

-(M80AttributedLabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[M80AttributedLabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.font = XKRegularFont(14);
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.underLineForLink = NO;
        _textLabel.autoDetectLinks = YES;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = UIColorFromRGB(0x555555);
        _textLabel.highlightColor = [UIColor clearColor];
        _textLabel.linkColor = XKMainTypeColor;
    }
    return _textLabel;
}

@end
