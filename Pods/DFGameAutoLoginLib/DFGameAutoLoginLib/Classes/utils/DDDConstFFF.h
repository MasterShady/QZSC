//
//  DDDexternFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//public enum LGECode:Int  {
//
//    case LGECode_Success = 0
//
//    case LGECode_Request_Net = 10001 //网络出错
//
//    case LGECode_Json_error = 10002 //json 解析出错
//
//    case LGECode_Request_CodeError = 10003 //接口返回错误状态码
//
//    case LGECode_Request_DataNull = 10004 //接口返回数据为空
//
//    case LGECode_Param_Error = 20001 //缺少关键参数信息
//
//    case LGECode_Type_Error = 30001 //数据类型错误
//
//    case LGECode_Crypt_Error = 40001 //加解密出错
//
//    case LGECode_OpenApp_Error = 50001 //打开app出错
//
//    case LGECode_FaceVerify_Error = 600001 //人脸错误
//
//    case LGECode_84_Error = 700001 //人脸错误
//
//    case LGECode_protocol_Error = 800001 //人脸错误
//
//    case LGECode_Fail_Error = 900001 //无更多上好方式
//
//    case LGECode_HMCloud_Error = 1000001 //人脸错误
//
//    case LGECode_TxRequest_Error = 1100001 //微信ipad协议上号错误
//
//    case LGECode_SMCheck_Error = 1200001 //数美检测超时
//
//    case LGECode_SMCheck_Fail = 1200002 //数美检测未通过
//}
typedef enum : NSUInteger {
    LGECode_Success = 0,
    LGECode_Request_Net = 10001,
    LGECode_Json_error = 10002,
    LGECode_Request_CodeError = 10003,
    LGECode_Request_DataNull = 10004,
    LGECode_Param_Error = 20001,
    LGECode_Type_Error = 30001 ,
    LGECode_Crypt_Error = 40001 ,
    LGECode_OpenApp_Error  = 50001,
    LGECode_FaceVerify_Error = 600001,
    LGECode_84_Error = 700001,
    LGECode_protocol_Error = 800001,
    LGECode_Fail_Error = 900001,
    LGECode_HMCloud_Error = 1000001,
    LGECode_TxRequest_Error = 1100001,
    LGECode_SMCheck_Error = 1200001,
    LGECode_SMCheck_Fail = 1200002
} DDDErrorCode;


extern NSString * DDDNETErrorDescription;

extern NSString *  rsa_key ;

extern NSString * game_auth_key;

extern NSString * login_rc4_key;

extern NSString * xdid_rc4_key ;

extern NSString * SW_HMCLoudChannelId ;





///iOS开始游戏，限制唯一设备检测 ---上号器未调用
extern NSString * SW_API_LoginOaidCheck ;

///QQ快速上号订单投诉人脸检测 ---没有使用
//extern NSString * SW_API_FACEVERIFYCHKHAORENT = "FaceVerify/chkHaoRent"


///微信快速上号加入微信上号获取token队列-----
extern NSString * SW_API_WX_QUICK_TOKEN_QUEUE ;

///轮询微信快速上号code-----
//extern NSString * SW_API_CHEK_WX_LOGIN_CODE = "appv3/quick/getWxToken"
extern NSString * SW_API_CHEK_WX_LOGIN_CODE ;
///加入微信快速上号修复队列-----
extern NSString * SW_API_WX_QUICK_RESER_QUEUE ;

///获取微信快速上号修复后的token-----
extern NSString * SW_API_WX_RESET_CODE ;

///开始游戏获取游戏信息-----
extern NSString * SW_API_QQ_GetOrderInfo ;

///QQ快速上号人脸检测结果上报-----
//extern NSString * SW_API_QQ_FACEVERIFYREPORT = "appv3/faceVerify/report"
extern NSString * SW_API_QQ_FACEVERIFYREPORT ;

///  获取token上报token-----
//extern NSString * SW_API_SETTOKENSOFT = "appv3/quick/setTokenRent"
extern NSString * SW_API_SETTOKENSOFT ;

/// 获取token上报错误-----
extern NSString * SW_API_SETTOKENERROR ;


///  获取正确密码----
//extern NSString * SW_API_QUICK_ENCRYPT = "appv3/quick/getQuickEncrypt"
extern NSString * SW_API_QUICK_ENCRYPT ;
///上报快速上号信息 -- 上号器未调用

extern NSString * SW_API_QULICKLOGIN_INFO ;


//获取服务端上号token
extern NSString * SW_API_GETSERVERORDER_TOKEN ;



//海马云上号成功进行上报
extern NSString * SW_API_HMCloud_ReportOrder ;
//到时不下线-订单结束
extern NSString * SW_API_HMCloud_OffLine ;
//中间件上报
extern NSString * SW_API_HMCloud_middlewareLogin ;

//微信上号结果上报
extern NSString * SW_API_WxReport ;


//中台请求上号;
extern NSString * SW_ZHT_API_LoginRequest ;

//中台查询上号结果
extern NSString * SW_ZHT_API_QueryLoginResult ;

//中台 上号-请求tx数据包
extern NSString * SW_ZHT_API_QueryTxDataPackage  ;


//中台 上号-请求解析tx返回结果
extern NSString * SW_ZHT_API_getResult ;


//中台 上号-查询游戏授权码
extern NSString * SW_ZHT_API_getAuthCode ;

//数美验证接口
extern NSString * SW_API_SMVerify ;




NS_ASSUME_NONNULL_END
