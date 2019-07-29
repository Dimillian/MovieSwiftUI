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

final class MoviesSelectedMenuStore: ObservableObject {
    var willChange = PassthroughSubject<Void, Never>()
    let pageListener: MoviesMenuListPageListener
    
    var menu: MoviesMenu {
        willSet {
            willChange.send()
        }
        didSet {
            pageListener.menu = menu
        }
    }
        
    init(selectedMenu: MoviesMenu) {
        self.menu = selectedMenu
        self.pageListener = MoviesMenuListPageListener(menu: selectedMenu)
    }
}
