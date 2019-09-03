//
//  XKPersonalDataTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonalDataTableViewCell.h"
#import "UIView+XKCornerRadius.h"
@implementation XKPersonalDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.myContentView = [[UIView alloc]init];
    [self.contentView addSubview:self.myContentView];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.myContentView.backgroundColor = [UIColor whiteColor];
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
//    label.adjustsFontSizeToFitWidth = YES;
    [self.myContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(14 * ScreenScale));
        make.centerY.equalTo(self.myContentView);
        make.height.equalTo(@(20 * ScreenScale));
//        make.width.equalTo(@(100 * ScreenScale));
    }];
    
    UILabel *rightLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
    rightLabel.adjustsFontSizeToFitWidth = YES;
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.myContentView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-33 * ScreenScale));
        make.centerY.equalTo(self.myContentView);
        make.height.equalTo(@(20 * ScreenScale));
        make.left.equalTo(label.mas_right).offset(10 * ScreenScale);
    }];
    
    UIImageView *nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_personal_nextBlack"]];
    [self.myContentView addSubview:nextImage];
    [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.myContentView.mas_centerY);
        make.right.mas_equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(8.8 * ScreenScale, 10 * ScreenScale));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XKSeparatorLineColor;
    [self.myContentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.myContentView);
        make.height.equalTo(@1);
    }];
    
    self.smallLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10] textColor:XKMainTypeColor backgroundColor:[UIColor whiteColor]];;
    [self.myContentView addSubview:_smallLabel];
    [self.smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(8);
        make.centerY.equalTo(rightLabel);
    }];
    self.titleLabel = label;
    self.rightTitlelabel = rightLabel;
    self.nextImageView = nextImage;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.myContentView xk_forceClip];
}
@end
