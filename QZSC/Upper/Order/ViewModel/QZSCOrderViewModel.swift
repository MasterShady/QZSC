//
//  QZSCOrderViewModel.swift
//  QZSC
//
//  Created by LN C on 2023/7/21.
//

import Foundation
struct QZSCOrderListRequest: BaseRequest {
    let status: Int
    var routerURL: String {
        return "/qzsc/orderList"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        let params: [String: Any] = ["status": status]
        return params
    }
}


struct QZSCOrderCancelRequest: BaseRequest {
    let order_id: Int
    var routerURL: String {
        return "/qzsc/orderCancel"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
    var optionalParameter: [String : Any]? {
        let params: [String: Any] = ["order_id": order_id]
        return params
    }
}


class QZSCOrderViewModel: NSObject {
    
    // 获取订单列表 status -1 全部 0=待支付 1=进行中 2=已完成  3/4预留 5=已关闭（支付过期等）
    class func loadOrderList(status: Int,complete: @escaping([OrderListModel]) -> Void) {
        let request = QZSCOrderListRequest(status: status)
        QZSCNetwork.request(request).responseDecodable { (response: QZSCAFDataResponse<[OrderListModel]>) in
            switch response.result {
            case .success(let list):
                complete(list)
            case .failure(let error):
                UMToast.show(error.localizedDescription)
                complete([])
            }
        }
    }
    
    // 删除地址
    class func loadOrderCancel(order_id: Int, complete: @escaping(Bool) -> Void) {
        
        let request = QZSCOrderCancelRequest(order_id: order_id)
        QZSCNetwork.request(request).responseServiceObject { obj in
            if obj.state == .Response_Succ {
                complete(true)
            } else {
                UMToast.show(obj.msg)
            }
        }
    }
    
    
}
