//
//  UILabel+Tool.h
//  ToucanHealthPlatform
//
//  Created by 何丽娟 on 14/12/17.
//  Copyright (c) 2014年 KSCloud.Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(Tool)
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
 *  文字间距设置
 *
 *  @param lineSpacing 间距大小
 */
- (void)setLineSpaceing:(CGFloat)lineSpacing;

/**
 *  文字列间距设置
 *
 *  @param lineSpacing 间距大小
 */
- (void)setcolumnSpaceing:(CGFloat)lineSpacing;

/**
 *  文字颜色设置
 *
 *  @param text       需要处理的文字
 *  @param scaleTexts 需要处理颜色的文字
 *  @param color      文字颜色
 */
- (void)setAttributedColor:(NSString*)text scaleText:(NSArray*)scaleTexts color:(UIColor*)color;

+(CGSize)getSpaceLabelHeight:(NSString*)str withWidth:(CGFloat)width lineSpacing:(CGFloat)spacing WithFont:(UIFont *)font;

+ (CGFloat)getContactHeight:(NSString*)contact withWidth:(CGFloat)width WithFontSize:(CGFloat)fontSize;

/**
 * 单行Label的宽度自适应 add by Shinson on 2017.04.11
 */
- (void)widthToFit;

/**
 * 单行Label的高度 add by leocll
 */
- (void)heightToFit;

- (void)setAttributedColor:(NSString*)text scaleText:(NSArray*)scaleTexts color:(UIColor*)color scaleSize:(CGFloat)scaleSize;

@end
