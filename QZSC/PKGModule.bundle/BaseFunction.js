
 
function kk_openQRCode(callback){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','openQRCode', {}, function(res){
            callback(res["result"])
        })
    }else {
        
    }
}


function kk_openURLInWebView(url,evaluateJsCode = null){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','openURLInWebView', {"url": url, "evaluateJsCode": evaluateJsCode}, function(res){
            
        })
    }else {
        
    }
}

function kk_sendMsgToMainWebView(data){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','sendMsgToMainWebView', {"data": data}, function(res){
            
        })
    }else {
        
    }
}

function kk_goBack(close=false){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','goBack', {"close": close}, function(res){
           
        })
    }else {
        
    }
}




function kk_AutoLoadGame(s, wxServerLoadingMsgs,orderRefreshCallback){
    if (window.KKJSBridge != null){
        s["wxServerLoadingMsgs"] = wxServerLoadingMsgs
        window.KKJSBridge.call('ToGameModule','AutoLoadGame', s, function(res){
            orderRefreshCallback()
        })
    }else {
        
    }
}


//1:网易 2:腾讯
function kk_faceVerify(channel,rname,verify_id,purpose,txInfo,amount=0,callback){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('FaceVerifyModule','faceVerify', {"channel":channel,"rname":rname,"verify_id":verify_id,"purpose":purpose,"txInfo":txInfo},callback)
    }else {

    }
}




function kk_share(title,content,url,image,showPoster,posterCallback){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','share', {"title":title,"content":content,"url":url,"image":image, "showPoster":showPoster},function(res){
            posterCallback()
        })
    }else {
        
    }
}


function kk_shareImage(image){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','shareImage',{"image":image},function(){})
    }else {
        
    }
}

function kk_saveImage(image,callback = null){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','saveImage',{"image":image},function(res){
            if (callback != null) {
                callback(res["result"])
            }
        })
    }else {
        
    }
}



function kk_thirdLogin(type,callback){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('ToGameModule','thirdLogin',{"type":type},callback)
    }else {
        
    }
}


function kk_openURLInBrowser(url){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','openURLInBrowser',{"url":url},function(res){})
    }else {
        
    }
}

function kk_popSheet(title,message,items,cancelTitle="取消",callback){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','popSheet', {
            "title":title,
            "message":message,
            "items":items,
            "cancelTitle": cancelTitle
        }, callback)
    }else {
        
    }
}

function kk_popAlert(title,message,items,cancelTitle="取消",callback){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','popAlert', {
            "title":title,
            "message":message,
            "items":items,
            "cancelTitle": cancelTitle
        }, callback)
    }else {
        
    }
}

function kk_pickPhoto(callback){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','pickPhoto', {}, callback)
    }else {

    }
}

function kk_takePhoto(callback){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','takePhoto', {}, callback)
    }else {

    }
}


function kk_userLogin(data){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','userLogin',data, null)
    }else {
        
    }
}

function kk_userLogout(){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','userLogout', {}, null)
    }else {
        
    }
}


function kk_promptForAppRating(){
    if (window.KKJSBridge != null){
        window.KKJSBridge.call('BaseFunction','promptForAppRating', {}, null)
    }else {
        
    }
}

//function kk_isJailBreak(callback){
//    if (window.KKJSBridge != null){
//        window.KKJSBridge.call('BaseFunction','isJailBreak', {}, callback)
//    }else {
//
//    }
//}
