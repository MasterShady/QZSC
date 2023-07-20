//
//  QZSCChenkInUploadImageCell.m
//  QZSC
//
//  Created by zzk on 2023/7/18.
//

#import "QZSCChenkInUploadImageCell.h"

@interface QZSCChenkInUploadImageCell ()

@property(nonatomic, strong) UIImageView *picImgView;
@property(nonatomic, strong) UIButton *deleteBtn;

@end

@implementation QZSCChenkInUploadImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _picImgView = [[UIImageView alloc] init];
    _picImgView.frame = self.bounds;
    _picImgView.contentMode = UIViewContentModeScaleAspectFill;
    _picImgView.layer.cornerRadius = 4;
    _picImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_picImgView];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(60, 0, 20, 20);
    [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setImage:[UIImage imageNamed:@"order_close"] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteBtn];
    
}

- (void)btnClick:(UIButton *)btn {
    if (self.deleteBlock != nil) {
        self.deleteBlock();
    }
}

- (void)setShowDelete:(BOOL)showDelete {
    _showDelete = showDelete;
    
    _deleteBtn.hidden = showDelete;
}

- (void)setContentImg:(UIImage *)contentImg {
    _contentImg = contentImg;
    _picImgView.image = contentImg;
}

@end
