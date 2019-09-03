/*******************************************************************************
 # File        : ProjectDataDic.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/26
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

#pragma mark - 性别
/**男 性别-数据字典*/
extern NSString *const XKSexMale;
/**女 性别-数据字典*/
extern NSString *const XKSexFemale;
/**保密 性别-数据字典*/
extern NSString *const XKSexUnknow;

#pragma mark - 认证状态
/**提交认证 认证状态-数据字典*/
extern NSString *const XKAuthStatusSubmit;
/**认证成功 认证状态-数据字典*/
extern NSString *const XKAuthStatusSuccess;
/**认证失败 认证状态-数据字典*/
extern NSString *const XKAuthStatusFailed;

#pragma mark - 投诉进度
/**提交投诉 投诉进度-数据字典*/
extern NSString *const XKReportProcessSubmit;
/**接受受理 投诉进度-数据字典*/
extern NSString *const XKReportProcessAccept;
/**关闭受理 投诉进度-数据字典*/
extern NSString *const XKReportProcessClse;



#pragma mark - 账号状态
/**正常 账号状态-数据字典 */
extern NSString *const XKAccoutStatusActive;
/**冻结 账号状态-数据字典*/
extern NSString *const XKAccoutStatusDisable;

#pragma mark - 关系状态




#pragma mark - 视角名称
/**个体虚拟商户 视角名称-数据字典*/
extern NSString *const XKViewTypePersonalVirtualMerchant;
/**普通用户 视角名称-数据字典*/
extern NSString *const XKViewTypeNormalUser;
/**实体商户 视角名称-数据字典*/
extern NSString *const XKViewTypeRealMerchant;
/**城市合伙人 视角名称-数据字典*/
extern NSString *const XKViewTypeCityPartner;
/**实体商户 视角名称-数据字典*/
extern NSString *const XKViewTypeAnchorVirtualMerchant;

#pragma mark - 工作台-工单状态
/**已完成 工单状态-数据字典*/
extern NSString *const XKWorkOrderStatusFinish;
/**未接单 工单状态-数据字典*/
extern NSString *const XKWorkOrderStatusNotTakeOver;
/**已接单 工单状态-数据字典*/
extern NSString *const XKWorkOrderStatusAlreadyTakeOver;
/**已评价 工单状态-数据字典*/
extern NSString *const XKWorkOrderStatusAleadyEvalution;

#pragma mark - 小可模块-xkModule
/**福利 小可模块-数据字典*/
extern NSString *const XKModulejf_mall;
/**店铺 小可模块-数据字典*/
extern NSString *const XKModuleshop;
/**游戏 小可模块-数据字典*/
extern NSString *const XKModulegame ;
/**小视频 小可模块-数据字典*/
extern NSString *const XKModulelive_video ;
/**商品 小可模块-数据字典*/
extern NSString *const XKModulegoods;
/**自营 小可模块-数据字典*/
extern NSString *const XKModuleMall;

#pragma mark - 动态权限-DynamicAuth
/**公开 动态权限-数据字典*/
extern NSString *const DynamicAuthPublic;
/**私密 动态权限-数据字典*/
extern NSString *const DynamicAuthMe;
/**部分可见 动态权限-数据字典*/
extern NSString *const DynamicAuthSee;
/**部分不可见 动态权限-数据字典*/
extern NSString *const DynamicAuthUnSee;

/**发送短信验证码*/
static NSString *const SmsAuthBizTypeLogin             = @"LOGIN";
static NSString *const SmsAuthBizTyperegister          = @"REGISTER";
static NSString *const SmsAuthBizTyperesetPassword     = @"RESET_PASSWORD";
static NSString *const SmsAuthBizTyperesetPhone        = @"RESET_PHONE";
static NSString *const SmsAuthBizTypeBindPhone         = @"BIND_PHONE";
static NSString *const SmsAuthBizTypeValidate          = @"VALIDATE";

