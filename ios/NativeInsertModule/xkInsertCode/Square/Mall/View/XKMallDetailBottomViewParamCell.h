//
//  XKMallDetailBottomViewParamCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallGoodsDetailViewModel.h"
@interface XKMallDetailBottomViewParamCell : UITableViewCell
@property(nonatomic, copy)void(^choseIndexBlock)(NSInteger index);
- (void)updateDataWithAttr:(XKMallGoodsDetailAttrListItem *)item;
@end
