//
//  XKSquareSearchTradingAreaCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareSearchTradingAreaCell.h"
#import "XKCommonStarView.h"
#import "XKTradingAreaShopListModel.h"

@interface XKSquareSearchTradingAreaCell ()

@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *distanceLabel;
@property (nonatomic, strong) XKCommonStarView  *starView;
@property (nonatomic, strong) UILabel           *scoreLabel;
@property (nonatomic, strong) UILabel           *salesLabel;
@property (nonatomic, strong) UIView            *lineView;

@end

@implementation XKSquareSearchTradingAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}


#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.salesLabel];
    [self.contentView addSubview:self.lineView];
    
}

//- (void)setFrame:(CGRect)frame {
//    
//    frame.origin.x += 10;
//    frame.size.width -= 20;
//    [super setFrame:frame];
//}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@(100*ScreenScale));
        make.bottom.equalTo(self.contentView).offset(-15);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(5);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];

    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left).offset(-2);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(11);
        make.width.equalTo(@80);
        make.height.equalTo(@10);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView.mas_right);
        make.centerY.equalTo(self.starView);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.starView.mas_bottom).offset(11);
        make.right.equalTo(self.contentView).offset(-10);
    }];

    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.distanceLabel.mas_bottom).offset(3);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter


- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
//        _imgView.backgroundColor = [UIColor yellowColor];
    }
    return _imgView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"测试酒店酒店";
    }
    return _nameLabel;
}


- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0, 0, 80, 10)];
        _starView.allowIncompleteStar = YES;
//        [_starView setScorePercent:4.7 / 5];
        _starView.userInteractionEnabled = NO;

    }
    return _starView;
}

- (UILabel *)scoreLabel {
    
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
//        _scoreLabel.text = @"4.0分";
        _scoreLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _scoreLabel.textColor = HEX_RGB(0x555555);
    }
    return _scoreLabel;
}


- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _distanceLabel.textColor = HEX_RGB(0x777777);
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
//        _distanceLabel.text = @"距离：187m";
    }
    return _distanceLabel;
}



- (UILabel *)salesLabel {
    
    if (!_salesLabel) {
        _salesLabel = [[UILabel alloc] init];
        _salesLabel.textAlignment = NSTextAlignmentLeft;
//        _salesLabel.text = @"成交量：456笔";
        _salesLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _salesLabel.textColor = HEX_RGB(0x777777);
    }
    return _salesLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (void)setValueWithModle:(ShopListItem *)model {
    
    [self.imgView sd_setImageWithURL:kURL(model.cover) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.name;
    [self.starView setScorePercent:model.level / 5];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld分", (long)model.level];
    self.distanceLabel.text = [NSString stringWithFormat:@"距离：%@m", model.distance ? model.distance: @"0"];
    self.salesLabel.text = [NSString stringWithFormat:@"月成交量：%ld笔", (long)model.monthVolume];
}

@end




