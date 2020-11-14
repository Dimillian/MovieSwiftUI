//
//  MovieBackdropsRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct MovieBackdropsRow : View {
    let backdrops: [ImageData]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Images")
                .titleStyle()
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(self.backdrops) { backdrop in
                        MovieBackdropImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: backdrop.file_path,
                                                                                          size: .original))
                    }
                }.padding(.leading)
            }
        }
        .listRowInsets(EdgeInsets())
        .padding(.top)
        .padding(.bottom)
    }
}

#if DEBUG
struct MovieBackdropsRow_Previews : PreviewProvider {
    static var previews: some View {
        MovieBackdropsRow(backdrops: [ImageData(aspect_ratio: 1.7,
                                             file_path: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
                                             height: 1200,
                                             width: 1800)])
    }
}
#endif
