//
//  XKMallGoodsListModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XKMallListViewModel : NSObject
@property (nonatomic , copy) NSString      *name;
@property (nonatomic , copy) NSString      *keyword;
@property (nonatomic , copy) NSString      *type;
@property (nonatomic , assign) NSInteger   isDesc;
@property (nonatomic , assign) NSInteger   page;
@property (nonatomic , assign) NSInteger   limit;
@property (nonatomic , assign) NSInteger   category;
@property (nonatomic , assign) NSTimeInterval   timestamp;
@end

@interface MallGoodsListCategories :NSObject
@property (nonatomic , copy) NSString              * cc_fri;
@end

@interface MallGoodsListItem :NSObject
@property (nonatomic , assign) NSInteger              price;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , strong) MallGoodsListCategories   * categories;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * video;
@property (nonatomic , copy) NSString              * sku;
@property (nonatomic , copy) NSString              * skuName;
@property (nonatomic , assign) NSInteger              saleMonQ;
@property (nonatomic , assign) NSInteger              saleQ;
@property (nonatomic, copy) NSString               *sharePath;
@property (nonatomic, copy) NSString               *recommendMessage;
@end

@interface XKMallGoodsListModel : NSObject
@property (nonatomic , strong) NSArray <MallGoodsListItem *>              * data;
@property (nonatomic , assign) NSInteger              total;

+ (void)requestMallGoodsListWithParam:(NSDictionary *)dic Success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed;

+ (void)requestMallRecommendGoodsListWithParam:(NSDictionary *)dic Success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed;
@end
