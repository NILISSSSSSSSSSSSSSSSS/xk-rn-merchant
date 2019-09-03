//
//  XKReceiveXKCouponTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKReceiveXKCouponTableViewCell.h"
#import "XKReceiveCouponModel.h"

@interface XKReceiveXKCouponTableViewCell ()

@property (nonatomic, strong) UIImageView *cardView;
@property (nonatomic, strong) UIImageView *cardLeftView;
@property (nonatomic, strong) UILabel *cardLeftViewDescribeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *limitLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *discountNumLabel;
@property (nonatomic, strong) UILabel *discountTagLabel;
@property (nonatomic, strong) UIButton *receiveButton;

@property (nonatomic, strong) XKReceiveCouponModel *XKCoupon;

@end

@implementation XKReceiveXKCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.containerView = [[UIView alloc] init];
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0));
    }];
    
    // 卡视图
    UIImageView *cardView = [UIImageView new];
    cardView.backgroundColor = self.contentView.backgroundColor;
    [self.containerView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.height.offset((90.0 * (SCREEN_WIDTH - 10.0)) / 355.0);
    }];
    self.cardView = cardView;
    UIImageView *cardLeftView = [UIImageView new];
    [cardView addSubview:cardLeftView];
    [cardLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView.mas_right);
        make.top.equalTo(cardView.mas_top);
        make.bottom.equalTo(cardView.mas_bottom);
        make.width.mas_equalTo(120 * ScreenScale);
    }];
    self.cardLeftView = cardLeftView;
    UILabel *cardLeftViewDescribeLabel = [UILabel new];
    cardLeftViewDescribeLabel.textColor = [UIColor whiteColor];
    cardLeftViewDescribeLabel.textAlignment = NSTextAlignmentRight;
    cardLeftViewDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:14.0];
    [cardView addSubview:cardLeftViewDescribeLabel];
    [cardLeftViewDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardLeftView.mas_centerY);
        make.right.equalTo(cardLeftView.mas_right).offset(-22 * ScreenScale);
    }];
    self.cardLeftViewDescribeLabel = cardLeftViewDescribeLabel;
    
    // 使用按钮
    UIButton *receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    receiveButton.titleLabel.font = XKRegularFont(14.0);
    [receiveButton setTitle:@"领取" forState:UIControlStateNormal];
    [receiveButton setTitleColor:HEX_RGB(0xFFFC7B) forState:UIControlStateNormal];
    [receiveButton setTitle:@"已领取" forState:UIControlStateDisabled];
    [receiveButton addTarget:self action:@selector(receiveButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
    [receiveButton setTitleColor:HEX_RGB(0xffffff) forState:UIControlStateDisabled];
    [cardView addSubview:receiveButton];
    [receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView.mas_right);
        make.top.equalTo(cardView.mas_top);
        make.bottom.equalTo(cardView.mas_bottom);
        make.width.offset(90 * ScreenScale);
    }];
    self.receiveButton = receiveButton;
    
    // 标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:18.0];
    [cardView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView.mas_top).offset(10);
        make.left.equalTo(cardView.mas_left).offset(90 * ScreenScale);
        make.right.equalTo(receiveButton.mas_left).offset(30.0);
    }];
    self.titleLabel = titleLabel;
    
    // 限制条件
    UILabel *limitLabel = [UILabel new];
    limitLabel.textColor = [UIColor darkTextColor];
    limitLabel.numberOfLines = 2;
    limitLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    [cardView addSubview:limitLabel];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.right.equalTo(titleLabel);
    }];
    self.limitLabel = limitLabel;
    
    // 有效期
    UILabel *dateLabel = [UILabel new];
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
    [cardView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView.mas_left).offset(25 * ScreenScale);
        make.bottom.equalTo(cardView.mas_bottom).offset(-10);
        make.right.equalTo(titleLabel);
    }];
    self.dateLabel = dateLabel;
    
    // 折扣
    UILabel *discountTagLabel = [UILabel new];
    discountTagLabel.textColor = XKMainTypeColor;
    discountTagLabel.text = @"¥";
    discountTagLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:16.0];
    [cardView addSubview:discountTagLabel];
    [discountTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView.mas_centerY).offset(2);
        make.left.equalTo(cardView.mas_left).offset(25 * ScreenScale);
    }];
    UILabel *discountNumLabel = [UILabel new];
    discountNumLabel.textColor = XKMainTypeColor;
    discountNumLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:30.0];
    [cardView addSubview:discountNumLabel];
    [discountNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView.mas_centerY);
        make.left.equalTo(discountTagLabel.mas_right).offset(3 * ScreenScale);
        make.right.equalTo(titleLabel.mas_left).offset(3 * ScreenScale);
    }];
    self.discountNumLabel = discountNumLabel;
    self.discountTagLabel = discountTagLabel;
    
    return self;
}

- (void)receiveButtonAction:(UIButton *) sender {
    if (self.receiveBtnBlock) {
        self.receiveBtnBlock(self.XKCoupon);
    }
}

- (void)configCellWithModel:(XKReceiveCouponModel *)XKCoupon {
    _XKCoupon = XKCoupon;
    self.cardView.image = IMG_NAME(@"xk_bg_company_coupon");
    self.cardLeftView.image = IMG_NAME(@"xk_bg_company_coupon_left");
    self.titleLabel.text = self.XKCoupon.couponName;
    self.limitLabel.text = self.XKCoupon.condition;
    self.dateLabel.text = [NSString stringWithFormat:@"有效期 %@至%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(self.XKCoupon.validTime)]], [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(self.XKCoupon.invalidTime)]]];
    self.discountNumLabel.text = self.XKCoupon.price;
    self.receiveButton.enabled = !self.XKCoupon.isReceived;
}

@end
