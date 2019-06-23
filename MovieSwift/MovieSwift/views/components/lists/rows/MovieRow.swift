//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

fileprivate let placeholder = UIImage(named: "poster-placeholder")!

struct MovieRow : View {
    @EnvironmentObject var store: AppStore
    
    let movieId: Int
    var movie: Movie! {
        return store.state.moviesState.movies[movieId]
    }
        
    var body: some View {
        HStack {
            MoviePosterImage(imageLoader: ImageLoader(poster: movie.poster_path, size: .small))
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.original_title).font(.FHACondFrenchNC(size: 22))
                Text(movie.overview)
                    .color(.secondary)
                    .lineLimit(8)
                    .truncationMode(.tail)
            }.padding(.leading, 8)
        }.padding(8)
    }
}

#if DEBUG
struct MovieRow_Previews : PreviewProvider {
    static var previews: some View {
        List {
            MovieRow(movieId: sampleMovie.id).environmentObject(sampleStore)
        }
    }
}
#endif
