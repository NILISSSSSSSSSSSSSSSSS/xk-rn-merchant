//
//  XKMineCouponPackageTerminalCouponTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineCouponPackageTerminalCouponTableViewCell.h"
#import "XKMineCouponPackageCouponModel.h"

@interface XKMineCouponPackageTerminalCouponTableViewCell ()

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *cardView;
@property (nonatomic, strong) UIImageView *cardLeftView;
@property (nonatomic, strong) UIImageView *cardRightView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *limitLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *discountNumLabel;
@property (nonatomic, strong) UILabel *discountTagLabel;
@property (nonatomic, strong) UILabel *discountUnitLabel;
@property (nonatomic, strong) UIButton *useButton;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *countChangeView;
@property (nonatomic, strong) UILabel *countChangeLabel;
@property (nonatomic, strong) XKMineCouponPackageCouponItem *couponItem;

@end

@implementation XKMineCouponPackageTerminalCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 选择按钮
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10 * ScreenScale);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.offset(20 * ScreenScale);
    }];
    self.selectButton = selectButton;
    
    // 卡视图
    UIImageView *cardView = [UIImageView new];
    cardView.userInteractionEnabled = YES;
    cardView.backgroundColor = self.contentView.backgroundColor;
    [self.contentView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectButton.mas_right).offset(10 * ScreenScale);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.offset(90);
    }];
    UIImageView *cardLeftView = [UIImageView new];
    cardLeftView.backgroundColor = self.contentView.backgroundColor;
    [cardView addSubview:cardLeftView];
    [cardLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView.mas_left);
        make.top.equalTo(cardView.mas_top);
        make.bottom.equalTo(cardView.mas_bottom);
        make.width.equalTo(cardView.mas_width).multipliedBy(0.7);
    }];
    UIImageView *cardRightView = [UIImageView new];
    cardRightView.backgroundColor = self.contentView.backgroundColor;
    [cardView addSubview:cardRightView];
    [cardRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView.mas_top);
        make.left.equalTo(cardLeftView.mas_right);
        make.bottom.equalTo(cardView.mas_bottom);
        make.right.equalTo(cardView.mas_right);
    }];
    self.cardView = cardView;
    self.cardLeftView = cardLeftView;
    self.cardRightView = cardRightView;
    
    // 折扣
    UILabel *discountNumLabel = [UILabel new];
    discountNumLabel.textColor = RGB(241, 114, 94);
    discountNumLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:30.0];
