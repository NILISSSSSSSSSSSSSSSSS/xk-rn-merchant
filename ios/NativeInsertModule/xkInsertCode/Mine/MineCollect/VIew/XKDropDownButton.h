/*******************************************************************************
 # File        : XKDropDownButton.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/12
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

@interface XKDropDownButton : UIButton

@property (nonatomic, copy) NSString  *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString  *imageName;

@end
