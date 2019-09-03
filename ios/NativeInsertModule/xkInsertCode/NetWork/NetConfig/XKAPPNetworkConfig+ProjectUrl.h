//
//  XKAPPNetworkConfig+ProjectUrl.h
//  XKSquare
//
//  Created by Jamesholy on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAPPNetworkConfig.h"

@interface XKAPPNetworkConfig (ProjectUrl)

#pragma mark ------------------------------------------登录注册
/**
 获取服务器时间戳
 */
+ (NSString *)getServerTimeUrl;
/**
 登录
 */
+ (NSString *)getLoginUrl;
/**
 注册
 */
+ (NSString *)getRegisterTimeUrl;
/**
 修改登录密码
 */
+ (NSString *)getUpdatePasswordUrl;
/**
 邀请码
 */
+ (NSString *)getUpdateReferralCodeUrl;
/**
 短信登录
 */
+ (NSString *)getLoginSmsUrl;
/**
 忘记密码
 */
+ (NSString *)getRetrievePasswordUrl;




#pragma mark ------------------------------------------短信
/**
 发送注册短信验证码
 */
+ (NSString *)getRegisterAuthCodeSendUrl;
/**
 发送登录验证码
 */
+ (NSString *)getLoginAuthCodeSendUrl;
/**
 发送重置密码短信验证码
 */
+ (NSString *)getResetPwdAuthCodeSendUrl;

/**
 发送修改手机号验证码
 */
+ (NSString *)getResetPhoneAuthCodeSendUrl;

#pragma  mark ------------------------------------------我的个人资料

/**
 绑定手机号码
 */
+ (NSString *)getXkUserBindPhoneUrl;

/**
 修改手机号码
 */
+ (NSString *)getXkUserUpdatePhoneUrl;

/**
 用户资料修改
 */
+ (NSString *)getXkUserUpdateUrl;

/**
 当前（登录）用户详情
 */
+ (NSString *)getXkUserDetailUrl;

/**
 隐私设置主页
 */
+ (NSString *)getXkPrivacySettingUrl;


/**
 允许陌生人查看我的小视频切换
 */
+ (NSString *)getXKPrivacySwitchVistVideo;


/**
 允许陌生人查看我的朋友圈切换
 */
+ (NSString *)getXKPrivacySwitchVistCircle;


/**
 银行卡列表
 */
+ (NSString *)getXKBankCardList;


/**
 添加银行卡
 */
+ (NSString *)getXKAddBankCard;



#pragma  mark ------------------------------------------地区
/**
 查询所有城市和区/县列表
 */
+ (NSString *)getCityAndDistrictListUrl;
/**
 查询区/县列表
 */
+ (NSString *)getDistrictListUrl;

/**
 查询热门列表
 */
+ (NSString *)getHotListUrl;

//查询所有的城市【前端缓存」
+ (NSString *)getCityCacheListUrl;

//查询所有的省份【前端缓存】
+ (NSString *)getProvinceCacheListUrl;

//查询所有的区/县【前端缓存】
+ (NSString *)getDistrictCacheListUrl;
#pragma  mark ------------------------------------------自营商城
/**
 查询推荐商品列表
 */
+ (NSString *)getMallRecommendGoodsListUrl;
/**
 查询icon分类
 */
+ (NSString *)getMallIconListUrl;
/**
 查询所有商品分类
 */
+ (NSString *)getMallCategoryListUrl;
/**
 查询所有商品分类
 */
+ (NSString *)getMallGoodsListUrl;
/**
 查询订单列表

 */
+ (NSString *)getMallOrderListUrl;
/**
 取消订单
 */
+ (NSString *)getMallOrderCancelUrl;
/**
确认收货
 */
+ (NSString *)getMallOrderAcceptlUrl;
/**
 取消退款
 */
+ (NSString *)getMallOrderCaccelRefundlUrl;
/**
退款理由
 */
+ (NSString *)getMallOrderRefundReasonlUrl;
/**
 退款
 */
+ (NSString *)getMallOrderRefundlUrl;
/**
 支付
 */
+ (NSString *)getMallOrderPaylUrl;
/**
 订单评论
 */
+ (NSString *)getMallOrderAddCommentUrl;
/**
 商品SKU明细
 */
+ (NSString *)getMallGoodsDetailSKUinfoUrl;
/**
 订单详情
 */
+ (NSString *)getMallOrderDetailUrl;
/**
用户上传物流信息
 */
+ (NSString *)getMallOrderUploadTransInfolUrl;
/**
退款订单详情
 */
