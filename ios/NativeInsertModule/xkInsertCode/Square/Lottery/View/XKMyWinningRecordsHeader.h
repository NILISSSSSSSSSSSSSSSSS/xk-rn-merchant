//
//  XKMyWinningRecordsHeader.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKMyWinningRecordsHeader : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *currentCategoryStr;

@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, copy, nullable) void(^categoryBtnBlock)(UIButton *sender);

@property (nonatomic, copy, nullable) void(^dateBtnBlock)(UIButton *sender);

@end

NS_ASSUME_NONNULL_END
