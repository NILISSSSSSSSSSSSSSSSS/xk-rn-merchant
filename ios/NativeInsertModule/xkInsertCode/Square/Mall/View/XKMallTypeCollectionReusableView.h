//
//  XKMallTypeCollectionReusableView.h
//  XKSquare
//
//  Created by hupan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKMallTypeCollectionReusableView : UICollectionReusableView

- (void)setTitleWithTitleStr:(NSString *)titleStr titleColor:(UIColor *)color font:(UIFont *)font;
- (void)titleTextAlignmentBotton;
- (void)titleTextAlignmentLeft:(CGFloat)leftMargin;

@end
