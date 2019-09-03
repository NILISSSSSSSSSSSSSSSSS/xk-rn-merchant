//
//  XKSquareCouponCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareCouponCell.h"
#import "XKSquareCardCouponModel.h"

@interface XKSquareCouponCell ()

@property (nonatomic, strong) UIImageView   *cardView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *dateLabel;
@property (nonatomic, strong) UILabel       *discountNumLabel;
@property (nonatomic, strong) UILabel       *discountTagLabel;
@property (nonatomic, strong) UIButton      *useButton;

@property (nonatomic, strong) XKSquareCardCouponModel *cardCoupon;

@end

@implementation XKSquareCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initViews];
        [self layoutViews];
    }
    return self;
}

- (void)initViews {
    
    [self.contentView addSubview:self.cardView];
    [self.cardView addSubview:self.titleLabel];
    [self.cardView addSubview:self.dateLabel];
    [self.cardView addSubview:self.discountNumLabel];
    [self.cardView addSubview:self.discountTagLabel];
    [self.cardView addSubview:self.useButton];
}


- (void)layoutViews {
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.top.right.equalTo(self.contentView);
    }];
    
    [self.discountNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ScreenScale *70));
        make.top.equalTo(self.cardView).offset(5);
        make.left.equalTo(self.cardView);
    }];
    
    [self.discountTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView);
        make.top.equalTo(self.discountNumLabel.mas_bottom);
        make.width.equalTo(@(ScreenScale *70));
        make.bottom.equalTo(self.cardView).offset(-10);

    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(80*ScreenScale);
        make.centerY.equalTo(self.discountNumLabel);
        make.right.equalTo(self.useButton.mas_left).offset(-5);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.useButton.mas_left).offset(-3);
        make.centerY.equalTo(self.discountTagLabel);
    }];
    

    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardView).offset(1);
        make.top.bottom.equalTo(self.cardView).offset(0);
        make.width.equalTo(@25);
    }];

}

#pragma mark - Events

- (void)clickUseButton:(UIButton *)sender {
    if (self.useBtnBlock) {
        self.useBtnBlock(self.cardCoupon);
    }
}

- (void)configCellWithCardCouponModel:(XKSquareCardCouponModel *)cardCoupon {
    _cardCoupon = cardCoupon;
    self.discountNumLabel.attributedText = [NSMutableAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text([NSString stringWithFormat:@"%.2f", (CGFloat)self.cardCoupon.price / 100.0]).font(XKMediumFont(26.0)).textColor(HEX_RGB(0xF68871));
        confer.text(@"¥").font(XKMediumFont(27.0)).textColor(HEX_RGB(0xF68871));
    }];
    self.discountTagLabel.text = _cardCoupon.cardMessage;
    self.titleLabel.text = _cardCoupon.cardName;
    self.dateLabel.text = [NSString stringWithFormat:@"有效期%@至%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%tu", _cardCoupon.validTime]], [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%tu", _cardCoupon.invalidTime]]];
}

#pragma mark - getter && setter

- (UIImageView *)cardView {
    if (!_cardView) {
        _cardView = [[UIImageView alloc] init];
        _cardView.image = [UIImage imageNamed:@"xk_bg_terminal_coupon"];
        _cardView.layer.shadowRadius = 5;
        _cardView.layer.shadowColor = [UIColor blackColor].CGColor;
        _cardView.layer.shadowOffset = CGSizeMake(0, 0.5);
        _cardView.layer.shadowOpacity = 0.2;
        _cardView.clipsToBounds = NO;
    }
    return _cardView;
}

- (UIButton *)useButton {
    if (!_useButton) {
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useButton setBackgroundImage:[UIImage imageNamed:@"xk_btn_hone_coupon_use"] forState:UIControlStateNormal];
        [_useButton addTarget:self action:@selector(clickUseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"满减券";
        _titleLabel.textColor = HEX_RGB(0x222222);
        _titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17.0];
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = @"有效期2018-09-12至2018-09-25";
        _dateLabel.textColor = HEX_RGB(0x999999);
        _dateLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
    }
    return _dateLabel;
}

- (UILabel *)discountNumLabel {
    if (!_discountNumLabel) {
        _discountNumLabel = [[UILabel alloc] init];
        _discountNumLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:26.0];
        _discountNumLabel.textAlignment = NSTextAlignmentCenter;

        NSString *text = @"100￥";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attStr addAttributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]} range:NSMakeRange(text.length-1, 1)];
        _discountNumLabel.attributedText = attStr;
        _discountNumLabel.textColor = HEX_RGB(0xF68871);
    }
    return _discountNumLabel;
}

- (UILabel *)discountTagLabel {
    if (!_discountTagLabel) {
        _discountTagLabel = [[UILabel alloc] init];
        _discountTagLabel.textAlignment = NSTextAlignmentCenter;
        _discountTagLabel.textColor = HEX_RGB(0x999999);
        _discountTagLabel.text = @"全场使用";
        _discountTagLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    }
    return _discountTagLabel;
}


@end

