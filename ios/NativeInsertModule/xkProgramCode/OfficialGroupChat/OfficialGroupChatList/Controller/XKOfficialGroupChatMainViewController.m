//
//  XKOfficialGroupChatMainViewController.m
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/25.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKOfficialGroupChatMainViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKMenuView.h"
#import "XKOfficialGroupChatListViewController.h"
#import "IAPCenter+XK.h"
#import "XKCityDBManager.h"

static NSString *const kOfficialGroupChatMainViewControllerGetMerchantMainCitiesUrl = @"user/ua/merchantMainCities/1.0";
static NSString *const kOfficialGroupChatMainViewControllerGetGroupChatListUrl = @"im/ma/trainTeamList/1.0";
static NSString *const kOfficialGroupChatMainViewControllerMerchantType = @"merchantType";
static NSString *const kOfficialGroupChatMainViewControllerMerchantName = @"merchantName";
static NSString *const kOfficialGroupChatMainViewControllerProvinceCodeName = @"provinceCodeName";
static NSString *const kOfficialGroupChatMainViewControllerCityName = @"cityName";
static NSString *const kOfficialGroupChatMainViewControllerDistrictName = @"districtName";
static NSString *const kOfficialGroupChatMainViewControllerProvinceCode = @"provinceCode";
static NSString *const kOfficialGroupChatMainViewControllerCityCode = @"cityCode";
static NSString *const kOfficialGroupChatMainViewControllerDistrictCode = @"districtCode";

@interface XKOfficialGroupChatMainViewController ()

@property (nonatomic, strong) UIButton *areaButton;
@property (nonatomic, strong) XKScrollPageMenuView *pageMenu;
@property (nonatomic, strong) XKMenuView *menuView;

@property (nonatomic, strong) NSArray *merchantArr;
@property (nonatomic, strong) NSArray *areaArr;
@property (nonatomic, strong) NSDictionary *currentMerchantDict;
@property (nonatomic, strong) NSDictionary *currentAreaDict;
@property (nonatomic, assign) NSInteger currentpageMenuIndex;

@end

@implementation XKOfficialGroupChatMainViewController

- (void)dealloc {
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self initializeView];
}

- (void)initializeView {
  
  self.navigationView.hidden = NO;
  [self setNavTitle:@"官方群列表" WithColor:[UIColor whiteColor]];
  
  // 导航栏右侧视图
  UIButton *areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
  areaButton.adjustsImageWhenHighlighted = NO;
  areaButton.titleLabel.font = XKFont(XK_PingFangSC_Semibold, 17);
  areaButton.titleLabel.textAlignment = NSTextAlignmentLeft;
  [areaButton setImage:[UIImage imageNamed:@"xk_btn_mall_select"] forState:UIControlStateNormal];
  [areaButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
  [areaButton setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
  areaButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  [areaButton addTarget:self action:@selector(clickAreaButton:) forControlEvents:UIControlEventTouchUpInside];
  areaButton.titleLabel.tintColor = [UIColor whiteColor];
  [self setRightView:areaButton withframe:CGRectMake(0, 0, 90, 24)];
  self.areaButton = areaButton;
  
  // 获取商户类型并初始化滑动选择器
  [self getAllMerchantType];
}

/**
 * 获取所有支持商户类型
 */
- (void)getAllMerchantType {
  
  XKUserInfo *userInfo = [XKUserInfo currentUser];
  NSMutableArray *merchant = userInfo.merchant.mutableCopy;
  
  // 加入【全部】选项
  NSDictionary *wholeMerchantDict = @{@"merchantType": @"",
                                      @"agreement": @"",
                                      @"name": @"全部",
                                      @"auditStatus": @(0)};
  [merchant insertObject:wholeMerchantDict atIndex:0];
  
  if (merchant.count > 0) {
    NSMutableArray *pageMenuTitleArr = @[].mutableCopy;
    NSMutableArray *pageMenuViewControllerArr = @[].mutableCopy;
    for (NSDictionary *merchantDict in merchant) {
      XKOfficialGroupChatListViewController *officialGroupChatListViewController = [XKOfficialGroupChatListViewController new];
      [pageMenuTitleArr addObject:merchantDict[@"name"]];
      [pageMenuViewControllerArr addObject:officialGroupChatListViewController];
    }
    
    // 滑动选择视图
    XKScrollPageMenuView *pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height)];
    
    self.pageMenu = pageMenu;
    self.merchantArr = merchant;
    self.currentpageMenuIndex = 0;
    self.currentMerchantDict = merchant[0];
    
    pageMenu.titles = pageMenuTitleArr.copy;
    pageMenu.childViews = pageMenuViewControllerArr.copy;
    pageMenu.sliderSize = CGSizeMake(50, 6);
    pageMenu.titleColor = [UIColor colorWithWhite:1 alpha:0.5];
    pageMenu.backgroundColor = XKMainTypeColor;
    pageMenu.titleSelectedColor = [UIColor whiteColor];
    pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
    pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
    pageMenu.sliderColor = [UIColor whiteColor];
    pageMenu.numberOfTitles = 5;
    pageMenu.titleBarHeight = 40;
    __weak typeof(self) weakSelf = self;
    pageMenu.selectedBlock = ^(NSInteger index) {
      weakSelf.currentpageMenuIndex = index;
      weakSelf.currentMerchantDict = weakSelf.merchantArr[index];
      [weakSelf getGroupAreaData];
    };
    [self.view addSubview:pageMenu];
    
    // 根据首个类型获取支持地区
    [self getGroupAreaData];
  }
}

