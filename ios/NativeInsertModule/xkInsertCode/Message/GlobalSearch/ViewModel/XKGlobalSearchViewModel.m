/*******************************************************************************
 # File        : XKGlobalSearchViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/6
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGlobalSearchViewModel.h"
#import "XKContactCacheManager.h"
#import "XKIMGlobalMethod.h"
#import <NIMKit.h>
#import "XKIMMessageNomalTextAttachment.h"
#import "XKIMTeamChatManager.h"
#import "XKSecretContactCacheManager.h"

@implementation XKGlobalSearchViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)createDefault {
    _localSearchDataArray = [NSMutableArray array];
    {
        XKGlobalSearchLocalInfo *info =  [XKGlobalSearchLocalInfo new];
        info.type = @"联系人";
        info.dataArray = @[].mutableCopy;
        [_localSearchDataArray addObject:info];
    }
    {
        XKGlobalSearchLocalInfo *info =  [XKGlobalSearchLocalInfo new];
        info.type = @"群聊";
        info.dataArray = @[].mutableCopy;
        [_localSearchDataArray addObject:info];
    }
    {
        XKGlobalSearchLocalInfo *info =  [XKGlobalSearchLocalInfo new];
        info.type = @"聊天记录";
        info.dataArray = @[].mutableCopy;
        [_localSearchDataArray addObject:info];
    }
}

- (void)cleanLocalResult {
    for (XKGlobalSearchLocalInfo *info in _localSearchDataArray) {
        [info.dataArray removeAllObjects];
    }
}

- (BOOL)hasSearchResult {
    for (XKGlobalSearchLocalInfo *info in _localSearchDataArray) {
        if (info.dataArray.count != 0) {
            return YES;
        }
    }
    return NO;
}

- (void)queryloacalDataWithKeyWord {
    NSString *searchKey = self.currentSearchKey;
    __weak typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        // 搜索本地好友
        [self searchFriendComplete:^(NSString *err, NSArray *arr) {
            if ([searchKey isEqual:self.currentSearchKey]) {
                NSMutableArray *dataArray = [self getDataArray:@"联系人"];
                [dataArray removeAllObjects];
                [dataArray addObjectsFromArray:arr];
                dispatch_semaphore_signal(sema);
            }
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        // 搜索群聊
        [self searchGroupChatComplete:^(NSString *err, NSArray *arr) {
            if ([searchKey isEqual:self.currentSearchKey]) {
                NSMutableArray *dataArray = [self getDataArray:@"群聊"];
                [dataArray removeAllObjects];
                if (arr)
                [dataArray addObjectsFromArray:arr];
                dispatch_semaphore_signal(sema);
            }
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        // 搜索聊天记录
        [self searchChatRecordComplete:^(NSString *err, NSArray *arr) {
            if ([searchKey isEqual:self.currentSearchKey]) {
                NSMutableArray *dataArray = [self getDataArray:@"聊天记录"];
                [dataArray removeAllObjects];
                [dataArray addObjectsFromArray:arr];
                dispatch_semaphore_signal(sema);
            }
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.searchResult();
        });
    });
}

- (NSMutableArray *)getDataArray:(NSString *)type {
    if ([type isEqualToString:@"联系人"]) {
        return _localSearchDataArray.firstObject.dataArray;
    } else if ([type isEqualToString:@"群聊"]) {
        return _localSearchDataArray[1].dataArray;
    } else if ([type isEqualToString:@"聊天记录"]) {
        return _localSearchDataArray[2].dataArray;
    }
    return nil;
}

- (void)searchFriendComplete:(void(^)(NSString *err, NSArray *arr))complete{
    if (self.isSecret) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            [XKSecretContactCacheManager configCurrentSecretId:self.secretId];
            NSArray *user = [XKSecretContactCacheManager queryContactsWithKeyWord:self.currentSearchKey];
            EXECUTE_BLOCK(complete,nil,user);
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            NSArray *user = [XKContactCacheManager queryContactsWithKeyWord:self.currentSearchKey];
            EXECUTE_BLOCK(complete,nil,user);
        });
    }
}

- (void)searchChatRecordComplete:(void(^)(NSString *err, NSArray *arr))complete{
    if (self.isSecret) { // 密友没有群聊
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            [XKIMGlobalMethod searchAllSecretFriendTextMessageWithKeyWord:self.currentSearchKey complete:^(NSArray<NIMMessage *> *messages) {
                NSMutableArray *resultArr = @[].mutableCopy;
                for (NIMMessage *msg in messages) {
                  if ([msg.messageObject isKindOfClass:[NIMCustomObject class]]) {
                    NIMCustomObject *object = msg.messageObject;
                    if ([object.attachment isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
                      XKIMMessageNomalTextAttachment *attachment = object.attachment;
                      NSString *text = attachment.msgContent;
                      XKGlobalSearchResult *resut = [XKGlobalSearchResult new];
                      resut.type = XKGlobalSearchResultTypeChat;
                      resut.text = text;
                      resut.user = [XKSecretContactCacheManager queryContactWithUserId:msg.from];
                      NSLog(@"%@%@",msg.senderName,text);
                      resut.message = msg;
                      [resultArr addObject:resut];
                    }
                  }
                }
                EXECUTE_BLOCK(complete,nil,resultArr);
            }];
        });
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [XKIMGlobalMethod searchAllKeFriendTextMessageWithKeyWord:self.currentSearchKey complete:^(NSArray<NIMMessage *> *messages) {
            NSMutableArray *resultArr = @[].mutableCopy;
            for (NIMMessage *msg in messages) {
              if ([msg.messageObject isKindOfClass:[NIMCustomObject class]]) {
                NIMCustomObject *object = msg.messageObject;
                if ([object.attachment isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
                  XKIMMessageNomalTextAttachment *attachment = object.attachment;
                  NSString *text = attachment.msgContent;
                  XKGlobalSearchResult *resut = [XKGlobalSearchResult new];
                  resut.type = XKGlobalSearchResultTypeChat;
                  resut.text = text;
                  resut.user = [XKContactCacheManager queryContactWithUserId:msg.from];
                  NSLog(@"%@%@",msg.senderName,text);
                  resut.message = msg;
                  [resultArr addObject:resut];
                }
              }
            }
            EXECUTE_BLOCK(complete,nil,resultArr);
        }];
    });
}

- (void)searchGroupChatComplete:(void(^)(NSString *err, NSArray *arr))complete{
    if (self.isSecret) {
        // FIXME: sy
        EXECUTE_BLOCK(complete,nil,nil);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [XKIMTeamChatManager getTeamListWithTeamName:self.currentSearchKey complete:^(NSArray<NIMTeam *> *teams) {
            NSMutableArray *resultArr = @[].mutableCopy;
            for (NIMTeam *team in teams) {
                XKGlobalSearchResult *resut = [XKGlobalSearchResult new];
                resut.type = XKGlobalSearchResultTypeGroup;
                resut.text = [team.teamName stringByReplacingOccurrencesOfString:@"[$*$]" withString:@""];
                resut.team = team;
                [resultArr addObject:resut];
            }
            EXECUTE_BLOCK(complete,nil,resultArr);
        }];
    });
}


@end


@implementation XKGlobalSearchLocalInfo

@end

@implementation XKGlobalSearchResult

@end

