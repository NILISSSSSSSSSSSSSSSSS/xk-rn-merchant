//
//  XKAdressTagStringTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKAdressTagStringTableViewCell;

@protocol XKAdressTagStringTableViewCellDelegate <NSObject>

- (void)addressTagStringCellDidSelected:(XKAdressTagStringTableViewCell *)cell tagString:(NSString *)tagString;

@end

@interface XKAdressTagStringTableViewCell : UITableViewCell

@property (nonatomic, weak) id<XKAdressTagStringTableViewCellDelegate> delegate;

- (void)configAdressTagStringTableViewCellWithTagString:(NSString *)tagString;

@end
