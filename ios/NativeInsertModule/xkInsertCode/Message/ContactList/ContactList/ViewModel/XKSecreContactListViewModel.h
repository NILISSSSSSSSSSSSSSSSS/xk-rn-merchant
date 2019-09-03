/*******************************************************************************
 # File        : XKSecreContactListViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKContactBaseViewModel.h"

@interface XKSecreContactListViewModel : XKContactBaseViewModel

/**<##>*/
@property(nonatomic, copy) NSString *secretId;
/**选择状态下的默认选中的数据*/
@property(nonatomic, copy) NSArray *defaultSelected;
/**选择状态下的默认选中是否置灰不可点击*/
@property(nonatomic, assign) BOOL defaultIsGray;
/**确认点击*/
@property(nonatomic, copy) void(^sureClick)(void);

- (void)requestComplete:(void (^)(NSString *, NSArray *))complete;

#pragma mark - 获取选择的数据
- (NSArray *)getSelectedArray;
@end
