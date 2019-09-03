//
//  XKSecretMessageFireOtherModel.h
//  XKSquare
//
//  Created by william on 2018/12/7.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseModel.h"
#import <NIMSDK/NIMSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface XKSecretMessageFireOtherModel : BaseModel

@property(nonatomic,strong) NSDate *fireDate;
@property(nonatomic,strong) NIMMessage *message;

@end

NS_ASSUME_NONNULL_END
