//
//  UrlHeader.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#ifndef UrlHeader_h
#define UrlHeader_h
#import "XKAPPNetworkConfig.h"
#import "XKAPPNetworkConfig+ProjectUrl.h"
//*********************************** 服务器切换在APPNetworkConfig.m中*********************************************

#define BaseUrl                              [XKAPPNetworkConfig getDynamicMainBaseUrl]
#define BaseWebUrl                           [XKAPPNetworkConfig getDynamicWebBaseUrl]
#define BaseLiveUrl                          [XKAPPNetworkConfig getDynamicLiveBaseUrl]
//获取服务器时间戳
#define GetServerTimeUrl                     [XKAPPNetworkConfig getServerTimeUrl]
#pragma mark ------------------------------------------登录注册

//登录
#define GetLoginUrl                          [XKAPPNetworkConfig getLoginUrl]
//注册
#define GetRegisterTimeUrl                   [XKAPPNetworkConfig getRegisterTimeUrl]
//修改登录密码
#define GetUpdatePasswordUrl                 [XKAPPNetworkConfig getUpdatePasswordUrl]
//填写邀请码
#define GetUpdateReferralCodeUrl             [XKAPPNetworkConfig getUpdateReferralCodeUrl]
//短信登录
#define GetLoginSmsUrl                       [XKAPPNetworkConfig getLoginSmsUrl]
//忘记密码
#define GetRetrievePasswordUrl               [XKAPPNetworkConfig getRetrievePasswordUrl]

#pragma mark ------------------------------------------短信

//发送注册短信验证码
#define GetRegisterAuthCodeSendUrl           [XKAPPNetworkConfig getRegisterAuthCodeSendUrl]
//发送登录验证码
#define GetLoginAuthCodeSendUrl              [XKAPPNetworkConfig getLoginAuthCodeSendUrl]
//发送重置密码短信验证码
#define GetResetPwdAuthCodeSendUrl           [XKAPPNetworkConfig getResetPwdAuthCodeSendUrl]
//发送修改手机号验证码
#define GetResetPhoneAuthCodeSendUrl         [XKAPPNetworkConfig getResetPhoneAuthCodeSendUrl]

#pragma  mark ------------------------------------------我的个人资料

// 绑定手机号码
#define GetXkUserBindPhoneUrl              [XKAPPNetworkConfig getXkUserBindPhoneUrl]

// 修改手机号码
#define GetXkUserUpdatePhoneUrl              [XKAPPNetworkConfig getXkUserUpdatePhoneUrl]

//用户资料修改
#define GetXkUserUpdateUrl                   [XKAPPNetworkConfig getXkUserUpdateUrl]

//当前（登录）用户详情
#define GetXkUserDetailUrl                   [XKAPPNetworkConfig getXkUserDetailUrl]

//获取隐私设置主页
#define GetXkPrivacySettingUrl               [XKAPPNetworkConfig getXkPrivacySettingUrl]

//修改允许陌生人查看我的小视频
#define GetXKPrivacySwitchVistVideo          [XKAPPNetworkConfig getXKPrivacySwitchVistVideo]

//修改允许陌生人查看我的朋友圈
#define GetXKPrivacySwitchVistCircle         [XKAPPNetworkConfig getXKPrivacySwitchVistCircle]

//银行卡列表
#define GetXKBankCardList                     [XKAPPNetworkConfig getXKBankCardList]

//添加银行卡
#define GetXKAddBankCard                      [XKAPPNetworkConfig getXKAddBankCard]

#pragma  mark ------------------------------------------地区

//查询所有城市和区/县列表
#define GetCityAndDistrictListUrl            [XKAPPNetworkConfig getCityAndDistrictListUrl]
//查询区/县列表
#define GetDistrictListUrl                   [XKAPPNetworkConfig getDistrictListUrl]
//热门列表
#define GetHotListUrl                        [XKAPPNetworkConfig getHotListUrl]
//查询所有的城市【前端缓存」
#define GetCityCacheListUrl                  [XKAPPNetworkConfig getCityCacheListUrl]
//查询所有的省份【前端缓存】
#define GetProvinceCacheListUrl              [XKAPPNetworkConfig getProvinceCacheListUrl]
//查询所有的区/县【前端缓存】
#define GetDistrictCacheListUrl              [XKAPPNetworkConfig getDistrictCacheListUrl]

