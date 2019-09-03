/*******************************************************************************
 # File        : XKReplyBaseInfo.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/27
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
#import "XKContactModel.h"

@interface XKReplyBaseInfo : NSObject<YYModel>

@property(nonatomic, strong) XKContactModel        * creator;
@property(nonatomic, strong) XKContactModel        * refCreator;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * replyId;

- (NSString *)getDisplayTime;
@end
