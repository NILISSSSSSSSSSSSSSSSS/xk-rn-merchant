/*******************************************************************************
 # File        : XKSwitchTableViewCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKBaseTableViewCell.h"
#import "XKSectionHeaderSwithView.h"

@interface XKSwitchTableViewCell : XKBaseTableViewCell
@property(nonatomic, strong, readonly) XKSectionHeaderSwithView *switchView;

/**switch事件*/
@property(nonatomic, copy) void(^switchClick)(BOOL isOn);
@end
