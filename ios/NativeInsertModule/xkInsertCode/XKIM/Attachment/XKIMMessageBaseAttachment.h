//
//  XKIMMessageBaseAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMKit.h>
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,XKIMExtraAttachmentType) {
  XKIMExtraAttachmentNormalType = 0 , //无特殊业务
  XKIMExtraAttachmentSecretTipMsgType = 1 , //密友提醒消息的业务
};


@interface XKIMMessageBaseAttachment : NSObject <NIMCustomAttachment>

// 类型
@property (nonatomic, assign) NSUInteger type;
// 关系
@property (nonatomic, assign) NSInteger group;
// 阅后即焚状态
@property (nonatomic, assign) NSInteger fireStatus;
//
@property (nonatomic, assign) XKIMExtraAttachmentType extraType;


/**
 消息内容（文本消息时，默认为文本内容，其他消息时：格式为[消息类型]），在最近聊天记录使用
 */
@property (nonatomic, copy) NSString *msgContent;

// 从字典直接获取到本模型

+ (instancetype)attachmentWithDict:(NSDictionary *)dict;

- (instancetype)initAttachmentWithDict:(NSDictionary *)dict;

- (NSDictionary *)getEncodeDataDic;
- (NSString *)getAttachmentMsgContent;

@end

NS_ASSUME_NONNULL_END