#pragma  mark ------------------------------------------自营商城
//查询自营商城推荐商品列表
#define GetMallRecommendGoodsListUrl         [XKAPPNetworkConfig getMallRecommendGoodsListUrl]
//查询自营商城所有icon分类
#define GetMallIconListUrl                   [XKAPPNetworkConfig getMallIconListUrl]
//查询自营商城所有商品分类
#define GetMallCategoryListUrl               [XKAPPNetworkConfig getMallCategoryListUrl]
//查询自营商城商品列表
#define GetMallGoodsListUrl                  [XKAPPNetworkConfig getMallGoodsListUrl]
//查询自营商城订单列表
#define GetMallOrderListUrl                  [XKAPPNetworkConfig getMallOrderListUrl]
//查询自营商城售后订单列表
#define GetMallOrderAfterSaleListUrl         [XKAPPNetworkConfig getMallOrderAfterSaleListUrl]
//取消自营商城订单
#define GetMallOrderCancelUrl                [XKAPPNetworkConfig getMallOrderCancelUrl]
//确认收货自营商城订单
#define GetMallOrderAcceptlUrl                [XKAPPNetworkConfig getMallOrderAcceptlUrl]
//取消退款自营商城订单
#define GetMallOrderCaccelRefundlUrl         [XKAPPNetworkConfig getMallOrderCaccelRefundlUrl]
//自营商城订单退款理由
#define GetMallOrderRefundReasonlUrl         [XKAPPNetworkConfig getMallOrderRefundReasonlUrl]
//自营商城订单退款
#define GetMallOrderRefundlUrl               [XKAPPNetworkConfig getMallOrderRefundlUrl]
//自营商城订单支付
#define GetMallOrderPaylUrl                  [XKAPPNetworkConfig getMallOrderPaylUrl]
//自营商城订单售后上传物流信息
#define GetMallOrderUploadTransInfolUrl      [XKAPPNetworkConfig getMallOrderUploadTransInfolUrl]
//自营商城订单评论
#define GetMallOrderAddCommentUrl            [XKAPPNetworkConfig getMallOrderAddCommentUrl]
//商品反馈
#define GetGoodsOpinionUrl                   [XKAPPNetworkConfig getGoodsOpinionUrl]

//订单物流查询
#define GetOrderTransportUrl                 [XKAPPNetworkConfig getOrderTransportUrl]
//查询自营商城订单详情
#define GetMallOrderDetailUrl                [XKAPPNetworkConfig getMallOrderDetailUrl]
//查询自营商城退款订单详情
#define GetMallOrderRefundDetailUrl          [XKAPPNetworkConfig getMallOrderRefundDetailUrl]
//查询自营商城购物车列表
#define GetMallBuyCarListUrl                 [XKAPPNetworkConfig getMallBuyCarListUrl]
//查询自营商城购物车优惠券列表
#define GetMallBuyCarTicketListUrl            [XKAPPNetworkConfig getMallBuyCarTicketListUrl]
//领取自营商城购物车优惠券
#define GetMallBuyCarDrawTicketUrl            [XKAPPNetworkConfig getMallBuyCarDrawTicketUrl]
//计算自营商城购物车费用
#define GetMallBuyCarFeeUrl                   [XKAPPNetworkConfig getMallBuyCarFeeUrl]
//获取订单可以使用的优惠券列表
#define GetMallBuyCarOrderTicketUrl           [XKAPPNetworkConfig getMallBuyCarOrderTicketUrl]
//下单
#define GetOrderMallBuyCarUrl                 [XKAPPNetworkConfig getOrderMallBuyCarUrl]
//自营商城购物车删除
#define GetMallBuyCarDeleteUrl                 [XKAPPNetworkConfig getMallBuyCarDeleteUrl]
//自营商城购物车收藏
#define GetMallBuyCarCollectUrl                 [XKAPPNetworkConfig getMallBuyCarCollectUrl]
#pragma  mark ------------------------------------------福利商城

