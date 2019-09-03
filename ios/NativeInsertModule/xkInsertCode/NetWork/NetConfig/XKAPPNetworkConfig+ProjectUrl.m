//
//  XKAPPNetworkConfig+ProjectUrl.m
//  XKSquare
//
//  Created by Jamesholy on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAPPNetworkConfig+ProjectUrl.h"

@implementation XKAPPNetworkConfig (ProjectUrl)
// 获取服务器时间戳
+ (NSString *)getServerTimeUrl {
    return @"user/ua/systemTime/1.0";
}
#pragma  mark ------------------------------------------登录注册-----------------------

// 登录
+ (NSString *)getLoginUrl {
    return  @"user/ua/xkUserLogin/1.0";
}

//注册
+ (NSString *)getRegisterTimeUrl {
    return @"user/ua/xkUserRegisterByPhone/1.0";
}
//修改登录密码
+ (NSString *)getUpdatePasswordUrl {
    return @"user/ua/xkUserUpdatePassword/1.0";
}
//邀请码
+ (NSString *)getUpdateReferralCodeUrl {
    return @"user/ua/xkUserUpdateReferralCode/1.0";
}
//短信登录
+ (NSString *)getLoginSmsUrl {
    return @"user/ua/xkUserLoginSms/1.0";
}
//忘记密码
+ (NSString *)getRetrievePasswordUrl {
    return @"user/ua/xkUserRetrievePassword/1.0";
}

#pragma  mark ------------------------------------------短信-----------------------

//发送注册短信验证码
+ (NSString *)getRegisterAuthCodeSendUrl {
    return @"sys/ua/sendAuthMessage/1.0";
}
//发送登录短信验证码
+ (NSString *)getLoginAuthCodeSendUrl {
    return @"sys/ua/sendAuthMessage/1.0";
}

//发送重置密码短信验证码
+ (NSString *)getResetPwdAuthCodeSendUrl {
    return @"sys/ua/sendAuthMessage/1.0";
}

/**
 发送修改手机号验证码
 */
+ (NSString *)getResetPhoneAuthCodeSendUrl{
    return @"sys/ua/sendAuthMessage/1.0";
}
#pragma  mark ------------------------------------------地区-----------------------

//查询所有城市和区/县列表
+ (NSString *)getCityAndDistrictListUrl {
    return @"sys/ua/cityAndDistrictList/1.0";
}
//查询区/县列表
+ (NSString *)getDistrictListUrl {
    return @"sys/ua/districtList/1.0";
}
//查询热门城市
+ (NSString *)getHotListUrl {
    return @"sys/ua/hostList/1.0";
}

//查询所有的城市【前端缓存」
+ (NSString *)getCityCacheListUrl {
    return @"sys/ua/regionPage/1.0";
}

//查询所有的省份【前端缓存】
+ (NSString *)getProvinceCacheListUrl {
    return @"sys/ua/regionPage/1.0";
}

//查询所有的区/县【前端缓存】
+ (NSString *)getDistrictCacheListUrl {
    return @"sys/ua/regionPage/1.0";
}

#pragma  mark ------------------------------------------我的个人资料-----------------------

/**
 绑定手机号码
 */
+ (NSString *)getXkUserBindPhoneUrl {
    return @"user/ua/xkUserBindPhone/1.0";
}

/**
 修改手机号码
 */
+ (NSString *)getXkUserUpdatePhoneUrl {
    return @"user/ua/xkUserUpdatePhone/1.0";
}

/**
 用户资料修改
 */
+ (NSString *)getXkUserUpdateUrl {
    return @"user/ua/xkUserUpdate/1.0";
}

/**
 当前（登录）用户详情
 */
+ (NSString *)getXkUserDetailUrl {
    return @"user/ua/xkUserDetail/1.0";
}

/**
 隐私设置主页
 */
+ (NSString *)getXkPrivacySettingUrl{
    return @"im/ua/friendCircleAuthDetail/1.0";
}

/**
 允许陌生人查看我的小视频切换
 */
+ (NSString *)getXKPrivacySwitchVistVideo{
    return @"im/ua/strangerVisitVideoSwitch/1.0";
}


/**
 允许陌生人查看我的朋友圈切换
 */
