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
    
    
    case popular, topRated, upcoming, nowPlaying, trending, genres, fanClub, discover, myLists, settings
    
    var title: String {
        switch self {
        case .popular:    return "Popular"
        case .topRated:   return "Top rated"
        case .upcoming:   return "Upcoming"
        case .nowPlaying: return "Now Playing"
        case .trending:   return "Trending"
        case .genres:     return "Genres"
        case .fanClub:    return "Fan Club"
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
        case .trending:   return "chart.bar.fill"
        case .genres:     return "tag.fill"
        case .fanClub:    return "star.circle.fill"
        case .discover:   return "square.stack.fill"
        case .myLists:    return "text.badge.plus"
        case .settings:   return "wrench"
        }
    }
    
    private func moviesList(menu: MoviesMenu) -> some View {
        NavigationView{ MoviesHomeList(menu: .constant(menu),
                                       pageListener: MoviesMenuListPageListener(menu: menu)) }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch self {
        case .popular:    moviesList(menu: .popular)
        case .topRated:   moviesList(menu: .topRated)
        case .upcoming:   moviesList(menu: .upcoming)
        case .nowPlaying: moviesList(menu: .nowPlaying)
        case .trending:   moviesList(menu: .trending)
        case .genres:     NavigationView { GenresList() }
        case .fanClub:    FanClubHome()
        case .discover:   DiscoverView()
        case .myLists:    MyLists()
        case .settings:   SettingsForm()
        }
    }
}

