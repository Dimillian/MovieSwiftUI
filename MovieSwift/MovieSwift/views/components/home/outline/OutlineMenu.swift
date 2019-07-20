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
    
    
    case popular, topRated, upcoming, nowPlaying, discover, myLists, settings
    
    var title: String {
        switch self {
        case .popular:    return "Popular"
        case .topRated:   return "Top rated"
        case .upcoming:   return "Upcoming"
        case .nowPlaying: return "Now Playing"
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
        case .discover:   return "square.stack.fill"
        case .myLists:    return "text.badge.plus"
        case .settings:   return "wrench"
        }
    }
    
    var contentView: AnyView {
        switch self {
        case .popular:    return AnyView( NavigationView{ PopularList() })
        case .topRated:   return AnyView( NavigationView{ TopRatedList() })
        case .upcoming:   return AnyView( NavigationView{ UpcomingList() })
        case .nowPlaying: return AnyView( NavigationView{ NowPlayingList() })
        case .discover:   return AnyView( DiscoverView() )
        case .myLists:    return AnyView( MyLists() )
        case .settings:   return AnyView( SettingsForm() )
        }
    }
}

