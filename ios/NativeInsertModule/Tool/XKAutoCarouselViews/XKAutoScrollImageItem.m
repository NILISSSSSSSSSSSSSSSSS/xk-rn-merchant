//
//  XKAutoScrollImageItem.m
//  XKSquare
//
//  Created by hupan on 2018/8/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAutoScrollImageItem.h"

@implementation XKAutoScrollImageItem


- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag {

    if (self = [super init]) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag {

    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.title = [dict objectForKey:@"title"];
            self.image = [dict objectForKey:@"image"];
            self.tag = [[dict objectForKey:@"tag"] integerValue];
            self.link = [dict objectForKey:@"link"];
            //...
        }
    }
    return self;
}


- (void)dealloc {
    self.title = nil;
    self.image = nil;
    self.link  = nil;
}
@end
