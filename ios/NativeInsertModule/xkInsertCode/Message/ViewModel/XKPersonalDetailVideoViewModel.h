/*******************************************************************************
 # File        : XKPersonalDetailVideoViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/26
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>

@interface XKPersonalDetailVideoViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, copy) NSString *userId;

/**请求列表*/
- (void)requestComplete:(void (^)(id error,id data))complete;

/**滚动回调*/
@property(nonatomic, copy) void(^scrollViewScroll)(UIScrollView *scrollView);

- (void)registerCellForTableView:(UITableView *)tableView;

@end
