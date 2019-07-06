//
//  CastsReducer.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUIFlux

func peoplesStateReducer(state: PeoplesState, action: Action) -> PeoplesState {
    var state = state
    switch action {
    case let action as PeopleActions.SetMovieCasts:
        for cast in action.response.cast {
            state.peoples[cast.id] = cast
        }
        for cast in action.response.crew {
            state.peoples[cast.id] = cast
        }
        state.peoplesMovies[action.movie] = action.response.cast.map{ $0.id } + action.response.crew.map{ $0.id }
    case let action as PeopleActions.SetSearch:
        if action.page == 1 {
            state.search[action.query] = action.response.results.map{ $0.id }
        } else {
            state.search[action.query]?.append(contentsOf: action.response.results.map{ $0.id })
        }
        state = mergePeople(peoples: action.response.results, state: state)
        
    case let action as PeopleActions.SetDetail:
        state.peoples[action.person.id] = action.person
        
    case let action as PeopleActions.SetImages:
        state.peoples[action.people]?.images = action.images
        
    default:
        break
    }

    return state
}

private func mergePeople(peoples: [People], state: PeoplesState) -> PeoplesState {
    var state = state
    for people in peoples {
        if state.peoples[people.id] == nil {
            state.peoples[people.id] = people
        }
    }
    return state
}

