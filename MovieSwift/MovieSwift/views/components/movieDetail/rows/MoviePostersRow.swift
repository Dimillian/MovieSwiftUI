//
//  MoviePostersRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct MoviePostersRow : View {
    let posters: [ImageData]
    @Binding var selectedPoster: ImageData?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Other posters")
                .titleStyle()
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 32) {
                    ForEach(self.posters) { poster in
                        MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: poster.file_path,
                                                                                        size: .medium),
                                         posterSize: .medium)
                            .onTapGesture {
                                withAnimation {
                                    self.selectedPoster = poster
                                }
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.leading)
            }
        }
        .listRowInsets(EdgeInsets())
        .padding(.vertical)
    }
}

#if DEBUG
struct MoviePostersRow_Previews : PreviewProvider {
    static var previews: some View {
        MoviePostersRow(posters: [ImageData(aspect_ratio: 0.666666666666667,
                                             file_path: "/fpemzjF623QVTe98pCVlwwtFC5N.jpg",
                                             height: 720,
                                             width: 1280)],
                        selectedPoster: .constant(nil))
    }
}
#endif

