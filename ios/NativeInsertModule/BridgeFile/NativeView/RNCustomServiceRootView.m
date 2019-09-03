/*******************************************************************************
 # File        : RN_CustomServiceRootView.m
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2018/12/17
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "RNCustomServiceRootView.h"
#import "XKArrowTableViewCell.h"
#import "XKCustomeSerMessageManager.h"
static NSString *const ServiceForShop = @"商户类咨询";
static NSString *const ServiceForZhubo = @"主播类咨询";
static NSString *const ServiceForFamilyElder = @"家族长类咨询";
static NSString *const ServiceForUnion= @"公会类咨询";
static NSString *const ServiceForCorporate = @"合伙人类咨询";
static NSString *const ServiceForPerson = @"个人/团队/公司类咨询";

static NSString *const XKServiceForShopImageName = @"xk_ic_customer_service_merchant";
static NSString *const XKServiceForZhuboImageName = @"xk_ic_customer_service_anchor";
static NSString *const XKServiceForFamilyElderImageName = @"xk_ic_customer_service_family";
static NSString *const XKServiceForUnionImageName = @"xk_ic_customer_service_consortia";
static NSString *const XKServiceForCorporateImageName = @"xk_ic_customer_service_partner";
static NSString *const XKServiceForPersonImageName = @"xk_ic_customer_service_personal";

@interface RNCustomServiceRootView()<UITableViewDelegate,UITableViewDataSource>
/**<##>*/
@property(nonatomic, strong) UITableView *tableView;
/***/
@property(nonatomic, copy) NSArray *dataTitleArray;
@property(nonatomic, copy) NSArray *dataImageArray;
@end

@implementation RNCustomServiceRootView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self viewConfig];
  }
  return self;
}

- (void)viewConfig {
  self.navigationView.backgroundColor = [UIColor whiteColor];
  [self hideNavigationSeperateLine];
  self.containView.backgroundColor = HEX_RGB(0xF8F8F8);
  [self setNavTitle:@"客服咨询" WithColor:[UIColor darkTextColor]];
  [self hiddenBackButton:YES];
  [self createTableView];
  
  self.dataTitleArray = @[ServiceForShop,ServiceForZhubo,ServiceForFamilyElder,ServiceForUnion,ServiceForCorporate,ServiceForPerson];
  
  UIImage *serviceForShopImage = [UIImage imageNamed:XKServiceForShopImageName];
  UIImage *serviceForZhuboImage = [UIImage imageNamed:XKServiceForZhuboImageName];
  UIImage *serviceForFamilyElderImage = [UIImage imageNamed:XKServiceForFamilyElderImageName];
  UIImage *serviceForUnionImage = [UIImage imageNamed:XKServiceForUnionImageName];
  UIImage *serviceForCorporateImage = [UIImage imageNamed:XKServiceForCorporateImageName];
  UIImage *serviceForPersonImage = [UIImage imageNamed:XKServiceForPersonImageName];
  self.dataImageArray = @[serviceForShopImage,
                          serviceForZhuboImage,
                          serviceForFamilyElderImage,
                          serviceForUnionImage,
                          serviceForCorporateImage,
                          serviceForPersonImage];
}

- (UIView *)view {
  return self;
}

- (void)createTableView {
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.containView addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
  }];
  [self.tableView registerClass:[XKArrowTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  [cell addCustomSubviews];
  [cell addUIConstraint];
  cell.arrowView.titleLabel.text = self.dataTitleArray[indexPath.row];
  cell.arrowView.leftImage = self.dataImageArray[indexPath.row];
  cell.arrowView.arrowImgView.image = [UIImage imageNamed:@"xk_ic_customer_service__arrow"];
  [cell hiddenSeperateLine:NO];
  if (indexPath.row == 0) {
    [cell clipTopCornerRadius:6];
    if (self.dataTitleArray.count == 1) {
      [cell hiddenSeperateLine:YES];
    }
  } else if (indexPath.row != self.dataTitleArray.count - 1) { // 不是最后一个
    
  } else { // 最后一个
    [cell clipBottomCornerRadius:6];
    [cell hiddenSeperateLine:YES];
  }
  return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataTitleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *title = self.dataTitleArray[indexPath.row];
  
  [XKCustomeSerMessageManager createXKCustomerSerChat];
  
  if ([title isEqualToString:ServiceForShop]) {
    //
  } else {
    
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 66.5;
}

@end
