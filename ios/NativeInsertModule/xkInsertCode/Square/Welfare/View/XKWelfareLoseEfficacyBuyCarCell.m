//
//  XKWelfareLoseEfficacyBuyCarCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareLoseEfficacyBuyCarCell.h"
#import "XKWelfareBuyCarSumView.h"
#import "XKWelfareProgressView.h"
#import "XKWelfareCarGoodsInfo.h"
@interface XKWelfareLoseEfficacyBuyCarCell ()
@property (nonatomic, strong)UIButton *choseBtn;
@property (nonatomic, strong)UIButton *loseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *progressLabel;
@property (nonatomic, strong)UIProgressView *joinProgress;
@property (nonatomic, strong)XKWelfareProgressView *progressNumberView;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *ticketLabel;
@property (nonatomic, strong)UIView *segmengView;
@property (nonatomic, strong)XKWelfareBuyCarItem  *model;
@end

@implementation XKWelfareLoseEfficacyBuyCarCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addCustomSubviews];
        [self addUIConstraint];
        
    }
    return self;
}

- (void)addCustomSubviews {
    
    [self addSubview:self.choseBtn];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.progressLabel];
    [self.contentView addSubview:self.joinProgress];
    [self.contentView addSubview:self.ticketLabel];
    [self.contentView addSubview:self.segmengView];
    [self.contentView addSubview:self.loseBtn];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.progressNumberView];
    
}

- (void)addUIConstraint {
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(40);
    }];
    
    [self.loseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.choseBtn.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(33, 18));
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loseBtn.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.width.mas_equalTo(80);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(14);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(14);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(14);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
    }];
    
    [self.joinProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.left.equalTo(self.progressLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(6);
    }];
    
    [self.progressNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.joinProgress.mas_left).offset(self.joinProgress.width * self.joinProgress.progress);
    }];
    
    [self.ticketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(14);
        make.top.equalTo(self.progressLabel.mas_bottom).offset(2);
    }];
    
    [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}


- (void)handleDataModel:(XKWelfareBuyCarItem *)item managerModel:(BOOL)manager {
    _model = item;
    self.nameLabel.text = item.name;
    self.choseBtn.selected = item.selected;
    if(manager) {
        self.timeLabel.hidden = NO;
        self.progressNumberView.hidden = YES;
        self.joinProgress.hidden = YES;
        self.progressLabel.hidden = YES;
        
        self.timeLabel.text = [NSString stringWithFormat:@"累计开奖次数：%@次",@(item.lotteryNumber).stringValue];
        [self.choseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(40);
        }];
    } else {//非管理模式
        if([item.drawType isEqualToString:@"bymember"]) {
            self.timeLabel.hidden = YES;
            self.progressNumberView.hidden = NO;
            self.joinProgress.hidden = NO;
            self.progressLabel.hidden = NO;
            
            CGFloat progress = @(item.participateStake).floatValue/item.maxStake;
            if(item.participateStake == 0) {
                progress = 0;
            }
            self.joinProgress.progress = progress;
            NSString *progressText = [NSString stringWithFormat:@"%.0f%%",progress * 100];
            self.progressNumberView.progressLabel.text = progressText;
            CGFloat textW = [progressText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH,MAXFRAG) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.width;
            CGFloat offset = progress == 1.f ? (textW + 10 ) : 0;
            [self.progressNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.progressLabel);
                make.height.mas_equalTo(16);
                make.left.equalTo(self.joinProgress.mas_left).offset(self.joinProgress.width * self.joinProgress.progress - offset);
            }];
            
        } else if([item.drawType isEqualToString:@"bytime"]) {
            self.timeLabel.hidden = NO;
            self.progressNumberView.hidden = YES;
            self.joinProgress.hidden = YES;
            self.progressLabel.hidden = YES;
            NSString *time = [XKTimeSeparateHelper backYMDHMStringByChineseSegmentWithTimestampString:@(item.drawTime).stringValue];
            self.timeLabel.text = [NSString stringWithFormat:@"开奖时间：%@分",[time substringFromIndex:12]];
        }
        
        [self.choseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(0);
        }];
    }
    
    NSString *price = @(item.price / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"积分：%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(3, priceStr.length - 3)];
    self.ticketLabel.attributedText = attrString;
}

- (void)choseBtnClick:(UIButton *)sender {
    if (self.choseBlock) {
        self.choseBlock(_model.index, sender);
    }
}

- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choseBtn;
}

- (UIButton *)loseBtn {
    if(!_loseBtn) {
        _loseBtn = [[UIButton alloc] init];
        [_loseBtn setBackgroundColor:UIColorFromRGB(0xcccccc)];
        [_loseBtn setTitle:@"失效" forState:0];
        _loseBtn.userInteractionEnabled = NO;
        _loseBtn.titleLabel.font = XKRegularFont(12);
        [_loseBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_loseBtn cutCornerWithRoundedRect:CGRectMake(0, 0, 33, 18) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];

    }
    return _loseBtn;
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
        _timeLabel.text = @"开奖时间：20:08分";
    }
    return _timeLabel;
}

- (UILabel *)progressLabel {
    if(!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        [_progressLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _progressLabel.textColor = UIColorFromRGB(0x555555);
        _progressLabel.text = @"参与进度：";
    }
    return _progressLabel;
}

- (UIProgressView *)joinProgress {
    if(!_joinProgress) {
        _joinProgress = [[UIProgressView alloc] init];
        _joinProgress.progressTintColor = XKMainTypeColor;
        _joinProgress.trackTintColor = UIColorFromRGB(0xe5e5e5);
        _joinProgress.layer.cornerRadius = 3.f;
        _joinProgress.layer.masksToBounds = YES;
        _joinProgress.progress = 0.5;
    }
    return _joinProgress;
}

- (XKWelfareProgressView *)progressNumberView {
    if(!_progressNumberView) {
        _progressNumberView = [[XKWelfareProgressView alloc] init];
    }
    return _progressNumberView;
}

- (UILabel *)ticketLabel {
    if(!_ticketLabel) {
        _ticketLabel = [[UILabel alloc] init];
        [_ticketLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _ticketLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _ticketLabel;
}

- (UIView *)segmengView {
    if(!_segmengView) {
        _segmengView = [[UIView alloc] init];
        _segmengView.backgroundColor = XKSeparatorLineColor;
    }
    return _segmengView;
}

@end
