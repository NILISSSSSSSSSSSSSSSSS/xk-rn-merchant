//
//  XKOrderDetailDecTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/11/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKOrderDetailDecTableViewCell : UITableViewCell

- (void)setValueWithName:(NSString *)name dec:(NSString *)dec;
- (void)setDecTextColor:(UIColor *)color;
- (void)hiddenLineView:(BOOL)hidden;
@end
