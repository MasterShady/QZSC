//
//  DDDGuideInfoFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDGuideInfoFFF : NSObject

@property NSInteger type;

@property (nonatomic,strong)UIViewController * viewController;

@property BOOL isCloudGame;

@property(nonatomic,strong)NSArray * urls;
@end

NS_ASSUME_NONNULL_END
