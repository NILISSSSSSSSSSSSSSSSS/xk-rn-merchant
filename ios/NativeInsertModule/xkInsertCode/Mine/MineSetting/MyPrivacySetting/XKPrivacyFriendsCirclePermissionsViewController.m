//
//  XKPrivacyFriendsCirclePermissionsViewController.m
//  XKSquare
//
//  Created by william on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPrivacyFriendsCirclePermissionsViewController.h"
#import "XKFriendsCirclePermissionsCollectionViewCell.h"
#import "XKContactModel.h"
#import "XKContactListController.h"
#import "XKCommonAlertView.h"

static NSString *const collectionViewCellID = @"permissionsCollectionViewCell";

#define itemCount        5
#define itemMargin       0
#define itemTotalMargin  (itemCount + 1) * itemMargin
#define itemWidth        (SCREEN_WIDTH - 20 - 14 - itemTotalMargin) / itemCount
#define itemHeight       (itemWidth + 30)

@interface XKPrivacyFriendsCirclePermissionsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *dataMuArr;   //原始数据
@property (nonatomic, strong) NSMutableArray   *dataNewMuArr;//删除后的数据
@property (nonatomic, strong) UIButton         *sureButton;
@property (nonatomic, assign) BOOL             isDelete;
@property (nonatomic, copy  ) NSString         *titleName;


@end

@implementation XKPrivacyFriendsCirclePermissionsViewController

#pragma mark – Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xEEEEEE);
    self.dataMuArr = [NSMutableArray array];
    self.dataNewMuArr = [NSMutableArray array];
    
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Events

- (void)sureButtonClicked:(UIButton *)sender {
    
    [self updateSelectedUser];

}

#pragma mark – Private Methods

-(void)initViews {
    
    [self setNaviCustomView:self.sureButton withframe:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 30)];
    
    if (_permissionsType == PermissionsType_notLookMine) {
        _titleName = @"不让Ta看我的朋友圈";
        if (!self.isDelete) {
            [self requestUserDataWithUrlString:@"friendCircleAuthList" authorityType:@"visitMeCF"];
        }
    } else if (_permissionsType == PermissionsType_notLookTheir) {
        _titleName = @"不看Ta的朋友圈";
        if (!self.isDelete) {
            [self requestUserDataWithUrlString:@"friendCircleAuthList" authorityType:@"visitTaCF"];
        }
    }
    
    [self.view addSubview:self.collectionView];
    [self setNavigationTitle];
    [self setCollectionViewLayout];
}

- (CGFloat)returnCollectionViewHeight {
    
    CGFloat viewHeight = 0;
    if (self.isDelete) {
        viewHeight = ((self.dataNewMuArr.count - 2) % 5) == 0 ? ((self.dataNewMuArr.count - 2) / 5) * itemHeight : (((self.dataNewMuArr.count - 2) / 5) + 1) * itemHeight;
//        viewHeight += 10;
        if (viewHeight >= SCREEN_HEIGHT - 20 - NavigationAndStatue_Height) {
            viewHeight = SCREEN_HEIGHT - 20 - NavigationAndStatue_Height;
        }
    } else {
        if ((self.dataMuArr.count % 5) == 0) {
            viewHeight = (self.dataMuArr.count / 5) * itemHeight;
        } else if ((self.dataMuArr.count % 5) == 1) {
            viewHeight = ((self.dataMuArr.count / 5) + 1) * itemHeight - 15;
        } else if ((self.dataMuArr.count % 5) == 2) {
            viewHeight = ((self.dataMuArr.count / 5) + 1) * itemHeight - 15;
        } else {
            viewHeight = ((self.dataMuArr.count / 5) + 1) * itemHeight;
        }

        if (viewHeight >= SCREEN_HEIGHT - 20 - NavigationAndStatue_Height) {
            viewHeight = SCREEN_HEIGHT - 20 - NavigationAndStatue_Height;
        }
    }
    return viewHeight;
}


- (void)setCollectionViewLayout {
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 7, 0, 7);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height + 10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@([self returnCollectionViewHeight]));
    }];
}

- (void)updateCollectionViewLayout {
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self returnCollectionViewHeight]));
    }];
}


- (void)setNavigationTitle {
    //设置title
    if (self.isDelete) {
        [self setNavTitle:[NSString stringWithFormat:@"%@(%d)", self.titleName, (int)self.dataNewMuArr.count - 2] WithColor:[UIColor whiteColor]];
    } else {
        [self setNavTitle:[NSString stringWithFormat:@"%@(%d)", self.titleName, (int)self.dataMuArr.count - 2] WithColor:[UIColor whiteColor]];
    }
}

