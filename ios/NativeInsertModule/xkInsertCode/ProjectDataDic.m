/*******************************************************************************
 # File        : ProjectDataDic.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/26
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "ProjectDataDic.h"

#pragma mark - 性别
/**男 数据字典*/
NSString *const  XKSexMale = @"male";
/**女 数据字典*/
NSString *const  XKSexFemale = @"female";
/**保密 数据字典*/
NSString *const  XKSexUnknow = @"unknown";


#pragma mark - 认证状态
/**提交认证 数据字典*/
NSString *const XKAuthStatusSubmit = @"submit";
/**认证成功 数据字典*/
NSString *const XKAuthStatusSuccess = @"success";
/**认证失败 数据字典*/
NSString *const XKAuthStatusFailed = @"failed";


#pragma mark - 投诉进度
/**提交投诉 数据字典*/
NSString *const XKReportProcessSubmit = @"submit";
/**接受受理 数据字典*/
NSString *const XKReportProcessAccept = @"accept";
/**关闭受理 数据字典*/
NSString *const XKReportProcessClse = @"clse";

#pragma mark - 账号状态
/**正常 数据字典*/
NSString *const XKAccoutStatusActive = @"active";
/**冻结 数据字典*/
NSString *const XKAccoutStatusDisable = @"disable";


#pragma mark - 视角名称
/**个体虚拟商户 视角名称-数据字典*/
NSString *const XKViewTypePersonalVirtualMerchant = @"PERSONAL_VIRTUAL_MERCHANT";
/**普通用户 视角名称-数据字典*/
NSString *const XKViewTypeNormalUser = @"NORMAL_USER";
/**实体商户 视角名称-数据字典*/
NSString *const XKViewTypeRealMerchant = @"REAL_MERCHANT";
/**城市合伙人 视角名称-数据字典*/
NSString *const XKViewTypeCityPartner = @"CITY_PARTNER";
/**实体商户 视角名称-数据字典*/
NSString *const XKViewTypeAnchorVirtualMerchant = @"ANCHOR_VIRTUAL_MERCHANT";


#pragma mark - 工作台-工单状态
/**已完成 工单状态-数据字典*/
NSString *const XKWorkOrderStatusFinish = @"WORK_ORDER_FINISH";
/**未接单 工单状态-数据字典*/
NSString *const XKWorkOrderStatusNotTakeOver = @"NOT_TAKE_OVER";
/**已接单 工单状态-数据字典*/
NSString *const XKWorkOrderStatusAlreadyTakeOver = @"ALREADY_TAKE_OVER";
/**已评价 工单状态-数据字典*/
NSString *const XKWorkOrderStatusAleadyEvalution = @"ALREADY_EVALUATION";

#pragma mark - 小可模块-xkModule
/**福利 小可模块-数据字典*/
NSString *const XKModulejf_mall = @"jf_mall";
/**店铺 小可模块-数据字典*/
NSString *const XKModuleshop    = @"shop";
/**游戏 小可模块-数据字典*/
NSString *const XKModulegame    = @"game";
/**小视频 小可模块-数据字典*/
NSString *const XKModulelive_video  = @"live_video";
/**商品 小可模块-数据字典*/
NSString *const XKModulegoods   = @"goods";
/**自营 小可模块-数据字典*/
NSString *const XKModuleMall   = @"mall";

#pragma mark - 动态权限-DynamicAuth
/**公开 动态权限-数据字典*/
NSString *const DynamicAuthPublic = @"all";
/**私密 动态权限-数据字典*/
NSString *const DynamicAuthMe    = @"me";
/**部分可见 动态权限-数据字典*/
NSString *const DynamicAuthSee    = @"see";
/**部分不可见 动态权限-数据字典*/
NSString *const DynamicAuthUnSee  = @"unsee";



@implementation ProjectDataDic

@end
