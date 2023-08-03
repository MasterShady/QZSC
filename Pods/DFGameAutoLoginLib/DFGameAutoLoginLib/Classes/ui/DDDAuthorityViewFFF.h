//
//  DDDAuthorityViewFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDAuthorityViewFFF : UIView

@property(nonatomic,copy)void(^launchGameBlock)(void);




-(void)show;


@end

@interface SWLGAuthorityCourseView : UIView
@property(nonatomic,copy)void(^confirmBlock)(void);

-(void)setUrl:(NSString *)url;
@end



NS_ASSUME_NONNULL_END
