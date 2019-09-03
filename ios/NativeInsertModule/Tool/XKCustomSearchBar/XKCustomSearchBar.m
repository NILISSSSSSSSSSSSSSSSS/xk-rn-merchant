//
//  XKCustomSearchBar.m
//  XKSquare
//
//  Created by hupan on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomSearchBar.h"

#define imageViewTag 1234

@interface XKCustomSearchBar ()
@end

@implementation XKCustomSearchBar


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}


- (void)configView {
    
    self.textField.frame = self.bounds;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.textField.frame), CGRectGetHeight(self.textField.frame))];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 8, 15, 15)];
    imageView.tag = imageViewTag;
    imageView.image = [UIImage imageNamed:@"xk_iocn_searchBar"];
    [leftView addSubview:imageView];

    self.textField.leftView = leftView;
    [self addSubview:self.textField];
    
}

- (void)setSearchBarSearchImage:(NSString *)imgName {
    UIView *leftView = self.textField.leftView;
    UIImageView *imgView = [leftView viewWithTag:imageViewTag];
    if (imgView) {
        imgView.image = [UIImage imageNamed:imgName];
    }
}


- (void)setTextFieldWithBackgroundColor:(UIColor *)backgroundColor
                              tintColor:(UIColor *)tintColor
                               textFont:(UIFont *)font
                              textColor:(UIColor *)textColor
                   textPlaceholderColor:(UIColor *)placeholderColor
                          textAlignment:(NSTextAlignment)textAlignment
                          masksToBounds:(BOOL)masksToBounds {
    
    
    UITextField *searchField = self.textField;
    if (searchField) {
        if (masksToBounds) {
            searchField.layer.masksToBounds = masksToBounds;
            searchField.layer.cornerRadius = self.textField.frame.size.height / 2.0f;
        }
        [searchField setBackgroundColor:backgroundColor];
        searchField.font = font;
        searchField.textAlignment = textAlignment;
        searchField.textColor = textColor;
        searchField.tintColor = tintColor;
        [searchField setTintColor:tintColor];
    }
}

- (void)setPlaceholderWithStr:(NSString *)placeholderStr font:(UIFont *)textFont textColor:(UIColor *)textColor {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:placeholderStr];
    [str addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, str.length)];
    self.textField.attributedPlaceholder = str;
}

@end
