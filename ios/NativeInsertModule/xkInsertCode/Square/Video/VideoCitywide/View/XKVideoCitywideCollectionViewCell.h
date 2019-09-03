//
//  XKVideoCitywideCollectionViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoDisplayVideoListItemModel;

static const CGFloat kVideoCitywideCollectionViewCellAppendHeight = 95.0; /** 除图片外附加Cell高度 */

@interface XKVideoCitywideCollectionViewCell : UICollectionViewCell

- (void)configCellWithVideo:(XKVideoDisplayVideoListItemModel *) video;
- (UIImageView *)getCellMainImageView;

@end
