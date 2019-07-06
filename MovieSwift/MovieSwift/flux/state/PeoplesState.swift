//
//  CastsState.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct PeoplesState: FluxState {
    var peoples: [Int: People] = [:]
    var peoplesMovies: [Int: [Int]] = [:]
    var search: [String: [Int]] = [:]
}
