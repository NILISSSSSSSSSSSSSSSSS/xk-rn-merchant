//
//  XKSqureHeaderToolCollectionViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/8/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKSqureHeaderToolCollectionViewCell : UICollectionViewCell

- (void)setTitle:(NSString *)title iconName:(NSString *)iconName;
- (void)setTitle:(NSString *)title iconUrl:(NSString *)url;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;

@end
