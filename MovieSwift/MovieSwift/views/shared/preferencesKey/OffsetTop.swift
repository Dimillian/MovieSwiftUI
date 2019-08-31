//
//  OffsetTop.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 30/08/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct OffsetTopPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    typealias Value = CGFloat
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