+ (NSString *)getXKPrivacySwitchVistCircle{
    return @"im/ua/strangerVisitCircleSwitch/1.0";
}


/**
 银行卡列表
 */
+ (NSString *)getXKBankCardList{
    return @"user/ua/mBankCardPage/1.0";
}
/**
 添加银行卡
 */
+ (NSString *)getXKAddBankCard{
    return @"user/ua/mBankCardCreate/1.0";
}


#pragma  mark ------------------------------------------自营商城-----------------------
// 查询推荐商品列表
+ (NSString *)getMallRecommendGoodsListUrl {
    return @"goods/ua/mallGoodsRecommendSGoodsQPage/1.0";
}
// 查询icon分类
+ (NSString *)getMallIconListUrl {
    return @"sys/ua/scategoryQList/1.0";
}
// 查询所有商品分类
+ (NSString *)getMallCategoryListUrl {
    return @"goods/ua/queryMallCategory/1.0";
}
// 查询商品列表
+ (NSString *)getMallGoodsListUrl {
    return @"goods/ua/goodsQPage/1.0";
}
//查询订单列表
+ (NSString *)getMallOrderListUrl {
    return @"trade/ua/mallOrderQPage/1.0";
}
//查询订单售后列表
+ (NSString *)getMallOrderAfterSaleListUrl {
    return @"trade/ua/mallOrderQPageRefund/1.0";
}
//取消订单
+ (NSString *)getMallOrderCancelUrl {
    return @"trade/ua/mallOrderUserCancel/1.0";
}
//确认收货
+ (NSString *)getMallOrderAcceptlUrl {
    return @"trade/ua/mallOrderUserConfirmReceive/1.0";
}
//取消退款
+ (NSString *)getMallOrderCaccelRefundlUrl {
    return @"trade/ua/mallOrderUserRefundCancel/1.0";
}
//退款理由
+ (NSString *)getMallOrderRefundReasonlUrl {
    return @"trade/ua/refundReasonQList/1.0";
}
//退款
+ (NSString *)getMallOrderRefundlUrl {
    return @"trade/ua/mallOrderUserRefund/1.0";
}
//支付
+ (NSString *)getMallOrderPaylUrl {
    return @"trade/ua/mallOrderUserPay/1.0";
}
//用户上传物流信息
+ (NSString *)getMallOrderUploadTransInfolUrl {
    return @"trade/ua/mallOrderUserRefundUploadLogistice/1.0";
}
//订单评论
+ (NSString *)getMallOrderAddCommentUrl {
    return @"im/ua/mallGoodsCommentCreate/1.0";
}
//商品反馈
+ (NSString *)getGoodsOpinionUrl {
    return @"sys/ua/goodsFeedbackCreate/1.0";
}
//订单物流
+ (NSString *)getOrderTransportUrl {
    return @"sys/ua/logisticsQuery/1.0";
}
//商品SKU明细
+ (NSString *)getMallGoodsDetailSKUinfoUrl {
    return @"goods/ua/mallGoodsSkuQList/1.0";
}
//订单详情
+ (NSString *)getMallOrderDetailUrl {
    return @"trade/ua/mallOrderDetail/1.0";
}
//退款订单详情
+ (NSString *)getMallOrderRefundDetailUrl {
    return @"trade/ua/mallOrderRefundDetail/1.0";
}
//购物车列表
+ (NSString *)getMallBuyCarListUrl {
    return @"goods/ua/mallCartList/1.0";
}
//获取订单可以使用的优惠券列表
+ (NSString *)getMallBuyCarTicketListUrl {
    return @"goods/ua/mallCardGoodsQList/1.0";
}
//领取订单可以使用的优惠券
+ (NSString *)getMallBuyCarDrawTicketUrl {
    return @"trade/ua/mallCouponUserDraw/1.0";
}
//订单费用
+ (NSString *)getMallBuyCarFeeUrl {
    return @"trade/ua/mallOrderUserValidateAmount/1.0";
}
//获取订单可以使用的优惠券列表
+ (NSString *)getMallBuyCarOrderTicketUrl {
     return @"trade/ua/findUserCoupons/1.0";
}
//下单
+ (NSString *)getOrderMallBuyCarUrl {
     return @"trade/ua/mallOrderUserCreate/1.0";
}
//购物车删除
+ (NSString *)getMallBuyCarDeleteUrl {
    return @"goods/ua/mallCartBatchDestory/1.0";
}
//购物车收藏
+ (NSString *)getMallBuyCarCollectUrl {
    return @"goods/ua/mallCartMoveToCollect/1.0";
}
#pragma  mark ------------------------------------------福利商城-----------------------
/**
 查询所有商品分类
 */
