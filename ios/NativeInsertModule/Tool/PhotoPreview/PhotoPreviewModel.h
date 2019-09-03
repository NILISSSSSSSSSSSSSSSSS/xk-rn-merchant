/*******************************************************************************
 # File        : PhotoPreviewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/20
 # Corporation : 水木科技
 # Description :
 浏览大图的基类 需要其他功能的时候需要继承然后定制
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

// 长按弹出选项
static NSString *const kLongPressOptionsSendFriend = @"发送给朋友";
static NSString *const kLongPressOptionsSavePhoto  = @"保存图片";

@interface PhotoPreviewModel : NSObject

/**缩略图*/
@property (nonatomic, strong) UIImage	 *thumbImage;

@property (nonatomic, copy)  NSString    *thumbPath;

@property (nonatomic, copy)  NSString    *imageURL;

@property (nonatomic, copy)  NSString    *name;

@property (nonatomic, copy)  NSString    *imageId;

- (void)originalImage:(void (^)(UIImage *))returnImage;

@property (nonatomic, strong) UIImage *assetImage;	// 相册的图片
// 需要单张图片自定义导航栏的title时，可以扩展设置的字段
@property (nonatomic, copy) NSString *customerTitle;
// 需要单张添加描述信息的扩展字段
@property (nonatomic, copy) NSString *customerDesc;

@end
