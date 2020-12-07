//
//  MovieInfoRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/12/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import UI

struct MovieInfoRow : View {
    let movie: Movie
    
    var asyncTextTransition: AnyTransition {
        return .scale
    }
    
    var asyncTextAnimation: Animation {
        Animation.spring()
            .speed(2)
            .delay(0.5)
    }
    
    private var infos: some View {
        HStack {
            Text(movie.release_date != nil ? movie.release_date!.prefix(4) : "")
                .font(.subheadline)
            if movie.runtime != nil {
                Text("• \(movie.runtime!) minutes")
                    .font(.subheadline)
                    .transition(asyncTextTransition)
                    .animation(asyncTextAnimation)
            }
            if movie.status != nil {
                Text("• \(movie.status!)")
                    .font(.subheadline)
                    .transition(asyncTextTransition)
                    .animation(asyncTextAnimation)
            }
        }.foregroundColor(.white)
    }
    
    private var productionCountry: some View {
        Group {
            if movie.production_countries?.isEmpty == false {
                Text("\(movie.production_countries!.first!.name)")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            infos
            productionCountry
        }
    }
}

#if DEBUG
struct MovieInfoRow_Previews : PreviewProvider {
    static var previews: some View {
        MovieInfoRow(movie: sampleMovie).background(Color.black).environmentObject(sampleStore)
    }
}
#endif
