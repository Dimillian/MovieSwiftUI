//
//  MoviePostersRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MoviePostersRow : View {
    let posters: [MovieImage]
    @Binding var selectedPoster: MovieImage?
    
    func presentedPoster(poster: MovieImage) -> some View {
        ZStack(alignment: .center) {
            Text("hello")
        }
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Other poster")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            ScrollView(showsHorizontalIndicator: false) {
                HStack(spacing: 16) {
                    ForEach(self.posters) { poster in
                        MoviePosterImage(imageLoader: ImageLoader(poster: poster.file_path,
                                                                  size: .small)).tapAction {
                                                                    withAnimation {
                                                                        self.selectedPoster = poster
                                                                    }
                        }
                    }
                    }.padding(.leading)
            }
            }
            .listRowInsets(EdgeInsets())
            .padding(.top)
            .padding(.bottom)
    }
}

