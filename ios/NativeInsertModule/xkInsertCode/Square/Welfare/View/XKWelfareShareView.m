//
//  XKWelfareShareView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareShareView.h"

@interface XKWelfareShareView ()

@property (nonatomic, strong) UIButton  *closeBtn;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UIImageView  *iconImgView;
@property (nonatomic, strong) UILabel  *contentLabel;
@property (nonatomic, strong) UIButton  *shareBtn;

@end

@implementation XKWelfareShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addCustomSubviews];
        self.layer.cornerRadius = 10.f;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.closeBtn];
    [self addSubview:self.nameLabel];
    [self addSubview:self.iconImgView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.shareBtn];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(64);
        make.size.mas_equalTo(CGSizeMake(130 * SCREEN_WIDTH / 375, 130 * SCREEN_WIDTH / 375));
    }];
    
}

- (void)closeBtnClick:(UIButton *)sender {
    if (self.closeBlock) {
        self.closeBlock(sender);
    }
}

- (void)shareBtnBtnClick:(UIButton *)sender {
    if (self.shareBlock) {
        self.shareBlock(sender);
    }
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:kDefaultPlaceHolderImg];
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 45, 10, 30, 30)];;
        [_closeBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_close"] forState:0];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH - 84, 20)];
        _nameLabel.textColor = UIColorFromRGB(0x22222);
        _nameLabel.font =  XKRegularFont(17);
        _nameLabel.text = @"提示";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 130 * SCREEN_WIDTH / 375, 130 * SCREEN_WIDTH / 375)];
        _iconImgView.layer.cornerRadius = 6.f;
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImgView;
}

- (UILabel *)contentLabel {
    if(!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImgView.frame) + 20, self.width, 16)];
        _contentLabel.textColor = UIColorFromRGB(0x777777);
        _contentLabel.font =  XKRegularFont(14);
        _contentLabel.text = @"小主分享后，系统才能帮您安排发货哦！";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,  CGRectGetMaxY(_contentLabel.frame) + 30, self.width - 30, 40)];;
        _shareBtn.layer.cornerRadius = 4.f;
        _shareBtn.layer.masksToBounds = YES;
        [_shareBtn setBackgroundColor:XKMainTypeColor];
        _shareBtn.titleLabel.font = XKRegularFont(14);
        [_shareBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_trans"] forState:0];
        [_shareBtn setTitle:@"立即分享" forState:0];
        [_shareBtn addTarget:self action:@selector(shareBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
@end
