//
//  XKEmotionKeyBoradManager.m
//  XKSquare
//
//  Created by william on 2018/12/8.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKEmotionKeyBoradManager.h"
#import "XKSticker.h"
#import "UILabel+xkEmoji.h"
@implementation XKEmotionKeyBoradManager
+ (instancetype)sharedInstance
{
    static XKEmotionKeyBoradManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XKEmotionKeyBoradManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initStickers];
    }
    return self;
}

- (void)initStickers
{
    NSString *path = [NSBundle.mainBundle pathForResource:@"XKEmotionInfo" ofType:@"plist"];
    if (!path) {
        return;
    }
    NSMutableArray *resultArr = [NSMutableArray array];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSArray *array = dict[@"Emotions"];
    for (NSDictionary *d in array) {
        XKSticker *stiker = [XKSticker yy_modelWithDictionary:d];
        [resultArr addObject:stiker];
    }
    NSLog(@"");
    self.allStickers = resultArr;
}

-(NSString *)emoticonNameByDesc:(NSString *)desc{
    if (!self.allStickers) {
        [self initStickers];
    }
    NSString *imageName = [UILabel mapExp].expressionMap[desc];
    if (imageName) {
        return imageName;
    }
    else{
        return nil;
    }
}
@end
