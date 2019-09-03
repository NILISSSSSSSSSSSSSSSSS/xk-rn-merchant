//
//  XKMineCouponPackageCompanyCouponTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineCouponPackageCompanyCouponTableViewCell.h"
#import "XKMineCouponPackageCouponModel.h"
#import "XKTimeSeparateHelper.h"

static const CGFloat kXKMineCouponPackageCompanyCouponTableViewCellTitleLeftMargin = 110;

@interface XKMineCouponPackageCompanyCouponTableViewCell ()

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *cardView;
@property (nonatomic, strong) UIImageView *cardLeftView;
@property (nonatomic, strong) UILabel *cardLeftViewDescribeLabel;
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

@implementation XKMineCouponPackageCompanyCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
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
    self.cardView = cardView;
    UIImageView *cardLeftView = [UIImageView new];
    [cardView addSubview:cardLeftView];
    [cardLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView.mas_right);
        make.top.equalTo(cardView.mas_top);
        make.bottom.equalTo(cardView.mas_bottom);
        make.width.equalTo(cardLeftView.mas_height).multipliedBy(1.2);
    }];
    self.cardLeftView = cardLeftView;
    UILabel *cardLeftViewDescribeLabel = [UILabel new];
    cardLeftViewDescribeLabel.textColor = [UIColor whiteColor];
    cardLeftViewDescribeLabel.textAlignment = NSTextAlignmentCenter;
    cardLeftViewDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:14.0];
    [cardView addSubview:cardLeftViewDescribeLabel];
    [cardLeftViewDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardLeftView.mas_centerY);
        make.right.equalTo(cardLeftView.mas_right).offset(-20 * ScreenScale);
    }];
    self.cardLeftViewDescribeLabel = cardLeftViewDescribeLabel;
    
    // 折扣
    UILabel *discountNumLabel = [UILabel new];
    discountNumLabel.textAlignment = NSTextAlignmentCenter;
    discountNumLabel.textColor = XKMainTypeColor;
    discountNumLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:30.0];
//    discountNumLabel.adjustsFontSizeToFitWidth = YES;
//    discountNumLabel.minimumScaleFactor = 8;
    [cardView addSubview:discountNumLabel];
    [discountNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView.mas_centerY);
        make.centerX.equalTo(cardView.mas_left).offset(kXKMineCouponPackageCompanyCouponTableViewCellTitleLeftMargin / 2 + 5);
        make.left.mas_greaterThanOrEqualTo(cardView.mas_left).offset(25);
    }];
    UILabel *discountTagLabel = [UILabel new];
    discountTagLabel.textColor = XKMainTypeColor;
    discountTagLabel.text = @"¥";
    discountTagLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:16.0];
    [cardView addSubview:discountTagLabel];
    [discountTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView.mas_centerY).offset(4);
        make.right.equalTo(discountNumLabel.mas_left).offset(-1);
    }];
    UILabel *discountUnitLabel = [UILabel new];
    discountUnitLabel.textColor = XKMainTypeColor;
    discountUnitLabel.text = @"折";
    discountUnitLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:16.0];
    [cardView addSubview:discountUnitLabel];
    [discountUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView.mas_centerY).offset(3);
        make.left.equalTo(discountNumLabel.mas_right).offset(1);
    }];
    self.discountNumLabel = discountNumLabel;
    self.discountTagLabel = discountTagLabel;
    self.discountUnitLabel = discountUnitLabel;
    
    // 标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:16.0];
    [cardView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView.mas_top).offset(18);
