/*******************************************************************************
 # File        : XKCommentDetailInfoCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
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
#import "XKGoodsView.h"

@class XKMediaInfo;

@interface XKCommentDetailInfoCell : UITableViewCell
/**头像*/
@property(nonatomic, strong) UIImageView *headImageView;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
/**时间*/
@property(nonatomic, strong) UILabel *timeLabel;
/**评论内容*/
@property(nonatomic, strong) UILabel *desLabel;
/**商家回复*/
@property(nonatomic, copy) NSString *shopComment;
/**分数*/
@property(nonatomic, copy) NSString *score;
/***/
@property(nonatomic, copy) NSArray <XKMediaInfo *>*imgsArray;
/**物品info*/
@property(nonatomic, strong) XKGoodsView *infoView;
/**<##>*/
@property(nonatomic, strong) NSIndexPath *indexPath;

- (void)hideStar;
@end
