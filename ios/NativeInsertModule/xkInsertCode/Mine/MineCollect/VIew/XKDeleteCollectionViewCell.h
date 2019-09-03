/*******************************************************************************
 # File        : XKDeleteCollectionViewCell.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/14
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface XKDeleteCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) void(^deleteBlock)(void);
@property (nonatomic, copy) void(^scrollBlock)(void);
@property (nonatomic, copy) void(^selectBlock)(UICollectionView *collectionView,NSIndexPath *indexPath);

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *myContentView;

- (void)createUI;
@end
