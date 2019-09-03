//
//  XKIMMessageShareGameAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageShareGameAttachment : XKIMMessageBaseAttachment

// 游戏ID
@property (nonatomic, copy) NSString *gameId;
// 游戏推荐码
@property (nonatomic, copy) NSString *gameRecommendCode;
// 游戏封面
@property (nonatomic, copy) NSString *gameIconUrl;
// 游戏名称
@property (nonatomic, copy) NSString *gameName;
// 星级评分
@property (nonatomic, assign) CGFloat gameScore;
// 游戏描述
@property (nonatomic, copy) NSString *gameDescription;
// 游戏url
@property (nonatomic, copy) NSString *gameUrl;
// 消息来源
@property (nonatomic, copy) NSString *messageSourceName;


@end

NS_ASSUME_NONNULL_END
