//
//  MoviesGenreList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 15/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

// MARK: - Page listener
final class MovieGenrePageListener: MoviesPagesListener {
    var genre: Genre
    var dispatch: DispatchFunction?
    
    var sort: MoviesSort = .byPopularity {
        didSet {
            currentPage = 1
            loadPage()
        }
    }
    
    override func loadPage() {
        dispatch?(MoviesActions.FetchMoviesGenre(genre: genre, page: currentPage, sortBy: sort))
    }
    
    init(genre: Genre) {
        self.genre = genre
        super.init()
    }
}

// MARK: - View
struct MoviesGenreList: ConnectedView {
    struct Props {
        let movies: [Int]
        let dispatch: DispatchFunction
    }
    
    let genre: Genre
    let pageListener: MovieGenrePageListener
    
    @State var isSortSheetPresented = false
    @State var selectedSort: MoviesSort = .byPopularity
    
    init(genre: Genre) {
        self.genre = genre
        self.pageListener = MovieGenrePageListener(genre: self.genre)
    }
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(movies: state.moviesState.withGenre[genre.id] ?? [],
              dispatch: dispatch)
    }
    
    func body(props: Props) -> some View {
        MoviesList(movies: props.movies, displaySearch: false, pageListener: pageListener)
            .navigationBarItems(trailing: (
                Button(action: {
                    self.isSortSheetPresented.toggle()
                }, label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .imageScale(.large)
                        .foregroundColor(.steam_gold)
                })
            ))
            .navigationBarTitle(Text(genre.name))
            .actionSheet(isPresented: $isSortSheetPresented,
                         content: { ActionSheet.sortActionSheet(onAction: { sort in
                            if let sort = sort {
                                self.selectedSort = sort
                                self.pageListener.sort = sort
                            }
                         })
            })
            .onAppear {
                self.pageListener.dispatch = props.dispatch
                self.pageListener.loadPage()
        }
    }
}

#if DEBUG
struct MoviesGenreList_Previews : PreviewProvider {
    static var previews: some View {
        MoviesGenreList(genre: Genre(id: 0, name: "test")).environmentObject(store)
    }
}
#endif
