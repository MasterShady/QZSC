//
//  QZSCHomeListUIView.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/19.
//

import SwiftUI

struct QZSCHomeListUIView: View {
    var title: String?
    var imgName: String?
    var price: String?
    
    var body: some View {
        ZStack {
            Color.red
            .padding(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
            .frame(width: kScreenWidth, height: 115)
            .overlay(alignment: .leading) {
                Image("")
                    .resizable()
                    .background(Color.blue)
                    .frame(width: 88, height: 88)
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 12, leading: 25, bottom: 12, trailing: 0))
                    .overlay(alignment: .topLeading) {
                        Image("home_cell_new_bg")
                            .resizable()
                            .frame(width: 36, height: 14)
                    }
            }
        }
    }
}

struct QZSCHomeListUIView_Previews: PreviewProvider {
    static var previews: some View {
        return QZSCHomeListUIView()
    }
}
