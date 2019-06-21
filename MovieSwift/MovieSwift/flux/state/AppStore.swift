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

final class AppStore: BindableObject {
    var didChange = PassthroughSubject<AppStore, Never>()
    
    struct AppState {
        var moviesState: MoviesState
        var castsState: CastsState
    }
    
    private(set) var state = AppState(moviesState: MoviesState(), castsState: CastsState())
    
    private let savePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(useAchivedState: Bool, moviesState: MoviesState = MoviesState(), castsState: CastsState = CastsState()) {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
            self.savePath = documentDirectory.appendingPathComponent("userData")
        } catch let error {
            fatalError("Couldn't create save state data with error: \(error)")
        }
        
        if useAchivedState,
            let data = try? Data(contentsOf: savePath),
            let moviesState = try? decoder.decode(MoviesState.self, from: data) {
            state.moviesState = moviesState
        } else {
            state.moviesState = moviesState
        }
        
        state.castsState = castsState
    }
    
    func archiveState() {
        guard let data = try? encoder.encode(state.moviesState) else {
            return
        }
        try? data.write(to: savePath)
    }
    
    func dispatch(action: Action) {
        var state = self.state
        state.moviesState = MoviesReducer().reduce(state: state.moviesState, action: action)
        state.castsState = CastsReducer().reduce(state: state.castsState, action: action)
        self.state = state
        DispatchQueue.main.async {
            self.didChange.send(self)
        }
    }
}

let store = AppStore(useAchivedState: true)
let sampleStore = AppStore(useAchivedState: false,
                           moviesState: MoviesState(movies: [0: sampleMovie],
                                                    recommanded: [0: [0]],
                                                    similar: [0: [0]],
                                                    popular: [0],
                                                    topRated: [0],
                                                    upcoming: [0],
                                                    customLists: [CustomList(name: "TestName",
                                                                            cover: 0,
                                                                            movies: [])]),
                           castsState: CastsState())
