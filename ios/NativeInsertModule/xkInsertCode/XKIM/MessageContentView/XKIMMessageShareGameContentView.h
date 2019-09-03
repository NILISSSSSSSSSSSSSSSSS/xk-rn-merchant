//
//  XKIMMessageShareGameContentView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMSessionMessageContentView.h"

@class XKCommonStarView;

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageShareGameContentView : XKIMMessageBaseContentView

@property (nonatomic, strong) UIImageView *gameCoverImgView;

@property (nonatomic, strong) UILabel *gameNameLab;

@property (nonatomic, strong) UILabel *starLab;

@property (nonatomic, strong) XKCommonStarView *starView;

@property (nonatomic, strong) UILabel *starValueLab;

@property (nonatomic, strong) UILabel *gameDespLab;

@property (nonatomic, strong) UILabel *lineH;

@property (nonatomic, strong) UILabel *fromLab;

@end

NS_ASSUME_NONNULL_END
