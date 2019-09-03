/*******************************************************************************
 # File        : XKSensitiveFilterHelper.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2019/4/1
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>
#define EXIST @"isExists"
@interface XKSensitiveFilterHelper : NSObject

+ (instancetype)shared;


@property (nonatomic,assign) BOOL isFilterClose;

/**敏感词过滤 针对可友圈*/
- (NSString *)filter:(NSString *)str;

/**敏感词过滤,针对商品商圈评价*/
- (NSString *)filterForBcircle:(NSString *)str;

/**敏感词过滤,针对小视频*/
- (NSString *)filterForVideo:(NSString *)str;

@end
