//
//  SwiftUI++.swift
//  QZSC
//
//  Created by 刘思源 on 2023/7/18.
//

import SwiftUI


struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            DispatchQueue.main.async {
                Tool.showTabBar()
            }
        }
    }
}

struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }
}


extension UIView {
       
       func allSubviews() -> [UIView] {
           var res = self.subviews
           for subview in self.subviews {
               let riz = subview.allSubviews()
               res.append(contentsOf: riz)
           }
           return res
       }
   }
   
   struct Tool {
       static func showTabBar() {
           UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
               if let view = v as? UITabBar {
                   view.isHidden = false
               }
           })
       }
       
       static func hiddenTabBar() {
           UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
               if let view = v as? UITabBar {
                   view.isHidden = true
               }
           })
       }
   }
   
   extension View {
       func showTabBar() -> some View {
           return self.modifier(ShowTabBar())
       }
       func hiddenTabBar() -> some View {
           return self.modifier(HiddenTabBar())
       }
   }


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            self
            placeholder().opacity(shouldShow ? 1 : 0).allowsHitTesting(false)
        }
    }
}


struct TextArea: View {
    @Binding var text: String
    let placeholder: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text) // <= Here
                .padding(4)
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
        }
        .font(.body)
    }
}
