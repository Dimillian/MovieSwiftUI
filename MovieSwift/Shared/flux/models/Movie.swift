//
//  Movie.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Backend

struct Movie: Codable, Identifiable {
    let id: Int
    
    let original_title: String
    let title: String
    var userTitle: String {
        return AppUserDefaults.alwaysOriginalTitle ? original_title : title
    }
    
    let overview: String
    let poster_path: String?
    let backdrop_path: String?
    let popularity: Float
    let vote_average: Float
    let vote_count: Int
    
    let release_date: String?
    var releaseDate: Date? {
        return release_date != nil ? Movie.dateFormatter.date(from: release_date!) : Date()
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()
    
    let genres: [Genre]?
    let runtime: Int?
    let status: String?
    let video: Bool
    
    var keywords: Keywords?
    var images: MovieImages?
    
    var production_countries: [productionCountry]?
    
    var character: String?
    var department: String?
    
    struct Keywords: Codable {
        let keywords: [Keyword]?
    }
    
    struct MovieImages: Codable {
        let posters: [ImageData]?
        let backdrops: [ImageData]?
    }
    
    struct productionCountry: Codable, Identifiable {
        var id: String {
            name
        }
        let name: String
    }
}

let sampleMovie = Movie(id: 0,
                        original_title: "Test movie Test movie Test movie Test movie Test movie Test movie Test movie ",
                        title: "Test movie Test movie Test movie Test movie Test movie Test movie Test movie  Test movie Test movie Test movie",
                        overview: "Test desc",
                        poster_path: "/uC6TTUhPpQCmgldGyYveKRAu8JN.jpg",
                        backdrop_path: "/nl79FQ8xWZkhL3rDr1v2RFFR6J0.jpg",
                        popularity: 50.5,
                        vote_average: 8.9,
                        vote_count: 1000,
                        release_date: "1972-03-14",
                        genres: [Genre(id: 0, name: "test")],
                        runtime: 80,
                        status: "released",
                        video: false)
