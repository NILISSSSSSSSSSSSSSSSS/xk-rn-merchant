//
//  M80AttributedLabel+XKIM.m
//  XKSquare
//
//  Created by william on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "M80AttributedLabel+XKIM.h"
#import "XKIMInputEmoticonParser.h"
#import "XKEmotionKeyBoradManager.h"
@implementation M80AttributedLabel (XKIM)
- (void)xkim_setText:(NSString *)text
{
    [self setText:@""];
    NSArray *tokens = [[XKIMInputEmoticonParser currentParser] tokens:text];
    for (XKIMInputTextToken *token in tokens)
    {
        if (token.type == XKIMInputTokenTypeEmoticon)
        {
            NSString *path = [NSBundle.mainBundle pathForResource:@"XKEmotionResource" ofType:@"bundle"];

            NSString *imageName = [[XKEmotionKeyBoradManager sharedInstance] emoticonNameByDesc:token.text];
            UIImage *image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]];
            if (image)
            {
                [self appendImage:image
                          maxSize:CGSizeMake(18, 18)];
            }
        }
        else
        {
            NSString *text = token.text;
            [self appendText:text];
        }
    }
}
@end
