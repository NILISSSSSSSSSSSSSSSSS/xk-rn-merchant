/*******************************************************************************
 # File        : TagsDisplayCollectionCell
 # Project     : Erp4iOS
 # Author      : Jamesholy
 # Created     : 2017/11/21
 # Corporation :
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "TagsDisplayCollectionCell.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>

@interface TagsDisplayCollectionCell()
/**label*/
@property(nonatomic, strong) UILabel *label;
@end

@implementation TagsDisplayCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self creatUI];
        self.backgroundColor = [UIColor clearColor];
		self.contentView.layer.cornerRadius = 12.5;
		self.contentView.layer.borderColor = XKMainTypeColor.CGColor;
		self.contentView.layer.borderWidth = 1;

	}
	return self;
}

- (void)creatUI {
	_label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
	[self.contentView addSubview:_label];
	_label.font = [UIFont systemFontOfSize:12];
	[_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
	}];
}

- (void)setBeSelected:(BOOL)beSelected {
    _beSelected = beSelected;
    if (beSelected) {
        self.contentView.backgroundColor = XKMainTypeColor;
        self.label.textColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];;
        self.label.textColor = XKMainTypeColor;
    }
}


- (void)setText:(NSString *)text {
	self.label.text = text;
}

+ (CGSize)cellSize:(NSString *)text {
	CGFloat width = [text getWidthStrWithFontSize:12 height:18];
	return CGSizeMake(width + 10 + 10, 25);
}

@end


@implementation TagsDisplayInfo


@end