/**
 * 根据商户类型获取所有支持的城市，暂不支持缓存
 */
- (void)getGroupAreaData {
  
  NSString *merchantTypeCode = self.currentMerchantDict[kOfficialGroupChatMainViewControllerMerchantType];
  NSString *url = kOfficialGroupChatMainViewControllerGetMerchantMainCitiesUrl;
  NSMutableDictionary *params = @{}.mutableCopy;
  params[kOfficialGroupChatMainViewControllerMerchantType] = merchantTypeCode;
  [XKHudView showLoadingTo:self.view animated:YES];
  [HTTPClient  postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    [XKHudView hideHUDForView:self.view];
    // 仅处理最后一次请求选择商户类型
    if (![self.currentMerchantDict[kOfficialGroupChatMainViewControllerMerchantType] isEqualToString: merchantTypeCode]) {
      return;
    }
    NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *areaArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    if (areaArr.count > 0) {
      
      // 加入【全部】地区选项
       NSDictionary *wholeAreaDict = @{@"provinceName": @"",
                                      @"provinceCode": @"",
                                      @"cityName": @"",
                                      @"cityCode": @"",
                                      @"districtName": @"全部",
                                      @"districtCode": @""};
      NSMutableArray *tempAreaArr = areaArr.mutableCopy;
      [tempAreaArr insertObject:wholeAreaDict atIndex:0];
      self.areaArr = tempAreaArr.copy;
      self.currentAreaDict = self.areaArr[0];
      self.areaButton.hidden = NO;
      [self.areaButton setTitle:self.currentAreaDict[kOfficialGroupChatMainViewControllerDistrictName] forState:UIControlStateNormal];
      [self getGroupChatList];
      
    } else {
      NSDictionary *tempDict = @{kOfficialGroupChatMainViewControllerDistrictName: @""};
      self.areaArr = @[tempDict];
      self.areaButton.hidden = YES;
      [self.areaButton setTitle:@"" forState:UIControlStateNormal];
    }
    
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.view];
    NSDictionary *tempDict = @{kOfficialGroupChatMainViewControllerDistrictName: @""};
    self.areaArr = @[tempDict];
    self.areaButton.hidden = YES;
    [self.areaButton setTitle:@"" forState:UIControlStateNormal];
  }];
}

/**
 * 根据商户类型及区域获取官方群列表
 */
- (void)getGroupChatList {
  
  NSString *url = kOfficialGroupChatMainViewControllerGetGroupChatListUrl;
  NSString *merchantTypeCode = self.currentMerchantDict[kOfficialGroupChatMainViewControllerMerchantType];
  NSString *provinceCode = self.currentAreaDict[kOfficialGroupChatMainViewControllerProvinceCode];
  NSString *cityCode = self.currentAreaDict[kOfficialGroupChatMainViewControllerCityCode];
  NSString *districtCode = self.currentAreaDict[kOfficialGroupChatMainViewControllerDistrictCode];
  
  NSMutableDictionary *params = @{}.mutableCopy;
  params[kOfficialGroupChatMainViewControllerMerchantType] = merchantTypeCode;
  params[kOfficialGroupChatMainViewControllerProvinceCode] = provinceCode;
  params[kOfficialGroupChatMainViewControllerCityCode] = cityCode;
  params[kOfficialGroupChatMainViewControllerDistrictCode] = districtCode;

  [XKHudView showLoadingTo:self.view animated:YES];
  [HTTPClient  postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    
    [XKHudView hideHUDForView:self.view];
    // 仅处理最后一次请求选择商户类型
    if (![self.currentMerchantDict[kOfficialGroupChatMainViewControllerMerchantType] isEqualToString: merchantTypeCode]) {
      return;
    }
    
    // 仅处理最后一次请求选择地区
    if (![self.currentAreaDict[kOfficialGroupChatMainViewControllerDistrictCode] isEqualToString: districtCode]) {
      return;
    }
    
    if (responseObject != nil) {
      NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
      NSArray *groupChatArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
      if (groupChatArr.count > 0) {
        XKOfficialGroupChatListViewController *officialGroupChatListViewController = self.pageMenu.childViews[self.currentpageMenuIndex];
        officialGroupChatListViewController.merchantType = self.currentMerchantDict[kOfficialGroupChatMainViewControllerMerchantType];
        officialGroupChatListViewController.dataArr = groupChatArr;
      }
    }
    
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.view];
  }];
}

/**
 * 选择区域
 */
- (void)clickAreaButton:(UIControl *)sender {
  
  NSMutableArray *titles = @[].mutableCopy;
  for (NSDictionary *tempDict in self.areaArr) {
    [titles addObject:tempDict[kOfficialGroupChatMainViewControllerDistrictName]];
  }
  XKMenuView *menuView = [XKMenuView menuWithTitles:titles images:nil width:100 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
    self.currentAreaDict = self.areaArr[index];
    [self.areaButton setTitle:self.currentAreaDict[kOfficialGroupChatMainViewControllerDistrictName] forState:UIControlStateNormal];
    [self getGroupChatList];
  }];
  menuView.menuColor = HEX_RGBA(0xffffff, 1);
  menuView.textColor = UIColorFromRGB(0x222222);
  menuView.separatorPadding = 5;
  menuView.textImgSpace = 10;
  menuView.dismissOnTouchOutside = YES;
  menuView.dismissOnselected = YES;
  self.menuView = menuView;
  [self.menuView show];
}

@end
