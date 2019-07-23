//
//  StoreConnector.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 23/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct StoreConnector<State: FluxState, V: View>: View {
    @EnvironmentObject var store: Store<State>
    let content: (State, @escaping (Action) -> Void) -> V
    
    var body: V {
        content(store.state, store.dispatch(action:))
    }
}
