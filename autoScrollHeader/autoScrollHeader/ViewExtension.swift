//
//  ViewExtension.swift
//  autoScrollHeader
//
//  Created by Diego Henrick on 08/07/24.
//

import SwiftUI

@available(iOS 16.0, *)
extension View {
    
    public func offset(_ coordinateSpace: AnyHashable, completion: @escaping (CGRect) -> ()) -> some View {
        self.overlay {
            GeometryReader {
                let rect = $0.frame(in: .named(coordinateSpace))
                Color.clear
                    .preference(key: OffsetKey.self, value: rect)
                    .onPreferenceChange(OffsetKey.self, perform: completion)
            }
        }
    }
    
    public func onAnimationCompleted<Value: VectorArithmetic>(for value: Value,
                                                              completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        self.modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }

    
}

public struct OffsetKey: PreferenceKey {
    public static var defaultValue: CGRect = .zero
    
    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
