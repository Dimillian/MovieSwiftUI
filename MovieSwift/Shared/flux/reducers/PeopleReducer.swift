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
        state = mergePeople(peoples: action.response.cast, state: state)
        state = mergePeople(peoples: action.response.crew, state: state)
        state.peoplesMovies[action.movie] = Set(action.response.cast.map{ $0.id } + action.response.crew.map{ $0.id })

    case let action as PeopleActions.SetSearch:
        if action.page == 1 {
            state.search[action.query] = action.response.results.map{ $0.id }
        } else {
            state.search[action.query]?.append(contentsOf: action.response.results.map{ $0.id })
        }
        state = mergePeople(peoples: action.response.results, state: state)
        
    case let action as PeopleActions.SetPopular:
        if action.page == 1 {
            state.popular = action.response.results.map{ $0.id }
        } else {
            state.popular.append(contentsOf: action.response.results.map{ $0.id })
        }
        state = mergePeople(peoples: action.response.results, state: state)
        
    case let action as PeopleActions.SetDetail:
        if let current = state.peoples[action.person.id] {
            var new = action.person
            new.known_for = current.known_for
            new.images = current.images
            new.character = current.character
            new.department = current.department
            state.peoples[action.person.id] = new
        } else {
            state.peoples[action.person.id] = action.person
        }
        
    case let action as PeopleActions.SetPeopleCredits:
        if let cast = action.response.cast {
            if state.casts[action.people] == nil {
                state.casts[action.people] = [:]
            }
            for meta in cast where meta.character != nil {
                state.casts[action.people]![meta.id] = meta.character!
            }
        }
        
        if let crew = action.response.crew {
            if state.crews[action.people] == nil {
                state.crews[action.people] = [:]
            }
            for meta in crew where meta.department != nil {
                state.crews[action.people]![meta.id] = meta.department!
            }
        }
        
    case let action as PeopleActions.SetImages:
        state.peoples[action.people]?.images = action.images
        
    case let action as PeopleActions.AddToFanClub:
        state.fanClub.insert(action.people)
        
    case let action as PeopleActions.RemoveFromFanClub:
        state.fanClub.remove(action.people)
        
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

