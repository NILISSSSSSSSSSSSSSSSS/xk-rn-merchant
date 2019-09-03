//
//  XKVideoAdvertisementViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoGoodsModel;
@class XKVideoAdvertisementViewController;

@protocol XKVideoAdvertisementViewControllerDelegate <NSObject>

- (void)viewController:(XKVideoAdvertisementViewController *)viewController clickGotoGoodsButtonWithModel:(XKVideoGoodsModel *)model;
- (void)viewController:(XKVideoAdvertisementViewController *)viewController clickPlaceAnOrderButtonWithModel:(XKVideoGoodsModel *)model;

@end

@interface XKVideoAdvertisementViewController : UIViewController

@property (nonatomic, weak) id<XKVideoAdvertisementViewControllerDelegate> delegate;

- (void)configVideoAdvertisementViewControllerWithRecomGoodsModel:(NSArray<XKVideoGoodsModel *> *)modelArr;

@end
