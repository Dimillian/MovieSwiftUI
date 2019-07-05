//
//  MyLists.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MyLists : View {
    
    // MARK: - Defs
    private enum MoviesSort: Int {
        case byAddedDate, byReleaseDate
    }
    
    // MARK: - Vars
    @State private var selectedList: Int = 0
    @State private var selectedMoviesSort = MoviesSort.byAddedDate
    @State private var showShortActionSheet = false
    @EnvironmentObject private var store: Store<AppState>
    
    // MARK: - Dynamic vars
    var customLists: [CustomList] {
        store.state.moviesState.customLists.compactMap{ $0.value }
    }
    
    var wishlist: [Int] {
        get {
            let wishlist = store.state.moviesState.wishlist.map{ $0.id }
            switch selectedMoviesSort {
            case .byAddedDate:
                let metas = store.state.moviesState.moviesUserMeta.filter{ wishlist.contains($0.key) }
                return metas.sorted{ $0.value.dateAddedToWishlist! > $1.value.dateAddedToWishlist! }.compactMap{ $0.key }
            case .byReleaseDate:
                let movies = store.state.moviesState.movies.filter{ wishlist.contains($0.key) }
                return movies.sorted{ $0.value.releaseDate ?? Date() > $1.value.releaseDate ?? Date() }.compactMap{ $0.key }
            }
        }
    }
    
    var seenlist: [Int] {
        get {
            let seenlist = store.state.moviesState.seenlist.map{ $0.id }
            switch selectedMoviesSort {
            case .byAddedDate:
                let metas = store.state.moviesState.moviesUserMeta.filter{ seenlist.contains($0.key) }
                return metas.sorted{ $0.value.dateAddedToWishlist! > $1.value.dateAddedToWishlist! }.compactMap{ $0.key }
            case .byReleaseDate:
                let movies = store.state.moviesState.movies.filter{ seenlist.contains($0.key) }
                return movies.sorted{ $0.value.releaseDate ?? Date() > $1.value.releaseDate ?? Date() }.compactMap{ $0.key }
            }
        }
    }
    
    // MARK: - Dynamic views
    private var sortActionSheet: ActionSheet? {
        get {
            guard showShortActionSheet else {
                return nil
            }
            let byAddedDate: Alert.Button = .default(Text("Sort by added date")) {
                self.selectedMoviesSort = .byAddedDate
                self.showShortActionSheet = false
            }
            let byReleaseDate: Alert.Button = .default(Text("Sort by release date")) {
                self.selectedMoviesSort = .byReleaseDate
                self.showShortActionSheet = false
            }
            
            return ActionSheet(title: Text("Sort movies by"),
                               message: nil,
                               buttons: [byAddedDate, byReleaseDate, Alert.Button.cancel({
                self.showShortActionSheet = false
            })])
        }
    }
    
    private var customListsSection: some View {
        Section(header: Text("Custom Lists")) {
            PresentationLink(destination: CustomListForm(shouldDismiss: {
                
            }).environmentObject(store)) {
                Text("Create custom list").color(.steam_blue)
            }
            ForEach(customLists) { list in
                NavigationLink(destination: CustomListDetail(listId: list.id).environmentObject(self.store)) {
                    CustomListRow(list: list)
                }
            }
            .onDelete { (index) in
                let list = self.customLists[index.first!]
                self.store.dispatch(action: MoviesActions.RemoveCustomList(list: list.id))
            }
        }
    }
    
    private var wishlistSection: some View {
        Section(header: Text("Wishlist")) {
            ForEach(wishlist) {id in
                NavigationLink(destination: MovieDetail(movieId: id).environmentObject(self.store)) {
                    MovieRow(movieId: id)
                }
                }
                .onDelete { (index) in
                    let movie = self.wishlist[index.first!]
                    self.store.dispatch(action: MoviesActions.RemoveFromWishlist(movie: movie))
                    
            }
        }
    }
    
    private var seenSection: some View {
        Section(header: Text("Seen")) {
            ForEach(seenlist) {id in
                NavigationLink(destination: MovieDetail(movieId: id).environmentObject(self.store)) {
                    MovieRow(movieId: id)
                }
                }
                .onDelete { (index) in
                    let movie = self.seenlist[index.first!]
                    self.store.dispatch(action: MoviesActions.RemoveFromSeenList(movie: movie))
            }
        }
    }
    
    // MARK: - Body
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
            .presentation(sortActionSheet)
            .navigationBarTitle(Text("My Lists"))
            .navigationBarItems(trailing: Button(action: {
                    self.showShortActionSheet.toggle()
            }, label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
            }))
        }
    }
}

#if DEBUG
struct MyLists_Previews : PreviewProvider {
    static var previews: some View {
        MyLists().environmentObject(sampleStore)
    }
}
#endif

