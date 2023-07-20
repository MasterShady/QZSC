//
//  CommonDefine.h
//  QZSC
//
//  Created by zzk on 2023/7/19.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

#define kStatusBarHight [UIDevice vg_statusBarHeight]
#define kHomeIndicatorHight [UIDevice vg_safeDistanceBottom]
#define kNavBarHight [UIDevice vg_navigationBarHeight]
#define KNavBarFullHight [UIDevice vg_navigationFullHeight]
#define KTabBarHight [UIDevice vg_tabBarHeight]
#define KTabBarFullHight [UIDevice vg_tabBarFullHeight]

#define kFontNormal(s) [UIFont normal:s]
#define kFontMedium(s) [UIFont medium:s]
#define kFontSemibload(s) [UIFont semibload:s]

#define kColorHex(hex) [UIColor colorWithHexString:hex]
#define kColorHexA(hex, a) [UIColor colorWithHexString:hex alpha:a]

#define kImageName(name) [UIImage imageNamed: name]

#endif /* CommonDefine_h */
