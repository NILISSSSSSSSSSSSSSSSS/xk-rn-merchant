//
//  XKSquareBannerModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, BannerType) {
    BannerType_Square,
    BannerType_Welfare,
    BannerType_Mall,
    BannerType_Area
};
@class BannerTemplateContentModel;



@interface XKSquareBannerModel :NSObject

@property (nonatomic , copy  ) NSString              * cityCode;
@property (nonatomic , copy  ) NSString              * createdAt;
@property (nonatomic , copy  ) NSString              * districtCode;
@property (nonatomic , copy  ) NSString              * bannerId;
@property (nonatomic , copy  ) NSString              * provinceCode;
@property (nonatomic , copy  ) NSString              * status;
@property (nonatomic , copy  ) NSString              * templateName;
@property (nonatomic , copy  ) NSString              * updatedAt;
@property (nonatomic , copy  ) NSString              * bannerModule;

@property (nonatomic , assign) NSInteger              index;
@property (nonatomic , assign) CGFloat                lat;
@property (nonatomic , assign) CGFloat                lng;

@property (nonatomic , strong) BannerTemplateContentModel  *templateContent;

+ (void)requestBannerListWithBannerType:(BannerType )type TypeSuccess:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed;
@end


@class ItemModel;
@interface BannerTemplateContentModel :NSObject

@property (nonatomic , strong) NSArray <ItemModel *>   *arr;
@property (nonatomic , assign) NSInteger               x;
@property (nonatomic , assign) NSInteger               y;

@end


@interface ItemModel :NSObject

@property (nonatomic , copy  ) NSString              * jumpIOS;
@property (nonatomic , copy  ) NSString              * jumpAndroid;
@property (nonatomic , copy  ) NSString              * jumpRN;
@property (nonatomic , copy  ) NSString              * src;
@property (nonatomic , copy  ) NSString              * gridStart;
@property (nonatomic , copy  ) NSString              * gridEnd;
@property (nonatomic , assign) NSInteger               type;//跳转类型 1 h5   2 app
@property (nonatomic , copy  ) NSString              * txt;//提示文字
@property (nonatomic , copy  ) NSString              * position;//提示文字的位置


@end


