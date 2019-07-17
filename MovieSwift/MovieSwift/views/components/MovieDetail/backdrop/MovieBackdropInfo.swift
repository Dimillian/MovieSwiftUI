//
//  MovieBackdropInfo.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieBackdropInfo : View {
    let movie: Movie
    
    var asyncTextTransition: AnyTransition {
        return .scale
    }
    
    var asyncTextAnimation: Animation {
        Animation.spring()
            .speed(2)
            .delay(0.5)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(movie.userTitle)
                    .font(.FjallaOne(size: 28))
                    .color(.steam_gold)
                    .lineLimit(nil)
                    .padding(.leading)
                    .padding(.trailing)
                HStack {
                    Text(movie.release_date != nil ? movie.release_date!.prefix(4) : "")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    if movie.runtime != nil {
                        Text("• \(movie.runtime!) minutes")
                            .font(.subheadline)
                            .color(.white)
                            .transition(asyncTextTransition)
                            .animation(asyncTextAnimation)
                    }
                    if movie.status != nil {
                        Text("• \(movie.status!)")
                            .font(.subheadline)
                            .color(.white)
                            .transition(asyncTextTransition)
                            .animation(asyncTextAnimation)
                    }
                }.padding(.leading)
                if movie.production_countries?.isEmpty == false {
                    Text("\(movie.production_countries!.first!.name)")
                        .font(.subheadline)
                        .color(.white)
                        .padding(.leading)
                        .padding(.bottom, 4)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(movie.genres ?? []) { genre in
                            GenreBadge(genre: genre)
                        }
                    }.padding(.leading)
                    }
            }
            }
            .listRowInsets(EdgeInsets())
            .padding(.bottom)
    }
}

#if DEBUG
struct MovieBackdropInfo_Previews : PreviewProvider {
    static var previews: some View {
        MovieBackdropInfo(movie: sampleMovie).environmentObject(sampleStore)
    }
}
#endif
