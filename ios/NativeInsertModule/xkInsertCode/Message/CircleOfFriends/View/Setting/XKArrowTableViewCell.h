/*******************************************************************************
 # File        : XKArrowTableViewCell.h
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
#import "XKSectionHeaderArrowView.h"
@interface XKArrowTableViewCell : XKBaseTableViewCell
@property(nonatomic, strong, readonly) XKSectionHeaderArrowView *arrowView;

- (void)clipTopCornerRadius:(CGFloat)cornerRadius;
- (void)clipBottomCornerRadius:(CGFloat)cornerRadius;

@end
