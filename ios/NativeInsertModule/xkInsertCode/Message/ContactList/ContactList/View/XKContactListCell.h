/*******************************************************************************
 # File        : XKContactListCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/10
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
#import "XKContactModel.h"
#import "XKBaseTableViewCell.h"
@interface XKContactListCell : UITableViewCell
@property(nonatomic, strong, readonly) UIView *myContentView;
/**图片*/
@property(nonatomic, strong, readonly) UIImageView *headerImgView;
/**名字*/
@property(nonatomic, strong, readonly) UILabel *nameLabel;
/**信息*/
@property(nonatomic, strong, readonly) UILabel *infoLabel;
/**操作按钮*/
@property(nonatomic, strong, readonly) UIButton *operationBtn;
/**选择按钮*/
@property(nonatomic, strong) UIButton *chooseBtn;
/**操作按钮点击事件*/
@property(nonatomic, copy) void(^operationClick)(NSIndexPath *indexPath, XKContactModel *model);
/**头像按钮点击事件*/
@property(nonatomic, copy) void(^headClick)(NSIndexPath *indexPath, XKContactModel *model);

/**indxPath*/
@property(nonatomic, strong) NSIndexPath *indexPath;
/**model*/
@property(nonatomic, strong) XKContactModel *model;
/**隐藏分割线*/
@property(nonatomic, assign) BOOL hideSeperate;
/**是否显示选择按钮*/
@property(nonatomic, assign) BOOL showChooseBtn;
@end
