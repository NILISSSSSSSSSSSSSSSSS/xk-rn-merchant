//
//  UILabel+Tool.m
//  ToucanHealthPlatform
//
//  Created by 何丽娟 on 14/12/17.
//  Copyright (c) 2014年 KSCloud.Co.,Ltd. All rights reserved.
//

#import "UILabel+Tool.h"

@implementation UILabel(Tool)

- (void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors
{
    if (!text) return;
    
    self.text = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:scaleSize] range:[text rangeOfString:scaleText]];
    }
    
    for (NSInteger i=0, j  = diffColorTexts.count;i<j;i++) {
        NSString *subStr = [diffColorTexts objectAtIndex:i];
        UIColor *color = [diffColors objectAtIndex:i];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[self.text rangeOfString:subStr]];
    }
    
    self.attributedText = attributedString;
}


- (void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize
{
    if (!text) return;
    
    self.text = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:scaleSize] range:[text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
}

- (void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleFont:(UIFont *)font diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors {
	if (!text) return;
	self.text = text;
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
	for (NSString *scaleText in scaleTexts) {
		[attributedString addAttribute:NSFontAttributeName value:font range:[text rangeOfString:scaleText]];
	}
	for (NSInteger i=0, j  = diffColorTexts.count;i<j;i++) {
		NSString *subStr = [diffColorTexts objectAtIndex:i];
		UIColor *color = [diffColors objectAtIndex:i];
		[attributedString addAttribute:NSForegroundColorAttributeName value:color range:[self.text rangeOfString:subStr]];
	}
	self.attributedText = attributedString;
}

- (void)setLineSpaceing:(CGFloat)lineSpacing
{
	if (self.text == nil) {
		return;
	}
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpacing];
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,attStr.length)];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    self.attributedText = attStr;
}

- (void)setAttributedColor:(NSString*)text scaleText:(NSArray*)scaleTexts color:(UIColor*)color
{
    if (!text) return;
    
    self.text = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
}

- (void)setAttr:(CGFloat)lineSpacing scaleColorText:(NSArray*)scaleColorTexts color:(UIColor*)color scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize
{
    if (!self.text) return;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    for (NSString *scaleText in scaleColorTexts) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[self.text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
    
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:scaleSize] range:[self.text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,attributedString.length)];
    self.attributedText = attributedString;
    
    
}

- (void)setAttrText:(NSString*)text diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors
{
    if (!text) return;
    self.text = text;
    if (diffColorTexts.count != diffColors.count || diffColorTexts.count <= 0 || diffColors.count <= 0) {
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    for (int i=0,j=(int)diffColorTexts.count;i<j;i++) {
        NSString *subStr = [diffColorTexts objectAtIndex:i];
        UIColor *color = [diffColors objectAtIndex:i];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[self.text rangeOfString:subStr]];
    }
    self.attributedText = attributedString;
}

+(CGSize)getSpaceLabelHeight:(NSString*)str withWidth:(CGFloat)width lineSpacing:(CGFloat)spacing WithFont:(UIFont *)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = spacing;//行间距 默认为0
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, [UIScreen mainScreen].bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

+ (CGFloat)getContactHeight:(NSString*)contact withWidth:(CGFloat)width WithFontSize:(CGFloat)fontSize {
	NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
	CGSize maxSize = CGSizeMake(width, MAXFLOAT);
	CGSize size = [contact boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
	return size.height;
}

- (void)setcolumnSpaceing:(CGFloat)lineSpacing {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text?:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

#pragma mark - 单行Label的宽度自适应 add by Shinson on 2017.04.11
- (void)widthToFit {
	if (self.numberOfLines == 1) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width, self.frame.size.height);
	}
}

- (void)heightToFit {
	if (self.numberOfLines == 1) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].height);
	}
}

- (void)setAttributedColor:(NSString*)text scaleText:(NSArray*)scaleTexts color:(UIColor*)color scaleSize:(CGFloat)scaleSize {
    if (!text) return;

    self.text = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;

    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:scaleSize] range:[self.text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
}

@end
