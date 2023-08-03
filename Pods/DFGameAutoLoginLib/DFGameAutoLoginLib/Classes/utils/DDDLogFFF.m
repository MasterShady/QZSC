//
//  DDDLogFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//
#include "DDDLogFFF.h"



#import "DDDOtherInfoWrapFFF.h"

inline void DDDLog(NSString * msg);
inline void DDDWarning(NSString * msg);
inline void DDDError(NSString * msg);


inline void DDDLog(NSString * msg){
    
    
    
    if ([DDDOtherInfoWrapFFF shared].loglevel & DDDLogLevelNormal){
       
        NSLog(@"%@",msg);
      
    }
    
}


inline void DDDWarning(NSString * msg){
    
    if ([DDDOtherInfoWrapFFF shared].loglevel & DDDLogLevelWarning){
        
        NSLog(@"%@",msg);
    }
}
inline void DDDError(NSString * msg){
    
    if ([DDDOtherInfoWrapFFF shared].loglevel & DDDLogLevelError){
        
        NSLog(@"%@",msg);
    }
}
