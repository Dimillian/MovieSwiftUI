//
//  NotificationBadge.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 15/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct NotificationBadge : View {
    let text: String
    let color: Color
    @Binding var show: Bool
    
    var animation: Animation {
        Animation
            .spring()
            .speed(2)
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .padding()
            .background(color)
            .cornerRadius(8)
            .scaleEffect(show ? 1: 0.5)
            .opacity(show ? 1 : 0)
            .animation(animation)
    }
}
