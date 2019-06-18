//
//  MoviesList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MoviesList : View {
    @EnvironmentObject var state: AppState
    
    @State var searchtext: String = ""
    
    let movies: [Int]
    let displaySearch: Bool
    
    var isSearching: Bool {
        return !searchtext.isEmpty
    }
    
    var searchedMovies: [Int] {
        return state.moviesState.search[searchtext] ?? []
    }
    
    var keywords: [Keyword]? {
        return state.moviesState.searchKeywords[searchtext]?.prefix(5).map{ $0 }
    }
    
    func onChange() {
        store.dispatch(action: MoviesActions.FetchSearch(query: searchtext))
        store.dispatch(action: MoviesActions.FetchSearchKeyword(query: searchtext))
    }
    
    var body: some View {
        VStack {
            List {
                if displaySearch {
                    TextField($searchtext,
                              placeholder: Text("Search any movies"))
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)
                            .debounce(for: 0.5,
                                      scheduler: DispatchQueue.main),
                                   perform: onChange)
                        .textFieldStyle(.roundedBorder)
                        .listRowInsets(EdgeInsets())
                        .padding()
                }
                if isSearching && keywords != nil {
                    Section {
                        ForEach(keywords!) {keyword in
                            NavigationButton(destination: MovieKeywordList(keyword: keyword)) {
                                Text(keyword.name)
                            }
                        }
                    }
                }
                Section {
                    ForEach(isSearching ? searchedMovies : movies) {id in
                        NavigationButton(destination: MovieDetail(movieId: id)) {
                            MovieRow(movieId: id)
                        }
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
