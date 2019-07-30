//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MovieCrosslineRow : View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .titleStyle()
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
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
            NavigationLink(destination: MovieDetail(movieId: movie.id).environmentObject(store)) {
                ZStack(alignment: .topLeading) {
                    MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: movie.poster_path,
                                                                                    size: .medium),
                                     posterSize: .medium)
                    ListImage(movieId: movie.id)
                    
                }
                .fixedSize()
                .contextMenu{ MovieContextMenu(movieId: movie.id) }
                Text(movie.userTitle)
                    .font(.body)
                    .foregroundColor(.primary)
                Text(movie.release_date != nil ? movie.release_date!.prefix(4) : "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            }
        .frame(width: 120)
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
