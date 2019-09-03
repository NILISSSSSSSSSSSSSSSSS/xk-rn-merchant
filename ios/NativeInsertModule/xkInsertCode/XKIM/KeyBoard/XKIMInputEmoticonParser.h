//
//  XKIMInputEmoticonParser.h
//  XKSquare
//
//  Created by william on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    XKIMInputTokenTypeText,
    XKIMInputTokenTypeEmoticon,
    
} XKIMInputTokenType;

@interface XKIMInputTextToken : NSObject
@property (nonatomic,copy)      NSString    *text;
@property (nonatomic,assign)    XKIMInputTokenType   type;
@end

@interface XKIMInputEmoticonParser : NSObject
+ (instancetype)currentParser;
- (NSArray *)tokens:(NSString *)text;
@end

