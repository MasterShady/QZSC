//
//  AddressViewModel.swift
//  QZSC
//
//  Created by LN C on 2023/7/20.
//

import Foundation

struct QZSCAddressListRequest: BaseRequest {
    
    var routerURL: String {
        return "/qzsc/addressList"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        var params: [String: Any] = [
                                     "page": 1,
                                     "pageSize": 20]
        return params
    }
}

struct QZSCAddAddressRequest: BaseRequest {
    let uname: String
    let phone: String
    let address_area: String
    let address_detail: String
    let is_default: Int
    
    var routerURL: String {
        return "/qzsc/addAddress"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        let params: [String: Any] = [
                                     "uname": uname,
                                     "phone": phone,
                                     "address_area": address_area,
                                     "address_detail": address_detail,
                                     "is_default": is_default,
        ]
        return params
    }
}

struct QZSCUpdateAddressRequest: BaseRequest {
    let uname: String
    let phone: String
    let address_area: String
    let address_detail: String
    let is_default: Int
    let address_id: Int
    
    var routerURL: String {
        return "/qzsc/updateAddress"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        let params: [String: Any] = [
                                     "uname": uname,
                                     "phone": phone,
                                     "address_area": address_area,
                                     "address_detail": address_detail,
                                     "is_default": is_default,
                                     "address_id": address_id,]
        return params
    }
}

struct QZSCDelAddressRequest: BaseRequest {
    let address_id: Int
    
    var routerURL: String {
        return "/qzsc/delAddress"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        let params: [String: Any] = ["address_id": address_id]
        return params
    }
}

class QZSCAddressViewModel: NSObject {
    
    // 获取地址列表
    class func loadAddressList(complete: @escaping([AddressListModel]) -> Void) {
        let request = QZSCAddressListRequest()
        QZSCNetwork.request(request).responseDecodable { (response: QZSCAFDataResponse<[AddressListModel]>) in
            switch response.result {
            case .success(let list):
                complete(list)
            case .failure(let error):
                UMToast.show(error.localizedDescription)
                complete([])
            }
        }
    }
    
    // 新增地址
    class func loadAddAddress( uname: String, phone: String, address_area: String, address_detail: String, is_default: Int , complete: @escaping(Bool) -> Void) {
        
        let request = QZSCAddAddressRequest(uname: uname, phone: phone, address_area: address_area, address_detail: address_detail, is_default: is_default)
        QZSCNetwork.request(request).responseServiceObject { obj in
            if obj.state == .Response_Succ {
                complete(true)
            } else {
                UMToast.show(obj.msg)
            }
        }
    }
    
    // 更新地址
    class func loadUpdateAddress( uname: String, phone: String, address_area: String, address_detail: String, is_default: Int , address_id: Int , complete: @escaping(Bool) -> Void) {
        
        let request = QZSCUpdateAddressRequest(uname: uname, phone: phone, address_area: address_area, address_detail: address_detail, is_default: is_default, address_id: address_id)
        QZSCNetwork.request(request).responseServiceObject { obj in
            if obj.state == .Response_Succ {
                complete(true)
            } else {
                UMToast.show(obj.msg)
            }
        }
    }
    
    // 删除地址
    class func loadDelAddress(address_id: Int, complete: @escaping(Bool) -> Void) {
        
        let request = QZSCDelAddressRequest(address_id: address_id)
        QZSCNetwork.request(request).responseServiceObject { obj in
            if obj.state == .Response_Succ {
                complete(true)
            } else {
                UMToast.show(obj.msg)
            }
        }
    }    
    
}
