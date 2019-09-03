//
//  XKIMMessageCustomerSerQuestionAttachment.m
//  XKSquare
//
//  Created by xudehuai on 2019/1/8.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKIMMessageCustomerSerQuestionAttachment.h"

@implementation XKIMMessageCustomerSerQuestionAttachment

- (NSString *)encodeAttachment {
    NSDictionary *dict = @{
                           @"question" : self.question
                           };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:nil];
    return [[NSString alloc] initWithData:jsonData
                                 encoding:NSUTF8StringEncoding];
}


@end
