/*******************************************************************************
 # File        : XKCommentVideoInfo.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/27
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommentBaseInfo.h"
@class XKVideoInfo;
@interface XKCommentForVideoModel : XKCommentBaseInfo

@property (nonatomic , strong) XKVideoInfo              * shortVideo;
@end



@class XKVideoUplolder;
@interface XKVideoInfo:NSObject <YYModel>
@property (nonatomic , copy) NSString              * describe;
@property (nonatomic , copy) NSString              * videoId;
@property (nonatomic , copy) NSString              * showPic;
@property (nonatomic , strong) XKVideoUplolder     * uploader;

@end

@interface XKVideoUplolder:NSObject
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * nickName;

@end


