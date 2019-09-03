//
//  XKFriendsCirclePermissionsCollectionViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKContactModel;

@interface XKFriendsCirclePermissionsCollectionViewCell : UICollectionViewCell

- (void)setValues:(XKContactModel *)model isDelete:(BOOL)isDelete;

@end
