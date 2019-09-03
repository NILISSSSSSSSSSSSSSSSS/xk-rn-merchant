//
//  XKLatestSecretTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKLatestSecretModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKLatestSecretTableViewCell : UITableViewCell

- (void)configCellWithLatestSecretModel:(XKLatestSecretModel *) latestSecret;

- (void)removeTimer;

@end

NS_ASSUME_NONNULL_END
