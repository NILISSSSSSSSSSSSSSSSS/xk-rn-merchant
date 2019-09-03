//
//  XKAddGameCoinAccountCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddGameCoinAccountTextFieldDelegate <NSObject>

- (void)textFieldSelected:(UITextField *)textField;
- (void)chooseCardNumber:(NSString *)oldCardNumber;

@end

@interface XKAddGameCoinAccountCell : UITableViewCell

@property (nonatomic, weak  ) id<AddGameCoinAccountTextFieldDelegate> delegete;

- (void)setvalueWithDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath;
- (void)setTextFieldTextAlignment:(NSTextAlignment)textAlignment;
- (void)hiddenLineView:(BOOL)hiden;

@end
