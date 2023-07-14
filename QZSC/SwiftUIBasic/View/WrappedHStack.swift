//
//  WrappingHStack.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 4/19/23.
//

import SwiftUI

struct WrappedHStack<Content: View>: View {
    private let content: [Content]
    private var spacing: CGFloat
    private let geometry: GeometryProxy
    
    init(geometry: GeometryProxy, spacing: CGFloat = 40, content: [Content]) {
        self.content = content
        self.spacing = spacing
        self.geometry = geometry
    }
    
    var body: some View {
        let rowBuilder = RowBuilder(spacing: spacing,
                                    containerWidth: geometry.size.width)
        
        let rowViews = rowBuilder.generateRows(views: content)
        let finalView = ForEach(rowViews.indices) { rowViews[$0] }
        
        VStack(alignment: .leading, spacing: 20) {
            finalView
        }.frame(width: geometry.size.width)
    }
}

extension WrappedHStack {
    init<Data, ID: Hashable>(geometry: GeometryProxy,spacing: CGFloat = 40, @ViewBuilder content: () -> ForEach<Data, ID, Content>) {
        let views = content()
        self.geometry = geometry
        self.spacing = spacing
        self.content = views.data.map(views.content)
    }

    init(geometry: GeometryProxy,spacing: CGFloat = 40, content: () -> [Content]) {
        
        self.spacing = spacing
        self.geometry = geometry
        self.content = content()
    }
}

extension WrappedHStack {
    struct RowBuilder {
        private var spacing: CGFloat
        private var containerWidth: CGFloat
        
        init(spacing: CGFloat, containerWidth: CGFloat) {
            self.spacing = spacing
            self.containerWidth = containerWidth
        }
        
        func generateRows<Content: View>(views: [Content]) -> [AnyView] {
            var rows = [AnyView]()
            
            var currentRowViews = [AnyView]()
            var currentRowWidth: CGFloat = 0
            
            for view in views {
                let viewWidth = view.getSize().width
                
                if currentRowWidth + viewWidth > containerWidth {
                    rows.append(createRow(for: currentRowViews))
                    currentRowViews = []
                    currentRowWidth = 0
                }
                currentRowViews.append(view.erasedToAnyView())
                currentRowWidth += viewWidth + spacing
            }
            rows.append(createRow(for: currentRowViews))
            return rows
        }
        
        private func createRow(for views: [AnyView]) -> AnyView {
            HStack(alignment: .center, spacing: spacing) {
                ForEach(views.indices) { views[$0] }
            }
            .erasedToAnyView()
        }
    }
}

extension View {
    func erasedToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func getSize() -> CGSize {
        UIHostingController(rootView: self).view.intrinsicContentSize
    }
}
