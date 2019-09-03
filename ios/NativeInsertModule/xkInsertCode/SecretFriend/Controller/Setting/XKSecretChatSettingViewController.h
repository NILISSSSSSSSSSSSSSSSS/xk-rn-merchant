//
//  XKSecretChatSettingViewController.h
//  XKSquare
//
//  Created by william on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"
#import <NIMKit.h>

@interface XKSecretChatSettingViewController : BaseViewController

@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, copy) NSString    *secretID;
@end

