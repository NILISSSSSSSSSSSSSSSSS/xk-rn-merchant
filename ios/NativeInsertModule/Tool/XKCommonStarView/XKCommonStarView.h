//
//  XKCommonStarView.h
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKCommonStarView;

@protocol XKCommonStarViewDelegate <NSObject>

- (void)starRateView:(XKCommonStarView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent;

@end

@interface XKCommonStarView : UIView

@property (nonatomic, assign) CGFloat scorePercent;     //得分值，范围为0--1，默认为1
@property (nonatomic, assign) BOOL hasAnimation;        //是否允许动画，默认为NO
@property (nonatomic, assign) BOOL allowIncompleteStar; //是否允许不是整星，默认为NO
@property (nonatomic, weak  ) id<XKCommonStarViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars;

@end
