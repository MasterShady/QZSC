//
//  QZSCFootprintViewModel.swift
//  QZSC
//
//  Created by LN C on 2023/7/21.
//

import Foundation


struct QZSCUserFootprintRequest: BaseRequest {
    let day_type: Int
    
    var routerURL: String {
        return "/qzsc/userFootprint"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        let params: [String: Any] = ["day_type": day_type]
        return params
    }
}

struct QZSCUserCollectRequest: BaseRequest {
    let uid: Int
    var routerURL: String {
        return "/qzsc/userCollect"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        let params: [String: Any] = ["uid": uid]
        return params
    }
}


class QZSCFootprintViewModel: NSObject {
    
    // 获取足迹列表
    class func loadUserFootprint(day_type: Int,complete: @escaping([QZSCProductListModel]) -> Void) {
        let request = QZSCUserFootprintRequest(day_type: day_type)
        QZSCNetwork.request(request).responseDecodable { (response: QZSCAFDataResponse<[QZSCProductListModel]>) in
            switch response.result {
            case .success(let list):
                complete(list)
            case .failure(let error):
                UMToast.show(error.localizedDescription)
                complete([])
            }
        }
    }
    
    // 获取收藏列表
    class func loadUserCollect(complete: @escaping([QZSCProductListModel]) -> Void) {
        let request = QZSCUserCollectRequest(uid: QZSCLoginManager.shared.userInfo!.uid)
        QZSCNetwork.request(request).responseDecodable { (response: QZSCAFDataResponse<[QZSCProductListModel]>) in
            switch response.result {
            case .success(let list):
                complete(list)
            case .failure(let error):
                UMToast.show(error.localizedDescription)
                complete([])
            }
        }
    }
}
