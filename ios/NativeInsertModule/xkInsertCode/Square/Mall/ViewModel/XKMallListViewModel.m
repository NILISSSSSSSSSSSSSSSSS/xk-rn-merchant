//
//  XKMallGoodsListModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallListViewModel.h"
@implementation XKMallListViewModel

@end

@implementation MallGoodsListCategories

@end

@implementation MallGoodsListItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categories" : [MallGoodsListCategories class],
             };
}
@end

@implementation XKMallGoodsListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [MallGoodsListItem class],
             };
}

+ (void)requestMallGoodsListWithParam:(NSDictionary *)dic Success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed {
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:GetMallGoodsListUrl];
    [HTTPClient getEncryptRequestWithURLString:GetMallGoodsListUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKMallGoodsListModel *model =  [XKMallGoodsListModel yy_modelWithJSON:responseObject];
        if([dic[@"page"] integerValue] == 1) { // 第一页 数据为空时候代表没有缓存数据 用本地数据显示
            if(model == nil) {//没有数据更新 或无数据
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error = nil;
                if ([fileManager fileExistsAtPath:path isDirectory:nil]) { //本地有缓存
                    NSData *data = [NSData dataWithContentsOfFile:path];
                    NSString *cacheJSON = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&error];
                    model =  [XKMallGoodsListModel yy_modelWithJSON:cacheJSON];
                }
            }
        } else {//有数据 刷新本地数据
            //缓存的位置
            [responseObject writeToFile:path atomically:YES];
        }
        success(model.data);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)requestMallRecommendGoodsListWithParam:(NSDictionary *)dic Success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetMallRecommendGoodsListUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKMallGoodsListModel *model =  [XKMallGoodsListModel yy_modelWithJSON:responseObject];
        success(model.data);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

//创建用户保存所有YTKNetwork缓存的文件夹
+ (NSString *)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"LazyRequestCache"];
    return path;
}
@end
