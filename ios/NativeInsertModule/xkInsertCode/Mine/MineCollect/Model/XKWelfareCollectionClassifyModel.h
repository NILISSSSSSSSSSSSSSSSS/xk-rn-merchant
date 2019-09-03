//
//  XKWelfareCollectionClassifyModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKWelfareCollectionClassifyModel :NSObject
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;

@end

NS_ASSUME_NONNULL_END
