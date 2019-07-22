//
//  MovieDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Combine

struct MovieDetail : View {
    @EnvironmentObject var store: Store<AppState>
    @State var addSheetShown = false
    @State var showCreateListForm = false
    @State var showSavedBadge = false
    @State var selectedPoster: ImageData?
    
    let movieId: Int
    
    //MARK: - App State computed properties
    
    var movie: Movie! {
        return store.state.moviesState.movies[movieId]!
    }
    
    var characters: [People]? {
        get {
            guard let ids = store.state.peoplesState.peoplesMovies[movie.id] else {
                return nil
            }
            let cast = store.state.peoplesState.peoples.filter{ $0.value.character != nil }
            return ids.filter{ cast[$0] != nil }.map{ cast[$0]! }
        }
    }
    
    var credits: [People]? {
        get {
            guard let ids = store.state.peoplesState.peoplesMovies[movie.id] else {
                return nil
            }
            let cast = store.state.peoplesState.peoples.filter{ $0.value.department != nil }
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
        store.dispatch(action: PeopleActions.FetchMovieCasts(movie: movie.id))
        store.dispatch(action: MoviesActions.FetchRecommended(movie: movie.id))
        store.dispatch(action: MoviesActions.FetchSimilar(movie: movie.id))
    }
    
    var addActionSheet: ActionSheet {
        get {
            var buttons: [Alert.Button] = []
            let wishlistButton = ActionSheet.wishlistButton(store: store, movie: movieId) {
                self.displaySavedBadge()
            }
            let seenButton = ActionSheet.seenListButton(store: store, movie: movieId) {
                self.displaySavedBadge()
            }
            let customListButtons = ActionSheet.customListsButttons(store: store, movie: movieId) {
                self.displaySavedBadge()
            }
            let createListButton: Alert.Button = .default(Text("Create list")) {
                self.showCreateListForm = true
            }
            let cancelButton = Alert.Button.cancel {
 
            }
            buttons.append(wishlistButton)
            buttons.append(seenButton)
            buttons.append(contentsOf: customListButtons)
            buttons.append(createListButton)
            buttons.append(cancelButton)
            let sheet = ActionSheet(title: Text("Add or remove \(movie.userTitle) from your lists"),
                                    message: nil,
                                    buttons: buttons)
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
                MovieAddToListRow(movieId: movie.id).tapAction {
                    self.addSheetShown = true
                }
                MovieOverview(movie: movie)
                Group {
                    if movie.keywords?.keywords != nil && movie.keywords?.keywords?.isEmpty == false {
                        MovieKeywords(keywords: movie.keywords!.keywords!)
                    }
                    if characters != nil && characters?.isEmpty == false {
                        MovieCrosslinePeopleRow(title: "Characters",
                                 peoples: characters ?? [])
                    }
                    if credits != nil && credits?.isEmpty == false {
                        MovieCrosslinePeopleRow(title: "Crew",
                                 peoples: credits ?? [])
                    }
                    if similar != nil && similar?.isEmpty == false {
                        MovieCrosslineRow(title: "Similar Movies", movies: similar ?? [])
                    }
                    if recommended != nil && recommended?.isEmpty == false {
                        MovieCrosslineRow(title: "Recommended Movies", movies: recommended ?? [])
                    }
                    if movie.images?.posters != nil && movie.images?.posters?.isEmpty == false {
                        MoviePostersRow(posters: movie.images!.posters!,
                                        selectedPoster: $selectedPoster)
                    }
                    if movie.images?.backdrops != nil && movie.images?.backdrops?.isEmpty == false {
                        MovieBackdropsRow(backdrops: movie.images!.backdrops!)
                    }
                }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarItems(trailing: Button(action: onAddButton) {
                    Image(systemName: "text.badge.plus").imageScale(.large)
                })
                .onAppear {
                    self.fetchMovieDetails()
                }
                .actionSheet(isPresented: $addSheetShown, content: { addActionSheet })
                .sheet(isPresented: $showCreateListForm,
                       onDismiss: { self.showCreateListForm = false},
                       content: { CustomListForm(editingListId: nil,
                                                             shouldDismiss: {
                                            self.showCreateListForm = false
                       }).environmentObject(self.store) })
                .disabled(selectedPoster != nil)
                .animation(nil)
                .blur(radius: selectedPoster != nil ? 30 : 0)
                .animation(.easeInOut)
            
            NotificationBadge(text: "Added successfully",
                              color: .blue,
                              show: $showSavedBadge).padding(.bottom, 10)
            if selectedPoster != nil && movie.images?.posters != nil {
                ImagesCarouselView(posters: movie.images!.posters!, selectedPoster: $selectedPoster)
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

