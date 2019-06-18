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
            NavigationButton(destination: MoviesCrewList(crew: cast)) {
                CastImage(imageLoader: ImageLoader(poster: cast.profile_path,
                                                   size: .cast))
                Text(cast.name).font(.body).color(.primary)
                Text(cast.character ?? cast.department ?? "")
                    .font(.subheadline)
                    .color(.secondary)
                }.frame(width: 100)
            }
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
                    .renderingMode(.original)
                    .cornerRadius(10)
                    .frame(width: 60, height: 90)
            } else {
                Rectangle()
                    .cornerRadius(10)
                    .frame(width: 60, height: 90)
                    .foregroundColor(.gray)
                    .opacity(0.1)
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
