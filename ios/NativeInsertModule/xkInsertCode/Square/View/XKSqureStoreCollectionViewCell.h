//
//  XKSqureStoreCollectionViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKSqureStoreCollectionViewCell : UICollectionViewCell

- (void)setName:(NSString *)name dec:(NSString *)dec imgUrl:(NSString *)ingUrl;
- (void)hiddenLineView:(BOOL)hidden;

@end
