//
//  MovieRating.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieRating : View {
    let movie: Movie
    
    @State var showReview = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                PopularityBadge(score: Int(movie.vote_average * 10))
                Text("\(movie.vote_count) ratings")
            }
            Button(action: {
                self.showReview = true
            }, label: {
                Text("See reviews").color(.blue)
            })
            }.presentation(self.showReview ?
                Modal(MovieReviews(showReviews: $showReview, movie: movie.id).environmentObject(store))
            : nil)
            .padding(.top, 8)
            .padding(.bottom, 8)
    }
}

#if DEBUG
struct MovieRating_Previews : PreviewProvider {
    static var previews: some View {
        MovieRating(movie: sampleMovie)
    }
}
#endif
