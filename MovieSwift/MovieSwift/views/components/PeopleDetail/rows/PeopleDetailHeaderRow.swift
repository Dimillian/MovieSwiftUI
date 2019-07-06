//
//  PeopleDetailHeaderRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PeopleDetailHeaderRow : View {
    @EnvironmentObject private var store: Store<AppState>
    let peopleId: Int
    
    var people: People {
        store.state.peoplesState.peoples[peopleId]!
    }
    
    var body: some View {
        HStack(alignment: .top) {
            BigPeopleImage(imageLoader: ImageLoader(path: people.profile_path,
                                                    size: .original))
            VStack(alignment: .leading, spacing: 4) {
                Text("Known for:")
                    .font(.FjallaOne(size: 16))
                    .fontWeight(.bold)
                Text(people.knownForText ?? "For now nothing much... or missing data")
                    .color(.secondary)
                    .font(.body)
                    .lineLimit(nil)
            }
            .padding(.leading, 8)
                .padding(.top, 8)
        }
    }
}

#if DEBUG
struct PeopleDetailHeaderRow_Previews : PreviewProvider {
    static var previews: some View {
        PeopleDetailHeaderRow(peopleId: sampleCasts.first!.id).environmentObject(sampleStore)
    }
}
#endif
