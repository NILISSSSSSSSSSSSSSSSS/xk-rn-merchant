//
//  XKChatGiveGiftViewLayout.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKChatGiveGiftViewLayout : UICollectionViewFlowLayout
//  一行中 cell的个数
@property (nonatomic,assign) NSUInteger itemCountPerRow;
//    一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;

@end
