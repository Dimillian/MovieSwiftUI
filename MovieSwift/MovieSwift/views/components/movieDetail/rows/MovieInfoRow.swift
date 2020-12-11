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
        .opacity
    }
    
    var asyncTextAnimation: Animation {
        .easeInOut
    }
    
    private var infos: some View {
        HStack {
            if let date = movie.release_date {
                Text(date.prefix(4)).font(.subheadline)
            }
            if let runtime = movie.runtime {
                Text("• \(runtime) minutes")
                    .font(.subheadline)
                    .animation(asyncTextAnimation)
                    .transition(asyncTextTransition)
            }
            if let status = movie.status {
                Text("• \(status)")
                    .font(.subheadline)
                    .animation(asyncTextAnimation)
                    .transition(asyncTextTransition)
            }
        }
        .foregroundColor(.white)
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
