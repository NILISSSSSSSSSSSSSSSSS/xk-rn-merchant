//
//  XKStoreSectionHeaderView.h
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ButtonImgDirection_left,
    ButtonImgDirection_right,
    ButtonImgDirection_top,
} ButtonImgDirection;

typedef void(^MoreBtnBlock)(UIButton *sender);

@interface XKStoreSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy  ) MoreBtnBlock moreBlock;
@property (nonatomic, strong) UIView       *backView;

- (void)setTitleName:(NSString *)name titleColor:(UIColor *)color titleFont:(UIFont *)font;
- (void)setMoreButtonImageWithImageName:(NSString *)imgName space:(CGFloat)space imgDirection:(ButtonImgDirection)direction;
- (void)setMoreButtonWithTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font buttonTag:(NSInteger)tag;
- (void)hiddenLineView:(BOOL)hidden;

@end
