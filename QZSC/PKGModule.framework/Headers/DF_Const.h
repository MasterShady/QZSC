//
//  DF_Const.h
//  Pods
//
//  Created by 刘思源 on 2023/7/25.
//


#import <Foundation/Foundation.h>

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kAppName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] ? [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]

extern NSString *const df_previewReleaseServer;
extern NSString *const df_releaseServer;
extern NSString *const df_getAppInfo;
extern NSString *const df_ReportUpdateNotification;
extern NSString *const df_getBoxId;

//// "http://10.10.24.178:9502/"
//let kPreviewReleaseServer = "y8t9CH2JZL+bDlhL5DFy8dFJMC8tHD0OW8oCvL2puX0=".aes256decode()
//// "https://zhwapp.zuhaowan.com/"
//let kReleaseServer = "92oF/dBJpAX/GO4OdACniKAup2kndh7nMEa27TMeEXM=".aes256decode()
