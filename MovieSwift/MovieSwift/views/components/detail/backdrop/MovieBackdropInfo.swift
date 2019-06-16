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
                            GenreBadge(genre: genre)
                        }
                    }
                    }.frame(height: 30)
            }
            }
            .padding(.leading)
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
