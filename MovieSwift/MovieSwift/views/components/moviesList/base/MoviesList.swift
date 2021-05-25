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
import UI
import Backend

// MARK: - Movies List
struct MoviesList: ConnectedView {
    struct Props {
        let searchedMovies: [Int]?
        let searchedKeywords: [Keyword]?
        let searcherdPeoples: [Int]?
        let recentSearches: [String]
    }
    
    enum SearchFilter: Int {
        case movies, peoples
    }
    
    
    // MARK: - binding
    @State private var searchFilter: Int = SearchFilter.movies.rawValue
    @State private var searchTextWrapper = MoviesSearchTextWrapper()
    @State private var isSearching = false
    
    // MARK: - Public var
    let movies: [Int]
    let displaySearch: Bool
    var pageListener: MoviesPagesListener?
    
    // MARK: - Private var
    @State private var selectedItem: String? = nil
    @State private var listViewId = UUID()
    
    // MARK: - Computed Props
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        if isSearching {
            return Props(searchedMovies: state.moviesState.search[searchTextWrapper.searchText],
                         searchedKeywords: state.moviesState.searchKeywords[searchTextWrapper.searchText]?.prefix(5).map{ $0 },
                         searcherdPeoples: state.peoplesState.search[searchTextWrapper.searchText],
                         recentSearches: state.moviesState.recentSearches.map{ $0 })
        }
        return Props(searchedMovies: nil, searchedKeywords: nil, searcherdPeoples: nil, recentSearches: [])
    }
    
    // MARK: - Computed views
    private func moviesRows(props: Props) -> some View {
        ForEach(isSearching ? props.searchedMovies ?? [] : movies, id: \.self) { id in
            NavigationLink(destination: MovieDetail(movieId: id), tag: String(id), selection:$selectedItem) {
                MovieRow(movieId: id)
            }
        }
    }
    
    private func movieSection(props: Props) -> some View {
        Group {
            if isSearching {
                Section(header: Text("Results for \(searchTextWrapper.searchText)")) {
                    if isSearching && props.searchedMovies == nil {
                        MovieRow(movieId: 0)
                        MovieRow(movieId: 0)
                        MovieRow(movieId: 0)
                        MovieRow(movieId: 0)
                    } else if isSearching && props.searchedMovies?.isEmpty == true {
                        Text("No results")
                    } else {
                        moviesRows(props: props)
                    }
                }
            } else {
                Section {
                    moviesRows(props: props)
                }
            }
        }
    }
    
    private func peoplesSection(props: Props) -> some View {
        Section {
            if isSearching && props.searcherdPeoples == nil {
                PeopleRow(peopleId: 0)
                PeopleRow(peopleId: 0)
                PeopleRow(peopleId: 0)
                PeopleRow(peopleId: 0)
            } else if isSearching && props.searcherdPeoples?.isEmpty == true {
                Text("No results")
            } else {
                ForEach(props.searcherdPeoples ?? [], id: \.self) { id in
                    NavigationLink(destination: PeopleDetail(peopleId: id), tag: String(id), selection:$selectedItem) {
                        PeopleRow(peopleId: id)
                    }
                }
            }
        }
    }
    
    private func keywordsSection(props: Props) -> some View {
        Section(header: Text("Keywords")) {
            ForEach(props.searchedKeywords ?? []) {keyword in
                NavigationLink(destination: MovieKeywordList(keyword: keyword)) {
                    Text(keyword.name)
                }
            }
        }
    }
        
    private var searchField: some View {
        SearchField(searchTextWrapper: searchTextWrapper,
                    placeholder: "Search any movies or person",
                    isSearching: $isSearching)
        .onPreferenceChange(OffsetTopPreferenceKey.self) { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private var searchFilterView: some View {
        Picker(selection: $searchFilter, label: Text("")) {
            Text("Movies").tag(SearchFilter.movies.rawValue)
            Text("People").tag(SearchFilter.peoples.rawValue)
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    // MARK: - Body
    func body(props: Props) -> some View {
        List {
            if displaySearch {
                Section {
                    searchField
                }
            }
            
            if isSearching {
                searchFilterView
                if props.searchedKeywords != nil && searchFilter == SearchFilter.movies.rawValue {
                    keywordsSection(props: props)
                }
            }
            
            if isSearching && searchFilter == SearchFilter.peoples.rawValue {
                peoplesSection(props: props)
                    .id(listViewId)
            } else {
                movieSection(props: props)
                    .id(listViewId)
            }
            
            /// The pagination is done by appending a invisible rectancle at the bottom of the list, and trigerining the next page load as it appear.
            /// Hacky way for now, hope it'll be possible to find a better solution in a future version of SwiftUI.
            /// Could be possible to do with GeometryReader.
            if !movies.isEmpty || props.searchedMovies?.isEmpty == false {
                Rectangle()
                    .foregroundColor(.clear)
                    .onAppear {
                        if self.isSearching && props.searchedMovies?.isEmpty == false {
                            self.searchTextWrapper.searchPageListener.currentPage += 1
                        } else if self.pageListener != nil && !self.isSearching && !self.movies.isEmpty {
                            self.pageListener?.currentPage += 1
                        }
                    }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            if selectedItem != nil {
                selectedItem = nil
                /// Changing view id to refresh view to avoid a bug of SwiftUI List that selected list row remains highlighted
                listViewId = UUID()
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
