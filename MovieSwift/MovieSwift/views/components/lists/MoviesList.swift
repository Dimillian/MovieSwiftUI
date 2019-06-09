//
//  MoviesList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MoviesList : View {
    let movies: [Int]
    
    var body: some View {
        List(movies) { id in
            NavigationButton(destination: MovieDetail(movieId: id)) {
                MovieRow(movieId: id)
            }
        }
    }
}

#if DEBUG
struct MoviesList_Previews : PreviewProvider {
    static var previews: some View {
        MoviesList(movies: [sampleMovie.id])
    }
}
#endif
