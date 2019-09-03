//
//  XKSqureMerchantRecommendCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureMerchantRecommendCell.h"
#import "XKCommonStarView.h"
#import "XKSquareMerchantRecommendModel.h"

@interface XKSqureMerchantRecommendCell ()

@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *distanceLabel;
@property (nonatomic, strong) XKCommonStarView  *starView;
@property (nonatomic, strong) UILabel           *decLable;
@property (nonatomic, strong) UILabel           *priceLable;
@property (nonatomic, strong) UIView            *lineView;


@end

@implementation XKSqureMerchantRecommendCell

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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.decLable];
    [self.contentView addSubview:self.priceLable];
    [self.contentView addSubview:self.lineView];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.height.equalTo(@(80*ScreenScale)).priorityHigh();
        make.width.equalTo(@(80*ScreenScale));
        make.bottom.equalTo(self.contentView).offset(-10);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(5);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-50);
//        make.height.equalTo(@25);
    }];

    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.nameLabel);
    }];


    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left).offset(-2);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        make.width.equalTo(@80);
        make.height.equalTo(@10);
    }];

    [self.decLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.starView.mas_bottom).offset(2);
        make.right.equalTo(self.contentView).offset(-10);
    }];

    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.decLable.mas_bottom).offset(5);
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
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg"]];
    }
    return _imgView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"测试酒店酒店";
    }
    return _nameLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _distanceLabel.textColor = HEX_RGB(0x999999);
        _distanceLabel.textAlignment = NSTextAlignmentRight;
//        _distanceLabel.text = @"187m";
    }
    return _distanceLabel;
}


- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0, 0, 80, 10)];
        _starView.allowIncompleteStar = YES;
        [_starView setScorePercent:4.7 / 5];
        _starView.userInteractionEnabled = NO;

    }
    return _starView;
}

- (UILabel *)decLable {
    
    if (!_decLable) {
        _decLable = [[UILabel alloc] init];
        _decLable.textAlignment = NSTextAlignmentLeft;
//        _decLable.text = @"酒店提供商人处少发点福利卡";
        _decLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _decLable.textColor = HEX_RGB(0x777777);
    }
    return _decLable;
}



- (UILabel *)priceLable {
    
    if (!_priceLable) {
        _priceLable = [[UILabel alloc] init];
        _priceLable.textAlignment = NSTextAlignmentLeft;
//        _priceLable.text = @"￥98";
        _priceLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:16];
        _priceLable.textColor = HEX_RGB(0xEE6161);
    }
    return _priceLable;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (void)setTestName:(NSString *)name {
    self.nameLabel.text = name;
}


- (void)setValueWithModel:(MerchantRecommendItem *)model {
    
    [self.imgView sd_setImageWithURL:kURL(model.cover) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];

    self.nameLabel.text = model.name;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%@m", model.distance ? model.distance : @"0"];
    
    [self.starView setScorePercent:model.level.integerValue / 5.0];
    
    self.decLable.text = model.descriptionStr;
    
    self.priceLable.text = [NSString stringWithFormat:@"￥%@", model.avgConsumption ? model.avgConsumption : @"0"];
    
}



@end





















