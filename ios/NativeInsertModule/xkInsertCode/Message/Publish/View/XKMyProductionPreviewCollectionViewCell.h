//
//  XKMyProductionPreviewCollectionViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMyProductionPreviewModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKMyProductionPreviewCollectionViewCell : UICollectionViewCell

- (void)configCellWithPreviewModel:(XKMyProductionPreviewModel *) preview;

- (void)play;

- (void)pause;

@end

NS_ASSUME_NONNULL_END