//查询福利商城所有商品分类
#define GetWelfareCategoryListUrl            [XKAPPNetworkConfig getWelfareCategoryListUrl]
//查询福利商城所有icon分类
#define GetWelfareIconListUrl                [XKAPPNetworkConfig getWelfareIconListUrl]
//查询福利推荐商城商品列表
#define GetWelfareRecommendGoodsListUrl      [XKAPPNetworkConfig getWelfareRecommendGoodsListUrl]
//查询福利商城平台大奖列表
#define GetWelfarePlatformGoodsListUrl      [XKAPPNetworkConfig getWelfarePlatformGoodsListUrl]
//查询福利商城店铺大奖列表
#define GetWelfareStoredGoodsListUrl      [XKAPPNetworkConfig getWelfareStoredGoodsListUrl]
//查询福利商城商品列表
#define GetWelfareGoodsListUrl               [XKAPPNetworkConfig getWelfareGoodsListUrl]
//查询福利商城订单列表
#define GetWelfareOrderListUrl               [XKAPPNetworkConfig getWelfareOrderListUrl]
//查询福利商城购物车列表
#define GetWelfareBuyCarListUrl               [XKAPPNetworkConfig getWelfareBuyCarListUrl]
//福利商城购物车删除
#define GetWelfareBuyCarDeleteUrl             [XKAPPNetworkConfig getWelfareBuyCarDeleteUrl]
//福利商城购物车收藏
#define GetWelfareBuyCarCollectionUrl         [XKAPPNetworkConfig getWelfareBuyCarCollectionUrl]
//福利商城购物车修改数量
#define GetWelfareBuyCarChangeNumbernUrl      [XKAPPNetworkConfig getWelfareBuyCarChangeNumbernUrl]
//查询福利商城订单详情
#define GetWelfareOrderDetailUrl              [XKAPPNetworkConfig getWelfareOrderDetailUrl]
//查询福利商城中奖详情
#define GetWelfareOrderWinDetailUrl           [XKAPPNetworkConfig getWelfareOrderWinDetailUrl]
//福利订单收货
#define GetWelfareOrderAcceptUrl                [XKAPPNetworkConfig getWelfareOrderAcceptUrl]
//福利订单分享
#define GetWelfareOrderShareUrl                [XKAPPNetworkConfig getWelfareOrderShareUrl]
//订单换货
#define GetWelfareGoodsChangeUrl                [XKAPPNetworkConfig getWelfareGoodsChangeUrl]
//订单换货详情
#define GetWelfareGoodsChangeDetailUrl          [XKAPPNetworkConfig getWelfareGoodsChangeDetailUrl]
#pragma  mark ------------------------------------------商品详情
//收藏商品
#define GetGoodsDetailCollectionUrl           [XKAPPNetworkConfig getGoodsDetailCollectionUrl]
//取消收藏商品
#define GetGoodsDetailCancelCollectionUrl     [XKAPPNetworkConfig getGoodsDetailCancelCollectionUrl]
//商品SKU明细
#define GetMallGoodsDetailSKUinfoUrl          [XKAPPNetworkConfig getMallGoodsDetailSKUinfoUrl]




#pragma  mark ------------------------------------------广场首页-------------------------------
//轮播图
#define GetSquareBannerUrl                  [XKAPPNetworkConfig getSquareBannerUrl]
//home工具栏
#define GetSquareHomeToolUrl                [XKAPPNetworkConfig getSquareHomeToolUrl]
//抽奖信息
#define GetSqureRewardUrl                   [XKAPPNetworkConfig getSqureRewardUrl]
//商城的商品推荐
#define GetSquareStoreRecommendUrl          [XKAPPNetworkConfig getSquareStoreRecommendUrl]
//商家推荐
#define GetSquareMerchantRecommendUrl       [XKAPPNetworkConfig getSquareMerchantRecommendUrl]
//广场资讯
#define GetSquareConsultUrl                 [XKAPPNetworkConfig getSquareConsultUrl]
//朋友圈推荐
#define GetSquareFriendsCircleRecommendUrl  [XKAPPNetworkConfig getSquareFriendsCircleRecommendUrl]
//朋友圈点赞
#define GetSquareFriendsCircleLikeUrl       [XKAPPNetworkConfig getSquareFriendsCircleLikeUrl]
//小视频推荐
#define GetSquareVideoRecommendUrl          [XKAPPNetworkConfig getSquareVideoRecommendUrl]
//游戏推荐
#define GetSquareGamesRecommendUrl          [XKAPPNetworkConfig getSquareGamesRecommendUrl]



#pragma  mark ----------------------------------------- 商 圈 -------------------------------

//商圈商品评论列表
#define GetTradingAreaGoodsOrShopCommentListUrl      [XKAPPNetworkConfig getTradingAreaGoodsOrShopCommentListUrl]

//商圈商品评论标签
#define GetTradingAreaGoodsCommentLabelsUrl    [XKAPPNetworkConfig getTradingAreaGoodsCommentLabelsUrl]

//商圈商店评论标签
#define GetTradingAreaShopsCommentLabelsUrl    [XKAPPNetworkConfig getTradingAreaShopsCommentLabelsUrl]

//商圈商品评论数及平均数
#define GetTradingAreaGoodsGradeUrl               [XKAPPNetworkConfig getTradingAreaGoodsGradeUrl]
//商圈商店评论数及平均数
#define GetTradingAreaShopGradeUrl                [XKAPPNetworkConfig getTradingAreaShopGradeUrl]

