/*******************************************************************************
 # File        : XKTabBarMsgRedPointItem.m
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

#import "XKTabBarMsgRedPointItem.h"
#import "CYLTabBarController.h"
#import "xkMerchantEmitterModule.h"

@interface XKTabBarMsgRedPointItem()
@property(nonatomic, assign) BOOL hasRedPoint;
@end

@implementation XKTabBarMsgRedPointItem


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - protocol 重新设置红点状态 遍历齐下管理的item
- (void)resetTabBarRedPointStatus {
    NSArray *items = [self allItems];
    BOOL hasRed = NO;
    for (id<XKRedPointChildItemProtocol> item in items) {
        if ([item getItemPointStatus]) {
            hasRed = YES;
            break;
        }
    }
    self.hasRedPoint = hasRed;
    [self updateTabBarRedPointUI];
}

- (void)resetTabBarRedPointStatusWithCalculate {
    NSArray *items = [self allItems];
    for (id<XKRedPointChildItemProtocol> item in items) {
        [item resetItemRedPointStatus];
    }
}

#pragma mark - protocol
- (BOOL)getTabBarRedPointStatus {
    return self.hasRedPoint;
}

#pragma mark - protocol 界面逻辑
- (void)updateTabBarRedPointUI {
    [xkMerchantEmitterModule friendRedPointStatusChange:self.hasRedPoint];
}

#pragma mark - protocol 清空红点
- (void)cleanRedPoint {
    NSArray *items = [self allItems];
    for (id<XKRedPointChildItemProtocol> item in items) {
        [item cleanItemRedPoint];
    }
}

- (NSArray *)allItems {
    return @[self.imItem,self.friendCicleItem,self.sysItem,self.newFriendItem];
}

- (XKRedPointItemForIM *)imItem {
    if (!_imItem) {
        __weak typeof(self) weakSelf = self;
        _imItem = [[XKRedPointItemForIM alloc] init];
        [_imItem setRedStatusChange:^(XKRedPointItem *item) {
            [weakSelf resetTabBarRedPointStatus];
        }];
    }
    return _imItem;
}

- (XKRedPointForFriendCircle *)friendCicleItem {
    if (!_friendCicleItem) {
        __weak typeof(self) weakSelf = self;
        _friendCicleItem = [[XKRedPointForFriendCircle alloc] init];
        [_friendCicleItem setRedStatusChange:^(XKRedPointItem *item) {
            [weakSelf resetTabBarRedPointStatus];
        }];
    }
    return _friendCicleItem;
}

- (XKRedPointItemForSys *)sysItem {
    if (!_sysItem) {
        __weak typeof(self) weakSelf = self;
        _sysItem = [[XKRedPointItemForSys alloc] init];
        [_sysItem setRedStatusChange:^(XKRedPointItem *item) {
            [weakSelf resetTabBarRedPointStatus];
        }];
    }
    return _sysItem;
}

- (XKRedPointItemForNewFriend *)newFriendItem {
    if (!_newFriendItem) {
        __weak typeof(self) weakSelf = self;
        _newFriendItem = [[XKRedPointItemForNewFriend alloc] init];
        [_newFriendItem setRedStatusChange:^(XKRedPointItem *item) {
            [weakSelf resetTabBarRedPointStatus];
        }];
    }
    return _newFriendItem;
}

@end
