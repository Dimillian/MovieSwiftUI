//
//  CustomListRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 18/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend

struct CustomListRow : View {
    @EnvironmentObject var store: Store<AppState>
    
    let list: CustomList
    var coverMovie: Movie? {
        guard let id = list.movies.first else {
            return nil
        }
        return store.state.moviesState.movies[id]
    }
    
    var body: some View {
        HStack {
            SmallMoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: coverMovie?.poster_path,
                                                                                 size: .medium))
            VStack(alignment: .leading, spacing: 2) {
                Text(list.name).font(.headline).fontWeight(.bold)
                Text("\(list.movies.count) movies").font(.subheadline).foregroundColor(.secondary)
            }
            }.listRowInsets(EdgeInsets())
            .frame(height: 50)
    }
}

struct SmallMoviePosterImage : View {
    @ObservedObject var imageLoader: ImageLoader
    @State var isImageLoaded = false
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 33, height: 50)
                    .cornerRadius(3)
                    .opacity(isImageLoaded ? 1 : 0.1)
                    .shadow(radius: 2)
                    .animation(.easeInOut)
                    .onAppear{
                        self.isImageLoaded = true
                }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 33, height: 50)
                    .cornerRadius(3)
                    .opacity(0.3)
            }
            }
    }
}

#if DEBUG
struct CustomListRow_Previews : PreviewProvider {
    static var previews: some View {
        CustomListRow(list: CustomList(id: 0, name: "Wow", cover: 0, movies: [0]))
            .environmentObject(sampleStore)
    }
}
#endif
