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
}
