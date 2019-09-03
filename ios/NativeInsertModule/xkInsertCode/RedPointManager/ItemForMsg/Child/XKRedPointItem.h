/*******************************************************************************
 # File        : XKRedPointItem.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/26
 # Corporation : 水木科技
 # Description :
  红点管理对象
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "XKRedPointProtocol.h"

/*
父类 请继承使用
*/

@interface XKRedPointItem : NSObject<XKRedPointChildItemProtocol>

@property(nonatomic, assign) BOOL hasRedPoint;
/**状态变化的回调 用户通知上层去更新tabBar界面的红点 */
@property(nonatomic, copy) void(^redStatusChange)(XKRedPointItem *item);

@end
