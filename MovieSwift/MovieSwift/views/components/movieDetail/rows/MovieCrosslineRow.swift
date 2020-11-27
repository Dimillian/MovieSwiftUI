//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend
import UI

struct MovieCrosslineRow : View {
    let title: String
    let movies: [Movie]
    
    private var listView: some View {
        MoviesList(movies: movies.map{ $0.id },
                   displaySearch: false,
                   pageListener: nil).navigationBarTitle(title)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .titleStyle()
                    .padding(.leading)
                NavigationLink(destination: listView) {
                    Text("See all")
                        .foregroundColor(.steam_blue)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 32) {
                    ForEach(self.movies) { movie in
                        MovieDetailRowItem(movie: movie)
                    }
                }.padding(.leading)
            }
        }
        .listRowInsets(EdgeInsets())
        .padding(.vertical)
    }
}

struct MovieDetailRowItem: View {
    let movie: Movie
    
    var body: some View {
        NavigationLink(destination: MovieDetail(movieId: movie.id)) {
            VStack(alignment: .center) {
                ZStack(alignment: .topLeading) {
                    MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: movie.poster_path,
                                                                                    size: .medium),
                                     posterSize: .medium)
                    ListImage(movieId: movie.id)
                    
                }.fixedSize()
                Text(movie.userTitle)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                PopularityBadge(score: Int(movie.vote_average * 10))
            }.frame(width: 120, height: 240)
        }.contextMenu{ MovieContextMenu(movieId: movie.id) }
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
