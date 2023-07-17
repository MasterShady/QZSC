//
//  QZSCHomeUIView.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/17.
//

import SwiftUI

struct QZSCHomeListModel: Identifiable {
    let id = UUID()
    
    var title: String?
    var imgName: String?
    var price: String?
    
    init(title: String? = nil, imgName: String? = nil, price: String? = nil) {
        self.title = title
        self.imgName = imgName
        self.price = price
    }
}

struct QZSCHomeUIView: View {
    
    @State var models = [
        QZSCHomeListModel(title: "越秀集团IP吉祥物-超级越越-古田路9号", price: "29.9"),
        QZSCHomeListModel(title: "越秀集团IP吉祥物-超级越越-古田路9号", price: "29.9"),
        QZSCHomeListModel(title: "越秀集团IP吉祥物-超级越越-古田路9号", price: "29.9"),
        QZSCHomeListModel(title: "越秀集团IP吉祥物-超级越越-古田路9号", price: "29.9"),
        QZSCHomeListModel(title: "越秀集团IP吉祥物-超级越越-古田路9号", price: "29.9")
    ]
    
    var body: some View {
        NavigationView {
            List(models) { model in
                NavigationView {
                    QZSCHomeListUIView(title: model.title, imgName: model.imgName, price: model.price)
                }
            }
        }
    }
}

struct QZSCHomeUIView_Previews: PreviewProvider {
    static var previews: some View {
        QZSCHomeUIView()
    }
}

struct QZSCHomeListUIView: View {
    var title: String?
    var imgName: String?
    var price: String?
    
    var body: some View {
        ZStack {
            HStack {
                Image("")
                    .background(Color.blue)
                    .frame(width: 88, height: 88)
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 0))
            }
        }.padding(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
    }
}
