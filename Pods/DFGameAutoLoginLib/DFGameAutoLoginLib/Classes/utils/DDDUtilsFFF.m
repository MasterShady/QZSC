//
//  DDDUtilsFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDUtilsFFF.h"
#import "DDDHttpToolFFF.h"
#import "DDDOtherInfoWrapFFF.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonHMAC.h>

#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "DDDCriptsFFF.h"


inline dispatch_source_t DDDTimer(NSInteger step,void(^block)(void)){
    
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    // 设置定时器的事件处理程序
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW , NSEC_PER_SEC * step, 0);
    
    // 绑定定时器到主队列
    
    
    dispatch_source_set_event_handler(timer, ^{
        // 在这里编写定时器触发时需要执行的操作
        
        block();
    });
    
    
    
    return timer;
}

CGFloat DDDScale_Height(CGFloat height){
    
    CGFloat scale = DDDScreenWidth/375;
    return  scale * height;
}

CGFloat DDDScale_Width(CGFloat width){
    
    CGFloat scale = DDDScreenHeight/667;
    return  scale * width;
}

UIImage * DDDGetImageFFF(NSString * name,BOOL adjust){
    
   NSString * bundlepath = [DDDUtilsFFF getCurrentBundle].bundlePath;
    
    NSString * adjust_des = @"";
    
    if (adjust) {
        
        adjust_des = [NSString stringWithFormat:@"@%dx",(int)UIScreen.mainScreen.scale];
    }
    
    NSString * path_image = [NSString stringWithFormat:@"%@/%@%@.png",bundlepath,name,adjust_des];
    
    return [UIImage imageWithContentsOfFile:path_image];
}




inline void DDDToast(NSString * message){
    
    
}

@implementation DDDUtilsFFF

+(NSString *)zhongtai_aesKey{
    
    if ([DDDHttpToolFFF defaultTool].api_env == MJHttpServerEnv_release){
        
        return @"gMmb8PXBCYyc9CPRx0BMvyPUqVD4ayqH";
    }else{
        
        return @"WYdvTDlB/OOXQM5v9V6LwU/rUVQARIF1";
    }
}
+(id)zhongTai_dataWith:(NSString *)data
        withModelClass:(Class)modelClass{
    
    NSString * json = [DDDAESFFF AES256DecryptECB:data key:[self zhongtai_aesKey]];
    
    return [modelClass yy_modelWithJSON:json];
}

+ (UIViewController *)getCurrentViewController {
    UIViewController* currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return currentViewController;
}


+(NSBundle *)getCurrentBundle{
    
    NSBundle * podBundle = [NSBundle bundleForClass:self];
    
    NSURL * bundleurl = [podBundle URLForResource:@"DFToGameLibBundle" withExtension:@"bundle"];
    
    if (bundleurl == nil){
        
        if ([[podBundle bundlePath] containsString:@"DFGameAutoLoginLib.framework"]){
            
            return podBundle;
        }
    }
    
    if (bundleurl != nil){
        
        NSBundle * bundle = [NSBundle bundleWithURL:bundleurl];
        
        return  bundle;
    }else{
        
        return NSBundle.mainBundle;
    }
}
+(NSString *)getAppVersion{
    
    return  [DDDOtherInfoWrapFFF shared].appversion;
}

+(NSDictionary *)httpSign:(NSDictionary *)datas
                  withkey:(NSString *)key{
    
    NSMutableDictionary *Mdic = [NSMutableDictionary dictionaryWithDictionary:datas];
    
    NSString *timestamp = Mdic[@"timestamp"];
    
    //添加当前时间戳
    if (timestamp.length <= 0) {
        NSString *timestamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];//时间戳
        [Mdic setValue:timestamp forKey:@"timestamp"];
    }
    
    /**
     随机字符串
     */
    [Mdic setValue:[self randomStrWithLenth:8] forKey:@"signature_nonce"];
    
    NSArray *keyArr = [[Mdic allKeys] sortedArrayUsingSelector:@selector(compare:)];//区分大小写
    
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    
    for (int i=0; i<[keyArr count]; i++) {
        NSString *key = [keyArr objectAtIndex:i];
        NSString *value = (NSString *)[Mdic objectForKey:[keyArr objectAtIndex:i]];
        NSString *KEY = [NSString stringWithFormat:@"%@",key];
        NSString *VALUE1 = [NSString stringWithFormat:@"%@",value];
        if (i == keyArr.count - 1) {
            [string appendFormat:@"%@=%@",KEY,[self URLEncodedString:VALUE1]];
        }else{
            [string appendFormat:@"%@=%@&",KEY,[self URLEncodedString:VALUE1]];
        }
    }
    
    /**
     对 string 进行hmacSHA1加密
     */
    NSString *hmac_str = [[self hmacSHA1WithKey:key str:string] lowercaseString];
    
    /**
     hmac_str 进行base64编码
     */
    NSString *signature = [self base64EncodedStringWithStr:hmac_str];
    
    NSMutableDictionary *Mparams = [NSMutableDictionary dictionaryWithDictionary:Mdic];
    
    [Mparams setValue:signature forKey:@"signature"];
    
    return Mparams;
}



/*
 随机生成字符串(由大小写字母、数字组成)
 长度大于等于8
 */
