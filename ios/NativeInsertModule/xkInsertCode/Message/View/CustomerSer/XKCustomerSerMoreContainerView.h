//
//  XKCustomerSerMoreContainerView.h
//  XKSquare
//
//  Created by william on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMKit.h>
#import "XKIM.h"

@interface XKCustomerSerMoreContainerView : UIView

-(id)initWithFrame:(CGRect)frame andSession:(NIMSession *)session;

- (void)configWithIMType:(XKIMType)IMType;

/**
 当前对话session
 */
@property (nonatomic , strong) NIMSession *session;

@end
