//
//  CastResponse.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

struct CastResponse: Codable {
    let id: Int
    let cast: [People]
    let crew: [People]
}

let sampleCasts = [People(id: 0, name: "Cast 1", character: "Character 1", department: nil, profile_path: nil),
                   People(id: 1, name: "Cast 2", character: nil, department: "Director 1", profile_path: nil)]
