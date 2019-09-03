//
//  XKIMMessageBaseAttachment.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"
#import "XKIM.h"

@implementation XKIMMessageBaseAttachment

- (instancetype)init {
  self = [super init];
  if (self) {
    self.group = 1;
  }
  return self;
}

+ (instancetype)attachmentWithDict:(NSDictionary *)dict {
  return [[self alloc] initAttachmentWithDict:dict];
}

- (instancetype)initAttachmentWithDict:(NSDictionary *)dict {
  if (dict[@"data"]) {
    self = [[self class] yy_modelWithDictionary:dict[@"data"]];
  } else {
    self = [[[self class] alloc] init];
  }
  if (self) {
    self.type = [dict[@"type"] integerValue];
    self.group = [dict[@"group"] integerValue];
    self.fireStatus = [dict[@"fireStatus"] integerValue];
    self.extraType = [dict[@"extraType"] integerValue];
    self.msgContent = dict[@"data"][@"msgContent"];
  }
  return self;
}

- (NSDictionary *)getEncodeDataDic {
  NSMutableDictionary *tempDic = [[NSJSONSerialization JSONObjectWithData:[self yy_modelToJSONData] options:NSJSONReadingMutableContainers error:nil] mutableCopy];
  [tempDic removeObjectForKey:@"type"];
  [tempDic removeObjectForKey:@"group"];
  [tempDic removeObjectForKey:@"fireStatus"];
  [tempDic removeObjectForKey:@"extraType"];
  tempDic[@"msgContent"] = [self getAttachmentMsgContent];
  
  return [tempDic copy];
}

#pragma mark - NIMCustomAttachment

- (NSString *)encodeAttachment {
  
  // 编码时，编码成以下格式
  //    @{
  //      @"type"       : @"XXX",
  //      @"group"      : @"XXX",
  //      @"fireStatus" : @"XXX",
  //      @"xxxxxxxxxx" : @"XXX",
  //      @"data"       : @{
  //                        @"msgContent" : @"XXX",
  //                        @"key"        : @"value",
  //                        },
  //      }
  
  NSMutableDictionary *theDic = [NSMutableDictionary dictionary];
  // 添加type键值，便于后续消息类型判断
  theDic[@"type"] =  @(self.type);
  theDic[@"group"] = @(self.group ? self.group : 1);
  theDic[@"fireStatus"] = @(self.fireStatus);
  theDic[@"extraType"] = @(self.extraType);
  // 添加特有部分数据
  theDic[@"data"] = [self getEncodeDataDic];
  
  return [theDic yy_modelToJSONString];
}

#pragma mark - getter

