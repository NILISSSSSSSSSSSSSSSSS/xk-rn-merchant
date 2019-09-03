//
//  XKReceiveMerchantCouponTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKReceiveMerchantCouponTableViewCell.h"
#import "XKReceiveCouponModel.h"


@interface XKReceiveMerchantCouponTableViewCell ()

@property (nonatomic, strong) UIImageView *leftImgView;

@property (nonatomic, strong) UIImageView *rightImgView;

@property (nonatomic, strong) UILabel *prizeLab;

@property (nonatomic, strong) UILabel *reduceLab;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *conditionLab;

@property (nonatomic, strong) UILabel *dateLab;

@property (nonatomic, strong) UIButton *receiveBtn;


@property (nonatomic, strong) XKReceiveCouponModel *merchantCoupon;

@end

@implementation XKReceiveMerchantCouponTableViewCell

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
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.containerView = [[UIView alloc] init];
        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0));
        }];
        
        self.leftImgView = [[UIImageView alloc] init];
        self.leftImgView.image = IMG_NAME(@"xk_img_receiveCenter_merchantCoupon_left");
        [self.containerView addSubview:self.leftImgView];
        [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.containerView);
            make.leading.mas_equalTo(self.containerView);
            make.width.mas_equalTo(self.leftImgView.mas_height).multipliedBy(97.0 / 90.0);
            make.height.mas_equalTo((90.0 * (SCREEN_WIDTH - 10.0)) / 355.0);
        }];
        
        self.rightImgView = [[UIImageView alloc] init];
        self.rightImgView.image = IMG_NAME(@"xk_img_receiveCenter_merchantCoupon_right");
        [self.containerView addSubview:self.rightImgView];
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.bottom.mas_equalTo(self.containerView);
            make.left.mas_equalTo(self.leftImgView.mas_right);
        }];
        
        self.prizeLab = [[UILabel alloc] init];
        self.prizeLab.textAlignment = NSTextAlignmentCenter;
        [self.rightImgView addSubview:self.prizeLab];
        [self.prizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.leftImgView);
            make.leading.trailing.mas_equalTo(self.leftImgView);
        }];
        
        self.reduceLab = [[UILabel alloc] init];
        self.reduceLab.text = @"";
        self.reduceLab.font = XKRegularFont(10.0);
        self.reduceLab.textColor = HEX_RGB(0x999999);
        self.reduceLab.textAlignment = NSTextAlignmentCenter;
        [self.rightImgView addSubview:self.reduceLab];
        [self.reduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.leftImgView).offset(-14.0);
            make.leading.trailing.mas_equalTo(self.leftImgView);
        }];
        
        self.receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.receiveBtn.titleLabel.font = XKRegularFont(12.0);
        [self.receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
        [self.receiveBtn setTitleColor:HEX_RGB(0xEE6161) forState:UIControlStateNormal];
        [self.receiveBtn setTitle:@"已领取" forState:UIControlStateDisabled];
        [self.receiveBtn setTitleColor:HEX_RGB(0xf1f1f1) forState:UIControlStateDisabled];
        [self.rightImgView addSubview:self.receiveBtn];
        [self.receiveBtn addTarget:self action:@selector(receiveBtnAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        self.receiveBtn.layer.cornerRadius = 11.0;
        self.receiveBtn.layer.masksToBounds = YES;
        self.receiveBtn.layer.borderWidth = 1.0;
        self.receiveBtn.layer.borderColor = HEX_RGB(0xEE6161).CGColor;
        [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15.0);
            make.trailing.mas_equalTo(-15.0);
            make.width.mas_equalTo(70.0);
            make.height.mas_equalTo(22.0);
        }];
        
        self.nameLab = [[UILabel alloc] init];
        self.nameLab.font = XKMediumFont(17.0);
        self.nameLab.textColor = HEX_RGB(0x222222);
        [self.rightImgView addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12.0);
            make.leading.mas_equalTo(20.0);
            make.right.mas_equalTo(self.receiveBtn.mas_left).offset(-5.0);
        }];
        
        self.conditionLab = [[UILabel alloc] init];
        self.conditionLab.font = XKRegularFont(12.0);
        self.conditionLab.textColor = HEX_RGB(0x222222);
        [self.rightImgView addSubview:self.conditionLab];
        [self.conditionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLab.mas_bottom);
            make.leading.trailing.mas_equalTo(self.nameLab);
        }];
        
        self.dateLab = [[UILabel alloc] init];
        self.dateLab.font = XKRegularFont(10.0);
        self.dateLab.textColor = HEX_RGB(0x999999);
        [self.rightImgView addSubview:self.dateLab];
        [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-15.0);
            make.leading.mas_equalTo(self.nameLab);
            make.trailing.mas_equalTo(-20.0);
        }];
    }
    return self;
}

- (void)receiveBtnAction:(UIButton *) sender {
    if (self.receiveBtnBlock) {
        self.receiveBtnBlock(self.merchantCoupon);
    }
}

- (void)configCellWithModel:(XKReceiveCouponModel *) merchantCoupon {
    _merchantCoupon = merchantCoupon;
    NSMutableAttributedString *prizeStr;
    if ([self.merchantCoupon.couponType isEqualToString:@"DISCOUNT"]) {
//        折扣券
        prizeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@折", self.merchantCoupon.price]];
    } else if ([self.merchantCoupon.couponType isEqualToString:@"DEDUCTION"]) {
//        抵扣券
        prizeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@¥", self.merchantCoupon.price]];
    } else if ([self.merchantCoupon.couponType isEqualToString:@"FULL_SUB"]) {
//        满减券
        prizeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@¥", self.merchantCoupon.price]];
    }
    [prizeStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xF68871) range:NSMakeRange(0, prizeStr.length)];
    [prizeStr addAttribute:NSFontAttributeName value:XKMediumFont(36.0) range:NSMakeRange(0, prizeStr.length - 1)];
    [prizeStr addAttribute:NSFontAttributeName value:XKMediumFont(17.0) range:NSMakeRange(prizeStr.length - 1, 1)];
    self.prizeLab.attributedText = prizeStr;
    self.conditionLab.hidden = !(self.merchantCoupon.condition && self.merchantCoupon.condition.length);
    self.conditionLab.text = self.merchantCoupon.condition;
    self.nameLab.text = self.merchantCoupon.couponName;
    self.conditionLab.text = self.merchantCoupon.message;
    self.dateLab.text = [NSString stringWithFormat:@"有效期 %@至%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(self.merchantCoupon.validTime)]], [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(self.merchantCoupon.invalidTime)]]];
    self.receiveBtn.enabled = !self.merchantCoupon.isReceived;
    self.receiveBtn.layer.borderColor = self.merchantCoupon.isReceived ? HEX_RGB(0xf1f1f1).CGColor : HEX_RGB(0xEE6161).CGColor;
}

@end
