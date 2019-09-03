//
//  XKPushMessageTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPushMessageTableViewCell.h"

@implementation XKPushMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}
- (void)changeSwitchAction:(UISwitch *)sender {
    if (self.switchChangeBLock) {
        self.switchChangeBLock(sender);
    }
}
- (void)initViews {
    UIView *myContentView = [[UIView alloc]init];
    [self.contentView addSubview:myContentView];
    myContentView.backgroundColor = [UIColor whiteColor];
    [myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    label.adjustsFontSizeToFitWidth = YES;
    [myContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(14 * ScreenScale));
        make.centerY.equalTo(myContentView);
        make.height.equalTo(@(20 * ScreenScale));
        make.width.equalTo(@(100 * ScreenScale));
    }];
    
    UILabel *rightLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor whiteColor]];
    rightLabel.adjustsFontSizeToFitWidth = YES;
    rightLabel.textAlignment = NSTextAlignmentRight;
    [myContentView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-80 * ScreenScale));
        make.centerY.equalTo(myContentView);
        make.height.equalTo(@(20 * ScreenScale));
        make.left.equalTo(label.mas_right).offset(10 * ScreenScale);
    }];
    
    UISwitch *xkSwitch = [[UISwitch alloc]init];
    [xkSwitch addTarget:self action:@selector(changeSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [myContentView addSubview:xkSwitch];
    [xkSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(myContentView.mas_centerY);
        make.right.mas_equalTo(myContentView.mas_right).offset(-20 * ScreenScale);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XKSeparatorLineColor;
    [myContentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(myContentView);
        make.height.equalTo(@0.5);
    }];
    self.titleLabel = label;
    self.rightTitlelabel = rightLabel;
    self.xkSwitch = xkSwitch;
}

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}
@end
