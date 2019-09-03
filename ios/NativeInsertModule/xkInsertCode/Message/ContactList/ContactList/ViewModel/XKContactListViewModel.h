/*******************************************************************************
 # File        : XKContactListViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/10
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
#import "XKContactBaseViewModel.h"


@interface XKContactListViewModel : XKContactBaseViewModel

/**选择状态下的默认选中的数据*/
@property(nonatomic, copy) NSArray *defaultSelected;
/**外部传入的数据源*/
@property(nonatomic, copy) NSArray<XKContactModel *> *outDataArray;
/**选择状态下的默认选中是否置灰不可点击*/
@property(nonatomic, assign) BOOL defaultIsGray;
/**密友圈id useType为添加密友时传入*/
@property(nonatomic, copy) NSString *secretId;

/**确认点击*/
@property(nonatomic, copy) void(^sureClick)(void);

- (void)requestComplete:(void (^)(NSString *, NSArray *))complete;

#pragma mark - 获取选择的数据
- (NSArray *)getSelectedArray;

@end
