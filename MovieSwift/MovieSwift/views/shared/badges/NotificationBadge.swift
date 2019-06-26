//
//  NotificationBadge.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 15/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct NotificationBadge: View {
    let text: String
    let color: Color
    @Binding var show: Bool

    var animation: Animation {
        Animation
            .spring(initialVelocity: 5)
            .speed(2)
            .delay(0.3)
    }

    var body: some View {
        if show {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                /// Calling a global `store` which should be refactored to local
                /// using `@EnvironmentObject var store: AppState` etc.
                store.dispatch(action: TaskActions.Notification(show: false, message: ""))
            }
        }

        return Text(text)
            .color(.white)
            .padding()
            .background(color)
            .cornerRadius(8)
            .scaleEffect(show ? 1 : 0.5)
            .opacity(show ? 1 : 0)
            .animation(animation)
    }
}

