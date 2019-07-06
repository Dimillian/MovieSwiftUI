//
//  PeopleDetailImagesRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct PeopleDetailImagesRow : View {
    let images: [ImageData]
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Images:")
                .font(.FjallaOne(size: 16))
                .fontWeight(.bold)
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 16) {
                    ForEach(images) { image in
                        PeopleImage(imageLoader: ImageLoader(path: image.file_path, size: .cast))
                    }
                }
                .padding(.leading)
            }
        }
        .listRowInsets(EdgeInsets())
        .padding(.top)
        .padding(.bottom)
    }
}

#if DEBUG
struct PeopleDetailImagesRow_Previews : PreviewProvider {
    static var previews: some View {
        PeopleDetailImagesRow(images: sampleCasts.first!.images ?? [])
    }
}
#endif
