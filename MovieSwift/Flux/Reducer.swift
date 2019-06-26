//
//  Reducer.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

public typealias Reducer<FluxState> =
    (_ state: FluxState, _ action: Action) -> FluxState

