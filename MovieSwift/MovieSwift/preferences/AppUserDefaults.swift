//
//  UserDefaults.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 25/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

struct AppUserDefaults {
    @UserDefault("user_region", defaultValue: Locale.current.regionCode ?? "US")
    static var region: String
        
    @UserDefault("original_title", defaultValue: false)
    static var alwaysOriginalTitle: Bool
}
