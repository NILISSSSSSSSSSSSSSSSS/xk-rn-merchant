/*******************************************************************************
 # File        : XKSecretContactListController.h
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

#import "XKContactBaseController.h"
#import "XKSecreContactListViewModel.h"
#import "XKContactModel.h"

@interface XKSecretContactListController : XKContactBaseController

/** 2 5 type没做*/
@property(nonatomic, assign) XKContactUseType useType;
/**
 设置底部按钮 不设置没有底部按钮 （选择状态下有效）
 */
@property(nonatomic, copy) NSString *bottomButtonText;
/**
 设置导航栏右侧完成按钮 不设置没有 （选择状态下有效）
 */
@property(nonatomic, copy) NSString *rightButtonText;
/**密友圈id*/
@property(nonatomic, copy) NSString *secretId;

/**是否显示已选中数量*/
@property(nonatomic, assign) BOOL showSelectedNum;

/**选择状态下的默认选中的数据*/
@property(nonatomic, copy) NSArray *defaultSelected;
/**选择状态下的默认选中是否置灰不可点击*/
@property(nonatomic, assign) BOOL defaultIsGray;

/**确认回调*/
@property(nonatomic, copy) void(^sureClickBlock)(NSArray <XKContactModel *>*contacts,XKSecretContactListController *listVC);

#pragma mark - 获取选择的数量
- (NSArray <XKContactModel *>*)getSelectedArray;
@end
