//
//  MyCartView.swift
//  QZSC
//
//  Created by 刘思源 on 2023/7/14.
//

import SwiftUI
import SwiftUIIntrospect


class PickerWrapper{
    
    var model: Product
    
    init(model: Product) {
        self.model = model
    }
    
    lazy var durationPicker: SinglePicker<String> = {
        let title = NSMutableAttributedString(string:"选择商品类型")
        title.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.init(hexString: "111111"),
        ], range: .init(location: 0, length: title.length))
        
        let picker = SinglePicker<String>(title: title, data: model.type) {[weak self] data in
            self?.model.selectedTypeIndex = self?.model.type.indexOf(data) ?? 0
            self?.durationPicker.popDismiss()
        } titleForDatum: { value in
            return value
        }
        
        picker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 300))
        }
        return picker
        
    }()
}


struct MyCartView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    @State var didLoad = false
    
    
    var body: some View {
        VStack {
            List {
                (userData.cartItems.count > 0) ? VStack{
                    ForEach($userData.cartItems,id: \.id) { item in
                        CartCell(product: item, pickerWrapper: .init(model: item.wrappedValue))
                    }
                }.erasedToAnyView() : Image("cart_placeholder")
                    .imageScale(.large)
                    .foregroundColor(.accentColor).erasedToAnyView()
            }
            ComfirmPanel()
            
            
        }
        .navigationBarTitle("购物车", displayMode: .inline)
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
            }.ignoresSafeArea(edges: .bottom).environmentObject(userData).hiddenTabBar()
            
    }
}


struct ComfirmPanel : View{
    @EnvironmentObject var userData: UserData
    var body: some View{
        ZStack(alignment: .top) {
            HStack(alignment: .center){
                Text("¥").font(.system(size: 10)).foregroundColor(.init(hex:0xB8BED0)) + Text(String(format: "%.2f", userData.totalPrice)).font(.system(size: 28, weight: .bold)).foregroundColor(.init(hex: 0x333333))
                Spacer()
                Button {
                    
                } label: {
                    Text("立即结算").font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                }.frame(width: 144, height: 44).background(.black).cornerRadius(22)
                
            }.padding(.horizontal,16).frame(height: 64)
        }.padding(.bottom, 44).frame(height:108).background(.white)
    }
}


struct CartCell: View{
    @EnvironmentObject var userData: UserData
    @Binding var product: Product
    @State var deleteAlertShow = false
    let pickerWrapper : PickerWrapper
    
//    init(model: Product) {
//        self.model = model
//        self.pickerWrapper = PickerWrapper(model: model)
//    }
    
    var body: some View{
        return HStack(alignment:.top) {
            Image("").frame(width: 88, height: 88).background(Color.blue).cornerRadius(8)
            VStack(alignment: .leading) {
                Text(product.name).font(.system(size: 14, weight: .semibold)).foregroundColor(.init(hex: 0x333333))
                Button {
                    //弹窗
                    //pickerWrapper.durationPicker.popFromBottom()
                } label: {
                    HStack {
                        Text(product.selectedType).font(.system(size: 12)).foregroundColor(.init(hex: 0x868A96))
                        //Spacer()
                        Image("drop_down").resizable().frame(width: 16, height: 16)
                        
                    }.padding(.init(top: 4, leading: 8, bottom: 4, trailing: 4)).frame(height: 24).background(Color(hex: 0xF3F3F3)).cornerRadius(12)
                    
                }.buttonStyle(.plain)
                HStack {
                    Text(feeValue())
                    Spacer()
                    HStack{
                        Button {
                            if product.count == 1{
                                deleteAlertShow = true
                                return
                            }
                            product.count -= 1
                        } label: {
                            Image("cart_minus")
                        }.buttonStyle(.plain).alert(isPresented: $deleteAlertShow) {
                            Alert(title: Text(""), message: Text("确定要删除吗?"), primaryButton: .default(Text("确定"), action: {
                                userData.cartItems.remove(product)
                            }), secondaryButton: .cancel(Text("取消")))
                        }.buttonStyle(.plain)
                        
                        Text(String(product.count)).foregroundColor(.init(hex: 0x333333))
                        
                        Button {
                            product.count += 1
                        } label: {
                            Image("cart_plus")
                        }.buttonStyle(.plain)
                        
                    }.frame(width:72, height: 24).overlay(
                        Capsule()
                            .stroke(Color(hex: 0xF3F3F3), lineWidth: 1) // 添加边框
                    )
                }
                
                
            }
        }.padding(.init(top: 12, leading: 12, bottom: 9, trailing: 12)).background(Color.white)
    }
    
    
    func feeValue() -> AttributedString{
        let raw = String(format: "¥%.2f/天",userData.cartItems[0].fee)
        
        let attr = NSMutableAttributedString(string: raw, attributes: [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor(hexString: "#B8BED0")
        ])
        attr.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor(hexString: "111111")
        ], range: (raw as NSString).range(of: String(format: "%.2f", userData.cartItems[0].fee)))
        return AttributedString(attr)
    }
    
    
}

struct MyCartView_Previews: PreviewProvider {
    //@StateObject var userData =
    static var previews: some View {
        MyCartView().environmentObject(UserData())
    }
}


struct MyCartCell_Previews: PreviewProvider {
    static var previews: some View {
        let userData = Binding<UserData>(get: { return UserData() },
                                        set: { _ in })
        CartCell(product: userData.cartItems[0], pickerWrapper: .init(model: userData.cartItems[0].wrappedValue)).environmentObject(userData.wrappedValue).previewLayout(.sizeThatFits)
    }
}
