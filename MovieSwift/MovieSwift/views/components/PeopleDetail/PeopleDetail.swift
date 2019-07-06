//
//  PeopleDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PeopleDetail : View {
    @EnvironmentObject private var store: Store<AppState>
    let peopleId: Int
    
    var people: People {
        store.state.peoplesState.peoples[peopleId]!
    }
    
    var body: some View {
        List {
            PeopleDetailHeaderRow(peopleId: peopleId)
            if people.biography != nil && people.biography?.isEmpty == false {
                PeopleDetailBiographyRow(biography: people.biography!)
            }
            if people.images != nil {
                PeopleDetailImagesRow(images: people.images!)
            }
        }
        .navigationBarTitle(people.name)
        .onAppear {
            self.store.dispatch(action: PeopleActions.FetchDetail(people: self.peopleId))
            self.store.dispatch(action: PeopleActions.FetchImages(people: self.peopleId))
            self.store.dispatch(action: PeopleActions.FetchPeopleCredits(people: self.peopleId))
        }
    }
}

#if DEBUG
struct PeopleDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            PeopleDetail(peopleId: sampleCasts.first!.id).environmentObject(sampleStore)
        }
    }
}
#endif
