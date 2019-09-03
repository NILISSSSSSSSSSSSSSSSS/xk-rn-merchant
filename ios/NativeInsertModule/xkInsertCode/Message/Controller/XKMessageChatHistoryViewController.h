//
//  XKMessageChatHistoryViewController.h
//  XKSquare
//
//  Created by william on 2018/10/29.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"
#import <NIMSDK/NIMSDK.h>

@interface XKMessageChatHistoryViewController : BaseViewController

@property (nonatomic,strong) NIMSession     *session;

@property (nonatomic,copy) NSString         *secretID;

@end
