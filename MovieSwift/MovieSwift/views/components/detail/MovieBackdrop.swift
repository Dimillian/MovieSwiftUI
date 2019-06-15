//
//  MovieBackdrop.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieBackdrop: View {
    @EnvironmentObject var state: AppState
    @State var seeImage = false
    
    let movieId: Int
    var movie: Movie! {
        return state.moviesState.movies[movieId]
    }
    
    //MARK: - View computed properties
    
    var transition: AnyTransition {
        return AnyTransition.move(edge: .leading)
                .combined(with: .opacity)
    }
    
    var animation: Animation {
        Animation.spring(initialVelocity: 2)
            .speed(2)
            .delay(0.5)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MovieDetailImage(imageLoader: ImageLoader(poster: movie.backdrop_path,
                                                      size: .original),
                             isExpanded: $seeImage)
                .blur(radius: seeImage ? 0 : 10, opaque: true)
                .tapAction {
                    withAnimation{
                        self.seeImage.toggle()
                    }
            }
            if !seeImage {
                HStack {
                    VStack(alignment: .leading) {
                        Text(movie.original_title)
                            .fontWeight(.bold)
                            .font(.title)
                            .color(.white)
                            .lineLimit(nil)
                        HStack {
                            Text(movie.release_date.prefix(4))
                                .font(.subheadline)
                                .color(.white)
                            if movie.runtime != nil {
                                Text("• \(movie.runtime!) minutes")
                                    .font(.subheadline)
                                    .color(.white)
                                    .transition(transition)
                                    .animation(animation)
                            }
                            if movie.status != nil {
                                Text("• \(movie.status!)")
                                    .font(.subheadline)
                                    .color(.white)
                                    .transition(transition)
                                    .animation(animation)
                            }
                        }
                        ScrollView(showsHorizontalIndicator: false) {
                            HStack {
                                ForEach(movie.genres ?? []) { genre in
                                    TextBadge(text: genre.name)
                                }
                            }
                        }
                            .frame(height: 30)
                    }
                    }
                    .padding(.leading)
                    .padding(.bottom, 5)
            }
            
            }.listRowInsets(EdgeInsets())
    }
}


struct MovieDetailImage : View {
    @State var imageLoader: ImageLoader
    @State var isImageLoaded = false
    @Binding var isExpanded: Bool
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(500/300, contentMode: .fit)
                    .opacity(isImageLoaded ? 1 : 0)
                    .animation(.basic())
                    .onAppear{
                        self.isImageLoaded = true
                }
            } else {
                Rectangle()
                    .aspectRatio(500/300, contentMode: .fit)
                    .foregroundColor(.gray)
                    .opacity(0.1)
            }
            }.onAppear {
                self.imageLoader.loadImage()
        }
    }
}


#if DEBUG
struct MovieBackdrop_Previews : PreviewProvider {
    static var previews: some View {
        MovieBackdrop(movieId: sampleMovie.id).environmentObject(sampleStore)
    }
}
#endif
