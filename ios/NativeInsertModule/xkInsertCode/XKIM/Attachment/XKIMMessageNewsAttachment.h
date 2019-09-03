//
//  XKIMMessageNewsAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2019/5/21.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageNewsAttachment : XKIMMessageBaseAttachment
// 资讯图片
@property (nonatomic, copy) NSString *newsImgUrl;
// 资讯标题
@property (nonatomic, copy) NSString *newsTitle;
// 资讯链接
@property (nonatomic, copy) NSString *newsUrl;

@end

NS_ASSUME_NONNULL_END
