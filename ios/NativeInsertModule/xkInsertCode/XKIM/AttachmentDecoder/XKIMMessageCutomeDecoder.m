//
//  XKIMMessageCutomeDecoder.m
//  XKSquare
//
//  Created by william on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageCutomeDecoder.h"
#import <NIMKit.h>
#import "XKIM.h"


@interface XKIMMessageCutomeDecoder()<NIMCustomAttachmentCoding>

@end

@implementation XKIMMessageCutomeDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
  //所有的自定义消息都会走这个解码方法，如有多种自定义消息请自行做好类型判断和版本兼容。这里仅演示最简单的情况。
  id<NIMCustomAttachment> attachment;
  NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
  if (data) {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSUInteger type = [dict[@"type"] unsignedIntegerValue];
    // 问题
    if (dict[@"question"] && [dict[@"question"] integerValue] == 1) {
      if ([dict[@"questionFrom"] isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        // 以我的名义代发的消息
        XKIMMessageCustomerSerQuestionAttachment *attachment = [[XKIMMessageCustomerSerQuestionAttachment alloc] init];
        attachment.question = [NSString stringWithFormat:@"%@",dict[@"question"]];
        return attachment;
      }
    }
    
    // 处理系统通知消息
    if (type >= 10000) {
      attachment = [XKIMMessageNomalTextAttachment attachmentWithDict:dict];
      XKIMMessageNomalTextAttachment *theAttachment = (XKIMMessageNomalTextAttachment *)attachment;
      theAttachment.systemMessageType = type;
    }
    
    // 自定义文本消息
    if (type == XK_CUSTOM_TIP) {
      
      attachment = [XKIMMessageCustomTipAttachment attachmentWithDict:dict];
    }
    
    // 自定义文本消息
    if (type == XK_NORMAL_TEXT) {
      
      attachment = [XKIMMessageNomalTextAttachment attachmentWithDict:dict];
    }
    
    // 自定义图片消息
    if (type == XK_NORMAL_IMG) {
      
      attachment = [XKIMMessageNomalImageAttachment attachmentWithDict:dict];
    }
    
    // 自定义语音消息
    if (type == XK_NORMAL_AUDIO) {
      
      attachment = [XKIMMessageAudioAttachment attachmentWithDict:dict];
    }
    
    // 自定义视频消息
    if (type == XK_NORMAL_VIDEO) {
      
      attachment = [XKIMMessageNomalVideoAttachment attachmentWithDict:dict];
    }
    
    // 表情
    //        if(type == XK_NORMAL_FACIAL){
    //
    //            attachment = [XKIMMessageFirendCardAttachment attachmentWithDict:dict];
    //        }
    
    // 名片
    if(type == XK_NORMAL_BUSINESS_CARD){
      
      attachment = [XKIMMessageFirendCardAttachment attachmentWithDict:dict];
    }
    
    // 资讯
    //        if(type == XK_NORMAL_NEWS){
    //
    //            attachment = [XKIMMessageFirendCardAttachment attachmentWithDict:dict];
    //        }
    
    // 收藏/分享的商品
    if(type == XK_COLLECTION_GOODS){
      
      attachment = [XKIMMessageShareGoodsAttachment attachmentWithDict:dict];
    }
    
    // 收藏/分享的店铺
    if (type == XK_COLLECTION_SHOP) {
      
      attachment = [XKIMMessageShareShopAttachment attachmentWithDict:dict];
    }
    
    // 收藏的小视频
    if (type == XK_COLLECTION_LITTLE_VIDEO) {
      
      attachment = [XKIMMessageShareLittleVideoAttachment attachmentWithDict:dict];
    }
    
    // 分享的小视频
    if (type == XK_SHARE_LITTLE_VIDEO) {
      
      attachment = [XKIMMessageLittleVideoAttachment attachmentWithDict:dict];
    }
    
    // 收藏/分享的游戏
    if (type == XK_COLLECTION_GAME) {
      
      attachment = [XKIMMessageShareGameAttachment attachmentWithDict:dict];
    }
    
    // 收藏的福利
    if (type == XK_COLLECTION_WELFARE) {
      
      attachment = [XKIMMessageShareWelfareAttachment attachmentWithDict:dict];
    }
    
    // 分享的福利
    //        if (type == XK_SHARE_WELFARE) {
    //
    //            attachment = [XKIMMessageShareWelfareAttachment attachmentWithDict:dict];
    //        }
    
    // 礼物
    if (type == XK_HANDSEL_GIFT) {
      
      attachment = [XKIMMessageGiftAttachment attachmentWithDict:dict];
    }
    
    // 红包
    if (type == XK_HANDSEL_RED_ENVELOPE) {
      
      attachment = [XKIMMessageRedEnvelopeAttachment attachmentWithDict:dict];
    }
    
    // 红包提示消息
    if (type == XK_HANDSEL_RED_ENVELOPE_TIP) {
      
      attachment = [XKIMMessageRedEnvelopeTipAttachment attachmentWithDict:dict];
    }
    
    // 晓可卡 商户卡
    if (type == XK_HANDSEL_CARD) {
      
      attachment = [XKIMMessageCardAttachment attachmentWithDict:dict];
    }
    
    // 晓可券 商户券
    if (type == XK_HANDSEL_COUPON) {
      
      attachment = [XKIMMessageCouponAttachment attachmentWithDict:dict];
    }
    
    // 客服订单
    if (type == XK_CUSTOMER_SERVICE_ORDER) {
      
      attachment = [XKIMMessageCustomerSerOrderAttachment attachmentWithDict:dict];
    }
    
    // 客服知识点
    if (type == XK_CUSTOMER_SERVICE_KNOWLEDGE) {
      
      attachment = [XKIMMessageCustomerSerKnowledgeAttachment attachmentWithDict:dict];
    }
    
    // 客服邀请用户评分
    if (type == XK_CUSTOMER_SERVICE_INVITE_EVALUTE) {
      
      attachment = [XKIMMessageCustomerSerInviteEvaluateAttachment attachmentWithDict:dict];
    }
    
    // 音乐
    if (type == XK_LIVE_BROADCAST_MUSIC) {
      
      attachment = [XKIMMessageMusicAttachment attachmentWithDict:dict];
    }
    
  }
  return attachment;
}
@end
