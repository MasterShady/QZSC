//
//  DDDHMCloudSuspendViewFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import "DDDHMCloudSuspendViewFFF.h"
#import "DDDUtilsFFF.h"
#import <math.h>
static CGFloat  suspendWidth = 70;

@interface DDDHMCloudSuspendViewFFF()

@property(nonatomic)BOOL island;

@property(strong)UIImageView * button;
@end

@implementation DDDHMCloudSuspendViewFFF

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGFloat)maxHeight{
    
    return _island ? fminf(DDDScreenWidth, DDDScreenHeight):fmaxf(DDDScreenWidth, DDDScreenHeight);
}

-(CGFloat)maxWidth{
    
    return !_island ? fminf(DDDScreenWidth, DDDScreenHeight):fmaxf(DDDScreenWidth, DDDScreenHeight);
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+(instancetype)suspendViewWith:(UIView *)superView{
    
    DDDHMCloudSuspendViewFFF * view = [[DDDHMCloudSuspendViewFFF alloc] initWithFrame:CGRectZero];
    
    [superView addSubview:view];
    
    [view uiConfigure];
    return view;
}

-(void)uiConfigure{
    
    _island = YES;
    
    CGFloat min_x = suspendWidth/2;
    
    BOOL isRight = UIApplication.sharedApplication.statusBarOrientation == UIDeviceOrientationLandscapeRight;
    
    if (isRight){
        
        min_x += self.superview.safeAreaInsets.left;
    }
    
    self.frame = CGRectMake(min_x, ([self maxHeight] - suspendWidth)/2, suspendWidth, suspendWidth);
    
    _button = [[UIImageView alloc] initWithImage:DDDGetImageFFF(@"suspend_btn", YES)];
    
    _button.frame = self.bounds;
    
    [_button setUserInteractionEnabled:YES] ;
    
    [_button addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClicked)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientNotification) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UIPanGestureRecognizer * pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEvent:)];
    [self addGestureRecognizer:pangesture];
}

-(void)buttonClicked{
    
    self.clickCallBack != nil ? self.clickCallBack() : nil;
}
-(void)orientNotification{
    
    CGFloat centerX = CGRectGetMidX(self.frame);
    CGFloat centerY = CGRectGetMidY(self.frame);
    
    if (centerX <= [self maxWidth]/2){
        
        
        CGFloat mid_x = 0;
        
        BOOL isRight = UIApplication.sharedApplication.statusBarOrientation == UIDeviceOrientationLandscapeRight;
        
        if (isRight){
            
            mid_x += self.superview.safeAreaInsets.left;
        }
        
        self.center = CGPointMake(mid_x, centerY);
    }else{
        CGFloat mid_x = [self maxWidth];
        
        BOOL isLeft = UIApplication.sharedApplication.statusBarOrientation == UIDeviceOrientationLandscapeLeft;
        
        if (isLeft){
            
            mid_x -= self.superview.safeAreaInsets.right;
        }
        
        self.center = CGPointMake(mid_x, centerY);
    }
    
    
}

-(void)panEvent:(UIPanGestureRecognizer *)gesture{
    
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:
        {
            self.center = [gesture locationInView:self.superview];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            CGPoint endPoint = [gesture locationInView:self.superview];
            
            CGPoint adjustCenter = CGPointZero;
            
            if (endPoint.y < suspendWidth/2){
                
                adjustCenter.y = suspendWidth/2;
            }
            else if (endPoint.y > [self maxHeight] - suspendWidth/2){
                
                adjustCenter.y = [self maxHeight] - suspendWidth/2;
            }else{
                
                adjustCenter.y = endPoint.y;
            }
            
            
            if (endPoint.x <= [self maxWidth]/2){
                
                CGFloat mid_x = 0;
                
                BOOL isRight = UIApplication.sharedApplication.statusBarOrientation == UIDeviceOrientationLandscapeRight;
                
                if (isRight){
                    
                    mid_x += self.superview.safeAreaInsets.right;
                }
                
                adjustCenter.x = mid_x;
            }else{
                
                CGFloat mid_x = [self maxWidth];
                
                BOOL isLeft = UIApplication.sharedApplication.statusBarOrientation == UIDeviceOrientationLandscapeLeft;
                
                if (isLeft){
                    
                    mid_x -= self.superview.safeAreaInsets.left;
                }
                
                adjustCenter.x = mid_x;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.center = adjustCenter;
            }];
            
        }
            break;
        default:
            break;
    }
    
}
@end
