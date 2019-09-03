//
//  XKWelfareGoodsDetailBannerCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKWelfareGoodsDetailBannerCell : UITableViewCell
@property (nonatomic, copy) void(^backBtnBlock)(UIButton *sender);
@property (nonatomic, copy) void(^moreBtnBlock)(UIButton *sender);
@end
