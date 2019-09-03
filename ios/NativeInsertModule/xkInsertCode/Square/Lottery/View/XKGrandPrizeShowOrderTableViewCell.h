//
//  XKGrandPrizeShowOrderTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKGrandPrizeShowOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UILabel *downLine;


@property (nonatomic, copy) NSArray *imgs;

@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, copy) void(^expandBtnBlock)(void);

@property (nonatomic, copy) void(^imgViewTapBlock)(NSString *imgUrl);

// 折叠行数
@property (nonatomic, assign) NSUInteger foldedNumOfLines;
// 展开行数
@property (nonatomic, assign) NSUInteger expandedNumOfLines;

@end

NS_ASSUME_NONNULL_END

