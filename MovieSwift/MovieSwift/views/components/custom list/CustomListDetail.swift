//
//  CustomListDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct CustomListDetail : View {
    @EnvironmentObject var store: Store<AppState>
    
    let listId: Int
    
    @State private var isEditing = false
    
    var list: CustomList {
        store.state.moviesState.customLists[listId]!
    }
    
    var movies: [Int] {
        list.movies.sortedMoviesIds(by: .byReleaseDate, state: store.state)
    }
    
    var body: some View {
        List {
            CustomListHeaderRow(listId: listId)
            ForEach(movies) { movie in
                NavigationLink(destination: MovieDetail(movieId: movie).environmentObject(self.store)) {
                    MovieRow(movieId: movie, displayListImage: false)
                }
            }.onDelete { (index) in
               self.store.dispatch(action: MoviesActions.RemoveMovieFromCustomList(list: self.listId, movie: self.movies[index.first!]))
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