/**商圈的排序规则*/
static NSString *const TradingAreaOrderTypeIntelligenece             = @"INTELLIGENCE";//智能排序
static NSString *const TradingAreaOrderTypeDistance                  = @"DISTANCE";//距离优先
static NSString *const TradingAreaOrderTypeAvgconsumptionL           = @"POPULARITY";//低价优先
static NSString *const TradingAreaOrderTypeLevel                     = @"LEVEL";//好评优先
static NSString *const TradingAreaOrderTypeAvgconsumptionH           = @"AVGCONSUMPTION";//高价优先

/**开奖方式*/
static NSString *const Jf_MallBytime                                 = @"bytime";//按时间，时间到自动开奖
static NSString *const Jf_MallBymember                               = @"bymember";//按进度人数达到自动开奖
static NSString *const Jf_MallBytimeorbymember                       = @"bytime_or_bymember";//时间到或进度已满则开奖
static NSString *const Jf_MallBytimeandbymember                      = @"bytime_and_bymember";//时间到且进度已满则开奖


#pragma mark - 系统消息类型-sysMessage

/**系统消息*/
static NSString *const SysMessageCode          = @"001";
/**活动*/
static NSString *const SysMessageActivityCode  = @"002";
/**专题*/
static NSString *const SysMessageSpecialCode   = @"003";
/**自营商城*/
static NSString *const SysMessageShoppingCode  = @"004";
/**福利商城*/
static NSString *const SysMessageMallCode      = @"005";
/**抽奖*/
static NSString *const SysMessagepPraiseCode   = @"006";
/**周边*/
static NSString *const SysMessageAreaCode      = @"007";

#pragma mark - 自营消息订单状态-mallMessageOderStatus
/*
待支付，PRE_PAY, 待配送PRE_SHIP, 待收货PRE_RECEVICE, 待评价PRE_EVALUATE, 已完成COMPLETELY;
*/
/**待支付*/
static NSString *const mallMessageOderPrePayStatus          = @"PRE_PAY";
/**待配送*/
static NSString *const mallMessageOderPreShipStatus         = @"PRE_SHIP";
/**待收货*/
static NSString *const mallMessageOderPreReceviceStatus     = @"PRE_RECEVICE";
/**待评价*/
static NSString *const mallMessageOderPreEvaluateStatus     = @"PRE_EVALUATE";
/**已完成*/
static NSString *const mallMessageOderCompletelyStatus      = @"COMPLETELY";

#pragma mark - 自营消息退款订单状态-mallMessageRefundOderStatus
//未退款NONE,已申请APPLY,未通过REFUSED,待用户发货PRE_USER_SHIP,待平台收货PRE_PLAT_RECEIVE,待平台退款PRE_REFUND,退款中REFUNDING,退款完成COMPLETE
/**未退款*/
static NSString *const mallMessageRefundOderStatusNONE                 = @"NONE";
/**已申请*/
static NSString *const mallMessageRefundOderStatusAPPLY                = @"APPLY";
/**未通过*/
static NSString *const mallMessageRefundOderStatusREFUSED              = @"REFUSED";
/**待用户发货*/
static NSString *const mallMessageRefundOderStatusPREUSERSHIP        = @"PRE_USER_SHIP";
/**待平台收货*/
static NSString *const mallMessageRefundOderStatusPREPLATRECEIVE     = @"PRE_PLAT_RECEIVE";
/**待平台退款*/
static NSString *const mallMessageRefundOderStatusPREREFUND           = @"PRE_REFUND";
/**退款中*/
static NSString *const mallMessageRefundOderStatusREFUNDING            = @"REFUNDING";
/**退款完成*/
static NSString *const mallMessageRefundOderStatusCOMPLETE             = @"COMPLETE";



typedef NS_ENUM(NSInteger, perfectPersonalType) {
  personalType              = 1, // 个人资料
  KYPersonalType            = 2, //  可友资料
  MYPersonalType            = 3  // 密友资料
};

@interface ProjectDataDic : NSObject

@end