//商圈商店详情
#define GetTradingAreaShopDetailUrl             [XKAPPNetworkConfig getTradingAreaShopDetailUrl]

//获取收藏状态
#define GetXKFavoriteStatusUrl                   [XKAPPNetworkConfig getXKFavoriteStatusUrl]

//收藏
#define GetXKFavoriteUrl                        [XKAPPNetworkConfig getXKFavoriteUrl]

//取消收藏
#define GetXKCancelFavoriteUrl                   [XKAPPNetworkConfig getXKCancelFavoriteUrl]

//商圈行业分类
#define GetTradingAreaIndustryCategaryListlUrl  [XKAPPNetworkConfig getTradingAreaIndustryCategaryListlUrl]

//商圈商品列表
#define GetTradingAreaShopListlUrl               [XKAPPNetworkConfig getTradingAreaShopListlUrl]

//商圈商品详情
#define GetTradingAreaGoodsDetailUrl             [XKAPPNetworkConfig getTradingAreaGoodsDetailUrl]

//商圈商品详情
#define GetTradingAreaGoodsDetailUrl                [XKAPPNetworkConfig getTradingAreaGoodsDetailUrl]

//获取商圈商家自定义的商品二级分类
#define GetTradingAreaGoodsCoustomCategaryListUrl   [XKAPPNetworkConfig getTradingAreaGoodsCoustomCategaryListUrl]

//根据商家自定义的商品二级分类获取商品
#define GetTradingAreaCategaryGoodsListUrl          [XKAPPNetworkConfig getTradingAreaCategaryGoodsListUrl]


//获取商家优惠券列表
#define GetTradingAreaShopCouponListUrl            [XKAPPNetworkConfig getTradingAreaShopCouponListUrl]

//获取商家会员卡列表
#define GetTradingAreaShopMemberListUrl            [XKAPPNetworkConfig getTradingAreaShopMemberListUrl]

//获取商家抽奖卡列表
#define GetTradingAreaShopRewardListUrl            [XKAPPNetworkConfig getTradingAreaShopRewardListUrl]

//领取商家优惠券
#define GetTradingAreaShopCouponUserDraw            [XKAPPNetworkConfig getTradingAreaShopCouponUserDraw]

//领取商家会员卡
#define GetTradingAreaShopMemberUserDraw            [XKAPPNetworkConfig getTradingAreaShopMemberUserDraw]

//领取商家抽奖卡
#define GetTradingAreaShopRewardUserDraw            [XKAPPNetworkConfig getTradingAreaShopRewardUserDraw]

//获取席位分类列表
#define GetTradingAreaSeatCategaryListUrl            [XKAPPNetworkConfig getTradingAreaSeatCategaryList]

//获取不同分类席位列表
#define GetTradingAreaSeatListUrl                   [XKAPPNetworkConfig getTradingAreaSeatList]

//验证席位
#define GetTradingAreaVerifierOrderSeatUrl          [XKAPPNetworkConfig getTradingAreaVerifierOrderSeatUrl]


//创建订单
#define GetTradingAreaCreatOrder                    [XKAPPNetworkConfig getTradingAreaCreatOrder]

//取消订单
#define GetTradingAreaCancelOrder                    [XKAPPNetworkConfig getTradingAreaCancelOrder]

//取消订单(取消服务(服务包含的加购后台会对应取消))
#define GetTradingAreaCancelServiceOrder             [XKAPPNetworkConfig getTradingAreaCancelServiceOrder]

//删除加购订单(针对于未接单前的订单)
#define GetTradingAreaDeletePurchaseOrder            [XKAPPNetworkConfig getTradingAreaDeletePurchaseOrder]


//取消加购订单(针对于已接单但是未支付的订单)
#define GetTradingAreaCancelPurchaseOrder            [XKAPPNetworkConfig getTradingAreaCancelPurchaseOrder]


//退款加购订单(针对于已支付但是未完成的订单)
#define GetTradingAreaRefundPurchaseOrder            [XKAPPNetworkConfig getTradingAreaRefundPurchaseOrder]

//0元支付或者有退款
#define GetTradingAreaPrePayRefundOrder              [XKAPPNetworkConfig getTradingAreaPrePayRefundOrder]

//加购商品支付
#define GetTradingAreaPayPurchaseGoods              [XKAPPNetworkConfig getTradingAreaPayPurchaseGoods]

//服务商品支付
#define GetTradingAreaPayServiceGoods                [XKAPPNetworkConfig getTradingAreaPayServiceGoods]

