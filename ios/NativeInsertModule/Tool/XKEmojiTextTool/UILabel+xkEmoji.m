//
//  UILabel+xkEmoji.m
//  MLLabel
//
//  Created by Jamesholy on 2018/12/10.
//

#import "UILabel+xkEmoji.h"
#import "MLExpressionManager.h"
#import "NSString+MLExpression.h"

@interface UILabel ()
// 私有使用
@property(nonatomic, copy) NSString *tmpStr;
@end

@implementation UILabel (xkEmoji)

static MLExpression *_mapExp;
static NSDictionary *_mapping;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [self class];
        SEL originalSelector = @selector(setText:);
        SEL swizzledSelector = @selector(emoji_seText:);
        [self swizzleMethod:targetClass orgSel:originalSelector swizzSel:swizzledSelector];
        
        [self mapExp];
    });
}

+ (MLExpression *)mapExp {
    if (!_mapExp) {
        NSString *path = [NSBundle.mainBundle pathForResource:@"XKEmotionInfo" ofType:@"plist"];
        if (!path) {
            return nil;
        }
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];
        NSArray *array = dict[@"Emotions"];
        NSMutableDictionary *map = @{}.mutableCopy;
        for (NSDictionary *d in array) {
            map[d[@"Desc"]] = d[@"Image"];
        }
        _mapping = map;
        _mapExp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" expressionMap:map bundleName:@"XKEmotionResource"];
    }
    return _mapExp;
}

- (void)emoji_seText:(NSString *)text {
  if ([text containsString:@"["] && [text containsString:@"]"] ) {
    [self setAttributedText:[UILabel getEmojiAttriStr:text]];
    self.tmpStr = text;
  } else {
    [self emoji_seText:text];
  }
}

+ (NSAttributedString *)getEmojiAttriStr:(NSString *)text {
    return [text expressionAttributedStringWithExpression:[UILabel mapExp]];
}

+ (NSString *)getImageNameForExp:(NSString *)exp {
    return _mapping[@"exp"];
}

static const char *xk_emoji_tmpStr = "xk_emoji_tmpStr";
- (void)setTmpStr:(NSString *)tmpStr {
    objc_setAssociatedObject(self, xk_emoji_tmpStr, tmpStr, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)tmpStr {
    return objc_getAssociatedObject(self, xk_emoji_tmpStr);
}


@end
