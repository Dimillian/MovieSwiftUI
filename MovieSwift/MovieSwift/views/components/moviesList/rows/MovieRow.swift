//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend
import UI

fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct MovieRow: ConnectedView {
    struct Props {
        let movie: Movie
    }
    
    // MARK: - Init
    let movieId: Int
    var displayListImage = true
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(movie: state.moviesState.movies[movieId]!)
    }
    
    func body(props: Props) -> some View {
        HStack {
            ZStack(alignment: .topLeading) {
                MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.movie.poster_path,
                                                                                size: .medium),
                                 posterSize: .medium)
                if displayListImage {
                    ListImage(movieId: movieId)
                }
            }
            .fixedSize()
            .animation(.spring())
            VStack(alignment: .leading, spacing: 8) {
                Text(props.movie.userTitle)
                    .titleStyle()
                    .foregroundColor(.steam_gold)
                    .lineLimit(2)
                HStack {
                    PopularityBadge(score: Int(props.movie.vote_average * 10))
                    Text(formatter.string(from: props.movie.releaseDate ?? Date()))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                Text(props.movie.overview)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .truncationMode(.tail)
            }.padding(.leading, 8)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
        .contextMenu{ MovieContextMenu(movieId: self.movieId) }
        .redacted(reason: movieId == 0 ? .placeholder : [])
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

