//
//  Tabbar.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct HomeView: View {
    #if targetEnvironment(UIKitForMac)
    var body: some View {
        SplitView()
    }
    #else
    var body: some View {
        TabbarView()
    }
    #endif
}

struct TabbarView: View {
    @State var selectedTab = Tab.movies
    
    enum Tab: Int {
        case movies, discover, myLists
    }
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(image)
            Text(text)
        }
    }
    
    var body: some View {
        TabbedView(selection: $selectedTab) {
            MoviesHome().tabItemLabel(tabbarItem(text: "Movies", image: "icon-movies")).tag(Tab.movies)
            DiscoverView().tabItemLabel(tabbarItem(text: "Discover", image: "icon-discover")).tag(Tab.discover)
            MyLists().tabItemLabel(tabbarItem(text: "My lists", image: "icon-my-lists")).tag(Tab.myLists)
            }
            .edgesIgnoringSafeArea(.top)
    }
}

struct SplitView: View {
    enum Menu: Int {
        case popular, topRated, upcoming, nowPlaying, discover, wishlist, seenlist, myLists
    }
    
    @State var selectedMenu: Int = Menu.popular.rawValue
    
    var contentView: some View {
        let menu = Menu(rawValue: selectedMenu)!
        return Group {
            if menu == .popular {
                PopularList()
            } else if menu == .topRated {
                TopRatedList()
            } else if menu == .upcoming {
                UpcomingList()
            } else if menu == .nowPlaying {
                NowPlayingList()
            } else if menu == .discover {
                DiscoverView()
            } else if menu == .wishlist || menu == .seenlist || menu == .myLists {
                MyLists()
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            List {
                Section(header: Text("Movies")) {
                    Text("Popular").tapAction {
                        self.selectedMenu = Menu.popular.rawValue
                    }
                    Text("Top Rated").tapAction {
                        self.selectedMenu = Menu.topRated.rawValue
                    }
                    Text("Upcoming").tapAction {
                        self.selectedMenu = Menu.upcoming.rawValue
                    }
                    Text("Now playing").tapAction {
                        self.selectedMenu = Menu.nowPlaying.rawValue
                    }
                }
                Text("Discover").tapAction {
                    self.selectedMenu = Menu.discover.rawValue
                }
                Section(header: Text("Movies lists")) {
                    Text("Wishlist").tapAction {
                        self.selectedMenu = Menu.wishlist.rawValue
                    }
                    Text("Seenlist").tapAction {
                        self.selectedMenu = Menu.seenlist.rawValue
                    }
                    Text("My Lists").tapAction {
                        self.selectedMenu = Menu.myLists.rawValue
                    }
                }
                }
                .frame(width: 200)
            Spacer().frame(width: 1).foregroundColor(.secondary)
            NavigationView {
                contentView
            }
        }
    }
}

#if DEBUG
struct Tabbar_Previews : PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(sampleStore)
    }
}
#endif
