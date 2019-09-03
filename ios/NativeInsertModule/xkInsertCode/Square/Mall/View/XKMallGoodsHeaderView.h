//
//  XKMallGoodsHeaderView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKMallGoodsHeaderView : UICollectionReusableView
@property (nonatomic, copy) void(^saveBlock)(UIButton *sender);
@property (nonatomic, strong) UIButton  *saveBtn;
- (void)hideRirhtBtn:(BOOL)hide title:(NSString *)title;
@end
