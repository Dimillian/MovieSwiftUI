//
//  MyLists.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MyLists : ConnectedView {
    struct Props {
        let customLists: [CustomList]
        let wishlist: [Int]
        let seenlist: [Int]
    }
    
    // MARK: - Vars
    @EnvironmentObject private var store: Store<AppState>
    @State private var selectedList: Int = 0
    @State private var selectedMoviesSort = MoviesSort.byReleaseDate
    @State private var isSortActionSheetPresented = false
    @State private var isEditingFormPresented = false
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(customLists: state.moviesState.customLists.compactMap{ $0.value },
              wishlist: state.moviesState.wishlist.map{ $0 }.sortedMoviesIds(by: selectedMoviesSort,
                                                                                state: store.state),
              seenlist: state.moviesState.seenlist.map{ $0 }.sortedMoviesIds(by: selectedMoviesSort,
                                                                                state: store.state))
    }
    
    // MARK: - Dynamic views
    private var sortActionSheet: ActionSheet {
        ActionSheet.sortActionSheet { (sort) in
            if let sort = sort{
                self.selectedMoviesSort = sort
            }
        }
    }
    
    private func customListsSection(props: Props) -> some View {
        Section(header: Text("Custom Lists")) {
            Button(action: {
                self.isEditingFormPresented = true
            }) {
                Text("Create custom list").foregroundColor(.steam_blue)
            }
            ForEach(props.customLists) { list in
                NavigationLink(destination: CustomListDetail(listId: list.id)) {
                    CustomListRow(list: list)
                }
            }
            .onDelete { (index) in
                let list = props.customLists[index.first!]
                self.store.dispatch(action: MoviesActions.RemoveCustomList(list: list.id))
            }
        }
    }
    
    private func wishlistSection(props: Props) -> some View {
        Section(header: Text("\(props.wishlist.count) movies in wishlist (\(selectedMoviesSort.title()))")) {
            ForEach(props.wishlist, id: \.self) {id in
                NavigationLink(destination: MovieDetail(movieId: id)) {
                    MovieRow(movieId: id, displayListImage: false)
                }
            }
            .onDelete { (index) in
                let movie = props.wishlist[index.first!]
                self.store.dispatch(action: MoviesActions.RemoveFromWishlist(movie: movie))
                
            }
        }
    }
    
    private func seenSection(props: Props) -> some View {
        Section(header: Text("\(props.seenlist.count) movies in seenlist (\(selectedMoviesSort.title()))")) {
            ForEach(props.seenlist, id: \.self) {id in
                NavigationLink(destination: MovieDetail(movieId: id)) {
                    MovieRow(movieId: id, displayListImage: false)
                }
            }
            .onDelete { (index) in
                let movie = props.seenlist[index.first!]
                self.store.dispatch(action: MoviesActions.RemoveFromSeenList(movie: movie))
            }
        }
    }
    
    func body(props: Props) -> some View {
        NavigationView {
            List {
                customListsSection(props: props)
                
                Picker(selection: $selectedList, label: Text("")) {
                    Text("Wishlist").tag(0)
                    Text("Seenlist").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                
                if selectedList == 0 {
                    wishlistSection(props: props)
                } else if selectedList == 1 {
                    seenSection(props: props)
                }
            }
            .listStyle(GroupedListStyle())
            .actionSheet(isPresented: $isSortActionSheetPresented, content: { sortActionSheet })
                .navigationBarTitle(Text("My Lists"))
                .navigationBarItems(trailing: Button(action: {
                    self.isSortActionSheetPresented.toggle()
                }, label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                }))
        }
        .sheet(isPresented: $isEditingFormPresented) {
                CustomListForm(editingListId: nil).environmentObject(self.store)
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

