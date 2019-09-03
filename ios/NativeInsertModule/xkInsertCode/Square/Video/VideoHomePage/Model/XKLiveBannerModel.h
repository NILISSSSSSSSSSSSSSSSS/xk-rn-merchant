//
//  XKLiveBannerModel.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKLiveBannerModelListItem :NSObject
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * img;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * title;

@end


@interface XKLiveBannerModelBody :NSObject
@property (nonatomic , strong) NSArray <XKLiveBannerModelListItem *>              * list;

@end


@interface XKLiveBannerModel :NSObject
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * message;
@property (nonatomic , strong) XKLiveBannerModelBody              * body;

@end
