//
//  XKGroupChatManageAddBottomView.h
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/27.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKGroupChatManageAddBottomView : UIView
@property (nonatomic, strong)UIButton *choseBtn;

/**确定按钮的回调*/
@property(nonatomic, copy) void(^sureBlock)(UIButton *sender);
/**全选按钮的回调*/
@property(nonatomic, copy) void(^allChoseBlock)(UIButton *sender);
@end

NS_ASSUME_NONNULL_END
