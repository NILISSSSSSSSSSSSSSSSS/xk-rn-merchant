//
//  BaseViewFactory.m
//  xiaohua
//
//  Created by william on 16/8/12.
//  Copyright © 2016年 zld. All rights reserved.
//

#import "BaseViewFactory.h"

@implementation BaseViewFactory
+ (UITextField *)textFieldWithFrame:(CGRect)frame
                               font:(UIFont *)font
                        placeholder:(NSString *)placeholder
                          textColor:(UIColor *)color
                   placeholderColor:(UIColor *)placeholderColor
                           delegate:(id<UITextFieldDelegate>)delegate
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = font;
    textField.textColor = color;
    textField.placeholder = placeholder;
    textField.delegate = delegate;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (placeholderColor)
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    return textField;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                         font:(UIFont *)font
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    backColor:(UIColor *)backColor
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (backColor) {
        button.backgroundColor = backColor;
    } else {
        button.backgroundColor = [UIColor clearColor];
    }
    return button;
}

+(UIView *)viewWithFram:(CGRect)frame Image:(UIImage *)image textField:(UITextField *)textField withLine:(BOOL)line
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:textField];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImage:image];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.left.mas_equalTo(view.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(image.size.width, image.size.height));
    }];
    if (textField) [view addSubview:textField];
    if (line) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height-0.5, view.bounds.size.width, 1)];
        line.backgroundColor = RGBA(245, 245, 245, 1);
        [view addSubview:line];
    }
    return view;
}

+(UIView *)viewWithFram:(CGRect)frame title:(NSString *)title textField:(UITextField *)textField withLine:(BOOL)line{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:textField];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, frame.size.height)];
    label.text = title;
    label.font = XKRegularFont(14);
    label.textColor = UIColorFromRGB(0x222222);
    label.adjustsFontSizeToFitWidth = YES;
    [view addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(view);
        make.left.mas_equalTo(view.mas_left).offset(15 * ScreenScale);
    }];
    if (textField) [view addSubview:textField];
    if (line) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height-1, view.bounds.size.width, 1)];
        line.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(view.mas_bottom);
            make.left.mas_equalTo(view.mas_left).offset(15 * ScreenScale);
            make.right.mas_equalTo(view.mas_right).offset(-15 * ScreenScale);
            make.height.mas_equalTo(1);
        }];
    }
    return view;
}

+(UILabel *)labelWithFram:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backColor{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = backColor;
    return label;
}


@end
