//
//  XKOrderSureChooseSeatNumViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderSureChooseSeatNumViewController.h"
#import "XKOderChooseSeatNumCollectionViewCell.h"
#import "XKMallTypeTableViewCell.h"
#import "XKSeatNumDetailViewController.h"
#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaSeatModel.h"
#import "XKTradingAreaSeatListModel.h"
#import "XKTradingAreaSeatVerifyModel.h"
#import "XKTradingAreaOrderDetailViewController.h"

static NSString * const collectionViewCellID          = @"RightCollectionViewCell";
static NSString * const tableViewCellID               = @"leftTableViewCell";


@interface XKOrderSureChooseSeatNumViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton        *sureBtn;

@property (nonatomic, strong) UITableView      *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic ,copy  ) NSArray          *leftClassDataArr;
@property (nonatomic ,strong) NSMutableArray   *rightCollectionDataArr;

@property (nonatomic ,strong) NSMutableDictionary   *rightDataArrCacheDic;
@property (nonatomic ,assign) NSInteger              selectedIndex;

@property (nonatomic, strong) XKTradingAreaSeatVerifyModel   *seatVerifyModel;
@property (nonatomic ,copy  ) NSString                       *verifyCode;



@end

@implementation XKOrderSureChooseSeatNumViewController

#pragma mark - Life Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.maxSeat) {
        self.maxSeat = 1;
    }
    
    [self setNavTitle:@"选择餐桌号" WithColor:[UIColor whiteColor]];
    [self setNaviCustomView:self.sureBtn withframe:CGRectMake(SCREEN_WIDTH - 45, 0, 40, 40)];
    
    self.selectedIndex = 0;
    self.rightCollectionDataArr = [NSMutableArray array];
    self.rightDataArrCacheDic = [NSMutableDictionary dictionary];
    if (!self.selectedSetMuDic) {
        self.selectedSetMuDic = [NSMutableDictionary dictionary];
    }
    
    [self initViews];
    [self layoutViews];
    [self requestAllData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request

- (void)requestAllData {
    
    [XKHudView showLoadingTo:self.view animated:YES];
    [XKSquareTradingAreaTool tradingAreaSeatCategaryList:@{@"shopId":self.shopId ? self.shopId : @"",
                                                           @"limit":@"0",
                                                           @"page":@"1"}
                                                 success:^(NSArray<XKSetItem *> *listArr) {
                                                     [XKHudView hideHUDForView:self.view];
                                                     self.leftClassDataArr = listArr;
                                                     [self.leftTableView reloadData];
                                                     
                                                     [self requestSetList];
    
                                                 } faile:^(XKHttpErrror *error) {
                                                     [XKHudView hideHUDForView:self.view];

                                                 }];
}

- (void)requestSetList {
    if (self.leftClassDataArr.count <= self.selectedIndex) {
        return;
    }
    
    XKSetItem *item = self.leftClassDataArr[self.selectedIndex];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.rightDataArrCacheDic[item.seatTypeId]];
    if (muArr.count) {
        [self.rightCollectionDataArr removeAllObjects];
        [self.rightCollectionDataArr addObjectsFromArray:muArr];
        [self.rightCollectionView reloadData];
        return;
    }
    
    [XKHudView showLoadingTo:self.view animated:YES];
    [XKSquareTradingAreaTool tradingAreaSeatList:@{@"shopId":self.shopId ? self.shopId : @"",
                                                   @"seatTypeId": item.seatTypeId ? item.seatTypeId : @""}
     
                                         success:^(NSArray<XKTradingAreaSeatListModel *> *listArr) {
                                             [XKHudView hideHUDForView:self.view];

                                             //处理回显数据
                                             NSArray *arr = self.selectedSetMuDic.allValues;
                                             NSMutableArray *muListArr = [NSMutableArray arrayWithArray:listArr];
                                             for (NSArray *subArr in arr) {
                                                 for (XKTradingAreaSeatListModel *selectedItem in subArr) {
                                                     for (XKTradingAreaSeatListModel *item in listArr) {
                                                         if ([selectedItem.seatId isEqualToString:item.seatId]) {
                                                             [muListArr replaceObjectAtIndex:[listArr indexOfObject:item] withObject:selectedItem];
                                                             break;
                                                         }
                                                     }
                                                     
                                                 }
                                             }
                                             
                                             //缓存
                                             [self.rightDataArrCacheDic setObject:muListArr forKey:item.seatTypeId];
                                             
                                             [self.rightCollectionDataArr removeAllObjects];
                                             //
                                             [self.rightCollectionDataArr addObjectsFromArray:muListArr.copy];
                                             
                                             [self.rightCollectionView reloadData];
                                             
                                         } faile:^(XKHttpErrror *error) {
                                             [XKHudView hideHUDForView:self.view];

                                         }];
}

