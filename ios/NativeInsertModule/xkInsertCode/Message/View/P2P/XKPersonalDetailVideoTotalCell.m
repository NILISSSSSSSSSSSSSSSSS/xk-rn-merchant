/*******************************************************************************
 # File        : XKPersonalDetailVideoTotalCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/26
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKPersonalDetailVideoTotalCell.h"
#import "XKVideoDisplayModel.h"
#import "XKVideoDisplayMediator.h"

@interface XKPersonalDetailVideoTotalCell ()
/**内容父视图*/
@property(nonatomic, strong) UIView *imgSuperView;
@end

@implementation XKPersonalDetailVideoTotalCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.backgroundColor = UIColorFromRGB(0xEEEEEE);

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {

}

#pragma mark - 初始化界面
- (void)createUI {
    _imgSuperView = [UIView new];
    [self.contentView addSubview:_imgSuperView];
    [_imgSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        make.height.equalTo(@1);
    }];
}

#pragma mark - 播放
- (void)playVideoIndex:(NSInteger)index {
    [XKVideoDisplayMediator displaySingleVideoWithViewController:self.getCurrentUIVC videoListItemModel:self.dataArray[index]];
}

- (void)setDataArray:(NSMutableArray<XKVideoDisplayVideoListItemModel *> *)dataArray {
    _dataArray = dataArray;
    [_imgSuperView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
//    CGFloat 177 227
    CGFloat space = 1.5;
    CGFloat imgWidth = (SCREEN_WIDTH - 20 - space) / 2;
    CGFloat imgHeight = (int)(imgWidth * 227 / 177.0);
    
    CGFloat x = 0;
    CGFloat y = 0;
    NSInteger index = 1;
    UIImageView *lastImageView;
    __weak typeof(self) weakSelf = self;
    for (XKVideoDisplayVideoListItemModel *item in dataArray) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:kURL(item.video.first_cover) placeholderImage:kDefaultPlaceHolderImg];
        [_imgSuperView addSubview:imageView];
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake(x, y, imgWidth, imgHeight);
        if (index % 2 == 0) {
            y = y + imgHeight + space;
            x = 0;
        } else {
            x = x + imgWidth + space;
        }
        [imageView bk_whenTapped:^{
            [weakSelf playVideoIndex:index - 1];
        }];
        index ++;
        lastImageView = imageView;
        imageView.userInteractionEnabled = YES;
    }
    [_imgSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lastImageView.bottom);
    }];
}


#pragma mark ----------------------------- 公用方法 ------------------------------

@end
