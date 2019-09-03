//
//  XKMallMainSingleCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallListViewModel.h"
@interface XKMallMainSingleCell : UICollectionViewCell
- (void)bindData:(MallGoodsListItem *)item;
@end
