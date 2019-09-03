//
//  XKCityCollectionFlowLayout.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCityCollectionFlowLayout.h"

@implementation XKCityCollectionFlowLayout
/// 准备布局
- (void)prepareLayout {
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width - 60)/ 3;
    self.itemSize = CGSizeMake(itemW, 40);
    
    //设置最小间距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 25);
}
@end
