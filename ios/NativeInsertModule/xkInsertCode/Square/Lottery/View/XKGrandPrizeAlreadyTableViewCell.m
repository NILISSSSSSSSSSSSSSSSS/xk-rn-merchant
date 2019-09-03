//
//  XKGrandPrizeAlreadyTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGrandPrizeAlreadyTableViewCell.h"
#import "XKGrandPrizeModel.h"

@interface XKGrandPrizeAlreadyTableViewCell ()

@property (nonatomic, strong) UIImageView *prizeImgView;

@property (nonatomic, strong) UILabel *prizeTitleLab;

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *confirmOrderBtn;

@property (nonatomic, strong) UIButton *showBtn;

@property (nonatomic, strong) UIButton *logisticsBtn;

@property (nonatomic, strong) UIButton *detailBtn;


@property (nonatomic, strong) XKGrandPrizeModel *grandPrize;

@end

@implementation XKGrandPrizeAlreadyTableViewCell

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
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.prizeImgView];
    [self.containerView addSubview:self.prizeTitleLab];
    [self.containerView addSubview:self.timeLab];
    [self.containerView addSubview:self.statusLab];
    [self.containerView addSubview:self.detailBtn];
}

- (void)updateViews {
    CGFloat btnWidth = ((SCREEN_WIDTH - 24.0 - 80.0 - 15.0 - 24.0) - 10.0 * 2) / 3;
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    
    [self.prizeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17.0);
        make.leading.mas_equalTo(14.0);
        make.width.height.mas_equalTo(80.0);
    }];
    
    [self.prizeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.prizeImgView);
        make.left.mas_equalTo(self.prizeImgView.mas_right).offset(14.0);
        make.trailing.mas_equalTo(-14.0);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.prizeTitleLab.mas_bottom).offset(12.0);
        make.leading.trailing.mas_equalTo(self.prizeTitleLab);
    }];
    
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(12.0);
        make.leading.trailing.mas_equalTo(self.timeLab);
    }];
    
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLab.mas_bottom).offset(15.0);
        make.trailing.mas_equalTo(self.prizeTitleLab);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(20.0);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-14.0).priorityMedium();
    }];
}

#pragma mark - public method

- (void)configCellWithGrandPrizeModel:(XKGrandPrizeModel *) grandPrize {
    _grandPrize = grandPrize;
    [self.shareBtn removeFromSuperview];
    [self.confirmOrderBtn removeFromSuperview];
    [self.showBtn removeFromSuperview];
    [self.logisticsBtn removeFromSuperview];
    NSInteger temp = arc4random() % 5;
    if (temp == 0) {
        // 未中奖 详情按钮
    } else if (temp == 1) {
//        已中奖，未分享 分享按钮 详情按钮
        [self.containerView addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailBtn);
            make.right.mas_equalTo(self.detailBtn.mas_left).offset(-10.0);
            make.size.mas_equalTo(self.detailBtn);
        }];
    } else if (temp == 2) {
//        已分享但未领取 确认订单按钮（实物才有）/ 晒单按钮（虚拟） +  详情按钮
        [self.containerView addSubview:self.confirmOrderBtn];
        [self.confirmOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailBtn);
            make.right.mas_equalTo(self.detailBtn.mas_left).offset(-10.0);
            make.size.mas_equalTo(self.detailBtn);
        }];
    } else if (temp == 3) {
//        已领取但未晒单 物流按钮（实物才有） 晒单按钮 详情按钮
        [self.containerView addSubview:self.showBtn];
        [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailBtn);
            make.right.mas_equalTo(self.detailBtn.mas_left).offset(-10.0);
            make.size.mas_equalTo(self.detailBtn);
        }];
        if (1) {
//            实物
            [self.containerView addSubview:self.logisticsBtn];
            [self.logisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.showBtn);
                make.right.mas_equalTo(self.showBtn.mas_left).offset(-10.0);
                make.size.mas_equalTo(self.showBtn);
            }];
        }
    } else if (temp == 4) {
//        已晒单 物流按钮（实物才有） 详情按钮
        if (1) {
//            实物
            [self.containerView addSubview:self.logisticsBtn];
            [self.logisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.detailBtn);
                make.right.mas_equalTo(self.detailBtn.mas_left).offset(-10.0);
                make.size.mas_equalTo(self.detailBtn);
            }];
        }
    }
}

#pragma mark - privite method

