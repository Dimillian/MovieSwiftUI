//
//  OutlineMenu.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 27/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

enum OutlineMenu: Int, CaseIterable, Identifiable {
    var id: Int {
        return self.rawValue
    }
    
    case popular, topRated, upcoming, nowPlaying, discover, wishlist, seenlist, myLists
    
    func title() -> String {
        switch self {
        case .popular:
            return "Popular"
        case .topRated:
            return "Top rated"
        case .upcoming:
            return "Upcoming"
        case .nowPlaying:
            return "Now Playing"
        case .discover:
            return "Discover"
        case .wishlist:
            return "Wishlist"
        case .seenlist:
            return "Seenlist"
        case .myLists:
            return "MyLists"
        }
    }
    
    func systemImageName() -> String {
        switch self {
        case .popular:
            return "film.fill"
        case .topRated:
            return "star.fill"
        case .upcoming:
            return "clock.fill"
        case .nowPlaying:
            return "play.circle.fill"
        case .discover:
            return "square.stack.fill"
        case .wishlist:
            return "heart.fill"
        case .seenlist:
            return "eye.fill"
        case .myLists:
            return "text.badge.plus"
        }
    }
}

