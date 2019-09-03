//
//  XKShopShareView.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKShopShareView.h"
#import "XKCommonStarView.h"

@interface XKShopShareView()
@property (nonatomic, strong)UILabel     *smallNameLabel;
@property (nonatomic, strong)UILabel     *monthCountLabel;
@property (nonatomic, strong)UILabel     *distanceLabel;
@property (nonatomic, strong)UIView      *segmentationView2;
@property (nonatomic, strong)UIView      *segmentationView;
@property (nonatomic, strong)XKCommonStarView      *starView;
@property (nonatomic, strong)UILabel     *countLabel;
@property (nonatomic, strong)UILabel     *countLabel2;
@end

@implementation XKShopShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
- (void)setModel:(XKCollectShopModelDataItem *)model {
    _model = model;
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics] placeholderImage:kDefaultPlaceHolderImg];
    NSString *dataString = [NSString stringWithFormat:@"xkgc://commodity_detail?commodity_id=%@&user_id=%@",model.target.targetId,[XKUserInfo getCurrentUserId]] ;
    [self.iconImgView createShareQRImageWithQRString:dataString correctionLevel:@"L"];
    self.nameLabel.text = model.target.name;
    NSString *mouthVolumeStr = @"";
    if (model.target.mouthCount > 10000) {
        mouthVolumeStr = [NSString stringWithFormat:@"月销量：%ldw",model.target.mouthCount/10000];
    }else{
        mouthVolumeStr = [NSString stringWithFormat:@"月销量：%ld",model.target.mouthCount];
    }
    _monthCountLabel.text = mouthVolumeStr;
    _smallNameLabel.text = @"";
    _starView.scorePercent = model.target.starLevel / 5;
    _countLabel2.text = [NSString stringWithFormat:@"人均￥%ld起",model.target.avgConsumption];
    _countLabel.text = [NSString stringWithFormat:@"%ld分",model.target.starLevel];
    CLLocationCoordinate2D cl2d = [[XKBaiduLocation shareManager]getUserLocationLaititudeAndLongtitude];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:cl2d.latitude longitude:cl2d.longitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:model.target.lat.doubleValue longitude:model.target.lng.doubleValue];
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    NSString *distanceStr = @"";
    if (distance >1000.00) {
        distanceStr = [NSString stringWithFormat:@"距离：%0.1fkm",distance/1000];
    }else {
        distanceStr = [NSString stringWithFormat:@"距离：%0.1fm",distance];
    }
    _distanceLabel.text = distanceStr;
}
- (void)creatUI {
    [super creatUI];
    [self.bottomView addSubview:self.monthCountLabel];
    [self.bottomView addSubview:self.distanceLabel];
    [self.bottomView addSubview:self.segmentationView];
    [self.bottomView addSubview:self.starView];
    [self.bottomView addSubview:self.countLabel];
    [self.bottomView addSubview:self.countLabel2];
    [self.bottomView addSubview:self.segmentationView2];
    [self.bottomView addSubview:self.smallNameLabel];
    
    
    [self.smallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.iconImgView.mas_left).offset(-15);
        make.height.mas_equalTo(17 * ScreenScale);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(self.smallNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@80);
        make.height.mas_equalTo(10 * ScreenScale);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView.mas_right).offset(15);
        make.centerY.equalTo(self.starView);
        make.width.mas_equalTo(20 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    [self.segmentationView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starView);
        make.left.equalTo(self.countLabel.mas_right).offset(5);
        make.width.equalTo(@1);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    
    [self.countLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentationView2.mas_right).offset(5);
        make.centerY.equalTo(self.starView);
        make.right.equalTo(self.iconImgView.mas_left).offset(-5);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(self.starView.mas_bottom).offset(10 * ScreenScale);
        make.width.equalTo(@100);
    }];
    
    [self.segmentationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceLabel);
        make.left.equalTo(self.distanceLabel.mas_right);
        make.width.equalTo(@1);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [self.monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentationView.mas_right).offset(10);
        make.centerY.equalTo(self.distanceLabel);
        make.height.mas_equalTo(30 * ScreenScale);
        make.right.equalTo(@(-10));
    }];
    
}

- (UILabel *)smallNameLabel {
    if(!_smallNameLabel) {
        _smallNameLabel = [[UILabel alloc] init];
        [_smallNameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _smallNameLabel.textColor = UIColorFromRGB(0x555555);
        _smallNameLabel.text = @"鸡排";
    }
    return _smallNameLabel;
}
- (UILabel *)monthCountLabel {
    if(!_monthCountLabel) {
        _monthCountLabel = [[UILabel alloc] init];
        [_monthCountLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _monthCountLabel.textColor = UIColorFromRGB(0x555555);
        _monthCountLabel.text = @"成交量:12.5w单";
    }
    return _monthCountLabel;
}

- (UILabel *)countLabel {
    if(!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [_countLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _countLabel.textColor = UIColorFromRGB(0x555555);
        _countLabel.text = @"4分";
    }
    return _countLabel;
}

- (UILabel *)countLabel2 {
    if(!_countLabel2) {
        _countLabel2 = [[UILabel alloc] init];
        [_countLabel2 setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _countLabel2.textColor = UIColorFromRGB(0x555555);
        _countLabel2.text = @"人均：￥269起";
    }
    return _countLabel2;
}
- (UILabel *)distanceLabel {
    if(!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        [_distanceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _distanceLabel.textColor = UIColorFromRGB(0x555555);
        NSString *status = @"190m";
        NSString *statusStr = [NSString stringWithFormat:@"距离：%@",status];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(5, statusStr.length - 5)];
        _distanceLabel.attributedText = attrString;
    }
    return _distanceLabel;
}

- (UIView *)segmentationView {
    if(!_segmentationView) {
        _segmentationView = [[UIView alloc] init];
        _segmentationView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _segmentationView;
}

- (UIView *)segmentationView2 {
    if(!_segmentationView2) {
        _segmentationView2 = [[UIView alloc] init];
        _segmentationView2.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _segmentationView2;
}


- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0, 0, 80 * ScreenScale, 10 * ScreenScale) numberOfStars:5];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}
@end
