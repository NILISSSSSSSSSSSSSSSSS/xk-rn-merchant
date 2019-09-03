//
//  XKRedPacketGetViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedPacketGetViewController.h"
#import "XKRedPacketDetailViewController.h"
@interface XKRedPacketGetViewController ()
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) UIImageView  *bgImgView;
@property (nonatomic, strong) UIImageView  *headerImgView;
@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UILabel      *tipLabel;
@property (nonatomic, strong) UILabel      *statusLabel;
@property (nonatomic, strong) UILabel      *detailLabel;
@end

@implementation XKRedPacketGetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handleData {
    [super handleData];
    self.titleStr = @"晓可币红包";
}

- (void)addCustomSubviews {
    XKWeakSelf(ws);
    [self hideNavigation];
    _navBar =  [[XKCustomNavBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kIphoneXNavi(64))];
    [_navBar customBaseNavigationBar];
    _navBar.titleLabel.text = self.titleStr;
    _navBar.backgroundColor = [UIColor clearColor];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
        [ws.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.headerImgView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.detailLabel];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:_navBar];
    [self addUIConstraint];
}

- (void)addUIConstraint {
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(135);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(95);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerImgView.mas_bottom).offset(10);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(20);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 15));
    }];
}


- (void)detailTap {
    XKRedPacketDetailViewController *detail = [XKRedPacketDetailViewController new];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark lazy
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.image = [UIImage imageNamed:@"xk_bg_IM_function_redPacketTop"];
    }
    return _bgImgView;
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
        _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImgView.image = kDefaultHeadImg;
        _headerImgView.layer.cornerRadius = 40.f;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = XKMediumFont(17);
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.text = @"林小姐Msdus的红包";
    }
    return _nameLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = XKRegularFont(14);
        _tipLabel.textColor = UIColorFromRGB(0x555555);
        _tipLabel.text = @"喜发财，大吉大利";
    }
    return _tipLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = UIColorFromRGB(0x222222);
        if (self.type == 1){//如果抢到了红包  这里需要判断具体情况
            NSString *price = @(20.11).stringValue;
            NSString *priceStr = [NSString stringWithFormat:@"%@ 币",price];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
            
            [attrString addAttribute:NSFontAttributeName
                               value:XKRegularFont(60)
                               range:NSMakeRange(0, priceStr.length - 1)];
            
            [attrString addAttribute:NSFontAttributeName
                               value:XKRegularFont(14)
                               range:NSMakeRange(priceStr.length - 1, 1)];
            _statusLabel.attributedText = attrString;
        } else {
            _statusLabel.font = XKRegularFont(36);
            _statusLabel.text = @"红包已被抢完";
        }

    }
    return _statusLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        XKWeakSelf(ws);
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.userInteractionEnabled = YES;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = XKRegularFont(14);
        _detailLabel.textColor = XKMainTypeColor;
         if (self.type == 1){//如果抢到了红包  这里需要判断具体情况
             _detailLabel.text = @"已存入哓可币账户";
         } else {
             [_detailLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                 confer.text(@"查看领取详情 ");
                 confer.appendImage([UIImage imageNamed:@"xk_bg_IM_function_detail"]).bounds(CGRectMake(0, - 2, 7, 12));
             }];
             [_detailLabel bk_whenTapped:^{
                 [ws detailTap];
             }];
         }

    }
    return _detailLabel;
}


@end
