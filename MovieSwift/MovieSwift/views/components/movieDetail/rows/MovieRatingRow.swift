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
    
    @State private var isReviewsPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                PopularityBadge(score: Int(movie.vote_average * 10))
                Text("\(movie.vote_count) ratings")
                    .lineLimit(1)
                Button(action: {
                    self.isReviewsPresented = true
                }) {
                    HStack {
                        Text("Reviews")
                            .foregroundColor(.steam_blue)
                            .lineLimit(1)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 5, height: 10)
                            .foregroundColor(.steam_blue)
                    }
                }
            }
            }
            .padding(.top, 8)
            .padding(.bottom, 8)
            .sheet(isPresented: $isReviewsPresented,
                   content: { MovieReviews(isPresented: self.$isReviewsPresented,
                                           movie: self.movie.id).environmentObject(store) })
    }
}

#if DEBUG
struct MovieRating_Previews : PreviewProvider {
    static var previews: some View {
        MovieRatingRow(movie: sampleMovie)
    }
}
#endif
