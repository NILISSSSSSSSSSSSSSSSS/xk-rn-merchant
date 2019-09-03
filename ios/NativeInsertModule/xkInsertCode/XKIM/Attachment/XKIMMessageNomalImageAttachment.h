//
//  XKIMMessageNomalImageAttachment.h
//  XKSquare
//
//  Created by william on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

@interface XKIMMessageNomalImageAttachment : XKIMMessageBaseAttachment

// 图片名
@property (nonatomic ,copy) NSString *imgName;
// 图片URL
@property (nonatomic, copy) NSString *imgUrl;
// 图片大小
@property (nonatomic, copy) NSString *imgSize;
// 图片宽
@property (nonatomic, copy) NSString *imgWidth;
// 图片高
@property (nonatomic, copy) NSString *imgHeight;

@end
