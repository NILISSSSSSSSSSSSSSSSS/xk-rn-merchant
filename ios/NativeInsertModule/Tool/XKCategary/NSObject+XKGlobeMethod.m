//
//  NSObject+XKGlobeMethod.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "NSObject+XKGlobeMethod.h"

@implementation NSObject (XKGlobeMethod)

- (NSString *)getRandomStringWithNum:(NSInteger)num {
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        } else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}


-(BOOL)checkEmail:(NSString *)email {
    NSString * emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)checkMobile:(NSString *)mobile {
    NSString    * pattern = @"^1+[3456789]+\\d{9}";
    NSPredicate * pred    = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL          isMatch = [pred evaluateWithObject:mobile];
    return isMatch;
}

- (BOOL)checkCarNo:(NSString *)carNo {
    NSString * carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate * carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}

- (BOOL)checkNumberOnly:(NSString *)text {
    if (text == nil) {
        return NO;
    }else if (text.length == 0) {
        return NO;
    }
    BOOL isNumber = YES;
    for (NSInteger i = 0; i < text.length; i ++)
    {
        char singleC = [text characterAtIndex:i];
        if (singleC < 48 || singleC > 57)
        {
            isNumber = NO;
            break;
        }
    }
    return isNumber;
}

- (BOOL)checkPassword:(NSString *)password{
    NSString *regx = @"^[\\p{Punct}a-zA-Z0-9]{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regx];
    BOOL isValid = [predicate evaluateWithObject:password];
    return isValid;
}

- (BOOL)checkName:(NSString *)name {
    NSString *regx = @"[\u4e00-\u9fa5a-zA-Z0-9_]{2,10}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regx];
    BOOL isValid = [predicate evaluateWithObject:name];
    return isValid;
}

+ (void)swizzleMethod:(Class)class orgSel:(SEL)originalSelector swizzSel:(SEL)swizzledSelector {

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    char *swizzledTypes = (char *)method_getTypeEncoding(swizzledMethod);
    
    IMP originalImp = method_getImplementation(originalMethod);
    char *originalTypes = (char *)method_getTypeEncoding(originalMethod);
    
    BOOL success = class_addMethod(class, originalSelector, swizzledImp, swizzledTypes);
    if (success) {
        class_replaceMethod(class, swizzledSelector, originalImp, originalTypes);
    }else {
        // 添加失败，表明已经有这个方法，直接交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (BOOL)checkNewPassword:(NSString*)string {
    BOOL isValid = NO;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9a-zA-Z]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}

@end
