//
//  XKCollectionClassifyModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/19.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface XKCollectionClassifyDataItem :NSObject
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              parentCode;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              updatedAt;

@end
@interface XKCollectionClassifyModel : NSObject
@property (nonatomic , strong) NSArray <XKCollectionClassifyDataItem *>              * data;
@property (nonatomic , assign) BOOL              empty;
@property (nonatomic , assign) NSInteger              total;

@end

NS_ASSUME_NONNULL_END
