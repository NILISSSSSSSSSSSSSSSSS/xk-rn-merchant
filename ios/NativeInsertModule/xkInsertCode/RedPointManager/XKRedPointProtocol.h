//
//  XKRedPointProtocol.h
//  XKSquare
//
//  Created by Jamesholy on 2018/11/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

// 管理tabBar的红点协议
@protocol XKRedPointTabBarItemProtocol <NSObject>

/**重置红点 子项目改变状态后会调用的*/
- (void)resetTabBarRedPointStatus;
/**重置红点 初始化时 会遍历子项目整体计算一次*/
- (void)resetTabBarRedPointStatusWithCalculate;
/**直接取红点状态*/
- (BOOL)getTabBarRedPointStatus;
/**更新红点UI*/
- (void)updateTabBarRedPointUI;
/**代码清除红点 切换用户推出登录可以调用*/
- (void)cleanRedPoint;

@end


// 分别管理单独详细地方红点的协议
@protocol XKRedPointChildItemProtocol <NSObject>

/**重新计算红点是否存在 包括了状态切换和界面逻辑*/
- (void)resetItemRedPointStatus;
/**代码直接清除红点 包括了状态切换和界面逻辑*/
- (void)cleanItemRedPoint;
/**更新指定界面的方法*/
- (void)updateUIForSepical;
/**取红点状态*/
- (BOOL)getItemPointStatus;

@end

