//
//  TMD.swift
//  QZSC
//
//  Created by 刘思源 on 2023/7/18.
//

import SwiftUI

class UserData1: ObservableObject {
    @Published var count = 0
}

struct ContentView: View {
    @StateObject private var model = Model() // 父视图中的模型对象
    
    var body: some View {
        VStack {
            Text("Items: \(model.totalCount)")
            
            
            ChildView(model: model) // 将模型对象传递给子视图
        }
    }
}

struct ChildView: View {
    @ObservedObject var model: Model // 子视图接收的模型对象
    
    var body: some View {
        VStack {
            ForEach(model.items.indices, id: \.self) { index in
                VStack {
                    Text(model.items[index].name)
                    Text("Count: \(model.items[index].count)")
                    
                    Button("Increment") {
                        model.items[index].count += 1 // 在子视图中修改模型对象的 count 字段
                        //model.objectWillChange.send()
                    }
                }
            }
        }
    }
}

class Model: ObservableObject {
    @Published var items = [
        Item(name: "Item 1", count: 0),
        Item(name: "Item 2", count: 0),
        Item(name: "Item 3", count: 0)
    ]
    var totalCount : Int{
        return items.reduce(0) { partialResult, item in
            return partialResult + item.count
        }
    }
}

class Item: ObservableObject, Identifiable {
    let id = UUID()
    let name: String
    @Published var count: Int
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
}


struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData1())
    }
}