+ (NSString *)getMallOrderRefundDetailUrl;
/**
购物车
 */
+ (NSString *)getMallBuyCarListUrl;
/**
 //购物车优惠券列表
 */
+ (NSString *)getMallBuyCarTicketListUrl;
/**
 领取购物车优惠券
 */
 + (NSString *)getMallBuyCarDrawTicketUrl;
/**
 计算购物车费用
 */
+ (NSString *)getMallBuyCarFeeUrl;
/**
 获取订单可以使用的优惠券列表
 */
+ (NSString *)getMallBuyCarOrderTicketUrl;
/**
 下单
 */
+ (NSString *)getOrderMallBuyCarUrl;
/**
 购物车删除
 */
+ (NSString *)getMallBuyCarDeleteUrl;
/**
 购物车收藏
 */
+ (NSString *)getMallBuyCarCollectUrl;

#pragma  mark ------------------------------------------福利商城
/**
 查询所有商品分类
 */
+ (NSString *)getWelfareCategoryListUrl;
/**
 查询icon分类
 */
+ (NSString *)getWelfareIconListUrl;
/**
 查询推荐商品列表
 */
+ (NSString *)getWelfareRecommendGoodsListUrl;
/**
查询商品平台列表
 */
+ (NSString *)getWelfarePlatformGoodsListUrl;
/**
 查询商品列表
 */
+ (NSString *)getWelfareGoodsListUrl;
/**
 查询订单列表
 */
+ (NSString *)getWelfareOrderListUrl;

/**
 购物车列表
 */
+ (NSString *)getWelfareBuyCarListUrl;
/**
 //购物车列表删除
 */
+ (NSString *)getWelfareBuyCarDeleteUrl;
/**
 //购物车列表收藏
 */
+ (NSString *)getWelfareBuyCarCollectionUrl;
/**
 购物车—批量修改数量
 */
+ (NSString *)getWelfareBuyCarChangeNumbernUrl;
/**
 订单详情
 */
+ (NSString *)getWelfareOrderDetailUrl;

/**
 查询订单售后列表
 */
+ (NSString *)getMallOrderAfterSaleListUrl;
/**
 已中奖详情
 */
+ (NSString *)getWelfareOrderWinDetailUrl;
/**
 订单收货
 */
+ (NSString *)getWelfareOrderAcceptUrl;
/**
 订单分享
 */
+ (NSString *)getWelfareOrderShareUrl;
/**
 退货
 */
+ (NSString *)getWelfareGoodsChangeUrl;
/**
 订单退货详情
 */
+ (NSString *)getWelfareGoodsChangeDetailUrl;
/**
 往期中奖记录
 */
+ (NSString *)getPastAwardRecordsUrl;


#pragma  mark ------------------------------------------商品详情

/**
 收藏商品
 */
+ (NSString *)getGoodsDetailCollectionUrl;
/**
 取消收藏商品
 */
+ (NSString *)getGoodsDetailCancelCollectionUrl;


#pragma  mark ------------------------------------------广场首页-------------------------------


// App版本更新
+ (NSString *)getAppVersionCheckUrl;

// 首页优惠券列表
+ (NSString *)getSquareCardCouponListUrl;

//轮播图
+ (NSString *)getSquareBannerUrl;

//home工具栏
+ (NSString *)getSquareHomeToolUrl;

//抽奖信息
+ (NSString *)getSqureRewardUrl;

//商城的商品推荐
+ (NSString *)getSquareStoreRecommendUrl;

//商家推荐
+ (NSString *)getSquareMerchantRecommendUrl;

//广场资讯
+ (NSString *)getSquareConsultUrl;

//朋友圈推荐
+ (NSString *)getSquareFriendsCircleRecommendUrl;

//朋友圈点赞
+ (NSString *)getSquareFriendsCircleLikeUrl;

//获取推荐小视频
+ (NSString *)getSquareVideoRecommendUrl;

//获取推荐游戏
+ (NSString *)getSquareGamesRecommendUrl;

// 中奖公告
+ (NSString *)getWinningAnnouncementUrl;

// 抽奖规则
+ (NSString *)getWelfareActivityRulesUrl;

#pragma  mark ----------------------------------------- 商 圈 -------------------------------

//获取商圈商品或者商店评价列表
+ (NSString *)getTradingAreaGoodsOrShopCommentListUrl;

//获取商圈商品评价标签
+ (NSString *)getTradingAreaGoodsCommentLabelsUrl;

