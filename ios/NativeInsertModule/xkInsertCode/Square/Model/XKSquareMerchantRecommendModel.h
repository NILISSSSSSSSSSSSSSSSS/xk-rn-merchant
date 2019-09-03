//
//  XKSquareMerchantRecommendModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MerchantRecommendItem;
@class IndustryItem;

@interface XKSquareMerchantRecommendModel : NSObject

@property (nonatomic , strong) NSArray <MerchantRecommendItem *>   * data;
@property (nonatomic , assign) BOOL                                  empty;
@property (nonatomic , assign) NSInteger                             total;

@end



@interface MerchantRecommendItem :NSObject


@property (nonatomic , copy  ) NSString                  * cover;
@property (nonatomic , copy  ) NSString                  * code;
@property (nonatomic , copy  ) NSString                  * level;
@property (nonatomic , copy  ) NSString                  * distance;
@property (nonatomic , copy  ) NSString                  * name;
@property (nonatomic , copy  ) NSString                  * descriptionStr;
@property (nonatomic , copy  ) NSString                  * avgConsumption;
@property (nonatomic , copy  ) NSString                  * monthVolume;
@property (nonatomic , copy  ) NSString                  * monthPopularity;
@property (nonatomic , strong) NSArray <IndustryItem *>  * industry;
@property (nonatomic , copy  ) NSString                  * itemId;


@end


@interface IndustryItem :NSObject

@property (nonatomic , copy) NSString              * levelOneCode;
@property (nonatomic , copy) NSString              * levelTwoCode;

@end









