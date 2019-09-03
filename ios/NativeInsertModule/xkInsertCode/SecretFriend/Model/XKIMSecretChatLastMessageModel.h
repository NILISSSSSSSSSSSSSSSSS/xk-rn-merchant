//
//  XKIMSecretChatLastMessageModel.h
//  XKSquare
//
//  Created by william on 2018/11/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKIMSecretChatLastMessageModel : NSObject
@property(nonatomic,copy)NSString       *sessionID;
@property(nonatomic,copy)NSString       *messageId;
@property(nonatomic,copy)NSString       *messageObject;
@property(nonatomic,assign)NSTimeInterval       time;
@end
