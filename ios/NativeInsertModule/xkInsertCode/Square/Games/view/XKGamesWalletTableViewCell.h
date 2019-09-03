//
//  XKGamesWalletTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GamesWalletDelegate <NSObject>

- (void)buyButtonClicked:(UIButton *)sender;
- (void)bindCoinButtonClicked:(UIButton *)sender index:(NSInteger)inxex;

@end

@interface XKGamesWalletTableViewCell : UITableViewCell

@property (nonatomic, weak  ) id<GamesWalletDelegate> delegate;

@end
