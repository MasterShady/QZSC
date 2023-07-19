//
//  MineModels.swift
//  QZSC
//
//  Created by 刘思源 on 2023/7/18.
//

import Foundation

class UserData: ObservableObject{
    @Published var cartCount = 15
    @Published var footPrintCount = 20
    @Published var likeCount = 6
    @Published var billCount = 8
    @Published var cartItems: [Product] = [
        
        Product(name: "产品名称", fee: 22, count: 1),
        Product(name: "产品名称2", fee: 22, count: 1),
        Product(name: "产品名称3", fee: 22, count: 1),
        Product(name: "产品名称4", fee: 22, count: 1),
        Product(name: "产品名称5", fee: 22, count: 1),
        Product(name: "产品名称6", fee: 22, count: 1),
        Product(name: "产品名称7", fee: 22, count: 1),
        Product(name: "产品名称8", fee: 22, count: 1),
        Product(name: "产品名称9", fee: 22, count: 1)
    ]
    
    var firstCount: Int{
        return cartItems.first!.count
    }
    
    var totalPrice: Double{
        cartItems.reduce(0) { partialResult, item in
            return partialResult + item.fee * item.count
        }
    }
}

struct Product: Identifiable, Equatable{
    let id = UUID()
    let name : String
    let fee : Double
    let type: [String] = ["typeA","typeB","typeC"]
    var selectedTypeIndex = 0
    var count = 1
    
    static func == (lhs: Self, rhs: Self) -> Bool{
        return lhs.name == rhs.name
    }
    
    var selectedType: String {
        type[selectedTypeIndex]
    }
    
    init(name: String, fee: Double, count: Int = 1) {
        self.name = name
        self.fee = fee
        self.count = count
    }
}
