//
//  PeopleRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PeopleRow : ConnectedView {
    struct Props {
        let people: People
    }
    
    let peopleId: Int
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(people: state.peoplesState.peoples[peopleId]!)
    }
    
    func body(props: Props) -> some View {
        HStack {
            PeopleImage(imageLoader: ImageLoader(path: props.people.profile_path, size: .cast))
            VStack(alignment: .leading) {
                Text(props.people.name)
                    .font(.FjallaOne(size: 20))
                    .foregroundColor(.steam_gold)
                    .lineLimit(1)
                Text(props.people.knownForText ?? "")
                    .foregroundColor(.secondary)
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
