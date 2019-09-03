//
//  XKStoreActivityCouponTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreActivityCouponTableViewCell.h"
#import "XKStoreActivityListCouponModel.h"

@interface XKStoreActivityCouponTableViewCell ()

@property (nonatomic, strong) UIImageView   *cardView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *limitLabel;
@property (nonatomic, strong) UILabel       *dateLabel;
@property (nonatomic, strong) UILabel       *discountNumLabel;
@property (nonatomic, strong) UILabel       *discountTagLabel;
@property (nonatomic, strong) UIButton      *useButton;

@end

@implementation XKStoreActivityCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

- (void)initViews {
    
    [self.contentView addSubview:self.cardView];
    [self.cardView addSubview:self.titleLabel];
    [self.cardView addSubview:self.limitLabel];
    [self.cardView addSubview:self.dateLabel];
    [self.cardView addSubview:self.discountNumLabel];
    [self.cardView addSubview:self.discountTagLabel];
    [self.cardView addSubview:self.useButton];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    
    [self.discountNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView);
        make.width.equalTo(@(ScreenScale *97));
        make.centerY.equalTo(self.cardView);
        
        make.top.equalTo(self.cardView).offset(25);
        make.bottom.equalTo(self.cardView).offset(-25);

    }];
    
    [self.discountTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView);
        make.width.equalTo(@(ScreenScale *97));
        make.top.equalTo(self.discountNumLabel.mas_bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(117*ScreenScale);
        make.top.equalTo(self.cardView).offset(12);
        make.right.equalTo(self.useButton.mas_left).offset(-5);
    }];

    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardView).offset(-15);
        make.width.equalTo(@70);
        make.height.equalTo(@22);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.discountTagLabel);
    }];
}


#pragma mark - Events

- (void)clickUseButton:(UIButton *)sender {
    
}


#pragma mark - getter && setter

- (UIImageView *)cardView {
    if (!_cardView) {
        _cardView = [[UIImageView alloc] init];
        _cardView.image = [UIImage imageNamed:@"xk_bg_terminal_coupon"];
    }
    return _cardView;
}

- (UIButton *)useButton {
    if (!_useButton) {
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_useButton setTitle:@"领取" forState:UIControlStateNormal];
        _useButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        [_useButton setTitleColor:HEX_RGB(0xEE6161) forState:UIControlStateNormal];
        _useButton.layer.borderWidth = 1;
        _useButton.layer.borderColor = HEX_RGB(0xEE6161).CGColor;
        _useButton.layer.cornerRadius = 11;
        _useButton.layer.masksToBounds = YES;
        [_useButton addTarget:self action:@selector(clickUseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.text = @"满减券";
        _titleLabel.textColor = HEX_RGB(0x222222);
        _titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17.0];
    }
    return _titleLabel;
}

- (UILabel *)limitLabel {
    if (!_limitLabel) {
        _limitLabel = [[UILabel alloc] init];
//        _limitLabel.text = @"指定商品可使用";
        _limitLabel.textColor = HEX_RGB(0x222222);
        _limitLabel.numberOfLines = 2;
        _limitLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    }
    return _limitLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
//        _dateLabel.text = @"有效期  2018-09-12至2018-09-25";
        _dateLabel.textColor = HEX_RGB(0x999999);
        _dateLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
    }
    return _dateLabel;
}

- (UILabel *)discountNumLabel {
    if (!_discountNumLabel) {
        _discountNumLabel = [[UILabel alloc] init];
        _discountNumLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:36.0];
        _discountNumLabel.textAlignment = NSTextAlignmentCenter;
        _discountNumLabel.textColor = HEX_RGB(0xF68871);

//        NSString *text = @"100￥";
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
//        [attStr addAttributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]} range:NSMakeRange(text.length-1, 1)];
//        _discountNumLabel.attributedText = attStr;
    }
    return _discountNumLabel;
}

- (UILabel *)discountTagLabel {
    if (!_discountTagLabel) {
        _discountTagLabel = [[UILabel alloc] init];
        _discountTagLabel.textAlignment = NSTextAlignmentCenter;
        _discountTagLabel.textColor = HEX_RGB(0x999999);
//        _discountTagLabel.text = @"满500减100";
        _discountTagLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    }
    return _discountTagLabel;
}

- (void)setVauleWithModel:(CouponItemModel *)model {
    
    //优惠券类型 DISCOUNT 折扣券 DEDUCTION 抵扣券 FULL_SUB 满减券
    NSString *typeStr;
    NSString *Type = @"";
    if ([model.couponType isEqualToString:@"DISCOUNT"]) {
        Type = @"折扣券";
        typeStr = @"折";
    } else if ([model.couponType isEqualToString:@"DEDUCTION"]) {
        Type = @"抵扣券";
        typeStr = @"￥";
    } else {
        Type = @"满减券";
        typeStr = @"￥";
    }
    self.titleLabel.text = Type;
    self.limitLabel.text = model.message;
    self.dateLabel.text = [NSString stringWithFormat:@"有效期  %@至%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:model.validTime] ,[XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:model.invalidTime]];
    
    NSString *text = [NSString stringWithFormat:@"%@%@", model.price, typeStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]} range:NSMakeRange(text.length-1, 1)];
    self.discountNumLabel.attributedText = attStr;
    
    self.discountTagLabel.text = model.couponName;
    
    if (model.whetherDraw) {
        [self.useButton setTitle:@"已领取" forState:UIControlStateNormal];
        self.useButton.enabled = NO;
        [self.useButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.useButton.layer.borderColor = [UIColor grayColor].CGColor;

    } else {
        [self.useButton setTitle:@"领取" forState:UIControlStateNormal];
        self.useButton.enabled = YES;
        [self.useButton setTitleColor:HEX_RGB(0xEE6161) forState:UIControlStateNormal];
        self.useButton.layer.borderColor = HEX_RGB(0xEE6161).CGColor;

    }
}


@end

