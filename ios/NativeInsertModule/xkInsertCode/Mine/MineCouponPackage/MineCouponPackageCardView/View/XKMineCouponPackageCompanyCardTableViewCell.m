//
//  XKMineCouponPackageCompanyCardTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMineCouponPackageCompanyCardTableViewCell.h"
#import "XKMineCouponPackageCardModel.h"
#import "XKTimeSeparateHelper.h"

@interface XKMineCouponPackageCompanyCardTableViewCell ()

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *cardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *discountNumLabel;
@property (nonatomic, strong) UILabel *discountUnitLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *countChangeView;
@property (nonatomic, strong) UILabel *countChangeLabel;
@property (nonatomic, strong) XKMineCouponPackageCardItem *cardItem;

@end

@implementation XKMineCouponPackageCompanyCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        make.width.height.equalTo(@20);
    }];
    self.selectButton = selectButton;
    
    // 卡视图
    UIImageView *cardView = [UIImageView new];
    cardView.userInteractionEnabled = YES;
    cardView.backgroundColor = HEX_RGB(0xF6F6F6);
    [self.contentView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectButton.mas_right).offset(10 * ScreenScale);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.offset(110);
    }];
    self.cardView = cardView;
    
    // 卡标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:22.0];
    [cardView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView.mas_top).offset(16);
        make.left.equalTo(cardView.mas_left).offset(18 * ScreenScale);
    }];
    self.titleLabel = titleLabel;
    
    // 折扣
    UILabel *discountNumLabel = [UILabel new];
    discountNumLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:18.0];
    [cardView addSubview:discountNumLabel];
    [discountNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_bottom).offset(2);
        make.left.equalTo(titleLabel.mas_right).offset(4);
    }];
    self.discountNumLabel = discountNumLabel;
    
    UILabel *discountUnitLabel = [UILabel new];
    discountUnitLabel.text = @"折";
    discountUnitLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:11.0];
    [cardView addSubview:discountUnitLabel];
    [discountUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_bottom).offset(-1);
        make.left.equalTo(discountNumLabel.mas_right).offset(1);
    }];
    self.discountUnitLabel = discountUnitLabel;
    
    // 张数
    UILabel *countLabel = [UILabel new];
    countLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_top);
        make.right.equalTo(cardView.mas_right).offset(-18);
    }];
    self.countLabel = countLabel;
    
    // 使用说明
    UILabel *describeLabel = [UILabel new];
    describeLabel.text = @"晓可商城通用";
    describeLabel.textColor = [UIColor whiteColor];
    describeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    [cardView addSubview:describeLabel];
    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(18);
        make.left.equalTo(titleLabel.mas_left);
    }];
    
    // 有效期
    UILabel *dateLabel = [UILabel new];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
    [cardView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(describeLabel.mas_bottom).offset(2);
        make.left.equalTo(titleLabel.mas_left);
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configCellWithModel:(XKMineCouponPackageCardItem *)cardItem {
    
    self.cardItem = cardItem;
    
    self.cardView.image = [UIImage imageNamed:@"xk_bg_company_card"];
    self.selectButton.selected = cardItem.isSelected;
    
    self.titleLabel.textColor = [UIColor yellowColor];
    NSString *titleLabel;
    if ([cardItem.cardType isEqualToString:@"VIP"]) {
        titleLabel = @"VIP";
    } else if ([cardItem.cardType isEqualToString:@"GENERAL"]) {
        titleLabel = @"普通卡";
    }
    self.titleLabel.text = titleLabel;
    
    self.discountNumLabel.text = cardItem.discount;
    self.discountNumLabel.textColor = [UIColor yellowColor];
    self.discountUnitLabel.textColor = [UIColor yellowColor];
    
    NSString *validString = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(cardItem.validTime)]];
    NSString *invalidString = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(cardItem.invalidTime)]];
    self.dateLabel.text = [NSString stringWithFormat:@"有效期 %@ 至 %@", validString, invalidString];
    
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.text = [NSString stringWithFormat:@"剩余 %@ 张", @(cardItem.cards)];
}

- (void)configOverdueCellWithModel:(XKMineCouponPackageCardItem *)cardItem {
    
    self.cardItem = cardItem;
    
    self.cardView.image = [UIImage imageNamed:@"xk_bg_overdue_company_card"];
    self.selectButton.selected = cardItem.isSelected;
    
    self.titleLabel.textColor = [UIColor whiteColor];
    NSString *titleLabel;
    if ([cardItem.cardType isEqualToString:@"VIP"]) {
        titleLabel = @"VIP";
    } else if ([cardItem.cardType isEqualToString:@"GENERAL"]) {
        titleLabel = @"普通卡";
    }
    self.titleLabel.text = titleLabel;
    
    self.discountNumLabel.text = cardItem.discount;
    self.discountNumLabel.textColor = [UIColor whiteColor];
    self.discountUnitLabel.textColor = [UIColor whiteColor];
    
    NSString *validString = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(cardItem.validTime)]];
    NSString *invalidString = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(cardItem.invalidTime)]];
    self.dateLabel.text = [NSString stringWithFormat:@"有效期 %@ 至 %@", validString, invalidString];
    
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.text = [NSString stringWithFormat:@"过期 %@ 张", @(cardItem.cards)];
}

- (void)showSelectButton {
    
    self.selectButton.hidden = NO;
    [self.selectButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.left.equalTo(self.contentView.mas_left).offset(10 * ScreenScale);
    }];
    [self.cardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right).offset(10 * ScreenScale);
    }];
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
}

- (void)showCountChangeView {
    self.countChangeView.hidden = NO;
}

- (void)hiddenCountChangeView {
    self.countChangeView.hidden = YES;
}

- (void)showCountLabel {
    self.countLabel.hidden = NO;
}

- (void)hiddenCountLabel {
    self.countLabel.hidden = YES;
}

- (void)clickSelectButton:(UIButton *)sender {
    
    self.cardItem.isSelected = !self.cardItem.isSelected;
    
    NSInteger count = self.countChangeLabel.text.integerValue;
    if (self.cardItem.isSelected == YES) {
        count = 1;
    } else {
        count = 0;
    }
    self.countChangeLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    self.cardItem.selectedCount = count;
    
    [self.delegate companyCardTableViewCell:self updateModel:self.cardItem];
}

- (void)clickCountSubtractionButton:(UIButton *)sender {
    
    NSInteger count = self.countChangeLabel.text.integerValue;
    count -= 1;
    if (count <= 0) {
        count = 0;
    }
    self.cardItem.selectedCount = count;
    self.countChangeLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    
    if (count == 0) {
        self.cardItem.isSelected = 0;
        [self.delegate companyCardTableViewCell:self updateModel:self.cardItem];
    }
}

- (void)clickCountAdditionButton:(UIButton *)sender {
    
    NSInteger count = self.countChangeLabel.text.integerValue;
    count += 1;
    if (count >= self.cardItem.cards) {
        count = self.cardItem.cards;
    }
    self.cardItem.selectedCount = count;
    self.countChangeLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    
    self.cardItem.isSelected = 1;
    [self.delegate companyCardTableViewCell:self updateModel:self.cardItem];
}

@end
