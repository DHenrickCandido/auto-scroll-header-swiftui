//
//  AnimationCompletionObserverModifier.swift
//  autoScrollHeader
//
//  Created by Diego Henrick on 08/07/24.
//

import SwiftUI

@available (iOS 16.0, *)
public struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {
    public var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }
    
    private var targetValue: Value
    
    private var completion: () -> Void
    
    public init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }
    
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }
        
        DispatchQueue.main.async {
            self.completion()
        }
    }
    
    public func body(content: Content) -> some View {
        return content
    }
}
