//
//  XKSqureConsultDetailViewController.h
//  XKSquare
//
//  Created by hupan on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseWKWebViewController.h"

@interface XKSqureConsultDetailViewController : BaseWKWebViewController

@property (nonatomic, copy  ) NSString   *url;

//分享相关数据
@property (nonatomic, copy  ) NSString   *titleName;
@property (nonatomic, copy  ) NSString   *content;
@property (nonatomic, copy  ) NSString   *imgUrl;

@end
