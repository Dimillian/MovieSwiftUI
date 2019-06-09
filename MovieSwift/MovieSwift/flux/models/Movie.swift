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
    let poster_path: String
    let backdrop_path: String
}

let sampleMovie = Movie(id: 0,
                        original_title: "Test movie",
                        overview: "Test desc",
                        poster_path: "/uC6TTUhPpQCmgldGyYveKRAu8JN.jpg",
                        backdrop_path: "/nl79FQ8xWZkhL3rDr1v2RFFR6J0.jpg")
