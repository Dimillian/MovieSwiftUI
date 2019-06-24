//
//  MovieDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieDetail : View {
    @EnvironmentObject var store: AppStore
    @State var addSheetShown = false
    @State var showSavedBadge = false
    @State var selectedPoster: MovieImage?
    
    let movieId: Int
    
    //MARK: - App State computed properties
    
    var movie: Movie! {
        return store.state.moviesState.movies[movieId]!
    }
    
    var characters: [Cast]? {
        get {
            guard let ids = store.state.castsState.castsMovie[movie.id] else {
                return nil
            }
            let cast = store.state.castsState.casts.filter{ $0.value.character != nil }
            return ids.filter{ cast[$0] != nil }.map{ cast[$0]! }
        }
    }
    
    var credits: [Cast]? {
        get {
            guard let ids = store.state.castsState.castsMovie[movie.id] else {
                return nil
            }
            let cast = store.state.castsState.casts.filter{ $0.value.department != nil }
            return ids.filter{ cast[$0] != nil }.map{ cast[$0]! }
        }
    }
    
    var recommended: [Movie]? {
        get {
            guard let ids = store.state.moviesState.recommended[movie.id] else {
                return nil
            }
            let movies = store.state.moviesState.movies
            return ids.filter{ movies[$0] != nil }.map{ movies[$0]! }
        }
    }
    
    var similar: [Movie]? {
        get {
            guard let ids = store.state.moviesState.similar[movie.id] else {
                return nil
            }
            let movies = store.state.moviesState.movies
            return ids.filter{ movies[$0] != nil }.map{ movies[$0]! }
        }
    }
    
    // MARK: - Actions
    func fetchMovieDetails() {
        store.dispatch(action: MoviesActions.FetchDetail(movie: movie.id))
        store.dispatch(action: CastsActions.FetchMovieCasts(movie: movie.id))
        store.dispatch(action: MoviesActions.FetchRecommended(movie: movie.id))
        store.dispatch(action: MoviesActions.FetchSimilar(movie: movie.id))
        store.dispatch(action: MoviesActions.FetchMovieKeywords(movie: movie.id))
        store.dispatch(action: MoviesActions.FetchMovieImages(movie: movie.id))
    }
    
    var addActionSheet: ActionSheet {
        get {
            let wishlistButton: Alert.Button = .default(Text("Add to wishlist")) {
                self.addSheetShown = false
                self.displaySavedBadge()
                self.store.dispatch(action: MoviesActions.addToWishlist(movie: self.movieId))
            }
            let seenButton: Alert.Button = .default(Text("Add to seenlist")) {
                self.addSheetShown = false
                self.displaySavedBadge()
                self.store.dispatch(action: MoviesActions.addToSeenlist(movie: self.movieId))
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showSavedBadge = false
        }
    }
    
    //MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                MovieBackdrop(movieId: movie.id)
                MovieRatingRow(movie: movie)
                MovieAddToListRow(addedToWishlist: false,
                               addedToSeenlist: false,
                               movieId: movie.id)
                MovieOverview(movie: movie)
                Group {
                    if movie.keywords != nil && movie.keywords?.isEmpty == false {
                        MovieKeywords(keywords: movie.keywords!).frame(height: 90)
                    }
                    if characters != nil && characters?.isEmpty == false {
                        MovieCrosslinePeopleRow(title: "Characters",
                                 casts: characters ?? []).frame(height: 200)
                    }
                    if credits != nil && credits?.isEmpty == false {
                        MovieCrosslinePeopleRow(title: "Crew",
                                 casts: credits ?? []).frame(height: 200)
                    }
                    if similar != nil && similar?.isEmpty == false {
                        MovieCrosslineRow(title: "Similar Movies", movies: similar ?? []).frame(height: 260)
                    }
                    if recommended != nil && recommended?.isEmpty == false {
                        MovieCrosslineRow(title: "Recommended Movies", movies: recommended ?? []).frame(height: 260)
                    }
                    if movie.posters != nil && movie.posters?.isEmpty == false {
                        MoviePostersRow(posters: movie.posters!,
                                        selectedPoster: $selectedPoster)
                            .frame(height: 220)
                    }
                    if movie.backdrops != nil && movie.backdrops?.isEmpty == false {
                        MovieBackdropsRow(backdrops: movie.backdrops!,
                                          selectedBackdrop: $selectedPoster)
                            .frame(height: 300)
                    }
                }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarItems(trailing: Button(action: onAddButton) {
                    Image(systemName: "text.badge.plus")
                })
                .onAppear {
                    self.fetchMovieDetails()
                }
                .presentation(self.addSheetShown ? addActionSheet : nil)
                .blur(radius: selectedPoster != nil ? 50 : 0)
            
            NotificationBadge(text: "Added successfully", color: .blue, show: $showSavedBadge)
                .padding(.bottom, 10)
            if selectedPoster != nil && movie.posters != nil {
                MoviePostersCarouselView(posters: movie.posters!, selectedPoster: $selectedPoster)
            }
        }
    }
    
    func onAddButton() {
        addSheetShown.toggle()
    }
    
}

// MARK: - Preview
#if DEBUG
struct MovieDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetail(movieId: sampleMovie.id).environmentObject(sampleStore)
        }
    }
}
#endif

