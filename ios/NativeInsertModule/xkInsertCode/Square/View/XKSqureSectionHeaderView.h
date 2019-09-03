//
//  XKSqureSectionHeaderView.h
//  XKSquare
//
//  Created by hupan on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKSqureSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *backView;

- (void)setTitleName:(NSString *)name;

@end
