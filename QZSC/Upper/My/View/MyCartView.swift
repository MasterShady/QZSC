//
//  MyCartView.swift
//  QZSC
//
//  Created by 刘思源 on 2023/7/14.
//

import SwiftUI



struct MyCartView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    @State var didLoad = false
    
    
    var body: some View {
        
        VStack {
            (userData.cartItems.count > 0) ? VStack{
                ForEach(userData.cartItems,id: \.name) { item in
                    CartCell(model: item)
                }
            }.erasedToAnyView() : Image("cart_placeholder")
                .imageScale(.large)
                .foregroundColor(.accentColor).erasedToAnyView()
            
            
            
        }.navigationBarTitle("购物车", displayMode: .inline)
            .navigationBarBackButtonHidden(true) //隐藏系统的导航返回按钮
            .navigationBarItems(leading: Button(action: { //自定义导航的返回按钮
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("back_arrow") //导航返回按钮图标
            }))
            .onAppear {
                if (!didLoad){
                    didLoad = true
                    //updateData
                    
            }
        }
    }
}


struct CartCell: View{
    var model: Product
    var body: some View{
        return Text(model.name)
    }
}

struct MyCartView_Previews: PreviewProvider {
    static var previews: some View {
        MyCartView().environmentObject(UserData())
    }
}
