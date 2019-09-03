//
//  XKSquareFriendsCricleTool.m
//  XKSquare
//
//  Created by hupan on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareFriendsCricleTool.h"


@implementation XKSquareFriendsCricleTool


+ (void)friendsCircleLikeWithParameters:(NSDictionary *)parameters success:(void (^)(NSInteger status))success {
    [XKHUD showLoadingText:nil];
    [HTTPClient postEncryptRequestWithURLString:GetSquareFriendsCircleLikeUrl
                                timeoutInterval:20
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
                                                if ([dic isKindOfClass:[NSDictionary class]]) {
                                                    success([dic[@"status"] integerValue]);
                                                }
                                            }
                                            [XKHUD dismiss];
                                        } failure:^(XKHttpErrror *error) {
                                            [XKHudView showErrorMessage:error.message];
                                            [XKHUD dismiss];
                                        }];

}

+ (void)requestLikeWithDid:(NSString *)did complete:(void (^)(NSString *, BOOL status))complete {

    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"did"] = did;
    [HTTPClient postEncryptRequestWithURLString:GetSquareFriendsCircleLikeUrl
                                timeoutInterval:20
                                     parameters:params
                                        success:^(id responseObject) {
                                            NSDictionary *dataDic = [responseObject xk_jsonToDic];
                                            complete(nil,[dataDic[@"status"] integerValue]);
                                        } failure:^(XKHttpErrror *error) {
                                            complete(error.message,NO);
                                        }];
}

@end
