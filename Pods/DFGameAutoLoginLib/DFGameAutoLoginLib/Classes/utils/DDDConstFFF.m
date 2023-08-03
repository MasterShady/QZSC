//
//  DDDConstFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDConstFFF.h"


const NSString * DDDNETErrorDescription = @"网络不稳定，请稍后重试";

const NSString *  rsa_key = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsHWwJ8nBCsSkq0jJVuVQQArzSaW8oOhH0nqZTa+FGN7fVLTl1vlSja+6MjlvoZeelubQExAaImD7pc/QxcrTh01uZuEmfikFe/pKDjcUnEtIBPMiPl49BXWtq4ZnEjgMIQv9Sirb6/Tnf8Cyc8+BTwstu+MV7AJbmFtbv9AvcjwIDAQAB";



const NSString * game_auth_key = @"F21B543B29D7C5E9B2CCC59C5FF5974F";

const NSString * login_rc4_key = @"dbe320f44b2c1a0a";

const NSString * xdid_rc4_key = @"F21B543B29D7FWEGB2CAA59C5FF5974F";

const NSString * SW_HMCLoudChannelId = @"zhw";




///iOS开始游戏，限制唯一设备检测 ---上号器未调用
const NSString * SW_API_LoginOaidCheck = @"Quick/appLoginOaidCheck";

///QQ快速上号订单投诉人脸检测 ---没有使用
//const NSString * SW_API_FACEVERIFYCHKHAORENT = "FaceVerify/chkHaoRent"


///微信快速上号加入微信上号获取token队列-----
const NSString * SW_API_WX_QUICK_TOKEN_QUEUE = @"Quick/setWxQueue";

///轮询微信快速上号code-----
//const NSString * SW_API_CHEK_WX_LOGIN_CODE = "appv3/quick/getWxToken"
const NSString * SW_API_CHEK_WX_LOGIN_CODE = @"Quick/getWxToken";
///加入微信快速上号修复队列-----
const NSString * SW_API_WX_QUICK_RESER_QUEUE = @"Quick/setWxResetQueue";

///获取微信快速上号修复后的token-----
const NSString * SW_API_WX_RESET_CODE = @"Quick/getWxResetToken";

///开始游戏获取游戏信息-----
const NSString * SW_API_QQ_GetOrderInfo = @"Quick/getTokenByUncode";

///QQ快速上号人脸检测结果上报-----
//const NSString * SW_API_QQ_FACEVERIFYREPORT = "appv3/faceVerify/report"
const NSString * SW_API_QQ_FACEVERIFYREPORT = @"FaceVerify/report";

///  获取token上报token-----
//const NSString * SW_API_SETTOKENSOFT = "appv3/quick/setTokenRent"
const NSString * SW_API_SETTOKENSOFT = @"Quick/setTokenRent";

/// 获取token上报错误-----
const NSString * SW_API_SETTOKENERROR = @"Quick/addReportErr";


///  获取正确密码----
//const NSString * SW_API_QUICK_ENCRYPT = "appv3/quick/getQuickEncrypt"
const NSString * SW_API_QUICK_ENCRYPT = @"Quick/getQuickEncrypt";
///上报快速上号信息 -- 上号器未调用

const NSString * SW_API_QULICKLOGIN_INFO = @"IndexV2/entry";


//获取服务端上号token
const NSString * SW_API_GETSERVERORDER_TOKEN = @"quick/getServerOrderToken";



//海马云上号成功进行上报
const NSString * SW_API_HMCloud_ReportOrder = @"quick/cloudReportOrder";
//到时不下线-订单结束
const NSString * SW_API_HMCloud_OffLine = @"quick/cloudOffline";
//中间件上报
const NSString * SW_API_HMCloud_middlewareLogin = @"quick/middlewareLogin";

//微信上号结果上报
const NSString * SW_API_WxReport = @"quick/reportWxOrderLog";


//中台请求上号;
const NSString * SW_ZHT_API_LoginRequest = @"api/quick/login/request";

//中台查询上号结果
const NSString * SW_ZHT_API_QueryLoginResult = @"api/quick/login/getResult";

//中台 上号-请求tx数据包
const NSString * SW_ZHT_API_QueryTxDataPackage = @"api/quick/login/getTxDataPackage";


//中台 上号-请求解析tx返回结果
const NSString * SW_ZHT_API_getResult = @"api/quick/login/analysisResult";


//中台 上号-查询游戏授权码
const NSString * SW_ZHT_API_getAuthCode = @"api/quick/login/getAuthCode";

//数美验证接口
const NSString * SW_API_SMVerify = @"Quick/smVerify";