//获取商圈商店评价标签
+ (NSString *)getTradingAreaShopsCommentLabelsUrl;


//商圈商品评论数及平均数
+ (NSString *)getTradingAreaGoodsGradeUrl;

//商圈商店评论数及平均数
+ (NSString *)getTradingAreaShopGradeUrl;

//获取商圈商店详情
+ (NSString *)getTradingAreaShopDetailUrl;

//获取收藏状态
+ (NSString *)getXKFavoriteStatusUrl;

//收藏
+ (NSString *)getXKFavoriteUrl;

//取消收藏
+ (NSString *)getXKCancelFavoriteUrl;

//获取商圈行业分类
+ (NSString *)getTradingAreaIndustryCategaryListlUrl;

//获取商圈商店列表
+ (NSString *)getTradingAreaShopListlUrl;

//获取商圈商品详情
+ (NSString *)getTradingAreaGoodsDetailUrl;

//商品反馈
+ (NSString *)getGoodsOpinionUrl;

//订单物流
+ (NSString *)getOrderTransportUrl;

//获取商圈商家自定义的商品二级分类
+ (NSString *)getTradingAreaGoodsCoustomCategaryListUrl;

//根据商家自定义的商品二级分类获取商品
+ (NSString *)getTradingAreaCategaryGoodsListUrl;


//获取商家优惠券列表
+ (NSString *)getTradingAreaShopCouponListUrl;

//获取商家会员卡列表
+ (NSString *)getTradingAreaShopMemberListUrl;

//获取商家抽奖卡列表
+ (NSString *)getTradingAreaShopRewardListUrl;

//领取商家优惠券
+ (NSString *)getTradingAreaShopCouponUserDraw;

//领取商家会员卡
+ (NSString *)getTradingAreaShopMemberUserDraw;

//领取商家抽奖卡
+ (NSString *)getTradingAreaShopRewardUserDraw;

//获取席位分类列表
+ (NSString *)getTradingAreaSeatCategaryList;

//获取不同分类席位列表
+ (NSString *)getTradingAreaSeatList;

//验证席位
+ (NSString *)getTradingAreaVerifierOrderSeatUrl;

//创建订单
+ (NSString *)getTradingAreaCreatOrder;

//取消订单
+ (NSString *)getTradingAreaCancelOrder;


//取消订单(取消服务(服务包含的加购后台会对应取消))
+ (NSString *)getTradingAreaCancelServiceOrder;


//删除加购订单(针对于未接单前的订单)
+ (NSString *)getTradingAreaDeletePurchaseOrder;


//取消加购订单(针对于已接单但是未支付的订单)
+ (NSString *)getTradingAreaCancelPurchaseOrder;


//退款加购订单(针对于已支付但是未完成的订单)
+ (NSString *)getTradingAreaRefundPurchaseOrder;

//0元支付或者有退款
+ (NSString *)getTradingAreaPrePayRefundOrder;


//加购商品支付
+ (NSString *)getTradingAreaPayPurchaseGoods;


//服务商品支付
+ (NSString *)getTradingAreaPayServiceGoods;


//主单支付
+ (NSString *)getTradingAreaPayMainOrder;


//订单列表
+ (NSString *)getTradingAreaOrderListUrl;


//订单详情
+ (NSString *)getTradingAreaOrderDetailUrl;

//售后订单详情
+ (NSString *)getTradingAreaRefundOrderDetailUrl;


//订单加购
+ (NSString *)getTradingAreaOrderAddGoodsUrl;


//提醒商家我要付款
+ (NSString *)getTradingAreaTellMerchantOrderWillPay;


//获取订单支付价格
+ (NSString *)getTradingAreaOrderGetPayPriceUrl;



//获取订单优惠券
+ (NSString *)getTradingAreaGetOrderCouponsUrl;



//退款订单列表
+ (NSString *)getTradingAreaRefundOrderListUrl;


#pragma mark ------------------------------------------【我的】首页

/**
 * 获取社交模块数量
 */
+ (NSString *)getSocialContactCountUrl;

/**
 * 获取我的作品列表(BaseLiveUrl)
 */
+ (NSString *)getMyProductListUrl;

#pragma mark ------------------------------------------【我的】卡券包

/**
 * 获取会员卡及优惠券数量
 */
+ (NSString *)getCardAndCouponCountUrl;

/**
 * 获取会员卡列表
 */
+ (NSString *)getCardListUrl;

/**
 * 获取优惠券列表
 */
+ (NSString *)getCouponListUrl;