+ (NSString *)getWelfareCategoryListUrl {
    return @"goods/ua/queryJfmallCategory/1.0";
}
//新版首页ICON
+ (NSString *)getWelfareIconListUrl {
    return @"sys/ua/jcategoryQList/1.0";
}
// 查询推荐商品列表
+ (NSString *)getWelfareRecommendGoodsListUrl {
      return @"goods/ua/recommendJGoodsQPage/1.0";
}
// 查询商品平台列表
+ (NSString *)getWelfarePlatformGoodsListUrl {
    return @"goods/ua/platDrawQPage/1.0";
}
// 查询商品店铺列表
+ (NSString *)getWelfareStoredGoodsListUrl {
    return @"goods/ua/platDrawQPage/1.0";
}

// 查询商品列表
+ (NSString *)getWelfareGoodsListUrl {
    return @"goods/ua/jmallEsSearch/1.0";
}
//查询订单列表
+ (NSString *)getWelfareOrderListUrl {
    return @"trade/ua/jfMallOrderQPage/1.0";
}
//购物车列表
+ (NSString *)getWelfareBuyCarListUrl {
    return @"goods/ua/jfmallCartQList/1.0";
}
//购物车列表删除
+ (NSString *)getWelfareBuyCarDeleteUrl {
    return @"goods/ua/jfmallCartDestroy/1.0";
}
//购物车列表收藏
+ (NSString *)getWelfareBuyCarCollectionUrl {
    return @"goods/ua/jfmallCartMoveToFavorites/1.0";
}
//购物车—批量修改数量
+ (NSString *)getWelfareBuyCarChangeNumbernUrl {
    return @"goods/ua/jfmallCartUpdateQuantity/1.0";
}
//收藏商品
+ (NSString *)getGoodsDetailCollectionUrl {
    return @"trade/ua/jfMallOrderQPage/1.0";
}
//取消收藏商品
+ (NSString *)getGoodsDetailCancelCollectionUrl {
    return @"trade/ua/jfMallOrderQPage/1.0";
}
//订单详情
+ (NSString *)getWelfareOrderDetailUrl {
    return @"trade/ua/jfMallOrderDetail/1.0";
}
//已中奖详情
+ (NSString *)getWelfareOrderWinDetailUrl {
    return @"trade/ua/jSequenceJoinQPage/1.0";
}
//订单收货
+ (NSString *)getWelfareOrderAcceptUrl {
    return @"trade/ua/jOrderDoReceving/1.0";
}
//订单分享
+ (NSString *)getWelfareOrderShareUrl {
    return @"trade/ua/jOrderDoShare/1.0";
}
//订单退货
+ (NSString *)getWelfareGoodsChangeUrl {
    return @"trade/ua/jmallOrderReportedLoss/1.0";
}
//订单退货详情
+ (NSString *)getWelfareGoodsChangeDetailUrl {
    return @"trade/ua/refundReportDetail/1.0";
}
// 往期中奖记录
+ (NSString *)getPastAwardRecordsUrl {
    return @"goods/ua/pastLotteryRecordForOperation/1.0";
}


#pragma  mark ------------------------------------------广场首页-------------------------------


// App版本更新
+ (NSString *)getAppVersionCheckUrl {
    return @"sys/ua/clientVersionQuery/1.0";
}

// 首页优惠券列表
+ (NSString *)getSquareCardCouponListUrl {
    return @"trade/ua/sDrawHomePageActivity/1.0";
}

//轮播图
+ (NSString *)getSquareBannerUrl {
    return @"sys/ua/bannerList/1.0";
}

//home工具栏
+ (NSString *)getSquareHomeToolUrl {
    return @"sys/ua/homeIconQList/1.0";
}

