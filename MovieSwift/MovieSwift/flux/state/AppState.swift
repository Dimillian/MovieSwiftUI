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
    var castsState: CastsState
    
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
            let state = try? decoder.decode(MoviesState.self, from: data) {
            self.moviesState = state
        } else {
            self.moviesState = moviesState
        }
        
        self.castsState = castsState
    }
    
    func archiveState() {
        guard let data = try? encoder.encode(moviesState) else {
            return
        }
        try? data.write(to: savePath)
    }
    
    func dispatch(action: Action) {
        moviesState = MoviesReducer().reduce(state: moviesState, action: action)
        castsState = CastsReducer().reduce(state: castsState, action: action)
        DispatchQueue.main.async {
            self.didChange.send(self)
        }
    }
}

let store = AppState(useAchivedState: true)
let sampleStore = AppState(useAchivedState: false,
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
