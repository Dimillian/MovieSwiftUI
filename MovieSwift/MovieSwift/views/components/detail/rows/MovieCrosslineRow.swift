//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieCrosslineRow : View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.FHACondFrenchNC(size: 20))
                .padding(.leading)
            ScrollView(showsHorizontalIndicator: false) {
                HStack(spacing: 32) {
                    ForEach(self.movies) { movie in
                        MovieDetailRowItem(movie: movie)
                    }
                    }.padding(.leading)
            }
        }
            .listRowInsets(EdgeInsets())
            .padding(.top)
            .padding(.bottom)
    }
}

struct MovieDetailRowItem: View {
    let movie: Movie
    
    var body: some View {
            VStack(alignment: .center) {
                NavigationButton(destination: MovieDetail(movieId: movie.id)) {
                    MoviePosterImage(imageLoader: ImageLoader(poster: movie.poster_path, size: .medium))
                    Text(movie.original_title)
                        .font(.body)
                        .color(.primary)
                    Text(movie.release_date.prefix(4))
                        .font(.subheadline)
                        .color(.secondary)
                }
                }.frame(width: 120)
    }
}

#if DEBUG
struct MovieDetailRow_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieCrosslineRow(title: "Sample", movies: [sampleMovie, sampleMovie])
        }
    }
}
#endif
