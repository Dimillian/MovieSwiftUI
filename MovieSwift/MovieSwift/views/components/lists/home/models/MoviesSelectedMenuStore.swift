//
//  MoviesSelectedMenuStore.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class MoviesSelectedMenuStore: BindableObject {
    var willChange = PassthroughSubject<Void, Never>()
    let pageListener: MoviesListPageListener
    
    var menu: MoviesMenu {
        willSet {
            willChange.send()
        }
        didSet {
            pageListener.menu = menu
        }
    }
        
    init(selectedMenu: MoviesMenu, pageListener: MoviesListPageListener) {
        self.menu = selectedMenu
        self.pageListener = pageListener
    }
}
