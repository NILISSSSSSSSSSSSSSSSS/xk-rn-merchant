//
//  XKSquareTradingAreaTool.m
//  XKSquare
//
//  Created by hupan on 2018/10/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaOrderPayViewController.h"
#import "XKTradingAreaCommentLabelsModel.h"
#import "XKTradingAreaCommentListModel.h"
#import "XKTradingAreaShopInfoModel.h"
#import "XKTradingAreaIndustyAllCategaryModel.h"
#import "XKTradingAreaShopListModel.h"
#import "XKTradingAreaGoodsInfoModel.h"
#import "XKTradingAreaCommentGradeModel.h"
#import "XKGoodsCoustomCategaryListModel.h"
#import "XKCategaryGoodsListModel.h"
#import "XKStoreActivityListCouponModel.h"
#import "XKStoreActivityListShopCardModel.h"
#import "XKTradingAreaCreatOderModel.h"
#import "XKTradingAreaSeatModel.h"
#import "XKTradingAreaSeatListModel.h"
#import "XKPayAlertSheetView.h"
#import "XKBusinessAreaOrderListModel.h"
#import "XKTradingAreaOrderDetaiModel.h"
#import "XKTradingAreaAddGoodSuccessModel.h"
#import "XKTradingAreaGetPriceModel.h"
#import "XKTradingAreaOrderCouponModel.h"
#import "XKTradingAreaPrePayModel.h"
#import "XKTradingAreaSeatVerifyModel.h"

@implementation XKSquareTradingAreaTool

//商圈行业分类
+ (void)tradingAreaIndustryAllCategaryList:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaIndustyAllCategaryModel *model))success faile:(void(^)(XKHttpErrror *error))faile {
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaIndustryCategaryListlUrl
                                timeoutInterval:20.0
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaIndustyAllCategaryModel *mode = [XKTradingAreaIndustyAllCategaryModel yy_modelWithJSON:responseObject];
                                            success(mode);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//获取商店列表
+ (void)tradingAreaShopList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<ShopListItem *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopListlUrl
                                timeoutInterval:20.0
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaShopListModel *mode = [XKTradingAreaShopListModel yy_modelWithJSON:responseObject];
                                            success(mode.data);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}


//店铺详情
+ (void)tradingAreaShopInfo:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(XKTradingAreaShopInfoModel *model))success faile:(void(^)(XKHttpErrror *error))faile {
    if (group) {
        dispatch_group_enter(group);
    }
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopDetailUrl
                                timeoutInterval:20.0
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                XKTradingAreaShopInfoModel *mode = [XKTradingAreaShopInfoModel yy_modelWithJSON:responseObject];
                                                success(mode);
                                            }
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}


//获取商店收藏状态
+ (void)tradingAreaShopFavoriteStatus:(NSDictionary *)parameters success:(void (^__strong)(NSInteger code))success faile:(void(^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetXKFavoriteStatusUrl
                                timeoutInterval:20.0
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                success([responseObject integerValue]);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//收藏
+ (void)tradingAreaShopFavorite:(NSDictionary *)parameters success:(void (^__strong)(NSInteger code))success faile:(void(^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetXKFavoriteUrl
                                timeoutInterval:20.0
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                success(1);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}


//取消收藏
+ (void)tradingAreaShopCancelFavorite:(NSDictionary *)parameters success:(void (^__strong)(NSInteger code))success faile:(void(^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetXKCancelFavoriteUrl
                                timeoutInterval:20.0
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                success(1);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}


//获取商店评论标签
+ (void)tradingAreaShopCommentLabels:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<XKTradingAreaCommentLabelsModel *> *result))success {
    
    
    if (group) {
        dispatch_group_enter(group);
    }
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopsCommentLabelsUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                NSMutableArray *muArr = [NSMutableArray array];
                                                XKTradingAreaCommentLabelsModel *model = [XKTradingAreaCommentLabelsModel yy_modelWithDictionary:@{@"name":@"全部"}];
                                                [muArr addObject:model];
                                                NSArray *arr = [NSArray yy_modelArrayWithClass:[XKTradingAreaCommentLabelsModel class] json:responseObject];
                                                [muArr addObjectsFromArray:arr];
                                                success(muArr.copy);
                                            }
                                            
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}


+ (void)tradingAreaGoodsOrShopCommentList:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<CommentListItem *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile {

    if (group) {
        dispatch_group_enter(group);
    }
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaGoodsOrShopCommentListUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaCommentListModel *model = [XKTradingAreaCommentListModel yy_modelWithJSON:responseObject];
                                            success(model.data);
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                            [XKHudView showErrorMessage:error.message];
                                        }];

}


