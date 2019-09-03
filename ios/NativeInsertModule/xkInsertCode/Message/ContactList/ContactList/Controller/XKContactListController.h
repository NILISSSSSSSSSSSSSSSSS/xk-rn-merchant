/*******************************************************************************
 # File        : XKContactListController.h
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

#import "BaseViewController.h"
#import "XKContactListViewModel.h"
#import "XKContactModel.h"
#import "XKContactBaseController.h"

@interface XKContactListController : XKContactBaseController

@property(nonatomic, assign) XKContactUseType useType;
/**
 设置底部按钮 不设置没有底部按钮
 */
@property(nonatomic, copy) NSString *bottomButtonText;
/**
 设置导航栏右侧按钮 不设置没有
 */
@property(nonatomic, copy) NSString *rightButtonText;

/**是否显示已选中数量*/
@property(nonatomic, assign) BOOL showSelectedNum;
/**搜索条下的信息文本*/
@property(nonatomic, copy) NSString *infoText;

/**选择状态下的默认选中的数据*/
@property(nonatomic, copy) NSArray<XKContactModel *> *defaultSelected;
/**选择状态下的默认选中是否置灰不可点击*/
@property(nonatomic, assign) BOOL defaultIsGray;
/**选择状态下的确认按钮是否置灰没有选中置灰不可点*/
@property(nonatomic, assign) BOOL sureBtnIsGrayWhenNoChoose;

/**密友圈id useType为添加密友时传入*/
@property(nonatomic, copy) NSString *secretId;
/**会使用的外部数据源 不会请求了 userType 为XKContactUseTypeUseOutDateAndManySelected使用*/
@property(nonatomic, copy) NSArray<XKContactModel *> *outDataArray;

/**按钮的确认回调*/
@property(nonatomic, copy) void(^sureClickBlock)(NSArray <XKContactModel *>*contacts,XKContactListController *listVC);

#pragma mark - 获取选择的数量
- (NSArray <XKContactModel *>*)getSelectedArray;

@end
