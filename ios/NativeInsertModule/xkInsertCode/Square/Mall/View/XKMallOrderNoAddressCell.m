//
//  XKMallOrderNoAddressCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallOrderNoAddressCell.h"

@interface XKMallOrderNoAddressCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *tipLabel;

@end
@implementation XKMallOrderNoAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {

        self.xk_openClip = YES;
        self.xk_radius = 6.f;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
  
    
    [self addSubview:self.iconImgView];
    [self addSubview:self.tipLabel];
}

- (void)addUIConstraint {

    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(5);
        make.top.equalTo(self.iconImgView.mas_top).offset(-3);
        make.right.equalTo(self.mas_right).offset(-70);
    }];
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"xk_btn_welfare_location"];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}


- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        [_tipLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _tipLabel.textColor = UIColorFromRGB(0x555555);
        _tipLabel.numberOfLines = 0;
        _tipLabel.text = @"您还没有添加收货地址，请点击右侧按钮，添加一个收货地址";
    }
    return _tipLabel;
}

@end
