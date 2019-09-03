//
//  XKChatGiveGiftViewLayout.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKChatGiveGiftViewLayout.h"

@interface XKChatGiveGiftViewLayout ()

@property (strong, nonatomic) NSMutableArray *allAttributes;

@end

@implementation XKChatGiveGiftViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.allAttributes = [NSMutableArray array];
    NSInteger sections = [self.collectionView numberOfSections];
    for (int i = 0; i < sections; i++) {
        NSMutableArray * tmpArray = [NSMutableArray array];
        NSUInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSUInteger j = 0; j < count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [tmpArray addObject:attributes];
         }
        [self.allAttributes addObject:tmpArray];
    }
    
}

- (CGSize)collectionViewContentSize {
//    return CGSizeMake(SCREEN_WIDTH - 30, 450 * SCREEN_WIDTH / 345);
     return [super collectionViewContentSize];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger item = indexPath.item;
    NSUInteger x;
    NSUInteger y;
    [self targetPositionWithItem:item resultX:&x resultY:&y];
    NSUInteger item2 = [self originItemAtX:x y:y];
    NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForItem:item2 inSection:indexPath.section];
    UICollectionViewLayoutAttributes *theNewAttr = [super layoutAttributesForItemAtIndexPath:theNewIndexPath];
    theNewAttr.indexPath = indexPath;
    return theNewAttr;
}

/**
 返回rect中的所有的元素的布局属性 返回的是包含UICollectionViewLayoutAttributes的NSArray

 @param rect 大小
 @return 属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *tmp = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        for (NSMutableArray *attributes in self.allAttributes) {
           for (UICollectionViewLayoutAttributes *attr2 in attributes) {
               if (attr.indexPath.item == attr2.indexPath.item) {
                   [tmp addObject:attr2];
                   break;
               }
           }
        }
    }
    return tmp;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// 根据 item 计算目标item的位置

// x 横向偏移  y竖向偏移

- (void)targetPositionWithItem:(NSUInteger)item resultX:(NSUInteger *)x resultY:(NSUInteger *)y {

    NSUInteger page = item/(self.itemCountPerRow*self.rowCount);
    NSUInteger theX = item % self.itemCountPerRow + page * self.itemCountPerRow;
    NSUInteger theY = item / self.itemCountPerRow - page * self.rowCount;
    if (x != NULL) {
        *x = theX;
    }
    if (y != NULL) {
        *y = theY;
    }
}

// 根据偏移量计算item
- (NSUInteger)originItemAtX:(NSUInteger)x  y:(NSUInteger)y {
    NSUInteger item = x * self.rowCount + y;
    return item;
}
@end
