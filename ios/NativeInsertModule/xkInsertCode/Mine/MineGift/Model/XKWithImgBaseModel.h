/*******************************************************************************
 # File        : XKFriendCircleGiftModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/13
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>

@interface XKWithImgBaseModel : NSObject

/**展开收起状态*/
@property(nonatomic, assign) BOOL showAllImg;
/**图片数组*/
@property(nonatomic, copy) NSArray *imgsArray;

/**单张图片的尺寸*/
@property(nonatomic, assign) CGFloat singleImgheight;
@property(nonatomic, assign) CGFloat singleImgWidth;
@end
