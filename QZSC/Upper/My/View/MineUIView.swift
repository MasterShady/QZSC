//
//  MineUIView.swift
//  QZSC
//
//  Created by 刘思源 on 2023/7/14.
//

import SwiftUI

class UserData: ObservableObject{
    @Published var cartCount = 15
    @Published var footPrintCount = 20
    @Published var likeCount = 6
    @Published var billCount = 8
    @Published var cartItems: [Product] = [
        Product(name: "产品名称", fee: 10, count: 3),
        Product(name: "产品名称2", fee: 22, count: 5),
        Product(name: "产品名称3", fee: 22, count: 5),
        Product(name: "产品名称4", fee: 22, count: 5),
        Product(name: "产品名称5", fee: 22, count: 5),
        Product(name: "产品名称6", fee: 22, count: 5),
        Product(name: "产品名称7", fee: 22, count: 5),
        Product(name: "产品名称8", fee: 22, count: 5),
        Product(name: "产品名称9", fee: 22, count: 5)
    ]
    
    var totalPrice: Double{
        cartItems.reduce(0) { partialResult, item in
            return partialResult + item.fee * item.count
        }
    }
}

class Product: ObservableObject, Equatable{
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name : String
    let fee : Double
    let type: [String] = ["typeA","typeB","typeC"]
    @Published var selectedTypeIndex = 0
    
    var selectedType: String {
        type[selectedTypeIndex]
    }
    
    @Published var count = 1
    
    init(name: String, fee: Double, count: Int = 1) {
        self.name = name
        self.fee = fee
        self.count = count
    }
}

struct MineUIView: View {
    @ObservedObject var userData: UserData
    @State var didLoad = false
    
    /**
    swiftUi中的数据绑定, 这里是我粗浅的理解, 不一定对.
     @state 用于基本数据类型和结构体
     @StateObject 和 @ObservedObject 用于对象
    其中 @StateObject 表明了 视图 "持有" 了对象. 即该对象完全服务于当前的视图. 对象和视图的声明周期一致, 对象可以在视图中进行创建
     @ObservedObject 表明了 视图 "弱引用"了对象, 无法在视图内部创建对象. 只能在初始化时从外部传入
     @EnvironmentObject 就是 @ObservedObject 的简易版本, 在创建视图时不用传了.  可以直接用environmentObject(userData) 这种方式来传.
     
     在该视图中, 我们需要访问用户的数据UserData, 显然是一个全局的对象, 所以应该使用 @ObservedObject 来传入.
     同时 MineHeaderView 需要访问 UserData, 我们通过environmentObject 来注入. MineHeaderView中用 @EnvironmentObject 来声明
     */
    
    
    var body: some View {
        NavigationView {
            VStack {
                Image("mine_top_bg").resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .overlay(alignment:.topTrailing) {
                Button(action: {
                    
                }, label: {
                    Image("mine_settings")
                }).padding(EdgeInsets(top: kStatusBarHeight + 20, leading: 0, bottom: 0, trailing: 24))
            }
            .overlay(alignment: .topLeading){
                VStack(spacing: 12){
                    MineHeaderView()
                    MineOrderView()
                    MineFunctionView()
                    
                }.padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                
            }.ignoresSafeArea().background(Color(hex: 0xF6F8FA)).environmentObject(userData)
                .onAppear(perform: appearLoad)
        }
    }
    
    func appearLoad(){
        if (!didLoad){
            didLoad = true
            print("~~ first appear 处理初始化相关信息 ~~")
        }
        print("~~ appear ~~")
    }
}

struct MineUIView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        MineUIView(userData: userData)
    }
}

struct MineHeaderView: View {
    @EnvironmentObject var userData: UserData
    
    func items(at idx:Int) -> (String,Int, ReferenceWritableKeyPath<UserData, Int>){
        let list = [("购物车", userData.cartCount, \UserData.cartCount),
                    ("足迹",userData.footPrintCount, \UserData.footPrintCount),
                    ("收藏",userData.likeCount, \UserData.likeCount),
                    ("账单",userData.billCount, \UserData.billCount)]
        return list[idx]
    }
    
    var body: some View {
        VStack(alignment: .leading,spacing: 12) {
            HStack {
                Image("profile-image")
                
                    .resizable()
                    .frame(width: 68, height: 68)
                    .background(Color.blue)
                    .clipShape(Circle()) // 将图片裁剪为圆形
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2) // 添加边框
                    )
                
                VStack {
                    Text("像林京味的芹菜").font(.system(size: 18,weight: .semibold))
                    Text("这是一句辅助文案信息").font(.system(size: 12)).foregroundColor(.init(hex: 0x7090A0))
                }
            }.padding(.init(top: kStatusBarHeight + 44, leading: 0, bottom: 0, trailing: 0))
            
            HStack {
                ForEach(0..<4) { idx in
                    let item = items(at: idx)
                    Button {
                        userData[keyPath: item.2] += 1
                    } label: {
                        VStack(spacing: 2) {
                            Text(String(item.1)).font(.system(size: 24, weight: .bold))
                            Text(item.0).font(.system(size: 12)).foregroundColor(.init(hex: 0x999999))
                            
                        }.frame(maxWidth: .infinity)
                    }

                    
                }
            }
        }
    }
}


struct MineOrderView: View {
    
    let items = [
        ("待付款","mine_to_pay"),
        ("租赁中","mine_under_lease"),
        ("退款/售后","mine_after_sales"),
    ]
    var body: some View {
        VStack{
            HStack {
                Text("我的订单").font(.system(size: 16,weight: .bold))
                Spacer()
                Button {
                } label: {
                    HStack (spacing:0){
                        Text("全部").foregroundColor(.init(hex: 0x08C9CA)).font(.system(size: 12))
                        Image("mine_arrow")
                    }
                }
            }
            HStack{
                ForEach(items, id: \.0) { item in
                    Button {
                        
                    } label: {
                        VStack {
                            Image(item.1)
                            Text(item.0).foregroundColor(.init(hex: 333333)).font(.system(size: 12))
                        }.frame(maxWidth: .infinity)
                    }

                }
            }
        }.padding(.init(top: 10, leading: 16, bottom: 10, trailing: 16)).background(.white).cornerRadius(8)
    }
}


struct MineFunctionView: View{
    @EnvironmentObject var userData: UserData
    let items = [
        ("购物车","mine_cart"),
        ("我的客服", "mine_service"),
        ("意见反馈","mine_feedback"),
        ("我的账单", "mine_bills"),
        ("关于我们", "mine_about_us"),
        ("商家入驻", "mine_join_us")
    ]

    var body: some View {
        VStack(alignment: .leading){
            Text("我的订单").font(.system(size: 16,weight: .bold))
            GeometryReader{ geometry in
                WrappedHStack(geometry: geometry) {
                    ForEach(items, id: \.0) { item in
                        NavigationLink(destination:MyCartView().environmentObject(userData)) {
                            VStack {
                                Image(item.1)
                                Text(item.0).font(.system(size: 12)).foregroundColor(.init(hex: 0x000000))
                            }.frame(width:60)
                        }
                    }
                }
            }
            
                
        }.padding(.init(top: 10, leading: 16, bottom: 10, trailing: 16)).background(.white).cornerRadius(8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MineFunctionView()
    }
}