//    discountNumLabel.adjustsFontSizeToFitWidth = YES;
//    discountNumLabel.minimumScaleFactor = 8;
    [cardView addSubview:discountNumLabel];
    [discountNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView.mas_top).offset(6);
        make.left.equalTo(cardView.mas_left).offset(18 * ScreenScale);
    }];
    UILabel *discountTagLabel = [UILabel new];
    discountTagLabel.textColor = RGB(241, 114, 94);
    discountTagLabel.text = @"¥";
    discountTagLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:16.0];
    [cardView addSubview:discountTagLabel];
    [discountTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(discountNumLabel.mas_bottom).offset(-4);
        make.left.equalTo(discountNumLabel.mas_right).offset(1);
    }];
    UILabel *discountUnitLabel = [UILabel new];
    discountUnitLabel.textColor = RGB(241, 114, 94);
    discountUnitLabel.text = @"折";
    discountUnitLabel.font = [UIFont fontWithName:XK_PingFangSC_Semibold size:16.0];
    [cardView addSubview:discountUnitLabel];
    [discountUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(discountNumLabel.mas_bottom).offset(-6);
        make.left.equalTo(discountNumLabel.mas_right).offset(1);
    }];
    self.discountNumLabel = discountNumLabel;
    self.discountTagLabel = discountTagLabel;
    self.discountUnitLabel = discountUnitLabel;
    
    // 标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Semibold size:12.0];
    [cardView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(discountNumLabel.mas_bottom).offset(-6);
        make.left.equalTo(discountNumLabel.mas_right).offset(22);
    }];
    self.titleLabel = titleLabel;
    
    // 有效期
    UILabel *dateLabel = [UILabel new];
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
    [cardView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(discountNumLabel.mas_bottom).offset(3);
        make.left.equalTo(discountNumLabel.mas_left);
    }];
    self.dateLabel = dateLabel;
    
    // 限制条件
    UILabel *limitLabel = [UILabel new];
    limitLabel.textColor = [UIColor darkTextColor];
    limitLabel.numberOfLines = 2;
    limitLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    [cardView addSubview:limitLabel];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(1);
        make.left.equalTo(discountNumLabel.mas_left);
    }];
    self.limitLabel = limitLabel;
    
    // 使用按钮
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [useButton setTitle:@"去使用" forState:UIControlStateNormal];
    [useButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    useButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [useButton addTarget:self action:@selector(clickUseButton:) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:useButton];
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView.mas_right);
        make.top.equalTo(cardView.mas_top);
        make.bottom.equalTo(cardView.mas_bottom);
        make.width.offset(90);
    }];
    self.useButton = useButton;
    
    // 剩余张数
    UILabel *countLabel = [UILabel new];
    countLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(useButton.mas_centerX);
        make.bottom.equalTo(cardView.mas_bottom).offset(-10);
    }];
    self.countLabel = countLabel;
    
    // 修改数量视图
    UIView *countChangeView = [UIView new];
    countChangeView.hidden = YES;
    [cardView addSubview:countChangeView];
    [countChangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(countLabel.mas_centerX);
        make.top.equalTo(countLabel.mas_bottom).offset(5);
        make.width.offset(60);
        make.height.offset(30);
    }];
    self.countChangeView = countChangeView;
    
    UILabel *countChangeLabel = [UILabel new];
    countChangeLabel.textColor = [UIColor darkTextColor];
    countChangeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    countChangeLabel.text = @"0";
    countChangeLabel.textAlignment = NSTextAlignmentCenter;
    [countChangeView addSubview:countChangeLabel];
    [countChangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(countChangeView.mas_centerX);
        make.centerY.equalTo(countChangeView.mas_centerY);
        make.width.offset(30);
    }];
    self.countChangeLabel = countChangeLabel;
    
    UIButton *countSubtractionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [countSubtractionButton setImage:[UIImage imageNamed:@"xk_ic_coupon_package_terminal_coupon_subtraction"] forState:UIControlStateNormal];
    [countSubtractionButton addTarget:self action:@selector(clickCountSubtractionButton:) forControlEvents:UIControlEventTouchUpInside];
    [countChangeView addSubview:countSubtractionButton];
    [countSubtractionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(countChangeLabel.mas_centerY);
        make.right.equalTo(countChangeLabel.mas_left);
        make.width.height.offset(15);
    }];
    
    UIButton *countAdditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [countAdditionButton setImage:[UIImage imageNamed:@"xk_ic_coupon_package_terminal_coupon_addition"] forState:UIControlStateNormal];
    [countAdditionButton addTarget:self action:@selector(clickCountAdditionButton:) forControlEvents:UIControlEventTouchUpInside];
    [countChangeView addSubview:countAdditionButton];
    [countAdditionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(countChangeLabel.mas_centerY);
        make.left.equalTo(countChangeLabel.mas_right);
        make.width.height.offset(15);
    }];
    
    return self;
}

- (void)configCellWithModel:(XKMineCouponPackageCouponItem *)couponItem {
    
    self.couponItem = couponItem;
    
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    self.cardView.image = [UIImage imageNamed:@""];
    self.cardLeftView.image = [UIImage imageNamed:@"xk_bg_terminal_coupon_left"];
    self.cardRightView.image = [UIImage imageNamed:@"xk_bg_terminal_coupon_right"];
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.limitLabel.textColor = [UIColor darkTextColor];
    self.discountNumLabel.textColor = RGB(241, 114, 94);
    self.discountTagLabel.textColor = RGB(241, 114, 94);
    self.useButton.hidden = NO;
    [self.useButton setTitle:@"去使用" forState:UIControlStateNormal];
    self.countLabel.textColor = RGB(241, 114, 94);
    
    if (couponItem.couponType && couponItem.couponType.length != 0) {
        if ([couponItem.couponType isEqualToString:@"DISCOUNT"]) {
            self.discountTagLabel.hidden = NO;
            self.discountTagLabel.text = @"¥";
            self.discountUnitLabel.hidden = YES;
            self.discountUnitLabel.text = @"";
            self.discountNumLabel.text = couponItem.price;
        } else {
            self.discountTagLabel.hidden = YES;
            self.discountTagLabel.text = @"";
            self.discountUnitLabel.hidden = NO;
            self.discountUnitLabel.text = @"折";
            self.discountNumLabel.text = couponItem.price;
        }
    }
    if (couponItem.couponName && couponItem.couponName.length != 0) {
        self.titleLabel.text = couponItem.couponName;
    }
    if (couponItem.message && couponItem.message.length != 0) {
        self.limitLabel.text = couponItem.message;
    }
    NSString *validString = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(couponItem.validTime)]];
    NSString *invalidString = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(couponItem.invalidTime)]];
    self.dateLabel.text = [NSString stringWithFormat:@"有效期 %@至%@", validString, invalidString];
    self.countLabel.text = [NSString stringWithFormat:@"剩余 %@ 张", @(couponItem.cards)];
    self.selectButton.selected = couponItem.isSelected;
}

