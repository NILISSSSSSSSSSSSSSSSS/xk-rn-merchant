/*******************************************************************************
 # File        : XKCollectViewModel.m
 # Project     : XKSquare
 # Author      : Lin Li
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

#import "XKCollectViewModel.h"
#import "XKCollectGoodsModel.h"
#import "XKCollectWelfareModel.h"
#import "XKCollectGamesModel.h"
#import "XKCollectShopModel.h"
#import "XKCollectVideoModel.h"
#import "XKCollectionClassifyModel.h"
#import "XKGoodsCollectionClassifyModel.h"
#import "XKWelfareCollectionClassifyModel.h"

@interface XKCollectViewModel()
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;
/**类型*/
@property(nonatomic, assign) XKCollectViewModelType viewModelType;


@end
@implementation XKCollectViewModel
- (instancetype)initWithViewModelType:(XKCollectViewModelType)viewModelType XKControllerType:(XKControllerType)controllerType {
    self = [super init];
    if (self) {
        [self createDefaultData];
        self.viewModelType = viewModelType;
        self.controllerType = controllerType;
    }
    return self;
}

- (void)createDefaultData {
    _page = 1;
    _limit = 200;
    _dataArray = [NSMutableArray array];
    
}
- (void)requestIsRefresh:(BOOL)isRefresh typeCode:(NSString *)typeCode complete:(void (^)(NSString *, NSArray *))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [params setObject:@(1) forKey:@"page"];
    } else {
        [params setObject:@(self.page + 1) forKey:@"page"];
        
    }
    [params setObject:@(_limit) forKey:@"limit"];
    [params setObject:@([XKTimeSeparateHelper backTimestampSecondStringWithDate:[NSDate date]].longLongValue) forKey:@"lastUpdatedAt"];
    [params setObject:[XKUserInfo getCurrentUserId] forKey:@"userId"];
    [params setObject:typeCode forKey:@"typeCode"];

    switch (self.viewModelType) {
        case XKCollectGoodsViewModelType:{
            [params setObject:@"mall" forKey:@"xkModule"];
        }
            break;
        case XKCollectShopViewModelType:{
            [params setObject:@"shop" forKey:@"xkModule"];
            [params setObject:@"" forKey:@"typeNameList"];
        }
            break;
        case XKCollectGamesViewModelType:{
            [params setObject:@"game" forKey:@"xkModule"];
            
        }
            break;
        case XKCollectVideoViewModelType:{
            [params setObject:@"live_video" forKey:@"xkModule"];
            
        }
            break;
        case XKCollectWelfareViewModelType:{
            [params setObject:@"jf_mall" forKey:@"xkModule"];
        }
            break;
        default:
            break;
    }
    
    [self requestWithParams:params block:^(NSString *error, NSString *data) {
        if (error) {
            self.refreshStatus = Refresh_NoNet;
            EXECUTE_BLOCK(complete,error,nil);
        } else {
            NSArray *array = [NSArray array];
            switch (self.viewModelType) {
                case XKCollectGoodsViewModelType:{
                    XKCollectGoodsModel *model = [XKCollectGoodsModel yy_modelWithJSON:data];
                    array = model.data;
                }
                    break;
                case XKCollectShopViewModelType:{
                    XKCollectShopModel *model = [XKCollectShopModel yy_modelWithJSON:data];
                    array = model.data;
                }
                    break;
                case XKCollectGamesViewModelType:{
                    XKCollectGamesModel *model = [XKCollectGamesModel yy_modelWithJSON:data];
                    array = model.data;
                }
                    break;
                case XKCollectVideoViewModelType:{
                    XKCollectVideoModel *model = [XKCollectVideoModel yy_modelWithJSON:data];
                    array = model.data;
                }
                    break;
                case XKCollectWelfareViewModelType:{
                    XKCollectWelfareModel *model = [XKCollectWelfareModel yy_modelWithJSON:data];
                    array = model.data;
                }
                    break;
                default:
                    break;
            }
            if (isRefresh) {
                self.page = 1;
            } else {
                self.page += 1;
            }
            
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if (array.count < self.limit) {
                self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                self.refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [self.dataArray addObjectsFromArray:array];
            EXECUTE_BLOCK(complete,nil,array);
        }
    }];
    
}

- (void)requestIsRefresh:(BOOL)isRefresh complete:(void(^)(NSString *error,NSArray *array))complete {
    [self requestIsRefresh:isRefresh typeCode:@"" complete:complete];
}

