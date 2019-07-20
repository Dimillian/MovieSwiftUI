//
//  TextBadge.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 15/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct GenreBadge : View {
    let genre: Genre
    
    var body: some View {
        NavigationLink(destination: MoviesGenreList(genre: genre).environmentObject(store)) {
            RoundedBadge(text: genre.name)
        }
    }
}

#if DEBUG
struct TextBadge_Previews : PreviewProvider {
    static var previews: some View {
        GenreBadge(genre: Genre(id: 0, name: "Test"))
    }
}
#endif
