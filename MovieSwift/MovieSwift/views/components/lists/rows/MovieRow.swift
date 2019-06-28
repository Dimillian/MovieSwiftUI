//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

fileprivate let placeholder = UIImage(named: "poster-placeholder")!

struct MovieRow : View {
    @EnvironmentObject var store: Store<AppState>
    
    let movieId: Int
    private var movie: Movie! {
        return store.state.moviesState.movies[movieId]
    }
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
        
    var body: some View {
        HStack {
            MoviePosterImage(imageLoader: ImageLoader(poster: movie.poster_path, size: .small))
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.userTitle)
                    .font(.FjallaOne(size: 20))
                    .color(.steam_gold)
                    .lineLimit(2)
                HStack {
                    PopularityBadge(score: Int(movie.vote_average * 10))
                    Text(MovieRow.formatter.string(from: movie.releaseDate ?? Date()))
                        .font(.subheadline)
                        .color(.secondary)
                        .lineLimit(1)
                }
                Text(movie.overview)
                    .color(.secondary)
                    .lineLimit(3)
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
