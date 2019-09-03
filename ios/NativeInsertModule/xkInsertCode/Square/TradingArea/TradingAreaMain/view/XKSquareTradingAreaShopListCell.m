//
//  XKSquareTradingAreaShopListCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareTradingAreaShopListCell.h"
#import "XKCommonStarView.h"
#import "XKTradingAreaShopListModel.h"

@interface XKSquareTradingAreaShopListCell ()

@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UIButton          *tipBtn;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *tagLabel1;
@property (nonatomic, strong) UILabel           *tagLabel2;
@property (nonatomic, strong) UILabel           *distanceLabel;
@property (nonatomic, strong) XKCommonStarView  *starView;
@property (nonatomic, strong) UILabel           *scoreLabel;
@property (nonatomic, strong) UILabel           *salesLabel;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIView            *lineView0;


@end

@implementation XKSquareTradingAreaShopListCell

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
    
    [self.contentView addSubview:self.imgView];
    [self.imgView addSubview:self.tipBtn];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.tagLabel1];
    [self.contentView addSubview:self.tagLabel2];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.lineView0];
    [self.contentView addSubview:self.salesLabel];
    [self.contentView addSubview:self.lineView];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.width.height.equalTo(@80);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.imgView);
        make.width.equalTo(@36);
        make.height.equalTo(@18);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(0);
        make.left.equalTo(self.imgView.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.tagLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left).offset(0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(40);
    }];
    
    [self.tagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel1.mas_right).offset(15);
        make.top.equalTo(self.tagLabel1.mas_top);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(40);
    }];

    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left).offset(-2);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(22);
        make.width.equalTo(@80);
        make.height.equalTo(@12);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView.mas_right).offset(5);
        make.centerY.equalTo(self.starView);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.starView.mas_bottom).offset(5);
    }];
    
    [self.lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.distanceLabel.mas_right).offset(8);
        make.height.equalTo(@11);
        make.width.equalTo(@1);
        make.centerY.equalTo(self.distanceLabel);
    }];

    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView0.mas_right).offset(8);
        make.right.lessThanOrEqualTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.distanceLabel);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:XKRegularFont(font)}
                                     context:nil];
    return rect.size.width;
}

#pragma mark - Setter


- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor whiteColor];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 6;
//        _imgView.backgroundColor = [UIColor yellowColor];
    }
    return _imgView;
}

- (UIButton *)tipBtn {
    if (!_tipBtn) {
        _tipBtn = [[UIButton alloc] init];
        [_tipBtn setBackgroundImage:[UIImage imageNamed:@"xk_icon_reward_back"] forState:UIControlStateNormal];
        [_tipBtn setTitle:@"抽奖中" forState:UIControlStateNormal];
        [_tipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _tipBtn.titleLabel.font = XKRegularFont(9);
        _tipBtn.enabled = NO;
    }
    return _tipBtn;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = XKRegularFont(14);
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"测试酒店酒店";
    }
    return _nameLabel;
}


-(UILabel *)tagLabel1 {
    if (!_tagLabel1) {
        _tagLabel1 = [[UILabel alloc] init];
        [_tagLabel1 setFont:XKRegularFont(10)];
        _tagLabel1.textColor = RGB(252, 109, 58);
        _tagLabel1.text = @"均省45~56元";
        _tagLabel1.backgroundColor = RGB(254, 234, 229);
        _tagLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel1;
}

-(UILabel *)tagLabel2 {
    if (!_tagLabel2) {
        _tagLabel2 = [[UILabel alloc] init];
        [_tagLabel2 setFont:XKRegularFont(10)];
        _tagLabel2.textColor = RGB(252, 109, 58);
        _tagLabel2.text = @"抽奖活动中";
        _tagLabel2.backgroundColor = RGB(254, 234, 229);
        _tagLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel2;
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
        _scoreLabel.font = XKRegularFont(12);
        _scoreLabel.textColor = HEX_RGB(0xee6161);
    }
    return _scoreLabel;
}


- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = XKRegularFont(12);
        _distanceLabel.textColor = HEX_RGB(0x555555);
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
        _salesLabel.font = XKRegularFont(12);
        _salesLabel.textColor = HEX_RGB(0x555555);
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

- (UIView *)lineView0 {
    if (!_lineView0) {
        _lineView0 = [[UIView alloc] init];
        _lineView0.backgroundColor = HEX_RGB(0xCCCCCC);
    }
    return _lineView0;
}

- (void)setValueWithModle:(ShopListItem *)model {
    
    [self.imgView sd_setImageWithURL:kURL(model.cover) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.name;
    
    [self.tagLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat width = [self getWidthWithText:@"均省45~56元" height:14 font:10];
        make.width.mas_equalTo(@(width + 4));
    }];
    [self.tagLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat width = [self getWidthWithText:@"抽奖活动中" height:14 font:10];
        make.width.mas_equalTo(@(width + 4));
    }];
    
    [self.starView setScorePercent:model.level / 5];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld分", (long)model.level];
    self.distanceLabel.text = [NSString stringWithFormat:@"距离：%@m", model.distance ? model.distance: @"0"];
    self.salesLabel.text = [NSString stringWithFormat:@"成交量：%ld笔", (long)model.monthVolume];
}

@end







