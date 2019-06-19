//
//  CustomListRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 18/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CustomListRow : View {
    @EnvironmentObject var state: AppState
    
    let list: CustomList
    var coverMovie: Movie? {
        guard let id = list.cover else {
            return nil
        }
        return state.moviesState.movies[id]
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            MovieBackdropImage(imageLoader: ImageLoader(poster: coverMovie?.poster_path,
                                                        size: .original),
                               isExpanded: .constant(false),
                               forceBlur: true,
                               fill: true)
            VStack(alignment: .leading, spacing: 2) {
                Text(list.name)
                Text("\(list.movies.count) movies")
            }.blendMode(.overlay)
        }.frame(height: 50)
    }
}

#if DEBUG
struct CustomListRow_Previews : PreviewProvider {
    static var previews: some View {
        CustomListRow(list: CustomList(name: "Wow", cover: 0, movies: [0]))
            .environmentObject(sampleStore)
    }
}
#endif
