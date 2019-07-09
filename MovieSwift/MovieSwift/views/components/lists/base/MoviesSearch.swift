//
//  MoviesSearch.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

final class SearchPageListener: MoviesPagesListener {
    var text: String?
    
    override func loadPage() {
        if let text = text {
            store.dispatch(action: MoviesActions.FetchSearch(query: text, page: currentPage))
            store.dispatch(action: PeopleActions.FetchSearch(query: text, page: currentPage))
        }
    }
}


final class SearchMoviesWrapper: SearchTextWrapper {
    var searchPageListener = SearchPageListener()
    
    override func onUpdateText(text: String) {
        store.dispatch(action: MoviesActions.FetchSearchKeyword(query: text))
    }
    
    override func onUpdateTextDebounced(text: String) {
        self.searchPageListener.text = text
        self.searchPageListener.currentPage = 1
    }
}
