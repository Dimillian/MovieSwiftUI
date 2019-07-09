//
//  CustomListForm.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 18/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

final class CustomListFormSearchWrapper: SearchTextWrapper {

    override func onUpdateTextDebounced(text: String) {
        if !text.isEmpty {
            store.dispatch(action: MoviesActions.FetchSearch(query: text, page: 1))
        }
    }
}

struct CustomListForm : View {
    @EnvironmentObject var store: Store<AppState>
    
    @State private var searchTextWrapper = CustomListFormSearchWrapper()
    
    @State var listName: String = ""
    @State var listMovieCover: Int?
    
    let shouldDismiss: (() -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                TopSection(searchTextWrapper: searchTextWrapper, listMovieCover: $listMovieCover, listName: $listName)
                MovieSearchSection(searchTextWrapper: searchTextWrapper, listMovieCover: $listMovieCover)
                SaveCancelSection(listName: $listName, listMovieCover: $listMovieCover, shouldDismiss: shouldDismiss)
            }
            .navigationBarTitle(Text("New list"))
        }
    }
}

struct TopSection: View {
    @EnvironmentObject var store: Store<AppState>
    
    @ObjectBinding var searchTextWrapper: CustomListFormSearchWrapper
    @Binding var listMovieCover: Int?
    @Binding var listName: String
    
    var body: some View {
        Section(header: Text("List information"),
                content: {
                    HStack {
                        Text("Name:")
                        TextField("Name your list", text: $listName)
                    }
                    if listMovieCover == nil {
                        SearchField(searchTextWrapper: searchTextWrapper,
                                    placeholder: Text("Search and add a movie as your cover"))
                            .disabled(listMovieCover != nil)
                    }
                    if listMovieCover != nil {
                        CustomListCoverRow(movieId: listMovieCover!)
                        Button(action: {
                            self.listMovieCover = nil
                        }, label: {
                            Text("Remove cover").color(.red)
                        })
                    }
        })
    }
}

struct MovieSearchSection: View {
    @EnvironmentObject var store: Store<AppState>
    
    @ObjectBinding var searchTextWrapper: CustomListFormSearchWrapper
    @Binding var listMovieCover: Int?
    
    var searchedMovies: [Int] {
        return store.state.moviesState.search[searchTextWrapper.searchText]?.prefix(2).map{ $0 } ?? []
    }
    
    var body: some View {
        Section() {
            ForEach(searchedMovies) { movieId in
                CustomListCoverRow(movieId: movieId).tapAction {
                    self.listMovieCover = movieId
                    self.searchTextWrapper.searchText = ""
                }
            }
        }
    }
}

struct SaveCancelSection: View {
    @EnvironmentObject var store: Store<AppState>
    @Environment(\.isPresented) var isPresented
    
    @Binding var listName: String
    @Binding var listMovieCover: Int?
    
    let shouldDismiss: (() -> Void)?
    
    var body: some View {
        Section {
            Button(action: {
                let newList = CustomList(id: Int.random(in: self.store.state.moviesState.customLists.count ..< 1000^3),
                                         name: self.listName,
                                         cover: self.listMovieCover,
                                         movies: [])
                self.store.dispatch(action: MoviesActions.AddCustomList(list: newList))
                self.isPresented?.value = false
                self.shouldDismiss?()
                
            }, label: {
                Text("Create").color(.blue)
            })
            Button(action: {
                self.isPresented?.value = false
                self.shouldDismiss?()
            }, label: {
                Text("Cancel").color(.red)
            })
        }
    }
}

#if DEBUG
struct CustomListForm_Previews : PreviewProvider {
    static var previews: some View {
        CustomListForm(shouldDismiss: {
            
        }).environmentObject(sampleStore)
    }
}
#endif
