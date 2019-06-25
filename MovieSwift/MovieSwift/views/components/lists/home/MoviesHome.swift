//
//  MoviesHome.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MoviesHome : View {
    enum Categories: Int {
        case popular, topRated, upcoming, nowPlaying
    }
    
    @State var selectedIndex: Categories = Categories.popular
    
    var body: some View {
        NavigationView {
            SegmentedControl(selection: $selectedIndex) {
                Text("Popular").tag(Categories.popular)
                Text("Top Rated").tag(Categories.topRated)
                Text("Upcoming").tag(Categories.upcoming)
                Text("Now Playing").tag(Categories.nowPlaying)
                }
                .navigationBarItems(trailing:
                    PresentationButton(destination: SettingsForm()) {
                        Image(systemName: "wrench")
                    }
                )
                .navigationBarHidden(false)
                .padding(.leading)
                .padding(.trailing)
            if selectedIndex == .popular {
                PopularList()
            } else if selectedIndex == .topRated {
                TopRatedList()
            } else if selectedIndex == .upcoming {
                UpcomingList()
            } else if selectedIndex == .nowPlaying {
                NowPlayingList()
            }
        }
    }
}

#if DEBUG
struct MoviesHome_Previews : PreviewProvider {
    static var previews: some View {
        MoviesHome()
    }
}
#endif
