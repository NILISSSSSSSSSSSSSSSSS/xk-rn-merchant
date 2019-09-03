/*******************************************************************************
 # File        : XKGoodsAllCommentViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "XKCommentLabelModel.h"

typedef NS_ENUM(NSInteger,XKAllCommentType){
    XKAllCommentTypeForGoods = 0,
    XKAllCommentTypeForWelfare
};

@interface XKGoodsAllCommentViewModel : NSObject <UITableViewDelegate, UITableViewDataSource>
/**当前的请求种类*/
@property(nonatomic, copy) NSString *tag;
@property(nonatomic, copy) NSString *goodsId;
/**<##>*/
@property(nonatomic, assign) XKAllCommentType type;
@property(nonatomic, strong) NSMutableArray *labelDataArray;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) RefreshDataStatus refreshStatus;
/**<##>*/
@property(nonatomic, copy) void(^reloadData)(void);

- (void)registerCellForTableView:(UITableView *)tableView;

- (void)requestIsRefresh:(BOOL)isRefresh tag:(NSString *)tag complete:(void(^)(NSString *error,NSArray *array))complete;

- (void)requestCommentLabelComplete:(void(^)(NSString *error,id data))complete;

@end