/**
 * 删除过期会员卡
 */
+ (NSString *)getDeleteCardUrl;

/**
 * 删除过期优惠券
 */
+ (NSString *)getDeleteCouponUrl;

/**
 可以领取的卡片
 */
+ (NSString *)getCardsReceiveCenterUrl;

/**
 可以领取的优惠券
 */
+ (NSString *)getCouponsReceiveCenterUrl;

/**
 领取晓可卡
 */
+ (NSString *)getReceiveXKCardUrl;

/**
 领取商户卡
 */
+ (NSString *)getReceiveMerchantCardUrl;

/**
 领取晓可券
 */
+ (NSString *)getReceiveXKCouponUrl;

/**
 领取商户券
 */
+ (NSString *)getReceiveMerchantCouponUrl;

#pragma mark ------------------------------------------【我的】账号管理

/**
 * 获取密码开通状态
 */
+ (NSString *)getPaySecurityStatusUrl;

/**
 * 设置支付密码
 */
+ (NSString *)getSetPaySecurityUrl;

/**
 * 验证支付密码
 */
+ (NSString *)getPaySecurityVerifyUrl;

/**
 * 开启指纹支付
 */
+ (NSString *)getOpenFingerPayUrl;

/**
 * 关闭指纹支付
 */
+ (NSString *)getCloseFingerPayUrl;

/**
 * 开启面部识别支付
 */
+ (NSString *)getOpenFaceRecognitionUrl;

/**
 * 关闭面部识别支付
 */
+ (NSString *)getCloseFaceRecognitionUrl;

#pragma mark ------------------------------------------【我的】收货地址管理

/**
 * 获取收货地址列表
 */
+ (NSString *)getRecipientListUrl;

/**
 * 创建收货地址
 */
+ (NSString *)getCreateRecipientUrl;

/**
 * 设置默认收货地址
 */
+ (NSString *)getSetDefaultRecipientUrl;

/**
 * 修改收货地址
 */
+ (NSString *)getUpdateRecipientUrl;

/**
 * 删除收货地址
 */
+ (NSString *)getDeleteRecipientUrl;

#pragma mark ------------------------------------------【广场】小视频

/**
 * 获取直播banner
 */
+ (NSString *)getLiveBannerUrl;

/**
 * 获取推荐小视频
 */
+ (NSString *)getRecommendVideoUrl;

/**
 * 获取单个小视频
 */
+ (NSString *)getSingleVideoUrl;

/**
 * 获取同城小视频
 */
+ (NSString *)getCityVideoUrl;

/**
 获取小视频搜索处热门用户和热门话题
 */
+ (NSString *)getHotUsersAndHotTopicsUrl;

/**
 小视频搜索
 */
+ (NSString *)getSearchUrl;

/**
 小视频搜索更多用户
 */
+ (NSString *)getSearchMoreUsersUrl;

/**
 小视频搜索更多话题
 */
+ (NSString *)getSearchMoreTopicsUrl;

/**
 关注用户
 */
+ (NSString *)getFocusUserUrl;

/**
 取消关注用户
 */
+ (NSString *)getCancelFocusUserUrl;

/**
 视频点赞/取消点赞
 */
+ (NSString *)getVideoLikeUrl;

/**
 获取某个小视频的评论
 */
+ (NSString *)getAllCommentsUrl;

/**
 获取某个评论的详情
 */
+ (NSString *)getCommentDetailUrl;

/**
 获取某个评论的回复
 */
+ (NSString *)getCommentReplysUrl;

/**
 给某个小视频添加评论
 */
+ (NSString *)getAddCommentUrl;

/**
 给某个评论添加回复
 */
+ (NSString *)getAddCommentReplyUrl;

/**
 给某个评论进行点赞
 */
+ (NSString *)getLikeCommentUrl;

/**
 小视频分享成功后，分享次数+1
 */
+ (NSString *)getAddShareCountUrl;

/**
 小视频通过ID批量查询商品
 */
+ (NSString *)getVideoGoodsListUrl;


#pragma mark ------------------------------------------ IM

/**
 可友聊天礼物列表
 */
+ (NSString *)chatGiftListUrl;

/**
 送礼物
 */
+ (NSString *)sendGiftUrl;

#pragma mark ------------------------------------------ 交易

/**
 统一的收银台接口
 */
+ (NSString *)unifiedPaymentUrl;

#pragma mark ------------------------------------------ 商户APP接口

+ (NSString *)RNMerchantCustomerConsultationsUrl;

@end
