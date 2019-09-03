//
//  XKEmotionKeyBoradManager.h
//  XKSquare
//
//  Created by william on 2018/12/8.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKSticker.h"
NS_ASSUME_NONNULL_BEGIN

@interface XKEmotionKeyBoradManager : NSObject
+ (instancetype)sharedInstance;
/// 所有的表情包
@property (nonatomic, strong) NSArray<XKSticker *> *allStickers;


-(NSString *)emoticonNameByDesc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
