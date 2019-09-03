//
//  XKSingleImgCollectionViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallOrderViewModel.h"
@interface XKSingleImgCollectionViewCell : UICollectionViewCell
- (void)bindItem:(MallOrderListObj *)obj;
- (void)setImageWithImgUrl:(NSString *)url;
@end
