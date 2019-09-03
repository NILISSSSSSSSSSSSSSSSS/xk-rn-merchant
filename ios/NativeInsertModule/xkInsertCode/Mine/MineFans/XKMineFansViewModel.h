/*******************************************************************************
 # File        : XKMineFansViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/25
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

@interface XKMineFansViewModel : NSObject
/**数据源*/
@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, assign) RefreshDataStatus refreshStatus;
/**查看的别人的传*/
@property(nonatomic, copy) NSString *rid;

- (void)requestIsRefresh:(BOOL)isRefresh complete:(void(^)(NSString *error,NSArray *array))complete;

- (void)requestFocus:(NSIndexPath *)indexPath complete:(void(^)(NSString *error,id data))complete;
@end
