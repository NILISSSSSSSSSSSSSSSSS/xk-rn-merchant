//
//  XKListXkGroupModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKListXkGroupModel :NSObject
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * groupName;
@property (nonatomic , copy) NSString              * groupType;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , assign) NSInteger              index;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSArray              * dataArray;

@end

NS_ASSUME_NONNULL_END
