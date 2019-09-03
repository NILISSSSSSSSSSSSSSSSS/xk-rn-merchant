//
//  XKVideoSearchHeader.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoreBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchHeader : UIView

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *moreLab;

@property (nonatomic, strong) UIImageView *arrowImgView;

@property (nonatomic, copy) MoreBlock moreBlock;

- (void)setMoreViewHidden:(BOOL) hidden;

- (void)setDownLineHidden:(BOOL) hidden;

@end

NS_ASSUME_NONNULL_END
