//
//  DDDLogFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN_INLINE void DDDLog(NSString * msg);

FOUNDATION_EXTERN_INLINE void DDDWarning(NSString * msg);

FOUNDATION_EXTERN_INLINE void DDDError(NSString * msg);


typedef enum : NSUInteger {
    DDDLogLevelNone = 0,
    DDDLogLevelNormal = 1<<1,
    DDDLogLevelWarning = 1<<2,
    DDDLogLevelError = 1<<3,
    DDDLogLevelAll = DDDLogLevelError | DDDLogLevelNormal| DDDLogLevelWarning
} DDDLogLevel;




