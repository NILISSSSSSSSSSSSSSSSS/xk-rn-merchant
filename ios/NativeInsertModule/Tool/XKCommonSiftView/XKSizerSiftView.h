//
//  XKSizerSiftView.h
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SizerSiftViewDelegate <NSObject>

- (void)siftTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath selectedTitle:(NSString *)selectedTitle;

@end


@interface XKSizerSiftView : UIView

@property (nonatomic, weak) id<SizerSiftViewDelegate> delegate;

- (void)setDataSource:(NSArray *)dataSource;

@end
