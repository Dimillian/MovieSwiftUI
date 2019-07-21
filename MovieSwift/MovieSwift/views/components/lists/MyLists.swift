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
    @EnvironmentObject private var store: Store<AppState>
        
    // MARK: - Vars
    @State private var selectedList: Int = 0
    @State private var selectedMoviesSort = MoviesSort.byReleaseDate
    @State private var showShortActionSheet = false
    @State private var isEditingFormPresented = false
    
    // MARK: - Dynamic vars
    var customLists: [CustomList] {
        store.state.moviesState.customLists.compactMap{ $0.value }
    }
    
    var wishlist: [Int] {
        store.state.moviesState.wishlist.map{ $0.id }.sortedMoviesIds(by: selectedMoviesSort,
                                                                      state: store.state)
    }
    
    var seenlist: [Int] {
        store.state.moviesState.seenlist.map{ $0.id }.sortedMoviesIds(by: selectedMoviesSort,
                                                                      state: store.state)
    }
    
    // MARK: - Dynamic views
    private var sortActionSheet: ActionSheet {
        get {
            let byAddedDate: Alert.Button = .default(Text("Sort by added date")) {
                self.selectedMoviesSort = .byAddedDate
                self.showShortActionSheet = false
            }
            let byReleaseDate: Alert.Button = .default(Text("Sort by release date")) {
                self.selectedMoviesSort = .byReleaseDate 
                self.showShortActionSheet = false
            }
            let byScore: Alert.Button = .default(Text("Sort by ratings")) {
                self.selectedMoviesSort = .byScore
                self.showShortActionSheet = false
            }
            let byPopularity: Alert.Button = .default(Text("Sort by popularity")) {
                self.selectedMoviesSort = .byPopularity
                self.showShortActionSheet = false
            }
            
            return ActionSheet(title: Text("Sort movies by"),
                               message: nil,
                               buttons: [byAddedDate, byReleaseDate, byScore, byPopularity, Alert.Button.cancel({
                                self.showShortActionSheet = false
                               })])
        }
    }
    
    private var customListsSection: some View {
        Section(header: Text("Custom Lists")) {
            Button(action: {
                self.isEditingFormPresented = true
            }) {
                Text("Create custom list").foregroundColor(.steam_blue)
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
        Section(header: Text("\(wishlist.count) movies in wishlist (\(selectedMoviesSort.title()))")) {
            ForEach(wishlist) {id in
                NavigationLink(destination: MovieDetail(movieId: id).environmentObject(self.store)) {
                    MovieRow(movieId: id, displayListImage: false)
                }
                }
                .onDelete { (index) in
                    let movie = self.wishlist[index.first!]
                    self.store.dispatch(action: MoviesActions.RemoveFromWishlist(movie: movie))
                    
            }
        }
    }
    
    private var seenSection: some View {
        Section(header: Text("\(seenlist.count) movies in seenlist (\(selectedMoviesSort.title()))")) {
            ForEach(seenlist) {id in
                NavigationLink(destination: MovieDetail(movieId: id).environmentObject(self.store)) {
                    MovieRow(movieId: id, displayListImage: false)
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
                    Text("Seenlist").tag(1)
                }
                if selectedList == 0 {
                    wishlistSection
                } else if selectedList == 1 {
                    seenSection
                }
            }
            .actionSheet(isPresented: $showShortActionSheet, content: { sortActionSheet })
            .navigationBarTitle(Text("My Lists"))
            .navigationBarItems(trailing: Button(action: {
                    self.showShortActionSheet.toggle()
            }, label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
            }))
        }
        .sheet(isPresented: $isEditingFormPresented,
               onDismiss: { self.isEditingFormPresented = false }) {
                CustomListForm(editingListId: nil,
                               shouldDismiss: {
                    self.isEditingFormPresented = false
                }).environmentObject(self.store)
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

