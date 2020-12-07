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
import UI

struct MovieDetail: ConnectedView {
    struct Props {
        let movie: Movie
        let characters: [People]?
        let credits: [People]?
        let recommended: [Movie]?
        let similar: [Movie]?
        let reviewsCount: Int?
        let videos: [Video]?
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
        
        if let peopleIds = state.peoplesState.peoplesMovies[movieId]?.sorted() {
            let peoples = peopleIds.compactMap{ state.peoplesState.peoples[$0] }
            characters = peoples.filter{ $0.character != nil}
            credits = peoples.filter{ $0.department != nil }
            if let recommendedIds = state.moviesState.recommended[movieId] {
                recommended = recommendedIds.compactMap{ state.moviesState.movies[$0] }
            }
            if let simillarIds = state.moviesState.similar[movieId] {
                similar = simillarIds.compactMap{ state.moviesState.movies[$0] }
            }
        }
        return Props(movie: state.moviesState.movies[movieId]!,
                     characters: characters,
                     credits: credits,
                     recommended: recommended,
                     similar: similar,
                     reviewsCount: state.moviesState.reviews[movieId]?.count ?? nil,
                     videos: state.moviesState.videos[movieId])
    }
    
    // MARK: - Fetch
    func fetchMovieDetails() {
        store.dispatch(action: MoviesActions.FetchDetail(movie: movieId))
        store.dispatch(action: PeopleActions.FetchMovieCasts(movie: movieId))
        store.dispatch(action: MoviesActions.FetchRecommended(movie: movieId))
        store.dispatch(action: MoviesActions.FetchSimilar(movie: movieId))
        store.dispatch(action: MoviesActions.FetchMovieReviews(movie: movieId))
        store.dispatch(action: MoviesActions.FetchVideos(movie: movieId))
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
    
    func peopleRow(role: String, people: People?) -> some View {
        Group {
            if people != nil {
                NavigationLink(destination: PeopleDetail(peopleId: people!.id)) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(role + ": ").font(.callout)
                        Text(people!.name).font(.body).foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    func peopleRows(props: Props) -> some View {
        Group {
            peopleRow(role: "Director", people: props.credits?.filter{ $0.department == "Directing" }.first)
        }
    }

    func topSection(props: Props) -> some View {
        Section {
            MovieCoverRow(movieId: movieId)
            MovieButtonsRow(movieId: movieId, showCustomListSheet: $isAddSheetPresented)
            if props.reviewsCount ?? 0 > 0 {
                NavigationLink(destination: MovieReviews(movie: self.movieId)) {
                    Text("\(props.reviewsCount!) reviews")
                        .foregroundColor(.steam_blue)
                        .lineLimit(1)
                }
            }
            if !props.movie.overview.isEmpty {
                MovieOverview(movie: props.movie)
            }
        }
    }
    
    func bottomSection(props: Props) -> some View {
        Section {
            if props.movie.keywords?.keywords?.isEmpty == false {
                MovieKeywords(keywords: props.movie.keywords!.keywords!)
            }
            if props.characters?.isEmpty == false {
                MovieCrosslinePeopleRow(title: "Cast",
                                        peoples: props.characters ?? [])
            }
            if props.credits?.isEmpty == false {
                peopleRows(props: props)
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
                MoviePostersRow(posters: props.movie.images!.posters!.prefix(8).map{ $0 },
                                selectedPoster: $selectedPoster)
            }
            if props.movie.images?.backdrops?.isEmpty == false {
                MovieBackdropsRow(backdrops: props.movie.images!.backdrops!.prefix(8).map{ $0 })
            }
        }
    }
    
    func body(props: Props) -> some View {
        ZStack(alignment: .bottom) {
            List {
                topSection(props: props)
                bottomSection(props: props)
            }
            .navigationBarTitle(Text(props.movie.userTitle), displayMode: .large)
            .navigationBarItems(trailing: Button(action: onAddButton) {
                Image(systemName: "text.badge.plus").imageScale(.large)
            })
            .onAppear {
                self.fetchMovieDetails()
            }
            .actionSheet(isPresented: $isAddSheetPresented, content: { addActionSheet(props: props) })
            .sheet(isPresented: $isCreateListFormPresented,
                   content: { CustomListForm(editingListId: nil)
                    .environmentObject(store) })
            .disabled(selectedPoster != nil)
            .blur(radius: selectedPoster != nil ? 30 : 0)
            .scaleEffect(selectedPoster != nil ? 0.8 : 1)
            
            NotificationBadge(text: "Added successfully",
                              color: .blue,
                              show: $isAddedToListBadgePresented).padding(.bottom, 10)
            ImagesCarouselView(posters: props.movie.images?.posters ?? [],
                                   selectedPoster: $selectedPoster)
                .blur(radius: selectedPoster != nil ? 0 : 10)
                .scaleEffect(selectedPoster != nil ? 1 : 1.2)
                .opacity(selectedPoster != nil ? 1 : 0)
        }
    }
    
    
}

// MARK: - Preview
#if DEBUG
struct MovieDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetail(movieId: sampleMovie.id).environmentObject(sampleStore)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
#endif

