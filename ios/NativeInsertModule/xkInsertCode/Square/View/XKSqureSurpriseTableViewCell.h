//
//  XKSqureSurpriseTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PersonalTailorBlock)(UIButton *sender);


@interface XKSqureSurpriseTableViewCell : UITableViewCell

@property (nonatomic, copy  ) PersonalTailorBlock  personalTailorBlock;

@end
