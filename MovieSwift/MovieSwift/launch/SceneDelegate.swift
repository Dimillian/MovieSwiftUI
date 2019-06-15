//
//  SceneDelegate.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: Tabbar().environmentObject(store))
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        store.archiveState()
    }
}

