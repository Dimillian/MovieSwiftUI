//
//  CustomListDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

final class CustomListSearchMovieTextWrapper: SearchTextWrapper {
    override func onUpdateTextDebounced(text: String) {
        store.dispatch(action: MoviesActions.FetchSearch(query: text, page: 1))
        store.dispatch(action: PeopleActions.FetchSearch(query: text, page: 1))
    }
}

struct CustomListDetail : View {
    @EnvironmentObject var store: Store<AppState>
    @State private var searchTextWrapper = CustomListSearchMovieTextWrapper()
    @State var selectedMovies = Set<Int>()
    
    let listId: Int
        
    private var list: CustomList {
        store.state.moviesState.customLists[listId]!
    }
    
    private var movies: [Int] {
        list.movies.sortedMoviesIds(by: .byReleaseDate, state: store.state)
    }
    
    private var isSearching: Bool {
        return !searchTextWrapper.searchText.isEmpty
    }
    
    private var searchedMovies: [Int] {
        return store.state.moviesState.search[searchTextWrapper.searchText] ?? []
    }
    
    var body: some View {
        List {
            CustomListHeaderRow(listId: listId)
            SearchField(searchTextWrapper: searchTextWrapper,
                        placeholder: "Search movies to add to your list",
                        dismissButtonTitle: "Done",
                        dismissButtonCallback: {
                            self.store.dispatch(action: MoviesActions.AddMoviesToCustomList(list: self.listId,
                                                                                       movies: self.selectedMovies.map{ $0 }))
                            self.selectedMovies = Set<Int>()
            })
            if isSearching {
                ForEach(searchedMovies) { movie in
                    MovieRow(movieId: movie,
                             displayListImage: false,
                             isSelected: self.selectedMovies.contains(movie))
                        .tapAction {
                        if self.selectedMovies.contains(movie) {
                            self.selectedMovies.remove(movie)
                        } else {
                            self.selectedMovies.insert(movie)
                        }
                    }
                }
            } else {
                ForEach(movies) { movie in
                    NavigationLink(destination: MovieDetail(movieId: movie).environmentObject(self.store)) {
                        MovieRow(movieId: movie, displayListImage: false)
                    }
                }.onDelete { (index) in
                    self.store.dispatch(action: MoviesActions.RemoveMovieFromCustomList(list: self.listId, movie: self.movies[index.first!]))
                }
            }
        }
        .navigationBarItems(trailing: (
            PresentationLink(destination: CustomListForm(editingListId: listId,
                                                         shouldDismiss: nil).environmentObject(store),
                             label: {
                                Text("Edit").color(.steam_gold)
            })
        ))
        .edgesIgnoringSafeArea(.top)
    }
}

#if DEBUG
struct CustomListDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomListDetail(listId: sampleStore.state.moviesState.customLists.first!.key)
                .environmentObject(sampleStore)
        }
    }
}
#endif
