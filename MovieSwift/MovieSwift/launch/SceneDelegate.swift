//
//  SceneDelegate.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftUIFlux

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            //TODO: Move that to SwiftUI once implemented
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
            
            let controller = UIHostingController(rootView: HomeView().environmentObject(store))
            window.rootViewController = controller
            window.tintColor = UIColor(named: "steam_gold")
            self.window = window
            window.makeKeyAndVisible()
        }
        }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        store.state.archiveState()
    }
}


let store = Store<AppState>(reducer: appStateReducer, state: AppState(), queue: .main)

#if DEBUG
let sampleCustomList = CustomList(id: 0,
                                  name: "TestName",
                                  cover: 0,
                                  movies: [0])
let sampleStore = Store<AppState>(reducer: appStateReducer,
                           state: AppState(moviesState:
                            MoviesState(movies: [0: sampleMovie],
                                      recommended: [0: [0]],
                                      similar: [0: [0]],
                                      popular: [0],
                                      topRated: [0],
                                      upcoming: [0],
                                      customLists: [0: sampleCustomList]),
                                           peoplesState: PeoplesState(peoples: [0: sampleCasts.first!, 1: sampleCasts[1]],
                                                                      peoplesMovies: [:],
                                                                      search: [:])),
                           queue: .main)
#endif


