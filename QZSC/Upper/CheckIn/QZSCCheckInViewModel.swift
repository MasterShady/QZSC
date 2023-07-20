//
//  QZSCCheckInViewModel.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/20.
//

import Foundation

struct QZSCCheckInUploadRequest: BaseRequest {
    let desc: String
    let contack_num: String
    let good_type: String
    let goods_img_list: [String]
    let business_license: String
    
    var routerURL: String {
        return "qzsc/merchantSettle"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        var params: [String: Any] = ["desc": desc,
                                     "contack_num": contack_num,
                                     "good_type": good_type]
        if !goods_img_list.isEmpty {
            params["goods_img_list"] = goods_img_list
        }
        if !business_license.isEmpty {
            params["business_license"] = business_license
        }
        return params
    }
}

class QZSCCheckInViewModel {
    
    static func uploadBusinessCheckInDetails(desc: String, contack_num: String, good_type: String, goods_imgs: [String], license_img: String, complete: @escaping(Bool) -> Void) {
        let request = QZSCCheckInUploadRequest(desc: desc,
                                               contack_num: contack_num,
                                               good_type: good_type,
                                               goods_img_list: goods_imgs,
                                               business_license: license_img)
        QZSCNetwork.request(request).responseServiceObject { obj in
            if obj.state == .Response_Succ {
                complete(true)
            } else {
                UMToast.show(obj.msg)
            }
        }
    }
    
}
