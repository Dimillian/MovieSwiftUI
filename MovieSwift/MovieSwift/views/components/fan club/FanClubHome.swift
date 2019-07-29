//
//  FanClubHome.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 24/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct FanClubHome: ConnectedView {
    struct Props {
        let peoples: [Int]
    }
    
    func map(state: AppState , dispatch: @escaping DispatchFunction) -> Props {
        Props(peoples: state.peoplesState.fanClub.map{ $0 })
    }
    
    func body(props: Props) -> some View {
        NavigationView {
            List(props.peoples, id: \.self) { people in
                NavigationLink(destination: PeopleDetail(peopleId: people)) {
                    PeopleRow(peopleId: people)
                }
            }
            .navigationBarTitle("Fan Club")
        }
    }
}

#if DEBUG
struct FanClubHome_Previews: PreviewProvider {
    static var previews: some View {
        FanClubHome()
    }
}
#endif
