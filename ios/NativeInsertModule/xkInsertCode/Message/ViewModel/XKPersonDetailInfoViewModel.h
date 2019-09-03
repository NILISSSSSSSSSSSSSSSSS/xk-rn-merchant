/*******************************************************************************
 # File        : XKPersonDetailInfoViewModel.h
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

#import <Foundation/Foundation.h>
#import "XKPesonalDetailInfoModel.h"
#import "XKPersonDetailInfoBottomToolBar.h"
#import "XKPersonDetailInfoViewController.h"

@interface XKPersonDetailInfoViewModel : NSObject <XKPersonDetailInfoBottomToolBarDelegate>

@property(nonatomic, weak) XKPersonDetailInfoViewController *vc;
@property(nonatomic, copy) NSString *userId;
/**请求下来的用户信息*/
@property(nonatomic, strong) XKPesonalDetailInfoModel *personalInfo;

/**刷新界面block*/
@property(nonatomic, copy) void(^updateStatusUI)(void);
/**成功接受好友申请回调*/
@property(nonatomic, copy) void(^acceptApplySuccess)(void);
/**是否有状态修改了*/
@property(nonatomic, assign) BOOL hasStatusChanged;

- (void)requestInfoComplete:(void(^)(NSString *error,id data))complete;

- (void)dealMoreBtnClick:(UIButton *)btn;

- (void)updateData;

#pragma mark - 界面显示逻辑判断
/**申请界面*/
- (BOOL)vc_useForApply;
/** 密友主页  已是密友*/
- (BOOL)vc_useForSecretAndIsFriend;
/**密友主页  还未是密友*/
- (BOOL)vc_useForSecretAndIsNotFriend;
/**可友主页 也是可友*/
- (BOOL)vc_useForFriendAndIsFriend;
/**可友主页 未是可友*/
- (BOOL)vc_useForFriendAndIsNotFriend;

@end
