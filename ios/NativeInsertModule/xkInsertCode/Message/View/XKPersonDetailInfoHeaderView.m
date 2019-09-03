//
//  XKPersonDetailInfoHeaderView.m
//  XKSquare
//
//  Created by william on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonDetailInfoHeaderView.h"
#import "XKMineFansListController.h"
#import "XKMineFocusListController.h"

#define kHeaderImgHeight 220 * ScreenScale

@interface XKPersonDetailInfoHeaderView()
@property(nonatomic, strong) XKPesonalDetailInfoModel *model;
@property (nonatomic,strong)UIImageView         *backMainImageView;
@property (nonatomic,strong)UIVisualEffectView  *GuassView;         //高斯模糊
@property (nonatomic,strong)UIView              *shadowView;
@property (nonatomic,strong)UIView              *mainWhiteView;
@property (nonatomic,strong)UIImageView         *userAvatorImageView;
@property (nonatomic,strong)UILabel             *ageAndConstellationLabel;
@property (nonatomic,strong)UILabel             *addressLabel;
@property (nonatomic,strong)UILabel             *nickNameAndSexLabel;
@property (nonatomic,strong)UILabel             *userIDLabel;
@property (nonatomic,strong)UILabel             *signLabel;
@property (nonatomic,strong)UILabel             *fansLabel;
@property (nonatomic,strong)UILabel             *attentionLabel;

@end

@implementation XKPersonDetailInfoHeaderView

#pragma mark – Life Cycle
-(instancetype)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor =UIColorFromRGB(0xEEEEEE);
    [self setViews];
    [self layoutViews];
  }
  return self;
}

#pragma mark – Private Methods

-(void)setViews{
  [self addSubview:self.backMainImageView];
  [self addSubview:self.GuassView];
  [self addSubview:self.shadowView];
  [self addSubview:self.mainWhiteView];
  [self addSubview:self.userAvatorImageView];
  [self addSubview:self.ageAndConstellationLabel];
  [self addSubview:self.addressLabel];
  [self addSubview:self.nickNameAndSexLabel];
//  [self addSubview:self.userIDLabel];
  [self addSubview:self.signLabel];
//  [self addSubview:self.fansLabel];
//  [self addSubview:self.attentionLabel];
}

-(void)layoutViews{
  _backMainImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHeaderImgHeight);
  
  [_GuassView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(self->_backMainImageView);
  }];
  
  [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(self->_backMainImageView);
  }];
  
  [_mainWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(10);
    make.right.mas_equalTo(self.mas_right).offset(-10);
    make.top.mas_equalTo((iPhoneX?120:110) * ScreenScale );
  }];
  
  [_userAvatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self->_mainWhiteView.mas_centerX);
    make.centerY.mas_equalTo(self->_mainWhiteView.mas_top).offset(10 * ScreenScale);
    make.size.mas_equalTo(CGSizeMake(80 * ScreenScale, 80 * ScreenScale));
  }];
  _ageAndConstellationLabel.textAlignment = NSTextAlignmentCenter;
  [_ageAndConstellationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self->_mainWhiteView.mas_top).offset(10 * ScreenScale);
    make.right.mas_equalTo(self->_userAvatorImageView.mas_left).offset(0);
    make.height.mas_equalTo(17 * ScreenScale);
    make.width.mas_equalTo(SCREEN_WIDTH / 3.3);
  }];
  _addressLabel.textAlignment = NSTextAlignmentCenter;
  [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self->_mainWhiteView.mas_top).offset(10 * ScreenScale);
    make.left.mas_equalTo(self->_userAvatorImageView.mas_right);
    make.height.mas_equalTo(17 * ScreenScale);
    make.width.mas_equalTo(SCREEN_WIDTH / 3.3);
  }];
  
  [_nickNameAndSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self->_userAvatorImageView.mas_bottom).offset(10 * ScreenScale);
    make.left.and.right.mas_equalTo(self->_mainWhiteView);
    make.height.mas_equalTo(25 * ScreenScale);
  }];
  
//  [_userIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.centerX.mas_equalTo(self->_nickNameAndSexLabel.mas_centerX);
//    make.top.mas_equalTo(self->_nickNameAndSexLabel.mas_bottom);
//    make.height.mas_equalTo(0);
//  }];
  
  [_signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self->_nickNameAndSexLabel.mas_centerX);
    make.top.mas_equalTo(self->_nickNameAndSexLabel.mas_bottom).offset(6*ScreenScale);
    make.left.equalTo(self.mainWhiteView.mas_left).offset(20);
    make.bottom.mas_equalTo(self->_mainWhiteView.mas_bottom).offset(-20 * ScreenScale);
  }];
}


