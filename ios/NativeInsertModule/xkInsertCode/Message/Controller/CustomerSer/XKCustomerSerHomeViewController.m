//
//  XKCustomerSerHomeViewController.m
//  XKSquare
//
//  Created by william on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomerSerHomeViewController.h"
#import "XKCommonStarView.h"
#import "XKTransformHelper.h"
@interface XKCustomerSerHomeViewController ()


/**
 白色背景
 */
@property (nonatomic,strong) UIView      *mainBackWhiteView;


/**
 商铺iconXKIMMessageShareWelfareAttachment
 */
@property (nonatomic,strong) UIImageView *customerIconImageView;

/**
 钻石imageView
 */
@property (nonatomic,strong) UIImageView *diamondImageView;

/**
 客服名
 */
@property (nonatomic,strong) UILabel     *nameLabel;


/**
 评星
 */
@property (nonatomic,strong) XKCommonStarView *starView;


@property (nonatomic,strong) UILabel    *phoneNumLabel;
@end

@implementation XKCustomerSerHomeViewController

#pragma mark – Life Cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self setNav];
  [self ConfigView];
  [self autoLyout];
  [self test];
  [[NIMSDK sharedSDK].teamManager fetchTeamInfo:_mySession.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
    if (team.memberNumber > 1) {
      self.diamondImageView.hidden = NO;
      self.starView.hidden = NO;
      self.phoneNumLabel.hidden = YES;
      [self loadDate];
      
    }else{
      self.diamondImageView.hidden = YES;
      self.starView.hidden = YES;
      self.phoneNumLabel.hidden = NO;
    }
  }];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
//  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
  
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
//  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
#pragma mark – Private Methods

-(void)setNav{
  self.navigationView.backgroundColor = XKMainTypeColor;
  [self setNavTitle:@"客服主页" WithColor:[UIColor whiteColor]];
  [self setBackButton:nil andName:nil];
  [self hideNavigationSeperateLine];
  
}

-(void)ConfigView{
  [self.containView addSubview:self.mainBackWhiteView];
  [self.mainBackWhiteView addSubview:self.customerIconImageView];
  [self.mainBackWhiteView addSubview:self.diamondImageView];
  [self.mainBackWhiteView addSubview:self.nameLabel];
  [self.mainBackWhiteView addSubview:self.starView];
  [self.mainBackWhiteView addSubview:self.phoneNumLabel];
  self.starView.hidden = YES;
  self.diamondImageView.hidden = YES;
}

-(void)autoLyout{
  [_mainBackWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(13.0);
    make.leading.mas_equalTo(10.0);
    make.trailing.mas_equalTo(-10.0);
  }];
  
  [_customerIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.mainBackWhiteView.mas_centerX);
    make.bottom.mas_equalTo(self.mainBackWhiteView.mas_centerY);
    make.size.mas_equalTo(CGSizeMake(88.0, 88.0));
  }];
  
  [_diamondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.mainBackWhiteView.mas_top).offset(8 * ScreenScale);
    make.centerX.mas_equalTo(self.customerIconImageView.mas_centerX);
    make.size.mas_equalTo(CGSizeMake(28.7 * ScreenScale, 23 * ScreenScale));
  }];
  
  [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.mainBackWhiteView.mas_centerX);
    make.top.mas_equalTo(self.customerIconImageView.mas_bottom).offset(25.0);
  }];
  
  [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.mainBackWhiteView.mas_centerX);
    make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(18 * ScreenScale);
    make.size.mas_equalTo(CGSizeMake(100 * ScreenScale, 15 * ScreenScale));
  }];
  
  [_phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.mainBackWhiteView.mas_centerX);
    make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10.0);
    make.bottom.mas_equalTo(self.mainBackWhiteView).offset(-35.0);
  }];
}

-(void)test{
  
  _nameLabel.text = @"晓可客服";
  _starView.scorePercent = 5.0 / 5.0;
}

