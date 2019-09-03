/*******************************************************************************
 # File        : XKVisiblelAuthorityInfo.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/16
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
#import "XKContactModel.h"
#import "XKFriendGroupModel.h"


@class XKVisiblelAuthorityInfo;
@interface XKVisiblelAuthorityResult :NSObject

@property(nonatomic, strong) NSMutableArray <XKVisiblelAuthorityInfo *>*dataArray;

@property(nonatomic, assign) NSInteger currentInfoIndex;
#pragma mark - 外部使用
- (BOOL)containNetData;

#pragma mark - 外部使用
/**获取权限类型*/
- (NSString *)getDynamicAuthType;
/**获取用户组*/
- (NSArray <NSString *>*)getDynamicUserIds;
/**获取显示文本*/
- (NSString *)getDynamicDisplayInfo;

@end

@class XKVisiblelAuthorityItem;
@interface XKVisiblelAuthorityInfo : NSObject

/**标题*/
@property(nonatomic, copy) NSString *title;
/**描述*/
@property(nonatomic, copy) NSString *describe;
/**描述*/
@property(nonatomic, copy) NSString *dynamicAuthType;
/**是否选中*/
@property(nonatomic, assign) BOOL selected;
/**<##>*/
@property(nonatomic, strong) NSMutableArray <XKVisiblelAuthorityItem *>*itemsArray;
/**isFromAdress*/
@property(nonatomic, strong) XKVisiblelAuthorityItem *itemFromAddress;

@end

@interface XKVisiblelAuthorityItem : NSObject
/**组名*/
@property(nonatomic, copy) NSString *groupName;
/**组描述 */
@property(nonatomic, copy) NSString *groupInfo;

/**组详细信息*/
@property(nonatomic, strong) XKFriendGroupModel *group;

/**是否有详情操作*/
@property(nonatomic, assign) BOOL hasInfo;
/**是否选中*/
@property(nonatomic, assign) BOOL selected;

// 作为通讯录时使用
@property(nonatomic, strong) NSMutableArray <XKContactModel *>*userArray;

- (BOOL)showInfoBtn;

@end


