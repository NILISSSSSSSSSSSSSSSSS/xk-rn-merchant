//
//  NIMSessionMsgDatasource+XKMessageSeparater.h
//  XKSquare
//
//  Created by william on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMSessionMsgDatasource.h"

NS_ASSUME_NONNULL_BEGIN

@interface NIMSessionMsgDatasource (XKMessageSeparater)

- (void)insertMessage:(NIMMessage *)message;

- (BOOL)modelIsExist:(NIMMessageModel *)model;

- (NSArray *)insertMessageModel:(NIMMessageModel *)model index:(NSInteger)index;

- (NSInteger)findInsertPosistion:(NIMMessageModel *)model;
@end

NS_ASSUME_NONNULL_END
