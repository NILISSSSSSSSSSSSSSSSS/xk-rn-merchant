/*******************************************************************************
 # File        : XKFriendTalkRecordModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/5
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

@interface XKFriendTalkRecordModel : NSObject

@property (nonatomic , copy) NSString              * releaseTime;
@property (nonatomic , copy) NSString              * detailType;
@property (nonatomic , copy) NSString              * commentContent;
@property (nonatomic , copy) NSString              * dynamicContent;
@property (nonatomic , copy) NSString              * did;
@property (nonatomic , copy) NSString              * status;
/**like comment*/
@property (nonatomic , copy) NSString              * msgLogType;
@property (nonatomic , assign) BOOL                  unRead;
@property (nonatomic , copy) NSString              * releaseUserId;
@property (nonatomic , strong) XKContactModel      * releaseUser;

@end
