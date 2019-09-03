//
//  XKWelfareOrderQRcodeViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderQRcodeViewController.h"

@interface XKWelfareOrderQRcodeViewController ()
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *codeImgView;
@property (nonatomic, strong)UIButton *saveBtn;
@property (nonatomic, strong)UIImage *codeImg;
@end

@implementation XKWelfareOrderQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handleData {
    [super handleData];
    self.codeImg = [self createQRImageWithQRString:self.codeStr ?:@"121313"];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    XKCustomNavBar *navBar =  [[XKCustomNavBar alloc] init];
    navBar.titleString = @"商品二维码";
    [navBar customBaseNavigationBar];
    navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:navBar];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.codeImgView];
    [self.view addSubview:self.saveBtn];
    [self addUIConstraint];
    self.codeImgView.image = self.codeImg;
    
}

- (void)addUIConstraint {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10 + NavigationAndStatue_Height);
        make.height.mas_equalTo(246 * ScreenScale);
    }];
    
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(150 * ScreenScale, 150 * ScreenScale));
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.top.equalTo(self.bgView.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
}

- (void)saveBtnClick:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum(self.codeImg, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [XKHudView showTipMessage:@"保存成功"];
    } else {
        [XKHudView showTipMessage:error.description];
    }
    
}

- (UIImage *)createQRImageWithQRString:(NSString *)qrString {
    //1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.恢复默认
    [filter setDefaults];
    //3.给过滤器添加数据
    NSData *data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //5.将CIImage转换成UIImage，并放大显示 生成清晰二维码
    return  [self createUIImageFormCIImage:outputImage imgWidth:150 * ScreenScale imgHeight:150 * ScreenScale];
    
}

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

#pragma mark 懒加载
- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)codeImgView {
    if(!_codeImgView) {
        _codeImgView = [[UIImageView alloc] init];
        _codeImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _codeImgView;
}

- (UIButton *)saveBtn {
    if(!_saveBtn) {
        _saveBtn = [[UIButton alloc] init];
        [_saveBtn setTitle:@"存入相册" forState:0];
        _saveBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_saveBtn setBackgroundColor:XKMainTypeColor];
        _saveBtn.layer.cornerRadius = 3.f;
        [_saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.layer.masksToBounds = YES;
    }
    return _saveBtn;
}


@end
