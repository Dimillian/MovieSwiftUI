//
//  MoviesList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Combine

// MARK: - Movies List
struct MoviesList : View {
    
    enum SearchFilter: Int {
        case movies, peoples
    }
    
    // MARK: - State and binding
    @EnvironmentObject private var store: Store<AppState>
    @State private var searchFilter: Int = SearchFilter.movies.rawValue
    @State private var searchTextWrapper = MoviesSearchTextWrapper()
    
    // MARK: - Public var
    let movies: [Int]
    let displaySearch: Bool
    var pageListener: MoviesPagesListener?
    var deleteHandler: ((Int) -> Void)? = nil
    var headerView: AnyView?
    
    // MARK: - Computed properties
    private var isSearching: Bool {
        return !searchTextWrapper.searchText.isEmpty
    }
    
    private var searchedMovies: [Int]? {
        return store.state.moviesState.search[searchTextWrapper.searchText]
    }
    
    private var searchPeoples: [Int]? {
        return store.state.peoplesState.search[searchTextWrapper.searchText]
    }
    
    private var keywords: [Keyword]? {
        return store.state.moviesState.searchKeywords[searchTextWrapper.searchText]?.prefix(5).map{ $0 }
    }
    
    // Mark: - Computed views
    
    private var moviesRows: some View {
        ForEach(isSearching ? searchedMovies! : movies) { id in
            NavigationLink(destination: MovieDetail(movieId: id).environmentObject(self.store)) {
                MovieRow(movieId: id)
            }
        }
    }
    
    private var movieSection: some View {
        Group {
            if isSearching {
                Section(header: Text("Results for \(searchTextWrapper.searchText)")) {
                    if isSearching && searchedMovies == nil {
                        Text("Searching movies...")
                    } else if isSearching && searchedMovies?.isEmpty == true {
                        Text("No results")
                    } else {
                        moviesRows
                    }
                }
            } else {
                Section {
                    moviesRows
                }
            }
        }
    }
    
    private var peoplesSection: some View {
        Section {
            if isSearching && searchPeoples == nil {
                Text("Searching peoples...")
            } else if isSearching && searchPeoples?.isEmpty == true {
                Text("No results")
            } else {
                ForEach(searchPeoples!) { id in
                    NavigationLink(destination: PeopleDetail(peopleId: id).environmentObject(self.store)) {
                        PeopleRow(peopleId: id)
                    }
                }
            }
        }
    }
    
    private var keywordsSection: some View {
        Section(header: Text("Keywords")) {
            ForEach(keywords!) {keyword in
                NavigationLink(destination: MovieKeywordList(keyword: keyword).environmentObject(self.store)) {
                    Text(keyword.name)
                }
            }
        }
    }
    
    private var searchField: some View {
        SearchField(searchTextWrapper: searchTextWrapper,
                    placeholder: "Search any movies or person")
    }
    
    private var searchFilterView: some View {
        SegmentedControl(selection: $searchFilter) {
            Text("Movies").tag(SearchFilter.movies.rawValue)
            Text("People").tag(SearchFilter.peoples.rawValue)
        }
    }
    
    // MARK: - Views
    var body: some View {
        List {
            if displaySearch {
                Section {
                    searchField
                }
            }
            
            if headerView != nil && !isSearching {
                Section {
                    headerView!
                }
            }
            
            if isSearching {
                searchFilterView
                if keywords != nil && searchFilter == SearchFilter.movies.rawValue {
                    keywordsSection
                }
            }
            
            if isSearching && searchFilter == SearchFilter.peoples.rawValue {
                peoplesSection
            } else {
                movieSection
            }
            
            /// The pagination is done by appending a invisible rectancle at the bottom of the list, and trigerining the next page load as it appear.
            /// Hacky way for now, hope it'll be possible to find a better solution in a future version of SwiftUI.
            /// Could be possible to do with GeometryReader.
            if !movies.isEmpty || searchedMovies?.isEmpty == false {
                Rectangle()
                    .foregroundColor(.clear)
                    .onAppear {
                        if self.isSearching && self.searchedMovies?.isEmpty == false {
                            self.searchTextWrapper.searchPageListener.currentPage += 1
                        } else if self.pageListener != nil && !self.isSearching && !self.movies.isEmpty {
                            self.pageListener?.currentPage += 1
                        }
                }
            }
        }
    }
}

#if DEBUG
struct MoviesList_Previews : PreviewProvider {
    static var previews: some View {
        MoviesList(movies: [sampleMovie.id], displaySearch: true).environmentObject(sampleStore)
    }
}
#endif
