//
//  MoviesSearch.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

final class MoviesSearchPageListener: MoviesPagesListener {
    var text: String?
    
    override func loadPage() {
        if let text = text {
            store.dispatch(action: MoviesActions.FetchSearch(query: text, page: currentPage))
            store.dispatch(action: PeopleActions.FetchSearch(query: text, page: currentPage))
        }
    }
}

final class MoviesSearchTextWrapper: SearchTextWrapper {
    var searchPageListener = MoviesSearchPageListener()
    
    override func onUpdateText(text: String) {
        store.dispatch(action: MoviesActions.FetchSearchKeyword(query: text))
        searchPageListener.text = text
        searchPageListener.currentPage = 1
    }
    
    override func onUpdateTextDebounced(text: String) {

    }
}
