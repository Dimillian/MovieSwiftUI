//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct MovieRow : View {
    // MARK: - Store
    @EnvironmentObject var store: Store<AppState>
    
    // MARK: - Init
    let movieId: Int
    var displayListImage = true
    
    // MARK: - Private computed vars
    private var movie: Movie! {
        store.state.moviesState.movies[movieId]
    }
        
    // MARK: - Body
    var body: some View {
        HStack {
            ZStack(alignment: .topLeading) {
                MoviePosterImage(imageLoader: ImageLoader(path: movie.poster_path,
                                                          size: .medium),
                                 posterSize: .medium)
                if displayListImage {
                    ListImage(movieId: movieId)
                }
            }
            .fixedSize()
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.userTitle)
                    .font(.FjallaOne(size: 20))
                    .foregroundColor(.steam_gold)
                    .lineLimit(2)
                HStack {
                    PopularityBadge(score: Int(movie.vote_average * 10))
                    Text(formatter.string(from: movie.releaseDate ?? Date()))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                Text(movie.overview)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .truncationMode(.tail)
            }.padding(.leading, 8)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
        .contextMenu{ MovieContextMenu(movieId: self.movieId) }
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
