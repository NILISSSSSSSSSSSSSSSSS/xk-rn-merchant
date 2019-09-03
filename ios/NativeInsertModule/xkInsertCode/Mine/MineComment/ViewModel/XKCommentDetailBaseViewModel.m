/*******************************************************************************
 # File        : XKCommentDetailBaseViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/31
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommentDetailBaseViewModel.h"
#import "XKReplyBaseInfo.h"
#import "XKCommentForShopsModel.h"
#import "XKCommentForWelfareModel.h"

@interface XKCommentDetailBaseViewModel()
/**商品使用详情model*/
@property(nonatomic, strong) XKCommentForGoodsModel *goodInfoModel;
/**商圈使用详情model*/
@property(nonatomic, strong) XKCommentForShopsModel *shopsInfoModel;
/**商圈使用详情model*/
@property(nonatomic, strong) XKCommentForWelfareModel *welfareInfoModel;
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;

@end

@implementation XKCommentDetailBaseViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createData];
    }
    return self;
}

- (void)createData {
    _page = 1;
    _limit = 20;
    _commentArray = [NSMutableArray array];
}

- (void)requestDetailInfoComplete:(void (^)(NSString *, id))complete {
    NSString *url = [self getUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"id"] = self.commentId;
    [HTTPClient getEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        id model = [[self getInfoClass] yy_modelWithJSON:responseObject];
        [self setDetailInfo:model];
        EXECUTE_BLOCK(complete,nil,@"");
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}


- (void)requestIsRefresh:(BOOL)isRefresh complete:(void(^)(NSString *error, id data))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [params setObject:@(1) forKey:@"page"];
    } else {
        [params setObject:@(self.page + 1) forKey:@"page"];
    }
    [params setObject:@(_limit) forKey:@"limit"];
    params[@"commentId"] = self.commentId;
  
    [self requestListParams:params complete:^(NSString *error, id response) {
        if (error) {
            self.refreshStatus = Refresh_NoNet;
            EXECUTE_BLOCK(complete,error,nil);
        } else {
            if (isRefresh) {
                self.page = 0;
            } else {
                self.page += 1;
            }
            NSDictionary *dic = [response xk_jsonToDic];
            NSArray *array = [NSArray yy_modelArrayWithClass:[XKReplyBaseInfo class] json:dic[@"data"]];
            if (isRefresh) {
                [self.commentArray removeAllObjects];
            }
            if (array.count < self.limit) {
                self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                self.refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [self.commentArray addObjectsFromArray:array];
            EXECUTE_BLOCK(complete,nil,@"");
        }
    }];
}

- (void)requestListParams:(NSMutableDictionary *)params complete:(void(^)(NSString *error,id response))complete {
    [HTTPClient getEncryptRequestWithURLString:[self getListUrl] timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

#pragma mark -  getter setter

- (void)setDetailInfo:(XKCommentBaseInfo *)detailInfo {
    if (self.detailType == XKCommentDetailTypeGoods) {
        _goodInfoModel = (XKCommentForGoodsModel *)detailInfo;
    } else if (self.detailType == XKCommentDetailTypeCicle) {
        _shopsInfoModel = (XKCommentForShopsModel *)detailInfo;
    } else if (self.detailType == XKCommentDetailTypeWelfare) {
        _welfareInfoModel = (XKCommentForWelfareModel *)detailInfo;
    }
}

- (Class)getInfoClass {
    if (self.detailType == XKCommentDetailTypeGoods) {
        return [XKCommentForGoodsModel class];
    } else if (self.detailType == XKCommentDetailTypeCicle) {
        return [XKCommentForShopsModel class];
    } else if (self.detailType == XKCommentDetailTypeWelfare) {
        return [XKCommentForWelfareModel class];
    }
    return nil;
}

- (XKCommentBaseInfo *)detailInfo {
    if (self.detailType == XKCommentDetailTypeGoods) {
        return self.goodInfoModel;
    } else if (self.detailType == XKCommentDetailTypeCicle) {
        return self.shopsInfoModel;
    } else if (self.detailType == XKCommentDetailTypeWelfare) {
        return self.welfareInfoModel;
    }
    return nil;
}

- (NSString *)getUrl {
    if (self.detailType == XKCommentDetailTypeGoods) {
        return @"im/ua/mallGoodsCommentDetail/1.0";
    } else if (self.detailType == XKCommentDetailTypeCicle) {
        return @"im/ua/bcleGoodsCommentDetail/1.0";
    } else if (self.detailType == XKCommentDetailTypeWelfare) {
        return @"im/ua/jGoodsCommentDetail/1.0";
    }
    return nil;
}

- (NSString *)getListUrl {
    if (self.detailType == XKCommentDetailTypeGoods) {
        return @"im/ua/mallGoodsCommentReplyList/1.0";
    } else if (self.detailType == XKCommentDetailTypeCicle) {
        return @"im/ua/bcleGoodsCommentReplyList/1.0";
    } else if (self.detailType == XKCommentDetailTypeWelfare) {
        return @"im/ua/jGoodsCommentReplyList/1.0";
    }
    return nil;
}

- (NSString *)getReplyUrl {
    if (self.detailType == XKCommentDetailTypeGoods) {
        return  @"im/ua/mallGoodsCommentReplyCreate/1.0";;
    } else if (self.detailType == XKCommentDetailTypeCicle) {
        return @"im/ua/bcleGoodsCommentReplyCreate/1.0";
    } else if (self.detailType == XKCommentDetailTypeWelfare) {
        return @"im/ua/jGoodsCommentReplyCreate/1.0";
    }
    return nil;
}


@end
