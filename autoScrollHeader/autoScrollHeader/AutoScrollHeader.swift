//
//  AutoScrollHeader.swift
//  autoScrollHeader
//
//  Created by Diego Henrick on 08/07/24.
//

import SwiftUI

@available(iOS 16.0, *)
public struct AutoScrollHeader: View {
    @State var sections: [String]
    var contentProxy: ScrollViewProxy
    @State var action: (String) -> ()
    
    @Binding private var activeTab: String
    
    @Binding private var animationProgress: CGFloat
    @Namespace private var animation
    private let activeTabAnimationId: String = "activeTabAnimation"
    
    public init(sections: [String],
                animationProgress: Binding<CGFloat>,
                activeTab: Binding<String>,
                _ contentProxy: ScrollViewProxy,
                action: @escaping (String) -> ()) {
        self._sections = State(initialValue: sections)
        self._action = State(initialValue: action)
        self._animationProgress = animationProgress
        self._activeTab = activeTab
        self.contentProxy = contentProxy
    }
    
    public var body: some View {
        ScrollViewReader { autoScrollHeaderProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16.0) {
                    ForEach(sections, id: \.self) { section in
                        sectionView(section: section, contentProxy: contentProxy, autoScrollHeaderProxy: autoScrollHeaderProxy)
                    }
                }
                .padding(.horizontal, 20.0)
                .onChange(of: activeTab) { _ , newValue in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        autoScrollHeaderProxy.scrollTo(newValue, anchor: .center)
                    }
                }
                .onAnimationCompleted(for: animationProgress) {
                    animationProgress = 0.0
                }
            }
            .background {
                Rectangle()
                    .fill(.white)
            }
        }
    }
    
    @ViewBuilder
    private func sectionView(section: String,
                             contentProxy: ScrollViewProxy,
                             autoScrollHeaderProxy: ScrollViewProxy) -> some View {
        HStack(spacing: 8.0) {

            Text(section)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(activeTab == section ? Color("redIfood") : .gray)
                .padding(.horizontal, 4.0)
        }.background(alignment: .bottom, content: {
            if activeTab == section {
                Capsule()
                    .fill(Color("redIfood"))
                    .frame(height: 2.0)
                    .offset(y: 14.0)
                    .matchedGeometryEffect(id: activeTabAnimationId, in: animation)
            }
        })
        .padding(.vertical, 14.0)
        .contentShape(Rectangle())
        .id(section)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                activeTab = section
                animationProgress = 1.0
                autoScrollHeaderProxy.scrollTo(section, anchor: .topLeading)
                contentProxy.scrollTo(section, anchor: .top)
            }
        }
    }
}

@available(iOS 16.0, *)
struct AutoScrollHeader_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
    }
    
    private struct PreviewWrapper: View {
        @State(initialValue: "TabTab 1") var activeTab: String
        @State(initialValue: .zero)  var animationProgress: CGFloat
        var sections: [String] = ["TabTab 1", "TabTab 2","TabTab 3", "TabTab 4"]
        
        var body: some View {
            VStack {
                ScrollViewReader { proxy in
                    AutoScrollHeader(sections: sections,
                               animationProgress: $animationProgress,
                               activeTab: $activeTab,
                               proxy) { _ in }
                }
            }
        }
    }
}


