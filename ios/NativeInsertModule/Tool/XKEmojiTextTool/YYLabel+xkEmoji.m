//
//  YYLabel+xkEmoji.m
//  XKSquare
//
//  Created by Jamesholy on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import "YYLabel+xkEmoji.h"
#import "MLExpressionManager.h"
#import "UILabel+xkEmoji.h"

@implementation YYLabel (xkEmoji)

- (NSAttributedString *)getEmojiAttriStr:(NSString *)text {
    return [self expressionAttributedStringWithString:text expression:[UILabel mapExp]];
}

- (NSAttributedString*)expressionAttributedStringWithString:(NSString *)string expression:(MLExpression*)expression {
    
    NSAttributedString *attributedString = nil;
    if ([string isKindOfClass:[NSString class]]) {
        attributedString = [[NSAttributedString alloc]initWithString:string];
    }
    if (attributedString.length<=0) {
        return attributedString;
    }
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    
    //处理表情
    NSArray *results = [expression.expressionRegularExpression matchesInString:attributedString.string
                                                                       options:NSMatchingWithTransparentBounds
                                                                         range:NSMakeRange(0, [attributedString length])];
    //遍历表情，然后找到对应图像名称，并且处理
    NSUInteger location = 0;
    for (NSTextCheckingResult *result in results) {
        NSRange range = result.range;
        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:NSMakeRange(location, range.location - location)];
        //先把非表情的部分加上去
        [resultAttributedString appendAttributedString:subAttrStr];
        
        //下次循环从表情的下一个位置开始
        location = NSMaxRange(range);
        
        NSAttributedString *expressionAttrStr = [attributedString attributedSubstringFromRange:range];
        NSString *imageName = expression.expressionMap[expressionAttrStr.string];
        if (imageName.length>0) {
            //加个表情到结果中
            UIImage *image = nil;
            if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
                NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:expression.bundleName withExtension:nil]];
                image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
            }else{
                NSString *imagePath = [expression.bundleName stringByAppendingPathComponent:imageName];
                image = [UIImage imageNamed:imagePath];
            }
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(0, 0, self.font.pointSize + 2, self.font.pointSize + 2);
            NSMutableAttributedString *attachImageStr = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.size alignToFont:self.font alignment:YYTextVerticalAlignmentCenter];
            
//            [expressionAttrStr enumerateAttributesInRange:NSMakeRange(0, expressionAttrStr.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//                if (attrs.count>0&&range.length==expressionAttrStr.length) {
//                    [attachImageStr addAttributes:attrs range:NSMakeRange(0, attachImageStr.length)];
//                }
//            }];
            
            [resultAttributedString appendAttributedString:attachImageStr];
        }else{
            //找不到对应图像名称就直接加上去
            [resultAttributedString appendAttributedString:expressionAttrStr];
        }
    }
    
    if (location < [attributedString length]) {
        //到这说明最后面还有非表情字符串
        NSRange range = NSMakeRange(location, [attributedString length] - location);
        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:range];
        [resultAttributedString appendAttributedString:subAttrStr];
    }
    resultAttributedString.yy_color = self.textColor;
    return resultAttributedString;
}


@end
