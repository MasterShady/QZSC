//
//  AboutUsView.swift
//  QZSC
//
//  Created by 刘思源 on 2023/7/20.
//

import SwiftUI
import SwiftUIX

struct AboutUsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Image("appicon_small")
            Text("版本号v" + kAppVersion).font(.system(size: 16)).foregroundColor(.black)
            Spacer().frame(height: 99)
            HStack {
                Text("联系我们").font(.system(size: 16, weight: .semibold)).foregroundColor(.init(hex: 0x333333))
                Spacer()
                Image("bold_arrow")
            }
            Spacer()
            
        }
        .navigationBarColor(.clear)
        .navigationBarTitle("关于我们", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("back_arrow") //导航返回按钮图标
            }))
            .ignoresSafeArea(edges: .bottom).padding(.init(top: 12, leading: 16, bottom: 12, trailing: 16)).background(Color.init(hex: 0xF6F8FA)).hiddenTabBar()
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutUsView()
        }
        
    }
}
