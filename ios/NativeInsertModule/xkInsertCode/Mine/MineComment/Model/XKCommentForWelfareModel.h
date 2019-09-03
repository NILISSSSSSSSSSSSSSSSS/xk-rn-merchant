/*******************************************************************************
 # File        : XKCommentForWelfareModel.h
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

#import "XKCommentBaseInfo.h"
@class XKWelfareInfo;
@interface XKCommentForWelfareModel : XKCommentBaseInfo
/**<##>*/
@property(nonatomic, strong) XKWelfareInfo *goods;
@end

@interface XKWelfareInfo:NSObject <YYModel>
@property (nonatomic , copy) NSString              * mainPic;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * usage;
@property (nonatomic , copy) NSString              * integral;
@property (nonatomic , copy) NSString              * nper; // 开奖期数
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * winDate;
@property (nonatomic , copy) NSString              * jSequenceId; // 开奖期id

@end

