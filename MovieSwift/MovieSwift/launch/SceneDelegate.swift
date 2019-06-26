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
        #if targetEnvironment(UIKitForMac)
        let windowScene = UIWindowScene(session: session, connectionOptions: connectionOptions)
        let window = UIWindow(windowScene: windowScene)
        #else
        let window = UIWindow(frame: UIScreen.main.bounds)
        #endif
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
            NSAttributedString.Key.font: UIFont(name: "FHA Condensed French NC", size: 40)!]
        
        window.rootViewController = UIHostingController(rootView: Tabbar().environmentObject(store))
        window.tintColor = UIColor(named: "steam_gold")
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        store.state.archiveState()
    }
}


let store = Store<AppState>(reducer: appStateReducer, state: AppState())

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
             castsState: CastsState()))
#endif


