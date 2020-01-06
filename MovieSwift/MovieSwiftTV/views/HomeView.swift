//
//  ContentView.swift
//  MovieSwiftTV
//
//  Created by Thomas Ricouard on 06/01/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = MoviesMenu.popular
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MoviesMenu.allCases, id: \.self) { menu in
                MoviesView(menu: self.$selectedTab)
                    .tabItem{ Text(menu.title()) }
                    .tag(menu)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
