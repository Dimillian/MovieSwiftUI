//
//  MoviesList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MoviesList : View {
    let movies: [Int]
    
    @State var searchtext: String = ""
    
    var body: some View {
        VStack {
            List {
                TextField($searchtext,
                          placeholder: Text("Search any movies"),
                          onEditingChanged: { (_) in
                }) {
                    
                }
                    .textFieldStyle(.roundedBorder)
                    .listRowInsets(EdgeInsets())
                    .padding()
                ForEach(movies) {id in
                    NavigationButton(destination: MovieDetail(movieId: id)) {
                        MovieRow(movieId: id)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct MoviesList_Previews : PreviewProvider {
    static var previews: some View {
        MoviesList(movies: [sampleMovie.id])
    }
}
#endif
