/*******************************************************************************
 # File        : XKCommonDiyHeadView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/4
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

@interface XKCommonDiyHeadView : UIView
/**标题*/
@property(nonatomic, strong, readonly) UILabel *titleLabel;
/**箭头*/
@property(nonatomic, strong, readonly) UIImageView *arrowImgView;
/**右label*/
@property(nonatomic, strong, readonly) UILabel *contentLabel;

/**分割线*/
@property(nonatomic, assign) BOOL showSeparateLine;
@end
