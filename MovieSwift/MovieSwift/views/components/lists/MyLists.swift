//
//  MyLists.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MyLists : View {
    @State var selectedList: Int = 0
    @EnvironmentObject var state: AppState
    
    var customListsSection: some View {
        Section(header: Text("Custom Lists")) {
            PresentationButton(destination: CustomListForm().environmentObject(store),
                               label: {
                                Text("Create custom list")
                                    .color(.blue)
            })
            ForEach(state.moviesState.customLists) { list in
                NavigationButton(destination: CustomListDetail(listId: list.id)) {
                    CustomListRow(list: list)
                }
            }
        }
    }
    
    var wishlistSection: some View {
        Section(header: Text("Wishlist")) {
            ForEach(state.moviesState.wishlist.map{ $0.id }) {id in
                NavigationButton(destination: MovieDetail(movieId: id)) {
                    MovieRow(movieId: id)
                }
                }
                .onDelete { (index) in
                    let movie = self.state.moviesState.wishlist.map{ $0.id }[index.first!]
                    store.dispatch(action: MoviesActions.removeFromWishlist(movie: movie))
                    
            }
        }
    }
    
    var seenSection: some View {
        Section(header: Text("Seen")) {
            ForEach(state.moviesState.seenlist.map{ $0.id }) {id in
                NavigationButton(destination: MovieDetail(movieId: id)) {
                    MovieRow(movieId: id)
                }
                }
                .onDelete { (index) in
                    let movie = self.state.moviesState.seenlist.map{ $0.id }[index.first!]
                    store.dispatch(action: MoviesActions.removeFromSeenlist(movie: movie))
            }
        }
    }
    var body: some View {
        NavigationView {
            List {
                customListsSection
                SegmentedControl(selection: $selectedList) {
                    Text("Wishlist").tag(0)
                    Text("Seen").tag(1)
                }
                if selectedList == 0 {
                    wishlistSection
                } else if selectedList == 1 {
                    seenSection
                }
            }
            .navigationBarTitle(Text("My Lists"))
        }
    }
}

#if DEBUG
struct MyLists_Previews : PreviewProvider {
    static var previews: some View {
        MyLists(selectedList: 0).environmentObject(sampleStore)
    }
}
#endif

