/*******************************************************************************
 # File        : XKUploadMedioInfo.h
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

@interface XKUploadMediaInfo : NSObject
/**是否是加号*/
@property(nonatomic, assign) BOOL isAdd;
/**是否是图片信息*/
@property(nonatomic, assign) BOOL isVideo;
#pragma mark - 图片
/**图片img*/
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, copy) NSString *imageNetAddr;

#pragma mark - 视频相关
/**视频地址*/
@property(nonatomic, strong) NSURL *videolocalURL;

/**视频地址。。net*/
@property(nonatomic, copy) NSString *videoNetAddr;
/**视频首帧地址。。net*/
@property(nonatomic, copy) NSString *videoFirstImgNetAddr;
//上传资源
+ (void)uploadMediainfoWithModel:(XKUploadMediaInfo *)model Complete:(void(^)(NSString *error, id data))complete;
//上传资源数组
+ (void)uploadMediaWithMediaArr:(NSArray <XKUploadMediaInfo *> * )mediaArr Complete:(void(^)(NSString *error, id data))complete;
//检查上传结果
+ (BOOL)checkMediaAllUploadWithMediaArr:(NSArray <XKUploadMediaInfo *> * )mediaArr;
@end
