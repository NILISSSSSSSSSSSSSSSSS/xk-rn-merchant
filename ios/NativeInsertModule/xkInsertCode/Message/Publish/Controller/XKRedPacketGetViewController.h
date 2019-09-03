//
//  XKRedPacketGetViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKRedPacketGetViewController : BaseViewController
@property (nonatomic, copy) NSString  *titleStr;

/**
 领取状态  仅供测试   0 领完了 1 没领完
 */
@property (nonatomic, assign) NSInteger  type;
@end

NS_ASSUME_NONNULL_END
