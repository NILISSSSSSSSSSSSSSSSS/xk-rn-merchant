//
//  XKOrderAddressTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderAddressTableViewCell.h"

@interface XKOrderAddressTableViewCell ()

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UIButton          *addressButton;
@property (nonatomic, strong) XKHotspotButton   *lookAddressButton;
@property (nonatomic, strong) UIView            *lineview0;
@property (nonatomic, strong) XKHotspotButton   *shareButton;
@property (nonatomic, strong) XKHotspotButton   *phoneBtn;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, copy  ) NSArray           *phoneList;
@property (nonatomic, assign) double            lat;
@property (nonatomic, assign) double            lng;


@end


@implementation XKOrderAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.addressButton];
    [self.contentView addSubview:self.phoneBtn];
    [self.contentView addSubview:self.lookAddressButton];
    [self.contentView addSubview:self.lineview0];
    [self.contentView addSubview:self.shareButton];
    [self.contentView addSubview:self.lineView];

}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
   
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.phoneBtn.mas_left).offset(-5);
    }];

    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        make.width.height.equalTo(@30);
    }];
    
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.lookAddressButton.mas_left).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    
    [self.lookAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressButton);
        make.right.equalTo(self.lineview0.mas_left);
        make.width.height.equalTo(@40);
    }];
    
    [self.lineview0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareButton.mas_left);
        make.centerY.equalTo(self.addressButton);
        make.width.equalTo(@1);
        make.height.equalTo(@20);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressButton);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.height.equalTo(@0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

- (void)showShareButton {
    self.lineview0.hidden = NO;
    [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
    }];
    
}

- (void)setValueWithShopName:(NSString *)shopName phoneList:(NSArray *)phoneList address:(NSString *)address lat:(double)lat lng:(double)lng {
    self.phoneList = phoneList;
    self.lat = lat;
    self.lng = lng;
    self.nameLabel.text = shopName;
    [self.addressButton setTitle:address forState:UIControlStateNormal];
    
}

#pragma mark - Setter

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:18];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"测试火锅（时代中心店）";
    }
    return _nameLabel;
}

- (UIButton *)addressButton {
    if (!_addressButton) {
        _addressButton = [[UIButton alloc] init];
        _addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addressButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_address"] forState:UIControlStateNormal];
        [_addressButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _addressButton.titleLabel.font = XKRegularFont(12);
        [_addressButton setTitleColor:HEX_RGB(0x555555) forState:UIControlStateNormal];
//        [_addressButton setTitle:@"到机动车冻结法欧锦赛的风景哦大家发生纠纷几点几分大的" forState:UIControlStateNormal];
        _addressButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _addressButton;
}


- (XKHotspotButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = [[XKHotspotButton alloc] init];
        [_phoneBtn setImage:[UIImage imageNamed:@"xk_icon_Store_ phone_mainColor"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(reservationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (XKHotspotButton *)lookAddressButton {
    if (!_lookAddressButton) {
        _lookAddressButton = [[XKHotspotButton alloc] init];
        _lookAddressButton.titleLabel.font = XKRegularFont(14);
        [_lookAddressButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [_lookAddressButton setTitle:@"查看" forState:UIControlStateNormal];
        [_lookAddressButton addTarget:self action:@selector(addressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookAddressButton;
}


- (UIView *)lineview0 {
    if (!_lineview0) {
        _lineview0 = [[UIView alloc] init];
        _lineview0.backgroundColor = XKSeparatorLineColor;
        _lineview0.hidden = YES;
    }
    return _lineview0;
}

- (XKHotspotButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[XKHotspotButton alloc] init];
        _shareButton.titleLabel.font = XKRegularFont(14);
        [_shareButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}



#pragma mark - Events


- (void)addressButtonClicked:(UIButton *)sender {
    if (self.addresBtnBlock) {
        self.addresBtnBlock(sender);
    }
}

- (void)shareButtonClicked:(UIButton *)sender {
    if (self.shareStoreButtonBlock) {
        self.shareStoreButtonBlock(sender);
    }    
}

- (void)reservationButtonClicked:(UIButton *)sender {
    if (self.reservationBtnBlock) {
        self.reservationBtnBlock(sender, self.phoneList);
    }
}




@end


