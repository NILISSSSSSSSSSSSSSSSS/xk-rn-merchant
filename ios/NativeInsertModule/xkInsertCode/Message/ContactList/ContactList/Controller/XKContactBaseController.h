/*******************************************************************************
 # File        : XKContactBaseController.h
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

#import "BaseViewController.h"

#define kViewMargin 10

@interface XKContactBaseController : BaseViewController
/**搜索view*/
@property(nonatomic, strong) UIView *searchView;
/**搜索框*/
@property(nonatomic, strong) UITextField *searchField;
/**tableView*/
@property(nonatomic, strong) UITableView *tableView;
/**底部自定义视图*/
@property(nonatomic, strong) UIView *bottomView;

- (void)createTableView;
- (void)createSearchView;

@end
