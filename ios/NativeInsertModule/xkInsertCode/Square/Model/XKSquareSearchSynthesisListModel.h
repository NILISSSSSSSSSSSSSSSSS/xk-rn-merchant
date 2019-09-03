//
//  XKSquareSearchSynthesisListModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface XKSquareSearchSynthesisListCategoriesItem :NSObject
@property (nonatomic , copy) NSString              * categoryCode;

@end


@interface XKSquareSearchSynthesisListDataItem :NSObject
@property (nonatomic , strong) NSArray <XKSquareSearchSynthesisListCategoriesItem *>              * categories;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * drawStatus;
@property (nonatomic , copy) NSString              * drawType;
@property (nonatomic , copy) NSString              *  expectDrawTime;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , assign) NSInteger              isRecommend;
@property (nonatomic , assign) NSInteger              joinCount;
@property (nonatomic , copy) NSString              * mainUrl;
@property (nonatomic , assign) NSInteger              maxStake;
@property (nonatomic , assign) NSInteger              perPrice;
@property (nonatomic , assign) NSInteger              runningDate;
@property (nonatomic , copy) NSString              * sequenceId;
@property (nonatomic , copy) NSString              * showSkuName;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString              * xKModule;
@property (nonatomic , copy) NSString              * cover;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , copy  ) NSString              * distance;
@property (nonatomic , assign) NSInteger              monthVolume;//月销量
@property (nonatomic , assign) NSInteger              saleM;
@property(nonatomic, assign) NSInteger          price;              //价格
@property (nonatomic , copy) NSString              * ID;


@end

@interface XKSquareSearchSynthesisListModel : NSObject
@property (nonatomic , strong) NSArray <XKSquareSearchSynthesisListDataItem *>              * data;
@property (nonatomic , assign) NSInteger              total;

@end

NS_ASSUME_NONNULL_END
