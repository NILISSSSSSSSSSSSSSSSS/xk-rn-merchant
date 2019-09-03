//
//  UILabel+xkEmoji.h
//  MLLabel
//
//  Created by Jamesholy on 2018/12/10.
//

#import <UIKit/UIKit.h>
#import "MLExpressionManager.h"

@interface UILabel (xkEmoji)

+ (MLExpression *)mapExp;
+ (NSAttributedString *)getEmojiAttriStr:(NSString *)text;
/**获取[xx]对应的表情图片名称 没有为nil*/
+ (NSString *)getImageNameForExp:(NSString *)exp;

@end

