/*******************************************************************************
 # File        : XKReceiptListViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/20
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
#import "XKReceiptInfoModel.h"

@interface XKReceiptListViewModel : NSObject
/**数据源*/
@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, assign) RefreshDataStatus refreshStatus;

- (void)requestIsRefresh:(BOOL)isRefresh complete:(void(^)(NSString *error,NSArray *array))complete;

@end
