//
//  StoreProvider.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 23/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct StoreProvider<StateType: FluxState, V: View>: View {
    let store: Store<StateType>
    let content: () -> V
    
    var body: some View {
        content().environmentObject(store)
    }
}
