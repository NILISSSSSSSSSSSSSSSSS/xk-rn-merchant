/*******************************************************************************
 # File        : XKGoodsView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
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

@interface XKGoodsView : UIView
/**图片*/
@property(nonatomic, strong, readonly) UIImageView *imgView;
/**商品名字*/
@property(nonatomic, strong, readonly) UILabel *nameLabel;
/**规格*/
@property(nonatomic, strong, readonly) UILabel *infoLabel;

/**是否显示播放按钮*/
@property(nonatomic, assign) BOOL showSmallImg;
@end
