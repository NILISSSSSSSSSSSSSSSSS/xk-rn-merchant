//
//  XKJumpWebViewController.h
//  XKSquare
//
//  Created by hupan on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseWKWebViewController.h"

@interface XKJumpWebViewController : BaseWKWebViewController

// 如果传入的是url，则加载url
@property (nonatomic, copy) NSString *url;
// 如果传入的是html，则渲染html
@property (nonatomic, copy) NSString *html;


@end