//抽奖信息
+ (NSString *)getSqureRewardUrl {
    return @"";
}

//商城的商品推荐
+ (NSString *)getSquareStoreRecommendUrl {
    return @"goods/ua/mallGoodsRecommendSGoodsQPage/1.0";
}
//商家推荐
+ (NSString *)getSquareMerchantRecommendUrl {
    return @"goods/ua/esRecommendShopQPage/1.0";
}

//广场资讯
+ (NSString *)getSquareConsultUrl {
    return @"sys/ua/consultContentPage/1.0";
}

//朋友圈推荐
+ (NSString *)getSquareFriendsCircleRecommendUrl {
    return @"im/ua/friendCircleRefreshDynamic/1.0";
}
//朋友圈点赞
+ (NSString *)getSquareFriendsCircleLikeUrl {
    return @"im/ua/friendCircleLike/1.0";
}

//获取推荐小视频
+ (NSString *)getSquareVideoRecommendUrl {
    return @"index/Square/a001/recom/1.0";
}

//获取推荐游戏
+ (NSString *)getSquareGamesRecommendUrl {
    return @"";
}

// 中奖公告
+ (NSString *)getWinningAnnouncementUrl {
    return [[self getDynamicWebBaseUrl] stringByAppendingString:@"lotteryindex"];
}

// 抽奖规则
+ (NSString *)getWelfareActivityRulesUrl {
    return [[self getDynamicWebBaseUrl] stringByAppendingString:@"actRule"];
}

#pragma  mark ----------------------------------------- 商 圈 -------------------------------

//获取商圈商品评价列表
+ (NSString *)getTradingAreaGoodsOrShopCommentListUrl {
    return @"im/ua/bcleGoodsCommentList/1.0";
}
//获取商圈商品评价标签
+ (NSString *)getTradingAreaGoodsCommentLabelsUrl {
    return @"im/ua/bcleGoodsCommentLabels/1.0";
}

//获取商圈商店评价标签
+ (NSString *)getTradingAreaShopsCommentLabelsUrl {
    return @"goods/ua/mShopShopOneType/1.0";
}


//商圈商品评论数及平均数
+ (NSString *)getTradingAreaGoodsGradeUrl {
    return @"im/ua/stat4BcleGoodsComment/1.0";
}

//商圈商店评论数及平均数
+ (NSString *)getTradingAreaShopGradeUrl {
    return @"im/ua/stat4BcleShop/1.0";
}

//获取商圈商店详情
+ (NSString *)getTradingAreaShopDetailUrl {
    return @"goods/ua/shopGoodsAppPage/1.0";
}

//获取收藏状态
+ (NSString *)getXKFavoriteStatusUrl {
    return @"user/ua/xkFavoriteDoFavorite/1.0";
}

//收藏
+ (NSString *)getXKFavoriteUrl {
    return @"user/ua/xkFavoriteCreate/1.0";
}

//取消收藏
+ (NSString *)getXKCancelFavoriteUrl {
    return @"user/ua/xkFavoriteUnFavorite/1.0";
}


//获取商圈行业分类
+ (NSString *)getTradingAreaIndustryCategaryListlUrl {
    return @"sys/ua/industryAllQList/1.0";
}

//获取商圈商店列表
+ (NSString *)getTradingAreaShopListlUrl {
    return @"goods/ua/esShopPage/1.0";
}

//获取商圈商品详情
+ (NSString *)getTradingAreaGoodsDetailUrl {
    return @"goods/ua/shopGoodsDetail/1.0";
}


//获取商圈商家自定义的商品二级分类
+ (NSString *)getTradingAreaGoodsCoustomCategaryListUrl {
    return @"sys/ua/qListByServiceCatalogCode/1.0";
}


//根据商家自定义的商品二级分类获取商品
+ (NSString *)getTradingAreaCategaryGoodsListUrl {
    return @"goods/ua/shopGoodsClassificationQList/1.0";
}



//获取商家优惠券列表
+ (NSString *)getTradingAreaShopCouponListUrl {
    return @"goods/ua/shopCouponQList/1.0";
}

//获取商家会员卡列表
+ (NSString *)getTradingAreaShopMemberListUrl {
    return @"goods/ua/shopMemberQList/1.0";
}