- (void)requestUserDataWithUrlString:(NSString *)urlString authorityType:(NSString *)authorityType {
    
    urlString = [NSString stringWithFormat:@"im/ua/%@/1.0", urlString];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:authorityType forKey:@"authorityType"];

    [HTTPClient postEncryptRequestWithURLString:urlString timeoutInterval:30 parameters:muDic success:^(id responseObject) {
        if (responseObject) {
            self.dataMuArr = [NSArray yy_modelArrayWithClass:[XKContactModel class] json:responseObject].mutableCopy;
        }
        if (!self.isDelete) {
            [self.dataMuArr addObject:[XKContactModel yy_modelWithDictionary:@{@"nickname":@"", @"avatar":@"", @"userId":@"add"}]];
            [self.dataMuArr addObject:[XKContactModel yy_modelWithDictionary:@{@"nickname":@"", @"avatar":@"", @"userId":@"delete"}]];
        }
        self.dataNewMuArr = self.dataMuArr;
        //设置title
        [self setNavigationTitle];
        [self updateCollectionViewLayout];
        [self.collectionView reloadData];
        
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}

- (void)updateSelectedUser {
    
    NSString *authorityType = @"";
    if (_permissionsType == PermissionsType_notLookMine) {
        authorityType = @"visitMeCF";
    } else if (_permissionsType == PermissionsType_notLookTheir) {
        authorityType = @"visitTaCF";
    }
    NSString *urlString = @"im/ua/friendCircleAuthBatchUpdate/1.0";
    NSMutableArray *muArr = [NSMutableArray array];
    for (XKContactModel *model in self.dataNewMuArr) {
        //删除本地添加的标识
        if (![model.userId isEqualToString:@"add"] && ![model.userId isEqualToString:@"delete"]) {
            [muArr addObject:model.userId];
        }
    }
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:muArr.copy forKey:@"userIds"];
    [muDic setObject:authorityType forKey:@"authorityType"];
    
    [HTTPClient postEncryptRequestWithURLString:urlString timeoutInterval:30 parameters:muDic success:^(id responseObject) {

        [self updateSucccessfull:YES];
        
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
        [self updateSucccessfull:NO];
    }];
}

- (void)updateSucccessfull:(BOOL)success {
    
    self.sureButton.hidden = YES;
    self.isDelete = NO;
    if (success) {
        self.dataMuArr = self.dataNewMuArr;
    } else {
        self.dataNewMuArr = self.dataMuArr;
    }
    
    [self.collectionView reloadData];
    [self setNavigationTitle];
    [self updateCollectionViewLayout];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.isDelete) {
       return self.dataNewMuArr.count - 2;
    }
    return self.dataMuArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKFriendsCirclePermissionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];

    [cell setValues:self.isDelete ? self.dataNewMuArr[indexPath.row] : self.dataMuArr[indexPath.row] isDelete:self.isDelete];
    
    if (self.dataMuArr.count == 2 && indexPath.row == 1) {
        cell.hidden = YES;
    } else {
        cell.hidden = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.isDelete) { //删除
        XKContactModel *mode = self.dataNewMuArr[indexPath.row];
        XKWeakSelf(weakSelf);
        XKCommonAlertView *alertView = [[XKCommonAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否确定删除%@", mode.nickname] leftButton:@"取消" rightButton:@"确定" leftBlock:nil rightBlock:^{
            
            [weakSelf.dataNewMuArr removeObject:mode];
            
            [weakSelf.collectionView reloadData];
            
            [weakSelf setNavigationTitle];
            
            [weakSelf updateCollectionViewLayout];
            
        } textAlignment:NSTextAlignmentCenter];
        
        [alertView show];
        
    } else {
        
        if (indexPath.row == self.dataMuArr.count - 1) {//删除
            
            self.sureButton.hidden = NO;
            self.isDelete = YES;
            [self setNavigationTitle];
            [self updateCollectionViewLayout];
            [self.collectionView reloadData];
            
        } else if (indexPath.row == self.dataMuArr.count - 2) {//添加
            XKContactListController *vc = [[XKContactListController alloc] init];
            vc.useType = XKContactUseTypeManySelect;
            vc.defaultSelected = self.dataMuArr;
            vc.bottomButtonText = @"确定";
            XKWeakSelf(weakSelf);
            __weak typeof(vc)weakVC = vc;
            vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
                weakSelf.dataNewMuArr = contacts.mutableCopy;
                if (contacts.count) {
                    [weakSelf.dataNewMuArr addObject:[XKContactModel yy_modelWithDictionary:@{@"nickname":@"", @"avatar":@"", @"userId":@"add"}]];
                    [weakSelf.dataNewMuArr addObject:[XKContactModel yy_modelWithDictionary:@{@"nickname":@"", @"avatar":@"", @"userId":@"delete"}]];
                } else {
                    [weakSelf.dataNewMuArr addObject:[XKContactModel yy_modelWithDictionary:@{@"nickname":@"", @"avatar":@"", @"userId":@"add"}]];
                }
                [weakSelf updateSelectedUser];
                [weakVC.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - Custom Delegates

#pragma mark – Getters and Setters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = itemMargin;
        flowLayout.minimumInteritemSpacing = itemMargin;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.layer.masksToBounds = YES;
        _collectionView.layer.cornerRadius = 5;
        [_collectionView registerClass:[XKFriendsCirclePermissionsCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        
    }
    return _collectionView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.hidden = YES;
        [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
