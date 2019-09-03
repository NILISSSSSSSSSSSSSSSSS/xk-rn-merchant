//
//  XKAutoScrollImageItem.h
//  XKSquare
//
//  Created by hupan on 2018/8/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKAutoScrollImageItem : NSObject

@property (nonatomic, strong)  NSString     *title;
@property (nonatomic, strong)  NSString     *image;
@property (nonatomic, assign)  NSInteger    tag;
@property (nonatomic, copy  )  NSString     *link;

- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag;

- (instancetype)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag;

@end