-(void)updateUI:(XKPesonalDetailInfoModel *)model isSecret:(BOOL)isSecret {
  _model = model;
  [_backMainImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:kDefaultHeadImg];
  
  [_userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:kDefaultHeadImg];
  _userAvatorImageView.userInteractionEnabled = YES;
  __weak typeof(self) weakSelf = self;
  [_userAvatorImageView bk_whenTapped:^{
    [XKGlobleCommonTool showSingleImgWithImg:weakSelf.model.avatar viewController:self.getCurrentUIVC];
  }];
  _ageAndConstellationLabel.text = [NSString stringWithFormat:@"%@ %@", model.birthday?[NSString stringWithFormat:@"%@岁",[XKTimeSeparateHelper backAgeWithBrithdayTimeStampString:model.birthday]]:@"" , model.constellation?:@""];
  NSMutableArray *adds = @[].mutableCopy;
  if (model.province) {
    [adds addObject:model.province];
  }
  if (model.city) {
    [adds addObject:model.city];
  }
  _addressLabel.text = [adds componentsJoinedByString:@"·"];
  [_nickNameAndSexLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
    confer.paragraphStyle.alignment(NSTextAlignmentCenter).lineSpacing(3).lineBreakMode(NSLineBreakByTruncatingMiddle);
    if (isSecret) {
      confer.text(model.detailSecretDisplayName).textColor(HEX_RGB(0x222222)).font(XKRegularFont(17));
    } else {
      confer.text(model.detailDisplayName).textColor(HEX_RGB(0x222222)).font(XKRegularFont(17));
    }
    
    confer.text(@" ");
    if ([model.sex isEqualToString:XKSexUnknow]) {
      //
    } else {
      confer.appendImage([model.sex isEqualToString:XKSexMale] ?IMG_NAME(@"xk_img_personDetailInfo_male"): IMG_NAME(@"xk_img_personDetailInfo_female")).bounds(CGRectMake(0, -3.5 * ScreenScale, 16 * ScreenScale, 16 * ScreenScale));
    }
  }];
//  _userIDLabel.text = [NSString stringWithFormat:@"用户ID：%@",model.uid?:@""];
 _signLabel.text = model.signature ?:@"本宝宝暂时还没想到有趣的签名";
}

- (void)configHeaderViewBackgroundImageWithY:(CGFloat)y {
  self.backMainImageView.y = y;
  self.backMainImageView.height = kHeaderImgHeight - y;
}

#pragma mark - Events

- (CGFloat)getTopInfoViewBtm {
  return (iPhoneX_Serious ? 260 : 250) * ScreenScale + [self getFixSignHeight] - 10 * ScreenScale;
}

- (CGFloat)getFixSignHeight {
  CGFloat signTextheight = [self.signLabel.text getHeightStrWIthFontSize:self.signLabel.font.pointSize width:SCREEN_WIDTH - 20 - 40];
  return signTextheight;
}


#pragma mark – Getters and Setters
-(UIImageView *)backMainImageView{
  if (!_backMainImageView) {
    _backMainImageView = [[UIImageView alloc]init];
    _backMainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backMainImageView.layer.masksToBounds = YES;
    _backMainImageView.layer.contentsRect=CGRectMake(0,0,1,0.5);
  }
  return _backMainImageView;
}
-(UIView *)shadowView{
  if (!_shadowView) {
    _shadowView = [[UIView alloc]init];
    _shadowView.backgroundColor = HEX_RGBA(0x000000, 0.4);
  }
  return _shadowView;
}

-(UIVisualEffectView *)GuassView{
  if (!_GuassView) {
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    _GuassView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _GuassView.alpha = 0.98f;
  }
  return _GuassView;
}

-(UIView *)mainWhiteView{
  if (!_mainWhiteView) {
    _mainWhiteView = [[UIView alloc]init];
    _mainWhiteView.backgroundColor = [UIColor whiteColor];
    _mainWhiteView.xk_openClip = YES;
    _mainWhiteView.xk_radius = 8 ;
    _mainWhiteView.xk_clipType = XKCornerClipTypeAllCorners;
    __weak typeof(self) weakSelf = self;
    [_mainWhiteView bk_whenTapped:^{
      EXECUTE_BLOCK(weakSelf.infoViewClick);
    }];
  }
  return _mainWhiteView;
}

-(UIImageView *)userAvatorImageView{
  if (!_userAvatorImageView) {
    _userAvatorImageView = [[UIImageView alloc]init];
    _userAvatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    _userAvatorImageView.layer.masksToBounds = YES;
    _userAvatorImageView.layer.cornerRadius = 40 * ScreenScale;
  }
  return _userAvatorImageView;
}

-(UILabel *)ageAndConstellationLabel{
  if (!_ageAndConstellationLabel) {
    _ageAndConstellationLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor]];
    _ageAndConstellationLabel.adjustsFontSizeToFitWidth = YES;
  }
  return _ageAndConstellationLabel;
}

-(UILabel *)addressLabel{
  if (!_addressLabel) {
    _addressLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    _addressLabel.adjustsFontSizeToFitWidth = YES;
  }
  return _addressLabel;
}

-(UILabel *)nickNameAndSexLabel{
  if (!_nickNameAndSexLabel) {
    _nickNameAndSexLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKMediumFont(17) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor]];
    _nickNameAndSexLabel.textAlignment = NSTextAlignmentCenter;
  }
  return _nickNameAndSexLabel;
}

-(UILabel *)userIDLabel{
  if (!_userIDLabel) {
    _userIDLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor clearColor]];
    _userIDLabel.adjustsFontSizeToFitWidth = YES;
  }
  return _userIDLabel;
}

-(UILabel *)signLabel{
  if (!_signLabel) {
    _signLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(13) textColor:UIColorFromRGB(0x555555) backgroundColor:[UIColor clearColor]];
    _signLabel.numberOfLines = 0;
    _signLabel.textAlignment = NSTextAlignmentCenter;
  }
  return _signLabel;
}

-(UILabel *)fansLabel{
  if (!_fansLabel) {
    _fansLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor]];
    _fansLabel.textAlignment = NSTextAlignmentCenter;
    _fansLabel.numberOfLines = 0;
  }
  return _fansLabel;
}

-(UILabel *)attentionLabel{
  if (!_attentionLabel) {
    _attentionLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor]];
    _attentionLabel.textAlignment = NSTextAlignmentCenter;
    _attentionLabel.numberOfLines = 0;
  }
  return _attentionLabel;
}
@end
