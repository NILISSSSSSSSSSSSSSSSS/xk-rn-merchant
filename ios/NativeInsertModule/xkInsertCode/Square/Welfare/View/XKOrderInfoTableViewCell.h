//
//  XKOrderInfoTableViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKOrderInfoTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *leftLabel;

@property (nonatomic, strong)UILabel *rightLabel;

@property (nonatomic, strong)UITextField *rightTf;

@property (nonatomic, strong)UIImageView *rightImgView;

@property (nonatomic, strong) void(^scanfBlock)(void);

- (void)setupWithLeftLabelText:(NSString *)leftText leftLabelFont:(UIFont *)leftFont leftLabelTextColor:(UIColor *)leftColor rightLabelText:(NSString *)rightText rightLabelFont:(UIFont *)rightFont rightLabelTextColor:(UIColor *)rightColor  rightLabelAligment:(NSTextAlignment )alignment rightTextfieldEnable:(BOOL)tfEnable rightTextfieldPlaceHolder:(NSString *)placeHolder rightTextfieldFont:(UIFont *)rightTfFont rightTextfieldTextColor:(UIColor *)rightTfColor rightImgViewEnable:(BOOL)imageEnable rightImgViewImgName:(NSString *)imgName;
@end
