//
//  CustomListCoverRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 08/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct CustomListCoverRow : View {
    @EnvironmentObject var store: Store<AppState>
    
    let movieId: Int
    var movie: Movie! {
        return store.state.moviesState.movies[movieId]
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            MovieBackdropImage(imageLoader: ImageLoader(path: movie.backdrop_path ?? movie.poster_path, size: .medium))
        }.listRowInsets(EdgeInsets())
    }
}

#if DEBUG
struct CustomListCoverRow_Previews : PreviewProvider {
    static var previews: some View {
        CustomListCoverRow(movieId: 0).environmentObject(sampleStore)
    }
}
#endif