//获取商家抽奖卡列表
+ (NSString *)getTradingAreaShopRewardListUrl {
    return @"";
}


//领取商家优惠券
+ (NSString *)getTradingAreaShopCouponUserDraw {
    return @"trade/ua/shopCouponUserDraw/1.0";
}

//领取商家会员卡
+ (NSString *)getTradingAreaShopMemberUserDraw {
    return @"trade/ua/shopMemberCardUserDraw/1.0";
}

//领取商家抽奖卡
+ (NSString *)getTradingAreaShopRewardUserDraw {
    return @"";
}



//获取席位分类列表
+ (NSString *)getTradingAreaSeatCategaryList {
    return @"goods/ua/mSeatStatistics/1.0";
}


//获取不同分类席位列表
+ (NSString *)getTradingAreaSeatList {
    return @"goods/ua/mSeatList/1.0";
}


//验证席位
+ (NSString *)getTradingAreaVerifierOrderSeatUrl {
    return @"trade/ua/bcleUserVerifierOrderSeat/1.0";
}


//创建订单
+ (NSString *)getTradingAreaCreatOrder {
    return @"trade/ua/bcleOrderCreate/1.0";
}

//取消订单
+ (NSString *)getTradingAreaCancelOrder {
    return @"trade/ua/bcleUserCancelOrder/1.0";
}


//取消订单(取消服务(服务包含的加购后台会对应取消))
+ (NSString *)getTradingAreaCancelServiceOrder {
    return @"trade/ua/shopOrderRefundOrCancelApply/1.0";
}


//删除加购订单(针对于未接单前的订单)
+ (NSString *)getTradingAreaDeletePurchaseOrder {
    return @"trade/ua/shopPurchaseOrderUserBatchDelete/1.0";
}



//取消加购订单(针对于已接单但是未支付的订单)
+ (NSString *)getTradingAreaCancelPurchaseOrder {
    return @"trade/ua/shopPurchaseOrderBatchCancelApply/1.0";
}


//退款加购订单(针对于已支付但是未完成的订单)
+ (NSString *)getTradingAreaRefundPurchaseOrder {
    return @"trade/ua/shopPurchaseOrderBatchRefundApply/1.0";
}

//加购商品支付
+ (NSString *)getTradingAreaPayPurchaseGoods {
    return @"trade/ua/bcleUserPurchasedConfirmPayOrder/1.0";
}

//0元支付或者有退款
+ (NSString *)getTradingAreaPrePayRefundOrder {
    return @"trade/ua/userConfirmRefundOrder/1.0";
}


//服务商品支付
+ (NSString *)getTradingAreaPayServiceGoods {
    return @"trade/ua/userPartConfirmPayOrder/1.0";
}

//主单支付
+ (NSString *)getTradingAreaPayMainOrder {
    return @"trade/ua/userConfirmPayOrder/1.0";
}


//订单列表
+ (NSString *)getTradingAreaOrderListUrl {
    return @"trade/ua/bcleOrderUserQPage/1.0";
}


//订单详情
+ (NSString *)getTradingAreaOrderDetailUrl {
    return @"trade/ua/shopOrderDetail/1.0";
}

//售后订单详情
+ (NSString *)getTradingAreaRefundOrderDetailUrl {
    return @"trade/ua/shopOrderRefundDetail/1.0";
}


//订单加购
+ (NSString *)getTradingAreaOrderAddGoodsUrl {
    return @"trade/ua/shopPurchaseOrderUserCreate/1.0";
}

//获取订单支付价格
+ (NSString *)getTradingAreaOrderGetPayPriceUrl {
    return @"trade/ua/bcleUserAmountOrder/1.0";
}

//提醒商家我要付款
+ (NSString *)getTradingAreaTellMerchantOrderWillPay {
    return @"trade/ua/bcleUserConfirmClearing/1.0";
}

//获取订单优惠券
+ (NSString *)getTradingAreaGetOrderCouponsUrl {
    return @"trade/ua/findBcleUserCoupons/1.0";
}


//退款订单列表
+ (NSString *)getTradingAreaRefundOrderListUrl {
    return @"trade/ua/bcleRefundOrderUserQPage/1.0";
}




