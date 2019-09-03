//
//  XKGamesWalletCollectionViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BindCoinBlock)(UIButton *sender);

@interface XKGamesWalletCollectionViewCell : UICollectionViewCell


@property (nonatomic, copy  ) BindCoinBlock   bindCoinBlock;

- (void)hiddenLineView:(BOOL)hidden;

@end
