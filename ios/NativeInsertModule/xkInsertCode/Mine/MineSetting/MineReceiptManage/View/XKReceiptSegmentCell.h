/*******************************************************************************
 # File        : XKReceiptSegmentCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReceiptInfoBaseCell.h"

@interface XKReceiptSegmentCell : XKReceiptInfoBaseCell

/**切换*/
@property(nonatomic, copy) void(^check)(BOOL forPerson);
@end