#pragma mark ------------------------------------------【我的】首页

/**
 * 获取社交模块数量
 */
+ (NSString *)getSocialContactCountUrl {
    return @"user/ua/myInfoDetail/1.0";
}

/**
 * 获取我的作品列表(BaseLiveUrl)
 */
+ (NSString *)getMyProductListUrl {
    return @"index/Square/a001/myWorks/1.0";
}


#pragma mark ------------------------------------------【我的】卡券包

/**
 * 获取会员卡及优惠券数量
 */
+ (NSString *)getCardAndCouponCountUrl {
    return @"trade/ua/userCardCount/1.0";
}

/**
 * 获取会员卡列表
 */
+ (NSString *)getCardListUrl {
    return @"trade/ua/userMemberLiveQPage/1.0";
}

/**
 * 获取优惠券列表
 */
+ (NSString *)getCouponListUrl {
    return @"trade/ua/userCouponLiveQPage/1.0";
}

/**
 * 删除过期会员卡
 */
+ (NSString *)getDeleteCardUrl {
    return @"trade/ua/userMemberDeleteMemberByIds/1.0";
}

/**
 * 删除过期优惠券
 */
+ (NSString *)getDeleteCouponUrl {
    return @"trade/ua/userCouponDeleteCouponByIds/1.0";
}

/**
 可以领取的卡片
 */
+ (NSString *)getCardsReceiveCenterUrl {
    return @"goods/ua/memberCardQList/1.0";
}

/**
 可以领取的优惠券
 */
+ (NSString *)getCouponsReceiveCenterUrl {
    return @"goods/ua/couponQList/1.0";
}

/**
 领取晓可卡
 */
+ (NSString *)getReceiveXKCardUrl {
    return @"goods/ua/mallMemberCardUserDraw/1.0";
}

/**
 领取商户卡
 */
+ (NSString *)getReceiveMerchantCardUrl {
    return @"goods/ua/shopMemberCardUserDraw/1.0";
}

/**
 领取晓可券
 */
+ (NSString *)getReceiveXKCouponUrl {
    return @"goods/ua/mallCouponUserDraw/1.0";
}

/**
 领取商户券
 */
+ (NSString *)getReceiveMerchantCouponUrl {
    return @"goods/ua/shopCouponUserDraw/1.0";
}

#pragma mark ------------------------------------------【我的】账号管理

/**
 * 获取密码开通状态
 */
+ (NSString *)getPaySecurityStatusUrl {
    return @"user/ua/xkUserSecurityIsSet/1.0";
}

/**
 * 设置支付密码
 */
+ (NSString *)getSetPaySecurityUrl {
    return @"user/ua/xkUserPaySecuritySetPassword/1.0";
}

/**
 * 验证支付密码
 */
+ (NSString *)getPaySecurityVerifyUrl {
    return @"user/ua/xkUserPaySecurityVerify/1.0";
}

/**
 * 开启指纹支付
 */
+ (NSString *)getOpenFingerPayUrl {
    return @"user/ua/xkUserFingerprintEnable/1.0";
}

/**
 * 关闭指纹支付
 */
+ (NSString *)getCloseFingerPayUrl {
    return @"user/ua/xkUserFingerprintDisable/1.0";
}

/**
 * 开启面部识别支付
 */
+ (NSString *)getOpenFaceRecognitionUrl {
    return @"user/ua/xkUserFaceRecognitionEnable/1.0";
}

/**
 * 关闭面部识别支付
 */
+ (NSString *)getCloseFaceRecognitionUrl {
    return @"user/ua/xkUserFaceRecognitionDisable/1.0";
}

#pragma mark ------------------------------------------【我的】收货地址管理

/**
 * 获取收货地址列表
 */
+ (NSString *)getRecipientListUrl {
    return @"user/ua/xkUserShopAddrQPage/1.0";
}

/**
 * 创建收货地址
 */
+ (NSString *)getCreateRecipientUrl {
    return @"user/ua/xkUserShopAddrCreate/1.0";
}

/**
 * 设置默认收货地址
 */
+ (NSString *)getSetDefaultRecipientUrl {
    return @"user/ua/xkUserShopAddrUpdateDefault/1.0";
}