- (void)configOverdueCellWithModel:(XKMineCouponPackageCouponItem *)couponItem {
    
    self.couponItem = couponItem;
    
    self.contentView.backgroundColor = HEX_RGB(0xFFFFFF);
    self.cardView.image = [UIImage imageNamed:@""];
    self.cardLeftView.image = [UIImage imageNamed:@"xk_bg_terminal_overdue_coupon_left"];
    self.cardRightView.image = [UIImage imageNamed:@"xk_bg_terminal_overdue_coupon_right"];
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.limitLabel.textColor = [UIColor darkTextColor];
    self.discountNumLabel.textColor = RGB(241, 114, 94);
    self.discountTagLabel.textColor = RGB(241, 114, 94);
    self.useButton.hidden = YES;
    [self.useButton setTitle:@"" forState:UIControlStateNormal];
    self.countLabel.textColor = [UIColor darkGrayColor];
    
    if (couponItem.couponType && couponItem.couponType.length != 0) {
        if ([couponItem.couponType isEqualToString:@"DISCOUNT"]) {
            self.discountTagLabel.hidden = NO;
            self.discountTagLabel.text = @"¥";
            self.discountUnitLabel.hidden = YES;
            self.discountUnitLabel.text = @"";
            self.discountNumLabel.text = couponItem.price;
        } else {
            self.discountTagLabel.hidden = YES;
            self.discountTagLabel.text = @"";
            self.discountUnitLabel.hidden = NO;
            self.discountUnitLabel.text = @"折";
            self.discountNumLabel.text = couponItem.price;
        }
    }
    if (couponItem.couponName && couponItem.couponName.length != 0) {
        self.titleLabel.text = couponItem.couponName;
    }
    if (couponItem.message && couponItem.message.length != 0) {
        self.limitLabel.text = couponItem.message;
    }
    NSString *validString = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(couponItem.validTime)]];
    NSString *invalidString = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(couponItem.invalidTime)]];
    self.dateLabel.text = [NSString stringWithFormat:@"有效期 %@至%@", validString, invalidString];
    
    self.countLabel.text = [NSString stringWithFormat:@"%@张", @(couponItem.cards)];
    self.selectButton.selected = couponItem.isSelected;
}

- (void)showSelectButton {
    
    self.selectButton.hidden = NO;
    [self.selectButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20 * ScreenScale);
        make.left.equalTo(self.contentView.mas_left).offset(10 * ScreenScale);
    }];
    [self.cardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right).offset(10 * ScreenScale);
    }];
    
    self.useButton.hidden = YES;
}

- (void)hiddenSelectButton {
    
    self.selectButton.hidden = YES;
    [self.selectButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0);
        make.left.equalTo(self.contentView.mas_left);
    }];
    [self.cardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right).offset(10);
    }];
    
    if ([self.useButton.titleLabel.text isEqualToString:@"去使用"]) {
        self.useButton.hidden = NO;
    } else {
        self.useButton.hidden = YES;
    }
}

- (void)showCountChangeView {
    
    self.countChangeView.hidden = NO;
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardView.mas_bottom).offset(-50);
    }];
}

- (void)hiddenCountChangeView {
    
    self.countChangeView.hidden = YES;
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardView.mas_bottom).offset(-10);
    }];
}

- (void)showCountLabel {
    self.countLabel.hidden = NO;
}

- (void)hiddenCountLabel {
    self.countLabel.hidden = YES;
}

- (void)clickUseButton:(UIButton *)sender {
    
}

- (void)clickSelectButton:(UIButton *)sender {
    
    self.couponItem.isSelected = !self.couponItem.isSelected;
    
    NSInteger count = self.countChangeLabel.text.integerValue;
    if (self.couponItem.isSelected == YES) {
        count = 1;
    } else {
        count = 0;
    }
    self.countChangeLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    self.couponItem.selectedCount = count;
    
    [self.delegate terminalCouponTableViewCell:self updateModel:self.couponItem];
}

- (void)clickCountSubtractionButton:(UIButton *)sender {
    
    NSInteger count = self.countChangeLabel.text.integerValue;
    count -= 1;
    if (count <= 0) {
        count = 0;
    }
    self.couponItem.selectedCount = count;
    self.countChangeLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    
    if (count == 0) {
        self.couponItem.isSelected = 0;
        [self.delegate terminalCouponTableViewCell:self updateModel:self.couponItem];
    }
}

- (void)clickCountAdditionButton:(UIButton *)sender {
    
    NSInteger count = self.countChangeLabel.text.integerValue;
    count += 1;
    if (count >= self.couponItem.cards) {
        count = self.couponItem.cards;
    }
    self.couponItem.selectedCount = count;
    self.countChangeLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    
    self.couponItem.isSelected = 1;
    [self.delegate terminalCouponTableViewCell:self updateModel:self.couponItem];
}

@end
