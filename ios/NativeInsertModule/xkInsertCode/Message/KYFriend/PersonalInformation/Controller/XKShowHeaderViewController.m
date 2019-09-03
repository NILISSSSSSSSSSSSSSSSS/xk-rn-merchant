//
//  XKShowHeaderViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKShowHeaderViewController.h"
#import "XKPhotoPickHelper.h"

@interface XKShowHeaderViewController ()
@property (nonatomic, strong) XKPhotoPickHelper *bottomSheetView;
@property (nonatomic, strong) UIImageView *headerImageView;
@end

@implementation XKShowHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"个人头像" WithColor:[UIColor whiteColor]];
    [self setNavRightButton];
    [self creatUI];
}

- (void)creatUI {
    self.containView.backgroundColor = [UIColor blackColor];
    self.headerImageView = [[UIImageView alloc]init];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    if (self.type == XKMYHeaderControllerType ) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.headerUrl] placeholderImage:kDefaultHeadImg];
    }else {
         [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[XKUserInfo getCurrentUserAvatar]] placeholderImage:kDefaultHeadImg];
    }
    [self.containView addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.equalTo(self.headerImageView.mas_width);
    }];
    [self gestureConfig];
}
- (void)setNavRightButton {
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 40, 30);
    moreBtn.tintColor = [UIColor whiteColor];
    [moreBtn setImage:[[UIImage imageNamed:@"xk_ic_order_mainDetail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:moreBtn withframe:moreBtn.frame];
}

- (void)moreClick:(UIButton *)sender {
    [self.bottomSheetView showView];
}

- (XKPhotoPickHelper *)bottomSheetView {
    if(!_bottomSheetView) {
        XKWeakSelf(ws);
        _bottomSheetView = [[XKPhotoPickHelper alloc] init];
        _bottomSheetView.allowCrop = YES;
        _bottomSheetView.maxCount = 1;
        [_bottomSheetView handleVideoChoseWithNeeded:NO];
        _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
            for (UIImage *image in images) {
                [XKHudView showLoadingTo:ws.containView animated:YES];
                ws.headerImageView.image = image;
                [[XKUploadManager shareManager]uploadImage:image withKey:@"headerImage" progress:^(CGFloat progress) {
                } success:^(NSString *url) {
                    [XKHudView hideHUDForView:ws.containView animated:YES];
                    NSString *imageUrl = kQNPrefix(url);
                    if (ws.headerBlock) {
                        ws.headerBlock(imageUrl);
                    }
                    if (ws.type == XKMYHeaderControllerType ) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"avatar"] = imageUrl;
                        [ws updateWithParameters:dic];
                    }else{
                        [ws updateWithAvatar:imageUrl];
                    }
                } failure:^(id data) {
                }];
            }
        };
    }
    return _bottomSheetView;
}

- (void)updateWithAvatar:(NSString *)avatar{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"avatar"] = avatar;
    [HTTPClient postEncryptRequestWithURLString:GetXkUserUpdateUrl timeoutInterval:20.0 parameters:[parameters copy] success:^(id responseObject) {
        [XKUserInfo currentUser].avatar = avatar;
        XKUserSynchronize;
        [XKHudView showSuccessMessage:@"更新成功"];
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
    }];
}

- (void)updateWithParameters:(NSMutableDictionary *)parameters{
    parameters[@"secretId"] = self.secretId;
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/secretCircleDetailUpdate/1.0" timeoutInterval:20.0 parameters:[parameters copy] success:^(id responseObject) {
        [XKHudView hideHUDForView:self.view animated:YES];
        [XKHudView showSuccessMessage:@"更新成功"];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.view animated:YES];
        [XKHudView showErrorMessage:error.message to:self.view animated:YES];
    }];
}

- (void)gestureConfig{
    //图片放大缩小手势
   UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeScale:)];
   [self.headerImageView addGestureRecognizer:pinGesture];
   self.headerImageView.userInteractionEnabled = YES;
   self.headerImageView.multipleTouchEnabled = YES;
}

//对应上面的三种手势
- (void)changeScale:(UIPinchGestureRecognizer *)sender {
    UIView *view = sender.view;
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, sender.scale, sender.scale);
        sender.scale = 1.0;
    }
}

@end
