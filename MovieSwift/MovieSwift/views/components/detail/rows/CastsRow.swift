//
//  CastRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CastsRow : View {
    let title: String
    let casts: [Cast]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            ScrollView(showsHorizontalIndicator: false) {
                HStack {
                    ForEach(self.casts) { cast in
                        CastRowItem(cast: cast)
                    }
                }.padding(.leading)
            }
        }.listRowInsets(EdgeInsets())
            .padding(.top)
            .padding(.bottom)
    }
}

struct CastRowItem: View {
    let cast: Cast
    
    var body: some View {
        VStack(alignment: .center) {
            CastImage(imageLoader: ImageLoader(poster: cast.profile_path,
                                               size: .cast))
            Text(cast.name).font(.body)
            Text(cast.character ?? cast.department ?? "")
                .font(.subheadline)
                .color(.secondary)
            }.frame(width: 100)
    }
}

struct CastImage : View {
    @State var imageLoader: ImageLoader
    
    let size: Length = 60
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Rectangle()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }
            }.onAppear {
                self.imageLoader.loadImage()
        }
    }
}

#if DEBUG
struct CastsRow_Previews : PreviewProvider {
    static var previews: some View {
        CastsRow(title: "Sample", casts: sampleCasts)
    }
}
#endif
