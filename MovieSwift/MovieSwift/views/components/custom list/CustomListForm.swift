//
//  CustomListForm.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 18/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CustomListForm : View {
    @EnvironmentObject var state: AppState

    @State var listName: String = ""
    @State var movieSearch: String = ""
    @State var listMovieCover: Int?
    
    var body: some View {
        NavigationView {
            Form {
                CustomListPreviewRow(listName: $listName, listMovieCover: $listMovieCover)
                TopSection(listMovieCover: $listMovieCover, movieSearch: $movieSearch, listName: $listName)
                MovieSearchSection(movieSearch: $movieSearch, listMovieCover: $listMovieCover)
                SaveCancelSection()
            }
            .navigationBarTitle(Text("New list"))
        }
    }
}

struct TopSection: View {
    @EnvironmentObject var state: AppState
    
    @Binding var listMovieCover: Int?
    @Binding var movieSearch: String
    @Binding var listName: String
    
    func onKeyStroke() {
        if !movieSearch.isEmpty {
            state.dispatch(action: MoviesActions.FetchSearch(query: movieSearch))
        }
    }
    
    var body: some View {
        Section(header: Text("List information"),
                footer: listMovieCover == nil ? Text("Movie cover is optional") : nil,
                content: {
                    TextField($listName, placeholder: Text("Name your list"))
                    if listMovieCover == nil {
                        TextField($movieSearch,
                                  placeholder: Text("Add movie as your cover"))
                            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)
                                .debounce(for: 0.5,
                                          scheduler: DispatchQueue.main),
                                       perform: onKeyStroke)
                            .textFieldStyle(.plain)
                    } else {
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
    @EnvironmentObject var state: AppState
    
    @Binding var movieSearch: String
    @Binding var listMovieCover: Int?
    
    var searchedMovies: [Int] {
        return state.moviesState.search[movieSearch]?.prefix(2).map{ $0 } ?? []
    }
    
    var body: some View {
        Section() {
            ForEach(searchedMovies) { movieId in
                MovieRow(movieId: movieId).tapAction {
                    self.listMovieCover = movieId
                    self.movieSearch = ""
                }
            }
        }
    }
}

struct SaveCancelSection: View {
    @Environment(\.isPresented) var isPresented
    
    var body: some View {
        Section {
            Button(action: {
                self.isPresented?.value = false
            }, label: {
                Text("Create").color(.blue)
            })
            Button(action: {
                self.isPresented?.value = false
            }, label: {
                Text("Cancel").color(.red)
            })
        }
    }
}

struct CustomListPreviewRow: View {
    @EnvironmentObject var state: AppState
    
    @Binding var listName: String
    @Binding var listMovieCover: Int?
    @State var isExpanded = false
    
    var movie: Movie? {
        guard let id = listMovieCover else {
            return nil
        }
        return state.moviesState.movies[id]
    }
    
    var body: some View {
        ZStack {
            MovieDetailImage(imageLoader: ImageLoader(poster: movie?.backdrop_path,
                                                      size: .original),
                             isExpanded: $isExpanded,
                             fill: true)
            Text(listName)
            }.frame(height: 100)
    }
}

#if DEBUG
struct CustomListForm_Previews : PreviewProvider {
    static var previews: some View {
        CustomListForm().environmentObject(sampleStore)
    }
}
#endif
