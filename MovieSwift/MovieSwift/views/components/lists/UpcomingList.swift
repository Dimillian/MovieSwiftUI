//
//  LatestList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

final class UpcomingPageListener: PageListener {
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchUpcoming(page: currentPage))
    }
}


struct UpcomingList : View {
    @EnvironmentObject var state: AppState
    @State var pageListener = UpcomingPageListener()
    
    var body: some View {
        NavigationView {
            MoviesList(movies: state.moviesState.upcoming, displaySearch: true, pageListener: pageListener)
            .navigationBarTitle(Text("Upcoming"))
            }.onAppear {
                self.pageListener.loadPage()
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
