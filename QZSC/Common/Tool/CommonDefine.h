//
//  CommonDefine.h
//  DFSQ
//
//  Created by zhouc on 2023/3/17.
//

#ifndef CommonDefine_h
#define CommonDefine_h


#define kServerIP @"https://www.haiyougou.cn"
#define kRC4EncryKey @"dfsq@1q2w3e4r!!"

// 通用宏定义
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

#define kAppName  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 等比例
#define kScaleWidth(w)            (((w) / 375.0) * kScreenWidth)
#define KScaleHeight(w)           (((w) / 812.0) * kScreenHeight)

#define kWeakSelf(type) __weak typeof(type) weak##type=type;
#define kStrongSelf(type) __strong typeof(type) type=weak##type;

#ifdef DEBUG
#define DLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define DLog(...)
#endif

//判断当前iOS版本
#define kIOS_VERSION [UIDevice currentDevice].systemVersion

#define kIsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

#define kStringNoEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? @"" : str )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//获取temp
#define kPathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

// 通知名称
#define kNotificationLoginOrRegisterName @"kNotificationLoginOrRegisterName"
#define kNotificationLogOffName @"kNotificationLogOffName"

#define kNotificationPingBiRefresh @"kNotificationPingBiRefresh"
 
#endif /* CommonDefine_h */
