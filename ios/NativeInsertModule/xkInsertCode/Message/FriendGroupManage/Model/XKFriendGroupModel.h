/*******************************************************************************
 # File        : XKFriendGroupModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/9
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

typedef NS_ENUM(NSInteger,XKGroupType) {
    XKGroupFriendType = 0, // 好友
    XKGroupSecretType, // 密友
    XKGroupLabelType, // 标签
};

@interface XKFriendGroupModel : NSObject<YYModel>


@property(nonatomic, copy) NSString *groupName;

/**friend / secret / label */
@property(nonatomic, copy) NSString *groupType;

@property(nonatomic, copy) NSString *groupId;

@property(nonatomic, copy) NSString *status;
/***/
@property(nonatomic, strong) NSMutableArray <XKContactModel *>*list;

/**groupType 返回时有效*/
- (XKGroupType)groupTypeEnum;

/**辅助*/
@property(nonatomic, assign) BOOL selected;
@end
