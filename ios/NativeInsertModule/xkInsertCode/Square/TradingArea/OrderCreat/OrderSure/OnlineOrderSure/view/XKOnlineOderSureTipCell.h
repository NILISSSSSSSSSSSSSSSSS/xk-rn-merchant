//
//  XKOnlineOderSureTipCell.h
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OrderValueBlock)(NSString *phoneNum, NSString *tipStr, BOOL refresh);

@interface XKOnlineOderSureTipCell : UITableViewCell

@property (nonatomic, copy  ) OrderValueBlock  orderValueBlock;

- (void)setValueWithPhoneNum:(NSString *)phoneNum tipStr:(NSString *)tipStr;

@end
