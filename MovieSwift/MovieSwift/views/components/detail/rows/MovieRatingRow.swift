//
//  MovieRating.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieRatingRow : View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                PopularityBadge(score: Int(movie.vote_average * 10))
                Text("\(movie.vote_count) ratings")
            }
            PresentationButton(destination: MovieReviews(movie: movie.id).environmentObject(store),
                               label: {
                                Text("See reviews").color(.blue)
            })
            }
            .padding(.top, 8)
            .padding(.bottom, 8)
    }
}

#if DEBUG
struct MovieRating_Previews : PreviewProvider {
    static var previews: some View {
        MovieRatingRow(movie: sampleMovie)
    }
}
#endif
