//
//  IKCommon.h
//  Erp4iOS
//
//  Created by rztime on 2017/11/17.
//  Copyrig
//

#ifndef IKCommon_h
#define IKCommon_h


typedef NS_ENUM(NSInteger, RefreshDataStatus) {
	Refresh_HasDataAndHasMoreData = 1, // 当前有数据 && 还有更多数据 --> 设置
	Refresh_NoDataOrHasNoMoreData = 2, //  当前无数据 || 当前有数据但是没有更多数据 --> 设置
	Refresh_NoNet 				= 3 // 网络失败 -->设置
};


typedef NS_ENUM(NSInteger, XKControllerType) {
    XKCollectControllerCollectType             = 0,        // 收藏
    XKBrowseControllerType                     = 1,        // 浏览
    XKMeassageCollectControllerType            = 2,        // 收藏消息类型
};

typedef NS_ENUM(NSInteger, XKFriendHeaderControllerType) {
    XKKYHeaderControllerType            = 0,        // 可友选择头像
    XKMYHeaderControllerType            = 1,        // 密友选择头像
};

typedef NS_ENUM(NSInteger, XKPersonalVideoControllerType) {
    XKKYPersonalVideoControllerType        = 0,        // 可友视频
    XKMYPersonalVideoControllerType        = 1,        // 密友视频
};
typedef NS_ENUM(NSInteger, XKCollectViewModelType) {
    XKCollectGoodsViewModelType       = 0,        // 商品
    XKCollectShopViewModelType        = 1,        // 店铺
    XKCollectGamesViewModelType       = 2,        // 游戏
    XKCollectVideoViewModelType       = 3,        // 小视频
    XKCollectWelfareViewModelType     = 4,        // 福利
};

typedef NS_ENUM(NSInteger, XKQRCodeResultType) {
  XKQRCodeResultBusinessCardType       = 0,        //我的二维码名片xkgc://business_card?user=123&securityCode=123
  XKQRCodeResultGroupBusinessCardType  = 1,        //群名片 xkgc://group_business_card?groupId=123
  XKQRCodeResultCommodityDetailType    = 2,        //商品详情 xkgc://commodity_detail?commodityId=123&storeId=123&periodsId=123&userId=1111
  XKQRCodeResultStoreDetailType        = 3,        //店铺详情 xkgc://store_detail?storeId=123&userId=1111
  
  XKQRCodeResultStoreReceiptType       = 4,        //店铺收款 xksl://store_receipt?storeId=123&offerType=1111&offerValue=1111&originalPrice=1111&actualAmount=1111&expireTime=1111
  
  XKQRCodeResultSalesXiaokeCurrencyType = 5,        //出售晓可币 xksl://sales_xiaoke_currency?orderId=123&merchantId=1111&salePrice=1111&expireTime=1111
  
  XKQRCodeResultOfflineReceiptOrderType = 6,        //线下收款订单 xksl://offline_receipt_order?orderId=123&storeId=1111
  
  XKQRCodeResultOfflineConsumptionOrderType = 7,    //线下消费订单xkgc://offline_consumption_order?orderId=123&orderType=111&consumptionCode=111
  
  XKQRCodeResultNoneType               = 8,        //无法识别
};
/**
 系统消息类型
 */
typedef NS_ENUM(NSInteger, XKSysMessageControllerType) {
    XKActivitySysMessageControllerType        = 0,        // 活动
    XKSpecialSysMessageControllerType         = 1,        // 专题
    XKShoppingSysMessageControllerType        = 2,        // 自营
    XKMallSysMessageControllerType            = 3,        // 福利
    XKAreaSysMessageControllerType            = 4,        // 周边
    XKPraiseSysMessageControllerType          = 5,        // 抽奖
    XKSysSysMessageControllerType             = 6,        // 系统

};

#endif
