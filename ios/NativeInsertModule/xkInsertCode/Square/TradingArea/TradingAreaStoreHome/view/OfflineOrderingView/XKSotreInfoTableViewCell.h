//
//  XKSotreInfoTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATMShop;

@protocol StoreImageDelegate <NSObject>

- (void)storeImgCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr;

@end

@interface XKSotreInfoTableViewCell : UITableViewCell

@property (nonatomic, weak  ) id<StoreImageDelegate> delegate;

- (void)setValueWithModel:(ATMShop *)model;

@end
