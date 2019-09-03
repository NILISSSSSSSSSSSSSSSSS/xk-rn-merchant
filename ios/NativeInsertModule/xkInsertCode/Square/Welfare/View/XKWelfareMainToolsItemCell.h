//
//  XKWelfareMainToolsItemCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKWelfareMainToolsItemCell : UICollectionViewCell
- (void)setTitle:(NSString *)title iconName:(NSString *)iconName;
- (void)setTitle:(NSString *)title iconUrl:(NSString *)url;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@end

NS_ASSUME_NONNULL_END
