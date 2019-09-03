//
//  XKMallCategotyListModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallCategoryListModel.h"

@implementation MallIconItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end

@implementation ChildrenObj

@end

@implementation ChildrenItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children" : [ChildrenObj class],
             };
}
@end

@implementation XKMallCategoryListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children" : [ChildrenItem class],
             @"notFixed" : [MallIconItem class],
             @"fixed" : [MallIconItem class]
             };
}


+ (void)requestMallCategotyListSuccess:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed {
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:GetMallCategoryListUrl];
    [HTTPClient getEncryptRequestWithURLString:GetMallCategoryListUrl timeoutInterval:20.f parameters:nil success:^(id responseObject) {
        [XKHudView hideAllHud];
        NSArray *dataArr = [NSArray yy_modelArrayWithClass:[XKMallCategoryListModel class] json:responseObject];
        if(dataArr == nil) {//没有数据更新 或无数据
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = nil;
            if ([fileManager fileExistsAtPath:path isDirectory:nil]) { //本地有缓存
                NSData *data = [NSData dataWithContentsOfFile:path];
                NSString *cacheJSON = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&error];
                dataArr = [NSArray yy_modelArrayWithClass:[XKMallCategoryListModel class] json:cacheJSON];
                }
            } else {//有数据 刷新本地数据
            //缓存的位置
            [responseObject writeToFile:path atomically:YES];
        }
        success(dataArr);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)requestNewMallIconListSuccess:(void(^)(XKMallCategoryListModel *model))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetMallIconListUrl timeoutInterval:20.f parameters:nil success:^(id responseObject) {
        [XKHudView hideAllHud];
        NSArray *iconArr = [NSArray yy_modelArrayWithClass:[MallIconItem class] json:responseObject];
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:iconArr];
        for (MallIconItem *item in iconArr) {
            if ([item.status isEqualToString:@"del"]) {
                [tmpArr removeObject:item];
            }
        }
        iconArr = tmpArr.copy;
        NSMutableArray *fixedArr =  [NSMutableArray array];
        NSMutableArray *notFixedArr =  [NSMutableArray array];
        for (MallIconItem *item in iconArr) {
            if (item.moveEnable == 1) {
                [notFixedArr addObject:item];
            } else {
                [fixedArr addObject:item];
            }
        }
        XKMallCategoryListModel *model =  [XKMallCategoryListModel new];
        model.fixed = fixedArr.copy;
        model.notFixed = notFixedArr.copy;
        success(model);
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