//        make.left.equalTo(discountUnitLabel.mas_right).offset(2).priorityLow();
//        make.left.mas_greaterThanOrEqualTo(cardView.mas_left).offset(kXKMineCouponPackageCompanyCouponTableViewCellTitleLeftMargin * ScreenScale).priorityLow();
        make.left.equalTo(cardView.mas_left).offset(kXKMineCouponPackageCompanyCouponTableViewCellTitleLeftMargin * ScreenScale);
        make.right.equalTo(cardLeftView.mas_left).offset(-1);
    }];
    self.titleLabel = titleLabel;
    
    // 使用按钮
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [useButton addTarget:self action:@selector(clickUseButton:) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:useButton];
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cardLeftView);
    }];
    self.useButton = useButton;
    
    // 剩余张数
    UILabel *countLabel = [UILabel new];
    countLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardLeftView.mas_right).offset(-20 * ScreenScale);
//        make.centerX.equalTo(cardLeftViewDescribeLabel.mas_centerX);
        make.bottom.equalTo(cardView.mas_bottom).offset(-10);
    }];
    self.countLabel = countLabel;
    
    // 限制条件
    UILabel *limitLabel = [UILabel new];
    limitLabel.textColor = [UIColor darkTextColor];
    limitLabel.numberOfLines = 2;
    limitLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    [cardView addSubview:limitLabel];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.equalTo(titleLabel.mas_left);
    }];
    self.limitLabel = limitLabel;
    
    // 有效期
    UILabel *dateLabel = [UILabel new];
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
    [cardView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cardView.mas_bottom).offset(-10);
        make.left.equalTo(cardView.mas_left).offset(18);
    }];
    self.dateLabel = dateLabel;
    
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
    countChangeLabel.textColor = [UIColor whiteColor];
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
    [countSubtractionButton setImage:[UIImage imageNamed:@"xk_ic_coupon_package_subtraction"] forState:UIControlStateNormal];
    [countSubtractionButton addTarget:self action:@selector(clickCountSubtractionButton:) forControlEvents:UIControlEventTouchUpInside];
    [countChangeView addSubview:countSubtractionButton];
    [countSubtractionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(countChangeLabel.mas_centerY);
        make.right.equalTo(countChangeLabel.mas_left);
        make.width.height.offset(15);
    }];
    
    UIButton *countAdditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [countAdditionButton setImage:[UIImage imageNamed:@"xk_ic_coupon_package_addition"] forState:UIControlStateNormal];
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
    
    self.cardView.image = [UIImage imageNamed:@"xk_bg_company_coupon"];
    self.cardLeftView.image = [UIImage imageNamed:@"xk_bg_company_coupon_left"];
    self.cardLeftViewDescribeLabel.text = @"去使用";
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.limitLabel.textColor = [UIColor darkTextColor];
    self.discountNumLabel.textColor = XKMainTypeColor;
    self.discountTagLabel.textColor = XKMainTypeColor;
    self.useButton.hidden = NO;
    self.countLabel.textColor = [UIColor yellowColor];
    
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
    
    self.cardView.image = [UIImage imageNamed:@"xk_bg_company_overdue_coupon"];
    self.cardLeftView.image = [UIImage imageNamed:@"xk_bg_company_overdue_coupon_left"];
    self.cardLeftViewDescribeLabel.text = @"已过期";
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.limitLabel.textColor = [UIColor lightGrayColor];
    self.discountNumLabel.textColor = [UIColor lightGrayColor];
    self.discountTagLabel.textColor = [UIColor lightGrayColor];
    self.useButton.hidden = YES;
    self.countLabel.textColor = [UIColor whiteColor];
    
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
    
    if ([self.cardLeftViewDescribeLabel.text isEqualToString:@"去使用"]) {
        self.cardLeftViewDescribeLabel.hidden = YES;
        self.useButton.hidden = YES;
    } else {
        self.cardLeftViewDescribeLabel.hidden = NO;
        self.useButton.hidden = NO;
    }
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
    
    self.cardLeftViewDescribeLabel.hidden = NO;
    self.useButton.hidden = NO;
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
    
    [self.delegate companyCouponTableViewCell:self updateModel:self.couponItem];
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
        [self.delegate companyCouponTableViewCell:self updateModel:self.couponItem];
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
    [self.delegate companyCouponTableViewCell:self updateModel:self.couponItem];
}

@end
