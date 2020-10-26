//
//  CastsState.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct PeoplesState: FluxState, Codable {
    var peoples: [Int: People] = [:]
    var peoplesMovies: [Int: Set<Int>] = [:]
    var search: [String: [Int]] = [:]
    var popular: [Int] = []
    
    /// [PeopleId: [MovieId:  Character]]
    var casts: [Int: [Int: String]] = [:]
    /// [PeopleId: [MovieId:  Character]]
    var crews: [Int: [Int: String]] = [:]
    
    var fanClub: Set<Int> = Set()
    
    enum CodingKeys: String, CodingKey {
        case peoples, fanClub
    }
}
