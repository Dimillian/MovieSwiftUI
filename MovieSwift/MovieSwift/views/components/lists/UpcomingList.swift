//
//  LatestList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct UpcomingList : View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        NavigationView {
             MoviesList(movies: state.moviesState.upcoming)
            .navigationBarTitle(Text("Upcoming"))
            }.onAppear {
                store.dispatch(action: MoviesActions.FetchUpcoming())
        }
    }
}

#if DEBUG
struct LatestList_Previews : PreviewProvider {
    static var previews: some View {
        UpcomingList().environmentObject(sampleStore)
    }
}
#endif
