/*******************************************************************************
 # File        : XKAddFriendController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/15
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKAddFriendController.h"
#import "XKSectionHeaderArrowView.h"
#import "UIView+Border.h"
#import "XKQRCodeCardController.h"
#import "XKQRCodeScanViewController.h"
#import "XKSearchFriendController.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKContactListController.h"
#import "XKQRCodeResultManager.h"

#define kViewMargin 10


@interface XKAddFriendController ()
/***/
@property(nonatomic, strong) UIView *searchView;
/**<##>*/
@property(nonatomic, strong) UITextField *searchField;
/***/

@end

@implementation XKAddFriendController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  
}

#pragma mark - 初始化界面
- (void)createUI {
  if (self.isSecret) {
    [self setNavTitle:@"添加密友" WithColor:[UIColor whiteColor]];
    self.navStyle = BaseNavWhiteStyle;
  } else {
    [self setNavTitle:@"添加可友" WithColor:[UIColor whiteColor]];
  }
  
  self.containView.backgroundColor = HEX_RGB(0xEEEEEE);
  [self createSearchView];
  //    self.searchField.delegate = self.viewModel;
  //    [self.searchField addTarget:self.viewModel action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
  
  [self createAddView];
  
}


#pragma mark ----------------------------- 其他方法 ------------------------------
- (void)createSearchView {
  _searchView = [UIView new];
  _searchView.backgroundColor = [UIColor whiteColor];
  _searchView.xk_openClip = YES;
  _searchView.xk_radius = 8;
  _searchView.xk_clipType = XKCornerClipTypeAllCorners;
  self.searchView.frame = CGRectMake(kViewMargin, kViewMargin, SCREEN_WIDTH - 2 *kViewMargin, 44);
  [self.containView addSubview:self.searchView];
  
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.image = self.navStyle == BaseNavWhiteStyle ? IMG_NAME(@"xk_ic_search_xi") : IMG_NAME(@"xk_ic_contact_search");
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [_searchView addSubview:imageView];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.searchView.mas_left).offset(10);
    make.height.equalTo(@16);
    make.centerY.equalTo(self.searchView);
    make.width.equalTo(@26);
  }];
  
  self.searchField = [[UITextField alloc] init];
  self.searchField.placeholder = @"搜索";
  self.searchField.font = XKRegularFont(15);
  self.searchField.userInteractionEnabled = NO;
  [_searchView addSubview:self.searchField];
  [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(imageView.mas_right).offset(5);
    make.top.bottom.equalTo(self.searchView);
    make.right.equalTo(self.searchView.mas_right).offset(-10);
  }];
  __weak typeof(self) weakSelf = self;
  [self.searchView bk_whenTapped:^{
    [weakSelf searchFriend];
  }];
}

- (void)createAddView {
  __weak typeof(self) weakSelf = self;
  UIView *addView = [UIView new];
  [self.containView addSubview:addView];
  [addView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.searchView);
    make.top.equalTo(self.searchView.mas_bottom).offset(14);
  }];
  UILabel *myNumView = [[UILabel alloc] init];
  NSString *myCode = [XKUserInfo currentUser].uid;
  [myNumView rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
    confer.paragraphStyle.alignment(NSTextAlignmentCenter);
    confer.text([NSString stringWithFormat:@"我的二维码   "]).textColor(HEX_RGB(0x999999)).font([UIFont systemFontOfSize:15]);
    confer.appendImage([UIImage imageNamed:@"xk_ic_addFriend_QR"]).bounds(CGRectMake(0, -5, 20, 20));
  }];
  myNumView.userInteractionEnabled = YES;
  [myNumView bk_whenTapped:^{
    [weakSelf openMyQRCode];
  }];
  [addView addSubview:myNumView];
  [myNumView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(addView.mas_top).offset(2);
    make.left.right.equalTo(addView);
    make.height.equalTo(@25);
  }];
  
  UIView *chooseView = [[UIView alloc] init];
  chooseView.layer.cornerRadius = 6;
  chooseView.backgroundColor = [UIColor whiteColor];
  chooseView.layer.masksToBounds = YES;
  
  [addView addSubview:chooseView];
  [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(myNumView.mas_bottom).offset(12);
    make.left.right.equalTo(addView);
    make.bottom.equalTo(addView.mas_bottom);
  }];
  
  NSMutableArray *itemsArray = @[].mutableCopy;
  [itemsArray addObject:@[@"扫一扫添加",IMG_NAME(@"xk_ic_addFriend_QRScan")]];
  if (self.isSecret) {
    [itemsArray addObject:@[@"可友通讯录添加",IMG_NAME(@"xk_ic_addFriend_AdressList")]];
  }
  UIView *tempView;
  for (int i = 0; i < itemsArray.count; i ++) {
    NSArray *item = itemsArray[i];
    XKSectionHeaderArrowView *arrowView = [[XKSectionHeaderArrowView alloc] init];
    arrowView.leftImage = item.lastObject;
    arrowView.titleLabel.text = item.firstObject;
    [chooseView addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.equalTo(chooseView);
      if (!tempView) {
        make.top.equalTo(chooseView.mas_top);
      } else {
        make.top.equalTo(tempView.mas_bottom);
      }
      make.height.equalTo(@50);
      if (i == itemsArray.count - 1) {
        make.bottom.equalTo(chooseView.mas_bottom);
      }
    }];
    if (i != 0) {
      [arrowView showBorderSite:rzBorderSitePlaceTop];
      arrowView.topBorder.borderLine.backgroundColor = HEX_RGB(0xF1F1F1);
    }
    tempView = arrowView;
    [arrowView bk_whenTapped:^{
      if ([arrowView.titleLabel.text isEqualToString:@"扫一扫添加"]) {
        [weakSelf scanToAdd];
      } else if ([arrowView.titleLabel.text isEqualToString:@"可友通讯录添加"]) {
        [weakSelf addressToAdd];
      }
    }];
  }
}

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark - 搜索
- (void)searchFriend {
  XKSearchFriendController *vc = [XKSearchFriendController new];
  vc.isSecret = self.isSecret;
  vc.secretId = self.secretId;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 扫码添加
- (void)scanToAdd {
  XKQRCodeScanViewController *vc = [[XKQRCodeScanViewController alloc] init];
  vc.vcType = QRCodeScanVCType_QRScan;
  [vc setScanResult:^(NSString *resultString) {
    [XKQRCodeResultManager dealResult:resultString];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 通讯录添加  （密友添加才有）
- (void)addressToAdd {
  XKContactListController *listVC = [XKContactListController new];
  listVC.useType = XKContactUseTypeNormalForAddSecret;
  listVC.secretId = self.secretId;
  [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - 打开我的二维码
- (void)openMyQRCode {
  XKQRCodeCardController *vc = [XKQRCodeCardController new];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
