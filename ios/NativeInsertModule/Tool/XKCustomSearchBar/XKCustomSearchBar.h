//
//  XKCustomSearchBar.h
//  XKSquare
//
//  Created by hupan on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKCustomSearchBar : UIView

@property (nonatomic, strong) UITextField *textField;

- (instancetype)initWithFrame:(CGRect)frame;


- (void)setSearchBarSearchImage:(NSString *)imgName;


- (void)setTextFieldWithBackgroundColor:(UIColor *)backgroundColor
                              tintColor:(UIColor *)tintColor
                               textFont:(UIFont *)font
                              textColor:(UIColor *)textColor
                   textPlaceholderColor:(UIColor *)placeholderColor
                          textAlignment:(NSTextAlignment)textAlignment
                          masksToBounds:(BOOL)masksToBounds;

- (void)setPlaceholderWithStr:(NSString *) placeholderStr
                         font:(UIFont *) textFont
                    textColor:(UIColor *) textColor;

@end
