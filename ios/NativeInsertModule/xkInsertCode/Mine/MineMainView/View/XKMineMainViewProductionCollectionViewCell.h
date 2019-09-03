//
//  XKMineMainViewProductionCollectionViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListItem;

@protocol XKMineMainViewProductionCollectionViewCellDelegate <NSObject>

- (void)productionCollectionViewCell:(UICollectionViewCell *)cell clickProductionWithModel:(XKVideoDisplayVideoListItemModel *)model;

@end


@interface XKMineMainViewProductionCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<XKMineMainViewProductionCollectionViewCellDelegate> delegate;

- (void)configCellWithVideoListItem:(VideoListItem *)videoListItem;

@end
