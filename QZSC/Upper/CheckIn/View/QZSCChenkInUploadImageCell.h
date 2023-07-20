//
//  QZSCChenkInUploadImageCell.h
//  QZSC
//
//  Created by zzk on 2023/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZSCChenkInUploadImageCell : UICollectionViewCell

@property(nonatomic, assign) BOOL showDelete;
@property(nonatomic, strong) UIImage *contentImg;
@property(nonatomic, copy) void (^deleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
