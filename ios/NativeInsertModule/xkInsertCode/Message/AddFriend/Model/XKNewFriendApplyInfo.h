/*******************************************************************************
 # File        : XKNewFriendApplyInfo.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/17
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

@interface XKNewFriendApplyInfo : NSObject<YYModel>

@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , assign) BOOL                isPass;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * applyId;
@property (nonatomic , copy) NSString              * validateMsg;

@end
