/*******************************************************************************
 # File        : XKBaseHeadTitleDesView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/12
 # Corporation : 水木科技
 # Description :
 通用图片 标题 描述视图
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface XKBaseHeadTitleDesView : UIView
@property (nonatomic,strong) UIImageView    *imageView;
@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,strong) UILabel        *desLabel;
@property (nonatomic,strong) UILabel        *timeLabel;
@end
