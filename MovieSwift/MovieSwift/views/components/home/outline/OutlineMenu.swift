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
    
    
    case popular, genres, fanClub, myLists, settings
    
    var title: String {
        switch self {
        case .popular:    return "Popular"
        case .genres:     return "Genres"
        case .fanClub:    return "Fan Club"
        case .myLists:    return "MyLists"
        case .settings:   return "Settings"
        }
    }
    
    var image: String {
        switch self {
        case .popular:    return "film.fill"
        case .genres:     return "tag.fill"
        case .fanClub:    return "star.circle.fill"
        case .myLists:    return "text.badge.plus"
        case .settings:   return "wrench"
        }
    }
    
    private func moviesList(menu: MoviesMenu) -> AnyView {
        AnyView( NavigationView{ MoviesHomeList(menu: .constant(menu),
                                                pageListener: MoviesMenuListPageListener(menu: menu)) })
    }
    
    var contentView: AnyView {
        switch self {
        case .popular:    return moviesList(menu: .popular)
        case .genres:     return AnyView( NavigationView { GenresList() })
        case .fanClub:    return AnyView( FanClubHome() )
        case .myLists:    return AnyView( MyLists() )
        case .settings:   return AnyView( SettingsForm() )
        }
    }
}

