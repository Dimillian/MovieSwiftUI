//
//  PeopleRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend

struct PeopleRow : ConnectedView {
    struct Props {
        let people: People
        let isInFanClub: Bool
    }
    
    let peopleId: Int
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(people: state.peoplesState.peoples[peopleId]!,
              isInFanClub: state.peoplesState.fanClub.contains(peopleId))
    }
    
    private var fanClubIcon: some View {
        Image(systemName: "star.circle")
            .imageScale(.large)
            .foregroundColor(.steam_gold)
            .transition(AnyTransition.scale
                .combined(with: .opacity))
            .animation(.interpolatingSpring(stiffness: 80, damping: 10))
    }
    
    func body(props: Props) -> some View {
        HStack {
            PeopleImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.people.profile_path, size: .cast))
            VStack(alignment: .leading) {
                HStack {
                    if props.isInFanClub {
                        fanClubIcon
                    }
                    Text(props.people.name)
                        .titleStyle()
                        .foregroundColor(.steam_gold)
                        .lineLimit(1)
                        .animation(.spring())
                }
                Text(props.people.knownForText ?? "")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .lineLimit(3)
                    .truncationMode(.tail)
                    .frame(height: 40)
            }
            .padding(.leading, 8)
        }.padding(.top)
        .padding(.bottom)
        .contextMenu{ PeopleContextMenu(people: peopleId) }
        .redacted(reason: peopleId == 0 ? .placeholder : [])
    }
}

#if DEBUG
struct PeopleRow_Previews : PreviewProvider {
    static var previews: some View {
        PeopleRow(peopleId: sampleCasts.first!.id).environmentObject(sampleStore)
    }
}
#endif
