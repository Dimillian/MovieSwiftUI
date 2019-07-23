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
    
    
    case popular, topRated, upcoming, nowPlaying, trending, discover, myLists, settings
    
    var title: String {
        switch self {
        case .popular:    return "Popular"
        case .topRated:   return "Top rated"
        case .upcoming:   return "Upcoming"
        case .nowPlaying: return "Now Playing"
        case .trending:   return "Trending"
        case .discover:   return "Discover"
        case .myLists:    return "MyLists"
        case .settings:   return "Settings"
        }
    }
    
    var image: String {
        switch self {
        case .popular:    return "film.fill"
        case .topRated:   return "star.fill"
        case .upcoming:   return "clock.fill"
        case .nowPlaying: return "play.circle.fill"
        case .trending :   return "star.fill"
        case .discover:   return "square.stack.fill"
        case .myLists:    return "text.badge.plus"
        case .settings:   return "wrench"
        }
    }
    
    private func moviesList(menu: MoviesMenu) -> AnyView {
        AnyView( NavigationView{ MoviesHomeList(menu: .constant(menu),
                                                pageListener: MoviesListPageListener(menu: menu)) })
    }
    
    var contentView: AnyView {
        switch self {
        case .popular:    return moviesList(menu: .popular)
        case .topRated:   return moviesList(menu: .topRated)
        case .upcoming:   return moviesList(menu: .upcoming)
        case .nowPlaying: return moviesList(menu: .nowPlaying)
        case .trending:   return moviesList(menu: .trending)
        case .discover:   return AnyView( DiscoverView() )
        case .myLists:    return AnyView( MyLists() )
        case .settings:   return AnyView( SettingsForm() )
        }
    }
}

