//
//  XKSqureSectionFooterView.h
//  XKSquare
//
//  Created by hupan on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FooterViewBlock)(UIButton *sender);

@interface XKSqureSectionFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView           *backView;
@property (nonatomic, copy  ) FooterViewBlock  footerViewBlock;

- (void)setFooterViewWithTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font;

- (void)setFooterViewImg:(UIImage *)img;

- (void)setFooterButtonTag:(NSInteger)tag;

- (void)hiddenLineView:(BOOL)hidden;

@end