+ (void)tradingAreaGoodsCommentLabels:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<XKTradingAreaCommentLabelsModel *> *result))success {
    
    if (group) {
        dispatch_group_enter(group);
    }
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaGoodsCommentLabelsUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                
                                                NSArray *arr = [NSArray yy_modelArrayWithClass:[XKTradingAreaCommentLabelsModel class] json:responseObject];
                                                NSMutableArray *muArr = [NSMutableArray array];
                                                for (XKTradingAreaCommentLabelsModel *model in arr) {
                                                    if (model.count) {
                                                        [muArr addObject:model];
                                                    }
                                                }
                                                success([muArr copy]);
                                            }
                                            
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}



//获取商品详情
+ (void)tradingAreaGoodsDetail:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(XKTradingAreaGoodsInfoModel *model))success {
    if (group) {
        dispatch_group_enter(group);
    }
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaGoodsDetailUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                XKTradingAreaGoodsInfoModel *model = [XKTradingAreaGoodsInfoModel yy_modelWithJSON:responseObject];
                                                success(model);
                                            }
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
    
}



//获取商店评论数及评分
+ (void)tradingAreaShopCommentGrade:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(XKTradingAreaCommentGradeModel *model))success {
    
    if (group) {
        dispatch_group_enter(group);
    }
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopGradeUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                XKTradingAreaCommentGradeModel *model = [XKTradingAreaCommentGradeModel yy_modelWithJSON:responseObject];
                                                success(model);
                                            }
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}


//获取商品评论数及评分
+ (void)tradingAreaGoodsCommentGrade:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(XKTradingAreaCommentGradeModel *model))success {
    
    
    if (group) {
        dispatch_group_enter(group);
    }
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaGoodsGradeUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                XKTradingAreaCommentGradeModel *model = [XKTradingAreaCommentGradeModel yy_modelWithJSON:responseObject];
                                                success(model);
                                            }
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//获取商品商家自定义二级分类
+ (void)tradingAreaGoodsCoustomCategaryList:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<XKGoodsCoustomCategaryListModel *> *listArr))success {
    
    if (group) {
        dispatch_group_enter(group);
    }
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaGoodsCoustomCategaryListUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                NSArray *arr = [NSArray yy_modelArrayWithClass:[XKGoodsCoustomCategaryListModel class] json:responseObject];
                                                success(arr);
                                            }
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}




//根据商家自定义二级分类获取商品
+ (void)tradingAreaCategaryGoodsList:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<CategaryGoodsItem *> *listArr))success {
    
    if (group) {
        dispatch_group_enter(group);
    }
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaCategaryGoodsListUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                XKCategaryGoodsListModel *model = [XKCategaryGoodsListModel yy_modelWithJSON:responseObject];
                                                success(model.data);
                                            }
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            if (group) {
                                                dispatch_group_leave(group);
                                            }
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
    
    
}


//获取商家优惠券列表
+ (void)tradingAreaShopCouponList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<CouponItemModel *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopCouponListUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                XKStoreActivityListCouponModel *model = [XKStoreActivityListCouponModel yy_modelWithJSON:responseObject];
                                                success(model.data);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}

//获取商家会员卡列表
+ (void)tradingAreaShopMemberList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<ShopCardModel *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile {
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopMemberListUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                XKStoreActivityListShopCardModel *model = [XKStoreActivityListShopCardModel yy_modelWithJSON:responseObject];
                                                success(model.data);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//获取商家抽奖卡列表
+ (void)tradingAreaShopRewardList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<CategaryGoodsItem *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile {
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopRewardListUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                XKCategaryGoodsListModel *model = [XKCategaryGoodsListModel yy_modelWithJSON:responseObject];
                                                success(model.data);
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}


//领取商家优惠券
+ (void)tradingAreaShopCouponUserDraw:(NSDictionary *)parameters success:(void (^__strong)(id result))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopCouponUserDraw
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            success(responseObject);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}

