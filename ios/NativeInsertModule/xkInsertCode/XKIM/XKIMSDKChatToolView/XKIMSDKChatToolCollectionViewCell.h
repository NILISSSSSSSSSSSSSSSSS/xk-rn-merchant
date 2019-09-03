//
//  XKIMSDKChatToolCollectionViewCell.h
//  xkMerchant
//
//  Created by xudehuai on 2019/3/1.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKIMSDKChatToolCollectionViewCell : UICollectionViewCell

- (void)configCellWithImg:(NSString *)img
                    title:(NSString *)title
                    space:(CGFloat)space
                     font:(UIFont *)font
               titleColor:(UIColor *)titleColor;


@end

NS_ASSUME_NONNULL_END
