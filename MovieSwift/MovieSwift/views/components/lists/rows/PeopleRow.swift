//
//  PeopleRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PeopleRow : View {
    @EnvironmentObject var store: Store<AppState>
    
    let peopleId: Int
    private var people: People! {
        return store.state.peoplesState.peoples[peopleId]
    }
    
    private var knownForText: String? {
        guard let knownFor = people.known_for else {
            return nil
        }
        let names = knownFor.filter{ $0.original_title != nil}.map{ $0.original_title! }
        return names.joined(separator: ", ")
    }
    
    var body: some View {
        HStack {
            PeopleImage(imageLoader: ImageLoader(poster: people.profile_path, size: .cast))
            VStack(alignment: .leading) {
                Text(people.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(knownForText ?? "")
                    .color(.secondary)
                    .font(.subheadline)
                    .lineLimit(3)
                    .truncationMode(.tail)
            }.padding(.leading, 8)
        }.padding(.top)
            .padding(.bottom)
    }
}

#if DEBUG
struct PeopleRow_Previews : PreviewProvider {
    static var previews: some View {
        PeopleRow(peopleId: sampleCasts.first!.id).environmentObject(sampleStore)
    }
}
#endif
