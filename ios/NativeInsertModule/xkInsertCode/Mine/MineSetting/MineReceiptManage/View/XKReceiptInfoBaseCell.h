/*******************************************************************************
 # File        : XKReceiptInfoBaseCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
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
#import "XKReceiptInfoViewModel.h"
#import "XKReceiptInfoModel.h"

@interface XKReceiptInfoBaseCell : UITableViewCell
/**标题*/
@property(nonatomic, strong) UILabel *titleLabel;
/**cell类型*/
@property(nonatomic, assign) XKReceiptInfoCellType cellType;
/**显示配置*/
@property(nonatomic, strong) XKReceiptInfoDataConfig *config;
/**坐标*/
@property(nonatomic, strong) NSIndexPath *indexPath;
/**model*/
@property(nonatomic, strong) XKReceiptInfoModel *model;
/**隐藏分割线*/
@property(nonatomic, assign) BOOL hideSeperate;

/**refreshBlock*/
@property(nonatomic, copy) void(^refreshBlock)(NSIndexPath *indexPath);

@end
