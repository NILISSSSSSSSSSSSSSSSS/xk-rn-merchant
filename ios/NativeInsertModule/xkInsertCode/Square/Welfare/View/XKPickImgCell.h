//
//  XKPickImgCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKPickImgCell : UICollectionViewCell

@property (nonatomic, copy) void(^deleteClick)(UIButton *sender,NSIndexPath *indexPath);
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
