//
//  UILabel+Community.h
//  ErpApp
//
//  Created by Mi on 2018/1/11.
//  Copyright © 2018年 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Community)

/**
 *  字间距
 */
@property (nonatomic, assign)CGFloat characterSpace;

/**
 *  行间距
 */
@property (nonatomic, assign)CGFloat lineSpace;
- (void)setSingleLineSpace:(CGFloat)lineSpace;
/**
 *  关键字
 */
@property (nonatomic, copy)NSString *keywords;
@property (nonatomic, strong)UIFont *keywordsFont;
@property (nonatomic, strong)UIColor *keywordsColor;

/**
 *  下划线
 */
@property (nonatomic,copy)NSString *underlineStr;
@property (nonatomic,strong)UIColor *underlineColor;

/**
 *  计算label宽高，必须调用
 *
 *  @param maxWidth 最大宽度
 *
 *  @return label的size
 */
- (CGSize)getLableSizeWithMaxWidth:(CGFloat)maxWidth;


/**
 *  文字颜色字体设置
 *
 *  @param text           需要处理的文字
 *  @param scaleTexts     需要处理字体的文字
 *  @param font           文字字体
 *  @param diffColorTexts 需要处理颜色的文字
 *  @param diffColors     颜色
 */
- (void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleFont:(UIFont *)font diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors;

/**
 *  文字颜色字体设置
 *
 *  @param text           需要处理的文字
 *  @param scaleTexts     需要处理字体的文字
 *  @param scaleSize      文字字体大小
 *  @param diffColorTexts 需要处理颜色的文字
 *  @param diffColors     颜色
 */
- (void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors;
/**
 *  文字字体设置
 *
 *  @param text       需要处理的文字
 *  @param scaleTexts 需要处理字体的文字
 *  @param scaleSize  文字字体大小
 */
- (void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize;

/**
 *  文字颜色设置
 *
 *  @param text       需要处理的文字
 *  @param scaleTexts 需要处理颜色的文字
 *  @param color      文字颜色
 */
- (void)setAttributedColor:(NSString*)text scaleText:(NSArray*)scaleTexts color:(UIColor*)color;

/**
 *  文字颜色设置
 *
 *  @param text       需要处理的文字
 *  @param scaleTexts 需要处理颜色的文字
 *  @param color      文字颜色
 */
- (void)setAttributedColor:(NSString*)text scaleText:(NSArray*)scaleTexts color:(UIColor*)color scaleSize:(CGFloat)scaleSize;

/**
 *  文字颜色设置
 *
 *  @param text       需要处理的文字
 *  @param scaleTexts 需要处理颜色的文字
 *  @param color      文字颜色
 */
- (void)setAttributed:(NSString*)text scaleText:(NSArray*)scaleTexts color:(UIColor*)color font:(UIFont *)font;

+ (CGSize)getSpaceLabelHeight:(NSString*)str  withWidth:(CGFloat)width WithFontSize:(CGFloat)fontSize;

+ (CGSize)getSpaceLabelHeight:(NSString*)str withWidth:(CGFloat)width lineSpacing:(CGFloat)spacing WithFont:(UIFont *)font;


+ (CGFloat)getContactHeight:(NSString*)contact withWidth:(CGFloat)width WithFontSize:(CGFloat)fontSize;
/**
 * 单行Label的宽度自适应 add by Shinson on 2017.04.11
 */
- (void)widthToFit;

/**
 * 单行Label的高度 add by leocll
 */
- (void)heightToFit;

- (void)setLineSpaceing:(CGFloat)lineSpacing;

@end
