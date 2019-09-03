//
//  XKPersonalDataHeaderTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonalDataHeaderTableViewCell.h"

@implementation XKPersonalDataHeaderTableViewCell

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
     [myContentView cutCornerWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-20, 75 * ScreenScale) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    
    UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"头像" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    label.adjustsFontSizeToFitWidth = YES;
    [myContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(14 * ScreenScale));
        make.centerY.equalTo(myContentView);
        make.height.equalTo(@(30 * ScreenScale));
        make.width.equalTo(@(100 * ScreenScale));
    }];
    
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_img_personal_big_header"]];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    [myContentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-34 * ScreenScale));
        make.centerY.equalTo(myContentView);
        make.height.equalTo(@(52));
        make.width.equalTo(@(52));
    }];
    
    self.headerImageView = imageview;
    UIImageView *nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_personal_nextBlack"]];
    [myContentView addSubview:nextImage];
    self.headerImageView.xk_radius = 5;
    self.headerImageView.xk_clipType = XKCornerClipTypeAllCorners;
    self.headerImageView.xk_openClip = YES;
    [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(myContentView.mas_centerY);
        make.right.mas_equalTo(myContentView.mas_right).offset(-15 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(8.8 * ScreenScale, 10 * ScreenScale));
    }];
}

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}
@end
