//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

fileprivate let placeholder = UIImage(named: "poster-placeholder")!

struct MovieRow : View {
    @EnvironmentObject var state: AppState
    
    let movieId: Int
    var movie: Movie! {
        return state.moviesState.movies[movieId]
    }
        
    var body: some View {
        HStack {
            MovieRowImage(imageLoader: ImageLoader(poster: movie.poster_path, size: .medium))
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.original_title).bold()
                Text(movie.overview)
                    .color(.secondary)
                    .lineLimit(8)
                    .truncationMode(.tail)
            }.padding(.leading, 8)
        }.padding(8)
    }
}


struct MovieRowImage : View {
    @State var imageLoader: ImageLoader
    @State var isHovered = false
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .frame(width: 100, height: 150)
                    .cornerRadius(5)
                    .scaleEffect(isHovered ? 1.5 : 1.0)
                    .shadow(radius: 8)
                    .onHover(perform: {hovered in
                        withAnimation{ self.isHovered = hovered }
                    })
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 150)
                    .cornerRadius(5)
                    .shadow(radius: 8)
            }
            }.onAppear {
                self.imageLoader.loadImage()
        }
    }
}

#if DEBUG
struct MovieRow_Previews : PreviewProvider {
    static var previews: some View {
        List {
            MovieRow(movieId: sampleMovie.id).environmentObject(sampleStore)
        }
    }
}
#endif
