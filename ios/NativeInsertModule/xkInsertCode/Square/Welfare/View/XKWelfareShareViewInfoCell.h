//
//  XKWelfareShareViewInfoCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKGoodsShareModel.h"
#import "XKWelfareShareModel.h"
@interface XKWelfareShareViewInfoCell : UICollectionViewCell
//自营
- (void)updateInfoWithItem:(XKGoodsShareModel *)model;
//福利
- (void)updateWelfareInfoWithItem:(XKWelfareShareModel *)model;
@end
