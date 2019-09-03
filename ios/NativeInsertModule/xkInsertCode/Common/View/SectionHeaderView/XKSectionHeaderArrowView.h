/*******************************************************************************
 # File        : XKSectionHeaderArrowView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/8
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

@interface XKSectionHeaderArrowView : UIView
/**图片 传入代表有图*/
@property(nonatomic, strong, nullable) UIImage *leftImage;
/**标题*/
@property(nonatomic, strong, readonly) UILabel *titleLabel;
/**箭头文字*/
@property(nonatomic, strong, readonly) UILabel *detailLabel;
/**箭头*/
@property(nonatomic, strong, readonly) UIImageView *arrowImgView;

@end
