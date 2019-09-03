/*******************************************************************************
 # File        : XKBaseListController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/26
 # Corporation : 水木科技
 # Description :

 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BaseViewController.h"

/** 通用风格tableView列表 自带刷新和占位图逻辑 继承后只需要实现数据请求 以及cell赋值等操作*/

@protocol XKBaseListControllerProtocol
@required
/**子类重写 实现数据请求*/
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void(^)(NSString *error,NSArray *array))complete;
/**子类重写 实现返回cell*/
- (UITableViewCell *)returnCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
@optional
/**子类实现 处理cell 的点击事件*/
- (void)dealCellClick:(NSIndexPath *)indexPath;
/**子类实现 tableView更多详细配置的设值*/
- (void)configMoreForTableView:(UITableView *)tableView;
/**子类重写 是否显示导航栏 默认显示了*/
- (BOOL)needNav;

@end

@interface XKBaseListController : BaseViewController<XKBaseListControllerProtocol>

@property(nonatomic, strong, readonly) NSMutableArray *dataArray;
/**tableView*/
@property(nonatomic, strong, readonly) UITableView *tableView;

/**供外界调用的第一次请求 只会请求一次*/
- (void)requestFirst;

/**后续手动刷新数据 */
- (void)refreshDataNeedTip:(BOOL)needTip;
@end
