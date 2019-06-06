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

final class AppState: BindableObject {
    var didChange = PassthroughSubject<AppState, Never>()
    
    var moviesState: MoviesState
    
    init(moviesState: MoviesState = MoviesState()) {
        self.moviesState = moviesState
    }
    
    func dispatch(action: Action) {
        moviesState = MoviesStateReducer().reduce(state: moviesState, action: action)
        didChange.send(self)
    }
}

let store = AppState()
