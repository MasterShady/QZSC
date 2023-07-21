//
//  MineUIView.swift
//  QZSC
//
//  Created by lsy on 2023/7/14.
//

import SwiftUI
import Combine


struct UserInfoRequest: BaseRequest {
    var routerURL: String {
        return "/qzsc/userInfo"
    }
    
    var method: QZSCAFHTTPMethod {
        return .post
    }
    
}



struct MineUIView: View {
    @ObservedObject var userManager : QZSCLoginManager
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

//    init(userData: QZSCUserInfo?, didLoad: Bool = false) {
//        _userData = ObservedObject(wrappedValue: userData ?? QZSCUserInfo())
//        //StateObject(wrappedValue: userData ?? QZSCUserInfo())
//        self.didLoad = didLoad
//    }

    var body: some View {
        NavigationView {
            VStack {
                Image("mine_top_bg").resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .overlay(alignment:.topTrailing) {
                Button(action: {
                    
                    let SettingVC = QZSCSettingViewController()
                    QZSCControllerTool.currentNavVC()?.pushViewController(SettingVC, animated: true)

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

            }.ignoresSafeArea().background(Color(hex: 0xF6F8FA)).environmentObject(userManager)
                .onAppear(perform: appearLoad).showTabBar().navigationBarHidden(true)
        }
    }

    func appearLoad(){
        if (!didLoad){
            didLoad = true
        }
        
        if !userManager.isLogin{
            return
        }
        
        QZSCNetwork.request(UserInfoRequest()).responseDecodable { (response: QZSCAFDataResponse<QZSCUserInfo>) in
            switch response.result {
            case .success(let userInfo):
                userManager.userInfo = userInfo
            case .failure(let error):
                UMToast.show(error.localizedDescription)
            }
        }
    }
}



struct MineHeaderView: View {
    @EnvironmentObject var userManager: QZSCLoginManager
    @State var billAlertShow = false

    func items(at idx:Int) -> (String,Int){
        let list = [
            ("足迹",userManager.userInfo?.foot_num ?? 0),
            ("收藏",userManager.userInfo?.collect_num ?? 0),
            ("账单",userManager.userInfo?.bill_num ?? 0)
        ]
        return list[idx]
    }

    var body: some View {
        VStack(alignment: .leading,spacing: 12) {
            HStack {
                Image("appicon_small")

                    .resizable()
                    .frame(width: 68, height: 68)
                    .background(Color.blue)
                    .clipShape(Circle()) // 将图片裁剪为圆形
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2) // 添加边框
                    )
                Text(userManager.isLogin ? userManager.userInfo!.nickname : "请登录").font(.system(size: 18,weight: .semibold))
            }.onTapGesture {
                if !userManager.isLogin{
                    let LoginVC = QZSCLoginController()
                    QZSCControllerTool.currentNavVC()?.pushViewController(LoginVC, animated: true)
                }
            }.padding(.init(top: kStatusBarHeight + 44, leading: 0, bottom: 0, trailing: 0))

            HStack {
                ForEach(0..<3) { idx in
                    let item = items(at: idx)
                    Button {
                        if(idx == 0){
                            if !userManager.isLogin{
                                QZSCControllerTool.currentNavVC()?.pushViewController(QZSCLoginController(), animated: true)
                                return
                            }
                            let footprintVC = QZSCfootprintViewController()
                            QZSCControllerTool.currentNavVC()?.pushViewController(footprintVC, animated: true)
                        }else if(idx == 1){
                            if !userManager.isLogin{
                                QZSCControllerTool.currentNavVC()?.pushViewController(QZSCLoginController(), animated: true)
                                return
                            }
                            let CollectVC = QZSCCollectViewController()
                            QZSCControllerTool.currentNavVC()?.pushViewController(CollectVC, animated: true)
                        }else if (idx == 2){
                            UIAlertView(title: "您没有账单", message: "", delegate: "", cancelButtonTitle: "确定").show()
                        }
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
                    if let tabbarVC = QZSCControllerTool.currentVC() as? UITabBarController{
                        tabbarVC.selectedIndex = 1
                    }
                    
                } label: {
                    HStack (spacing:0){
                        Text("全部").foregroundColor(.init(hex: 0x08C9CA)).font(.system(size: 12))
                        Image("mine_arrow")
                    }
                }
            }
            HStack{
                ForEach(0..<3) { index in
                    let item = items[index]
                    Button {
                        if index == 0{
                            if !QZSCLoginManager.shared.isLogin{
                                QZSCControllerTool.currentNavVC()?.pushViewController(QZSCLoginController(), animated: true)
                                return
                            }
                            let vc = QZSCOrderAllViewController()
                            vc.navTitle = "待付款"
                            QZSCControllerTool.currentNavVC()?.pushViewController(vc, animated: true)
                        }else if index == 1{
                            if !QZSCLoginManager.shared.isLogin{
                                QZSCControllerTool.currentNavVC()?.pushViewController(QZSCLoginController(), animated: true)
                                return
                            }
                            let vc = QZSCOrderAllViewController()
                            vc.navTitle = "租赁中"
                            QZSCControllerTool.currentNavVC()?.pushViewController(vc, animated: true)
                        }else{
                            if !QZSCLoginManager.shared.isLogin{
                                QZSCControllerTool.currentNavVC()?.pushViewController(QZSCLoginController(), animated: true)
                                return
                            }
                            let vc = QZSCOrderAllViewController()
                            vc.navTitle = "退款/售后"
                            QZSCControllerTool.currentNavVC()?.pushViewController(vc, animated: true)
                        }
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
    //@EnvironmentObject var userData: UserData
    
    
    
    let items: [(String,String, Any)] = [
        //("购物车","mine_cart", MyCartView().erasedToAnyView()),
        //写法1, 用ControllerWrapper去包装一下,通过swiftUI的NavigationLink去跳转.
        ("我的客服", "mine_service",  {
            QZSCControllerTool.currentNavVC()?.pushViewController(QZSCKfController(), animated: true)
        } as ()->()),
        ("意见反馈","mine_feedback", FeedBackView().erasedToAnyView()),
        //写法2, 用block包一下.点击执行block完成跳转.
        ("我的地址", "mine_bills", {
            if !QZSCLoginManager.shared.isLogin{
                QZSCControllerTool.currentNavVC()?.pushViewController(QZSCLoginController(), animated: true)
                return
            }
            QZSCControllerTool.currentNavVC()?.pushViewController(MineAddressListViewController(), animated: true)
        } as ()->()),
        ("关于我们", "mine_about_us", AboutUsView().erasedToAnyView()),
        ("商家入驻", "mine_join_us", {
            QZSCControllerTool.currentNavVC()?.pushViewController(QZSCCheckInController(), animated: true)
        } as ()->())
    ]

    var body: some View {
        VStack(alignment: .leading){
            Text("我的订单").font(.system(size: 16,weight: .bold))
            GeometryReader{ geometry in
                WrappedHStack(geometry: geometry) {
                    ForEach(items, id: \.0) { item in
                        if let view = item.2 as? AnyView{
                            NavigationLink(destination:view) {
                                VStack {
                                    Image(item.1)
                                    Text(item.0).font(.system(size: 12)).foregroundColor(.init(hex: 0x000000))
                                }
                                .frame(width:60)
                            }
                        }else {
                            if let block = item.2 as? (() -> ()){
                                VStack {
                                    Image(item.1)
                                    Text(item.0).font(.system(size: 12)).foregroundColor(.init(hex: 0x000000))
                                }.frame(width:60).onTapGesture {
                                    block()
                                }
                            }
                            
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

struct MineUIView_Previews: PreviewProvider {
    static var previews: some View {
        MineUIView(userManager: QZSCLoginManager.shared)
    }
}
