/*******************************************************************************
 # File        : XKBaseTableViewCell.h
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

#import <UIKit/UIKit.h>

@interface XKBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView  *bgContainView;
- (void)hiddenSeperateLine:(BOOL)hidden;


/**
 自定义UI
 */
- (void)addCustomSubviews;


/**
 自定义约束
 */
- (void)addUIConstraint;
@end
