//
//  MovieDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieDetail : View {
    let movie: Movie
    var body: some View {
        List {
            ZStack(alignment: .bottomLeading) {
                MovieDetailImage(imageLoader: ImageLoader(poster: movie.backdrop_path,
                                                          size: .original))
                Rectangle()
                    .foregroundColor(.black)
                    .opacity(0.25)
                    .blur(radius: 5)
                    .frame(height: 80)
                HStack {
                    Text(movie.original_title)
                        .fontWeight(.bold)
                        .font(.title)
                        .color(.white)
                        .lineLimit(nil)
                    }
                    .padding(.bottom)
                    .padding(.leading)
                
            }.listRowInsets(EdgeInsets())
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.overview).color(.secondary).lineLimit(nil)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        
    }
    
}

struct MovieDetailImage : View {
    @State var imageLoader: ImageLoader
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(500/300, contentMode: .fit)
            } else {
                Rectangle()
                    .aspectRatio(500/300, contentMode: .fit)
                    .foregroundColor(.black)
            }
            }.onAppear {
                self.imageLoader.loadImage()
        }
    }
}

#if DEBUG
struct MovieDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetail(movie: sampleMovie)
        }
    }
}
#endif
