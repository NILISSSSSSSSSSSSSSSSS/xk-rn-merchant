//
//  XKMineCouponPackageCardModel.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKMineCouponPackageCardItem :NSObject

@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, assign) NSInteger invalidTime;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *userMemberId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, assign) NSInteger validTime;
@property (nonatomic, assign) NSInteger cards;
@property (nonatomic, assign) BOOL isSelected; /** 是否已经选取 */
@property (nonatomic, assign) NSInteger selectedCount; /** 选取数量 */

@end

@interface XKMineCouponPackageCardModel : NSObject

@property (nonatomic, strong) NSArray<XKMineCouponPackageCardItem *> *data;
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
