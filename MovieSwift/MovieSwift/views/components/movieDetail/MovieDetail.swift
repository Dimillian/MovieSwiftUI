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

struct MovieDetail: ConnectedView {
    struct Props {
        let movie: Movie
        let characters: [People]?
        let credits: [People]?
        let recommended: [Movie]?
        let similar: [Movie]?
    }
    
    let movieId: Int
    
    // MARK: View States
    @State var isAddSheetPresented = false
    @State var isCreateListFormPresented = false
    @State var isAddedToListBadgePresented = false
    @State var selectedPoster: ImageData?
        
    // MARK: Computed Props
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        var characters: [People]?
        var credits: [People]?
        var recommended: [Movie]?
        var similar: [Movie]?
        
        if let peopleIds = state.peoplesState.peoplesMovies[movieId] {
            let cast = state.peoplesState.peoples.filter{ $0.value.character != nil }
            characters = peopleIds.filter{ cast[$0] != nil }.map{ cast[$0]! }
            
            let departements = state.peoplesState.peoples.filter{ $0.value.department != nil }
            credits = peopleIds.filter{ departements[$0] != nil }.map{ departements[$0]! }
            
            let movies = state.moviesState.movies
            if let recommendedIds = state.moviesState.recommended[movieId] {
                recommended = recommendedIds.filter{ movies[$0] != nil }.map{ movies[$0]! }
            }
            if let simillarIds = state.moviesState.similar[movieId] {
                similar = simillarIds.filter{ movies[$0] != nil }.map{ movies[$0]! }
            }
        }
        return Props(movie: state.moviesState.movies[movieId]!,
                     characters: characters,
                     credits: credits,
                     recommended: recommended,
                     similar: similar)
    }
    
    // MARK: - Fetch
    func fetchMovieDetails() {
        store.dispatch(action: MoviesActions.FetchDetail(movie: movieId))
        store.dispatch(action: PeopleActions.FetchMovieCasts(movie: movieId))
        store.dispatch(action: MoviesActions.FetchRecommended(movie: movieId))
        store.dispatch(action: MoviesActions.FetchSimilar(movie: movieId))
    }
    
    // MARK: - View actions
    func displaySavedBadge() {
        isAddedToListBadgePresented = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isAddedToListBadgePresented = false
        }
    }
    
    func onAddButton() {
        isAddSheetPresented.toggle()
    }
    
    // MARK: - Computed views
    func addActionSheet(props: Props) -> ActionSheet {
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
            self.isCreateListFormPresented = true
        }
        let cancelButton = Alert.Button.cancel {
            
        }
        buttons.append(wishlistButton)
        buttons.append(seenButton)
        buttons.append(contentsOf: customListButtons)
        buttons.append(createListButton)
        buttons.append(cancelButton)
        let sheet = ActionSheet(title: Text("Add or remove \(props.movie.userTitle) from your lists"),
                                message: nil,
                                buttons: buttons)
        return sheet
    }
    
    // MARK: - Body
    func body(props: Props) -> some View {
        ZStack(alignment: .bottom) {
            List {
                MovieBackdrop(movieId: movieId)
                MovieRatingRow(movie: props.movie)
                MovieAddToListRow(movieId: movieId).tapAction {
                    self.isAddSheetPresented = true
                }
                MovieOverview(movie: props.movie)
                Group {
                    if props.movie.keywords?.keywords?.isEmpty == false {
                        MovieKeywords(keywords: props.movie.keywords!.keywords!)
                    }
                    if props.characters?.isEmpty == false {
                        MovieCrosslinePeopleRow(title: "Characters",
                                                peoples: props.characters ?? [])
                    }
                    if props.credits?.isEmpty == false {
                        MovieCrosslinePeopleRow(title: "Crew",
                                                peoples: props.credits ?? [])
                    }
                    if props.similar?.isEmpty == false {
                        MovieCrosslineRow(title: "Similar Movies", movies: props.similar ?? [])
                    }
                    if  props.recommended?.isEmpty == false {
                        MovieCrosslineRow(title: "Recommended Movies", movies: props.recommended ?? [])
                    }
                    if props.movie.images?.posters?.isEmpty == false {
                        MoviePostersRow(posters: props.movie.images!.posters!,
                                        selectedPoster: $selectedPoster)
                    }
                    if props.movie.images?.backdrops?.isEmpty == false {
                        MovieBackdropsRow(backdrops: props.movie.images!.backdrops!)
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
            .actionSheet(isPresented: $isAddSheetPresented, content: { addActionSheet(props: props) })
                .sheet(isPresented: $isCreateListFormPresented,
                       onDismiss: { self.isCreateListFormPresented = false},
                       content: { CustomListForm(editingListId: nil,
                                                 shouldDismiss: {
                                                    self.isCreateListFormPresented = false
                       }).environmentObject(store) })
                .disabled(selectedPoster != nil)
                .animation(nil)
                .blur(radius: selectedPoster != nil ? 30 : 0)
                .animation(.easeInOut)
            
            NotificationBadge(text: "Added successfully",
                              color: .blue,
                              show: $isAddedToListBadgePresented).padding(.bottom, 10)
            if selectedPoster != nil && props.movie.images?.posters != nil {
                ImagesCarouselView(posters: props.movie.images!.posters!, selectedPoster: $selectedPoster)
            }
        }
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

