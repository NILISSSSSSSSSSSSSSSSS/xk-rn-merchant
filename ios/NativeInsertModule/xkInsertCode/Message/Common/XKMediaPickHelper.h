/*******************************************************************************
 # File        : XKMediaPickHelper.h
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

#import <Foundation/Foundation.h>

@interface XKMediaPickHelper : NSObject
/** 选中图片回调*/
@property (nonatomic, copy)void(^choseImageBlcok)(NSArray<UIImage *> * _Nullable images);
/** 选中视频回调*/
@property (nonatomic, copy)void(^choseVideoPathBlcok)(NSURL *videoURL , UIImage *coverImg);
/**照片数量限制*/
@property (nonatomic, assign)NSInteger maxCount;
/**视频拍摄最大时长*/
@property(nonatomic, assign) NSInteger videoMaxSecond;
/**视频最大MB*/
@property(nonatomic, assign) float videoMaxSize;
/**是否能拍摄或选择视频*/
@property(nonatomic, assign) BOOL canSelectVideo;
/**
 判断是否有相机功能
 */
+ (BOOL)isCameraAvailable;

- (void)showView;
@end
