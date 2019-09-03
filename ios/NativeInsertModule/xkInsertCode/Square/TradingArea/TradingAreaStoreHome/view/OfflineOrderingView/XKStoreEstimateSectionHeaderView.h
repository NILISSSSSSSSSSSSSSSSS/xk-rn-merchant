//
//  XKStoreEstimateSectionHeaderView.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EstimateHeaderType_shop,
    EstimateHeaderType_goods,
} EstimateHeaderType;

typedef void(^MoreBlock)(void);
typedef void(^LabelsBlock)(NSInteger index);

@interface XKStoreEstimateSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy  ) MoreBlock         moreBlock;
@property (nonatomic, copy  ) LabelsBlock       labelsBlock;
@property (nonatomic, strong) UIView           *backView;

- (CGFloat)configLabelsWithDataSource:(NSArray *)array type:(EstimateHeaderType)type;
- (void)setTitleName:(NSString *)name titleColor:(UIColor *)color titleFont:(UIFont *)font;
- (void)setStarViewValue:(NSInteger)grade;
- (void)hiddenLineView:(BOOL)hidden;
- (void)hiddenToolView:(BOOL)hidden;

@end