//主单支付
#define GetTradingAreaPayMainOrder                   [XKAPPNetworkConfig getTradingAreaPayMainOrder]

//订单列表
#define GetTradingAreaOrderListUrl                  [XKAPPNetworkConfig getTradingAreaOrderListUrl]

//订单详情
#define GetTradingAreaOrderDetailUrl                [XKAPPNetworkConfig getTradingAreaOrderDetailUrl]

//售后中订单详情
#define GetTradingAreaRefundOrderDetailUrl          [XKAPPNetworkConfig getTradingAreaRefundOrderDetailUrl]


//订单加购
#define GetTradingAreaOrderAddGoodsUrl                [XKAPPNetworkConfig getTradingAreaOrderAddGoodsUrl]

//获取订单支付价格
#define GetTradingAreaOrderGetPayPriceUrl             [XKAPPNetworkConfig getTradingAreaOrderGetPayPriceUrl]

//提醒商家我要付款
#define GetTradingAreaTellMerchantOrderWillPay         [XKAPPNetworkConfig getTradingAreaTellMerchantOrderWillPay]

//获取订单优惠券
#define GetTradingAreaGetOrderCouponsUrl               [XKAPPNetworkConfig getTradingAreaGetOrderCouponsUrl]


//退款订单列表
#define GetTradingAreaRefundOrderListUrl            [XKAPPNetworkConfig getTradingAreaRefundOrderListUrl]


#pragma mark ------------------------------------------【我的】首页

//获取社交模块数量
#define GetSocialContactCountUrl          [XKAPPNetworkConfig getSocialContactCountUrl]

//获取社交模块数量(BaseLiveUrl)
#define GetMyProductListUrl          [XKAPPNetworkConfig getMyProductListUrl]

#pragma mark ------------------------------------------【我的】卡券包

//获取会员卡及优惠券数量
#define GetCardAndCouponCountUrl          [XKAPPNetworkConfig getCardAndCouponCountUrl]

//获取会员卡列表
#define GetCardListUrl          [XKAPPNetworkConfig getCardListUrl]

//获取优惠券列表
#define GetCouponListUrl          [XKAPPNetworkConfig getCouponListUrl]

//删除过期会员卡
#define GetDeleteCardUrl          [XKAPPNetworkConfig getDeleteCardUrl]

//删除过期优惠券
#define GetDeleteCouponUrl          [XKAPPNetworkConfig getDeleteCouponUrl]


#pragma mark ------------------------------------------【我的】账号管理

//获取密码开通状态
#define GetPaySecurityStatusUrl          [XKAPPNetworkConfig getPaySecurityStatusUrl]

//设置支付密码
#define GetSetPaySecurityUrl          [XKAPPNetworkConfig getSetPaySecurityUrl]

//验证支付密码
#define GetPaySecurityVerifyUrl          [XKAPPNetworkConfig getPaySecurityVerifyUrl]

//开启指纹支付
#define GetOpenFingerPayUrl          [XKAPPNetworkConfig getOpenFingerPayUrl]

//关闭指纹支付
#define GetCloseFingerPayUrl          [XKAPPNetworkConfig getCloseFingerPayUrl]

//开启面部识别支付
#define GetOpenFaceRecognitionUrl          [XKAPPNetworkConfig getOpenFaceRecognitionUrl]

//关闭面部识别支付
#define GetCloseFaceRecognitionUrl          [XKAPPNetworkConfig getCloseFaceRecognitionUrl]

#pragma mark ------------------------------------------【我的】收货地址管理

//获取收货地址列表
#define GetRecipientListUrl          [XKAPPNetworkConfig getRecipientListUrl]

//创建收货地址
#define GetCreateRecipientUrl          [XKAPPNetworkConfig getCreateRecipientUrl]

//设置默认收货地址
#define GetSetDefaultRecipientUrl          [XKAPPNetworkConfig getSetDefaultRecipientUrl]

//修改收货地址
#define GetUpdateRecipientUrl          [XKAPPNetworkConfig getUpdateRecipientUrl]

//删除收货地址
#define GetDeleteRecipientUrl          [XKAPPNetworkConfig getDeleteRecipientUrl]

#pragma mark ------------------------------------------【广场】小视频

//获取直播banner
#define GetLiveBannerUrl          [XKAPPNetworkConfig getLiveBannerUrl]

//获取推荐小视频
#define GetRecommendVideoUrl          [XKAPPNetworkConfig getRecommendVideoUrl]

//获取同城小视频
#define GetCityVideoUrl             [XKAPPNetworkConfig getCityVideoUrl]



#endif /* UrlHeader_h */