/**
 * 修改收货地址
 */
+ (NSString *)getUpdateRecipientUrl {
    return @"user/ua/xkUserShopAddrUpdate/1.0";
}

/**
 * 删除收货地址
 */
+ (NSString *)getDeleteRecipientUrl {
    return @"user/ua/xkUserShopAddrDelete/1.0";
}

#pragma mark ------------------------------------------【广场】小视频

/**
 * 获取直播banner
 */
+ (NSString *)getLiveBannerUrl {
    return @"index/Square/a001/getLiveBanner/1.0";
}

/**
 * 获取推荐小视频
 */
+ (NSString *)getRecommendVideoUrl {
    return @"index/Square/a001/recom/1.0";
}

/**
 * 获取单个小视频
 */
+ (NSString *)getSingleVideoUrl {
    return @"index/Square/a001/videoById/1.0";
}

/**
 * 获取同城小视频
 */
+ (NSString *)getCityVideoUrl{
    return @"index/Square/a001/searchCity/1.0";
}

/**
 获取小视频搜索处热门用户和热门话题
 */
+ (NSString *)getHotUsersAndHotTopicsUrl {
    return @"index/Square/a001/homeSearch/1.0";
}

/**
 小视频搜索
 */
+ (NSString *)getSearchUrl {
    return @"index/Square/a001/homeSearchAll/1.0";
}

/**
 小视频搜索更多用户
 */
+ (NSString *)getSearchMoreUsersUrl {
    return @"index/Square/a001/searchMoreUser/1.0";
}

/**
 小视频搜索更多话题
 */
+ (NSString *)getSearchMoreTopicsUrl {
    return @"index/Square/a001/searchMoreTopic/1.0";
}

/**
 关注用户
 */
+ (NSString *)getFocusUserUrl {
    return @"im/ua/follow/1.0";
}
/**
 取消关注用户
 */
+ (NSString *)getCancelFocusUserUrl {
    return @"im/ua/unfollow/1.0";
}

/**
 视频点赞/取消点赞
 */
+ (NSString *)getVideoLikeUrl {
    return @"im/ua/userVideoLike/1.0";
}

/**
 获取某个小视频的评论
 */
+ (NSString *)getAllCommentsUrl {
    return @"im/ua/videoCommentList/1.0";
}

/**
 获取某个评论的详情
 */
+ (NSString *)getCommentDetailUrl {
    return @"im/ua/videoCommentDetail/1.0";
}

/**
 获取某个评论的回复
 */
+ (NSString *)getCommentReplysUrl {
    return @"im/ua/videoCommentReplyList/1.0";
}

/**
 给某个小视频添加评论
 */
+ (NSString *)getAddCommentUrl {
    return @"im/ua/videoCommentCreate/1.0";
}

/**
 给某个评论添加回复
 */
+ (NSString *)getAddCommentReplyUrl {
    return @"im/ua/videoCommentReplyCreate/1.0";
}

/**
 给某个评论进行点赞
 */
+ (NSString *)getLikeCommentUrl {
    return @"im/ua/videoCommentLike/1.0";
}

/**
 小视频分享成功后，分享次数+1
 */
+ (NSString *)getAddShareCountUrl {
    return @"index/Square/a001/shareSetInc/1.0";
}

/**
 小视频通过ID批量查询商品
 */
+ (NSString *)getVideoGoodsListUrl {
    return @"goods/ua/goodsQListByIds/1.0";
}

#pragma mark ------------------------------------------ IM

/**
 可友聊天礼物列表
 */
+ (NSString *)chatGiftListUrl {
    return @"goods/ua/giftPage/1.0";
}

/**
 送礼物
 */
+ (NSString *)sendGiftUrl {
    return @"trade/ua/tradingAppGivingGifts/1.0";
}

#pragma mark ------------------------------------------ 交易

/**
 统一的收银台接口
 */
+ (NSString *)unifiedPaymentUrl {
    return @"trade/ua/uniPayment/1.0";
}

#pragma mark ------------------------------------------ 商户APP接口

+ (NSString *)RNMerchantCustomerConsultationsUrl {
  return @"im/ma/mCustomerList/1.0";
}

@end
