//
//  XKWelfareOrderDetailFinishTopCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailFinishTopCell.h"
#import "XKWelfarePhotoContainerView.h"
@interface XKWelfareOrderDetailFinishTopCell ()
@property (nonatomic, strong)UIImageView *headerImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *numberLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *opinionLabel;
@property (nonatomic, strong)XKWelfarePhotoContainerView *containView;
@property (nonatomic, strong)UIView *bgView;
@end

@implementation XKWelfareOrderDetailFinishTopCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.xk_openClip = YES;
        self.xk_radius = 6;
        self.xk_clipType = XKCornerClipTypeTopBoth;
        [self addCustomSubviews];
        [self addUIConstraint];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)addCustomSubviews {
   
    [self.bgView addSubview:self.headerImgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.numberLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.opinionLabel];
    [self.bgView addSubview:self.containView];
    [self.contentView addSubview:self.bgView];
}

- (void)handleDataWithItem:(XKWelfareFinishDetailDataItem *)item {
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:kDefaultHeadImg];
    self.nameLabel.text = item.nickname ?:@"小蘑菇的女孩";
    NSString *number = item.lotteryNumber;
    NSString *numberStr = [NSString stringWithFormat:@"中奖编号：%@",number];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:numberStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(5, numberStr.length - 5)];
    _numberLabel.attributedText = attrString;
    self.numberLabel.attributedText = attrString;
    
    NSString *time = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:@(item.factDrawDate).stringValue];
    self.timeLabel.text = [NSString stringWithFormat:@"开奖时间：%@",time];
    self.opinionLabel.text = item.content;
    
  //  self.containView.picPathStringsArray = item.pictures;
}

- (void)addUIConstraint {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.bgView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).offset(5);
        make.top.equalTo(self.headerImgView);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.numberLabel.mas_bottom).offset(2);
    }];

    [self.opinionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView);
        make.top.equalTo(self.headerImgView.mas_bottom).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-15);
    }];

    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.opinionLabel);
        make.top.equalTo(self.opinionLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(self.containView.fixedHeight);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(5);
    }];
    
//    self.containView.picPathStringsArray = @[@"https://gss0.bdstatic.com/5bVWsj_p_tVS5dKfpU_Y_D3/res/r/image/2017-09-26/352f1d243122cf52462a2e6cdcb5ed6d.png",@"https://gss0.bdstatic.com/5bVWsj_p_tVS5dKfpU_Y_D3/res/r/image/2017-09-26/352f1d243122cf52462a2e6cdcb5ed6d.png",@"https://gss0.bdstatic.com/5bVWsj_p_tVS5dKfpU_Y_D3/res/r/image/2017-09-26/352f1d243122cf52462a2e6cdcb5ed6d.png",@"https://gss0.bdstatic.com/5bVWsj_p_tVS5dKfpU_Y_D3/res/r/image/2017-09-26/352f1d243122cf52462a2e6cdcb5ed6d.png",@"https://gss0.bdstatic.com/5bVWsj_p_tVS5dKfpU_Y_D3/res/r/image/2017-09-26/352f1d243122cf52462a2e6cdcb5ed6d.png"];
//    [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.opinionLabel);
//        make.top.equalTo(self.opinionLabel.mas_bottom).offset(10);
//        make.height.mas_equalTo(self.containView.fixedHeight);
//
//    }];
    

}

- (UIImageView *)headerImgView {
    if(!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.text = @"小蘑菇";
    }
    return _nameLabel;
}


- (UILabel *)numberLabel {
    if(!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _numberLabel.textColor = UIColorFromRGB(0x222222);

    }
    return _numberLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _timeLabel.textColor = UIColorFromRGB(0x222222);

    }
    return _timeLabel;
}

- (UILabel *)opinionLabel {
    if(!_opinionLabel) {
        _opinionLabel = [[UILabel alloc] init];
        [_opinionLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _opinionLabel.textColor = UIColorFromRGB(0x555555);
        _opinionLabel.numberOfLines = 0;
        _opinionLabel.text = @"四川省成都市高新区环球中心B座四川省成都市高新区环球中四川省成都市高新区环球中心B座四川省成都市高新区环球中心B座";
    }
    return _opinionLabel;
}

- (XKWelfarePhotoContainerView *)containView {
    if(!_containView) {
        _containView = [XKWelfarePhotoContainerView new];
        [_containView clipsToBounds];

    }
    return _containView;
}

- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
@end
