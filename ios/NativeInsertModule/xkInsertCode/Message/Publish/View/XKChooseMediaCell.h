/*******************************************************************************
 # File        : XKChooseMediaCell.h
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

@interface XKChooseMediaCell : UICollectionViewCell

/**不带删除模式*/
@property(nonatomic, assign) BOOL withoutDelte;

@property (nonatomic, copy) void(^deleteClick)(UIButton *sender,NSIndexPath *indexPath);
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
/***/
@property(nonatomic, assign) BOOL showText;
@property(nonatomic, strong) UILabel *textLabel;
@end
