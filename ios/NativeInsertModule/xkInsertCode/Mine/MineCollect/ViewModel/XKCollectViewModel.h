/*******************************************************************************
 # File        : XKCollectViewModel.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/26
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

@interface XKCollectViewModel : NSObject
/**数据源*/
@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, assign) RefreshDataStatus refreshStatus;

@property(nonatomic, assign) XKControllerType controllerType;

- (void)requestIsRefresh:(BOOL)isRefresh complete:(void(^)(NSString *error,NSArray *array))complete;

- (void)requestIsRefresh:(BOOL)isRefresh typeCode:(NSString *)typeCode complete:(void(^)(NSString *error,NSArray *array))complete;

- (instancetype)initWithViewModelType:(XKCollectViewModelType)viewModelType XKControllerType:(XKControllerType)controllerType;

/**
 店铺分类列表

 @param complete 数组
 */
- (void)shopRequestClassifyComplete:(void(^)(NSString *error,NSArray *array))complete;
/**
 商品分类列表
 
 @param complete 数组
 */
- (void)goodsRequestClassifyComplete:(void (^)(NSString *error, NSArray *array))complete;
/**
 游戏分类列表
 
 @param complete 数组
 */
- (void)gamesRequestClassifyComplete:(void (^)(NSString *error, NSArray *array))complete;
/**
 福利分类列表
 
 @param complete 数组
 */
- (void)welfareRequestClassifyComplete:(void (^)(NSString *error, NSArray *array))complete;
@end
