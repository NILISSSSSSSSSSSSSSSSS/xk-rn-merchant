//
//  XKIMMessageRedEnvelopeContentView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMSessionMessageContentView.h"

extern NSString *const XKRedRedEnvelopeOpenEvent;
extern NSString *const XKRedRedEnvelopeDetailEvent;

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageRedEnvelopeContentView : XKIMMessageBaseContentView

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *openedLab;

@property (nonatomic, strong) UIButton *openBtn;

@property (nonatomic, strong) UIView *detailView;

@property (nonatomic, strong) UILabel *detailLab;

@property (nonatomic, strong) UIImageView *arrowImgView;

@end

NS_ASSUME_NONNULL_END
