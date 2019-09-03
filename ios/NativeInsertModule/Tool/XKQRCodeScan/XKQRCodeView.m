//
//  XKQRCodeView.m
//  QRCodeScan
//
//  Created by hupan on 2018/7/24.
//  Copyright © 2018年 hupan. All rights reserved.
//

#import "XKQRCodeView.h"

@interface XKQRCodeView ()

@property (nonatomic, strong)UIImageView *QRimageView;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@implementation XKQRCodeView


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _width = frame.size.width;
        _height = frame.size.height;
        [self addCustomViews];
        [self addLayout];
    }
    return self;
}

#pragma mark - Private Methods

- (void)addCustomViews {
    
    [self addSubview:self.QRimageView];
}

- (void)addLayout {
    
    [self.QRimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    //        self.QRimageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

/**
 将String转换成条形码图片
 
 @param barCodeString barCodeString description
 */
- (void)createBarCodeImageWithBarCodeString:(NSString *)barCodeString {
    
    
    // 创建条形码
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [barCodeString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    // 将CIImage 转换为UIImage
    UIImage *image = [UIImage imageWithCIImage:outputImage];
    
    self.QRimageView.image = image;
}
//分享专用生成二维码
- (void)createShareQRImageWithQRString:(NSString *)qrString correctionLevel:(NSString *)level {
    //1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.恢复默认
    [filter setDefaults];
    //3.给过滤器添加数据
    NSData *data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    [filter setValue:@"L" forKey:@"inputCorrectionLevel"];
    //4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //5.将CIImage转换成UIImage，并放大显示 生成清晰二维码
    self.QRimageView.image = [UIImage imageWithCIImage:outputImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];//[self createUIImageFormCIImage:outputImage imgWidth:_width imgHeight:_height];
    
}

/**
 将String转换成二维码图片
 
 @param qrString qrString description
 */
- (void)createQRImageWithQRString:(NSString *)qrString {
    //1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.恢复默认
    [filter setDefaults];
    //3.给过滤器添加数据
    NSData *data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //5.将CIImage转换成UIImage，并放大显示 生成清晰二维码
    self.QRimageView.image = [self createUIImageFormCIImage:outputImage imgWidth:_width imgHeight:_height];
    
}

- (void)createQRImageWithQRString:(NSString *)qrString correctionLevel:(NSString *)level {
    //1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.恢复默认
    [filter setDefaults];
    //3.给过滤器添加数据
    NSData *data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    [filter setValue:level forKey:@"inputCorrectionLevel"];
    //4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //5.将CIImage转换成UIImage，并放大显示 生成清晰二维码
    self.QRimageView.image = [self createUIImageFormCIImage:outputImage imgWidth:_width imgHeight:_height];
    
}


/**
 根据CIImage 生成 UIImage
 
 @param image CIImage
 @param imgWidth width
 @param imgHeight height
 @return UIImage
 */
- (UIImage *)createUIImageFormCIImage:(CIImage *)image imgWidth:(CGFloat)imgWidth imgHeight:(CGFloat)imgHeight
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(imgWidth / CGRectGetWidth(extent), imgHeight / CGRectGetHeight(extent));
    //创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}


#pragma mark - Lazy load

- (UIImageView *)QRimageView {
    if (!_QRimageView) {
        _QRimageView = [[UIImageView alloc] init];
    }
    return _QRimageView;
}





@end
