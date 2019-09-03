//
//  XKWelfarePhotoContainerView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfarePhotoContainerView.h"

@interface XKWelfarePhotoContainerView ()
@property (nonatomic, strong) NSArray *imageViewsArray;
@property (assign) CGFloat  itemH;

@end

@implementation XKWelfarePhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.clipsToBounds=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = 0.f;
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    self.itemH = 0;
    XKWeakSelf(ws);
    
    if (_picPathStringsArray.count == 1) {
        
        UIImageView *imageView = [_imageViewsArray objectAtIndex:0];
        
        [imageView  sd_setImageWithURL:[NSURL URLWithString:picPathStringsArray[0]] placeholderImage:[UIImage imageNamed:@"workgroup_img_defaultPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        self.itemH = itemW;
    } else {
        self.itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [ws.imageViewsArray objectAtIndex:idx];
        [imageView sd_setImageWithURL:[NSURL URLWithString:picPathStringsArray[idx]] placeholderImage:[UIImage imageNamed:@"workgroup_img_defaultPhoto"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.hidden = NO;
        //        imageView.image = [UIImage imageNamed:obj];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (self.itemH + margin), itemW, self.itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * self.itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = h;
    self.fixedWidth = w;
    
    
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
  //  UIView *imageView = tap.view;
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.currentImageIndex = imageView.tag;
//    browser.sourceImagesContainerView = self;
//    browser.imageCount = self.picPathStringsArray.count;
//    browser.delegate = self;
//    [browser show];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return 120;
    } else {
        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
        return w;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count <= 4) {
        return array.count;
    } else {
        return 4;
    }
}
@end
