/*******************************************************************************
 # File        : XKGoodsCommentCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
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
#import "XKGoodsCommentModel.h"
@class XKMediaInfoModel;

@interface XKGoodsCommentCell : UITableViewCell
/**内容总视图*/
@property(nonatomic, strong) UIView *containView;

/**头像*/
@property(nonatomic, strong) UIImageView *headImageView;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
/**时间*/
@property(nonatomic, strong) UILabel *timeLabel;
/**评论内容*/
@property(nonatomic, strong) UILabel *desLabel;

@property(nonatomic, strong) UIButton *operationBtn;
@property(nonatomic, assign) BOOL showOperationBtn;
@property(nonatomic, copy) void(^operationBtnClick)(NSIndexPath *indexPath);

/**用户ID*/
@property (nonatomic, copy) NSString *userId;
/**cell两边距屏幕的间距*/
@property(nonatomic, assign) CGFloat cellMargin;
/**model*/
@property(nonatomic, strong) XKWithImgBaseModel *model;
/**是否折叠  0 折叠 */
@property(nonatomic, assign) BOOL imgsShowAllStatus;

/**隐藏分割线*/
@property(nonatomic, assign) BOOL hideSeperate;

/**indexPath*/
@property(nonatomic, strong) NSIndexPath *indexPath;

/**刷新block*/
@property(nonatomic, copy) void(^refreshBlock)(NSIndexPath *indexPath);
@end

@interface XKMediaInfoModel:NSObject
/**<##>*/
@property(nonatomic, copy) NSString *mainPic;
@property(nonatomic, assign) BOOL isPic;
@property(nonatomic, copy) NSString *url;
@end
