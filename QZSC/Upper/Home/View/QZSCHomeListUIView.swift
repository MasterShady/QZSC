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

struct QZSCHomeListUIView_Previews: PreviewProvider {
    static var previews: some View {
        return QZSCHomeListUIView()
    }
}
