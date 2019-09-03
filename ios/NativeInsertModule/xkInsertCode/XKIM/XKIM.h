//
//  XKIM.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/5.
//  Copyright © 2018 xk. All rights reserved.
//

#ifndef XKIM_h
#define XKIM_h

#import "XKIMMessageBaseAttachment.h"
#import "XKIMMessageCustomTipAttachment.h"
#import "XKIMMessageNomalTextAttachment.h"
#import "XKIMMessageNomalImageAttachment.h"
#import "XKIMMessageAudioAttachment.h"
#import "XKIMMessageNomalVideoAttachment.h"
#import "XKIMMessageFirendCardAttachment.h"
#import "XKIMMessageShareGoodsAttachment.h"
#import "XKIMMessageShareShopAttachment.h"
#import "XKIMMessageShareLittleVideoAttachment.h"
#import "XKIMMessageLittleVideoAttachment.h"
#import "XKIMMessageShareGameAttachment.h"
#import "XKIMMessageShareWelfareAttachment.h"
#import "XKIMMessageGiftAttachment.h"
#import "XKIMMessageRedEnvelopeAttachment.h"
#import "XKIMMessageRedEnvelopeTipAttachment.h"
#import "XKIMMessageCardAttachment.h"
#import "XKIMMessageCouponAttachment.h"
#import "XKIMMessageCustomerSerOrderAttachment.h"
#import "XKIMMessageCustomerSerKnowledgeAttachment.h"
#import "XKIMMessageCustomerSerInviteEvaluateAttachment.h"
#import "XKIMMessageCustomerSerQuestionAttachment.h"
#import "XKIMMessageMusicAttachment.h"
#import "XKIMMessagePlatformGrandPrizeAttachment.h"
#import "XKIMMessageShopGrandPrizeAttachment.h"
#import "XKIMMessageNewsAttachment.h"
#import "XKIMGlobalMethod.h"
#import "XKIMMessageBaseContentView.h"


#pragma mark - 普通消息

// 文字消息
static NSUInteger const XK_NORMAL_TEXT              = 1001;
// 图片消息
static NSUInteger const XK_NORMAL_IMG               = 1002;
// 语音消息
static NSUInteger const XK_NORMAL_AUDIO             = 1003;
// 视频消息
static NSUInteger const XK_NORMAL_VIDEO             = 1004;
// 表情消息
//static NSUInteger const XK_NORMAL_FACIAL            = 1005;
// 名片消息
static NSUInteger const XK_NORMAL_BUSINESS_CARD     = 1006;
// 资讯消息
static NSUInteger const XK_NORMAL_NEWS              = 1007;
// 自定义提示消息
static NSUInteger const XK_CUSTOM_TIP               = 1008;

#pragma mark - 收藏分享类消息
// 收藏/分享-商品 样式相同,来源不同
static NSUInteger const XK_COLLECTION_GOODS         = 2001;
// 收藏/分享-店铺 样式相同,来源不同
static NSUInteger const XK_COLLECTION_SHOP          = 2002;
// 收藏-小视频
static NSUInteger const XK_COLLECTION_LITTLE_VIDEO  = 2003;
// 分享-小视频
static NSUInteger const XK_SHARE_LITTLE_VIDEO       = 2004;
// 收藏/分享-游戏 样式相同,来源不同
static NSUInteger const XK_COLLECTION_GAME          = 2005;
// 收藏-福利
static NSUInteger const XK_COLLECTION_WELFARE       = 2006;
// 音乐
static NSUInteger const XK_LIVE_BROADCAST_MUSIC     = 2007;
// 平台大奖
static NSUInteger const XK_SHARE_PLATFORM_GRAND_PRIZE = 2008;
// 店铺大奖
static NSUInteger const XK_SHARE_SHOP_GRAND_PRIZE = 2009;

#pragma mark - 赠送类消息
// 礼物消息
static NSUInteger const XK_HANDSEL_GIFT                 = 3001;
// 发红包消息
static NSUInteger const XK_HANDSEL_RED_ENVELOPE         = 3002;
// 红包提示消息
static NSUInteger const XK_HANDSEL_RED_ENVELOPE_TIP     = 3003;
// 晓可卡 商户卡
static NSUInteger const XK_HANDSEL_CARD                 = 3004;
// 晓可券 商户券
static NSUInteger const XK_HANDSEL_COUPON               = 3005;

#pragma mark - 客服消息
// 订单消息
static NSUInteger const XK_CUSTOMER_SERVICE_ORDER       = 4001;
// 客服知识点
static NSUInteger const XK_CUSTOMER_SERVICE_KNOWLEDGE   = 4002;
// 客服邀请用户评分
static NSUInteger const XK_CUSTOMER_SERVICE_INVITE_EVALUTE   = 4003;

typedef NS_ENUM(NSUInteger, XKIMType) {
  XKIMTypeNone,
  XKIMTypeSquareNormal, // 广场普通
  XKIMTypeSquareSecret, // 广场密友
  XKIMTypeSquareCustomerService, // 广场客服
  XKIMTypeMerchantNormal, // 商户普通
  XKIMTypeMerchantSecret, // 商户密友
  XKIMTypeMerchantCustomerService, // 商户客服
  XKIMTypeLiveBroadcastNormal, // 直播普通
  XKIMTypeLiveBroadcastSecret, // 直播密友
  XKIMTypeLiveBroadcastCustomerService, // 直播客服
};

#endif /* XKIM_h */
