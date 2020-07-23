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

let store = Store<AppState>(reducer: appStateReducer,
                            middleware: [loggingMiddleware],
                            state: AppState())

@main
struct HomeView: App {
    let archiveTimer: Timer
    
    init() {
        archiveTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { _ in
            store.state.archiveState()
        })
        setupApperance()
    }
    
    #if targetEnvironment(macCatalyst)
    var body: some Scene {
        WindowGroup {
            StoreProvider(store: store) {
                SplitView().accentColor(.steam_gold)
            }
        }
    }
    #else
    var body: some Scene {
        WindowGroup {
            StoreProvider(store: store) {
                TabbarView().accentColor(.steam_gold)
            }
        }
    }
    #endif
    
    private func setupApperance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
            NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 40)!]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
            NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 18)!]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
                                                                NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
                                                                NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 16)!],
                                                            for: .normal)
        
        UIWindow.appearance().tintColor = UIColor(named: "steam_gold")
    }
}

// MARK: - iOS implementation
struct TabbarView: View {
    @State var selectedTab = Tab.movies
    
    enum Tab: Int {
        case movies, discover, fanClub, myLists
    }
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MoviesHome().tabItem{
                self.tabbarItem(text: "Movies", image: "film")
            }.tag(Tab.movies)
            DiscoverView().tabItem{
                self.tabbarItem(text: "Discover", image: "square.stack")
            }.tag(Tab.discover)
            FanClubHome().tabItem{
                self.tabbarItem(text: "Fan Club", image: "star.circle.fill")
            }.tag(Tab.fanClub)
            MyLists().tabItem{
                self.tabbarItem(text: "My Lists", image: "heart.circle")
            }.tag(Tab.myLists)
        }
    }
}

// MARK: - MacOS implementation
struct SplitView: View {
    @State var selectedMenu: OutlineMenu = .popular
    
    @ViewBuilder
    var body: some View {
        HStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(OutlineMenu.allCases) { menu in
                        ZStack(alignment: .leading) {
                            OutlineRow(item: menu, selectedMenu: self.$selectedMenu)
                                .frame(height: 50)
                            if menu == self.selectedMenu {
                                Rectangle()
                                    .foregroundColor(Color.secondary.opacity(0.1))
                                    .frame(height: 50)
                            }
                        }
                    }
                }
                .padding(.top, 32)
                .frame(width: 300)
            }
            .background(Color.primary.opacity(0.1))
            selectedMenu.contentView
        }
    }
}

#if DEBUG
let sampleCustomList = CustomList(id: 0,
                                  name: "TestName",
                                  cover: 0,
                                  movies: [0])
let sampleStore = Store<AppState>(reducer: appStateReducer,
                                  state: AppState(moviesState:
                                                    MoviesState(movies: [0: sampleMovie],
                                                                moviesList: [MoviesMenu.popular: [0]],
                                                                recommended: [0: [0]],
                                                                similar: [0: [0]],
                                                                customLists: [0: sampleCustomList]),
                                                  peoplesState: PeoplesState(peoples: [0: sampleCasts.first!, 1: sampleCasts[1]],
                                                                             peoplesMovies: [:],
                                                                             search: [:])))
#endif
