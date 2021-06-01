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
        let popular: [Int]
        let dispatch: DispatchFunction
    }
    
    @State private var currentPage = 1
    
    func map(state: AppState , dispatch: @escaping DispatchFunction) -> Props {
        Props(peoples: state.peoplesState.fanClub.map{ $0 }.sorted(),
              popular: state.peoplesState.popular
                .filter{ !state.peoplesState.fanClub.contains($0) }
                .sorted() { state.peoplesState.peoples[$0]!.name < state.peoplesState.peoples[$1]!.name },
              dispatch: dispatch)
    }
    
    func body(props: Props) -> some View {
        NavigationView {
            List {
                Section {
                    ForEach(props.peoples, id: \.self) { people in
                        NavigationLink(destination: PeopleDetail(peopleId: people)) {
                            PeopleRow(peopleId: people)
                        }
                    }.onDelete(perform: { index in
                        props.dispatch(PeopleActions.RemoveFromFanClub(people: props.peoples[index.first!]))
                    })
                }
            
                Section(header: Text("Popular people to add to your Fan Club")) {
                    ForEach(props.popular, id: \.self) { people in
                        NavigationLink(destination: PeopleDetail(peopleId: people)) {
                            PeopleRow(peopleId: people)
                        }
                    }
                }
                
                if !props.popular.isEmpty {
                    Rectangle()
                        .foregroundColor(.clear)
                        .onAppear {
                            self.currentPage += 1
                            props.dispatch(PeopleActions.FetchPopular(page: self.currentPage))
                    }
                }
            }
            .navigationBarTitle("Fan Club")
            .animation(.spring())
        }
        .onAppear {
            if self.currentPage == 1{
                props.dispatch(PeopleActions.FetchPopular(page: self.currentPage))
            }
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
