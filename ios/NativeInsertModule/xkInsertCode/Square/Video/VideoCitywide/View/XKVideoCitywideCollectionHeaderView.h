//
//  XKVideoCitywideCollectionHeaderView.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoCitywideCollectionHeaderView;

@protocol XKVideoCitywideCollectionHeaderViewDelegate <NSObject>

- (void)headerView:(XKVideoCitywideCollectionHeaderView *)headerView clickBgControl:(UIControl *)control;

@end

@interface XKVideoCitywideCollectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<XKVideoCitywideCollectionHeaderViewDelegate> delegate;

- (void)configHeaderViewWithCityName:(NSString *)cityName;

@end
