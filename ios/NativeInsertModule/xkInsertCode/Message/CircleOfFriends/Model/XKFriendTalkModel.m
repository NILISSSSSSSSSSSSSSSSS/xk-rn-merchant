/*******************************************************************************
 # File        : XKFriendTalkModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/8/27
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkModel.h"
#import "XKFriendsTalkCommonRLCell.h"
#import "XKFriendCircleHeader.h"
#import <RZColorful.h>

@interface XKFriendTalkModel() {
  CGFloat _contentFullHeight; // 完整高度
  CGFloat _contentHeight; // 显示高度
  CGFloat _favorheight; // 点赞高度
  NSAttributedString *_contentAtt;
  NSAttributedString *_favorAtt;
}
/**内容是否需要折叠*/
@property(nonatomic, assign) BOOL contentNeedFold;
@end

@implementation XKFriendTalkModel

- (void)setContent:(NSString *)content {
  [super setContent:content];
  if (content.length == 0) {
    return;
  }
  
  BOOL isNeedFold = NO;
  CGFloat fullHeight = 0;
  NSAttributedString *contentAtt = nil;
  _contentHeight = [[self getCalculateClass] getContentHeight:self contentAtt:&contentAtt isNeedFold:&isNeedFold totalHeight:&fullHeight];
  _contentNeedFold = isNeedFold;
  _contentFullHeight = fullHeight;
  _contentAtt = contentAtt;
  _contentNeedFold = isNeedFold;
}

- (Class<XKFriendTalkHeightCalculatePrococol>)getCalculateClass {
  return [XKFriendsTalkCommonRLCell class];
}

- (NSArray *)pics {
  if (!_pics) {
    if ([self.detailType isEqualToString:@"picture"]) {
      NSMutableArray *arr = @[].mutableCopy;
      for (FriendsCirclelPictureContentsItem *item in self.pictureContents) {
        if (item.url) {
          [arr addObject:item.url];
        } else {
          [arr addObject:@""];
        }
      };
      _pics = arr.copy;
    } else if ([self.detailType isEqualToString:@"video"]) {
      NSMutableArray *arr = @[].mutableCopy;
      for (FriendsCirclelVideoContentsItem *item in self.videoContents) {
        if (item.url) {
          [arr addObject:item.showPic];
        } else {
          [arr addObject:@""];
        }
      };
      _pics = arr.copy;
    } else {
      _pics = @[];
    }
  }
  return _pics;
}

- (void)setLikes:(NSArray<FriendsCirclelLikesItem *> *)likes{
  [super setLikes:likes];
  if (likes.count == 0) {
    return;
  }
  NSAttributedString *att;
  _favorheight = [XKFriendsTalkCommonRLCell getFavorHeight:self favorAttStr:&att];
  _favorAtt = att;
}

- (NSAttributedString *)contentAtt {
  return _contentAtt;
}

- (NSAttributedString *)favorAtt {
  return _favorAtt;
}

- (XKFriendTalkMsgType)msgType {
  if (self.pics.count != 0) {
    return XKFriendTalkMsgImgType;
  } else {
    return XKFriendTalkMsgNormalTextType;
  }
}

- (CGFloat)contentHeight {
  if (self.contentNeedFold) {
    if (self.contentFoldStatus) {
      return _contentFullHeight;
    } else {
      return _contentHeight;
    }
  } else {
    return _contentHeight;
  }
}

- (CGFloat)favorHeight {
  if (self.likes.count == 0) {
    return 0;
  }
  return _favorheight;
}

@end
