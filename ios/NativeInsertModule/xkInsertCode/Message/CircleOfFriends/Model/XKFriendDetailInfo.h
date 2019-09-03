/*******************************************************************************
 # File        : XKFriendDetailInfo.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/11
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

@interface XKFriendDetailInfo : NSObject
@property (nonatomic , copy) NSString              * friendRemark;
@property (nonatomic , copy) NSString              * secretRemark;
@property (nonatomic , assign) NSInteger              visitTaCF;
@property (nonatomic , assign) NSInteger              visitMeCF;
@property (nonatomic , assign) XKRelationType         secretRelation;
@property (nonatomic , assign) XKRelationType         friendRelation;
@property (nonatomic , copy) NSString              * friendId;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , assign) BOOL                  isBlackList;

@end
