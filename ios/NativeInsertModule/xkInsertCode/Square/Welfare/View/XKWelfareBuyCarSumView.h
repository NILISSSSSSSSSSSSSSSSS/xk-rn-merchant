//
//  XKWelfareBuyCarSumView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKInfoInputView.h"
#import "XKMallBuyCarViewModel.h"
@interface XKWelfareBuyCarSumView : UIView
@property (nonatomic, strong)UIButton *addBtn;
@property (nonatomic, strong)UIButton *subBtn;
@property (nonatomic, strong)UITextField *inputTf;
@property (nonatomic, strong)XKMallBuyCarItem  *model;
@property (nonatomic, copy)void(^addBlock)(UIButton *sender);
@property (nonatomic, copy)void(^subBlock)(UIButton *sender);
@property (nonatomic, copy)void(^textFieldChangeBlock)(NSString *string);

@end
