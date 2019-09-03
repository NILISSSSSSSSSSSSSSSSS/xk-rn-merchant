/*******************************************************************************
 # File        : XKCheckTableViewCell.h
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

#import "XKBaseTableViewCell.h"

@interface XKCheckTableViewCell : XKBaseTableViewCell

@property(nonatomic, strong, readonly) UIButton *chooseBtn;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
@end