#pragma mark - Events

- (void)sureButtonClicked {
    //确定
    if (self.refreshBlock) {
        self.refreshBlock(self.selectedSetMuDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backBtnClick {
    [super backBtnClick];
    //确定
    if (self.refreshBlock) {
        self.refreshBlock(self.selectedSetMuDic);
    }
}

#pragma mark - Private Metheods


- (void)initViews {

    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightCollectionView];
}


- (void)layoutViews {
    
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(@(114 * ScreenScale));
    }];
    
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTableView.mas_top);
        make.left.equalTo(self.leftTableView.mas_right);
        make.bottom.equalTo(self.leftTableView.mas_bottom);
        make.right.equalTo(self.view);
    }];
}


#pragma mark - UITableviewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.leftClassDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKMallTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID];
    if (!cell) {
        cell = [[XKMallTypeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:tableViewCellID];
    }
    XKSetItem *model = self.leftClassDataArr[indexPath.row];
    
    NSString *name;
    NSMutableArray *muarr = self.selectedSetMuDic[model.seatTypeId];
    if (muarr.count) {
        name = [NSString stringWithFormat:@"%@(%ld)", model.seatTypeName, muarr.count];
    } else {
        name = model.seatTypeName;
    }
    /*
    [cell setTitle:name titleColor:indexPath.row == self.selectedIndex ? XKMainTypeColor : HEX_RGB(0x222222)];
    [cell setSelectedBackGroundViewColor:indexPath.row == self.selectedIndex ? [UIColor whiteColor] : HEX_RGB(0xf1f1f1)];
    */
    [cell setTitle:name titleColor:HEX_RGB(0x222222)];
    [cell setSelectedBackGroundViewColor:HEX_RGB(0xf1f1f1)];
    [cell showSelectedView:indexPath.row == self.selectedIndex];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedIndex == indexPath.row) {
        return;
    }
    
    
    [self.rightCollectionView scrollRectToVisible:CGRectMake(0, 0, self.rightCollectionView.width, self.rightCollectionView.height) animated:YES];
    //在赋值前
    NSIndexPath *oldInxdexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    NSIndexPath *newInxdexPath = indexPath;
    //赋值
    self.selectedIndex = indexPath.row;
    [self.leftTableView reloadRowsAtIndexPaths:@[oldInxdexPath, newInxdexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    
    [self requestSetList];
}

#pragma mark -  UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.rightCollectionDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKOderChooseSeatNumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    [cell setValueWithModel:self.rightCollectionDataArr[indexPath.row]];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    
    XKTradingAreaSeatListModel *seatModel = self.rightCollectionDataArr[indexPath.row];
    [XKHudView showLoadingTo:self.view animated:YES];
    [XKSquareTradingAreaTool tradingAreaVerifierOrderSeat:@{@"shopId":self.shopId ? self.shopId : @"",
                                                            @"seatId":seatModel.seatId ? seatModel.seatId : @""}
                                                  success:^(XKTradingAreaSeatVerifyModel *model) {
                                                      [XKHudView hideHUDForView:self.view];
                                                      self.seatVerifyModel = model;
                                                      //被占用
                                                      if (model.orderCipher) {
                                                          
                                                          UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该席位被占用，是否输入密码进入席位？" preferredStyle:(UIAlertControllerStyleAlert)];
                                                          [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                                              textField.placeholder = @"请输入席位密码";
                                                              textField.keyboardType = UIKeyboardTypeNumberPad;
                                                              [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                                                          }];
                                                          UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
                                                          UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                                                              //验证
                                                              if ([self.seatVerifyModel.orderCipher isEqualToString:self.verifyCode]) {
                                                                  XKTradingAreaOrderDetailViewController *vc = [[XKTradingAreaOrderDetailViewController alloc] init];
                                                                  vc.orderId = self.seatVerifyModel.orderId;
                                                                  [self.navigationController pushViewController:vc animated:YES];
                                                              } else {
                                                                  [XKHudView showErrorMessage:@"席位密码错误"];
                                                              }
                                                          }];
                                                          [alertVC addAction:cancel];
                                                          [alertVC addAction:sure];
                                                          [self presentViewController:alertVC animated:YES completion:nil];
                                                          
                                                      } else {
                                                          //没被占用
                                                          if (seatModel.images.count) {//有图
                                                              XKSeatNumDetailViewController *vc = [[XKSeatNumDetailViewController alloc] init];
                                                              vc.dataSource = seatModel.images;
                                                              vc.selected = seatModel.isSelected;
                                                              XKWeakSelf(weakSelf);
                                                              vc.refreshSetBlock = ^{
                                                                  [weakSelf resetDatasoureWithIndexPath:indexPath seatModel:seatModel];
                                                              };
                                                              [self.navigationController pushViewController:vc animated:YES];
                                                              
                                                          } else {
                                                              [self resetDatasoureWithIndexPath:indexPath seatModel:seatModel];
                                                          }
                                                      }
                                                  } faile:^(XKHttpErrror *error) {
                                                      [XKHudView hideHUDForView:self.view];
                                                  }];
}

