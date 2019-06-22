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
    
    var recommanded: [Movie]? {
        get {
            guard let ids = store.state.moviesState.recommanded[movie.id] else {
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
        store.dispatch(action: MoviesActions.FetchRecommanded(movie: movie.id))
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
    
    // MARK: - Posters Carousel
    
    func computeCarouselPosterScale(width: Length, itemX: Length) -> Length {
        let trueX = itemX - (width/2 - 250/3)
        if trueX == 0 {
            return 1
        }
        if trueX < -5 {
            return 1 - (abs(trueX) / width)
        }
        if trueX > 5 {
            return 1 - (trueX / width)
        }
        return 1
    }

    
    var carouselView: some View {
        GeometryReader { reader in
            ZStack(alignment: .center) {
                ScrollView(showsHorizontalIndicator: false) {
                    HStack(spacing: 200) {
                        ForEach(self.movie.posters!) { poster in
                            GeometryReader { reader2 in
                                BigMoviePosterImage(imageLoader: ImageLoader(poster: poster.file_path,
                                                                             size: .medium))
                                    .scaleEffect(self.computeCarouselPosterScale(width: reader.frame(in: .global).width,
                                                                                 itemX: reader2.frame(in: .global).midX),
                                                 anchor: .center)
                                    .tapAction {
                                        self.selectedPoster = nil
                                }
                            }
                        }
                    }
                }
                    .position(x: reader.frame(in: .global).midX,
                              y: reader.frame(in: .global).midY)
                    .tapAction {
                        self.selectedPoster = nil
                }
            }
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                MovieBackdrop(movieId: movie.id)
                MovieRating(movie: movie)
                MovieAddToList(addedToWishlist: false,
                               addedToSeenlist: false,
                               movieId: movie.id)
                MovieOverview(movie: movie)
                Group {
                    if movie.keywords != nil && movie.keywords?.isEmpty == false {
                        MovieKeywords(keywords: movie.keywords!).frame(height: 90)
                    }
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
                    if movie.posters != nil {
                        MoviePostersRow(posters: movie.posters!,
                                        selectedPoster: $selectedPoster)
                            .frame(height: 220)
                    }
                    if movie.backdrops != nil {
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
            if selectedPoster != nil {
               carouselView
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

