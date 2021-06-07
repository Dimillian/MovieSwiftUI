//
//  CustomListForm.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 18/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import UI

final class CustomListFormSearchWrapper: SearchTextObservable {
    override func onUpdateTextDebounced(text: String) {
        if !text.isEmpty {
            store.dispatch(action: MoviesActions.FetchSearch(query: text, page: 1))
        }
    }
}

struct CustomListForm : View {
    @EnvironmentObject var store: Store<AppState>
    @Environment(\.presentationMode) var presentationMode
    
    @State private var searchTextWrapper = CustomListFormSearchWrapper()
    @State private var isSearching = false
    @State var listName: String = ""
    @State var listMovieCover: Int?
    
    let editingListId: Int?
    
    private var searchedMovies: [Int] {
        return store.state.moviesState.search[searchTextWrapper.searchText]?.map{ $0 } ?? []
    }
    
    private var topSection: some View {
        Section(header: Text("List information"),
                content: {
                    HStack {
                        Text("Name:")
                        TextField("Name your list", text: $listName)
                    }
        })
    }
    
    private var coverSection: some View {
        Section(header: Text("List cover")) {
            if listMovieCover == nil {
                SearchField(searchTextWrapper: searchTextWrapper,
                            placeholder: "Search and add a movie as your cover",
                            isSearching: $isSearching)
                .onPreferenceChange(OffsetTopPreferenceKey.self) { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            if listMovieCover != nil {
                CustomListCoverRow(movieId: listMovieCover!)
                Button(action: {
                    self.listMovieCover = nil
                }, label: {
                    Text("Remove cover").foregroundColor(.red)
                })
            }
            
            if !searchTextWrapper.searchText.isEmpty {
                movieSearchSection
            }
        }
    }
    
    private var movieSearchSection: some View {
        Section() {
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(searchedMovies, id: \.self) { movieId in
                        CustomListCoverRow(movieId: movieId).onTapGesture {
                            self.listMovieCover = movieId
                            self.searchTextWrapper.searchText = ""
                        }
                    }
                }
                .padding(.bottom, 10)
            }
            .frame(height: 200)
            .padding(.leading, 16)
            .listRowInsets(EdgeInsets())
        }
    }
    
    private var buttonsSection: some View {
        Section {
            Button(action: {
                let newList = CustomList(id: Int.random(in: self.store.state.moviesState.customLists.count ..< 1000^3),
                                         name: self.listName,
                                         cover: self.listMovieCover,
                                         movies: [])
                if let id = self.editingListId {
                    self.store.dispatch(action: MoviesActions.EditCustomList(list: id,
                                                                             title: self.listName,
                                                                             cover: self.listMovieCover))
                } else {
                    self.store.dispatch(action: MoviesActions.AddCustomList(list: newList))
                }
                self.presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Text(self.editingListId != nil ? "Save changes" : "Create").foregroundColor(.blue)
            })
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel").foregroundColor(.red)
            })
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                topSection
                coverSection
                buttonsSection
            }
            .navigationBarTitle(Text("New list"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            if let id = self.editingListId,
                let list = self.store.state.moviesState.customLists[id] {
                self.listMovieCover = list.cover
                self.listName = list.name
            }
        }
    }
}

#if DEBUG
struct CustomListForm_Previews : PreviewProvider {
    static var previews: some View {
        CustomListForm(editingListId: nil).environmentObject(sampleStore)
    }
}
#endif
