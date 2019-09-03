/*******************************************************************************
 # File        : XKContactBaseController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/19
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKContactBaseController.h"

@interface XKContactBaseController ()

@end

@implementation XKContactBaseController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self supreCreateDefaultData];
  // 初始化界面
  [self supreCreateUI];
}

- (void)supreCreateDefaultData {
  
}

- (void)supreCreateUI {
  
}

- (void)createSearchView {
  _searchView = [UIView new];
  _searchView.backgroundColor = [UIColor whiteColor];
  _searchView.xk_openClip = YES;
  _searchView.xk_radius = 8;
  _searchView.xk_clipType = XKCornerClipTypeAllCorners;
  self.searchView.frame = CGRectMake(kViewMargin, kViewMargin, SCREEN_WIDTH - 2 *kViewMargin, 45);
  [self.containView addSubview:self.searchView];
  
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.image = self.navStyle == BaseNavWhiteStyle ? IMG_NAME(@"xk_ic_search_xi") : IMG_NAME(@"xk_ic_contact_search");
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [_searchView addSubview:imageView];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.searchView.mas_left).offset(12);
    make.height.equalTo(@16);
    make.centerY.equalTo(self.searchView);
    make.width.equalTo(@26);
  }];
  
  self.searchField = [[UITextField alloc] init];
  NSAttributedString *place = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
    confer.text(@"请输入昵称或者备注").font(XKRegularFont(14)).textColor(RGBGRAY(160));
  }];
  self.searchField.attributedPlaceholder = place;
  self.searchField.font = XKRegularFont(14);
  self.searchField.returnKeyType = UIReturnKeyDone;
  self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
  
  [_searchView addSubview:self.searchField];
  [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(imageView.mas_right).offset(5);
    make.top.bottom.equalTo(self.searchView);
    make.right.equalTo(self.searchView.mas_right).offset(-10);
  }];
}

- (void)createTableView {
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.backgroundColor = self.containView.backgroundColor;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kViewMargin, 0);
  [self.containView addSubview:self.tableView];
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
  self.tableView.sectionIndexColor = HEX_RGB(0x7777777);
}


@end
