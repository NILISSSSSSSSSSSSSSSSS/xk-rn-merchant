////
////  XKWelfareJoinBuyCarView.m
////  XKSquare
////
////  Created by 刘晓霖 on 2018/8/24.
////  Copyright © 2018年 xk. All rights reserved.
////
//
#import "XKWelfareGoodsDetailShareView.h"
//#import "XKWelfareShareViewInfoCell.h"
//#import "XKContactListController.h"
//#import "XKWelfareShareViewShareCell.h"
//#import "XKIMGlobalMethod.h"
//#import "XKCollectGoodsModel.h"
//#import "XKCollectWelfareModel.h"
@interface  XKWelfareGoodsDetailShareView ()//<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//@property (nonatomic, strong) UICollectionView *collectionView;
//
//@property (nonatomic, strong) UIView *headerView;
//@property (nonatomic, strong) UIImageView *headerImgView;
//@property (nonatomic, strong) UIView *headerLineView;
//
//@property (nonatomic, strong) UIView *footerView;
//@property (nonatomic, strong) UIButton *footerBtn;
//@property (nonatomic, strong) UIView *footerLineView;
//
//@property (nonatomic, strong) NSArray *titleArr;
//@property (nonatomic, strong) NSArray *imgArr;
@end
//
@implementation XKWelfareGoodsDetailShareView
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if(self) {
//        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 8.f;
//        self.layer.masksToBounds = YES;
//        self.clipsToBounds = YES;
//        [self handleData];
//        [self addCustomSubviews];
//        [self addUIConstraint];
//    }
//    return self;
//}
//
//- (void)handleData {
//    _titleArr = @[@"朋友圈",@"微信好友",@"QQ",@"微博",@"我的朋友",@"复制链接"];
//    _imgArr = @[@"xk_icon_welfaregoods_share_friendCycle",@"xk_icon_welfaregoods_share_WeChat",@"xk_icon_welfaregoods_share_QQ",@"xk_icon_welfaregoods_share_Weibo",@"xk_icon_welfaregoods_share_MyFriend",@"xk_icon_welfaregoods_share_copy"];
//}
//
//- (void)addCustomSubviews {
//    [self.headerView addSubview:self.headerImgView];
//    [self.headerView addSubview:self.headerLineView];
//    
//    [self.footerView addSubview:self.footerBtn];
//    [self.footerView addSubview:self.footerLineView];
//   
//}
//
//- (void)addUIConstraint {
//
//    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.left.equalTo(self.headerView);
//    }];
//    
//    [self.headerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(self.headerView);
//        make.height.mas_equalTo(1);
//    }];
//    
//    [self.footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.footerView);
//        make.centerY.equalTo(self.footerView.mas_centerY);
//        make.height.mas_equalTo(35 * SCREEN_WIDTH / 375);
//    }];
//    
//    [self.footerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.footerView);
//        make.height.mas_equalTo(1);
//    }];
//    
//    [self addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.equalTo(self);
//    }];
//}
//
//#pragma mark 响应事件
//- (void)closeBtnClick:(UIButton *)sender {
//
//}
//
//- (void)footerBtnClick:(UIButton *)sender {
//    if(self.closeBlock) {
//        self.closeBlock();
//    }
//}
//
//- (void)setShareModel:(XKGoodsShareModel *)shareModel {
//    if (shareModel) {
//        [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:shareModel.param.base.defaultSku.url] placeholderImage:kDefaultPlaceHolderImg];
//        _shareModel = shareModel;
//        [self.collectionView reloadData];
//    }
//}
//
//- (void)setWelfareShareModel:(XKWelfareShareModel *)welfareShareModel {
//    if (welfareShareModel) {
//        [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:welfareShareModel.param.sequence.goods.mainPic] placeholderImage:kDefaultPlaceHolderImg];
//        _welfareShareModel = welfareShareModel;
//        [self.collectionView reloadData];
//    }
//}
//#pragma mark collectionview代理 数据源
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 2;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return section == 0 ? 1 : 6;
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UIView *contentView;
//    NSString *identifier;
//    if(indexPath.section == 0) {
//        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//            identifier = @"XKWelfareShareHeader";
//            contentView = self.headerView;
//            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
//            [view addSubview:contentView];
//            return view;
//        } else {
//            return nil;
//        }
//    } else {
//         if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//             identifier = @"XKWelfareShareFooter";
//             contentView = self.footerView;
//             UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
//             [view addSubview:contentView];
//             return view;
//         } else {
//             return nil;
//         }
//    }
//
//}
//
//// 设置section头视图的参考大小，与tableheaderview类似
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
//referenceSizeForHeaderInSection:(NSInteger)section {
//    return section == 0 ? CGSizeMake(SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375, 210 * SCREEN_WIDTH / 375) : CGSizeZero;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return section == 1 ? CGSizeMake(SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375, 36 * SCREEN_WIDTH / 375) : CGSizeZero;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 0) {
//        XKWelfareShareViewInfoCell *info = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareShareViewInfoCell" forIndexPath:indexPath];
//        if (_shareModel) {
//             [info updateInfoWithItem:_shareModel];
//        } else {
//            [info updateWelfareInfoWithItem:_welfareShareModel];
//        }
//       
//        return info;
//    } else {
//        XKWelfareShareViewShareCell *share = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareShareViewShareCell" forIndexPath:indexPath];
//        [share updateItemName:_titleArr[indexPath.row] AndIconName:_imgArr[indexPath.row]];
//        return share;
//    }
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return indexPath.section == 0 ? CGSizeMake(SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375, 86 * SCREEN_WIDTH / 375) : CGSizeMake(ceil((SCREEN_WIDTH - 150 * SCREEN_WIDTH / 375) / 4), 75 * SCREEN_WIDTH / 375) ;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return section == 0 ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, 20 * SCREEN_WIDTH / 375, 0, 20 * SCREEN_WIDTH / 375);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return section == 0 ? 0 : 10;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    if(indexPath.section == 1) {
//        [self handleShare:indexPath.row];
//    }
//
//}
//
//- (void)handleShare:(NSInteger )index {
//    NSString *linkUrl;
//    NSString *linkText;
//    NSString *urlStr;
//     if (_shareModel) {
//         linkUrl = _shareModel.shareUrl;
//         linkText = _shareModel.param.base.name;
//         urlStr = _shareModel.param.base.defaultSku.url;
//     } else {
//         linkUrl = _welfareShareModel.shareUrl;
//         linkText = _welfareShareModel.param.sequence.goods.name;
//         urlStr = _welfareShareModel.param.sequence.goods.mainPic;
//     }
//    switch (index) {
//        case 0://朋友圈
//            {
//                [[XKShareManager shared] shareLinkUrl:linkUrl LinkText:linkText LinkTitle:@"商品分享" LinkImageURL:urlStr WithPlatform:JSHAREPlatformWechatTimeLine];
//            }
//            break;
//        case 1://微信好友
//            {
//                [[XKShareManager shared] shareLinkUrl:linkUrl LinkText:linkText LinkTitle:@"商品分享" LinkImageURL:urlStr WithPlatform:JSHAREPlatformWechatSession];
//            }
//            break;
//        case 2://QQ
//            {
//                [[XKShareManager shared] shareLinkUrl:linkUrl LinkText:linkText LinkTitle:@"商品分享" LinkImageURL:urlStr WithPlatform:JSHAREPlatformQQ];
//            }
//            break;
//        case 3://微博
//            {
//                [[XKShareManager shared] shareLinkUrl:linkUrl LinkText:linkText LinkTitle:@"商品分享" LinkImageURL:urlStr WithPlatform:JSHAREPlatformSinaWeibo];
//            }
//            break;
//        case 4://我的好友
//            {
//                if (self.closeBlock) {
//                    self.closeBlock();
//                }
//                
//                XKContactListController *vc = [[XKContactListController alloc] init];
//                vc.useType = XKContactUseTypeSingleSelectWithoutCheck;
//                vc.title = @"选择联系人";
//                [vc setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
//                    [listVC.navigationController popViewControllerAnimated:YES];
//                    if (contacts.count) {
//                        XKContactModel *contact = contacts.firstObject;
//                        
//                        if (self.shareModel) {
//                            // 分享商品
//                            XKCollectGoodsTarget *target = [[XKCollectGoodsTarget alloc] init];
//                            XKCollectGoodsDataItem *goods = [[XKCollectGoodsDataItem alloc] init];
//                            target.targetId = self.shareModel.param.goodsAttrs.goodsId;
//                            target.showPics = self.shareModel.param.base.defaultSku.url;
//                            target.name = self.shareModel.param.base.name;
//                            target.mouthVolume = self.shareModel.param.quantity;
//                            target.price = self.shareModel.param.base.costPrice;
//                            goods.target = target;
//                            
//                            NSMutableArray *tempArray = [NSMutableArray array];
//                            [tempArray addObject:goods];
//                            
//                            [XKIMGlobalMethod sendShareWithShareArray:tempArray session:[NIMSession session:contact.userId type:NIMSessionTypeP2P]];
//                        }
//                        if (self.welfareShareModel) {
//                            // 分享福利
//                            
//                            Target *target = [[Target alloc] init];
//                            XKCollectWelfareDataItem *welfare = [[XKCollectWelfareDataItem alloc] init];
//                            target.targetId = self.welfareShareModel.param.sequence.goods.ID;
//                            target.showPics = self.welfareShareModel.param.sequence.goods.mainPic;
//                            target.name = self.welfareShareModel.param.sequence.goods.name;
//                            target.showAttr = self.welfareShareModel.param.sequence.goods.atrrName;
//                            target.perPrice = self.welfareShareModel.param.sequence.lotteryWay.totalPrice;
//                            welfare.target = target;
//                            
//                            NSMutableArray *tempArray = [NSMutableArray array];
//                            [tempArray addObject:welfare];
//                            
//                            [XKIMGlobalMethod sendShareWithShareArray:tempArray session:[NIMSession session:contact.userId type:NIMSessionTypeP2P]];
//                        }
//                    }
//                }];
//                [[UIViewController getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//                if (self.closeBlock) {
//                    self.closeBlock();
//                }
//            }
//            break;
//        case 5://复制链接
//            {
//                [XKHudView showSuccessMessage:@"复制成功!"];
//                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                pasteboard.string = linkUrl;
//               
//            }
//            break;
//            
//        default:
//            break;
//    }
//}
//
//
//#pragma mark 懒加载
//- (UICollectionView *)collectionView {
//    if(!_collectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(30 * SCREEN_WIDTH / 375 ,75 * SCREEN_WIDTH / 375,SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375,500 * SCREEN_WIDTH / 375) collectionViewLayout:layout];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = [UIColor clearColor];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKWelfareShareHeader"];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XKWelfareShareFooter"];
//        [_collectionView registerClass:[XKWelfareShareViewInfoCell class] forCellWithReuseIdentifier:@"XKWelfareShareViewInfoCell"];
//        [_collectionView registerClass:[XKWelfareShareViewShareCell class] forCellWithReuseIdentifier:@"XKWelfareShareViewShareCell"];
//        
//    }
//    return _collectionView;
//}
//
//- (UIView *)headerView {
//    if(!_headerView) {
//        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375, 210 * SCREEN_WIDTH / 375)];
//        _headerView.backgroundColor = [UIColor whiteColor];
//    }
//    return _headerView;
//}
//
//- (UIImageView *)headerImgView {
//    if(!_headerImgView) {
//        _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375, 210 * SCREEN_WIDTH / 375)];
//        _headerImgView.backgroundColor = [UIColor whiteColor];
//        _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
//        _headerImgView.clipsToBounds = YES;
//    }
//    return _headerImgView;
//}
//
//- (UIView *)headerLineView {
//    if(!_headerLineView) {
//        _headerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 210 * SCREEN_WIDTH / 375, SCREEN_WIDTH - 50, 1)];
//        _headerLineView.backgroundColor = XKSeparatorLineColor;
//    }
//    return _headerLineView;
//}
//
//- (UIView *)footerView {
//    if(!_footerView) {
//        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375, 36 * SCREEN_WIDTH / 375)];
//        _footerView.backgroundColor = [UIColor whiteColor];
//    }
//    return _footerView;
//}
//
//- (UIButton *)footerBtn {
//    if(!_footerBtn) {
//        _footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375, 35 * SCREEN_WIDTH / 375)];
//        [_footerBtn setTitle:@"关闭" forState:0];
//        _footerBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
//        _footerBtn.titleLabel.font = XKRegularFont(14);
//        [_footerBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
//        [_footerBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _footerBtn;
//}
//
//- (UIView *)footerLineView {
//    if(!_footerLineView) {
//        _footerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375, 1)];
//        _footerLineView.backgroundColor = XKSeparatorLineColor;
//    }
//    return _footerLineView;
//}
//
@end