-(void)loadDate{
  
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/lastCustomerServiceInfo/1.0"
                              timeoutInterval:10
                                   parameters:@{@"userId":[XKUserInfo getCurrentUserId]}
                                      success:^(id responseObject) {
                                        if (responseObject) {
                                          [self getCustomerSerInfoWithRespons:responseObject];
                                        }
                                        else{
                                          
                                        }
                                      } failure:^(XKHttpErrror *error) {
                                        NSLog(@"");
                                      }];
  
}

-(void)getCustomerSerInfoWithRespons:(id)responseObject{
  NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",responseObject]];
  if (dict[@"workOrderId"]) {
    [HTTPClient postEncryptRequestWithURLString:@"sys/ua/customerServiceDetail/1.0" timeoutInterval:10 parameters:@{@"id":dict[@"workOrderId"],@"customerServiceId":dict[@"customerServiceId"]} success:^(id responseObject) {
      NSLog(@"");
      [self handleResponse:responseObject];
    } failure:^(XKHttpErrror *error) {
      NSLog(@"");
    }];
  }
  else{
    
  }
}

-(void)handleResponse:(id)responseObject{
  NSDictionary *dic = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",responseObject]];
  if (dic[@"level"]) {
    _starView.scorePercent = [dic[@"level"]floatValue] / 5.0;
  }
  if (dic[@"avatar"]) {
    [_customerIconImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:kDefaultHeadImg];
  }
  if (dic[@"nickName"]) {
    _nameLabel.text = [NSString stringWithFormat:@"晓可客服:%@",dic[@"nickName"]];
  }
}
#pragma mark - Events


#pragma mark – Getters and Setters
-(UIView *)mainBackWhiteView{
  if (!_mainBackWhiteView) {
    _mainBackWhiteView = [[UIView alloc] init];
    _mainBackWhiteView.backgroundColor = [UIColor whiteColor];
    _mainBackWhiteView.xk_radius = 8.0;
    _mainBackWhiteView.xk_openClip = YES;
    _mainBackWhiteView.xk_clipType = XKCornerClipTypeAllCorners;
  }
  return _mainBackWhiteView;
}

-(UIImageView *)customerIconImageView{
  if (!_customerIconImageView) {
    _customerIconImageView = [[UIImageView alloc] init];
    _customerIconImageView.backgroundColor = [UIColor whiteColor];
    [_customerIconImageView setImage:[UIImage imageNamed:@"xk_icon_im_customerSerLogoMerchant"]];
    //        [_customerIconImageView cutCornerWithRadius:5 color:UIColorFromRGB(0x222222) lineWidth:1];
  }
  return _customerIconImageView;
}

-(UIImageView *)diamondImageView{
  if (!_diamondImageView) {
    _diamondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_btn_customerSer_diamond"]];
    _diamondImageView.backgroundColor = [UIColor clearColor];
  }
  return _diamondImageView;
}

-(UILabel *)nameLabel{
  if (!_nameLabel) {
    _nameLabel = [BaseViewFactory labelWithFram:CGRectZero text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
  }
  return _nameLabel;
}

-(XKCommonStarView *)starView{
  if (!_starView) {
    _starView = [[XKCommonStarView alloc]initWithFrame:CGRectMake(0, 0, 100 * ScreenScale, 15 * ScreenScale) numberOfStars:5];
    _starView.userInteractionEnabled = NO;
  }
  return _starView;
}

-(UILabel *)phoneNumLabel{
  if (!_phoneNumLabel) {
    _phoneNumLabel = [BaseViewFactory labelWithFram:CGRectZero text:@"400-080-1118" font:XKRegularFont(14) textColor:UIColorFromRGB(0x4a90fa) backgroundColor:[UIColor whiteColor]];
    _phoneNumLabel.adjustsFontSizeToFitWidth = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    _phoneNumLabel.userInteractionEnabled = YES;
    [_phoneNumLabel addGestureRecognizer:tap];
  }
  return _phoneNumLabel;
}

- (void)tap {
  NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-080-1118"];
  [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
}

//获取appIconName
-(NSString*)getAppIconName{
  NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
  NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
  NSLog(@"GetAppIconName,icon:%@",icon);
  return icon;
}
@end
