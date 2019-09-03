//
//  XKTranscationDetailHeaderView.h
//  XKSquare
//
//  Created by hupan on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseTimeBlock)(UIButton *sender, NSString *currentTime);


@interface XKTranscationDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy  ) ChooseTimeBlock chooseTimeBlock;

@end
