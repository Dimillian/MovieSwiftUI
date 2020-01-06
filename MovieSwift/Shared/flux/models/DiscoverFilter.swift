//
//  DiscoverFilter.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 23/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct DiscoverFilter: Codable {
    let year: Int
    let startYear: Int?
    let endYear: Int?
    let sort: String
    let genre: Int?
    let region: String?
    
    static func randomFilter() -> DiscoverFilter {
        return DiscoverFilter(year: randomYear(),
                              startYear: nil,
                              endYear: nil,
                              sort: randomSort(),
                              genre: nil,
                              region: nil)
    }
    
    static func randomYear() -> Int {
        let calendar = Calendar.current
        return Int.random(in: 1950..<calendar.component(.year, from: Date()))
    }
    
    static func randomSort() -> String {
        let sortBy = ["popularity.desc",
                      "popularity.asc",
                      "vote_average.asc",
                      "vote_average.desc"]
        return sortBy[Int.random(in: 0..<sortBy.count)]
    }
    
    static func randomPage() -> Int {
        return Int.random(in: 1..<20)
    }
    
    func toParams() -> [String: String] {
        var params: [String: String] = [:]
        if let startYear = startYear, let endYear = endYear {
            params["primary_release_date.gte"] = "\(startYear)"
            params["primary_release_date.lte"] = "\(endYear)"
        } else {
            params["year"] = "\(year)"
        }
        if let genre = genre {
            params["with_genres"] = "\(genre)"
        }
        if let region = region {
            params["region"] = region
        }
        params["page"] = "\(DiscoverFilter.randomPage())"
        params["sort_by"] = sort
        params["language"] = "en-US"
        return params
    }
    
    func toText(genres: [Genre]) -> String {
        var text = String("")
        if let startYear = startYear, let endYear = endYear {
            text = text + "\(startYear)-\(endYear)"
        } else {
            text = text + " · Random"
        }
        if let genre = genre,
            let stateGenre = genres.first(where: { (realGenre) -> Bool in
                realGenre.id == genre
            }) {
            text = text + " · \(stateGenre.name)"
        }
        if let region = region {
            text = text + " · \(region)"
        }
        return text
    }
}
