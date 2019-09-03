/*******************************************************************************
 # File        : XKFriendCircleBaseModel.h
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

#import <Foundation/Foundation.h>
#import "XKFriendTalkModel.h"

@interface XKFriendCircleBaseViewModel : NSObject <UITableViewDataSource,UITableViewDelegate>
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;
/***/
@property(nonatomic, copy) NSString *timeStamp;
@property(nonatomic, assign) RefreshDataStatus refreshStatus;

/**dataArray*/
@property(nonatomic, strong) NSMutableArray *dataArray;
/**滚动回调*/
@property(nonatomic, copy) void(^scrollViewScroll)(UIScrollView *scrollView);

- (void)configVCToolBar:(BaseViewController *)vc;

/**<##>*/
@property(nonatomic, copy) void(^refreshTableView)(void);

- (void)registerCellForTableView:(UITableView *)tableView;


- (void)requestDelete:(NSString *)did Complete:(void (^)(NSString *err, id data))completeBlock;
@end
