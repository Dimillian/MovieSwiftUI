//
//  Tabbar.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

// MARK:- Shared View
struct HomeView: View {
    #if targetEnvironment(macCatalyst)
    var body: some View {
        SplitView()
    }
    #else
    var body: some View {
        TabbarView()
    }
    #endif
}

// MARK: - iOS implementation
struct TabbarView: View {
    @State var selectedTab = Tab.movies
    
    enum Tab: Int {
        case movies, discover, myLists
    }
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    var body: some View {
        TabbedView(selection: $selectedTab) {
            MoviesHome().tabItem{
                self.tabbarItem(text: "Movies", image: "film")
            }.tag(Tab.movies)
            DiscoverView().tabItem{
                self.tabbarItem(text: "Discover", image: "square.stack")
            }.tag(Tab.discover)
            MyLists().tabItem{
                self.tabbarItem(text: "My Lists", image: "heart.circle")
            }.tag(Tab.myLists)
            }
            .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - MacOS implementation
struct SplitView: View {
    @State var selectedMenu: OutlineMenu = .popular
    
    var body: some View {
        HStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(OutlineMenu.allCases) { menu in
                        OutlineRow(item: menu, selectedMenu: self.$selectedMenu)
                            .frame(height: 50)
                    }
                }
                .padding(.top, 32)
                .offset(x: -30, y: 0)
                .frame(width: 250)
            }
            .frame(width: 250)
            .background(Color(.sRGB, white: 0.1, opacity: 1))
            selectedMenu.contentView
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
