//
//  XKOnlineOderSureChooseWayCell.h
//  XKSquare
//
//  Created by hupan on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WayChooseBlock)(NSInteger wayType, NSString *address, NSString *phoneNumber, NSString *time);
typedef void(^ChooseAddressBlock)(void);
typedef void(^ChooseTimeBlock)(void);

@interface XKOnlineOderSureChooseWayCell : UITableViewCell

@property (nonatomic, copy  ) WayChooseBlock     wayChooseBlock;
@property (nonatomic, copy  ) ChooseAddressBlock chooseAddressBlock;
@property (nonatomic, copy  ) ChooseTimeBlock    chooseTimeBlock;

- (void)setValueWithSendAddr:(NSString *)sendAddr yuyueTime:(NSString *)yuyueTime shopAddr:(NSString *)shopAddr shopPhone:(NSString *)shopPhone;

@end
