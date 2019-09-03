/*******************************************************************************
 # File        : XKRedPointItemForNewFriend.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/27
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKRedPointItemForNewFriend.h"

@implementation XKRedPointItemForNewFriend

/**重新计算红点是否存在 包括了状态切换和界面逻辑*/
- (void)resetItemRedPointStatus {
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/hasUnReadApplyRecord/1.0" timeoutInterval:20 parameters:nil success:^(id responseObject) {
        NSDictionary *dic = [responseObject xk_jsonToDic];
        BOOL has = [dic[@"status"] boolValue];
        if (has) {
            self.hasRedPoint = YES;
        } else {
            self.hasRedPoint = NO;
        }
        [self updateUIForSepical];
    } failure:^(XKHttpErrror *error) {
        
    }];
}


- (void)updateUIForSepical {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:XKRedPointItemForNewFriendNoti object:nil];
        EXECUTE_BLOCK(self.redStatusChange,self);
    });
}


@end
