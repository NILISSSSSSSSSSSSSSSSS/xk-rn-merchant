//
//  XKAddBankCardCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddBankCardDelegate <NSObject>

- (void)textFieldSelected:(UITextField *)textField;

@end

@interface XKAddBankCardCell : UITableViewCell

@property (nonatomic, weak  ) id<AddBankCardDelegate> delegete;

- (void)setvalueWithDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath;
- (void)hiddenLineView:(BOOL)hiden;

@end
