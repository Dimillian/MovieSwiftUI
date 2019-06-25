//
//  MoviesList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

class PageListener {
    var currentPage: Int = 1 {
        didSet {
            loadPage()
        }
    }
    
    func loadPage() {
        
    }
}


final class SearchPageListener: PageListener {
    var text: String!
    
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchSearch(query: text, page: currentPage))
    }
}

struct MoviesList : View {
    @EnvironmentObject var store: AppStore
    @State var searchtext: String = ""
    @State var searchPageListener = SearchPageListener()
    
    let movies: [Int]
    let displaySearch: Bool
    var pageListener: PageListener?
    var deleteHandler: ((Int) -> Void)? = nil
    
    var isSearching: Bool {
        return !searchtext.isEmpty
    }
    
    var searchedMovies: [Int] {
        return store.state.moviesState.search[searchtext] ?? []
    }
    
    var keywords: [Keyword]? {
        return store.state.moviesState.searchKeywords[searchtext]?.prefix(5).map{ $0 }
    }
    
    var movieSection: some View {
        Section {
            ForEach(isSearching ? searchedMovies : movies) {id in
                NavigationButton(destination: MovieDetail(movieId: id)) {
                    MovieRow(movieId: id)
                }
            }
        }
    }
    
    var searchSection: some View {
        Section {
            ForEach(keywords!) {keyword in
                NavigationButton(destination: MovieKeywordList(keyword: keyword)) {
                    Text(keyword.name)
                }
            }
        }
    }
    
    var searchField: some View {
        SearchField(searchText: $searchtext,
                    placeholder: Text("Search movies"),
                    onUpdateSearchText: {text in
                        if !text.isEmpty {
                            self.searchPageListener.text = text
                            self.searchPageListener.currentPage = 1
                            self.store.dispatch(action: MoviesActions.FetchSearchKeyword(query: text))
                        }
        })
    }
    
    var body: some View {
        List {
            if displaySearch {
                searchField
            }
            if isSearching && keywords != nil {
                searchSection
            }
            movieSection
            if !movies.isEmpty || !searchedMovies.isEmpty {
                Rectangle()
                    .foregroundColor(.clear)
                    .onAppear {
                        if self.isSearching && !self.searchedMovies.isEmpty{
                            self.searchPageListener.currentPage += 1
                        } else if self.pageListener != nil {
                            self.pageListener!.currentPage += 1
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
