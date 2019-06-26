//
//  AppState.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final public class Store<State: FluxState>: BindableObject {
    public var didChange = PassthroughSubject<State, Never>()
        
    private(set) public var state: State {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self.state)
            }
        }
    }
    
    private let reducer: Reducer<State>
    private let lock = NSLock()
    
    public init(reducer: @escaping Reducer<State>, state: State) {
        self.reducer = reducer
        self.state = state
    }
        
    public func dispatch(action: Action) {
        lock.lock()
        var state = self.state
        state = reducer(state, action)
        self.state = state
        lock.unlock()
    }
}
