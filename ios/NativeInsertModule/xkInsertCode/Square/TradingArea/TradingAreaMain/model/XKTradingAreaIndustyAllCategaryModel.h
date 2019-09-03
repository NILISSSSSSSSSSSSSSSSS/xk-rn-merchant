//
//  XKTradingAreaIndustyAllCategaryModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IndustyOneLevelItem;
@class IndustyTwoLevelItem;

@interface XKTradingAreaIndustyAllCategaryModel : NSObject

@property (nonatomic , strong) NSArray <IndustyOneLevelItem *>    * oneLevel;
@property (nonatomic , strong) NSArray <IndustyTwoLevelItem *>    * twoLevel;

@end




@interface IndustyOneLevelItem :NSObject

@property (nonatomic , copy  ) NSString              * code;
@property (nonatomic , copy  ) NSString              * createdAt;
@property (nonatomic , copy  ) NSString              * icon;
@property (nonatomic , copy  ) NSString              * itemId;
@property (nonatomic , assign) NSInteger             moveEnable;
@property (nonatomic , copy  ) NSString              * name;
@property (nonatomic , copy  ) NSString              * parentCode;
@property (nonatomic , copy  ) NSString              * sort;
@property (nonatomic , copy  ) NSString              * status;
@property (nonatomic , copy  ) NSString              * updatedAt;

@end


@interface IndustyTwoLevelItem :NSObject

@property (nonatomic , copy  ) NSString              * code;
@property (nonatomic , copy  ) NSString              * createdAt;
@property (nonatomic , copy  ) NSString              * icon;
@property (nonatomic , copy  ) NSString              * itemId;
@property (nonatomic , assign) NSInteger             moveEnable;
@property (nonatomic , copy  ) NSString              * name;
@property (nonatomic , copy  ) NSString              * parentCode;
@property (nonatomic , copy  ) NSString              * sort;
@property (nonatomic , copy  ) NSString              * status;
@property (nonatomic , copy  ) NSString              * updatedAt;

@end






