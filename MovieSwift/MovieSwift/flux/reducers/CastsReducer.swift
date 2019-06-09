//
//  CastsReducer.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

struct CastsReducer: Reducer {
    func reduce(state: CastsState, action: Action) -> CastsState {
        var state = state
        if let action = action as? CastsActions.SetMovieCasts {
            for cast in action.response.cast {
                state.casts[cast.id] = cast
            }
            for cast in action.response.crew {
                state.casts[cast.id] = cast
            }
            state.castsMovie[action.movie] = action.response.cast.map{ $0.id } + action.response.crew.map{ $0.id }
        }
        return state
    }
}
