//
//  XKOrderInputTableViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKBaseTableViewCell.h"
@interface XKOrderInputTableViewCell : XKBaseTableViewCell
@property (nonatomic, strong)UILabel *leftLabel;

@property (nonatomic, strong)UILabel *rightLabel;

@property (nonatomic, strong)UITextField *rightTf;

@property (nonatomic, strong)UIImageView *rightImgView;
//更新约束，以输入框为准
- (void)updateLayout;
//更新约束，leftlabel撑满 换行
- (void)updateTextLayout;
//更新约束，leftlabel撑满 换行
- (void)updateTextLayout;
- (void)setupWithLeftTitle:(NSString *)leftTtitle rightTitle:(NSString *)rightTtile alignment:(NSTextAlignment)alignment rightTextfieldEnable:(BOOL)tFenable rightTextfieldPlaceHolder:(NSString *)placeHolder rightImgViewEnable:(BOOL)Imgenable rightImgViewImgName:(NSString *)imgName;
@end
