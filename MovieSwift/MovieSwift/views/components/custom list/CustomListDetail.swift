//
//  CustomListDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

final class CustomListSearchMovieTextWrapper: SearchTextObservable {
    override func onUpdateTextDebounced(text: String) {
        store.dispatch(action: MoviesActions.FetchSearch(query: text, page: 1))
    }
}

struct CustomListDetail : View {
    @EnvironmentObject private var store: Store<AppState>
    @State private var searchTextWrapper = CustomListSearchMovieTextWrapper()
    @State private var isSearching = false
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
        
    private var searchedMovies: [Int]? {
        store.state.moviesState.search[searchTextWrapper.searchText]
    }
    
    private var navbarButton: some View {
        Group {
            if isSearching {
                Button(action: {
                    self.searchTextWrapper.searchText = ""
                    self.isSearching = false
                    if !self.selectedMovies.isEmpty {
                        self.store.dispatch(action: MoviesActions.AddMoviesToCustomList(list: self.listId,
                                                                                        movies: self.selectedMovies.map{ $0 }))
                        self.selectedMovies = Set<Int>()
                    }
                }) {
                    Text(selectedMovies.isEmpty ? "Cancel" : "Add movies (\(selectedMovies.count))")
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
        List {
            if !isSearching {
                CustomListHeaderRow(sorting: $selectedMoviesSort,  listId: listId)
            }
            SearchField(searchTextWrapper: searchTextWrapper,
                        placeholder: "Search movies to add to your list",
                        isSearching: $isSearching)
                .listRowInsets(EdgeInsets())
                .padding(4)
                .onTapGesture {
                    self.searchTextWrapper.searchText = ""
            }
            Group {
                if isSearching {
                    if searchedMovies?.isEmpty == true {
                        Text("No results")
                    } else if searchedMovies == nil {
                        Text("Searching...")
                    } else {
                        ForEach(searchedMovies!, id: \.self) { movie in
                            ZStack(alignment: .center) {
                                MovieRow(movieId: movie, displayListImage: false)
                                Rectangle().foregroundColor(self.selectedMovies.contains(movie) ?
                                    Color.gray.opacity(0.2) : .clear)
                            }
                            .onTapGesture {
                                if self.selectedMovies.contains(movie) {
                                    self.selectedMovies.remove(movie)
                                } else {
                                    self.selectedMovies.insert(movie)
                                }
                            }
                        }
                    }
                } else {
                    ForEach(movies, id: \.self) { movie in
                        NavigationLink(destination: MovieDetail(movieId: movie)) {
                            MovieRow(movieId: movie, displayListImage: false)
                        }
                    }.onDelete { (index) in
                        self.store.dispatch(action: MoviesActions.RemoveMovieFromCustomList(list: self.listId, movie: self.movies[index.first!]))
                    }
                }
            }
            
        }
            .navigationBarTitle(Text(""),
                                displayMode: isSearching ? .inline : .automatic)
            .navigationBarItems(trailing: navbarButton)
            .edgesIgnoringSafeArea(isSearching ? .leading : .top)
            .actionSheet(isPresented: $isSortActionSheetPresented, content: { sortActionSheet })
            .sheet(isPresented: $isEditingFormPresented,
                   content: { CustomListForm(editingListId: self.listId).environmentObject(self.store)
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
