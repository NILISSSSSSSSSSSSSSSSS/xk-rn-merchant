/*******************************************************************************
 # File        : XKRedPointForFriendCircle.m
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

#import "XKRedPointForFriendCircle.h"

@implementation XKRedPointForFriendCircle

/**重新计算红点是否存在 包括了状态切换和界面逻辑*/
- (void)resetItemRedPointStatus {
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/friendCircleHasUnReadMsg/1.0" timeoutInterval:20 parameters:nil success:^(id responseObject) {
        NSDictionary *dic = [responseObject xk_jsonToDic];
        BOOL has = [dic[@"status"] boolValue];
        if (has) {
            self.newsTalkStatus = YES;
        } else {
            self.newsTalkStatus = NO;
        }
        self.hasRedPoint = self.newsTalkStatus || self.unReadTipStatus;
        [self updateUIForSepical];
    } failure:^(XKHttpErrror *error) {

    }];

    [HTTPClient postEncryptRequestWithURLString:@"im/ua/friendCircleUnReadMsgCount/1.0" timeoutInterval:20 parameters:nil success:^(id responseObject) {
        XKUnReadTip *tip = [XKUnReadTip yy_modelWithJSON:responseObject];
        if (tip.count == 0) {
            self.unReadTipStatus = NO;
            self.unReadTip = nil;
        } else {
            self.unReadTipStatus = YES;
            self.unReadTip = tip;
        }
        self.hasRedPoint = self.newsTalkStatus || self.unReadTipStatus;
        [self updateUIForSepical];
    } failure:^(XKHttpErrror *error) {

    }];
}


- (void)updateUIForSepical {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:XKRedPointForFriendCircleNoti object:nil];
        EXECUTE_BLOCK(self.redStatusChange,self);
    });
}

- (void)cleanItemRedPoint {
    self.newsTalkStatus = NO;
    self.unReadTipStatus = NO;
    self.hasRedPoint = self.newsTalkStatus || self.unReadTipStatus;
    [self updateUIForSepical];
}

- (void)cleanNewsTalkStatus {
    self.newsTalkStatus = NO;
    self.hasRedPoint = self.newsTalkStatus || self.unReadTipStatus;
    [self updateUIForSepical];
}

- (void)cleanUnReadTipStatus {
    self.unReadTipStatus = NO;
    self.hasRedPoint = self.newsTalkStatus || self.unReadTipStatus;
    [self updateUIForSepical];
}

- (void)setUnReadTipStatus:(BOOL)unReadTipStatus {
    _unReadTipStatus = unReadTipStatus;
    if (unReadTipStatus == NO) {
        self.unReadTip = nil;
    }
}

@end


@implementation XKUnReadTip

@end
