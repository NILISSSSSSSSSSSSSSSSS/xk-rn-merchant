//
//  XKChatGiveGiftViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKChatGiveGiftViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *priceLabel;

- (void)selectedStatus:(BOOL)selected;

@end
