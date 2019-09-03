//
//  XKP2PChatMoreContainerView.h
//  XKSquare
//
//  Created by william on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMKit.h>

@interface XKP2PChatMoreContainerView : UIView
-(id)initWithFrame:(CGRect)frame andSession:(NIMSession *)session;


/**
 当前对话session
 */
@property (nonatomic , strong) NIMSession *session;

@end
