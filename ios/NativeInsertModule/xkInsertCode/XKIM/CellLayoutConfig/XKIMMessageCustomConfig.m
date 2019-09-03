//
//  XKIMMessageCustomConfig.m
//  XKSquare
//
//  Created by william on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageCustomConfig.h"
#import "XKIM.h"
#import "XKTransformHelper.h"
#import "NIMKitInfoFetchOption.h"
#import "M80AttributedLabel+XKIM.h"
#import "XKIMMessageNomalTextContentView.h"
#import "XKIMMessageCustomerSerKnowledgeContentView.h"

@interface XKIMMessageCustomConfig()

@property (nonatomic, strong) M80AttributedLabel *normalTextLab;

@property (nonatomic, strong) UILabel *knowledgePointLab;

@end

@implementation XKIMMessageCustomConfig
- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)width{
  //填入内容大小
  if ([self isSupportedCustomModel:model] ) {
    
    // 自定义提示消息
    if ([self getCustomeType:model] == XK_CUSTOM_TIP) {
      NIMCustomObject *object = model.message.messageObject;
      XKIMMessageCustomTipAttachment *attachment = object.attachment;
      
      YYLabel *tempLab = [[YYLabel alloc] init];
      tempLab.numberOfLines = 0;
      tempLab.attributedText = [attachment tipStr];
      YYTextContainer *container = [YYTextContainer new];
      container.size = CGSizeMake(SCREEN_WIDTH - [NIMKit sharedKit].config.maxNotificationTipPadding * 2.0 - 12.0 * ScreenScale * 2, CGFLOAT_MAX);
      container.linePositionModifier = tempLab.linePositionModifier;
      container.insets = tempLab.textContainerInset;
      container.maximumNumberOfRows = tempLab.numberOfLines;
      
      //创建layout
      YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:tempLab.attributedText];
      return CGSizeMake(width, layout.textBoundingSize.height + 12.0 * ScreenScale);
    }
    
    // 自定义文本消息
    if ([self getCustomeType:model] == XK_NORMAL_TEXT) {
      NIMCustomObject *object = model.message.messageObject;
      XKIMMessageNomalTextAttachment *attachment = object.attachment;
      
      [self.normalTextLab xkim_setText:attachment.msgContent];
      CGFloat msgBubbleMaxWidth = (width - 130);
      CGFloat bubbleLeftToContent  = 14;
      CGFloat contentRightToBubble = 14;
      CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
      CGSize returnSize = [self.normalTextLab sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
      return CGSizeMake(returnSize.width + 20 * ScreenScale, returnSize.height + 20 * ScreenScale);
    }
    
    // 自定义图片消息
    if ([self getCustomeType:model] == XK_NORMAL_IMG) {
      NIMCustomObject *object = model.message.messageObject;
      XKIMMessageNomalImageAttachment *attachment = object.attachment;
      
      if (attachment.imgWidth.doubleValue != 0.0) {
        return CGSizeMake(180.0, 180.0 / attachment.imgWidth.doubleValue * attachment.imgHeight.doubleValue);
      } else {
        return CGSizeMake(180.0, 180.0 / 9.0 * 16.0);
      }
    }
    
    // 自定义语音
    if ([self getCustomeType:model] == XK_NORMAL_AUDIO) {
      NIMCustomObject *object = model.message.messageObject;
      XKIMMessageAudioAttachment *attachment = object.attachment;
      NSInteger dur = attachment.voiceTime / 1000;
      
      CGFloat width = 60 + 200 * ScreenScale * (dur / 60.0);
      return CGSizeMake(width + 20, 50);
    }
    
    // 自定义视频
    if ([self getCustomeType:model] == XK_NORMAL_VIDEO) {
      return CGSizeMake(140 * ScreenScale, 240 * ScreenScale);
    }
    
    // 表情
//        if ([self getCustomeType:model] == XK_NORMAL_FACIAL) {
//
//        }
    
    // 名片
    if ([self getCustomeType:model] == XK_NORMAL_BUSINESS_CARD) {
      return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
    }
    
    // 资讯
//        if ([self getCustomeType:model] == XK_NORMAL_NEWS) {
//
//        }
    
    // 收藏/分享的商品
    if ([self getCustomeType:model] == XK_COLLECTION_GOODS) {
      return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
    }
    
    // 收藏/分享的店铺
    if ([self getCustomeType:model] == XK_COLLECTION_SHOP) {
      return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
    }
    
    // 收藏的小视频
    if ([self getCustomeType:model] == XK_COLLECTION_LITTLE_VIDEO) {
      return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
    }
    
    // 分享的小视频
    if ([self getCustomeType:model] == XK_SHARE_LITTLE_VIDEO) {
      return CGSizeMake(140 * ScreenScale, 240 * ScreenScale);
    }
    
    // 收藏/分享的游戏
    if ([self getCustomeType:model] == XK_COLLECTION_GAME) {
      return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
    }
    
    // 收藏的福利
    if ([self getCustomeType:model] == XK_COLLECTION_WELFARE) {
      return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
    }
    
    // 分享的福利
//        if ([self getCustomeType:model] == XK_SHARE_WELFARE) {
//            return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
//        }
    
    // 礼物
    if ([self getCustomeType:model] == XK_HANDSEL_GIFT) {
      return CGSizeMake(100.0 * ScreenScale, 50.0 * ScreenScale);
    }
    
    // 红包
    if ([self getCustomeType:model] == XK_HANDSEL_RED_ENVELOPE) {
      return CGSizeMake(126 * ScreenScale, 180 * ScreenScale);
    }
    
    // 红包提示消息
    if ([self getCustomeType:model] == XK_HANDSEL_RED_ENVELOPE_TIP) {
      NIMCustomObject *object = model.message.messageObject;
      XKIMMessageRedEnvelopeTipAttachment *attachment = object.attachment;
      
      YYLabel *tempLab = [[YYLabel alloc] init];
      tempLab.numberOfLines = 0;
      tempLab.attributedText = [attachment tipStr];
      YYTextContainer *container = [YYTextContainer new];
      container.size = CGSizeMake(SCREEN_WIDTH - [NIMKit sharedKit].config.maxNotificationTipPadding * 2.0 - 12.0 * ScreenScale * 2, CGFLOAT_MAX);
      container.linePositionModifier = tempLab.linePositionModifier;
      container.insets = tempLab.textContainerInset;
      container.maximumNumberOfRows = tempLab.numberOfLines;
      
      //创建layout
      YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:tempLab.attributedText];
      return CGSizeMake(width, layout.textBoundingSize.height + 12.0 * ScreenScale);
    }
    
    // 晓可卡 商户卡
    if ([self getCustomeType:model] == XK_HANDSEL_CARD) {
      return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
    }
    // 晓可券 商户券
    if ([self getCustomeType:model] == XK_HANDSEL_COUPON) {
      return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
    }
    
    // 客服订单
    if ([self getCustomeType:model] == XK_CUSTOMER_SERVICE_ORDER) {
      return CGSizeMake(248 * ScreenScale, 66 * ScreenScale);
    }
    
    // 客服知识点
    if ([self getCustomeType:model] == XK_CUSTOMER_SERVICE_KNOWLEDGE) {
      NIMCustomObject *object = model.message.messageObject;
      XKIMMessageCustomerSerKnowledgeAttachment *attachment = object.attachment;
      
      self.knowledgePointLab.text = attachment.msgContent;
      CGFloat msgBubbleMaxWidth    = (width - 130);
      CGFloat bubbleLeftToContent  = 14;
      CGFloat contentRightToBubble = 14;
      CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
      CGSize returnSize = [self.knowledgePointLab sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
      return CGSizeMake(returnSize.width + 20 * ScreenScale, returnSize.height + 20 * ScreenScale);
    }
    
    // 客服邀请用户评分
    if ([self getCustomeType:model] == XK_CUSTOMER_SERVICE_INVITE_EVALUTE) {
      
      [self.normalTextLab xkim_setText:@"邀请评分"];
      CGFloat msgBubbleMaxWidth = (width - 130);
      CGFloat bubbleLeftToContent  = 14;
      CGFloat contentRightToBubble = 14;
      CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
      CGSize returnSize = [self.normalTextLab sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
      return CGSizeMake(returnSize.width + 20 * ScreenScale, returnSize.height + 20 * ScreenScale);
    }
    
    // 音乐
    if ([self getCustomeType:model] == XK_LIVE_BROADCAST_MUSIC) {
      return CGSizeMake(245 * ScreenScale, 100 * ScreenScale);
    }
  }
  //如果不是自己定义的消息，就走内置处理流程
  return [super contentSize:model
                  cellWidth:width];
}

- (NSString *)cellContent:(NIMMessageModel *)model{
  //填入contentView类型
  if ([self isSupportedCustomModel:model]) {
    
    // 自定义提示消息
    if ([self getCustomeType:model] == XK_CUSTOM_TIP) {
      return @"XKIMMessageCustomTipContentView";
    }
    
    // 自定义文本消息
    if ([self getCustomeType:model] == XK_NORMAL_TEXT) {
      return @"XKIMMessageNomalTextContentView";
    }
    
    // 自定义图片消息
    if ([self getCustomeType:model] == XK_NORMAL_IMG) {
      return @"XKIMMessageNomalImageContentView";
    }
    
    // 自定义语音消息
    if ([self getCustomeType:model] == XK_NORMAL_AUDIO) {
      return @"XKIMMessageNomalAudioContentView";
    }
    
    // 自定义视频消息
    if ([self getCustomeType:model] == XK_NORMAL_VIDEO) {
      return @"XKIMMessageNomalVideoContentView";
    }
    
    // 表情
//        if ([self getCustomeType:model] == XK_NORMAL_FACIAL) {
//
//        }
    
    // 名片
    if([self getCustomeType:model] == XK_NORMAL_BUSINESS_CARD){
      return @"XKIMMessageFriendCardContentView";
    }
    
    // 资讯
//        if ([self getCustomeType:model] == XK_NORMAL_NEWS) {
//
//        }
    
    // 收藏/分享的商品
    if ([self getCustomeType:model] == XK_COLLECTION_GOODS) {
      return @"XKIMMessageShareGoodsContentView";
    }
    
    // 收藏/分享的店铺
    if ([self getCustomeType:model] == XK_COLLECTION_SHOP) {
      return @"XKIMMessageShareShopContentView";
    }
    
    // 收藏的小视频
    if ([self getCustomeType:model] == XK_COLLECTION_LITTLE_VIDEO) {
      return @"XKIMMessageShareLittleVideoContentView";
    }
    
    // 分享的小视频
    if ([self getCustomeType:model] == XK_SHARE_LITTLE_VIDEO) {
      return @"XKIMMessageLittleVideoContentView";
    }
    
    // 收藏/分享的游戏
    if ([self getCustomeType:model] == XK_COLLECTION_GAME) {
      return @"XKIMMessageShareGameContentView";
    }
    
    // 收藏的福利
    if ([self getCustomeType:model] == XK_COLLECTION_WELFARE) {
      return @"XKIMMessageShareWelfareContentView";
    }
    
    // 分享的福利
//        if ([self getCustomeType:model] == XK_SHARE_WELFARE) {
//
//        }
    
    // 礼物
    if ([self getCustomeType:model] == XK_HANDSEL_GIFT) {
      return @"XKIMMessageGiftContentView";
    }
    
    // 红包
    if ([self getCustomeType:model] == XK_HANDSEL_RED_ENVELOPE) {
      return @"XKIMMessageRedEnvelopeContentView";
    }
    
    // 红包提示
    if ([self getCustomeType:model] == XK_HANDSEL_RED_ENVELOPE_TIP) {
      return @"XKIMMessageCustomTipContentView";
    }
    
    // 晓可卡 商户卡
    if ([self getCustomeType:model] == XK_HANDSEL_CARD) {
      NIMCustomObject *obj = model.message.messageObject;
      XKIMMessageCardAttachment *card = obj.attachment;
      if (card.cardType == 1) {
        return @"XKIMMessageXKCardContentView";
      } else if (card.cardType == 2) {
        return @"XKIMMessageMerchantCardContentView";
      }
    }
    
    // 晓可券 商户券
    if ([self getCustomeType:model] == XK_HANDSEL_COUPON) {
      NIMCustomObject *obj = model.message.messageObject;
      XKIMMessageCouponAttachment *coupon = obj.attachment;
      if (coupon.voucherType == 1) {
        return @"XKIMMessageXKCouponContentView";
      } else if (coupon.voucherType == 2) {
        return @"XKIMMessageMerchantCouponContentView";
      }
    }
    
    // 客服订单
    if ([self getCustomeType:model] == XK_CUSTOMER_SERVICE_ORDER) {
      return @"XKIMMessageCustomerSerOrderContentView";
    }
    
    // 客服知识点
    if ([self getCustomeType:model] == XK_CUSTOMER_SERVICE_KNOWLEDGE) {
      return @"XKIMMessageCustomerSerKnowledgeContentView";
    }
    
    // 客服邀请用户评分
    if ([self getCustomeType:model] == XK_CUSTOMER_SERVICE_INVITE_EVALUTE) {
      return @"XKIMMessageNomalTextContentView";
    }
    
    // 音乐
    if ([self getCustomeType:model] == XK_LIVE_BROADCAST_MUSIC) {
      return @"XKIMMessageMusicContentView";
    }
  }
  //如果不是自己定义的消息，就走内置处理流程
  return [super cellContent:model];
}

- (UIEdgeInsets)contentViewInsets:(NIMMessageModel *)model{
  //填入内容距气泡的边距,选填
  if ([self isSupportedCustomModel:model]) {
    return UIEdgeInsetsMake(0, 0, 0, 0);
  }
  //如果不是自己定义的消息，就走内置处理流程
  return [super contentViewInsets:model];
}

-(BOOL)isSupportedCustomModel:(NIMMessageModel *)model{
  if (model.message.messageType == NIMMessageTypeCustom) {
    return YES;
  } else {
    return NO;
  }
}

- (BOOL)shouldShowAvatar:(NIMMessageModel *)model {
  if ([model.message.messageObject isKindOfClass:[NIMCustomObject class]]) {
    if ([self isCustomTip:model.message] ||
        [self isRedEnvelopeTip:model.message]) {
      // 自定义提示消息 红包提示消息
      return NO;
    }
    return YES;
  }
  return NO;
}

-(BOOL)shouldShowNickName:(NIMMessageModel *)model{
  if (model.message.isOutgoingMsg ||
      [self isCustomTip:model.message] ||
      [self isRedEnvelopeTip:model.message]) {
    // 发出的消息 自定义提示消息 红包提示消息
    return NO;
  }
  if (model.message.session.sessionType == NIMSessionTypeTeam && model.message.messageType == NIMMessageTypeCustom) {
    if ([[XKDataBase instance] existsTable:XKIMTeamChatShowNickNameBaseTable]) {
      NSString *jsonString = [[XKDataBase instance] select:XKIMTeamChatShowNickNameBaseTable key:[XKUserInfo getCurrentUserId]];
      NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
      if (idArr && idArr.count > 0 && [idArr containsObject:model.message.session.sessionId]) {
        return YES;
      } else {
        return NO;
      }
    } else {
      return NO;
    }
  } else {
    return NO;
  }
}
#pragma mark - Private

-(NSInteger)getCustomeType:(NIMMessageModel *)model{
  if ([model.message.messageObject isKindOfClass:[NIMCustomObject class]]) {
    NIMCustomObject *obj = model.message.messageObject;
    if ([obj.attachment isKindOfClass:[XKIMMessageBaseAttachment class]]) {
      XKIMMessageBaseAttachment *attachment = obj.attachment;
      return attachment.type;
    }
  }
  return 0;
}

- (M80AttributedLabel *)normalTextLab {
  if (!_normalTextLab) {
    XKIMMessageNomalTextContentView *textContentView = [[XKIMMessageNomalTextContentView alloc] init];
    _normalTextLab = textContentView.textLabel;
  }
  return _normalTextLab;
}

- (UILabel *)knowledgePointLab {
  if (!_knowledgePointLab) {
    XKIMMessageCustomerSerKnowledgeContentView *knowledgePointContentView = [[XKIMMessageCustomerSerKnowledgeContentView alloc] init];
    _knowledgePointLab = knowledgePointContentView.textLabel;
  }
  return _knowledgePointLab;
}

-(CGPoint)avatarMargin:(NIMMessageModel *)model {
  return CGPointMake(10 * ScreenScale, 2);
}

- (BOOL)isRedEnvelopeTip:(NIMMessage *)message {
  if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
    NIMCustomObject *object = message.messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
      return YES;
    }
  }
  return NO;
}

- (BOOL)isCustomTip:(NIMMessage *)message {
  if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
    NIMCustomObject *object = message.messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageCustomTipAttachment class]]) {
      return YES;
    }
  }
  return NO;
}

@end
