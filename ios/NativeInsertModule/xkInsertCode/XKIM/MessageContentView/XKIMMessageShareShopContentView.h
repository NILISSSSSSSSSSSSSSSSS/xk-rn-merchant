//
//  XKIMMessageShareShopContentView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMSessionMessageContentView.h"

@class XKCommonStarView;

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageShareShopContentView : XKIMMessageBaseContentView

@property (nonatomic, strong) UIImageView *shopCoverImgView;

@property (nonatomic, strong) UILabel *shopNameLab;

@property (nonatomic, strong) UILabel *shopDespLab;

@property (nonatomic, strong) XKCommonStarView *starView;

@property (nonatomic, strong) UILabel *starLab;

@property (nonatomic, strong) UILabel *distanceLab;

@property (nonatomic, strong) UILabel *lineV;

@property (nonatomic, strong) UILabel *tradingQuantityLab;

@property (nonatomic, strong) UILabel *lineH;

@property (nonatomic, strong) UILabel *fromLab;

@end

NS_ASSUME_NONNULL_END
