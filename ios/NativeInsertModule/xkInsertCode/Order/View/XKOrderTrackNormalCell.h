/*******************************************************************************
 # File        : XKOrderTrackNormalCell.h
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

typedef NS_ENUM(NSInteger, XKOrderTrackCellLineStyle) {
    XKOrderTrackCellLineFullStyle = 0, // 全显示
    XKOrderTrackCellLineTopStyle = 1, // 显示上边
    XKOrderTrackCellLineBtmStyle = 2, // 显示下边
};

@interface XKOrderTrackNormalCell : UITableViewCell

/**<##>*/
@property(nonatomic, assign) XKOrderTrackCellLineStyle lineStyle;
/**<##>*/
@property(nonatomic, strong) NSIndexPath *indexPath;
/**<##>*/
@property(nonatomic, strong) id model;

@end