//领取商家会员卡
+ (void)tradingAreaShopMemberUserDraw:(NSDictionary *)parameters success:(void (^__strong)(id result))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopMemberUserDraw
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            success(responseObject);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//领取商家抽奖卡
+ (void)tradingAreaShopRewardUserDraw:(NSDictionary *)parameters success:(void (^__strong)(id result))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaShopRewardUserDraw
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            success(responseObject);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}



//获取席位分类
+ (void)tradingAreaSeatCategaryList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<XKSetItem *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaSeatCategaryListUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaSeatModel *model = [XKTradingAreaSeatModel yy_modelWithJSON:responseObject];
                                            success(model.data);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}


//获取席位列表
+ (void)tradingAreaSeatList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<XKTradingAreaSeatListModel *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaSeatListUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            NSArray *arr = [NSArray yy_modelArrayWithClass:[XKTradingAreaSeatListModel class] json:responseObject];
                                            success(arr);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}

//席位验证
+ (void)tradingAreaVerifierOrderSeat:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaSeatVerifyModel *model))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaVerifierOrderSeatUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaSeatVerifyModel *model = [XKTradingAreaSeatVerifyModel yy_modelWithJSON:responseObject];
                                            success(model);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}


//创建订单
+ (void)tradingAreaCreatOrder:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaCreatOderModel *model))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaCreatOrder
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaCreatOderModel *model = [XKTradingAreaCreatOderModel yy_modelWithJSON:responseObject];
                                            success(model);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//取消订单
+ (void)tradingAreaCancelOrder:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaCreatOderModel *model))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaCancelOrder
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaCreatOderModel *model = [XKTradingAreaCreatOderModel yy_modelWithJSON:responseObject];
                                            success(model);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}

//取消订单(取消服务(服务包含的加购后台会对应取消))
+ (void)tradingAreaCancelServiceOrder:(NSDictionary *)parameters success:(void (^)(NSInteger status))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaCancelServiceOrder
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            NSDictionary *dataDic = [responseObject xk_jsonToDic];
                                            success([dataDic[@"status"] integerValue]);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//删除加购订单(针对于未接单前的订单)
+ (void)tradingAreaDeletePurchaseOrder:(NSDictionary *)parameters success:(void (^)(NSInteger status))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaDeletePurchaseOrder
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            NSDictionary *dataDic = [responseObject xk_jsonToDic];
                                            success([dataDic[@"status"] integerValue]);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//取消加购订单(针对于已接单但是未支付的订单)
+ (void)tradingAreaCancelPurchaseOrder:(NSDictionary *)parameters success:(void (^)(NSInteger status))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaCancelPurchaseOrder
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            NSDictionary *dataDic = [responseObject xk_jsonToDic];
                                            success([dataDic[@"status"] integerValue]);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//退款加购订单(针对于已支付但是未完成的订单)
+ (void)tradingAreaRefundPurchaseOrder:(NSDictionary *)parameters success:(void (^)(NSInteger status))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaRefundPurchaseOrder
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            NSDictionary *dataDic = [responseObject xk_jsonToDic];
                                            success([dataDic[@"status"] integerValue]);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}

