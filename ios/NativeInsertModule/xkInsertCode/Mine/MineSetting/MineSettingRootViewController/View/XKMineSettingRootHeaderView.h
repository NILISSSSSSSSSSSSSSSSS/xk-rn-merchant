//
//  XKMineSettingRootHeaderView.h
//  XKSquare
//
//  Created by william on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^headerBlock)(void);
@interface XKMineSettingRootHeaderView : UIView

@property(nonatomic,copy) NSString  *cellName;
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UIView      *shadowView;
@property(nonatomic,copy) headerBlock  headerBlock;
@property(nonatomic,copy) headerBlock  bottomCellViewBlock;
- (void)setEditPersonheaderBlock:(headerBlock)block;
- (void)setbottomCellViewBlock:(headerBlock)block;
- (void)loadUI;
@end
