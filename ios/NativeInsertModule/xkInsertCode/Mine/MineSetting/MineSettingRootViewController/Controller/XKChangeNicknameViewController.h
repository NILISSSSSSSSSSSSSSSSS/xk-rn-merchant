//
//  XKChangeNicknameViewController.h
//  XKSquare
//
//  Created by Lin Li on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^nickNameBlock)(NSString *nickName);

@interface XKChangeNicknameViewController : BaseViewController
@property (nonatomic, assign) NSInteger limitNum;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *rightBtnText;
@property (nonatomic, copy) NSString *placeHolder;
/**禁止自动返回*/
@property(nonatomic, assign) BOOL forbidAutoPop;
/**未修改是否置灰*/
@property(nonatomic, assign) BOOL grayIfNoChange;
/**0 是作为设置昵称  1是作为修改备注 */
@property(nonatomic, assign) NSInteger useType;
@property (nonatomic, copy) nickNameBlock block;
- (void)setNicknameBlock:(nickNameBlock)block;
@end
