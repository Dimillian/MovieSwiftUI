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

let sampleCasts = [People(id: 0,
                          name: "Cast 1",
                          character: "Character 1",
                          department: nil,
                          profile_path: "/2daC5DeXqwkFND0xxutbnSVKN6c.jpg",
                          known_for_department: "Acting",
                          known_for: [People.KnownFor(id: sampleMovie.id,
                                                      original_title: sampleMovie.original_title,
                                                      poster_path: sampleMovie.poster_path)],
                          also_known_as: nil, birthDay: nil,
                          deathDay: nil, place_of_birth: nil,
                          biography: nil, popularity: nil, images: nil),
                   People(id: 1, name: "Cast 2", character: nil, department: "Director 1", profile_path: "/2daC5DeXqwkFND0xxutbnSVKN6c.jpg",
                          known_for_department: "Acting", known_for: nil,
                          also_known_as: nil, birthDay: nil, deathDay: nil, place_of_birth: nil,
                          biography: nil, popularity: nil, images: nil)]
