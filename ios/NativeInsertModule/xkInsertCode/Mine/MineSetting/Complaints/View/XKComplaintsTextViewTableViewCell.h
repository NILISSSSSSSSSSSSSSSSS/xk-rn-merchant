//
//  XKComplaintsTextViewTableViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^textViewDidEndEditingBlock)(NSString *text);
@interface XKComplaintsTextViewTableViewCell : UITableViewCell
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, copy)textViewDidEndEditingBlock block;
- (void)setTextViewDidEndEditingBlock:(textViewDidEndEditingBlock)block;
@end