- (void)requestWithParams:(NSDictionary *)params block:(void(^)(NSString *error,id data))block {
    if (self.controllerType == XKCollectControllerCollectType) {
        [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkFavoriteQPage/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            EXECUTE_BLOCK(block,nil,responseObject);
        } failure:^(XKHttpErrror *error) {
            EXECUTE_BLOCK(block,error.message,nil);
        }];
    }else if (self.controllerType == XKBrowseControllerType){
        [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkHistoryQPage/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            EXECUTE_BLOCK(block,nil,responseObject);
        } failure:^(XKHttpErrror *error) {
            EXECUTE_BLOCK(block,error.message,nil);
        }];
    }
    
}

/**
 分类列表

 @param complete 列表数组
 */
- (void)shopRequestClassifyComplete:(void (^)(NSString *, NSArray *))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(10) forKey:@"limit"];
    [params setObject:@(1) forKey:@"page"];
    [self requestWithClassifyParams:params viewModelType:XKCollectShopViewModelType block:^(NSString *error, id data) {
        XKCollectionClassifyModel *model = [XKCollectionClassifyModel yy_modelWithJSON:data];
        NSArray *array = model.data;
        NSMutableArray *itemArray = [NSMutableArray array];
        for (XKCollectionClassifyDataItem *item in array) {
            [itemArray addObject:item.name];
        }
        EXECUTE_BLOCK(complete,nil,itemArray);
    }];
}

- (void)goodsRequestClassifyComplete:(void (^)(NSString *, NSArray *))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self requestWithClassifyParams:params viewModelType:XKCollectGoodsViewModelType block:^(NSString *error, id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[XKGoodsCollectionClassifyModel class] json:data];
        NSMutableArray * itemArray1 = [NSMutableArray array];

        for (XKGoodsCollectionClassifyModel *model in array) {
            [itemArray1 addObject:model.name];
        }
//        NSMutableArray *itemArray2 = [NSMutableArray array];
//        for (ChildrenItem1 *item in itemArray1) {
//            [itemArray2 addObject:item.name];
//        }
        EXECUTE_BLOCK(complete,nil,itemArray1);
    }];
}
- (void)gamesRequestClassifyComplete:(void (^)(NSString *, NSArray *))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self requestWithClassifyParams:params viewModelType:XKCollectGamesViewModelType block:^(NSString *error, id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[XKGoodsCollectionClassifyModel class] json:data];
        NSMutableArray * itemArray1 = [NSMutableArray array];

        for (XKGoodsCollectionClassifyModel *model in array) {
            [itemArray1 addObject:model.name];
        }
//                NSMutableArray *itemArray2 = [NSMutableArray array];
//                for (ChildrenItem1 *item in itemArray1) {
//                    [itemArray2 addObject:item.name];
//                }
        EXECUTE_BLOCK(complete,nil,itemArray1);
    }];
}

- (void)welfareRequestClassifyComplete:(void (^)(NSString *, NSArray *))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self requestWithClassifyParams:params viewModelType:XKCollectWelfareViewModelType block:^(NSString *error, id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[XKWelfareCollectionClassifyModel class] json:data];
        NSMutableArray * itemArray1 = [NSMutableArray array];

        for (XKWelfareCollectionClassifyModel *model in array) {
            [itemArray1 addObject:model.name];
        }
        EXECUTE_BLOCK(complete,nil,itemArray1);
    }];
}


- (void)requestWithClassifyParams:(NSDictionary *)params viewModelType:(XKCollectViewModelType)viewModelType block:(void(^)(NSString *error,id data))block{
    if (viewModelType == XKCollectGoodsViewModelType) {
        [HTTPClient postEncryptRequestWithURLString:@"goods/ua/queryMallCategory/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            EXECUTE_BLOCK(block,nil,responseObject);
        } failure:^(XKHttpErrror *error) {
            EXECUTE_BLOCK(block,error.message,nil);
        }];
    }else if (viewModelType == XKCollectShopViewModelType) {
        [HTTPClient postEncryptRequestWithURLString:@"sys/ua/industryLevelOneList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            EXECUTE_BLOCK(block,nil,responseObject);
        } failure:^(XKHttpErrror *error) {
            EXECUTE_BLOCK(block,error.message,nil);
        }];
    }
    else if (viewModelType == XKCollectGamesViewModelType) {
        [HTTPClient postEncryptRequestWithURLString:@"goods/ua/queryMallCategory/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            EXECUTE_BLOCK(block,nil,responseObject);
        } failure:^(XKHttpErrror *error) {
            EXECUTE_BLOCK(block,error.message,nil);
        }];
    }
    else if (viewModelType == XKCollectWelfareViewModelType) {
        [HTTPClient postEncryptRequestWithURLString:@"goods/ua/queryJfmallCategory/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            EXECUTE_BLOCK(block,nil,responseObject);
        } failure:^(XKHttpErrror *error) {
            EXECUTE_BLOCK(block,error.message,nil);
        }];
    }
   
}


@end
