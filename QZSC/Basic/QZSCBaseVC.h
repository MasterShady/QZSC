//
//  QZSCBaseVC.h
//  QZSC
//
//  Created by lsy on 2023/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZSCBaseVC : UIViewController

@property(nonatomic, strong) UIView* customNavBar;
@property(nonatomic, copy) NSString *navTitle;
@property(nonatomic, assign) BOOL hidenBar;
@property(nonatomic, assign) BOOL hidenTitleL;

@property(nonatomic, strong) UIImage *backBtnImg;
@property(nonatomic, strong) UIColor *titleColor;

@property(nonatomic, copy) void (^reloadDataBlock)(void);

- (void)leftBtnClick;

@end

NS_ASSUME_NONNULL_END
