//
//  MovieReviews.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieReviews : View {
    @EnvironmentObject var state: AppState
    @Environment(\.isPresented) var isPresented
    
    let movie: Int
    
    var reviews: [Review] {
        return state.moviesState.reviews[movie] ?? []
    }
    
    func onCloseButton() {
        isPresented?.value = false
    }
    
    var body: some View {
        NavigationView {
            List(reviews) {review in
                ReviewRow(review: review)
            }
            .navigationBarTitle(Text("Reviews"))
            .navigationBarItems(trailing: Button(action: onCloseButton) {
                Image(systemName: "xmark")
            })
            }.onAppear{
                self.state.dispatch(action: MoviesActions.FetchMovieReviews(movie: self.movie.id))
        }
    }
}
