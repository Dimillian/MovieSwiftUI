//
//  ConnectedView.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 23/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUIFlux

protocol ConnectedView: View {
    associatedtype State: FluxState
    associatedtype Props
    associatedtype V: View
    
    func map(state: State, dispatch: @escaping (Action) -> Void) -> Props
    func body(props: Props) -> V
}

extension ConnectedView {
    func render(state: State, dispatch: @escaping (Action) -> Void) -> V {
        let props = map(state: state, dispatch: dispatch)
        return body(props: props)
    }
    
    var body: StoreConnector<State, V> {
        return StoreConnector(content: render)
    }
    
}
