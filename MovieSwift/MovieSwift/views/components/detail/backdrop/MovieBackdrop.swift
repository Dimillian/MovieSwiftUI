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
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MovieDetailImage(imageLoader: ImageLoader(poster: movie.backdrop_path,
                                                      size: .original),
                             isExpanded: $seeImage)
                .tapAction {
                    withAnimation{
                        self.seeImage.toggle()
                    }
            }
            if !seeImage {
                MovieBackdropInfo(movie: movie)
            }
        }.listRowInsets(EdgeInsets())
    }
}


#if DEBUG
struct MovieBackdrop_Previews : PreviewProvider {
    static var previews: some View {
        MovieBackdrop(movieId: sampleMovie.id).environmentObject(sampleStore)
    }
}
#endif
