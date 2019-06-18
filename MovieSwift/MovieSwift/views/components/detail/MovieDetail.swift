//
//  MovieDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieDetail : View {
    @EnvironmentObject var state: AppState
    @State var addSheetShown = false
    @State var showSavedBadge = false
    
    let movieId: Int
    
    //MARK: - App State computed properties
    
    var movie: Movie! {
        return state.moviesState.movies[movieId]!
    }
    
    var characters: [Cast]? {
        get {
            guard let ids = state.castsState.castsMovie[movie.id] else {
                return nil
            }
            let cast = state.castsState.casts.filter{ $0.value.character != nil }
            return ids.filter{ cast[$0] != nil }.map{ cast[$0]! }
        }
    }
    
    var credits: [Cast]? {
        get {
            guard let ids = state.castsState.castsMovie[movie.id] else {
                return nil
            }
            let cast = state.castsState.casts.filter{ $0.value.department != nil }
            return ids.filter{ cast[$0] != nil }.map{ cast[$0]! }
        }
    }
    
    var recommanded: [Movie]? {
        get {
            guard let ids = state.moviesState.recommanded[movie.id] else {
                return nil
            }
            let movies = state.moviesState.movies
            return ids.filter{ movies[$0] != nil }.map{ movies[$0]! }
        }
    }
    
    var similar: [Movie]? {
        get {
            guard let ids = state.moviesState.similar[movie.id] else {
                return nil
            }
            let movies = state.moviesState.movies
            return ids.filter{ movies[$0] != nil }.map{ movies[$0]! }
        }
    }
    
    var addActionSheet: ActionSheet {
        get {
            let wishlistButton: Alert.Button = .default(Text("Add to wihlist")) {
                self.addSheetShown = false
                self.displaySavedBadge()
                store.dispatch(action: MoviesActions.addToWishlist(movie: self.movieId))
            }
            let seenButton: Alert.Button = .default(Text("Add to seen list")) {
                self.addSheetShown = false
                self.displaySavedBadge()
                store.dispatch(action: MoviesActions.addToSeenlist(movie: self.movieId))
            }
            let sheet = ActionSheet(title: Text("Add to"),
                                    message: nil,
                                    buttons: [wishlistButton, seenButton, .cancel({
                                        self.addSheetShown = false
                                    })])
            return sheet
        }
    }
    
    func displaySavedBadge() {
        showSavedBadge = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showSavedBadge = false
        }
    }

    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                MovieBackdrop(movieId: movie.id)
                MovieRating(movie: movie)
                MovieAddToList()
                MovieOverview(movie: movie)
                if characters != nil && characters?.isEmpty == false {
                    CastsRow(title: "Characters",
                             casts: characters ?? []).frame(height: 200)
                }
                if credits != nil && credits?.isEmpty == false {
                    CastsRow(title: "Crew",
                             casts: credits ?? []).frame(height: 200)
                }
                if similar != nil && similar?.isEmpty == false {
                    MovieDetailRow(title: "Similar Movies", movies: similar ?? []).frame(height: 260)
                }
                if recommanded != nil && recommanded?.isEmpty == false {
                    MovieDetailRow(title: "Recommanded Movies", movies: recommanded ?? []).frame(height: 260)
                }
                if movie.keywords != nil && movie.keywords?.isEmpty == false {
                    MovieKeywords(keywords: movie.keywords!).frame(height: 90)
                }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarItems(trailing: Button(action: onAddButton) {
                    Image(systemName: "text.badge.plus")
                })
                .onAppear {
                    store.dispatch(action: MoviesActions.FetchDetail(movie: self.movie.id))
                    store.dispatch(action: CastsActions.FetchMovieCasts(movie: self.movie.id))
                    store.dispatch(action: MoviesActions.FetchRecommanded(movie: self.movie.id))
                    store.dispatch(action: MoviesActions.FetchSimilar(movie: self.movie.id))
                    store.dispatch(action: MoviesActions.FetchMovieKeywords(movie: self.movie.id))
                }.presentation(self.addSheetShown ? addActionSheet : nil)
            NotificationBadge(text: "Added successfully", color: .blue, show: $showSavedBadge)
                .padding(.bottom, 10)
        }
    }
    
    func onAddButton() {
        addSheetShown.toggle()
    }
    
}

#if DEBUG
struct MovieDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetail(movieId: sampleMovie.id).environmentObject(sampleStore)
        }
    }
}
#endif

