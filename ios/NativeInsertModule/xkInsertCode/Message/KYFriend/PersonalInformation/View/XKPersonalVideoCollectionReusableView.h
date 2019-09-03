//
//  XKPersonalVideoCollectionReusableView.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKPersonalVideoCollectionReusableView : UICollectionReusableView
/**背景图片偏移量*/
@property(nonatomic, assign) CGFloat backImagYOffset;

/**headerView的高度*/
@property(nonatomic, assign) CGFloat headerViewheight;

/**背景视图*/
@property(nonatomic, strong) UIImageView *backImgView;

/**说说*/
@property(nonatomic, strong) UILabel *shuoshuoLabel;

/**背景图片*/
@property(nonatomic, strong) UIImageView *headerImg;

/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
@end

NS_ASSUME_NONNULL_END
