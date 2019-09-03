//
//  XKUnionPersonalHeaderTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2019/5/6.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKUnionPersonalHeaderTableViewCell.h"

@implementation XKUnionPersonalHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.contentView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    UIView *myContentView = [[UIView alloc]init];
    [self.contentView addSubview:myContentView];
    myContentView.backgroundColor = [UIColor whiteColor];
    [myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"用户头像" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    label.adjustsFontSizeToFitWidth = YES;
    [myContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.centerY.equalTo(myContentView);
        make.height.equalTo(@(30));
        make.width.equalTo(@(100));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HEX_RGB(0xF1F1F1);
    [myContentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(myContentView);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.equalTo(@1);
    }];
    
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_img_personal_big_header"]];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    [myContentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-34));
        make.centerY.equalTo(myContentView);
        make.height.equalTo(@(52));
        make.width.equalTo(@(52));
    }];
    
    self.headerImageView = imageview;
    self.headerImageView.xk_radius = 26;
    self.headerImageView.xk_clipType = XKCornerClipTypeAllCorners;
    self.headerImageView.xk_openClip = YES;
}

@end
