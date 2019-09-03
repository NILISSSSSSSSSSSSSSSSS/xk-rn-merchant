//
//  XKPersonDetailInfoHeaderView.h
//  XKSquare
//
//  Created by william on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKPesonalDetailInfoModel.h"

@interface XKPersonDetailInfoHeaderView : UIView

/**点击事件*/
@property(nonatomic, copy) void(^infoViewClick)(void);

/**重新refresh*/
@property(nonatomic, copy) void(^refreshFrame)(void);

- (CGFloat)getTopInfoViewBtm;

-(void)updateUI:(XKPesonalDetailInfoModel *)model isSecret:(BOOL)isSecret;

/**弹簧*/
- (void)configHeaderViewBackgroundImageWithY:(CGFloat)y;
@end