- (void)textFieldDidChange:(UITextField *)textField {
    self.verifyCode = textField.text;
}

//判断是否达到最大数
- (BOOL)judgeMaxSeatNum {
    
    NSArray *arr = self.selectedSetMuDic.allValues;
    NSMutableArray *totalArr = [NSMutableArray array];
    for (NSArray *subArr in arr) {
        [totalArr addObjectsFromArray:subArr];
    }
    if (totalArr.count >= self.maxSeat) {
        [XKHudView showErrorMessage:@"您的席位数已达上限，不能再选"];
        return YES;
    }
    return NO;
}

- (void)resetDatasoureWithIndexPath:(NSIndexPath *)indexPath seatModel:(XKTradingAreaSeatListModel *)model {
    
    //先判断最大数 (如果是没被选中时候才判断)
    if (!model.isSelected) {
        if ([self judgeMaxSeatNum]) {
            return;
        }
    }
    
    
    NSMutableArray *muarr = self.selectedSetMuDic[model.seatTypeId];
    if (muarr.count) {
        NSMutableArray *newMuArr = [NSMutableArray arrayWithArray:muarr];
        BOOL have = NO;
        for (XKTradingAreaSeatListModel *setItem in muarr) {
            if ([model.seatId isEqualToString:setItem.seatId]) {//说明存在 则是移除
                have = YES;
                [newMuArr removeObject:setItem];
                break;
            }
        }
        if (!have) {
            [newMuArr addObject:model];
        }
        //重新复制
        [self.selectedSetMuDic setObject:newMuArr forKey:model.seatTypeId];
    } else {
        //重新复制
        NSMutableArray *newMuArr = [NSMutableArray arrayWithObject:model];
        [self.selectedSetMuDic setObject:newMuArr forKey:model.seatTypeId];
    }

    model.isSelected = !model.isSelected;
    [self.rightCollectionDataArr replaceObjectAtIndex:indexPath.row withObject:model];
    [self.rightCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    [self.leftTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - coustomDelegate



#pragma mark - coustomBlock


#pragma mark - setter && getter

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _leftTableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.rowHeight = 50;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}

- (UICollectionView *)rightCollectionView {
    
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumInteritemSpacing = 0.f;
        flowlayout.minimumLineSpacing = 0.5f;
        flowlayout.itemSize = CGSizeMake((int)((SCREEN_WIDTH - 114*ScreenScale) / 3), (int)((SCREEN_WIDTH - 114*ScreenScale) / 3));
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        
        [_rightCollectionView registerClass:[XKOderChooseSeatNumCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _rightCollectionView;
}



- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn addTarget:self action:@selector(sureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = XKRegularFont(16);
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _sureBtn;
}


@end
