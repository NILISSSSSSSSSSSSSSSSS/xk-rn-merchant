/*******************************************************************************
 # File        : XKSecretTipEditController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/12
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

@interface XKSecretTipEditController : BaseViewController

/**<##>*/
@property(nonatomic, copy) NSString *secretId;

/**<##>*/
@property(nonatomic, copy) void(^changeBlock)(void);

@end

@interface XKSecretTipMsg :NSObject <YYModel>

/**<##>*/
@property(nonatomic, copy) NSString *msgContent;
@property(nonatomic, copy) NSString *msgId;
@property(nonatomic, copy) NSString *msgMappingUserId;
@property(nonatomic, assign) NSInteger invalidDay;
@property(nonatomic, copy) NSString *secretId;
@property(nonatomic, assign) BOOL timerMsgStatus;
@property(nonatomic, copy) NSString *sendTime;
@property(nonatomic, copy) NSString *mappingMsgType;

@property(nonatomic, copy) NSString *displayTime;
@end
