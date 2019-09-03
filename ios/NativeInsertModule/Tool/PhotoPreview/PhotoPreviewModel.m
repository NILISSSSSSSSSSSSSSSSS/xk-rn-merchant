/*******************************************************************************
 # File        : PhotoPreviewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/20
 # Corporation : 水木科技
 # Description :
 浏览大图的基类 需要其他功能的时候需要继承然后定制
 ******************************************************************************/

#import "PhotoPreviewModel.h"
#import "ImageUtils.h"
#import <UIImageView+WebCache.h>

@implementation PhotoPreviewModel

#pragma mark - 获取原图
- (void)originalImage:(void (^)(UIImage *))returnImage {
    UIImage *placeholderImage = [UIImage imageWithContentsOfFile:self.thumbPath];
	EXECUTE_BLOCK(returnImage, (placeholderImage ? placeholderImage : (self.thumbImage ? self.thumbImage: kDefaultPlaceHolderImg)));
	if (![self.imageURL isExist]) {
		if (self.assetImage) {
			EXECUTE_BLOCK(returnImage, self.assetImage);
		}
		return;
	}
    if ([self.imageURL.lowercaseString containsString:@"http"]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                EXECUTE_BLOCK(returnImage, imageView.image);
            }
        }];
    } else {
	// 相册的图片，加快预览速度
		if (self.assetImage) {
			EXECUTE_BLOCK(returnImage, self.assetImage);
		} else {
            __weak typeof(self) weakSelf = self;;
            [ImageUtils getImageWithURL:[NSURL URLWithString:self.imageURL] resultBlock:^(NSError *error, UIImage *image) {
                if ([weakSelf.imageURL hasPrefix:@"assets"]) {
                    weakSelf.assetImage = image;
                }
                if (image) {
                    EXECUTE_BLOCK(returnImage, image);
                }
            }];
		}
    }
}

@end
