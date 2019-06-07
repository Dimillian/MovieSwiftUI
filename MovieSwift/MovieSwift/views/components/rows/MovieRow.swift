//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieRow : View {
    let movie: Movie
    var body: some View {
        VStack {
            Text(movie.original_title)
            Text(movie.overview).color(.secondary).lineLimit(0)
        }
    }
}

#if DEBUG
struct MovieRow_Previews : PreviewProvider {
    static var previews: some View {
        MovieRow(movie: Movie(id: 0, original_title: "Title", overview: "Overview \n Overview"))
    }
}
#endif
