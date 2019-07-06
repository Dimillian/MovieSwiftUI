//
//  MovieImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 21/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct ImageData: Codable, Identifiable {
    let id = UUID()
    let aspect_ratio: Float
    let file_path: String
    let height: Int
    let width: Int
}
