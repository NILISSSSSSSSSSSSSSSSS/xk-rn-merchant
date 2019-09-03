//
//  UILabel+Community.m
//  ErpApp
//
//  Created by Mi on 2018/1/11.
//  Copyright © 2018年 haofangtongerp. All rights reserved.
//

#import "UILabel+Community.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import "UIView+Frame.h"

@implementation UILabel (Community)
-(CGFloat)characterSpace{
    return [objc_getAssociatedObject(self,_cmd) floatValue];
}

-(void)setCharacterSpace:(CGFloat)characterSpace{
    objc_setAssociatedObject(self, @selector(characterSpace), @(characterSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(CGFloat)lineSpace{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

-(void)setLineSpace:(CGFloat)lineSpace{
    objc_setAssociatedObject(self, @selector(lineSpace), @(lineSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSingleLineSpace:(CGFloat)lineSpace {
    if (self.text == nil) {
        return;
    }
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpace];
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,attStr.length)];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = self.textAlignment;
    self.attributedText = attStr;
}



-(NSString *)keywords{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setKeywords:(NSString *)keywords{
    objc_setAssociatedObject(self, @selector(keywords), keywords, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIFont *)keywordsFont{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setKeywordsFont:(UIFont *)keywordsFont{
    objc_setAssociatedObject(self, @selector(keywordsFont), keywordsFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor *)keywordsColor{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setKeywordsColor:(UIColor *)keywordsColor{
    objc_setAssociatedObject(self, @selector(keywordsColor), keywordsColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)underlineStr{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setUnderlineStr:(NSString *)underlineStr{
    objc_setAssociatedObject(self, @selector(underlineStr), underlineStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(UIColor *)underlineColor{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setUnderlineColor:(UIColor *)underlineColor{
    objc_setAssociatedObject(self, @selector(underlineColor), underlineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

/**
 *  根据最大宽度计算label宽，高
 *
 *  @param maxWidth 最大宽度
 *
 *  @return size
 */
- (CGSize)getLableSizeWithMaxWidth:(CGFloat)maxWidth{
    if (!self.text) {
        return CGSizeZero;
    }
    if (self.text.length != 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
        [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0,self.text.length)];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.alignment=self.textAlignment;
        paragraphStyle.lineBreakMode=self.lineBreakMode;
        // 行间距
        if(self.lineSpace > 0){
            [paragraphStyle setLineSpacing:self.lineSpace];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
        }
        
        // 字间距
        if(self.characterSpace > 0){
            long number = self.characterSpace;
            CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
            [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
            
            CFRelease(num);
        }
        
        //关键字
        if (self.keywords) {
            NSRange itemRange = [self.text rangeOfString:self.keywords];
            if (self.keywordsFont) {
                [attributedString addAttribute:NSFontAttributeName value:self.keywordsFont range:itemRange];
                
            }
            
            if (self.keywordsColor) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:self.keywordsColor range:itemRange];
                
            }
        }
        
        //下划线
        if (self.underlineStr) {
            NSRange itemRange = [self.text rangeOfString:self.underlineStr];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:itemRange];
            if (self.underlineColor) {
                [attributedString addAttribute:NSUnderlineColorAttributeName value:self.underlineColor range:itemRange];
            }
        }
        self.attributedText = attributedString;
        //计算方法一
        //计算文本rect，但是发现设置paragraphStyle.lineBreakMode=NSLineBreakByTruncatingTail;后高度计算不准确
        //CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        
        //计算方法二
        //        CGSize expectSize = CGSizeZero;
        CGSize maximumLabelSize = CGSizeMake(maxWidth, [UIScreen mainScreen].bounds.size.height);//labelsize的最大值
        CGSize expectSize = [self sizeThatFits:maximumLabelSize];
        //避免一行也加间隙的情况
        if (self.lineSpace > 0 && expectSize.height > self.font.lineHeight && expectSize.height < self.font.lineHeight*2) {
            [paragraphStyle setLineSpacing:0];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
            self.attributedText = attributedString;
            expectSize.height = self.font.lineHeight;
        }
        return expectSize;
    } else {
        return CGSizeZero;
    }
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

- (void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors {
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


- (void)setAttributedColor:(NSString*)text scaleText:(NSArray*)scaleTexts color:(UIColor*)color scaleSize:(CGFloat)scaleSize
{
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

- (void)setAttributed:(NSString *)text scaleText:(NSArray *)scaleTexts color:(UIColor *)color font:(UIFont *)font {
    if (!text) return;
    
    self.text = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font} range:[text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
}

+ (CGSize)getSpaceLabelHeight:(NSString*)str withWidth:(CGFloat)width WithFontSize:(CGFloat)fontSize {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;//行间距 默认为0
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
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

#pragma mark - 单行Label的宽度自适应 add by Shinson on 2017.04.11
- (void)widthToFit {
    if (self.numberOfLines == 1) {
        self.width = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
    }
}

- (void)heightToFit {
    if (self.numberOfLines == 1) {
        self.height = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
    }
}

+ (CGSize)getSpaceLabelHeight:(NSString*)str withWidth:(CGFloat)width lineSpacing:(CGFloat)spacing WithFont:(UIFont *)font {
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
@end