- (NSUInteger)type {
  
  // 客服邀请用户评分
  if ([self isKindOfClass:[XKIMMessageCustomTipAttachment class]]) {
    return XK_CUSTOM_TIP;
  }
  
  // 文本
  if ([self isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
    return XK_NORMAL_TEXT;
  }
  
  // 图片
  if ([self isKindOfClass:[XKIMMessageNomalImageAttachment class]]) {
    return XK_NORMAL_IMG;
  }
  
  // 语音
  if ([self isKindOfClass:[XKIMMessageAudioAttachment class]]) {
    return XK_NORMAL_AUDIO;
  }
  
  // 视频
  if ([self isKindOfClass:[XKIMMessageNomalVideoAttachment class]]) {
    return XK_NORMAL_VIDEO;
  }
  
  // 表情
  //    if ([self isKindOfClass:NSClassFromString(@"")]) {
  //        return XK_NORMAL_FACIAL;
  //    }
  
  // 名片
  if ([self isKindOfClass:[XKIMMessageFirendCardAttachment class]]) {
    return XK_NORMAL_BUSINESS_CARD;
  }
  
  // 资讯
  //    if ([self isKindOfClass:NSClassFromString(@"")]) {
  //        return XK_NORMAL_NEWS;
  //    }
  
  // 收藏/分享的商品
  if ([self isKindOfClass:[XKIMMessageShareGoodsAttachment class]]) {
    return XK_COLLECTION_GOODS;
  }
  
  // 收藏/分享的店铺
  if ([self isKindOfClass:[XKIMMessageShareShopAttachment class]]) {
    return XK_COLLECTION_SHOP;
  }
  
  // 收藏的小视频
  if ([self isKindOfClass:[XKIMMessageShareLittleVideoAttachment class]]) {
    return XK_COLLECTION_LITTLE_VIDEO;
  }
  
  // 分享的小视频
  if ([self isKindOfClass:[XKIMMessageLittleVideoAttachment class]]) {
    return XK_SHARE_LITTLE_VIDEO;
  }
  
  // 收藏/分享的游戏
  if ([self isKindOfClass:[XKIMMessageShareGameAttachment class]]) {
    return XK_COLLECTION_GAME;
  }
  
  // 收藏的福利
  if ([self isKindOfClass:[XKIMMessageShareWelfareAttachment class]]) {
    return XK_COLLECTION_WELFARE;
  }
  
  // 分享的福利
  //    if ([self isKindOfClass:NSClassFromString(@"")]) {
  //        return XK_SHARE_WELFARE;
  //    }
  
  // 礼物
  if ([self isKindOfClass:[XKIMMessageGiftAttachment class]]) {
    return XK_HANDSEL_GIFT;
  }
  
  // 红包
  if ([self isKindOfClass:[XKIMMessageRedEnvelopeAttachment class]]) {
    return XK_HANDSEL_RED_ENVELOPE;
  }
  
  // 收藏的小视频
  if ([self isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
    return XK_HANDSEL_RED_ENVELOPE_TIP;
  }
  
  // 晓可卡 商户卡
  if ([self isKindOfClass:[XKIMMessageCardAttachment class]]) {
    return XK_HANDSEL_CARD;
  }
  
  // 晓可券 商户券
  if ([self isKindOfClass:[XKIMMessageCouponAttachment class]]) {
    return XK_HANDSEL_COUPON;
  }
  
  // 客服订单
  if ([self isKindOfClass:[XKIMMessageCustomerSerOrderAttachment class]]) {
    return XK_CUSTOMER_SERVICE_ORDER;
  }
  
  // 客服知识点
  if ([self isKindOfClass:[XKIMMessageCustomerSerKnowledgeAttachment class]]) {
    return XK_CUSTOMER_SERVICE_KNOWLEDGE;
  }
  
  // 客服邀请用户评分
  if ([self isKindOfClass:[XKIMMessageCustomerSerInviteEvaluateAttachment class]]) {
    return XK_CUSTOMER_SERVICE_INVITE_EVALUTE;
  }
  
  // 音乐
  if ([self isKindOfClass:[XKIMMessageMusicAttachment class]]) {
    return XK_LIVE_BROADCAST_MUSIC;
  }
  
  return 0;
}

- (NSString *)getAttachmentMsgContent {
  
  // 客服邀请用户评分
  if ([self isKindOfClass:[XKIMMessageCustomTipAttachment class]]) {
    return self.msgContent;
  }
  
  // 文本
  if ([self isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
    return self.msgContent;
  }
  
  // 图片
  if ([self isKindOfClass:[XKIMMessageNomalImageAttachment class]]) {
    return @"[图片]";
  }
  
  // 语音
  if ([self isKindOfClass:[XKIMMessageAudioAttachment class]]) {
    return @"[语音]";
  }
  
  // 视频
  if ([self isKindOfClass:[XKIMMessageNomalVideoAttachment class]]) {
    return @"[视频]";
  }
  
  // 表情
  //    if ([self isKindOfClass:NSClassFromString(@"")]) {
  //        return @"[表情]";
  //    }
  
  // 名片
  if ([self isKindOfClass:[XKIMMessageFirendCardAttachment class]]) {
    return @"[名片]";
  }
  
  // 资讯
  //    if ([self isKindOfClass:NSClassFromString(@"")]) {
  //        return @"[资讯]";
  //    }
  
  // 收藏/分享的商品
  if ([self isKindOfClass:[XKIMMessageShareGoodsAttachment class]]) {
    return @"[商品]";
  }
  
  // 收藏/分享的店铺
  if ([self isKindOfClass:[XKIMMessageShareShopAttachment class]]) {
    return @"[店铺]";
  }
  
  // 收藏的小视频
  if ([self isKindOfClass:[XKIMMessageShareLittleVideoAttachment class]]) {
    return @"[小视频]";
  }
  
  // 分享的小视频
  if ([self isKindOfClass:[XKIMMessageLittleVideoAttachment class]]) {
    return @"[小视频]";
  }
  
  // 收藏/分享的游戏
  if ([self isKindOfClass:[XKIMMessageShareGameAttachment class]]) {
    return @"[游戏]";
  }
  
  // 收藏的福利
  if ([self isKindOfClass:[XKIMMessageShareWelfareAttachment class]]) {
    return @"[福利]";
  }
  
  // 分享的福利
  //    if ([self isKindOfClass:NSClassFromString(@"")]) {
  //        return @"[福利]";
  //    }
  
  // 礼物
  if ([self isKindOfClass:[XKIMMessageGiftAttachment class]]) {
    return @"[礼物]";
  }
  
  // 红包
  if ([self isKindOfClass:[XKIMMessageRedEnvelopeAttachment class]]) {
    return @"[红包]";
  }
  
  // 红包提示消息
  if ([self isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
    return @"[红包]";
  }
  
  // 晓可卡 商户卡
  if ([self isKindOfClass:[XKIMMessageCardAttachment class]]) {
    XKIMMessageCardAttachment *card = (XKIMMessageCardAttachment *)self;
    if (card.cardType == 1) {
      return @"[晓可卡]";
    } else if (card.cardType == 2) {
      return @"[商户卡]";
    }
    return @"";
  }
  
  // 晓可券 商户券
  if ([self isKindOfClass:[XKIMMessageCouponAttachment class]]) {
    XKIMMessageCouponAttachment *coupon = (XKIMMessageCouponAttachment *)self;
    if (coupon.voucherType == 1) {
      return @"[晓可券]";
    } else if (coupon.voucherType == 2) {
      return @"[商户券]";
    }
    return @"";
  }
  
  // 客服订单
  if ([self isKindOfClass:[XKIMMessageCustomerSerOrderAttachment class]]) {
    return @"[订单]";
  }
  
  // 客服知识点
  if ([self isKindOfClass:[XKIMMessageCustomerSerKnowledgeAttachment class]]) {
    return self.msgContent;
  }
  
  // 客服邀请用户评分
  if ([self isKindOfClass:[XKIMMessageCustomerSerInviteEvaluateAttachment class]]) {
    return @"[邀请评分]";
  }
  
  // 音乐
  if ([self isKindOfClass:[XKIMMessageMusicAttachment class]]) {
    return @"[音乐]";
  }
  
  return @"未知类型消息";
}

@end
