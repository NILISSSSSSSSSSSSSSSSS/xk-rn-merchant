//
//  XKMyProductionCollectionViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoDisplayVideoListItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKMyProductionCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^choseBlock)(void);

- (void)configCellWithVideoModel:(XKVideoDisplayVideoListItemModel *) video;

- (void)setChoseBtnSelected:(BOOL) selected;

@end

NS_ASSUME_NONNULL_END
