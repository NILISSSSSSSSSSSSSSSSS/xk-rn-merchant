/*******************************************************************************
 # File        : XKOrderEvaModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/5
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKOrderEvaModel.h"
#import "XKUploadMediaInfo.h"
@implementation XKOrderEvaModel

- (instancetype)init {
    if (self = [super init]) {
        self.mediaInfoArr = [NSMutableArray array];
        XKUploadMediaInfo *addInfo = [[XKUploadMediaInfo alloc] init];
        addInfo.isAdd = YES;
        [self.mediaInfoArr addObject:addInfo];
    }
    return self;
}

+ (void)submitOrderCommentWithParm:(NSDictionary *)parmDic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderAddCommentUrl timeoutInterval:20.f parameters:parmDic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)submitGoodsOpinionWithParm:(NSDictionary *)parmDic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetGoodsOpinionUrl timeoutInterval:20.f parameters:parmDic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)submitGoodsChangeWithParm:(NSDictionary *)parmDic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetWelfareGoodsChangeUrl timeoutInterval:20.f parameters:parmDic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}
@end


@implementation XKOrderEvaStarInfo

@end
