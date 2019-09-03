//
//  XKMallListSingleCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseCollectionViewCell.h"
#import "XKMallListViewModel.h"
@interface XKMallListSingleCell : XKBaseCollectionViewCell
- (void)bindData:(MallGoodsListItem *)item;
@end
