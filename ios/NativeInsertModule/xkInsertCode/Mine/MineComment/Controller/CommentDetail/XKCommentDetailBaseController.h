/*******************************************************************************
 # File        : XKCommentDetailBaseController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/12
 # Corporation : 水木科技
 # Description :
 点评 详情
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BaseViewController.h"
#import "XKCommentDetailBaseViewModel.h"


@interface XKCommentDetailBaseController : BaseViewController

@property(nonatomic, assign) XKCommentDetailType detailType;
@property(nonatomic, copy) NSString *commentId;

@end