- (void)shareBtnAction {
    if (self.shareBtnBlock) {
        self.shareBtnBlock(self.grandPrize);
    }
}

- (void)confirmOrderBtnAction {
    if (self.confirmOrderBtnBlock) {
        self.confirmOrderBtnBlock(self.grandPrize);
    }
}

- (void)showBtnAction {
    if (self.showOrderBtnBlock) {
        self.showOrderBtnBlock(self.grandPrize);
    }
}

- (void)logisticsBtnAction {
    if (self.logisticsBtnBlock) {
        self.logisticsBtnBlock(self.grandPrize);
    }
}

- (void)detailBtnAction {
    if (self.detailBtnBlock) {
        self.detailBtnBlock(self.grandPrize);
    }
}

#pragma mark - getter setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)prizeImgView {
    if (!_prizeImgView) {
        _prizeImgView = [[UIImageView alloc] init];
        _prizeImgView.layer.borderWidth = 1.0;
        _prizeImgView.layer.cornerRadius = 10.0;
        _prizeImgView.layer.borderColor = HEX_RGB(0xe7e7e7).CGColor;
    }
    return _prizeImgView;
}

- (UILabel *)prizeTitleLab {
    if (!_prizeTitleLab) {
        _prizeTitleLab = [[UILabel alloc] init];
        _prizeTitleLab.text = @"标题";
        _prizeTitleLab.font = XKRegularFont(14.0);
        _prizeTitleLab.numberOfLines = 2;
    }
    return _prizeTitleLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.text = @"开奖时间";
        _timeLab.font = XKRegularFont(12.0);
        _timeLab.textColor = HEX_RGB(0x555555);
    }
    return _timeLab;
}

- (UILabel *)statusLab {
    if (!_statusLab) {
        _statusLab = [[UILabel alloc] init];
        _statusLab.text = @"开奖状态";
        _statusLab.font = XKRegularFont(12.0);
    }
    return _statusLab;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.titleLabel.font = XKRegularFont(10.0);
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        _shareBtn.layer.cornerRadius = 10.0;
        _shareBtn.layer.masksToBounds = YES;
        _shareBtn.layer.borderWidth = 1.0;
        _shareBtn.layer.borderColor = HEX_RGB(0x999999).CGColor;
        [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)confirmOrderBtn {
    if (!_confirmOrderBtn) {
        _confirmOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmOrderBtn.titleLabel.font = XKRegularFont(10.0);
        [_confirmOrderBtn setTitle:@"领取" forState:UIControlStateNormal];
        [_confirmOrderBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        _confirmOrderBtn.layer.cornerRadius = 10.0;
        _confirmOrderBtn.layer.masksToBounds = YES;
        _confirmOrderBtn.layer.borderWidth = 1.0;
        _confirmOrderBtn.layer.borderColor = HEX_RGB(0x999999).CGColor;
        [_confirmOrderBtn addTarget:self action:@selector(confirmOrderBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmOrderBtn;
}

- (UIButton *)showBtn {
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showBtn.titleLabel.font = XKRegularFont(10.0);
        [_showBtn setTitle:@"晒单" forState:UIControlStateNormal];
        [_showBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        _showBtn.layer.cornerRadius = 10.0;
        _showBtn.layer.masksToBounds = YES;
        _showBtn.layer.borderWidth = 1.0;
        _showBtn.layer.borderColor = HEX_RGB(0x999999).CGColor;
        [_showBtn addTarget:self action:@selector(showBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBtn;
}

- (UIButton *)logisticsBtn {
    if (!_logisticsBtn) {
        _logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logisticsBtn.titleLabel.font = XKRegularFont(10.0);
        [_logisticsBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_logisticsBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        _logisticsBtn.layer.cornerRadius = 10.0;
        _logisticsBtn.layer.masksToBounds = YES;
        _logisticsBtn.layer.borderWidth = 1.0;
        _logisticsBtn.layer.borderColor = XKMainTypeColor.CGColor;
        [_logisticsBtn addTarget:self action:@selector(logisticsBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logisticsBtn;
}

- (UIButton *)detailBtn {
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailBtn.titleLabel.font = XKRegularFont(10.0);
        [_detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        _detailBtn.layer.cornerRadius = 10.0;
        _detailBtn.layer.masksToBounds = YES;
        _detailBtn.layer.borderWidth = 1.0;
        _detailBtn.layer.borderColor = XKMainTypeColor.CGColor;
        [_detailBtn addTarget:self action:@selector(detailBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailBtn;
}

@end