//商圈商品预支付
+ (void)tradingAreaOrderPrePay:(NSDictionary *)parameters typeStr:(NSString *)typeStr success:(void (^)(XKTradingAreaPrePayModel *model))success faile:(void (^)(XKHttpErrror *error))faile {
    NSString *urlStr = @"";
    if ([typeStr isEqualToString:@"1"]) {//加购商品支付
        urlStr = GetTradingAreaPayPurchaseGoods;
    } else if ([typeStr isEqualToString:@"2"]) {//服务商品支付（服务+加购 加购前支付）
        urlStr = GetTradingAreaPayServiceGoods;
    } else if ([typeStr isEqualToString:@"3"]) {//主单支付
        urlStr = GetTradingAreaPayMainOrder;
    }
    
    [HTTPClient postEncryptRequestWithURLString:urlStr
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaPrePayModel *model = [XKTradingAreaPrePayModel yy_modelWithJSON:responseObject];
                                            success(model);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//商圈商品0元支付或者有退款
+ (void)tradingAreaOrderPrePayRefundOrder:(NSDictionary *)parameters success:(void (^)(id reslut))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaPrePayRefundOrder
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            success(responseObject);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//获取订单列表
+ (void)tradingAreaOrderList:(NSDictionary *)parameters orderType:(BusinessAreaOrderType)orderType success:(void (^__strong)(NSArray<AreaOrderListModel *> *list))success faile:(void (^)(XKHttpErrror *error))faile {
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    if (parameters) {
        [muDic addEntriesFromDictionary:parameters];
    }
    /*MOT_PICK = 0,//待接单  MOT_PAY,//待支付   MOT_USE,//待消费   MOT_PREPARE,//备货中   MOT_USEING,//进行中   MOT_EVALUATE,//待评价   MOT_FINISH,//已完成  MOT_CLOSED//已关闭*/
    /*待接单STAY_ORDER，代付款STAY_PAY，待消费STAY_CONSUMPTION，带备货STOCK_CENTRE，进行中CONSUMPTION_CENTRE，待评价STAY_EVALUATE，已完成COMPLETELY，已关闭CLOSE*/
    NSString *type = @"";
    NSString *url = @"";
    if (orderType == MOT_PICK) {
        type = @"STAY_ORDER";
        url = GetTradingAreaOrderListUrl;
        [muDic setObject:type forKey:@"orderStatus"];

    } else if (orderType == MOT_PAY) {
        type = @"STAY_PAY";
        url = GetTradingAreaOrderListUrl;
        [muDic setObject:type forKey:@"orderStatus"];

    } else if (orderType == MOT_USE) {
        type = @"STAY_CONSUMPTION";
        url = GetTradingAreaOrderListUrl;
        [muDic setObject:type forKey:@"orderStatus"];

    } else if (orderType == MOT_PREPARE) {
        type = @"STOCK_CENTRE";
        url = GetTradingAreaOrderListUrl;
        [muDic setObject:type forKey:@"orderStatus"];

    } else if (orderType == MOT_USEING) {
        type = @"CONSUMPTION_CENTRE";
        url = GetTradingAreaOrderListUrl;
        [muDic setObject:type forKey:@"orderStatus"];

    } else if (orderType == MOT_EVALUATE) {
        type = @"STAY_EVALUATE";
        url = GetTradingAreaOrderListUrl;
        [muDic setObject:type forKey:@"orderStatus"];

    } else if (orderType == MOT_FINISH) {
        type = @"COMPLETELY";
        url = GetTradingAreaOrderListUrl;
        [muDic setObject:type forKey:@"orderStatus"];

    } else if (orderType == MOT_REFUND) {
        url = GetTradingAreaRefundOrderListUrl;
        
    } else if (orderType == MOT_CLOSED) {
        type = @"CLOSE";
        url = GetTradingAreaOrderListUrl;
        [muDic setObject:type forKey:@"orderStatus"];

    }
    [HTTPClient postEncryptRequestWithURLString:url
                                timeoutInterval:20
                                     parameters:muDic
                                        success:^(id responseObject) {
                                            XKBusinessAreaOrderListModel *model = [XKBusinessAreaOrderListModel yy_modelWithJSON:responseObject];
                                            success(model.data);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}


//获取订单详情
+ (void)tradingAreaOrderDetail:(NSDictionary *)parameters isRefundOrder:(BOOL)isRefundOrder success:(void (^__strong)(XKTradingAreaOrderDetaiModel *model))success faile:(void (^)(XKHttpErrror *error))faile {
    
    NSString *urlStr;
    if (isRefundOrder) {
        urlStr = GetTradingAreaRefundOrderDetailUrl;
    } else {
        urlStr = GetTradingAreaOrderDetailUrl;
    }
    
    [HTTPClient postEncryptRequestWithURLString:urlStr
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaOrderDetaiModel *model = [XKTradingAreaOrderDetaiModel yy_modelWithJSON:responseObject];
                                            success(model);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//订单加购
+ (void)tradingAreaOrderAddGoods:(NSDictionary *)parameters success:(void (^__strong)(NSArray<XKTradingAreaAddGoodSuccessModel *> *list))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaOrderAddGoodsUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            NSArray *arr = [NSArray yy_modelArrayWithClass:[XKTradingAreaAddGoodSuccessModel class] json:responseObject];
                                            success(arr);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}

//获取订单支付金额
+ (void)tradingAreaOrderGetPayPrice:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaGetPriceModel *model))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaOrderGetPayPriceUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaGetPriceModel *model = [XKTradingAreaGetPriceModel yy_modelWithJSON:responseObject];
                                            success(model);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}

//提示商家我要付款
+ (void)tradingAreaTellMerchantOrderWillPay:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaCreatOderModel *model))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaTellMerchantOrderWillPay
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            XKTradingAreaCreatOderModel *model = [XKTradingAreaCreatOderModel yy_modelWithJSON:responseObject];
                                            success(model);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}

