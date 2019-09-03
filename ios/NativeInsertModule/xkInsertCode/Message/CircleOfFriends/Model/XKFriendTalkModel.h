/*******************************************************************************
 # File        : XKFriendTalkModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/8/27
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
#import "XKSquareFriendsCirclelModel.h"
@class XKFriendTalkModel;
@protocol XKFriendTalkHeightCalculatePrococol <NSObject>
+ (CGFloat)getContentHeight:(XKFriendTalkModel *)model contentAtt:(NSAttributedString **)contentAtt isNeedFold:(BOOL *)needFold totalHeight:(CGFloat *)totalHeight;
@end

typedef NS_ENUM(NSInteger,XKFriendTalkMsgType) {
    XKFriendTalkMsgNormalTextType = 0, // 普通文本
    XKFriendTalkMsgImgType = 1, // 带图片
};

@interface XKFriendTalkModel : FriendsCirclelListItem

/**图片*/
@property(nonatomic, copy) NSArray *pics;
/**消息类型*/
@property(nonatomic, assign, readonly) XKFriendTalkMsgType msgType;
/**内容是否有折叠的情况*/
@property(nonatomic, assign, readonly) BOOL contentNeedFold;
/**内容的折叠状态 0 未展开 1展开*/
@property(nonatomic, assign) BOOL contentFoldStatus;

/**供显示的说说富文本*/
- (NSAttributedString *)contentAtt;
- (NSAttributedString *)favorAtt;
- (CGFloat)favorHeight;
- (CGFloat)contentHeight;
/**单张图片的尺寸*/
@property(nonatomic, assign) CGFloat singleImgheight;
@property(nonatomic, assign) CGFloat singleImgWidth;
@end


