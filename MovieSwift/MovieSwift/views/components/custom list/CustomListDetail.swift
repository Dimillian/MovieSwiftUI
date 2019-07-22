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
    }
}

struct CustomListDetail : View {
    @EnvironmentObject private var store: Store<AppState>
    @State private var searchTextWrapper = CustomListSearchMovieTextWrapper()
    @State private var selectedMovies = Set<Int>()
    @State private var isEditingFormPresented = false
    @State private var selectedMoviesSort = MoviesSort.byReleaseDate
    @State private var isSortActionSheetPresented = false
    
    let listId: Int
    
    private var list: CustomList {
        store.state.moviesState.customLists[listId]!
    }
    
    private var movies: [Int] {
        list.movies.sortedMoviesIds(by: selectedMoviesSort, state: store.state)
    }
    
    private var isSearching: Bool {
        !searchTextWrapper.searchText.isEmpty
    }
    
    private var searchedMovies: [Int]? {
        return store.state.moviesState.search[searchTextWrapper.searchText]
    }
    
    private var navbarButton: some View {
        Group {
            if isSearching {
                Button(action: {
                    self.searchTextWrapper.searchText = ""
                    self.store.dispatch(action: MoviesActions.AddMoviesToCustomList(list: self.listId,
                                                                                    movies: self.selectedMovies.map{ $0 }))
                    self.selectedMovies = Set<Int>()
                }) {
                    Text("Add movies (\(selectedMovies.count))")
                }
            } else {
                HStack(spacing: 16) {
                    Button(action: {
                        self.isEditingFormPresented = true
                    }) {
                        Image(systemName: "pencil.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.steam_gold)
                    }
                    Button(action: {
                        self.isSortActionSheetPresented.toggle()
                    }, label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.steam_gold)
                    })
                }
            }
        }
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet.sortActionSheet { (sort) in
            if let sort = sort{
                self.selectedMoviesSort = sort
            }
        }
    }
    
    var body: some View {
        List(selection: $selectedMovies) {
            if !isSearching {
                CustomListHeaderRow(sorting: $selectedMoviesSort,  listId: listId)
            }
            SearchField(searchTextWrapper: searchTextWrapper,
                        placeholder: "Search movies to add to your list")
                .listRowInsets(EdgeInsets())
                .padding(4)
                .tapAction {
                    self.searchTextWrapper.searchText = ""
            }
            if isSearching {
                if searchedMovies?.isEmpty == true {
                    Text("No result")
                } else if searchedMovies == nil {
                    Text("Loading")
                } else {
                    ForEach(searchedMovies!) { movie in
                        MovieRow(movieId: movie, displayListImage: false)
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
        .environment(\.editMode, .constant(searchedMovies != nil && searchedMovies?.isEmpty == false ? .active : .inactive))
            .navigationBarTitle(Text(""),
                                displayMode: isSearching ? .inline : .automatic)
            .navigationBarItems(trailing: navbarButton)
            .edgesIgnoringSafeArea(isSearching ? .leading : .top)
            .actionSheet(isPresented: $isSortActionSheetPresented, content: { sortActionSheet })
            .sheet(isPresented: $isEditingFormPresented,
                   onDismiss: { self.isEditingFormPresented = false },
                   content: { CustomListForm(editingListId: self.listId,
                                             shouldDismiss: {
                                                self.isEditingFormPresented = false
                   }).environmentObject(self.store)
            })
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
