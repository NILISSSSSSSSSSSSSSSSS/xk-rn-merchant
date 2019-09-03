//
//  XKMallOrderPayResultStatusCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKMallOrderPayResultStatusCell : UITableViewCell
@property (nonatomic, copy)void(^orderClickBlock)(UIButton *sender);
@property (nonatomic, copy)void(^mallClickBlock)(UIButton *sender);
@property (nonatomic, copy)void(^groundClickBlock)(UIButton *sender);
@property (nonatomic, copy)void(^payAgainstBlock)(UIButton *sender);
@property (nonatomic, assign) NSInteger  status;
@end
