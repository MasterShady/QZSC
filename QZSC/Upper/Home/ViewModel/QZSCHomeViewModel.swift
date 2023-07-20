//
//  QZSCHomeViewModel.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/20.
//

import Foundation

struct QZSCProductListRequest: BaseRequest {
    let category_id: Int
    let keyWord: String
    
    var routerURL: String {
        return "qzsc/goodsList"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        var params: [String: Any] = ["category_id": category_id,
                                     "page": 1,
                                     "pageSize": 20]
        if !keyWord.isEmpty {
            params["keyWork"] = keyWord
        }
        return params
    }
}

struct QZSCProductDetailsRequest: BaseRequest {
    let productId: Int
    
    var routerURL: String {
        return "qzsc/goodsDetail"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        let params: [String: Any] = ["goods_id": productId]
        return params
    }
}

struct QZSCProductCollectRequest: BaseRequest {
    let productId: Int
    let status: Int
    
    var routerURL: String {
        return "qzsc/setCollect"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        let params: [String: Any] = ["goods_id": productId, "status": status]
        return params
    }
}

class QZSCHomeViewModel: NSObject {
    
    // 获取商品列表
    class func loadHomeProductList(category_id: Int = 0,
                                   keyWord: String = "",
                                   complete: @escaping([QZSCProductListModel]) -> Void) {
        let request = QZSCProductListRequest(category_id: category_id, keyWord: keyWord)
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
    
    // 获取商品详情
    class func loadHomeProductDetails(productId: Int,
                                      complete: @escaping(QZSCProductDetailsInfoModel?) -> Void) {
        let request = QZSCProductDetailsRequest(productId: productId)
        QZSCNetwork.request(request).responseDecodable { (response: QZSCAFDataResponse<QZSCProductDetailsModel>) in
            switch response.result {
            case .success(let result):
                complete(result.goods_info)
            case .failure(let error):
                UMToast.show(error.localizedDescription)
                complete(nil)
            }
        }
    }
    
    // 收藏/取消收藏商品
    class func collectProduct(productId: Int, isCollect: Bool, complete: @escaping(Bool) -> Void) {
        let status = (isCollect ? 1 : 0)
        let request = QZSCProductCollectRequest(productId: productId, status: status)
        QZSCNetwork.request(request).responseServiceObject { obj in
            if obj.state == .Response_Succ {
                complete(true)
            } else {
                UMToast.show(obj.msg)
            }
        }
    }
}
