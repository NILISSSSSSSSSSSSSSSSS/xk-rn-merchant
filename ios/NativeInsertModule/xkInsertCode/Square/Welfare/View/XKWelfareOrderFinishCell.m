//
//  XKWelfareOrderFinishOpenCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderFinishCell.h"
#import "XKTimeSeparateHelper.h"
@interface XKWelfareOrderFinishCell ()
@property (nonatomic, strong)UIButton *choseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)WelfareOrderDataItem *item;
@end

@implementation XKWelfareOrderFinishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.backgroundColor = [UIColor clearColor];
        self.bgContainView.xk_openClip = YES;
        self.bgContainView.xk_radius = 6;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bgContainView];
    
    [self.bgContainView addSubview:self.choseBtn];
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.nameLabel];
    [self.bgContainView addSubview:self.timeLabel];
    [self.bgContainView addSubview:self.statusLabel];
    [self.bgContainView addSubview:self.againBtn];
    
    
}

- (void)bindData:(WelfareOrderDataItem *)item {
    _item = item;
   
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.name;
    NSString *time = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:@(item.lotteryTime).stringValue];
    self.timeLabel.text = [NSString stringWithFormat:@"中奖时间：%@",time];
    NSString *status = @"";
    if([item.state isEqualToString:@"NO_LOTTERY"]) {
        status = @"未开奖";
    } else if([item.state isEqualToString:@"LOSING_LOTTERY"]) {
        status = @"未中奖";
         _againBtn.hidden = NO;
        [_againBtn setTitle:@"再次兑奖" forState:0];
    } else if([item.state isEqualToString:@"WINNING_LOTTERY"]) {
        status = @"已中奖";
        _againBtn.hidden = NO;
        [_againBtn setTitle:@"晒单" forState:0];
    } else if([item.state isEqualToString:@"SHARE_LOTTERY"]) {
        status = @"已晒单";
         _againBtn.hidden = NO;
        [_againBtn setTitle:@"再次兑奖" forState:0];
    } else if([item.state isEqualToString:@"NOT_SHARE"]) {
        status = @"未分享";
    } else if([item.state isEqualToString:@"NOT_DELIVERY"]) {
        status = @"未发货";
    } else if([item.state isEqualToString:@"DELIVERY"]) {
        status = @"已发货";
    } else if([item.state isEqualToString:@"RECEVING"]) {
        status = @"已收货";
    } else if([item.state isEqualToString:@"CHANGED"]) {
        status = @"已换货";
    }  else if([item.state isEqualToString:@"CHANGED"]) {
        status = @"晒单审核中";
         _againBtn.hidden = NO;
        [_againBtn setTitle:@"再次兑奖" forState:0];
    } else if([item.state isEqualToString:@"CHANGED"]) {
        status = @"晒单未通过";
         _againBtn.hidden = NO;
        [_againBtn setTitle:@"重新晒单" forState:0];
    }
    NSString *statusStr = [NSString stringWithFormat:@"商品状态：%@",status];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(5, statusStr.length - 5)];
    self.statusLabel.attributedText = attrString;
}

- (void)bindDataModel:(XKWelfareOrderDetailViewModel *)model {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.goodsPic] placeholderImage:nil];
    self.nameLabel.text = model.goodsName;
    self.timeLabel.text = [NSString stringWithFormat:@"规格参数:%@ x %zd",model.goodsAttr,model.myStake];
    NSString *status = @(model.univalence).stringValue;
    NSString *statusStr = [NSString stringWithFormat:@"商品状态：%@",status];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(5, statusStr.length - 5)];
    _statusLabel.attributedText = attrString;
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(40);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(40);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.bottom.equalTo(self.statusLabel.mas_top).offset(-3);
        make.right.equalTo(self.nameLabel);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-17);
        make.right.equalTo(self.nameLabel);
    }];
    
    [self.againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 20));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    _againBtn.hidden = YES;
}

- (void)updateLayout {
    [self.choseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.left.top.bottom.equalTo(self.contentView);
    }];
    
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(40);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

- (void)restoreLayout {
    [self.choseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.left.top.bottom.equalTo(self.contentView);
    }];
    
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

- (void)againBtnClick:(UIButton *)sender {
    if(self.btnActionBlick) {
        self.btnActionBlick(sender);
    }
}
#pragma mark 懒加载
- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _choseBtn;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 3.f;
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;

    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _timeLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _timeLabel;
}

- (UILabel *)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        [_statusLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _statusLabel.textColor = UIColorFromRGB(0x555555);

    }
    return _statusLabel;
}

- (UIButton *)againBtn {
    if(!_againBtn) {
        _againBtn = [[UIButton alloc] init];
        [_againBtn setTitle:@"再次抽奖" forState:0];
        _againBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_againBtn setTitleColor:XKMainTypeColor forState:0];
        _againBtn.layer.cornerRadius = 10.f;
        _againBtn.layer.masksToBounds = YES;
        _againBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _againBtn.layer.borderWidth = 1.f;
        [_againBtn addTarget:self action:@selector(againBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_againBtn setBackgroundColor:[UIColor whiteColor]];
    }
    return _againBtn;
}
@end
