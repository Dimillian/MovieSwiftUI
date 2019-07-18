//
//  MovieReviews.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MovieReviews : View {
    @EnvironmentObject var store: Store<AppState>
    @Binding var isPresented: Bool
    
    let movie: Int
    
    var reviews: [Review] {
        return store.state.moviesState.reviews[movie] ?? []
    }
    
    func onCloseButton() {
        isPresented = false
    }
    
    var body: some View {
        NavigationView {
            List(reviews) {review in
                ReviewRow(review: review)
            }
            .navigationBarTitle(Text("Reviews"))
            .navigationBarItems(trailing: Button(action: onCloseButton) {
                Image(systemName: "xmark").imageScale(.large)
            })
            }
        .navigationViewStyle(.stack)
        .onAppear{
                self.store.dispatch(action: MoviesActions.FetchMovieReviews(movie: self.movie.id))
            }
    }
}