+ (NSString *)randomStrWithLenth:(int)len {
    char ch[len];
    for (int index = 0; index < len; index++) {
        int num = arc4random_uniform(75) + 48;
        if (num > 57 && num < 65) {
            num = num % 57 + 48;
        }else if (num > 90 && num < 97) {
            num = num % 90 + 65;
        }
        ch[index] = num;
    }
    return [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
}

/**
 UTF8编码
 */
+ (NSString *)URLEncodedString:(NSString *)str{
    
    
    return AFPercentEscapedStringFromString(str);
}
/**
 hmac-sha1加密方式
 */
+ (NSString *)hmacSHA1WithKey:(NSString *)key str:(NSString *)str {
    
    NSData *hashData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char *digest;
    digest = malloc(CC_SHA1_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    
    NSString *encode = [self stringFromBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    
    free(digest);
    cKey = nil;
    return encode;
}

+ (NSString *)base64EncodedStringWithStr:(NSString *)hmacStr {
    
    NSData *data = [hmacStr dataUsingEncoding:NSUTF8StringEncoding];

    return [data base64EncodedStringWithOptions:0];
    
}

/**
 字符大小写可以通过修改“%02X”中的x修改,下面采用的是大写
 */
+ (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02X", bytes[i]];
    }
    
    return [strM copy];
}

/*
 base64 解码
 */
+ (NSString*)base64Decode:(NSString*)str {
    // 1.先把base64编码后的字符串转成二进制数据
    NSData* data = [[NSData alloc] initWithBase64EncodedString:str options:0];
    // 2.把data转成字符串
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(NSString *)hexTobyte:(NSString *)str{
    
    
    unsigned char * tmp = SWLG_HexToByte(str.UTF8String, str.length);
    
    if (tmp == NULL) {
        
        return  nil;
    }
    
    return [NSString stringWithCString: tmp encoding:NSUTF8StringEncoding];
}





// 把十六进制字符串，转为字节码，每两个十六进制字符作为一个字节
unsigned char* SWLG_HexToByte(const char* szHex,int nLen)
{
    if(!szHex)
        return NULL;
    
    int iLen = nLen;
    
    if (nLen <= 0 || 0 != nLen%2)
        return NULL;
    
    //unsigned char* pbBuf = new unsigned char[iLen/2+1];  //  ˝æ›ª∫≥Â«¯
    unsigned char* pbBuf = (unsigned char*)malloc(iLen/2+1);
    
    memset(pbBuf,0,iLen/2+1);
    
    int tmp1, tmp2;
    for (int i = 0;i< iLen/2;i ++)
    {
        tmp1 = (int)szHex[i*2] - (((int)szHex[i*2] >= 'A')?'A'-10:'0');
        
        if(tmp1 >= 16)
            return NULL;
        
        tmp2 = (int)szHex[i*2+1] - (((int)szHex[i*2+1] >= 'A')?'A'-10:'0');
        
        if(tmp2 >= 16)
            return NULL;
        
        pbBuf[i] = (tmp1*16+tmp2);
    }
    
    return pbBuf;
}


/**
 生成十六进制AES 秘钥
 */
+  (NSString *)random128BitAESKey {
    unsigned char buf[kCCKeySizeAES128];
    arc4random_buf(buf, sizeof(buf));
    
    NSData *data = [NSData dataWithBytes:buf length:sizeof(buf)];
    
    return [self hexStringFromData:data];
}

/**
 data转换为十六进制的string
 */
+  (NSString *)hexStringFromData:(NSData *)myD {
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
+(NSDictionary *)dicFRomJson:(NSString *)json{
    
    return [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}
+ (NSString *)getNowTimeTimestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

+(NSString *)jsonFromDic:(NSDictionary *)dic{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (jsonData) {
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}
/**
 16进制字符串转data
 */
+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || str.length == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

/**
 先对加密后生成的byte数组加密，加密后转成16进制字符串
 */
+  (NSString *)md5ForBytesToLower32Bate:(NSString *)str {
    NSData *data = [self convertHexStrToData:str];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    

    NSData *hexData = [[NSData alloc] initWithBytes:result length:CC_MD5_DIGEST_LENGTH];

//    NSLog(@"计算MD5签名 sign ==== %@", [self hexStringFromData:hexData]);
    
    return [self hexStringFromData:hexData];
}

/*
 * 字符串转字典（NSString转Dictionary）
 *   parameter
 *     turnString : 需要转换的字符串
 */
+ (NSDictionary *)turnStringToDictionary:(NSString *)turnString
{
    turnString = [turnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; //收尾空格
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    
    
    NSData *turnData = [turnString dataUsingEncoding:NSUTF8StringEncoding];
    if (turnData != nil) {
        NSError *err;
        NSDictionary *turnDic = [NSJSONSerialization JSONObjectWithData:turnData options:NSJSONReadingMutableContainers error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;

        }
        return turnDic;
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"解析数据出错，请重试!");
        });
        return  nil;
    }
    
    
    
}


+ (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return @"";
}


+ (NSString *)hmcloud_generateCToken:(NSString * )pkgName
                          withUserId:(NSString *)userId
                          withUserToken:(NSString *)userToken
                     withAccessKey:(NSString *)accessKey
                          withAccessKeyId:(NSString *)accessKeyId
                       withChannelId:(NSString *)channelId{
    
    
    NSData *keyData = [self hexToBytes:accessKey];
    Byte *keyArr = (Byte*)[keyData bytes];

    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@", userId, userToken, pkgName, accessKeyId, channelId];
    NSData *strData = [str dataUsingEncoding:kCFStringEncodingUTF8];

    NSData *aesData = [self AES256EncryptWithKey:(void *)keyArr forData:strData ];//加密后的串
    return [self stringByHashingWithSHA1:aesData];
}


+ (NSData *) hexToBytes:(NSString *)val {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= val.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString * hexStr = [val substringWithRange:range];
        NSScanner * scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (NSData *) AES256EncryptWithKey:(const void *)key forData:(NSData *)data {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));

    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          key, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);

    return nil;
}

+ (NSString *) stringByHashingWithSHA1:(NSData *)data {
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (unsigned int)data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}
@end
