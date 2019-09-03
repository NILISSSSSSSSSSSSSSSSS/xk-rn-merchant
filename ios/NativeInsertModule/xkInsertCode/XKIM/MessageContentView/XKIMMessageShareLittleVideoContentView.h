//
//  XKIMMessageShareLittleVideoContentView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMSessionMessageContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageShareLittleVideoContentView : XKIMMessageBaseContentView

@property (nonatomic, strong) UIImageView *videoCoverImgView;

@property (nonatomic, strong) UIImageView *videoPlayImgView;

@property (nonatomic, strong) UIImageView *authorImgView;

@property (nonatomic, strong) UILabel *authorLab;

@property (nonatomic, strong) UILabel *videoDespLab;

@property (nonatomic, strong) UILabel *lineH;

@property (nonatomic, strong) UILabel *fromLab;

@end

NS_ASSUME_NONNULL_END
