//
//  XKIMMessageGiftContentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageGiftContentView.h"
#import "XKIMMessageGiftAttachment.h"
#import "UIView+XKCornerBorder.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"

@interface XKIMMessageGiftContentView()

@end

@implementation XKIMMessageGiftContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.giftImgView];
        [self addSubview:self.giftNumLab];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageGiftAttachment *attachment = object.attachment;
    if (attachment.giftIconUrl && attachment.giftIconUrl.length) {
        [self.giftImgView sd_setImageWithURL:[NSURL URLWithString:attachment.giftIconUrl] placeholderImage:kDefaultPlaceHolderRectImg];
    } else {
        self.giftImgView.image = kDefaultPlaceHolderRectImg;
    }
    self.giftNumLab.text = [NSString stringWithFormat:@"x%tu", attachment.giftNumber];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.giftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.model.message.isOutgoingMsg) {
            make.right.mas_equalTo(self.giftNumLab.mas_left).offset(-10.0);
        } else {
            make.leading.mas_equalTo(self);
        }
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(50.0 * ScreenScale);
    }];
    
    [self.giftNumLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.giftNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        if (self.model.message.isOutgoingMsg) {
            make.trailing.mas_equalTo(self);
        } else {
            make.left.mas_equalTo(self.giftImgView.mas_right).offset(10.0);
        }
    }];
    
    [self handleFireView];
}

#pragma mark - getter setter

- (UIImageView *)giftImgView {
    if (!_giftImgView) {
        _giftImgView = [[UIImageView alloc] init];
        _giftImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImgView;
}

- (UILabel *)giftNumLab {
    if (!_giftNumLab) {
        _giftNumLab = [[UILabel alloc] init];
        _giftNumLab.textColor = XKMainRedColor;
        _giftNumLab.font = XKMediumFont(14.0);
        _giftNumLab.numberOfLines = 1;
    }
    return _giftNumLab;
}

@end
