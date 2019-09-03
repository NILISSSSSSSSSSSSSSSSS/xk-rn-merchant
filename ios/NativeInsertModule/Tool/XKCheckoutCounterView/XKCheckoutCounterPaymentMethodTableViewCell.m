//
//  XKCheckoutCounterPaymentMethodTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCheckoutCounterPaymentMethodTableViewCell.h"

@interface XKCheckoutCounterPaymentMethodTableViewCell ()

@end

@implementation XKCheckoutCounterPaymentMethodTableViewCell

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
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.containerView];
        
        self.imgView = [[UIImageView alloc] init];
        [self.containerView addSubview:self.imgView];
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.font = XKRegularFont(14.0);
        self.titleLab.textColor = HEX_RGB(0x222222);
        [self.containerView addSubview:self.titleLab];
        
        self.subTitleLab = [[UILabel alloc] init];
        self.subTitleLab.text = @"支付方式或者比率";
        self.subTitleLab.font = XKRegularFont(12.0);
        self.subTitleLab.textColor = HEX_RGB(0xCCCCCC);
        [self.containerView addSubview:self.subTitleLab];
        
        self.chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chooseBtn.userInteractionEnabled = NO;
        [self.chooseBtn setImage:IMG_NAME(@"xk_ic_contact_nochose") forState:UIControlStateNormal];
        [self.chooseBtn setImage:IMG_NAME(@"xk_ic_contact_chose") forState:UIControlStateSelected];
        [self.chooseBtn setImage:IMG_NAME(@"xk_ic_contact_cannotChose") forState:UIControlStateDisabled];
        [self.containerView addSubview:self.chooseBtn];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
        }];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15.0);
            make.centerY.mas_equalTo(self.containerView);
            make.width.height.mas_equalTo(20.0);
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.containerView.mas_centerY);
            make.left.mas_equalTo(self.imgView.mas_right).offset(8.0);
            make.right.mas_equalTo(self.chooseBtn.mas_left).offset(-8.0);
        }];
        
        [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.containerView.mas_centerY);
            make.left.mas_equalTo(self.imgView.mas_right).offset(8.0);
            make.right.mas_equalTo(self.chooseBtn.mas_left).offset(-8.0);
        }];
        
        [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-15.0);
            make.centerY.mas_equalTo(self.containerView);
            make.width.height.mas_equalTo(20.0);
        }];
    }
    return self;
}

@end
