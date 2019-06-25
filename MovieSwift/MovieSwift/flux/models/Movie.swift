//
//  Movie.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct Movie: Codable, Identifiable {
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String?
    let backdrop_path: String?
    let popularity: Float
    let vote_average: Float
    let vote_count: Int
    let release_date: String
    
    let genres: [Genre]?
    let runtime: Int?
    let status: String?
    
    var keywords: Keywords?
    var images: Images?
    
    var production_countries: [productionCountry]?
    
    struct Keywords: Codable {
        let keywords: [Keyword]?
    }
    
    struct Images: Codable {
        let posters: [MovieImage]?
        let backdrops: [MovieImage]?
    }
    
    struct productionCountry: Codable, Identifiable {
        let id = UUID()
        let name: String
    }
}

let sampleMovie = Movie(id: 0,
                        original_title: "Test movie",
                        overview: "Test desc",
                        poster_path: "/uC6TTUhPpQCmgldGyYveKRAu8JN.jpg",
                        backdrop_path: "/nl79FQ8xWZkhL3rDr1v2RFFR6J0.jpg",
                        popularity: 50.5,
                        vote_average: 8.9,
                        vote_count: 1000,
                        release_date: "1972-03-14",
                        genres: [Genre(id: 0, name: "test")],
                        runtime: 80,
                        status: "released")
