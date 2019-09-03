//
//  XKWelfareOrderDetailWaitOpenTopCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailWaitOpenTopCell.h"
@interface XKWelfareOrderDetailWaitOpenTopCell ()
@property (nonatomic, strong)UIImageView *timerTipImgView;
@property (nonatomic, strong)UILabel *topLabel;
@property (nonatomic, strong)UILabel *midLabel;
@property (nonatomic, strong)UILabel *bottomLabel;
@end

@implementation XKWelfareOrderDetailWaitOpenTopCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self addCustomSubviews];
        [self addUIConstraint];
        
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.timerTipImgView];
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.midLabel];
    [self.contentView addSubview:self.bottomLabel];
}

- (void)bindDataModel:(XKWelfareOrderDetailViewModel *)model withOrderItem:(WelfareOrderDataItem *)item {
    self.timerTipImgView.image = [UIImage imageNamed:@"xk_icon_snatchTreasure_order_progress"];
    
    NSString *time = [[XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:model.expectDrawTime] substringFromIndex:11];
    CGFloat progress = @(model.joinCount).floatValue/model.maxStake;
    if(item.participateStake == 0) {
        progress = 0;
    }

    NSString *progressText = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    if ([model.drawType isEqualToString:@"bytime"]) {
        
        self.timerTipImgView.image = [UIImage imageNamed:@"xk_icon_snatchTreasure_order_waitTrans_detail"];
        self.topLabel.text = [NSString stringWithFormat:@"开奖时间：%@",time];
        [self cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 45)];
    } else  if ([model.drawType isEqualToString:@"bymember"]) {
        
        self.topLabel.text = [NSString stringWithFormat:@"开奖进度：%@",progressText];
        [self cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 45)];
    } else  if ([model.drawType isEqualToString:@"bytime_or_bymember"]) {
        
        self.topLabel.text = [NSString stringWithFormat:@"开奖进度：%@",progressText];
        self.midLabel.text = [NSString stringWithFormat:@"开奖时间：%@",time];
        self.bottomLabel.text = @"注意：满足以上任意一个条件就可开奖哦！";
        [self cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 100)];
    } else  if ([model.drawType isEqualToString:@"bytime_and_bymember"]) {
        
        self.topLabel.text = [NSString stringWithFormat:@"开奖进度：%@",progressText];
        self.midLabel.text = [NSString stringWithFormat:@"开奖时间：%@",time];
        self.bottomLabel.text = @"注意：需满足以上两个条件才可开奖哦！";
        [self cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 100)];
    }
}

- (void)addUIConstraint {
    [self.timerTipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timerTipImgView.mas_right).offset(5);
        make.centerY.equalTo(self.timerTipImgView);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];

    [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topLabel);
        make.top.equalTo(self.topLabel.mas_bottom).offset(5);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topLabel);
        make.top.equalTo(self.midLabel.mas_bottom).offset(5);
    }];
}

- (UIImageView *)timerTipImgView {
    if(!_timerTipImgView) {
        _timerTipImgView = [[UIImageView alloc] init];
        _timerTipImgView.contentMode = UIViewContentModeScaleAspectFit;
        _timerTipImgView.image = [UIImage imageNamed:@"xk_icon_snatchTreasure_order_waitTrans_detail"];
    }
    return _timerTipImgView;
}

- (UILabel *)topLabel {
    if(!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = XKRegularFont(17);
        _topLabel.textColor = UIColorFromRGB(0x222222);
    }
    
    return _topLabel;
}

- (UILabel *)midLabel {
    if(!_midLabel) {
        _midLabel = [[UILabel alloc] init];
        _midLabel.font = XKRegularFont(17);
        _midLabel.textColor = UIColorFromRGB(0x222222);

    }
    return _midLabel;
}

- (UILabel *)bottomLabel {
    if(!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = XKRegularFont(14);
        _bottomLabel.textColor = UIColorFromRGB(0xEE6161);
        
    }
    return _bottomLabel;
}
@end
