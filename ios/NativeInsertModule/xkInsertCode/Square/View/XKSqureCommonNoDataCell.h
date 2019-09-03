//
//  XKSqureCommonNoDataCell.h
//  XKSquare
//
//  Created by hupan on 2018/10/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKSqureCommonNoDataCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;

- (void)hiddenLineView:(BOOL)hidden;
- (void)setNoDataTitleName:(NSString *)name;

@end