//获取订单的优惠券
+ (void)tradingAreaGetOrderCoupons:(NSDictionary *)parameters success:(void (^__strong)(NSArray<XKTradingAreaOrderCouponModel *> *list))success faile:(void (^)(XKHttpErrror *error))faile {
    
    [HTTPClient postEncryptRequestWithURLString:GetTradingAreaGetOrderCouponsUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            NSArray *arr = [NSArray yy_modelArrayWithClass:[XKTradingAreaOrderCouponModel class] json:responseObject];
                                            success(arr);
                                        } failure:^(XKHttpErrror *error) {
                                            faile(error);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}

//订单列表去支付
+ (void)tradingAreaOrderListGotoPay:(NSString *)orderId targetViewController:(BaseViewController *)viewController faile:(void (^)(XKHttpErrror *error))faile {
    [XKHudView showLoadingTo:nil animated:YES];
    [XKSquareTradingAreaTool tradingAreaOrderDetail:@{@"orderId":orderId ? orderId : @""}
                                    isRefundOrder:NO
                                            success:^(XKTradingAreaOrderDetaiModel *model) {
                                                [XKHudView hideAllHud];
                                                NSString *type = model.sceneStatus;                                                
                                                XKTradingAreaOrderPayViewController *vc = [[XKTradingAreaOrderPayViewController alloc] init];
                                                vc.itemsArr = model.items;
                                                if ([type isEqualToString:@"SERVICE_OR_STAY"] || [type isEqualToString:@"SERVICE_AND_LOCALE_BUY"]) {
                                                    vc.appointRange = model.appointRange;
                                                    vc.type = PayViewType_service;
                                                    //纯服务
                                                    if ([type isEqualToString:@"SERVICE_OR_STAY"]) {
                                                        vc.isMainOrder = YES;
                                                    } else {
                                                        //服务+加购
                                                        //商家确认 待用户支付时是主单支付
                                                        if ([model.orderStatus isEqualToString:@"STAY_CLEARING"]) {
                                                            vc.isMainOrder = YES;
                                                        }
                                                    }
                                                } else if ([type isEqualToString:@"LOCALE_BUY"]) {
                                                    vc.type = PayViewType_offline;
                                                    
                                                } else if ([type isEqualToString:@"TAKE_OUT"]) {
                                                    if (model.isSelfLifting) {
                                                        vc.type = PayViewType_takeoutSelfTake;
                                                    } else {
                                                        vc.type = PayViewType_takeoutSend;
                                                    }
                                                }
                                                [viewController.navigationController pushViewController:vc animated:YES];
                                                
                                            } faile:^(XKHttpErrror *error) {
                                                faile(error);
                                                [XKHudView hideAllHud];
                                            }];
    
}

//支付（弃用）
+ (void)showPayWithPrice:(CGFloat)price orderId:(NSString *)orderId payWay:(NSString *)payWay successBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed {
    
    if (!orderId) {
        [XKHudView showErrorMessage:@"订单id不能为空"];
        return;
    }
    if (!payWay) {
        [XKHudView showErrorMessage:@"支付方式不能为空"];
        return;
    }
    
    [XKPayAlertSheetView showWithResultBlock:^(NSInteger index) {
        //根据index 判断是那种支付方式
        NSDictionary *dic = @{@"payAmount":@(price),
                              @"orderId":orderId,
                              @"payChannel":@"ALI_PAY"};
        
        [self payForTreadingAreaOrderWithParmDic:dic success:^(id data) {
            success(data);
        } failed:^(NSString *failedReason, NSInteger code) {
            failed(failedReason);
        }];
    }];
}


+ (void)payForTreadingAreaOrderWithParmDic:(NSDictionary *)dic success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [XKHudView showLoadingTo:nil animated:YES];

    [HTTPClient postEncryptRequestWithURLString:GetMallOrderPaylUrl
                                timeoutInterval:20.f
                                     parameters:dic
                                        success:^(id responseObject) {
                                            [XKHudView hideAllHud];
                                            success(responseObject);
                                        } failure:^(XKHttpErrror *error) {
                                            [XKHudView hideAllHud];
                                            failed(error.message,error.code);
                                        }];
}


@end
